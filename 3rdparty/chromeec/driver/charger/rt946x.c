/* Copyright 2017 The Chromium OS Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 *
 * Richtek rt946x battery charger driver.
 */

#include "battery.h"
#include "battery_smart.h"
#include "charger.h"
#include "charge_manager.h"
#include "common.h"
#include "compile_time_macros.h"
#include "config.h"
#include "console.h"
#include "hooks.h"
#include "i2c.h"
#include "printf.h"
#include "rt946x.h"
#include "task.h"
#include "timer.h"
#include "usb_charge.h"
#include "util.h"

/* Console output macros */
#define CPRINTF(format, args...) cprintf(CC_CHARGER, format, ## args)

/* Charger parameters */
static const struct charger_info rt946x_charger_info = {
	.name         = CHARGER_NAME,
	.voltage_max  = CHARGE_V_MAX,
	.voltage_min  = CHARGE_V_MIN,
	.voltage_step = CHARGE_V_STEP,
	.current_max  = CHARGE_I_MAX,
	.current_min  = CHARGE_I_MIN,
	.current_step = CHARGE_I_STEP,
	.input_current_max  = INPUT_I_MAX,
	.input_current_min  = INPUT_I_MIN,
	.input_current_step = INPUT_I_STEP,
};

struct charger_init_setting {
	uint16_t eoc_current;
	uint16_t mivr;
	uint16_t ircmp_vclamp;
	uint16_t ircmp_res;
	uint16_t boost_voltage;
	uint16_t boost_current;
};

static const struct charger_init_setting rt946x_charger_init_setting = {
	.eoc_current = 400,
	.mivr = 4000,
	.ircmp_vclamp = 32,
	.ircmp_res = 25,
	.boost_voltage = 5050,
	.boost_current = 1500,
};

enum rt946x_ilmtsel {
	RT946X_ILMTSEL_PSEL_OTG,
	RT946X_ILMTSEL_AICR = 2,
	RT946X_ILMTSEL_LOWER_LEVEL, /* lower of above two */
};

enum rt946x_chg_stat {
	RT946X_CHGSTAT_READY = 0,
	RT946X_CHGSTAT_IN_PROGRESS,
	RT946X_CHGSTAT_DONE,
	RT946X_CHGSTAT_FAULT,
};

enum rt946x_adc_in_sel {
	RT946X_ADC_VBUS_DIV5 = 1,
	RT946X_ADC_VBUS_DIV2,
};

enum rt946x_irq {
	RT946X_IRQ_CHGSTATC = 0,
	RT946X_IRQ_CHGFAULT,
	RT946X_IRQ_TSSTATC,
	RT946X_IRQ_CHGIRQ1,
	RT946X_IRQ_CHGIRQ2,
	RT946X_IRQ_CHGIRQ3,
#ifdef CONFIG_CHARGER_RT9467
	RT946X_IRQ_DPDMIRQ,
#endif
	RT946X_IRQ_COUNT,
};

static uint8_t rt946x_irqmask[RT946X_IRQ_COUNT] = {
	0xF0, 0xF0, 0xFF, 0xFF, 0xFF, 0xFF,
#ifdef CONFIG_CHARGER_RT9467
	0xFC,
#endif
};

static const uint8_t rt946x_irq_maskall[RT946X_IRQ_COUNT] = {
	0xF0, 0xF0, 0xFF, 0xFF, 0xFF, 0xFF,
#ifdef CONFIG_CHARGER_RT9467
	0xFF,
#endif
};

/* Must be in ascending order */
static const uint16_t rt946x_boost_current[] = {
	500, 700, 1100, 1300, 1800, 2100, 2400,
};

static int rt946x_read8(int reg, int *val)
{
	return i2c_read8(I2C_PORT_CHARGER, RT946X_ADDR, reg, val);
}

static int rt946x_write8(int reg, int val)
{
	return i2c_write8(I2C_PORT_CHARGER, RT946X_ADDR, reg, val);
}

static int rt946x_block_write(int reg, const uint8_t *val, int len)
{
	int rv;
	uint8_t buf[I2C_MAX_HOST_PACKET_SIZE];

	if (len + 1 > I2C_MAX_HOST_PACKET_SIZE)
		return EC_ERROR_INVAL;

	buf[0] = reg & 0xff;
	memcpy(&buf[1], val, len);

	i2c_lock(I2C_PORT_CHARGER, 1);
	rv = i2c_xfer(I2C_PORT_CHARGER, RT946X_ADDR, buf, len + 1, NULL, 0,
		      I2C_XFER_SINGLE);
	i2c_lock(I2C_PORT_CHARGER, 0);
	return rv;
}

static int rt946x_update_bits(int reg, int mask, int val)
{
	int rv;
	int reg_val = 0;

	rv = rt946x_read8(reg, &reg_val);
	if (rv)
		return rv;
	reg_val &= ~mask;
	reg_val |= (mask & val);
	rv = rt946x_write8(reg, reg_val);
	return rv;
}

static inline int rt946x_set_bit(int reg, int mask)
{
	return rt946x_update_bits(reg, mask, mask);
}

static inline int rt946x_clr_bit(int reg, int mask)
{
	return rt946x_update_bits(reg, mask, 0x00);
}

static inline uint8_t rt946x_closest_reg(uint16_t min, uint16_t max,
					 uint16_t step, uint16_t target)
{
	if (target < min)
		return 0;
	if (target >= max)
		return ((max - min) / step);
	return (target - min) / step;
}

static int rt946x_chip_rev(int *chip_rev)
{
	int rv;

	rv = rt946x_read8(RT946X_REG_DEVICEID, chip_rev);
	if (rv == EC_SUCCESS)
		*chip_rev &= RT946X_MASK_CHIP_REV;
	return rv;
}

static inline int rt946x_enable_wdt(int en)
{
	return (en ? rt946x_set_bit : rt946x_clr_bit)
		(RT946X_REG_CHGCTRL13, RT946X_MASK_WDT_EN);
}

/* Enable high-impedance mode */
static inline int rt946x_enable_hz(int en)
{
	return (en ? rt946x_set_bit : rt946x_clr_bit)
		(RT946X_REG_CHGCTRL1, RT946X_MASK_HZ_EN);
}

static int rt946x_por_reset(void)
{
	int rv = 0;

	rv = rt946x_enable_hz(0);
	if (rv)
		return rv;

	return rt946x_set_bit(RT946X_REG_CORECTRL0, RT946X_MASK_RST);
}

static int rt946x_reset_to_zero(void)
{
	int rv = 0;

	rv = charger_set_current(0);
	if (rv)
		return rv;

	rv = charger_set_voltage(0);
	if (rv)
		return rv;

	return rt946x_enable_hz(1);
}

static int rt946x_enable_bc12_detection(int en)
{
#ifdef CONFIG_CHARGER_RT9467
	return (en ? rt946x_set_bit : rt946x_clr_bit)
		(RT946X_REG_DPDM1, RT946X_MASK_USBCHGEN);
#endif
	return 0;
}

static int rt946x_set_ieoc(unsigned int ieoc)
{
	uint8_t reg_ieoc = 0;

	reg_ieoc = rt946x_closest_reg(RT946X_IEOC_MIN, RT946X_IEOC_MAX,
		RT946X_IEOC_STEP, ieoc);

	CPRINTF("%s ieoc = %d(0x%02X)\n", __func__, ieoc, reg_ieoc);

	return rt946x_update_bits(RT946X_REG_CHGCTRL9, RT946X_MASK_IEOC,
		reg_ieoc << RT946X_SHIFT_IEOC);
}

static int rt946x_set_mivr(unsigned int mivr)
{
	uint8_t reg_mivr = 0;

	reg_mivr = rt946x_closest_reg(RT946X_MIVR_MIN, RT946X_MIVR_MAX,
		RT946X_MIVR_STEP, mivr);

	CPRINTF("%s: mivr = %d(0x%02X)\n", __func__, mivr, reg_mivr);

	return rt946x_update_bits(RT946X_REG_CHGCTRL6, RT946X_MASK_MIVR,
		reg_mivr << RT946X_SHIFT_MIVR);
}

static int rt946x_set_boost_voltage(unsigned int voltage)
{
	uint8_t reg_voltage = 0;

	reg_voltage = rt946x_closest_reg(RT946X_BOOST_VOLTAGE_MIN,
		RT946X_BOOST_VOLTAGE_MAX, RT946X_BOOST_VOLTAGE_STEP, voltage);

	CPRINTF("%s voltage = %d(0x%02X)\n", __func__, voltage, reg_voltage);

	return rt946x_update_bits(RT946X_REG_CHGCTRL5,
		RT946X_MASK_BOOST_VOLTAGE,
		reg_voltage << RT946X_SHIFT_BOOST_VOLTAGE);
}

static int rt946x_set_boost_current(unsigned int current)
{
	int i;

	/*
	 * Find the smallest output current threshold which can support
	 * our requested output current. Use the greatest achievable
	 * boost current (2.4A) if requested current is too large.
	 */
	for (i = 0; i < ARRAY_SIZE(rt946x_boost_current) - 1; i++) {
		if (current < rt946x_boost_current[i])
			break;
	}

	CPRINTF("%s current = %d(0x%02X)\n", __func__, current, i);

	return rt946x_update_bits(RT946X_REG_CHGCTRL10,
		RT946X_MASK_BOOST_CURRENT,
		i << RT946X_SHIFT_BOOST_CURRENT);
}

static int rt946x_set_ircmp_vclamp(unsigned int vclamp)
{
	uint8_t reg_vclamp = 0;

	reg_vclamp = rt946x_closest_reg(RT946X_IRCMP_VCLAMP_MIN,
		RT946X_IRCMP_VCLAMP_MAX, RT946X_IRCMP_VCLAMP_STEP, vclamp);

	CPRINTF("%s: vclamp = %d(0x%02X)\n", __func__, vclamp, reg_vclamp);

	return rt946x_update_bits(RT946X_REG_CHGCTRL18,
		RT946X_MASK_IRCMP_VCLAMP,
		reg_vclamp << RT946X_SHIFT_IRCMP_VCLAMP);
}

static int rt946x_set_ircmp_res(unsigned int res)
{
	uint8_t reg_res = 0;

	reg_res = rt946x_closest_reg(RT946X_IRCMP_RES_MIN, RT946X_IRCMP_RES_MAX,
		RT946X_IRCMP_RES_STEP, res);

	CPRINTF("%s: res = %d(0x%02X)\n", __func__, res, reg_res);

	return rt946x_update_bits(RT946X_REG_CHGCTRL18, RT946X_MASK_IRCMP_RES,
		reg_res << RT946X_SHIFT_IRCMP_RES);
}

static int rt946x_set_vprec(unsigned int vprec)
{
	uint8_t reg_vprec = 0;

	reg_vprec = rt946x_closest_reg(RT946X_VPREC_MIN, RT946X_VPREC_MAX,
		RT946X_VPREC_STEP, vprec);

	CPRINTF("%s: vprec = %d(0x%02X)\n", __func__, vprec, reg_vprec);

	return rt946x_update_bits(RT946X_REG_CHGCTRL8, RT946X_MASK_VPREC,
		reg_vprec << RT946X_SHIFT_VPREC);
}

static int rt946x_set_iprec(unsigned int iprec)
{
	uint8_t reg_iprec = 0;

	reg_iprec = rt946x_closest_reg(RT946X_IPREC_MIN, RT946X_IPREC_MAX,
		RT946X_IPREC_STEP, iprec);

	CPRINTF("%s: iprec = %d(0x%02X)\n", __func__, iprec, reg_iprec);

	return rt946x_update_bits(RT946X_REG_CHGCTRL8, RT946X_MASK_IPREC,
		reg_iprec << RT946X_SHIFT_IPREC);
}

static int rt946x_init_irq(void)
{
	int rv = 0;
	int dummy;
	int i;

	/* Mask all interrupts */
	rv = rt946x_block_write(RT946X_REG_CHGSTATCCTRL, rt946x_irq_maskall,
				RT946X_IRQ_COUNT);
	if (rv)
		return rv;

	/* Clear all interrupt flags */
	for (i = 0; i < RT946X_IRQ_COUNT; i++) {
		rv = rt946x_read8(RT946X_REG_CHGSTATC + i, &dummy);
		if (rv)
			return rv;
	}

	/* Init interrupt */
	return rt946x_block_write(RT946X_REG_CHGSTATCCTRL, rt946x_irqmask,
				  ARRAY_SIZE(rt946x_irqmask));
}

static int rt946x_init_setting(void)
{
	int rv = 0;
	const struct battery_info *batt_info = battery_get_info();

#ifdef CONFIG_CHARGER_OTG
	/*  Disable boost-mode output voltage */
	rv = charger_enable_otg_power(0);
	if (rv)
		return rv;
#endif
	/* Enable/Disable BC 1.2 detection */
#ifdef HAS_TASK_USB_CHG
	rv = rt946x_enable_bc12_detection(1);
#else
	rv = rt946x_enable_bc12_detection(0);
#endif
	if (rv)
		return rv;
	/* Disable WDT */
	rv = rt946x_enable_wdt(0);
	if (rv)
		return rv;
	/* Disable battery thermal protection */
	rv = rt946x_clr_bit(RT946X_REG_CHGCTRL16, RT946X_MASK_JEITA_EN);
	if (rv)
		return rv;
	/* Disable charge timer */
	rv = rt946x_clr_bit(RT946X_REG_CHGCTRL12, RT946X_MASK_TMR_EN);
	if (rv)
		return rv;
	rv = rt946x_set_mivr(rt946x_charger_init_setting.mivr);
	if (rv)
		return rv;
	rv = rt946x_set_ieoc(rt946x_charger_init_setting.eoc_current);
	if (rv)
		return rv;
	rv = rt946x_set_boost_voltage(
		rt946x_charger_init_setting.boost_voltage);
	if (rv)
		return rv;
	rv = rt946x_set_boost_current(
		rt946x_charger_init_setting.boost_current);
	if (rv)
		return rv;
	rv = rt946x_set_ircmp_vclamp(rt946x_charger_init_setting.ircmp_vclamp);
	if (rv)
		return rv;
	rv = rt946x_set_ircmp_res(rt946x_charger_init_setting.ircmp_res);
	if (rv)
		return rv;
	rv = rt946x_set_vprec(batt_info->voltage_min);
	if (rv)
		return rv;
	rv = rt946x_set_iprec(batt_info->precharge_current);
	if (rv)
		return rv;

	return rt946x_init_irq();
}

#ifdef CONFIG_CHARGER_OTG
int charger_enable_otg_power(int enabled)
{
	return (enabled ? rt946x_set_bit : rt946x_clr_bit)
		(RT946X_REG_CHGCTRL1, RT946X_MASK_OPA_MODE);
}

int charger_is_sourcing_otg_power(int port)
{
	int val;

	if (rt946x_read8(RT946X_REG_CHGCTRL1, &val))
		return 0;

	return !!(val & RT946X_MASK_OPA_MODE);
}
#endif

int charger_set_input_current(int input_current)
{
	uint8_t reg_iin = 0;
	const struct charger_info * const info = charger_get_info();

	reg_iin = rt946x_closest_reg(info->input_current_min,
		info->input_current_max, info->input_current_step,
		input_current);

	CPRINTF("%s iin = %d(0x%02X)\n", __func__, input_current, reg_iin);

	return rt946x_update_bits(RT946X_REG_CHGCTRL3, RT946X_MASK_AICR,
		reg_iin << RT946X_SHIFT_AICR);
}

int charger_get_input_current(int *input_current)
{
	int rv;
	int val = 0;
	const struct charger_info * const info = charger_get_info();

	rv = rt946x_read8(RT946X_REG_CHGCTRL3, &val);
	if (rv)
		return rv;

	val = (val & RT946X_MASK_AICR) >> RT946X_SHIFT_AICR;
	*input_current = val * info->input_current_step
		+ info->input_current_min;

	return EC_SUCCESS;
}

int charger_manufacturer_id(int *id)
{
	return EC_ERROR_UNIMPLEMENTED;
}

int charger_device_id(int *id)
{
	int rv;

	rv = rt946x_read8(RT946X_REG_DEVICEID, id);
	if (rv == EC_SUCCESS)
		*id &= RT946X_MASK_VENDOR_ID;
	return rv;
}

int charger_get_option(int *option)
{
	/* Ignored: does not exist */
	*option = 0;
	return EC_SUCCESS;
}

int charger_set_option(int option)
{
	/* Ignored: does not exist */
	return EC_SUCCESS;
}

const struct charger_info *charger_get_info(void)
{
	return &rt946x_charger_info;
}

int charger_get_status(int *status)
{
	int rv;
	int val = 0;

	rv = rt946x_read8(RT946X_REG_CHGCTRL2, &val);
	if (rv)
		return rv;
	val = (val & RT946X_MASK_CHG_EN) >> RT946X_SHIFT_CHG_EN;
	if (!val)
		*status |= CHARGER_CHARGE_INHIBITED;

	rv = rt946x_read8(RT946X_REG_CHGFAULT, &val);
	if (rv)
		return rv;
	if (val & RT946X_MASK_CHG_VBATOV)
		*status |= CHARGER_VOLTAGE_OR;


	rv = rt946x_read8(RT946X_REG_CHGNTC, &val);
	if (rv)
		return rv;
	val = (val & RT946X_MASK_BATNTC_FAULT) >> RT946X_SHIFT_BATNTC_FAULT;

	switch (val) {
	case RT946X_BATTEMP_WARM:
		*status |= CHARGER_RES_HOT;
		break;
	case RT946X_BATTEMP_COOL:
		*status |= CHARGER_RES_COLD;
		break;
	case RT946X_BATTEMP_COLD:
		*status |= CHARGER_RES_COLD;
		*status |= CHARGER_RES_UR;
		break;
	case RT946X_BATTEMP_HOT:
		*status |= CHARGER_RES_HOT;
		*status |= CHARGER_RES_OR;
		break;
	default:
		break;
	}

	return EC_SUCCESS;
}

int charger_set_mode(int mode)
{
	int rv;

	if (mode & CHARGE_FLAG_POR_RESET) {
		rv = rt946x_por_reset();
		if (rv)
			return rv;
	}

	if (mode & CHARGE_FLAG_RESET_TO_ZERO) {
		rv = rt946x_reset_to_zero();
		if (rv)
			return rv;
	}

	return EC_SUCCESS;
}

int charger_get_current(int *current)
{
	int rv;
	int val = 0;
	const struct charger_info * const info = charger_get_info();

	rv = rt946x_read8(RT946X_REG_CHGCTRL7, &val);
	if (rv)
		return rv;

	val = (val & RT946X_MASK_ICHG) >> RT946X_SHIFT_ICHG;
	*current = val * info->current_step + info->current_min;

	return EC_SUCCESS;
}

int charger_set_current(int current)
{
	uint8_t reg_icc = 0;
	const struct charger_info * const info = charger_get_info();

	reg_icc = rt946x_closest_reg(info->current_min, info->current_max,
		info->current_step, current);

	return rt946x_update_bits(RT946X_REG_CHGCTRL7, RT946X_MASK_ICHG,
		reg_icc << RT946X_SHIFT_ICHG);
}

int charger_get_voltage(int *voltage)
{
	int rv;
	int val = 0;
	const struct charger_info * const info = charger_get_info();

	rv = rt946x_read8(RT946X_REG_CHGCTRL4, &val);
	if (rv)
		return rv;

	val = (val & RT946X_MASK_CV) >> RT946X_SHIFT_CV;
	*voltage = val * info->voltage_step + info->voltage_min;

	return EC_SUCCESS;
}

int charger_set_voltage(int voltage)
{
	uint8_t reg_cv = 0;
	const struct charger_info * const info = charger_get_info();

	reg_cv = rt946x_closest_reg(info->voltage_min, info->voltage_max,
		info->voltage_step, voltage);

	return rt946x_update_bits(RT946X_REG_CHGCTRL4, RT946X_MASK_CV,
		reg_cv << RT946X_SHIFT_CV);
}

int charger_discharge_on_ac(int enable)
{
	return rt946x_enable_hz(enable);
}

int charger_get_vbus_voltage(int port)
{
	int val;
	static int vbus_mv;
	int retries = 10;

	/* Set VBUS as ADC input */
	rt946x_update_bits(RT946X_REG_CHGADC, RT946X_MASK_ADC_IN_SEL,
		RT946X_ADC_VBUS_DIV5 << RT946X_SHIFT_ADC_IN_SEL);

	/* Start ADC conversion */
	rt946x_set_bit(RT946X_REG_CHGADC, RT946X_MASK_ADC_START);

	/*
	 * In practice, ADC conversion rarely takes more than 35ms.
	 * However, according to the datasheet, ADC conversion may take
	 * up to 200ms. But we can't wait for that long, otherwise
	 * host command would time out. So here we set ADC timeout as 50ms.
	 * If ADC times out, we just return the last read vbus_mv.
	 *
	 * TODO(chromium:820335): We may handle this more gracefully with
	 * EC_RES_IN_PROGRESS.
	 */
	while (--retries) {
		rt946x_read8(RT946X_REG_CHGSTAT, &val);
		if (val & RT946X_MASK_ADC_STAT)
			break;
		msleep(5);
	}

	if (retries) {
		/* Read measured results if ADC finishes in time. */
		rt946x_read8(RT946X_REG_ADCDATAL, &vbus_mv);
		rt946x_read8(RT946X_REG_ADCDATAH, &val);
		vbus_mv |= (val << 8);
		vbus_mv *= 25;
	}

	return vbus_mv;
}

/* Setup sourcing current to prevent overload */
#ifdef CONFIG_CHARGER_ILIM_PIN_DISABLED
static int rt946x_enable_ilim_pin(int en)
{
	int ret;

	ret = (en ? rt946x_set_bit : rt946x_clr_bit)
		(RT946X_REG_CHGCTRL3, RT946X_MASK_ILIMEN);

	return ret;
}

static int rt946x_select_ilmt(enum rt946x_ilmtsel sel)
{
	int ret;

	ret = rt946x_update_bits(RT946X_REG_CHGCTRL2, RT946X_MASK_ILMTSEL,
		sel << RT946X_SHIFT_ILMTSEL);

	return ret;
}
#endif /* CONFIG_CHARGER_ILIM_PIN_DISABLED */

/* Charging power state initialization */
int charger_post_init(void)
{
#ifdef CONFIG_CHARGER_ILIM_PIN_DISABLED
	int rv;

	rv = rt946x_select_ilmt(RT946X_ILMTSEL_AICR);
	if (rv)
		return rv;
	/* Disable ILIM pin */
	rv = rt946x_enable_ilim_pin(0);
	if (rv)
		return rv;
#endif
	return EC_SUCCESS;
}

/* Hardware current ramping (aka AICL: Average Input Current Level) */
#ifdef CONFIG_CHARGE_RAMP_HW
static int rt946x_get_mivr(int *mivr)
{
	int rv;
	int val = 0;

	rv = rt946x_read8(RT946X_REG_CHGCTRL6, &val);
	if (rv)
		return rv;

	val = (val & RT946X_MASK_MIVR) >> RT946X_SHIFT_MIVR;
	*mivr = val * RT946X_MIVR_STEP + RT946X_MIVR_MIN;

	return EC_SUCCESS;
}

static int rt946x_set_aicl_vth(uint8_t aicl_vth)
{
	uint8_t reg_aicl_vth = 0;

	reg_aicl_vth = rt946x_closest_reg(RT946X_AICLVTH_MIN,
		RT946X_AICLVTH_MAX, RT946X_AICLVTH_STEP, aicl_vth);

	return rt946x_update_bits(RT946X_REG_CHGCTRL14, RT946X_MASK_AICLVTH,
		reg_aicl_vth << RT946X_SHIFT_AICLVTH);
}

int charger_set_hw_ramp(int enable)
{
	int rv;
	unsigned int mivr = 0;

	if (!enable) {
		rv = rt946x_clr_bit(RT946X_REG_CHGCTRL14, RT946X_MASK_AICLMEAS);
		return rv;
	}

	rv = rt946x_get_mivr(&mivr);
	if (rv < 0)
		return rv;

	/*
	 * Check if there's a suitable AICL_VTH.
	 * The vendor suggests setting AICL_VTH as (MIVR + 200mV).
	 */
	if ((mivr + 200) > RT946X_AICLVTH_MAX) {
		CPRINTF("%s: no suitable vth, mivr = %d\n", __func__, mivr);
		return EC_ERROR_INVAL;
	}

	rv = rt946x_set_aicl_vth(mivr + 200);
	if (rv < 0)
		return rv;

	return rt946x_set_bit(RT946X_REG_CHGCTRL14, RT946X_MASK_AICLMEAS);
}

int chg_ramp_is_stable(void)
{
	int rv;
	int val = 0;

	rv = rt946x_read8(RT946X_REG_CHGCTRL14, &val);
	val = (val & RT946X_MASK_AICLMEAS) >> RT946X_SHIFT_AICLMEAS;

	return (!rv && !val);
}

int chg_ramp_is_detected(void)
{
	return 1;
}

int chg_ramp_get_current_limit(void)
{
	int rv;
	int input_current = 0;

	rv = charger_get_input_current(&input_current);

	return rv ? -1 : input_current;
}
#endif /* CONFIG_CHARGE_RAMP_HW */

static void rt946x_init(void)
{
	int reg = 0xFFFFFFFF;

	/* Check device id */
	if (charger_device_id(&reg) || reg != RT946X_VENDOR_ID) {
		CPRINTF("RT946X incorrect ID: 0x%02x\n", reg);
		return;
	}

	/* Check revision id */
	if (rt946x_chip_rev(&reg)) {
		CPRINTF("Failed to read RT946X CHIP REV\n");
		return;
	}
	CPRINTF("RT946X CHIP REV: 0x%02x\n", reg);

	if (rt946x_init_setting()) {
		CPRINTF("RT946X init failed\n");
		return;
	}
	CPRINTF("RT946X init succeeded\n");
}
DECLARE_HOOK(HOOK_INIT, rt946x_init, HOOK_PRIO_INIT_I2C + 1);

#ifdef HAS_TASK_USB_CHG
static int rt946x_get_bc12_device_type(void)
{
	int reg;

	if (rt946x_read8(RT946X_REG_DPDM1, &reg))
		return CHARGE_SUPPLIER_NONE;

	switch (reg & RT946X_MASK_BC12_TYPE) {
	case RT946X_MASK_SDP:
		return CHARGE_SUPPLIER_BC12_SDP;
	case RT946X_MASK_CDP:
		return CHARGE_SUPPLIER_BC12_CDP;
	case RT946X_MASK_DCP:
		return CHARGE_SUPPLIER_BC12_DCP;
	default:
		return CHARGE_SUPPLIER_NONE;
	}
}

static int rt946x_get_bc12_ilim(int charge_supplier)
{
	switch (charge_supplier) {
	case CHARGE_SUPPLIER_BC12_CDP:
	case CHARGE_SUPPLIER_BC12_DCP:
		return 1500;
	case CHARGE_SUPPLIER_BC12_SDP:
	default:
		return USB_CHARGER_MIN_CURR_MA;
	}
}

void rt946x_interrupt(enum gpio_signal signal)
{
	task_wake(TASK_ID_USB_CHG);
}

void usb_charger_task(void *u)
{
	struct charge_port_info charge;
	int bc12_type = CHARGE_SUPPLIER_NONE;
	int reg = 0;

	charge.voltage = USB_CHARGER_VOLTAGE_MV;

	while (1) {
		rt946x_read8(RT946X_REG_DPDMIRQ, &reg);

		/* VBUS attach event */
		if (reg & RT946X_MASK_DPDMIRQ_ATTACH) {
			bc12_type = rt946x_get_bc12_device_type();
			if (bc12_type != CHARGE_SUPPLIER_NONE) {
				charge.current =
					rt946x_get_bc12_ilim(bc12_type);
				charge_manager_update_charge(bc12_type,
							     0, &charge);
				rt946x_enable_bc12_detection(0);
			}
		}

		/* VBUS detach event */
		if (reg & RT946X_MASK_DPDMIRQ_DETACH) {
			charge.current = 0;
			charge_manager_update_charge(bc12_type, 0, &charge);
			rt946x_enable_bc12_detection(1);
		}

		task_wait_event(-1);
	}
}
#endif /* HAS_TASK_USB_CHG */

/* Non-standard interface functions */

int rt946x_enable_charger_boost(int en)
{
	return (en ? rt946x_set_bit : rt946x_clr_bit)
		(RT946X_REG_CHGCTRL2, RT946X_MASK_CHG_EN);
}

/*
 * rt946x reports VBUS ready after VBUS is up for ~500ms.
 * Check if this works for the use case before calling this function.
 */
int rt946x_is_vbus_ready(void)
{
	int val = 0;

	return rt946x_read8(RT946X_REG_CHGSTATC, &val) ?
	       0 : !!(val & RT946X_MASK_PWR_RDY);
}

int rt946x_is_charge_done(void)
{
	int val = 0;

	if (rt946x_read8(RT946X_REG_CHGSTAT, &val))
		return 0;

	val = (val & RT946X_MASK_CHG_STAT) >> RT946X_SHIFT_CHG_STAT;

	return val == RT946X_CHGSTAT_DONE;
}

int rt946x_cutoff_battery(void)
{
	return rt946x_set_bit(RT946X_REG_CHGCTRL2, RT946X_MASK_SHIP_MODE);
}

int rt946x_enable_charge_termination(int en)
{
	return (en ? rt946x_set_bit : rt946x_clr_bit)
		(RT946X_REG_CHGCTRL2, RT946X_MASK_TE);
}
