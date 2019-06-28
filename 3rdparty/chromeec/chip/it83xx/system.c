/* Copyright (c) 2013 The Chromium OS Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

/* System module for Chrome EC : hardware specific implementation */

#include "console.h"
#include "cpu.h"
#include "ec2i_chip.h"
#include "flash.h"
#include "host_command.h"
#include "intc.h"
#include "registers.h"
#include "system.h"
#include "task.h"
#include "util.h"
#include "version.h"
#include "watchdog.h"

void system_hibernate(uint32_t seconds, uint32_t microseconds)
{
#ifdef CONFIG_HOSTCMD_PD
	/* Inform the PD MCU that we are going to hibernate. */
	host_command_pd_request_hibernate();
	/* Wait to ensure exchange with PD before hibernating. */
	msleep(100);
#endif

	/* Flush console before hibernating */
	cflush();

	if (board_hibernate)
		board_hibernate();

	/* chip specific standby mode */
	__enter_hibernate(seconds, microseconds);
}

static void check_reset_cause(void)
{
	uint32_t flags = 0;
	uint8_t raw_reset_cause = IT83XX_GCTRL_RSTS & 0x03;
	uint8_t raw_reset_cause2 = IT83XX_GCTRL_SPCTRL4 & 0x07;

	/* Clear reset cause. */
	IT83XX_GCTRL_RSTS |= 0x03;
	IT83XX_GCTRL_SPCTRL4 |= 0x07;

	/* Determine if watchdog reset or power on reset. */
	if (raw_reset_cause & 0x02) {
		flags |= RESET_FLAG_WATCHDOG;
	} else if (raw_reset_cause & 0x01) {
		flags |= RESET_FLAG_POWER_ON;
	} else {
		if ((IT83XX_GCTRL_RSTS & 0xC0) == 0x80)
			flags |= RESET_FLAG_POWER_ON;
	}

	if (raw_reset_cause2 & 0x04)
		flags |= RESET_FLAG_RESET_PIN;

	/* Restore then clear saved reset flags. */
	if (!(flags & RESET_FLAG_POWER_ON)) {
		flags |= BRAM_RESET_FLAGS << 24;
		flags |= BRAM_RESET_FLAGS1 << 16;
		flags |= BRAM_RESET_FLAGS2 << 8;
		flags |= BRAM_RESET_FLAGS3;

		/* watchdog module triggers these reset */
		if (flags & (RESET_FLAG_HARD | RESET_FLAG_SOFT))
			flags &= ~RESET_FLAG_WATCHDOG;
	}

	BRAM_RESET_FLAGS = 0;
	BRAM_RESET_FLAGS1 = 0;
	BRAM_RESET_FLAGS2 = 0;
	BRAM_RESET_FLAGS3 = 0;

	system_set_reset_flags(flags);
}

int system_is_reboot_warm(void)
{
	uint32_t reset_flags;
	/*
	 * Check reset cause here,
	 * gpio_pre_init is executed faster than system_pre_init
	 */
	check_reset_cause();
	reset_flags = system_get_reset_flags();

	if ((reset_flags & RESET_FLAG_RESET_PIN) ||
	    (reset_flags & RESET_FLAG_POWER_ON) ||
	    (reset_flags & RESET_FLAG_WATCHDOG) ||
	    (reset_flags & RESET_FLAG_HARD) ||
	    (reset_flags & RESET_FLAG_SOFT) ||
	    (reset_flags & RESET_FLAG_HIBERNATE))
		return 0;
	else
		return 1;
}

void chip_pre_init(void)
{
	/* bit4, enable debug mode through SMBus */
	IT83XX_SMB_SLVISELR &= ~(1 << 4);
}

void system_pre_init(void)
{
	/* No initialization required */

}

void system_reset(int flags)
{
	uint32_t save_flags = 0;

	/* Disable interrupts to avoid task swaps during reboot. */
	interrupt_disable();

	/* Handle saving common reset flags. */
	system_encode_save_flags(flags, &save_flags);

	if (clock_ec_wake_from_sleep())
		save_flags |= RESET_FLAG_HIBERNATE;

	/* Store flags to battery backed RAM. */
	BRAM_RESET_FLAGS = save_flags >> 24;
	BRAM_RESET_FLAGS1 = (save_flags >> 16) & 0xff;
	BRAM_RESET_FLAGS2 = (save_flags >> 8) & 0xff;
	BRAM_RESET_FLAGS3 = save_flags & 0xff;

	/* If WAIT_EXT is set, then allow 10 seconds for external reset */
	if (flags & SYSTEM_RESET_WAIT_EXT) {
		int i;

		/* Wait 10 seconds for external reset */
		for (i = 0; i < 1000; i++) {
			watchdog_reload();
			udelay(10000);
		}
	}

	/*
	 * bit4, disable debug mode through SMBus.
	 * If we are in debug mode, we need disable it before triggering
	 * a soft reset or reset will fail.
	 */
	IT83XX_SMB_SLVISELR |= (1 << 4);

	/*
	 * Writing invalid key to watchdog module triggers a soft reset. For
	 * now this is the only option, no hard reset.
	 */
	IT83XX_ETWD_ETWCFG |= 0x20;
	IT83XX_ETWD_EWDKEYR = 0x00;

	/* Spin and wait for reboot; should never return */
	while (1)
		;
}

int system_set_scratchpad(uint32_t value)
{
	BRAM_SCRATCHPAD3 = (value >> 24) & 0xff;
	BRAM_SCRATCHPAD2 = (value >> 16) & 0xff;
	BRAM_SCRATCHPAD1 = (value >> 8) & 0xff;
	BRAM_SCRATCHPAD = value & 0xff;

	return EC_SUCCESS;
}

uint32_t system_get_scratchpad(void)
{
	uint32_t value = 0;

	value |= BRAM_SCRATCHPAD3 << 24;
	value |= BRAM_SCRATCHPAD2 << 16;
	value |= BRAM_SCRATCHPAD1 << 8;
	value |= BRAM_SCRATCHPAD;

	return value;
}

static uint16_t system_get_chip_id(void)
{
	return (IT83XX_GCTRL_CHIPID1 << 8) | IT83XX_GCTRL_CHIPID2;
}

static uint8_t system_get_chip_version(void)
{
	/* bit[3-0], chip version */
	return IT83XX_GCTRL_CHIPVER & 0x0F;
}

static char to_hex(int x)
{
	if (x >= 0 && x <= 9)
		return '0' + x;
	return 'a' + x - 10;
}

const char *system_get_chip_vendor(void)
{
	return "ite";
}

const char *system_get_chip_name(void)
{
	static char buf[7];
	uint16_t chip_id = system_get_chip_id();

	buf[0] = 'i';
	buf[1] = 't';
	buf[2] = to_hex((chip_id >> 12) & 0xf);
	buf[3] = to_hex((chip_id >> 8) & 0xf);
	buf[4] = to_hex((chip_id >> 4) & 0xf);
	buf[5] = to_hex(chip_id & 0xf);
	buf[6] = '\0';
	return buf;
}

const char *system_get_chip_revision(void)
{
	static char buf[3];
	uint8_t rev = system_get_chip_version();

	buf[0] = to_hex(rev + 0xa);
	buf[1] = 'x';
	buf[2] = '\0';
	return buf;
}

static int bram_idx_lookup(enum system_bbram_idx idx)
{
	if (idx >= SYSTEM_BBRAM_IDX_VBNVBLOCK0 &&
	    idx <= SYSTEM_BBRAM_IDX_VBNVBLOCK15)
		return BRAM_IDX_NVCONTEXT +
		       idx - SYSTEM_BBRAM_IDX_VBNVBLOCK0;
#ifdef CONFIG_USB_PD_DUAL_ROLE
	if (idx == SYSTEM_BBRAM_IDX_PD0)
		return BRAM_IDX_PD0;
	if (idx == SYSTEM_BBRAM_IDX_PD1)
		return BRAM_IDX_PD1;
#endif
	return -1;
}

int system_get_bbram(enum system_bbram_idx idx, uint8_t *value)
{
	int bram_idx = bram_idx_lookup(idx);

	if (bram_idx < 0)
		return EC_ERROR_INVAL;

	*value = IT83XX_BRAM_BANK0(bram_idx);
	return EC_SUCCESS;
}

int system_set_bbram(enum system_bbram_idx idx, uint8_t value)
{
	int bram_idx = bram_idx_lookup(idx);

	if (bram_idx < 0)
		return EC_ERROR_INVAL;

	IT83XX_BRAM_BANK0(bram_idx) = value;
	return EC_SUCCESS;
}

#define BRAM_NVCONTEXT_SIZE (BRAM_IDX_NVCONTEXT_END - BRAM_IDX_NVCONTEXT + 1)
BUILD_ASSERT(EC_VBNV_BLOCK_SIZE <= BRAM_NVCONTEXT_SIZE);

uintptr_t system_get_fw_reset_vector(uintptr_t base)
{
	uintptr_t reset_vector, num;

	num = *(uintptr_t *)base;
	reset_vector = ((num>>24)&0xff) | ((num<<8)&0xff0000) |
			((num>>8)&0xff00) | ((num<<24)&0xff000000);
	reset_vector = ((reset_vector & 0xffffff) << 1) + base;

	return reset_vector;
}
