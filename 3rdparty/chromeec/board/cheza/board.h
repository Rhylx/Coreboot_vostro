/* Copyright 2018 The Chromium OS Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

/* Cheza board configuration */

#ifndef __CROS_EC_BOARD_H
#define __CROS_EC_BOARD_H

/* TODO(waihong): Remove the following bringup features */
#define CONFIG_BRINGUP
#define CONFIG_SYSTEM_UNLOCKED /* Allow dangerous commands. */

/* NPCX7 config */
#define NPCX_UART_MODULE2 1  /* GPIO64/65 are used as UART pins. */
#define NPCX_TACH_SEL2    0  /* No tach. */
#define NPCX7_PWM1_SEL    0  /* GPIO C2 is not used as PWM1. */

/* Internal SPI flash on NPCX7 */
#define CONFIG_FLASH_SIZE (512 * 1024) /* It's really 1MB. */
#define CONFIG_SPI_FLASH_REGS
#define CONFIG_SPI_FLASH_W25Q80 /* Internal SPI flash type. */

/* EC Modules */
#define CONFIG_I2C
#define CONFIG_I2C_MASTER
#define CONFIG_LED_COMMON
#define CONFIG_ADC
#undef CONFIG_PWM
#undef CONFIG_PECI

#define CONFIG_BOARD_VERSION
#define CONFIG_POWER_BUTTON
#define CONFIG_VOLUME_BUTTONS
#define CONFIG_SWITCH
#define CONFIG_LID_SWITCH
#define CONFIG_EXTPOWER_GPIO

/* Battery */
#define CONFIG_BATTERY_PRESENT_GPIO GPIO_BATT_PRES_ODL
#define CONFIG_BATTERY_SMART

/* Charger */
#define CONFIG_CHARGER
#define CONFIG_CHARGER_V2
#define CONFIG_CHARGE_MANAGER
#define CONFIG_CHARGER_ISL9238
#define CONFIG_CHARGE_RAMP_HW
#define CONFIG_USB_CHARGER

/* TODO(b/79163120): Use correct charger values, copied from Lux for rev-0 */
#define CONFIG_CHARGER_INPUT_CURRENT 512
#define CONFIG_CHARGER_MIN_BAT_PCT_FOR_POWER_ON 2
#define CONFIG_CHARGER_MIN_POWER_MW_FOR_POWER_ON 7500
#define CONFIG_CHARGER_SENSE_RESISTOR 10
#define CONFIG_CHARGER_SENSE_RESISTOR_AC 20

/* BC 1.2 Charger */
#define CONFIG_BC12_DETECT_PI3USB9281
#define CONFIG_BC12_DETECT_PI3USB9281_CHIP_COUNT 2

/* USB */
#define CONFIG_USB_POWER_DELIVERY
#define CONFIG_CMD_PD_CONTROL
#define CONFIG_USB_PD_ALT_MODE
#define CONFIG_USB_PD_ALT_MODE_DFP
#define CONFIG_USB_PD_DISCHARGE_PPC
#define CONFIG_USB_PD_DUAL_ROLE
#define CONFIG_USB_PD_DUAL_ROLE_AUTO_TOGGLE
#define CONFIG_USB_PD_LOGGING
#define CONFIG_USB_PD_MAX_SINGLE_SOURCE_CURRENT TYPEC_RP_3A0
#define CONFIG_USB_PD_PORT_COUNT 2
#define CONFIG_USB_PD_TCPC_LOW_POWER
#define CONFIG_USB_PD_TCPM_ANX3429
#define CONFIG_USB_PD_TCPM_PS8751
#define CONFIG_USB_PD_TCPM_MUX
#define CONFIG_USB_PD_TCPM_TCPCI
#define CONFIG_USB_PD_TRY_SRC
#define CONFIG_USB_PD_VBUS_DETECT_TCPC
#define CONFIG_USB_PD_5V_EN_CUSTOM
#define CONFIG_USBC_PPC_SN5S330
#define CONFIG_USBC_SS_MUX
#define CONFIG_USBC_SS_MUX_DFP_ONLY
#define CONFIG_USBC_VCONN
#define CONFIG_USBC_VCONN_SWAP

/* TODO(b/79163120): Use correct PD delay values, copied from Lux for rev-0 */
#define PD_POWER_SUPPLY_TURN_ON_DELAY   30000  /* us */
#define PD_POWER_SUPPLY_TURN_OFF_DELAY  250000 /* us */
#define PD_VCONN_SWAP_DELAY             5000 /* us */

/* TODO(b/79163120): Use correct PD power values, copied from Lux for rev-0 */
#define PD_OPERATING_POWER_MW   15000
#define PD_MAX_POWER_MW         45000
#define PD_MAX_CURRENT_MA       3000
#define PD_MAX_VOLTAGE_MV       20000

#define CONFIG_CHIPSET_SDM845
#define CONFIG_CHIPSET_RESET_HOOK
#define CONFIG_POWER_COMMON
#define CONFIG_POWER_PP5000_CONTROL

/* TODO(b/79348203): Enable EC hibernate */
#undef CONFIG_HIBERNATE

/* I2C Ports */
#define I2C_PORT_BATTERY I2C_PORT_POWER
#define I2C_PORT_CHARGER I2C_PORT_POWER
#define I2C_PORT_POWER   NPCX_I2C_PORT0_0
#define I2C_PORT_TCPC0   NPCX_I2C_PORT1_0
#define I2C_PORT_TCPC1   NPCX_I2C_PORT2_0
#define I2C_PORT_EEPROM  NPCX_I2C_PORT5_0
#define I2C_PORT_SENSOR  NPCX_I2C_PORT7_0

#ifndef __ASSEMBLER__

#include "gpio_signal.h"
#include "registers.h"

enum power_signal {
	SDM845_POWER_GOOD = 0,
	/* Number of power signals */
	POWER_SIGNAL_COUNT
};

enum adc_channel {
	ADC_VBUS = -1,
	ADC_CH_COUNT
};

void board_set_switchcap(int asserted);

/* Custom function to indicate if sourcing VBUS */
int board_is_sourcing_vbus(int port);
/* Enable VBUS sink for a given port */
int board_vbus_sink_enable(int port, int enable);
/* Reset all TCPCs. */
void board_reset_pd_mcu(void);

#endif /* !defined(__ASSEMBLER__) */

#endif /* __CROS_EC_BOARD_H */
