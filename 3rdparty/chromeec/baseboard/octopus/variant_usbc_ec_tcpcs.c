/* Copyright 2018 The Chromium OS Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

/* Common code for VARIANT_OCTOPUS_USBC_EC_TCPCS configuration */

#include "charge_state.h"
#include "common.h"
#include "console.h"
#include "driver/ppc/sn5s330.h"
#include "driver/tcpm/it83xx_pd.h"
#include "driver/usb_mux_it5205.h"
#include "driver/tcpm/ps8xxx.h"
#include "driver/tcpm/tcpci.h"
#include "driver/tcpm/tcpm.h"
#include "gpio.h"
#include "hooks.h"
#include "system.h"
#include "tcpci.h"
#include "usb_mux.h"
#include "usbc_ppc.h"
#include "util.h"

#define USB_PD_PORT_ITE_0	0
#define USB_PD_PORT_ITE_1	1

/******************************************************************************/
/* USB-C TPCP Configuration */
const struct tcpc_config_t tcpc_config[CONFIG_USB_PD_PORT_COUNT] = {
	[USB_PD_PORT_ITE_0] = {
		/* TCPC is embedded within EC so no i2c config needed */
		.drv = &it83xx_tcpm_drv,
		.pol = TCPC_ALERT_ACTIVE_LOW,
	},
	[USB_PD_PORT_ITE_1] = {
		/* TCPC is embedded within EC so no i2c config needed */
		.drv = &it83xx_tcpm_drv,
		.pol = TCPC_ALERT_ACTIVE_LOW,
	},
};

/******************************************************************************/
/* USB-C MUX Configuration */

/* TODO(crbug.com/826441): Consolidate this logic with other impls */
static void board_it83xx_hpd_status(int port, int hpd_lvl, int hpd_irq)
{
	enum gpio_signal gpio = port ?
		GPIO_USB_C1_HPD_1V8_ODL : GPIO_USB_C0_HPD_1V8_ODL;

	/* Invert HPD level since GPIOs are active low. */
	hpd_lvl = !hpd_lvl;

	gpio_set_level(gpio, hpd_lvl);
	if (hpd_irq) {
		gpio_set_level(gpio, 1);
		msleep(1);
		gpio_set_level(gpio, hpd_lvl);
	}
}

struct usb_mux usb_muxes[CONFIG_USB_PD_PORT_COUNT] = {
	[USB_PD_PORT_ITE_0] = {
		/* Driver uses I2C_PORT_USB_MUX as I2C port */
		.port_addr = IT5205_I2C_ADDR1,
		.driver = &it5205_usb_mux_driver,
		.hpd_update = &board_it83xx_hpd_status,
	},
	[USB_PD_PORT_ITE_1] = {
		/* Use PS8751 as mux only */
		.port_addr = MUX_PORT_AND_ADDR(
			I2C_PORT_USBC1, PS8751_I2C_ADDR1),
		.driver = &tcpci_tcpm_usb_mux_driver,
		.hpd_update = &board_it83xx_hpd_status,
	}
};

/******************************************************************************/
/* USB-C PPC Configuration */
const struct ppc_config_t ppc_chips[CONFIG_USB_PD_PORT_COUNT] = {
	[USB_PD_PORT_ITE_0] = {
		.i2c_port = I2C_PORT_USBC0,
		.i2c_addr = SN5S330_ADDR0,
		.drv = &sn5s330_drv
	},
	[USB_PD_PORT_ITE_1] = {
		.i2c_port = I2C_PORT_USBC1,
		.i2c_addr = SN5S330_ADDR0,
		.drv = &sn5s330_drv
	},
};
const unsigned int ppc_cnt = ARRAY_SIZE(ppc_chips);

/******************************************************************************/
/* Power Delivery and charing functions */

void variant_tcpc_init(void)
{
	/* Enable PPC interrupts. */
	gpio_enable_interrupt(GPIO_USB_C0_PD_INT_ODL);
	gpio_enable_interrupt(GPIO_USB_C1_PD_INT_ODL);
}
/* Called after the baseboard_tcpc_init (via +2) */
DECLARE_HOOK(HOOK_INIT, variant_tcpc_init, HOOK_PRIO_INIT_I2C + 2);

uint16_t tcpc_get_alert_status(void)
{
	/*
	 * Since C0/C1 TCPC are embedded within EC, we don't need the PDCMD
	 * tasks.The (embedded) TCPC status since chip driver code will
	 * handles its own interrupts and forward the correct events to
	 * the PD_C0 task. See it83xx/intc.c
	 */
	return 0;
}

/**
 * Reset all system PD/TCPC MCUs -- currently only called from
 * handle_pending_reboot() in common/power.c just before hard
 * resetting the system. This logic is likely not needed as the
 * PP3300_A rail should be dropped on EC reset.
 */
void board_reset_pd_mcu(void)
{
	/*
	 * C0 & C1: The internal TCPC on ITE EC does not have a reset signal,
	 * but it will get reset when the EC gets reset.
	 */
}

void board_pd_vconn_ctrl(int port, int cc_pin, int enabled)
{
	/*
	 * We ignore the cc_pin because the polarity should already be set
	 * correctly in the PPC driver via the pd state machine.
	 */
	if (ppc_set_vconn(port, enabled) != EC_SUCCESS)
		cprints(CC_USBPD, "C%d: Failed %sabling vconn",
			port, enabled ? "en" : "dis");
}
