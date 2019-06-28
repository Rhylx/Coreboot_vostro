# -*- makefile -*-
# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# ISH chip specific files build
#

# ISH SoC has a Minute-IA core
CORE:=minute-ia
# Allow the i486 instruction set
CFLAGS_CPU+=-march=pentium -mtune=i486 -m32

ifeq ($(CONFIG_LTO),y)
# Re-include the core's build.mk file so we can remove the lto flag.
include core/$(CORE)/build.mk
endif

# Required chip modules
chip-y+=clock.o gpio.o system.o hwtimer.o uart.o flash.o
chip-$(CONFIG_I2C)+=i2c.o
chip-$(CONFIG_HOSTCMD_LPC)+=ipc.o
chip-$(CONFIG_WATCHDOG)+=watchdog.o

# location of the scripts and keys used to pack the SPI flash image
SCRIPTDIR:=./chip/${CHIP}/util

# Allow SPI size to be overridden by board specific size, default to 256KB.
CHIP_SPI_SIZE_KB?=256

$(out)/$(PROJECT).bin:
