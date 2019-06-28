/* Copyright 2016 The Chromium OS Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

/*
 * This is a driver for the I2C Master controller (i2cm) of the g chip.
 *
 * The g chip i2cm module supports 3 modes of operation, disabled, bit-banging,
 * and instruction based. These modes are selected via the I2C_CTRL
 * register. Selecting disabled mode can be used as a soft reset where the i2cm
 * hw state machine is reset, but the register values remain unchanged. In
 * bit-banging mode the signals SDA/SCL are controlled by the lower two bits of
 * the INST register. I2C_INST[1:0] = SCL|SDA. In this mode the value of SDA is
 * read every clock cycle.
 *
 * The main operation mode is instruction mode. A 32 bit instruction register
 * (I2C_INST) is used to describe a sequence of operations. The I2C transaction
 * is initiated when this register is written. The I2C module contains a status
 * register which in real-time tracks the progress of the I2C sequence that was
 * configured in the INST register. If enabled, an interrupt is generated when
 * the transaction is completed. If not using interrupts then bit 24 (INTB) of
 * the status register can be polled for 0. INTB is the inverse of the i2cm
 * interrupt status.
 *
 * The i2cm module provides a 64 byte fifo (RWBYTES) for both write and read
 * transactions. In addition there is a 4 byte fifo (FWBYTES) that can be used
 * for writes, for the register write of portion of a read transaction. By
 * default the pointer to RWBYTES fifo resets back 0 following each
 * transaction.
 *
 * As mentioned, i2c transactions are configured via the I2C_INST register.
 * A 2 byte register write would create the following bitmap to define the
 * compound instruction for the transaction:
 *
 * I2C_INST_START = 1         -> send start bit
 * I2C_INST_FWDEVADDR = 1     -> first send the slave device address
 * I2C_INST_FWBYTESCOUNT = 3  -> 3 bytes in FWBYTES (register + 16 bit value)
 * I2C_INST_FINALSTOP = 1     -> send stop bit
 * I2C_INST_DEVADDRVAL = slave address
 *
 * I2C_FWBYTES[b7:b0]   = out[0]  -> register address
 * I2C_FWBYTES[b15:b8]  = out[1]  -> first byte of value
 * I2C_FWBYTES[b23:b16] = out[2]  -> 2nd byte of value
 *
 * A 2 byte register read would create the following bitmap to define the
 * compound instruction for the transaction:
 *
 * I2C_INST_START = 1         -> send start bit
 * I2C_INST_FWDEVADDR = 1     -> first send the slave device address
 * I2C_INST_FWBYTESCOUNT = 1  -> 1 byte in FWBYTES (register address)
 * I2C_INST_REPEATEDSTART = 1 -> send start bit following write
 * I2C_INST_RWDEVADDR = 1     -> send slave address in read mode
 * I2C_INST_RWDEVADDR_RWB = 1 -> read bytes following slave address
 * I2C_INST_FINALNA = 1       -> ACK read bytes, NACK last byte read
 * I2C_INST_FINALSTOP = 1     -> send stop bit
 * I2C_INST_DEVADDRVAL = slave address
 * I2C_FWBYTES[b7:b0] = out[0] -> register address byte
 *
 * Once transaction is complete:
 * in[0] = I2C_RW0[b7:b0]     -> copy first byte of read into destination
 * in[1] = I2C_RW0[b15:b8]    -> copy 2nd byte of read into destination
 *
 * Once the register I2C_INST is written with the instruction words constructed
 * as shown, the transaction on the bus will commence. When I2C_INST is written,
 * I2C_STATUS[b23:b0] is updated to reflect the transaction
 * details and I2C_STATUS[b24] is set to 1. The transaction is complete when
 * I2C_STATUS[b24] is 0. If interrupts are enabled, then an interrupt would be
 * generated at this same point. The values of I2C_STATUS[b23:b0] are updated as
 * the transaction progresses. Upon a completion of a successful transaction
 * I2C_STATUS will be 0. If there was an error, the error details are contained
 * in the upper bits of of I2C_STATUS, specifically [b31:b25].
 */

#include "common.h"
#include "console.h"
#include "gpio.h"
#include "hooks.h"
#include "i2c.h"
#include "pmu.h"
#include "registers.h"
#include "system.h"
#include "timer.h"

#define CPRINTS(format, args...) cprints(CC_I2C, format, ## args)

/*
 * Limits for polling I2C transaction. The time limit of 25 msec is a
 * conservative value for the worst case (68 byte transfer) at 100 kHz clock
 * speed.
 */
#define I2CM_POLL_WAIT_US 25
#define I2CM_MAX_POLL_ITERATIONS (25000 / I2CM_POLL_WAIT_US)

/* Sizes for first write (FW) and read/write (RW) fifos */
#define I2CM_FW_BYTES_MAX 4
#define I2CM_RW_BYTES_MAX 64

/* Macros to set bits/fields of the INST word for sequences*/
#define INST_START GFIELD_MASK(I2C, INST, START)
#define INST_STOP GFIELD_MASK(I2C, INST, FINALSTOP)
#define INST_RPT_START GFIELD_MASK(I2C, INST, REPEATEDSTART)
#define INST_FWDEVADDR GFIELD_MASK(I2C, INST, FWDEVADDR)
#define INST_DEVADDRVAL(addr) (addr << GFIELD_LSB(I2C, INST, \
						  DEVADDRVAL))
#define INST_RWDEVADDR GFIELD_MASK(I2C, INST, RWDEVADDR)
#define INST_RWDEVADDR_RWB GFIELD_MASK(I2C, INST, RWDEVADDR_RWB)
#define INST_NA GFIELD_MASK(I2C, INST, FINALNA)
#define INST_RWBYTES(size) (size << GFIELD_LSB(I2C, INST, \
					       RWBYTESCOUNT))

/* Mask for b31:INTB of STATUS register */
#define I2CM_ERROR_MASK (~((1 << GFIELD_LSB(I2C, STATUS, INTB)) - 1))

enum i2cm_control_mode {
	i2c_mode_disabled = 0,
	i2c_mode_bit_bang = 1,
	i2c_mode_instruction = 2,
	i2c_mode_reserved = 3,
};

#define I2C_NUM_PHASESTEPS 4
struct i2c_xfer_mode {
	uint8_t clk_div;
	uint8_t phase_steps[I2C_NUM_PHASESTEPS];
};

/*
 * TODO (crosbug.com/p/58355): For 100 and 400 kHz speed, phasestep0 has been
 * adjusted longer that what should be required due to slow rise times on both
 * Reef and Gru boards. In addition, the suggested values from the H1 chip spec
 * were based off a 26 MHz clock. Have an ask to get suggested values for the
 * actual 24 MHz bus speed.
 */
const struct i2c_xfer_mode i2c_timing[I2C_FREQ_COUNT] = {
	/* 1000 kHz */
	{
		.clk_div = 1,
		.phase_steps = {5, 5, 5, 11},
	},
	/* 400 kHz */
	{
		.clk_div = 1,
		.phase_steps = {15, 12, 12, 21},
	},
	/* 100 kHz */
	{
		.clk_div = 10,
		.phase_steps = {9, 6, 5, 4},
	},
};

static void i2cm_config_xfer_mode(int port, enum i2c_freq freq)
{
	/* Set the control mode to disabled (soft reset) */
	GWRITE_I(I2C, port, CTRL_MODE, i2c_mode_disabled);

	/* Set the phasesteps register for the requested bus frequency */
	GWRITE_FIELD_I(I2C, port, CTRL_PHASESTEPS, P0,
		       i2c_timing[freq].phase_steps[0]);
	GWRITE_FIELD_I(I2C, port, CTRL_PHASESTEPS, P1,
		       i2c_timing[freq].phase_steps[1]);
	GWRITE_FIELD_I(I2C, port, CTRL_PHASESTEPS, P2,
		       i2c_timing[freq].phase_steps[2]);
	GWRITE_FIELD_I(I2C, port, CTRL_PHASESTEPS, P3,
		       i2c_timing[freq].phase_steps[3]);

	/* Set the clock divide control register */
	GWRITE_I(I2C, port, CTRL_CLKDIV, i2c_timing[freq].clk_div);
	/* Ensure that INST register is reset */
	GWRITE_I(I2C, port, INST, 0);
	/* Set the control mode register to instruction */
	GWRITE_I(I2C, port, CTRL_MODE, i2c_mode_instruction);
}

static void i2cm_set_fwbytes(int port, uint32_t *inst, const uint8_t *data,
			     int size)
{
	int i;
	uint32_t fwbytes = 0;

	/* Indicate that first write bytes field will be used */
	*inst |= size << GFIELD_LSB(I2C, INST, FWBYTESCOUNT);

	/* Now write data to FWBYTES register */
	for (i = 0; i < size; i++)
		fwbytes |= data[i] << (i * 8);
	GWRITE_I(I2C, port, FW, fwbytes);
}

static void i2cm_write_rwbytes(int port, const uint8_t *out, int size)
{
	volatile uint32_t *rw_ptr;
	int rw_count;
	int i;

	/* Calculate number of RW register writes required */
	rw_count = (size + 3) >> 2;
	/* Get pointer to RW0 register (start of fifo) */
	rw_ptr = GREG32_ADDR_I(I2C, port, RW0);

	/*
	 * Get write data from source buffer one byte at a time and write up to
	 * 4 bytes at a time in to the RW fifo.
	 */
	for (i = 0; i < rw_count; i++) {
		int byte_count;
		int j;
		uint32_t rw_data = 0;

		byte_count = MIN(4, size);
		for (j = 0; j < byte_count; j++)
			rw_data |= *out++ << (j * 8);
		size -= byte_count;
		*rw_ptr++ = rw_data;
	}
}

static void i2cm_read_rwbytes(int port, uint8_t *in, int size)
{
	int rw_count;
	int i;
	volatile uint32_t *rw_ptr;

	/* Calculate number of RW register writes required */
	rw_count = (size + 3) >> 2;
	/* Get pointer to RW0 register (start of fifo) */
	rw_ptr = GREG32_ADDR_I(I2C, port, RW0);

	/*
	 * Read data from fifo up to 4 bytes at a time and copy into
	 * destination buffer 1 byte at a time.
	 */
	for (i = 0; i < rw_count; i++) {
		int byte_count;
		int j;
		uint32_t rw_data;

		rw_data = *rw_ptr++;
		byte_count = MIN(4, size);
		for (j = 0; j < byte_count; j++) {
			*in++ = rw_data;
			rw_data >>= 8;
		}
		size -= byte_count;
	}
}

static int i2cm_poll_for_complete(int port)
{
	int poll_count = 0;

	while (poll_count < I2CM_MAX_POLL_ITERATIONS) {
		/* Check if the sequence is complete */
		if (!GREAD_FIELD_I(I2C, port, STATUS, INTB))
			return EC_SUCCESS;
		/* Not done yet, sleep */
		usleep(I2CM_POLL_WAIT_US);
		poll_count++;
	};

	return EC_ERROR_TIMEOUT;
}

static uint32_t i2cm_build_sequence(int port, int slave_addr,
			       const uint8_t *out,  int out_size,
			       uint8_t *in, int in_size, int flags)
{
	int bytes_consumed;
	uint32_t inst = 0;

	if (flags & I2C_XFER_START)
		inst |= INST_START;

	/*
	 *  Setup slave device address. Calls to chip_i2c_xfer assume an 8 bit
	 *  slave address. Need to shift right by 1 bit.
	 */
	inst |= INST_DEVADDRVAL(slave_addr >> 1);

	if (out_size) {
		/* Send slave addr byte if this is start of I2C transaction */
		if (flags & I2C_XFER_START)
			inst |= INST_FWDEVADDR;
		bytes_consumed = MIN(I2CM_FW_BYTES_MAX, out_size);
		/* Setup first write bytes */
		i2cm_set_fwbytes(port, &inst, out, bytes_consumed);
		out_size -= bytes_consumed;
		/* If write data remains, then put the rest in RW fifo */
		if (out_size) {
			out += bytes_consumed;
			inst |= INST_RWBYTES(out_size);
			i2cm_write_rwbytes(port, out, out_size);
		}
	}

	if (in_size) {
		/*
		 * If I2C_XFER_START is marked, then send slave address and
		 * indicate it's a read transaction.
		 */
		if (flags & I2C_XFER_START) {
			inst |= INST_RWDEVADDR;
			inst |= INST_RWDEVADDR_RWB;
			inst |= INST_RPT_START;
		}
		/* Setup number of bytes to read */
		inst |= INST_RWBYTES(in_size);

		/* NACK the last byte read */
		if (flags & I2C_XFER_STOP)
			inst |= INST_NA;
	}

	if (flags & I2C_XFER_STOP)
		inst |= INST_STOP;

	return inst;
}

static int i2cm_execute_sequence(int port, int slave_addr, const uint8_t *out,
				 int out_size, uint8_t *in, int in_size,
				 int flags)
{
	int rv;
	uint32_t inst;

	/* Build sequence instruction */
	inst = i2cm_build_sequence(port, slave_addr, out, out_size, in,
				   in_size, flags);
	/* Start transaction */
	GWRITE_I(I2C, port, INST, inst);

	/* Wait for transaction to be complete */
	rv = i2cm_poll_for_complete(port);
	/* Handle timeout case */
	if (rv)
		return rv;

	/* Check status value for errors */
	if (GREAD_I(I2C, port, STATUS) & I2CM_ERROR_MASK) {
		/* If failed, then clear INST register */
		GWRITE_I(I2C, port, INST, 0);
		return EC_ERROR_UNKNOWN;
	}

	return EC_SUCCESS;
}


/* Perform an i2c transaction. */
int chip_i2c_xfer(int port, int slave_addr, const uint8_t *out, int out_size,
		  uint8_t *in, int in_size, int flags)
{
	int rv;
	int sequence_flags;
	int num_out, num_in;

	if (!in_size && !out_size)
		/* Nothing to do */
		return EC_SUCCESS;

	/*
	 * Cr50 can do sequences of up to 64 write or read bytes. In addition it
	 * can accommodate up to 4 write bytes and up to 64 read bytes in a
	 * sequence set up. However, if the number of write bytes is > 4, then
	 * the write and read must be done in separate sequences.
	 */

	while (out_size > I2CM_FW_BYTES_MAX) {
		/* number of bytes that can handed in 1 sequence */
		num_out = MIN(I2CM_RW_BYTES_MAX + I2CM_FW_BYTES_MAX, out_size);
		sequence_flags = flags;
		/* If more than 1 sequence remaining, mask stop bit flag */
		if ((out_size - num_out)  || in_size)
			sequence_flags &= ~I2C_XFER_STOP;
		/* Execute transaction */
		rv = i2cm_execute_sequence(port, slave_addr, out, num_out, in,
					   0, sequence_flags);
		if (rv)
			return rv;
		/* Update counts and flags */
		out += num_out;
		out_size -= num_out;
		flags &= ~sequence_flags;
	}

	/* At this point out_size <= 4 */
	while (out_size || in_size) {
		num_in = MIN(I2CM_RW_BYTES_MAX, in_size);
		num_out = out_size;
		sequence_flags = flags;
		/* If more than 1 sequence remaining, mask stop bit flag */
		if (in_size - num_in)
			sequence_flags &= ~I2C_XFER_STOP;

		rv = i2cm_execute_sequence(port, slave_addr, out, num_out, in,
					   num_in, sequence_flags);
		if (rv)
			return rv;

		/* If bytes were read, copy to destination buffer */
		if (num_in) {
			i2cm_read_rwbytes(port, in, num_in);
			in += num_in;
			in_size -= num_in;
		}
		out_size = 0;
		flags &= ~sequence_flags;
	}

	return EC_SUCCESS;
}

int i2c_raw_get_scl(int port)
{
	enum gpio_signal pin;

	if (get_scl_from_i2c_port(port, &pin) == EC_SUCCESS)
		return gpio_get_level(pin);

	/* If no SCL pin defined for this port, then return 1 to appear idle. */
	return 1;
}

int i2c_raw_get_sda(int port)
{
	enum gpio_signal pin;

	if (get_sda_from_i2c_port(port, &pin) == EC_SUCCESS)
		return gpio_get_level(pin);

	/* If no SDA pin defined for this port, then return 1 to appear idle. */
	return 1;
}

int i2c_get_line_levels(int port)
{
	return (i2c_raw_get_sda(port) ? I2C_LINE_SDA_HIGH : 0) |
		(i2c_raw_get_scl(port) ? I2C_LINE_SCL_HIGH : 0);

}

static void i2cm_init_port(const struct i2c_port_t *p)
{
	enum i2c_freq freq;

	/* Enable clock for I2C Master */
	pmu_clock_en(p->port ? PERIPH_I2C1 : PERIPH_I2C0);

	/* Set operation speed. */
	switch (p->kbps) {
	case 1000: /* Fast-mode Plus */
		freq = I2C_FREQ_1000KHZ;
		break;
	case 400: /* Fast-mode */
		freq = I2C_FREQ_400KHZ;
		break;
	case 100: /* Standard-mode */
		freq = I2C_FREQ_100KHZ;
		break;
	default: /* unknown speed, default to 100kBps */
		CPRINTS("I2C bad speed %d kBps.  Defaulting to 100kbps.",
			p->kbps);
		freq = I2C_FREQ_100KHZ;
	}

	/* Configure the transfer clocks and mode */
	i2cm_config_xfer_mode(p->port, freq);

	CPRINTS("Initalized I2C port %d, freq = %d kHz", p->port, p->kbps);
}

/**
 * Initialize the i2c module for all supported ports.
 */
void i2cm_init(void)
{
	const struct i2c_port_t *p = i2c_ports;
	int i;

	for (i = 0; i < i2c_ports_used; i++, p++)
		i2cm_init_port(p);

}
