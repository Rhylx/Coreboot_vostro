/* Copyright 2017 The Chromium OS Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

/* Fizz board-specific configuration */

#include "adc.h"
#include "adc_chip.h"
#include "als.h"
#include "battery.h"
#include "bd99992gw.h"
#include "board_config.h"
#include "button.h"
#include "charge_manager.h"
#include "charge_state.h"
#include "charger.h"
#include "chipset.h"
#include "console.h"
#include "cros_board_info.h"
#include "driver/pmic_tps650x30.h"
#include "driver/temp_sensor/tmp432.h"
#include "driver/tcpm/ps8xxx.h"
#include "driver/tcpm/tcpci.h"
#include "driver/tcpm/tcpm.h"
#include "espi.h"
#include "extpower.h"
#include "espi.h"
#include "fan.h"
#include "fan_chip.h"
#include "gpio.h"
#include "hooks.h"
#include "host_command.h"
#include "i2c.h"
#include "math_util.h"
#include "pi3usb9281.h"
#include "power.h"
#include "power_button.h"
#include "pwm.h"
#include "pwm_chip.h"
#include "spi.h"
#include "switch.h"
#include "system.h"
#include "task.h"
#include "temp_sensor.h"
#include "timer.h"
#include "uart.h"
#include "usb_charge.h"
#include "usb_mux.h"
#include "usb_pd.h"
#include "usb_pd_tcpm.h"
#include "util.h"

#define CPRINTS(format, args...) cprints(CC_USBCHARGE, format, ## args)
#define CPRINTF(format, args...) cprintf(CC_USBCHARGE, format, ## args)

static void tcpc_alert_event(enum gpio_signal signal)
{
	if (!gpio_get_level(GPIO_USB_C0_PD_RST_ODL))
		return;

#ifdef HAS_TASK_PDCMD
	/* Exchange status with TCPCs */
	host_command_pd_send_status(PD_CHARGE_NO_CHANGE);
#endif
}

#define ADP_DEBOUNCE_MS		1000  /* Debounce time for BJ plug/unplug */
/*
 * ADP_IN pin state. It's initialized to 1 (=unplugged) because the IRQ won't
 * be triggered if BJ is the power source.
 */
static int adp_in_state = 1;

static void adp_in_deferred(void);
DECLARE_DEFERRED(adp_in_deferred);
static void adp_in_deferred(void)
{
	struct charge_port_info pi = { 0 };
	int level = gpio_get_level(GPIO_ADP_IN_L);

	/* Debounce */
	if (level == adp_in_state)
		return;
	if (!level) {
		/* BJ is inserted but the voltage isn't effective because PU3
		 * is still disabled. */
		pi.voltage = 19500;
		if (chipset_in_state(CHIPSET_STATE_ANY_OFF))
			/*
			 * It doesn't matter what we set here because we'll
			 * brown out anyway when charge_manager switches
			 * input.
			 */
			pi.current = 3330;
	}
	charge_manager_update_charge(CHARGE_SUPPLIER_DEDICATED,
				     DEDICATED_CHARGE_PORT, &pi);
	/*
	 * Explicitly notifies the host that BJ is plugged or unplugged
	 * (when running on a type-c adapter).
	 */
	pd_send_host_event(PD_EVENT_POWER_CHANGE);
	adp_in_state = level;
}

/* IRQ for BJ plug/unplug. It shouldn't be called if BJ is the power source. */
void adp_in(enum gpio_signal signal)
{
	if (adp_in_state == gpio_get_level(GPIO_ADP_IN_L))
		return;
	hook_call_deferred(&adp_in_deferred_data, ADP_DEBOUNCE_MS * MSEC);
}

void vbus0_evt(enum gpio_signal signal)
{
	task_wake(TASK_ID_PD_C0);
}

#include "gpio_list.h"

/* power signal list.  Must match order of enum power_signal. */
const struct power_signal_info power_signal_list[] = {
	{GPIO_PCH_SLP_S0_L,	POWER_SIGNAL_ACTIVE_HIGH, "SLP_S0_DEASSERTED"},
#ifdef CONFIG_ESPI_VW_SIGNALS
	{VW_SLP_S3_L,		POWER_SIGNAL_ACTIVE_HIGH, "SLP_S3_DEASSERTED"},
	{VW_SLP_S4_L,		POWER_SIGNAL_ACTIVE_HIGH, "SLP_S4_DEASSERTED"},
#else
	{GPIO_PCH_SLP_S3_L,	POWER_SIGNAL_ACTIVE_HIGH, "SLP_S3_DEASSERTED"},
	{GPIO_PCH_SLP_S4_L,	POWER_SIGNAL_ACTIVE_HIGH, "SLP_S4_DEASSERTED"},
#endif
	{GPIO_PCH_SLP_SUS_L,	POWER_SIGNAL_ACTIVE_HIGH, "SLP_SUS_DEASSERTED"},
	{GPIO_RSMRST_L_PGOOD,	POWER_SIGNAL_ACTIVE_HIGH, "RSMRST_L_PGOOD"},
	{GPIO_PMIC_DPWROK,	POWER_SIGNAL_ACTIVE_HIGH, "PMIC_DPWROK"},
};
BUILD_ASSERT(ARRAY_SIZE(power_signal_list) == POWER_SIGNAL_COUNT);

/* Hibernate wake configuration */
const enum gpio_signal hibernate_wake_pins[] = {
	GPIO_POWER_BUTTON_L,
};
const int hibernate_wake_pins_used = ARRAY_SIZE(hibernate_wake_pins);

/* ADC channels */
const struct adc_t adc_channels[] = {
	/* Vbus sensing (1/10 voltage divider). */
	[ADC_VBUS] = {"VBUS", NPCX_ADC_CH2, ADC_MAX_VOLT*10, ADC_READ_MAX+1, 0},
};
BUILD_ASSERT(ARRAY_SIZE(adc_channels) == ADC_CH_COUNT);

/******************************************************************************/
/* Physical fans. These are logically separate from pwm_channels. */
const struct fan_conf fan_conf_0 = {
	.flags = FAN_USE_RPM_MODE,
	.ch = MFT_CH_0,	/* Use MFT id to control fan */
	.pgood_gpio = -1,
	.enable_gpio = GPIO_FAN_PWR_EN,
};

const struct fan_rpm fan_rpm_0 = {
	.rpm_min = 2800,
	.rpm_start = 2800,
	.rpm_max = 5600,
};

struct fan_t fans[] = {
	[FAN_CH_0] = { .conf = &fan_conf_0, .rpm = &fan_rpm_0, },
};
BUILD_ASSERT(ARRAY_SIZE(fans) == FAN_CH_COUNT);

/******************************************************************************/
/* MFT channels. These are logically separate from pwm_channels. */
const struct mft_t mft_channels[] = {
	[MFT_CH_0] = {NPCX_MFT_MODULE_2, TCKC_LFCLK, PWM_CH_FAN},
};
BUILD_ASSERT(ARRAY_SIZE(mft_channels) == MFT_CH_COUNT);

/* I2C port map */
const struct i2c_port_t i2c_ports[]  = {
	{"tcpc", NPCX_I2C_PORT0_0, 400, GPIO_I2C0_0_SCL, GPIO_I2C0_0_SDA},
	{"eeprom", NPCX_I2C_PORT0_1, 400, GPIO_I2C0_1_SCL, GPIO_I2C0_1_SDA},
	{"charger", NPCX_I2C_PORT1, 100, GPIO_I2C1_SCL, GPIO_I2C1_SDA},
	{"pmic", NPCX_I2C_PORT2, 400, GPIO_I2C2_SCL, GPIO_I2C2_SDA},
	{"thermal", NPCX_I2C_PORT3, 400, GPIO_I2C3_SCL, GPIO_I2C3_SDA},
};
const unsigned int i2c_ports_used = ARRAY_SIZE(i2c_ports);

/* TCPC mux configuration */
const struct tcpc_config_t tcpc_config[CONFIG_USB_PD_PORT_COUNT] = {
	{NPCX_I2C_PORT0_0, I2C_ADDR_TCPC0, &ps8xxx_tcpm_drv,
			TCPC_ALERT_ACTIVE_LOW},
};

static int ps8751_tune_mux(const struct usb_mux *mux)
{
	/* 0x98 sets lower EQ of DP port (4.5db) */
	i2c_write8(I2C_PORT_TCPC0, I2C_ADDR_TCPC0,
			   PS8XXX_REG_MUX_DP_EQ_CONFIGURATION, 0x98);
	return EC_SUCCESS;
}

struct usb_mux usb_muxes[CONFIG_USB_PD_PORT_COUNT] = {
	{
		.port_addr = 0,
		.driver = &tcpci_tcpm_usb_mux_driver,
		.hpd_update = &ps8xxx_tcpc_update_hpd_status,
		.board_init = &ps8751_tune_mux,
	}
};

const int usb_port_enable[USB_PORT_COUNT] = {
	GPIO_USB1_ENABLE,
	GPIO_USB2_ENABLE,
	GPIO_USB3_ENABLE,
	GPIO_USB4_ENABLE,
	GPIO_USB5_ENABLE,
};

void board_reset_pd_mcu(void)
{
	gpio_set_level(GPIO_USB_C0_PD_RST_ODL, 0);
	msleep(1);
	gpio_set_level(GPIO_USB_C0_PD_RST_ODL, 1);
}

void board_tcpc_init(void)
{
	int port, reg;

	/* This needs to be executed only once per boot. It could be run by RO
	 * if we boot in recovery mode. It could be run by RW if we boot in
	 * normal or dev mode. Note EFS makes RO jump to RW before HOOK_INIT. */
	board_reset_pd_mcu();

	/*
	 * Wake up PS8751. If PS8751 remains in low power mode after sysjump,
	 * TCPM_INIT will fail due to not able to access PS8751.
	 * Note PS8751 A3 will wake on any I2C access.
	 */
	i2c_read8(I2C_PORT_TCPC0, I2C_ADDR_TCPC0, 0xA0, &reg);

	/* Enable TCPC interrupts */
	gpio_enable_interrupt(GPIO_USB_C0_PD_INT_ODL);

	/*
	 * Initialize HPD to low; after sysjump SOC needs to see
	 * HPD pulse to enable video path
	 */
	for (port = 0; port < CONFIG_USB_PD_PORT_COUNT; port++) {
		const struct usb_mux *mux = &usb_muxes[port];
		mux->hpd_update(port, 0, 0);
	}
}
DECLARE_HOOK(HOOK_INIT, board_tcpc_init, HOOK_PRIO_INIT_I2C+1);

uint16_t tcpc_get_alert_status(void)
{
	uint16_t status = 0;

	if (!gpio_get_level(GPIO_USB_C0_PD_INT_ODL)) {
		if (gpio_get_level(GPIO_USB_C0_PD_RST_ODL))
			status |= PD_STATUS_TCPC_ALERT_0;
	}

	return status;
}

/*
 * Temperature sensors data; must be in same order as enum temp_sensor_id.
 * Sensor index and name must match those present in coreboot:
 *     src/mainboard/google/${board}/acpi/dptf.asl
 */
const struct temp_sensor_t temp_sensors[] = {
	{"TMP432_Internal", TEMP_SENSOR_TYPE_BOARD, tmp432_get_val,
			TMP432_IDX_LOCAL, 4},
	{"TMP432_Sensor_1", TEMP_SENSOR_TYPE_BOARD, tmp432_get_val,
			TMP432_IDX_REMOTE1, 4},
	{"TMP432_Sensor_2", TEMP_SENSOR_TYPE_BOARD, tmp432_get_val,
			TMP432_IDX_REMOTE2, 4},
};
BUILD_ASSERT(ARRAY_SIZE(temp_sensors) == TEMP_SENSOR_COUNT);

/*
 * Thermal limits for each temp sensor.  All temps are in degrees K.  Must be in
 * same order as enum temp_sensor_id.  To always ignore any temp, use 0.
 */
struct ec_thermal_config thermal_params[] = {
	/* {Twarn, Thigh, Thalt}, <on>
	 * {Twarn, Thigh, X    }, <off>
	 * fan_off, fan_max
	 */
	{{0, C_TO_K(80), C_TO_K(81)}, {0, C_TO_K(78), 0},
		C_TO_K(4), C_TO_K(76)},	/* TMP432_Internal */
	{{0, 0, 0}, {0, 0, 0}, 0, 0},	/* TMP432_Sensor_1 */
	{{0, 0, 0}, {0, 0, 0}, 0, 0},	/* TMP432_Sensor_2 */
};
BUILD_ASSERT(ARRAY_SIZE(thermal_params) == TEMP_SENSOR_COUNT);

/* Initialize PMIC */
#define I2C_PMIC_READ(reg, data) \
		i2c_read8(I2C_PORT_PMIC, TPS650X30_I2C_ADDR1, (reg), (data))

#define I2C_PMIC_WRITE(reg, data) \
		i2c_write8(I2C_PORT_PMIC, TPS650X30_I2C_ADDR1, (reg), (data))

static void board_pmic_init(void)
{
	int err;
	int error_count = 0;
	static uint8_t pmic_initialized = 0;

	if (pmic_initialized)
		return;

	/* Read vendor ID */
	while (1) {
		int data;
		err = I2C_PMIC_READ(TPS650X30_REG_VENDORID, &data);
		if (!err && data == TPS650X30_VENDOR_ID)
			break;
		else if (error_count > 5)
			goto pmic_error;
		error_count++;
	}

	/*
	 * VCCIOCNT register setting
	 * [6] : CSDECAYEN
	 * otherbits: default
	 */
	err = I2C_PMIC_WRITE(TPS650X30_REG_VCCIOCNT, 0x4A);
	if (err)
		goto pmic_error;

	/*
	 * VRMODECTRL:
	 * [4] : VCCIOLPM clear
	 * otherbits: default
	 */
	err = I2C_PMIC_WRITE(TPS650X30_REG_VRMODECTRL, 0x2F);
	if (err)
		goto pmic_error;

	/*
	 * PGMASK1 : Exclude VCCIO from Power Good Tree
	 * [7] : MVCCIOPG clear
	 * otherbits: default
	 */
	err = I2C_PMIC_WRITE(TPS650X30_REG_PGMASK1, 0x80);
	if (err)
		goto pmic_error;

	/*
	 * PWFAULT_MASK1 Register settings
	 * [7] : 1b V4 Power Fault Masked
	 * [4] : 1b V7 Power Fault Masked
	 * [2] : 1b V9 Power Fault Masked
	 * [0] : 1b V13 Power Fault Masked
	 */
	err = I2C_PMIC_WRITE(TPS650X30_REG_PWFAULT_MASK1, 0x95);
	if (err)
		goto pmic_error;

	/*
	 * Discharge control 4 register configuration
	 * [7:6] : 00b Reserved
	 * [5:4] : 01b V3.3S discharge resistance (V6S), 100 Ohm
	 * [3:2] : 01b V18S discharge resistance (V8S), 100 Ohm
	 * [1:0] : 01b V100S discharge resistance (V11S), 100 Ohm
	 */
	err = I2C_PMIC_WRITE(TPS650X30_REG_DISCHCNT4, 0x15);
	if (err)
		goto pmic_error;

	/*
	 * Discharge control 3 register configuration
	 * [7:6] : 01b V1.8U_2.5U discharge resistance (V9), 100 Ohm
	 * [5:4] : 01b V1.2U discharge resistance (V10), 100 Ohm
	 * [3:2] : 01b V100A discharge resistance (V11), 100 Ohm
	 * [1:0] : 01b V085A discharge resistance (V12), 100 Ohm
	 */
	err = I2C_PMIC_WRITE(TPS650X30_REG_DISCHCNT3, 0x55);
	if (err)
		goto pmic_error;

	/*
	 * Discharge control 2 register configuration
	 * [7:6] : 01b V5ADS3 discharge resistance (V5), 100 Ohm
	 * [5:4] : 01b V33A_DSW discharge resistance (V6), 100 Ohm
	 * [3:2] : 01b V33PCH discharge resistance (V7), 100 Ohm
	 * [1:0] : 01b V18A discharge resistance (V8), 100 Ohm
	 */
	err = I2C_PMIC_WRITE(TPS650X30_REG_DISCHCNT2, 0x55);
	if (err)
		goto pmic_error;

	/*
	 * Discharge control 1 register configuration
	 * [7:2] : 00b Reserved
	 * [1:0] : 01b VCCIO discharge resistance (V4), 100 Ohm
	 */
	err = I2C_PMIC_WRITE(TPS650X30_REG_DISCHCNT1, 0x01);
	if (err)
		goto pmic_error;

	/*
	 * Increase Voltage
	 *  [7:0] : 0x2a default
	 *  [5:4] : 10b default
	 *  [5:4] : 01b 5.1V (0x1a)
	 */
	err = I2C_PMIC_WRITE(TPS650X30_REG_V5ADS3CNT, 0x1a);
	if (err)
		goto pmic_error;

	/*
	 * PBCONFIG Register configuration
	 *   [7] :      1b Power button debounce, 0ms (no debounce)
	 *   [6] :      0b Power button reset timer logic, no action (default)
	 * [5:0] : 011111b Force an Emergency reset time, 31s (default)
	 */
	err = I2C_PMIC_WRITE(TPS650X30_REG_PBCONFIG, 0x9F);
	if (err)
		goto pmic_error;

	CPRINTS("PMIC init done");
	pmic_initialized = 1;
	return;

pmic_error:
	CPRINTS("PMIC init failed");
}

void chipset_pre_init_callback(void)
{
	board_pmic_init();
}

/**
 * Notify the AC presence GPIO to the PCH.
 */
static void board_extpower(void)
{
	gpio_set_level(GPIO_PCH_ACPRESENT, extpower_is_present());
}
DECLARE_HOOK(HOOK_AC_CHANGE, board_extpower, HOOK_PRIO_DEFAULT);

/* Initialize board. */
static void board_init(void)
{
	uint32_t version;
	if (cbi_get_board_version(&version) == EC_SUCCESS)
		CPRINTS("Board Version: 0x%04x", version);

	/* Provide AC status to the PCH */
	board_extpower();

	gpio_enable_interrupt(GPIO_USB_C0_VBUS_WAKE_L);
}
DECLARE_HOOK(HOOK_INIT, board_init, HOOK_PRIO_DEFAULT);

/* Mapping to the old schematics */
#define GPIO_U42_P GPIO_TYPE_C_60W
#define GPIO_U22_C GPIO_TYPE_C_65W

/*
 * Board version 2.1 or before uses a different current monitoring circuitry.
 */
static void set_charge_limit(int charge_ma)
{
	/*
	 * We have two FETs connected to two registers: PR257 & PR258.
	 * These control thresholds of the over current monitoring system.
	 *
	 *                              PR257, PR258
	 * For 4.62A (90W BJ adapter),     on,   off
	 * For 3.33A (65W BJ adapter),    off,    on
	 * For 3.00A (Type-C adapter),    off,   off
	 *
	 * The over current monitoring system doesn't support less than 3A
	 * (e.g. 2.25A, 2.00A). These current most likely won't be enough to
	 * power the system. However, if they're needed, EC can monitor
	 * PMON_PSYS and trigger H_PROCHOT by itself.
	 */
	if (charge_ma >= 4620) {
		gpio_set_level(GPIO_U42_P, 1);
		gpio_set_level(GPIO_U22_C, 0);
	} else if (charge_ma >= 3330) {
		gpio_set_level(GPIO_U42_P, 0);
		gpio_set_level(GPIO_U22_C, 1);
	} else if (charge_ma >= 3000) {
		gpio_set_level(GPIO_U42_P, 0);
		gpio_set_level(GPIO_U22_C, 0);
	} else {
		/* TODO(http://crosbug.com/p/65013352) */
		CPRINTS("Current %dmA not supported", charge_ma);
	}
}

void board_set_charge_limit(int port, int supplier, int charge_ma,
			    int max_ma, int charge_mv)
{
	uint32_t ver = 0;
	int p87w = 0, p65w = 0, p60w = 0;

	/*
	 * Turn on/off power shortage alert. Performs the same check as
	 * system_can_boot_ap(). It's repeated here because charge_manager
	 * hasn't updated charge_current/voltage when board_set_charge_limit
	 * is called.
	 */
	led_alert(charge_ma * charge_mv <
			CONFIG_CHARGER_MIN_POWER_MW_FOR_POWER_ON * 1000);

	/*
	 * In terms of timing, this should always work because
	 * HOOK_PRIO_CHARGE_MANAGER_INIT is notified after HOOK_PRIO_INIT_I2C.
	 * If CBI isn't initialized or contains invalid data, we assume it's
	 * a new board.
	 */
	if (cbi_get_board_version(&ver) == EC_SUCCESS && ver < 0x0202)
		return set_charge_limit(charge_ma);
	/*
	 * We have three FETs connected to three registers: PR257, PR258,
	 * PR7824. These control the thresholds of the current monitoring
	 * system.
	 *
	 *                               PR257  PR7824 PR258
	 *   For BJ (65W or 90W)           off     off   off
	 *   For 4.35A (87W)                on     off   off
	 *   For 3.25A (65W)               off     off    on
	 *   For 3.00A (60W)               off      on   off
	 *
	 * The system power consumption is capped by PR259, which is stuffed
	 * differently depending on the SKU (65W v.s. 90W or U42 v.s. U22).
	 * So, we only need to monitor type-c adapters. For example:
	 *
	 *   a 90W system powered by 65W type-c charger
	 *   b 65W system powered by 60W type-c charger
	 *   c 65W system powered by 87W type-c charger
	 *
	 * In a case such as (c), we actually do not need to monitor the current
	 * because the max is capped by PR259.
	 *
	 * AP is expected to read type-c adapter wattage from EC and control
	 * power consumption to avoid over-current or system browns out.
	 *
	 */
	if (supplier != CHARGE_SUPPLIER_DEDICATED) {
		/* Apple 87W charger offers 4.3A @20V. */
		if (charge_ma >= 4300) {
			p87w = 1;
		} else if (charge_ma >= 3250) {
			p65w = 1;
		} else if (charge_ma >= 3000) {
			p60w = 1;
		} else {
			/*
			 * TODO:http://crosbug.com/p/65013352.
	 		 * The current monitoring system doesn't support lower
	 		 * current. These currents are most likely not enough to
	 		 * power the system. However, if they're needed, EC can
	 		 * monitor PMON_PSYS and trigger H_PROCHOT by itself.
	 		 */
			p60w = 1;
			CPRINTS("Current %dmA not supported", charge_ma);
		}
	}

	gpio_set_level(GPIO_TYPE_C_87W, p87w);
	gpio_set_level(GPIO_TYPE_C_65W, p65w);
	gpio_set_level(GPIO_TYPE_C_60W, p60w);
}

enum battery_present battery_is_present(void)
{
	/* The GPIO is low when the battery is present */
	return BP_NO;
}

int64_t get_time_dsw_pwrok(void)
{
	/* DSW_PWROK is turned on before EC was powered. */
	return -20 * MSEC;
}

const struct pwm_t pwm_channels[] = {
	[PWM_CH_LED_RED]   = { 3, PWM_CONFIG_DSLEEP, 100 },
	[PWM_CH_LED_GREEN] = { 5, PWM_CONFIG_DSLEEP, 100 },
	[PWM_CH_FAN] = {4, PWM_CONFIG_OPEN_DRAIN, 25000},
};
BUILD_ASSERT(ARRAY_SIZE(pwm_channels) == PWM_CH_COUNT);

struct fan_step {
	int on;
	int off;
	int rpm;
};

/* Note: Do not make the fan on/off point equal to 0 or 100 */
static const struct fan_step fan_table0[] = {
	{.on =  0, .off =  1, .rpm = 0},
	{.on = 36, .off =  1, .rpm = 2800},
	{.on = 58, .off = 58, .rpm = 3200},
	{.on = 66, .off = 61, .rpm = 3400},
	{.on = 75, .off = 69, .rpm = 4200},
	{.on = 81, .off = 76, .rpm = 4800},
	{.on = 88, .off = 83, .rpm = 5200},
	{.on = 98, .off = 91, .rpm = 5600},
};
static const struct fan_step fan_table1[] = {
	{.on =  0, .off =  1, .rpm = 0},
	{.on = 36, .off =  1, .rpm = 2800},
	{.on = 62, .off = 58, .rpm = 3200},
	{.on = 68, .off = 63, .rpm = 3400},
	{.on = 75, .off = 69, .rpm = 4200},
	{.on = 81, .off = 76, .rpm = 4800},
	{.on = 88, .off = 83, .rpm = 5200},
	{.on = 98, .off = 91, .rpm = 5600},
};
/* All fan tables must have the same number of levels */
#define NUM_FAN_LEVELS ARRAY_SIZE(fan_table0)
BUILD_ASSERT(ARRAY_SIZE(fan_table1) == NUM_FAN_LEVELS);

/* Default uses table0 due to its smaller active point */
static const struct fan_step *fan_tables[] = {
	fan_table0,	/* Kench & Default */
	fan_table0,	/* Teemo */
	fan_table1,	/* Sion */
};

static int get_custom_rpm(int fan, int pct, int oem_id)
{
	static int current_level;
	static int previous_pct;
	const struct fan_step *fan_table = fan_tables[oem_id];
	int i;

	/*
	 * Compare the pct and previous pct, we have the three paths :
	 *  1. decreasing path. (check the off point)
	 *  2. increasing path. (check the on point)
	 *  3. invariant path. (return the current RPM)
	 */
	if (pct < previous_pct) {
		for (i = current_level; i >= 0; i--) {
			if (pct <= fan_table[i].off)
				current_level = i - 1;
			else
				break;
		}
	} else if (pct > previous_pct) {
		for (i = current_level + 1; i < NUM_FAN_LEVELS; i++) {
			if (pct >= fan_table[i].on)
				current_level = i;
			else
				break;
		}
	}

	if (current_level < 0)
		current_level = 0;

	previous_pct = pct;

	if (fan_table[current_level].rpm !=
		fan_get_rpm_target(FAN_CH(fan)))
		cprintf(CC_THERMAL, "[%T Setting fan RPM to %d]\n",
			fan_table[current_level].rpm);

	return fan_table[current_level].rpm;
}

int fan_percent_to_rpm(int fan, int pct)
{
	uint32_t oem_id;
	if (cbi_get_oem_id(&oem_id) || oem_id >= ARRAY_SIZE(fan_tables)) {
		CPRINTF("Fan OEM%d not supported or failed to get OEM", oem_id);
		oem_id = 0;
	}
	return get_custom_rpm(fan, pct, oem_id);
}
