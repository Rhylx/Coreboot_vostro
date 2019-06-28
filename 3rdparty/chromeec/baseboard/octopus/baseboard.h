/* Copyright 2018 The Chromium OS Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

/* Octopus board configuration */

#ifndef __CROS_EC_BASEBOARD_H
#define __CROS_EC_BASEBOARD_H

/*******************************************************************************
 * EC Config
 */

/*
 * Variant EC defines. Pick one:
 * VARIANT_OCTOPUS_EC_NPCX796FB
 * VARIANT_OCTOPUS_EC_ITE8320
 */
#if defined(VARIANT_OCTOPUS_EC_NPCX796FB)
	/* NPCX7 config */
	#define NPCX_UART_MODULE2 1  /* GPIO64/65 are used as UART pins. */
	#define NPCX_TACH_SEL2    0  /* [0:GPIO40/73, 1:GPIO93/A6] as TACH */
	#define NPCX7_PWM1_SEL    0  /* GPIO C2 is not used as PWM1. */

	/* Internal SPI flash on NPCX7 */
	/* Flash is 1MB but reserve half for future use. */
	#define CONFIG_FLASH_SIZE (512 * 1024)

	#define CONFIG_SPI_FLASH_REGS
	#define CONFIG_SPI_FLASH_W25Q128 /* Internal SPI flash type. */

	/* I2C Bus Configuration */
	#define I2C_PORT_BATTERY	NPCX_I2C_PORT0_0
	#define I2C_PORT_TCPC0		NPCX_I2C_PORT1_0
	#define I2C_PORT_TCPC1		NPCX_I2C_PORT2_0
	#define I2C_PORT_EEPROM		NPCX_I2C_PORT3_0
	#define I2C_PORT_CHARGER	NPCX_I2C_PORT4_1
	#define I2C_PORT_SENSOR		NPCX_I2C_PORT7_0
	#define I2C_ADDR_EEPROM		0xA0

	/* EC variant determines USB-C variant */
	#define VARIANT_OCTOPUS_USBC_STANDALONE_TCPCS
#elif defined(VARIANT_OCTOPUS_EC_ITE8320)
	 /* Flash clock must be > (50Mhz / 2) */
	#define CONFIG_IT83XX_FLASH_CLOCK_48MHZ

	/* I2C Bus Configuration */
	#define I2C_PORT_BATTERY	IT83XX_I2C_CH_A	/* Shared bus */
	#define I2C_PORT_CHARGER	IT83XX_I2C_CH_A	/* Shared bus */
	#define I2C_PORT_SENSOR		IT83XX_I2C_CH_B
	#define I2C_PORT_USBC0		IT83XX_I2C_CH_C
	#define I2C_PORT_USBC1		IT83XX_I2C_CH_E
	#define I2C_PORT_USB_MUX	I2C_PORT_USBC0	/* For MUX driver */
	#define I2C_PORT_EEPROM		IT83XX_I2C_CH_F
	#define I2C_ADDR_EEPROM		0xA0

	/* EC variant determines USB-C variant */
	#define VARIANT_OCTOPUS_USBC_ITE_EC_TCPCS
#else
	#error Must define a VARIANT_OCTOPUS_EC
#endif /* VARIANT_OCTOPUS_EC */

/* Common EC defines */
#define CONFIG_I2C
#define CONFIG_I2C_MASTER
#define CONFIG_VBOOT_HASH
#define CONFIG_VSTORE
#define CONFIG_VSTORE_SLOT_COUNT 1
#define CONFIG_CRC8
#define CONFIG_CROS_BOARD_INFO
#define CONFIG_BOARD_VERSION_CBI
#define CONFIG_LOW_POWER_IDLE

/*
 * We don't need CONFIG_BACKLIGHT_LID since hardware AND's LID_OPEN and AP
 * signals with EC backlight enable signal.
 */

/*******************************************************************************
 * Battery/Charger/Power Config
 */

/*
 * Variant charger defines. Pick one:
 * VARIANT_OCTOPUS_CHARGER_ISL9238
 * VARIANT_OCTOPUS_CHARGER_BQ25703
 */
#if defined(VARIANT_OCTOPUS_CHARGER_ISL9238)
	#define CONFIG_CHARGER_ISL9238
	#define CONFIG_CHARGER_SENSE_RESISTOR_AC 20
	/*
	 * ISL923x driver sets "Adapter insertion to Switching Debounce"
	 * CONTROL2 REG 0x3DH <Bit 11> to 1 which is 150 ms
	 */
	#undef	CONFIG_EXTPOWER_DEBOUNCE_MS
	#define	CONFIG_EXTPOWER_DEBOUNCE_MS 200
#elif defined(VARIANT_OCTOPUS_CHARGER_BQ25703)
	#define CONFIG_CHARGER_BQ25703
	#define CONFIG_CHARGER_SENSE_RESISTOR_AC 10
	/*
	 * From BQ25703: CHRG_OK is HIGH after 50ms deglitch time.
	 */
	#undef	CONFIG_EXTPOWER_DEBOUNCE_MS
	#define	CONFIG_EXTPOWER_DEBOUNCE_MS 50
#else
	#error Must define a VARIANT_OCTOPUS_CHARGER
#endif /* VARIANT_OCTOPUS_CHARGER */

/* Common charger defines */
#define CONFIG_CHARGE_MANAGER
#define CONFIG_CHARGE_RAMP_HW
#define CONFIG_CHARGER
#define CONFIG_CHARGER_V2
#define CONFIG_CHARGER_INPUT_CURRENT 512 /* Allow low-current USB charging */
#define CONFIG_CHARGER_MIN_BAT_PCT_FOR_POWER_ON 1
#define CONFIG_CHARGER_SENSE_RESISTOR 10
#define CONFIG_CHARGER_DISCHARGE_ON_AC
#define CONFIG_USB_CHARGER

/* Common battery defines */
#define CONFIG_BATTERY_CUT_OFF
#define CONFIG_BATTERY_DEVICE_CHEMISTRY  "LION"
/* TODO(b/74427009): Ensure this works in dead battery conditions */
#define CONFIG_BATTERY_HW_PRESENT_CUSTOM
#define CONFIG_BATTERY_PRESENT_CUSTOM
#define CONFIG_BATTERY_REVIVE_DISCONNECT
#define CONFIG_BATTERY_SMART

/*******************************************************************************
 * USB-C Configs
 * Automatically defined by VARIANT_OCTOPUS_EC_ variant.
 */

 /*
  * Variant USBC defines. Pick one:
  * VARIANT_OCTOPUS_USBC_STANDALONE_TCPCS
  * VARIANT_OCTOPUS_USBC_ITE_EC_TCPCS (requires)
  */
#if defined(VARIANT_OCTOPUS_USBC_STANDALONE_TCPCS)
	/*
	 * TODO(b/77544959): This mode doe not work with ANX7447 currently and
	 * floods the EC console with low power mode messages.
	 */
	#undef CONFIG_USB_PD_TCPC_LOW_POWER
	#undef CONFIG_USB_PD_DUAL_ROLE_AUTO_TOGGLE
	#define CONFIG_USB_PD_TCPM_ANX7447	/* C0 TCPC: ANX7447QN */
	#define CONFIG_USB_PD_TCPM_ANX7447_OCM_ERASE_COMMAND
	#define CONFIG_USB_PD_TCPM_PS8751	/* C1 TCPC: PS8751 */
	#define CONFIG_USB_PD_VBUS_DETECT_TCPC
	#define CONFIG_USBC_PPC_NX20P3483
#elif defined(VARIANT_OCTOPUS_USBC_ITE_EC_TCPCS)
	#undef CONFIG_USB_PD_TCPC_LOW_POWER
	#undef CONFIG_USB_PD_DUAL_ROLE_AUTO_TOGGLE
	#define CONFIG_USB_PD_VBUS_DETECT_PPC
	#define CONFIG_USB_PD_TCPM_ITE83XX	/* C0 & C1 TCPC: ITE EC */
	#define CONFIG_USB_MUX_IT5205		/* C0 MUX: IT5205 */
	#define CONFIG_USB_PD_TCPM_PS8751	/* C1 Mux: PS8751 */
	#define CONFIG_USB_PD_TCPM_TCPCI_MUX_ONLY
	#define CONFIG_USBC_PPC_SN5S330		/* C0 & C1 PPC: each SN5S330 */
	#define CONFIG_USBC_PPC_VCONN
#else
	#error Must define a VARIANT_OCTOPUS_USBC
#endif /* VARIANT_OCTOPUS_USBC */

/* Common USB-C defines */
#define CONFIG_USB_POWER_DELIVERY
#define CONFIG_USB_PD_PORT_COUNT 2
#define CONFIG_USB_PD_MAX_SINGLE_SOURCE_CURRENT TYPEC_RP_3A0
#define CONFIG_USB_PD_DUAL_ROLE
#define CONFIG_USB_PD_LOGGING
#define CONFIG_USB_PD_ALT_MODE
#define CONFIG_USB_PD_ALT_MODE_DFP
#define CONFIG_USB_PD_COMM_LOCKED
#define CONFIG_USB_PD_DISCHARGE_PPC
#define CONFIG_USB_PD_TRY_SRC
#define CONFIG_USBC_SS_MUX
#define CONFIG_USBC_VCONN
#define CONFIG_USBC_VCONN_SWAP
#define CONFIG_USB_PD_VBUS_MEASURE_ADC_EACH_PORT
#define CONFIG_USB_PD_TCPM_MUX
#define CONFIG_USB_PD_TCPM_TCPCI
#define CONFIG_BC12_DETECT_BQ24392
#define CONFIG_CMD_PD_CONTROL
#define CONFIG_CMD_PPC_DUMP

/* TODO(b/76218141): Use correct PD delay values */
#define PD_POWER_SUPPLY_TURN_ON_DELAY	30000	/* us */
#define PD_POWER_SUPPLY_TURN_OFF_DELAY	250000	/* us */
#define PD_VCONN_SWAP_DELAY		5000	/* us */

/* TODO(b/76218141): Use correct PD power values */
#define PD_OPERATING_POWER_MW	15000
#define PD_MAX_POWER_MW		45000
#define PD_MAX_CURRENT_MA	3000
#define PD_MAX_VOLTAGE_MV	20000

/*******************************************************************************
 * USB-A Configs
 */

 /* Common USB-A defines */
#define CONFIG_USB_PORT_POWER_DUMB
#define USB_PORT_COUNT 2

/*******************************************************************************
 * SoC / PCH Config
 */

 /* Common SoC / PCH defines */
#define CONFIG_CHIPSET_GEMINILAKE
#define CONFIG_CHIPSET_RESET_HOOK
#define CONFIG_HOSTCMD_ESPI
/* TODO(b/74123961): Enable Virtual Wires after bringup */
#define CONFIG_POWER_COMMON
#define CONFIG_POWER_S0IX
#define CONFIG_POWER_TRACK_HOST_SLEEP_STATE
#define CONFIG_POWER_BUTTON
#define CONFIG_POWER_BUTTON_X86
#define CONFIG_POWER_PP5000_CONTROL
#define CONFIG_EXTPOWER_GPIO

/*******************************************************************************
 * Keyboard Config
 */

/* Common Keyboard Defines */
#define CONFIG_CMD_KEYBOARD
#define CONFIG_KEYBOARD_BOARD_CONFIG
#define CONFIG_KEYBOARD_PROTOCOL_8042
#define CONFIG_KEYBOARD_COL2_INVERTED
#define CONFIG_KEYBOARD_PWRBTN_ASSERTS_KSI2

#ifndef __ASSEMBLER__

enum power_signal {
#ifdef CONFIG_POWER_S0IX
	X86_SLP_S0_N,		/* PCH  -> SLP_S0_L */
#endif
	X86_SLP_S3_N,		/* PCH  -> SLP_S3_L */
	X86_SLP_S4_N,		/* PCH  -> SLP_S4_L */
	X86_SUSPWRDNACK,	/* PCH  -> SUSPWRDNACK */

	X86_ALL_SYS_PG,		/* PMIC -> PMIC_EC_PWROK_OD */
	X86_RSMRST_N,		/* PMIC -> PMIC_EC_RSMRST_ODL */
	X86_PGOOD_PP3300,	/* PMIC -> PP3300_PG_OD */
	X86_PGOOD_PP5000,	/* PMIC -> PP5000_PG_OD */

	/* Number of X86 signals */
	POWER_SIGNAL_COUNT
};

/* Forward declare common (within octopus) board-specific functions */
void board_reset_pd_mcu(void);

#ifdef VARIANT_OCTOPUS_USBC_ITE_EC_TCPCS
void board_pd_vconn_ctrl(int port, int cc_pin, int enabled);
#endif

#endif /* !__ASSEMBLER__ */

#endif /* __CROS_EC_BASEBOARD_H */
