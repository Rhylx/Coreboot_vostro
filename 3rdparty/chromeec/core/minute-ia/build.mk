# -*- makefile -*-
# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
#
# Minute-IA core build
#

# Select Minute-IA bare-metal toolchain
$(call set-option,CROSS_COMPILE,$(CROSS_COMPILE_i386),i686-pc-linux-gnu-)

# FPU compilation flags
CFLAGS_FPU-$(CONFIG_FPU)=

# CPU specific compilation flags
CFLAGS_CPU+=-fno-omit-frame-pointer -mno-accumulate-outgoing-args	\
	    -ffunction-sections -fdata-sections				\
	    -fno-builtin-printf -fno-builtin-sprintf			\
	    -fno-stack-protector -gdwarf-2  -fno-common -ffreestanding	\
	    -minline-all-stringops -fno-strict-aliasing

CFLAGS_CPU+=$(CFLAGS_FPU-y)

ifneq ($(CONFIG_LTO),)
CFLAGS_CPU+=-flto
LDFLAGS_EXTRA+=-flto
endif

core-y=cpu.o init.o interrupts.o atomic.o
core-$(CONFIG_COMMON_PANIC_OUTPUT)+=panic.o
core-$(CONFIG_COMMON_RUNTIME)+=switch.o task.o
core-$(CONFIG_MPU)+=mpu.o
