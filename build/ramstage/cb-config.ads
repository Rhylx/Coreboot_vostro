package CB.Config is

   --
   -- Automatically generated file; DO NOT EDIT.
   -- coreboot configuration
   --
   --
   -- General setup
   --
   COREBOOT_BUILD                                 : constant boolean := true;
   LOCALVERSION                                   : constant string  := "";
   CBFS_PREFIX                                    : constant string  := "fallback";
   COMPILER_GCC                                   : constant boolean := true;
   COMPILER_LLVM_CLANG                            : constant boolean := false;
   ANY_TOOLCHAIN                                  : constant boolean := false;
   CCACHE                                         : constant boolean := false;
   FMD_GENPARSER                                  : constant boolean := false;
   UTIL_GENPARSER                                 : constant boolean := false;
   COMPRESS_RAMSTAGE                              : constant boolean := true;
   INCLUDE_CONFIG_FILE                            : constant boolean := true;
   COLLECT_TIMESTAMPS                             : constant boolean := true;
   TIMESTAMPS_ON_CONSOLE                          : constant boolean := false;
   USE_BLOBS                                      : constant boolean := true;
   USE_AMD_BLOBS                                  : constant boolean := false;
   COVERAGE                                       : constant boolean := false;
   UBSAN                                          : constant boolean := false;
   RELOCATABLE_RAMSTAGE                           : constant boolean := true;
   NO_STAGE_CACHE                                 : constant boolean := false;
   TSEG_STAGE_CACHE                               : constant boolean := true;
   UPDATE_IMAGE                                   : constant boolean := false;
   BOOTSPLASH_IMAGE                               : constant boolean := false;
   --
   -- Mainboard
   --
   --
   -- Important: Run 'make distclean' before switching boards
   --
   VENDOR_ADLINK                                  : constant boolean := false;
   VENDOR_AMD                                     : constant boolean := false;
   VENDOR_AOPEN                                   : constant boolean := false;
   VENDOR_APPLE                                   : constant boolean := false;
   VENDOR_ASROCK                                  : constant boolean := false;
   VENDOR_ASUS                                    : constant boolean := false;
   VENDOR_BAP                                     : constant boolean := false;
   VENDOR_BIOSTAR                                 : constant boolean := false;
   VENDOR_CAVIUM                                  : constant boolean := false;
   VENDOR_COMPULAB                                : constant boolean := false;
   VENDOR_DELL                                    : constant boolean := true;
   VENDOR_ELMEX                                   : constant boolean := false;
   VENDOR_EMULATION                               : constant boolean := false;
   VENDOR_FACEBOOK                                : constant boolean := false;
   VENDOR_FOXCONN                                 : constant boolean := false;
   VENDOR_GETAC                                   : constant boolean := false;
   VENDOR_GIGABYTE                                : constant boolean := false;
   VENDOR_GIZMOSPHERE                             : constant boolean := false;
   VENDOR_GOOGLE                                  : constant boolean := false;
   VENDOR_HP                                      : constant boolean := false;
   VENDOR_IBASE                                   : constant boolean := false;
   VENDOR_INTEL                                   : constant boolean := false;
   VENDOR_JETWAY                                  : constant boolean := false;
   VENDOR_KONTRON                                 : constant boolean := false;
   VENDOR_LENOVO                                  : constant boolean := false;
   VENDOR_LIPPERT                                 : constant boolean := false;
   VENDOR_MSI                                     : constant boolean := false;
   VENDOR_OPENCELLULAR                            : constant boolean := false;
   VENDOR_PACKARDBELL                             : constant boolean := false;
   VENDOR_PCENGINES                               : constant boolean := false;
   VENDOR_PORTWELL                                : constant boolean := false;
   VENDOR_PURISM                                  : constant boolean := false;
   VENDOR_RAZER                                   : constant boolean := false;
   VENDOR_RODA                                    : constant boolean := false;
   VENDOR_SAMSUNG                                 : constant boolean := false;
   VENDOR_SAPPHIRE                                : constant boolean := false;
   VENDOR_SCALEWAY                                : constant boolean := false;
   VENDOR_SIEMENS                                 : constant boolean := false;
   VENDOR_SIFIVE                                  : constant boolean := false;
   VENDOR_SUPERMICRO                              : constant boolean := false;
   VENDOR_SYSTEM76                                : constant boolean := false;
   VENDOR_TI                                      : constant boolean := false;
   VENDOR_UP                                      : constant boolean := false;
   MAINBOARD_VENDOR                               : constant string  := "Dell Inc.";
   BOARD_SPECIFIC_OPTIONS                         : constant boolean := true;
   MAINBOARD_DIR                                  : constant string  := "dell/dell_system_vostro_3360";
   MAINBOARD_PART_NUMBER                          : constant string  := "Dell System Vostro 3360";
   MAX_CPUS                                       : constant         := 8;
   ONBOARD_VGA_IS_PRIMARY                         : constant boolean := false;
   DIMM_SPD_SIZE                                  : constant         := 256;
   VGA_BIOS                                       : constant boolean := false;
   VGA_BIOS_ID                                    : constant string  := "8086,0156";
   MAINBOARD_SERIAL_NUMBER                        : constant string  := "123456789";
   VGA_BIOS_FILE                                  : constant string  := "pci8086,0156.rom";
   C_ENV_BOOTBLOCK_SIZE                           : constant         := 16#0001_0000#;
   MAINBOARD_SMBIOS_MANUFACTURER                  : constant string  := "Dell Inc.";
   DRAM_RESET_GATE_GPIO                           : constant         := 60;
   DEVICETREE                                     : constant string  := "devicetree.cb";
   PRERAM_CBMEM_CONSOLE_SIZE                      : constant         := 16#0c00#;
   CBFS_SIZE                                      : constant         := 16#0040_0000#;
   POST_IO                                        : constant boolean := true;
   USBDEBUG_HCD_INDEX                             : constant         := 2;
   OVERRIDE_DEVICETREE                            : constant string  := "";
   BOOT_DEVICE_SPI_FLASH_BUS                      : constant         := 0;
   UART_FOR_CONSOLE                               : constant         := 0;
   FMDFILE                                        : constant string  := "";
   BOARD_DELL_DELL_SYSTEM_VOSTRO_3360             : constant boolean := true;
   VBOOT                                          : constant boolean := false;
   DCACHE_RAM_BASE                                : constant         := 16#fefe_0000#;
   DCACHE_RAM_SIZE                                : constant         := 16#0002_0000#;
   DCACHE_BSP_STACK_SIZE                          : constant         := 16#0001_0000#;
   MMCONF_BASE_ADDRESS                            : constant         := 16#f000_0000#;
   HAVE_INTEL_FIRMWARE                            : constant boolean := true;
   MRC_SETTINGS_CACHE_SIZE                        : constant         := 16#0001_0000#;
   SPI_FLASH_INCLUDE_ALL_DRIVERS                  : constant boolean := true;
   SPI_FLASH_WINBOND                              : constant boolean := true;
   DRIVERS_INTEL_WIFI                             : constant boolean := true;
   DIMM_MAX                                       : constant         := 4;
   MAINBOARD_SMBIOS_PRODUCT_NAME                  : constant string  := "Dell System Vostro 3360";
   HAVE_IFD_BIN                                   : constant boolean := false;
   MAINBOARD_VERSION                              : constant string  := "1.0";
   DRIVERS_PS2_KEYBOARD                           : constant boolean := false;
   DRIVERS_UART_8250IO                            : constant boolean := true;
   PCIEXP_L1_SUB_STATE                            : constant boolean := false;
   NO_POST                                        : constant boolean := false;
   SMBIOS_ENCLOSURE_TYPE                          : constant         := 16#0003#;
   HEAP_SIZE                                      : constant         := 16#4000#;
   CONSOLE_POST                                   : constant boolean := false;
   POST_DEVICE                                    : constant boolean := true;
   SUBSYSTEM_VENDOR_ID                            : constant         := 16#0000#;
   SUBSYSTEM_DEVICE_ID                            : constant         := 16#0000#;
   BOARD_ROMSIZE_KB_8192                          : constant boolean := true;
   COREBOOT_ROMSIZE_KB_64                         : constant boolean := false;
   COREBOOT_ROMSIZE_KB_128                        : constant boolean := false;
   COREBOOT_ROMSIZE_KB_256                        : constant boolean := false;
   COREBOOT_ROMSIZE_KB_512                        : constant boolean := false;
   COREBOOT_ROMSIZE_KB_1024                       : constant boolean := false;
   COREBOOT_ROMSIZE_KB_2048                       : constant boolean := false;
   COREBOOT_ROMSIZE_KB_4096                       : constant boolean := false;
   COREBOOT_ROMSIZE_KB_5120                       : constant boolean := false;
   COREBOOT_ROMSIZE_KB_6144                       : constant boolean := false;
   COREBOOT_ROMSIZE_KB_8192                       : constant boolean := true;
   COREBOOT_ROMSIZE_KB_10240                      : constant boolean := false;
   COREBOOT_ROMSIZE_KB_12288                      : constant boolean := false;
   COREBOOT_ROMSIZE_KB_16384                      : constant boolean := false;
   COREBOOT_ROMSIZE_KB_32768                      : constant boolean := false;
   COREBOOT_ROMSIZE_KB_65536                      : constant boolean := false;
   COREBOOT_ROMSIZE_KB                            : constant         := 8192;
   ROM_SIZE                                       : constant         := 16#0080_0000#;
   HAVE_POWER_STATE_AFTER_FAILURE                 : constant boolean := true;
   HAVE_POWER_STATE_PREVIOUS_AFTER_FAILURE        : constant boolean := true;
   POWER_STATE_OFF_AFTER_FAILURE                  : constant boolean := true;
   POWER_STATE_ON_AFTER_FAILURE                   : constant boolean := false;
   POWER_STATE_PREVIOUS_AFTER_FAILURE             : constant boolean := false;
   MAINBOARD_POWER_FAILURE_STATE                  : constant         := 0;
   SYSTEM_TYPE_LAPTOP                             : constant boolean := false;
   SYSTEM_TYPE_TABLET                             : constant boolean := false;
   SYSTEM_TYPE_DETACHABLE                         : constant boolean := false;
   SYSTEM_TYPE_CONVERTIBLE                        : constant boolean := false;
   CBFS_AUTOGEN_ATTRIBUTES                        : constant boolean := false;
   --
   -- Chipset
   --
   --
   -- SoC
   --
   CPU_SPECIFIC_OPTIONS                           : constant boolean := true;
   HAVE_BOOTBLOCK                                 : constant boolean := true;
   CPU_ADDR_BITS                                  : constant         := 36;
   EHCI_BAR                                       : constant         := 16#fef0_0000#;
   SERIRQ_CONTINUOUS_MODE                         : constant boolean := true;
   SMM_TSEG_SIZE                                  : constant         := 16#0080_0000#;
   SMM_RESERVED_SIZE                              : constant         := 16#0010_0000#;
   SMM_MODULE_STACK_SIZE                          : constant         := 16#0400#;
   ACPI_CPU_STRING                                : constant string  := "\\_PR.CP%02d";
   SOC_CAVIUM_CN81XX                              : constant boolean := false;
   ARCH_ARMV8_EXTENSION                           : constant         := 0;
   STACK_SIZE                                     : constant         := 16#1000#;
   SOC_CAVIUM_COMMON                              : constant boolean := false;
   SOC_INTEL_GLK                                  : constant boolean := false;
   X86_TOP4G_BOOTMEDIA_MAP                        : constant boolean := true;
   ROMSTAGE_ADDR                                  : constant         := 16#0200_0000#;
   VERSTAGE_ADDR                                  : constant         := 16#0200_0000#;
   DCACHE_RAM_MRC_VAR_SIZE                        : constant         := 16#0000#;
   PCIEXP_ASPM                                    : constant boolean := true;
   PCIEXP_COMMON_CLOCK                            : constant boolean := true;
   PCIEXP_CLK_PM                                  : constant boolean := false;
   IED_REGION_SIZE                                : constant         := 16#0040_0000#;
   TTYS0_BASE                                     : constant         := 16#03f8#;
   TTYS0_LCS                                      : constant         := 3;
   UART_PCI_ADDR                                  : constant         := 16#0000#;
   SOC_MEDIATEK_MT8173                            : constant boolean := false;
   SOC_MEDIATEK_MT8183                            : constant boolean := false;
   SOC_NVIDIA_TEGRA124                            : constant boolean := false;
   SOC_NVIDIA_TEGRA210                            : constant boolean := false;
   SOC_QUALCOMM_COMMON                            : constant boolean := false;
   SOC_QC_IPQ40XX                                 : constant boolean := false;
   SOC_QC_IPQ806X                                 : constant boolean := false;
   SOC_QUALCOMM_QCS405                            : constant boolean := false;
   SOC_QUALCOMM_SC7180                            : constant boolean := false;
   SOC_QUALCOMM_SDM845                            : constant boolean := false;
   SOC_ROCKCHIP_RK3288                            : constant boolean := false;
   SOC_ROCKCHIP_RK3399                            : constant boolean := false;
   CPU_SAMSUNG_EXYNOS5250                         : constant boolean := false;
   CPU_SAMSUNG_EXYNOS5420                         : constant boolean := false;
   SOC_UCB_RISCV                                  : constant boolean := false;
   --
   -- CPU
   --
   CPU_AMD_AGESA                                  : constant boolean := false;
   CPU_AMD_PI                                     : constant boolean := false;
   CPU_ARMLTD_CORTEX_A9                           : constant boolean := false;
   CPU_INTEL_MODEL_206AX                          : constant boolean := true;
   SSE2                                           : constant boolean := true;
   CPU_INTEL_FIRMWARE_INTERFACE_TABLE             : constant boolean := false;
   CPU_INTEL_TURBO_NOT_PACKAGE_SCOPED             : constant boolean := false;
   CPU_INTEL_COMMON                               : constant boolean := true;
   ENABLE_VMX                                     : constant boolean := true;
   SET_IA32_FC_LOCK_BIT                           : constant boolean := true;
   CPU_INTEL_COMMON_TIMEBASE                      : constant boolean := true;
   CPU_INTEL_COMMON_SMM                           : constant boolean := true;
   MICROCODE_UPDATE_PRE_RAM                       : constant boolean := true;
   CPU_TI_AM335X                                  : constant boolean := false;
   PARALLEL_CPU_INIT                              : constant boolean := false;
   PARALLEL_MP                                    : constant boolean := true;
   PARALLEL_MP_AP_WORK                            : constant boolean := false;
   UDELAY_LAPIC                                   : constant boolean := false;
   UDELAY_TSC                                     : constant boolean := true;
   TSC_MONOTONIC_TIMER                            : constant boolean := true;
   TSC_SYNC_LFENCE                                : constant boolean := false;
   TSC_SYNC_MFENCE                                : constant boolean := true;
   NO_FIXED_XIP_ROM_SIZE                          : constant boolean := true;
   LOGICAL_CPUS                                   : constant boolean := true;
   HAVE_SMI_HANDLER                               : constant boolean := true;
   NO_SMM                                         : constant boolean := false;
   SMM_ASEG                                       : constant boolean := false;
   SMM_TSEG                                       : constant boolean := true;
   SMM_MODULE_HEAP_SIZE                           : constant         := 16#4000#;
   SMM_STUB_STACK_SIZE                            : constant         := 16#0400#;
   SMM_LAPIC_REMAP_MITIGATION                     : constant boolean := false;
   SERIALIZED_SMM_INITIALIZATION                  : constant boolean := false;
   X86_AMD_FIXED_MTRRS                            : constant boolean := false;
   X86_AMD_INIT_SIPI                              : constant boolean := false;
   MIRROR_PAYLOAD_TO_RAM_BEFORE_LOADING           : constant boolean := false;
   SOC_SETS_MSRS                                  : constant boolean := false;
   SMP                                            : constant boolean := true;
   MMX                                            : constant boolean := true;
   SSE                                            : constant boolean := true;
   SUPPORT_CPU_UCODE_IN_CBFS                      : constant boolean := true;
   USES_MICROCODE_HEADER_FILES                    : constant boolean := false;
   USE_CPU_MICROCODE_CBFS_BINS                    : constant boolean := true;
   CPU_MICROCODE_CBFS_DEFAULT_BINS                : constant boolean := true;
   CPU_MICROCODE_CBFS_EXTERNAL_BINS               : constant boolean := false;
   CPU_MICROCODE_CBFS_EXTERNAL_HEADER             : constant boolean := false;
   CPU_MICROCODE_CBFS_NONE                        : constant boolean := false;
   --
   -- Northbridge
   --
   NORTHBRIDGE_AMD_AGESA                          : constant boolean := false;
   NORTHBRIDGE_AMD_PI                             : constant boolean := false;
   NORTHBRIDGE_INTEL_SANDYBRIDGE                  : constant boolean := true;
   USE_NATIVE_RAMINIT                             : constant boolean := true;
   NATIVE_RAMINIT_IGNORE_MAX_MEM_FUSES            : constant boolean := false;
   NATIVE_RAMINIT_IGNORE_XMP_MAX_DIMMS            : constant boolean := false;
   --
   -- Southbridge
   --
   AMD_SB_CIMX                                    : constant boolean := false;
   SOUTHBRIDGE_AMD_CIMX_SB800                     : constant boolean := false;
   SOUTHBRIDGE_INTEL_C216                         : constant boolean := true;
   SOUTH_BRIDGE_OPTIONS                           : constant boolean := true;
   HPET_MIN_TICKS                                 : constant         := 16#0080#;
   SOUTHBRIDGE_INTEL_COMMON_RESET                 : constant boolean := true;
   SOUTHBRIDGE_INTEL_COMMON_RTC                   : constant boolean := true;
   SOUTHBRIDGE_INTEL_COMMON_PMCLIB                : constant boolean := true;
   SOUTHBRIDGE_INTEL_COMMON_PMBASE                : constant boolean := true;
   SOUTHBRIDGE_INTEL_COMMON_GPIO                  : constant boolean := true;
   SOUTHBRIDGE_INTEL_COMMON_SMBUS                 : constant boolean := true;
   SOUTHBRIDGE_INTEL_COMMON_SPI                   : constant boolean := true;
   SOUTHBRIDGE_INTEL_COMMON_SPI_ICH7              : constant boolean := false;
   SOUTHBRIDGE_INTEL_COMMON_SPI_ICH9              : constant boolean := true;
   SOUTHBRIDGE_INTEL_COMMON_SPI_SILVERMONT        : constant boolean := false;
   SOUTHBRIDGE_INTEL_COMMON_PIRQ_ACPI_GEN         : constant boolean := true;
   SOUTHBRIDGE_INTEL_COMMON_RCBA_PIRQ             : constant boolean := true;
   HAVE_INTEL_CHIPSET_LOCKDOWN                    : constant boolean := true;
   SOUTHBRIDGE_INTEL_COMMON_SMM                   : constant boolean := true;
   SOUTHBRIDGE_INTEL_COMMON_ACPI_MADT             : constant boolean := true;
   SOUTHBRIDGE_INTEL_COMMON_FINALIZE              : constant boolean := true;
   SOUTHBRIDGE_INTEL_COMMON_USB_DEBUG             : constant boolean := true;
   INTEL_DESCRIPTOR_MODE_CAPABLE                  : constant boolean := true;
   INTEL_DESCRIPTOR_MODE_REQUIRED                 : constant boolean := true;
   VALIDATE_INTEL_DESCRIPTOR                      : constant boolean := false;
   INTEL_CHIPSET_LOCKDOWN                         : constant boolean := true;
   SOUTHBRIDGE_INTEL_COMMON_WATCHDOG              : constant boolean := true;
   LOCK_SPI_FLASH_NONE                            : constant boolean := true;
   LOCK_SPI_FLASH_RO                              : constant boolean := false;
   LOCK_SPI_FLASH_NO_ACCESS                       : constant boolean := false;
   --
   -- Super I/O
   --
   SUPERIO_ASPEED_AST2400                         : constant boolean := false;
   SUPERIO_ASPEED_COMMON_PRE_RAM                  : constant boolean := false;
   SUPERIO_ASPEED_HAS_UART_DELAY_WORKAROUND       : constant boolean := false;
   SUPERIO_FINTEK_FAN_CONTROL                     : constant boolean := false;
   --
   -- Embedded Controllers
   --
   EC_GOOGLE_WILCO                                : constant boolean := false;
   --
   -- Intel Firmware
   --
   MAINBOARD_USES_IFD_GBE_REGION                  : constant boolean := false;
   MAINBOARD_USES_IFD_EC_REGION                   : constant boolean := false;
   DO_NOT_TOUCH_DESCRIPTOR_REGION                 : constant boolean := false;
   LOCK_MANAGEMENT_ENGINE                         : constant boolean := false;
   UNLOCK_FLASH_REGIONS                           : constant boolean := true;
   CAVIUM_BDK                                     : constant boolean := false;
   MAINBOARD_HAS_CHROMEOS                         : constant boolean := false;
   GOOGLE_SMBIOS_MAINBOARD_VERSION                : constant boolean := false;
   UEFI_2_4_BINDING                               : constant boolean := false;
   UDK_2015_BINDING                               : constant boolean := false;
   UDK_2017_BINDING                               : constant boolean := false;
   USE_SIEMENS_HWILIB                             : constant boolean := false;
   ARM_LPAE                                       : constant boolean := false;
   ARCH_X86                                       : constant boolean := true;
   ARCH_BOOTBLOCK_X86_32                          : constant boolean := true;
   ARCH_VERSTAGE_X86_32                           : constant boolean := true;
   ARCH_ROMSTAGE_X86_32                           : constant boolean := true;
   ARCH_POSTCAR_X86_32                            : constant boolean := true;
   ARCH_RAMSTAGE_X86_32                           : constant boolean := true;
   ARCH_POSTCAR_X86_64                            : constant boolean := false;
   USE_MARCH_586                                  : constant boolean := false;
   AP_IN_SIPI_WAIT                                : constant boolean := false;
   X86_RESET_VECTOR                               : constant         := 16#ffff_fff0#;
   SIPI_VECTOR_IN_ROM                             : constant boolean := false;
   RAMBASE                                        : constant         := 16#00e0_0000#;
   RAMTOP                                         : constant         := 16#0100_0000#;
   NUM_IPI_STARTS                                 : constant         := 2;
   CBMEM_TOP_BACKUP                               : constant boolean := false;
   PC80_SYSTEM                                    : constant boolean := true;
   BOOTBLOCK_DEBUG_SPINLOOP                       : constant boolean := false;
   IOAPIC_INTERRUPTS_ON_FSB                       : constant boolean := true;
   IOAPIC_INTERRUPTS_ON_APIC_SERIAL_BUS           : constant boolean := false;
   HPET_ADDRESS_OVERRIDE                          : constant boolean := false;
   HPET_ADDRESS                                   : constant         := 16#fed0_0000#;
   ID_SECTION_OFFSET                              : constant         := 16#0080#;
   POSTCAR_STAGE                                  : constant boolean := true;
   VERSTAGE_DEBUG_SPINLOOP                        : constant boolean := false;
   ROMSTAGE_DEBUG_SPINLOOP                        : constant boolean := false;
   BOOTBLOCK_SIMPLE                               : constant boolean := true;
   BOOTBLOCK_NORMAL                               : constant boolean := false;
   ACPI_HAVE_PCAT_8259                            : constant boolean := true;
   COLLECT_TIMESTAMPS_NO_TSC                      : constant boolean := false;
   COLLECT_TIMESTAMPS_TSC                         : constant boolean := true;
   PAGING_IN_CACHE_AS_RAM                         : constant boolean := false;
   IDT_IN_EVERY_STAGE                             : constant boolean := false;
   HAVE_CF9_RESET                                 : constant boolean := true;
   PIRQ_ROUTE                                     : constant boolean := false;
   --
   -- Devices
   --
   HAVE_VGA_TEXT_FRAMEBUFFER                      : constant boolean := true;
   HAVE_LINEAR_FRAMEBUFFER                        : constant boolean := true;
   MAINBOARD_HAS_NATIVE_VGA_INIT                  : constant boolean := false;
   MAINBOARD_FORCE_NATIVE_VGA_INIT                : constant boolean := false;
   MAINBOARD_HAS_LIBGFXINIT                       : constant boolean := true;
   MAINBOARD_USE_LIBGFXINIT                       : constant boolean := true;
   VGA_ROM_RUN                                    : constant boolean := false;
   NO_GFX_INIT                                    : constant boolean := false;
   MULTIPLE_VGA_ADAPTERS                          : constant boolean := false;
   --
   -- Display
   --
   VGA_TEXT_FRAMEBUFFER                           : constant boolean := false;
   GENERIC_LINEAR_FRAMEBUFFER                     : constant boolean := true;
   LINEAR_FRAMEBUFFER                             : constant boolean := true;
   BOOTSPLASH                                     : constant boolean := false;
   LINEAR_FRAMEBUFFER_MAX_WIDTH                   : constant         := 2560;
   LINEAR_FRAMEBUFFER_MAX_HEIGHT                  : constant         := 1600;
   PCI                                            : constant boolean := true;
   NO_MMCONF_SUPPORT                              : constant boolean := false;
   MMCONF_SUPPORT                                 : constant boolean := true;
   HYPERTRANSPORT_PLUGIN_SUPPORT                  : constant boolean := false;
   HT_CHAIN_UNITID_BASE                           : constant         := 0;
   HT_CHAIN_END_UNITID_BASE                       : constant         := 0;
   PCIX_PLUGIN_SUPPORT                            : constant boolean := true;
   CARDBUS_PLUGIN_SUPPORT                         : constant boolean := true;
   AZALIA_PLUGIN_SUPPORT                          : constant boolean := false;
   PCIEXP_PLUGIN_SUPPORT                          : constant boolean := true;
   PCIEXP_HOTPLUG                                 : constant boolean := false;
   EARLY_PCI_BRIDGE                               : constant boolean := false;
   INTEL_GMA_ADD_VBT                              : constant boolean := false;
   SOFTWARE_I2C                                   : constant boolean := false;
   --
   -- Generic Drivers
   --
   DRIVERS_AS3722_RTC                             : constant boolean := false;
   CRB_TPM_BASE_ADDRESS                           : constant         := 16#fed4_0000#;
   MAINBOARD_HAS_CRB_TPM                          : constant boolean := false;
   ELOG                                           : constant boolean := false;
   GIC                                            : constant boolean := false;
   IPMI_KCS                                       : constant boolean := false;
   DRIVERS_LENOVO_WACOM                           : constant boolean := false;
   CACHE_MRC_SETTINGS                             : constant boolean := true;
   MRC_SETTINGS_PROTECT                           : constant boolean := false;
   HAS_RECOVERY_MRC_CACHE                         : constant boolean := false;
   MRC_CLEAR_NORMAL_CACHE_ON_RECOVERY_RETRAIN     : constant boolean := false;
   MRC_SETTINGS_VARIABLE_DATA                     : constant boolean := false;
   MRC_WRITE_NV_LATE                              : constant boolean := false;
   RT8168_GET_MAC_FROM_VPD                        : constant boolean := false;
   RT8168_SET_LED_MODE                            : constant boolean := false;
   SMMSTORE                                       : constant boolean := false;
   SMMSTORE_IN_CBFS                               : constant boolean := false;
   SPI_FLASH                                      : constant boolean := true;
   SPI_SDCARD                                     : constant boolean := false;
   BOOT_DEVICE_SPI_FLASH_RW_NOMMAP                : constant boolean := true;
   BOOT_DEVICE_SPI_FLASH_RW_NOMMAP_EARLY          : constant boolean := false;
   SPI_FLASH_DONT_INCLUDE_ALL_DRIVERS             : constant boolean := false;
   SPI_FLASH_NO_FAST_READ                         : constant boolean := false;
   SPI_FLASH_ADESTO                               : constant boolean := true;
   SPI_FLASH_AMIC                                 : constant boolean := true;
   SPI_FLASH_ATMEL                                : constant boolean := true;
   SPI_FLASH_EON                                  : constant boolean := true;
   SPI_FLASH_GIGADEVICE                           : constant boolean := true;
   SPI_FLASH_MACRONIX                             : constant boolean := true;
   SPI_FLASH_SPANSION                             : constant boolean := true;
   SPI_FLASH_SST                                  : constant boolean := true;
   SPI_FLASH_STMICRO                              : constant boolean := true;
   SPI_FLASH_HAS_VOLATILE_GROUP                   : constant boolean := false;
   HAVE_SPI_CONSOLE_SUPPORT                       : constant boolean := false;
   DRIVERS_UART                                   : constant boolean := true;
   DRIVERS_UART_8250IO_SKIP_INIT                  : constant boolean := false;
   NO_UART_ON_SUPERIO                             : constant boolean := false;
   UART_OVERRIDE_INPUT_CLOCK_DIVIDER              : constant boolean := false;
   UART_OVERRIDE_REFCLK                           : constant boolean := false;
   DRIVERS_UART_8250MEM                           : constant boolean := false;
   DRIVERS_UART_8250MEM_32                        : constant boolean := false;
   HAVE_UART_SPECIAL                              : constant boolean := false;
   DRIVERS_UART_OXPCIE                            : constant boolean := false;
   DRIVERS_UART_PL011                             : constant boolean := false;
   UART_USE_REFCLK_AS_INPUT_CLOCK                 : constant boolean := false;
   HAVE_USBDEBUG                                  : constant boolean := true;
   HAVE_USBDEBUG_OPTIONS                          : constant boolean := true;
   USBDEBUG                                       : constant boolean := false;
   VPD                                            : constant boolean := false;
   DRIVERS_GENERIC_WIFI                           : constant boolean := true;
   USE_SAR                                        : constant boolean := false;
   DRIVERS_AMD_PI                                 : constant boolean := false;
   DRIVERS_GENERIC_CBFS_SERIAL                    : constant boolean := false;
   DRIVERS_GENERIC_GFX                            : constant boolean := false;
   DRIVERS_I2C_MAX98373                           : constant boolean := false;
   DRIVERS_I2C_MAX98927                           : constant boolean := false;
   DRIVERS_I2C_PCA9538                            : constant boolean := false;
   DRIVERS_I2C_PCF8523                            : constant boolean := false;
   DRIVERS_I2C_PTN3460                            : constant boolean := false;
   DRIVERS_I2C_RT1011                             : constant boolean := false;
   DRIVERS_I2C_RT5663                             : constant boolean := false;
   DRIVERS_I2C_RTD2132                            : constant boolean := false;
   DRIVERS_I2C_RX6110SA                           : constant boolean := false;
   DRIVERS_I2C_SX9310                             : constant boolean := false;
   MAINBOARD_HAS_I2C_TPM_ATMEL                    : constant boolean := false;
   MAINBOARD_HAS_I2C_TPM_CR50                     : constant boolean := false;
   MAINBOARD_HAS_I2C_TPM_GENERIC                  : constant boolean := false;
   PLATFORM_USES_FSP2_0                           : constant boolean := false;
   PLATFORM_USES_FSP2_1                           : constant boolean := false;
   INTEL_DDI                                      : constant boolean := false;
   INTEL_EDID                                     : constant boolean := false;
   INTEL_INT15                                    : constant boolean := true;
   INTEL_GMA_ACPI                                 : constant boolean := true;
   INTEL_GMA_SSC_ALTERNATE_REF                    : constant boolean := false;
   INTEL_GMA_SWSMISCI                             : constant boolean := false;
   GFX_GMA                                        : constant boolean := true;
   GFX_GMA_INTERNAL_IS_EDP                        : constant boolean := true;
   GFX_GMA_INTERNAL_IS_LVDS                       : constant boolean := false;
   GFX_GMA_DYN_CPU                                : constant boolean := true;
   GFX_GMA_GENERATION                             : constant string  := "Ironlake";
   GFX_GMA_INTERNAL_PORT                          : constant string  := "DP";
   GFX_GMA_ANALOG_I2C_PORT                        : constant string  := "PCH_DAC";
   DRIVER_INTEL_I210                              : constant boolean := false;
   DRIVERS_INTEL_MIPI_CAMERA                      : constant boolean := false;
   HAVE_INTEL_PTT                                 : constant boolean := false;
   DRIVERS_LENOVO_HYBRID_GRAPHICS                 : constant boolean := false;
   DRIVER_MAXIM_MAX77686                          : constant boolean := false;
   DRIVER_PARADE_PS8625                           : constant boolean := false;
   DRIVER_PARADE_PS8640                           : constant boolean := false;
   DRIVERS_MC146818                               : constant boolean := true;
   LPC_TPM                                        : constant boolean := false;
   MAINBOARD_HAS_LPC_TPM                          : constant boolean := false;
   DRIVERS_RICOH_RCE822                           : constant boolean := false;
   DRIVER_SIEMENS_NC_FPGA                         : constant boolean := false;
   NC_FPGA_NOTIFY_CB_READY                        : constant boolean := false;
   DRIVERS_SIL_3114                               : constant boolean := false;
   MAINBOARD_HAS_SPI_TPM_CR50                     : constant boolean := false;
   DRIVER_TI_TPS65090                             : constant boolean := false;
   DRIVERS_TI_TPS65913                            : constant boolean := false;
   DRIVERS_TI_TPS65913_RTC                        : constant boolean := false;
   DRIVERS_USB_ACPI                               : constant boolean := false;
   COMMONLIB_STORAGE                              : constant boolean := false;
   --
   -- Security
   --
   --
   -- Verified Boot (vboot)
   --
   --
   -- Trusted Platform Module
   --
   USER_NO_TPM                                    : constant boolean := true;
   --
   -- Memory initialization
   --
   PLATFORM_HAS_DRAM_CLEAR                        : constant boolean := true;
   SECURITY_CLEAR_DRAM_ON_REGULAR_BOOT            : constant boolean := false;
   ACPI_SATA_GENERATOR                            : constant boolean := true;
   ACPI_INTEL_HARDWARE_SLEEP_VALUES               : constant boolean := true;
   ACPI_AMD_HARDWARE_SLEEP_VALUES                 : constant boolean := false;
   BOOT_DEVICE_NOT_SPI_FLASH                      : constant boolean := false;
   BOOT_DEVICE_SPI_FLASH                          : constant boolean := true;
   BOOT_DEVICE_MEMORY_MAPPED                      : constant boolean := true;
   BOOT_DEVICE_SUPPORTS_WRITES                    : constant boolean := true;
   RTC                                            : constant boolean := true;
   --
   -- Console
   --
   BOOTBLOCK_CONSOLE                              : constant boolean := true;
   POSTCAR_CONSOLE                                : constant boolean := true;
   SQUELCH_EARLY_SMP                              : constant boolean := true;
   CONSOLE_SERIAL                                 : constant boolean := true;
   --
   -- I/O mapped, 8250-compatible
   --
   --
   -- Serial port base address = 0x3f8
   --
   CONSOLE_SERIAL_921600                          : constant boolean := false;
   CONSOLE_SERIAL_460800                          : constant boolean := false;
   CONSOLE_SERIAL_230400                          : constant boolean := false;
   CONSOLE_SERIAL_115200                          : constant boolean := true;
   CONSOLE_SERIAL_57600                           : constant boolean := false;
   CONSOLE_SERIAL_38400                           : constant boolean := false;
   CONSOLE_SERIAL_19200                           : constant boolean := false;
   CONSOLE_SERIAL_9600                            : constant boolean := false;
   TTYS0_BAUD                                     : constant         := 115200;
   SPKMODEM                                       : constant boolean := false;
   CONSOLE_NE2K                                   : constant boolean := false;
   CONSOLE_CBMEM                                  : constant boolean := true;
   CONSOLE_CBMEM_BUFFER_SIZE                      : constant         := 16#0002_0000#;
   CONSOLE_SPI_FLASH                              : constant boolean := false;
   DEFAULT_CONSOLE_LOGLEVEL_8                     : constant boolean := true;
   DEFAULT_CONSOLE_LOGLEVEL_7                     : constant boolean := false;
   DEFAULT_CONSOLE_LOGLEVEL_6                     : constant boolean := false;
   DEFAULT_CONSOLE_LOGLEVEL_5                     : constant boolean := false;
   DEFAULT_CONSOLE_LOGLEVEL_4                     : constant boolean := false;
   DEFAULT_CONSOLE_LOGLEVEL_3                     : constant boolean := false;
   DEFAULT_CONSOLE_LOGLEVEL_2                     : constant boolean := false;
   DEFAULT_CONSOLE_LOGLEVEL_1                     : constant boolean := false;
   DEFAULT_CONSOLE_LOGLEVEL_0                     : constant boolean := false;
   DEFAULT_CONSOLE_LOGLEVEL                       : constant         := 8;
   CMOS_POST                                      : constant boolean := false;
   POST_DEVICE_NONE                               : constant boolean := true;
   POST_DEVICE_LPC                                : constant boolean := false;
   POST_DEVICE_PCI_PCIE                           : constant boolean := false;
   DEFAULT_POST_ON_LPC                            : constant boolean := false;
   POST_IO_PORT                                   : constant         := 16#0080#;
   NO_EARLY_BOOTBLOCK_POSTCODES                   : constant boolean := false;
   HWBASE_DEBUG_CB                                : constant boolean := true;
   HAVE_ACPI_RESUME                               : constant boolean := true;
   DISABLE_ACPI_HIBERNATE                         : constant boolean := false;
   RESUME_PATH_SAME_AS_BOOT                       : constant boolean := true;
   NO_MONOTONIC_TIMER                             : constant boolean := false;
   HAVE_MONOTONIC_TIMER                           : constant boolean := true;
   TIMER_QUEUE                                    : constant boolean := false;
   HAVE_OPTION_TABLE                              : constant boolean := false;
   PCI_IO_CFG_EXT                                 : constant boolean := false;
   IOAPIC                                         : constant boolean := true;
   USE_WATCHDOG_ON_BOOT                           : constant boolean := true;
   GFXUMA                                         : constant boolean := false;
   HAVE_ACPI_TABLES                               : constant boolean := true;
   COMMON_FADT                                    : constant boolean := true;
   ACPI_NHLT                                      : constant boolean := false;
   --
   -- System tables
   --
   GENERATE_MP_TABLE                              : constant boolean := false;
   GENERATE_PIRQ_TABLE                            : constant boolean := false;
   GENERATE_SMBIOS_TABLES                         : constant boolean := true;
   SMBIOS_PROVIDED_BY_MOBO                        : constant boolean := false;
   --
   -- Payload
   --
   PAYLOAD_NONE                                   : constant boolean := false;
   PAYLOAD_ELF                                    : constant boolean := false;
   PAYLOAD_FILO                                   : constant boolean := false;
   PAYLOAD_GRUB2                                  : constant boolean := true;
   PAYLOAD_LINUXBOOT                              : constant boolean := false;
   PAYLOAD_SEABIOS                                : constant boolean := false;
   PAYLOAD_UBOOT                                  : constant boolean := false;
   PAYLOAD_YABITS                                 : constant boolean := false;
   PAYLOAD_LINUX                                  : constant boolean := false;
   PAYLOAD_TIANOCORE                              : constant boolean := false;
   PAYLOAD_FILE                                   : constant string  := "payloads/external/GRUB2/grub2/build/default_payload.elf";
   GRUB2_STABLE                                   : constant boolean := true;
   GRUB2_MASTER                                   : constant boolean := false;
   GRUB2_REVISION                                 : constant boolean := false;
   GRUB2_EXTRA_MODULES                            : constant string  := "";
   GRUB2_INCLUDE_RUNTIME_CONFIG_FILE              : constant boolean := false;
   PAYLOAD_OPTIONS                                : constant string  := "";
   PXE                                            : constant boolean := false;
   COMPRESSED_PAYLOAD_LZMA                        : constant boolean := true;
   COMPRESSED_PAYLOAD_LZ4                         : constant boolean := false;
   PAYLOAD_IS_FLAT_BINARY                         : constant boolean := false;
   COMPRESS_SECONDARY_PAYLOAD                     : constant boolean := true;
   --
   -- Secondary Payloads
   --
   COREINFO_SECONDARY_PAYLOAD                     : constant boolean := false;
   MEMTEST_SECONDARY_PAYLOAD                      : constant boolean := false;
   NVRAMCUI_SECONDARY_PAYLOAD                     : constant boolean := false;
   TINT_SECONDARY_PAYLOAD                         : constant boolean := false;
   --
   -- Debugging
   --
   --
   -- CPU Debug Settings
   --
   --
   -- BLOB Debug Settings
   --
   --
   -- General Debug Settings
   --
   GDB_STUB                                       : constant boolean := false;
   FATAL_ASSERTS                                  : constant boolean := false;
   DEBUG_CBFS                                     : constant boolean := false;
   HAVE_DEBUG_RAM_SETUP                           : constant boolean := true;
   DEBUG_RAM_SETUP                                : constant boolean := false;
   HAVE_DEBUG_SMBUS                               : constant boolean := true;
   DEBUG_SMBUS                                    : constant boolean := false;
   DEBUG_SMI                                      : constant boolean := false;
   DEBUG_MALLOC                                   : constant boolean := false;
   DEBUG_CONSOLE_INIT                             : constant boolean := false;
   DEBUG_SPI_FLASH                                : constant boolean := false;
   TRACE                                          : constant boolean := false;
   DEBUG_BOOT_STATE                               : constant boolean := false;
   DEBUG_ADA_CODE                                 : constant boolean := false;
   HAVE_EM100_SUPPORT                             : constant boolean := false;
   NO_EDID_FILL_FB                                : constant boolean := true;
   RAMSTAGE_ADA                                   : constant boolean := true;
   RAMSTAGE_LIBHWBASE                             : constant boolean := true;
   HWBASE_DYNAMIC_MMIO                            : constant boolean := true;
   HWBASE_DEFAULT_MMCONF                          : constant         := 16#f000_0000#;
   HWBASE_DIRECT_PCIDEV                           : constant boolean := true;
   WARNINGS_ARE_ERRORS                            : constant boolean := true;
   POWER_BUTTON_DEFAULT_ENABLE                    : constant boolean := false;
   POWER_BUTTON_DEFAULT_DISABLE                   : constant boolean := false;
   POWER_BUTTON_FORCE_ENABLE                      : constant boolean := false;
   POWER_BUTTON_FORCE_DISABLE                     : constant boolean := false;
   POWER_BUTTON_IS_OPTIONAL                       : constant boolean := false;
   REG_SCRIPT                                     : constant boolean := false;
   MAX_REBOOT_CNT                                 : constant         := 3;
   NO_XIP_EARLY_STAGES                            : constant boolean := false;
   EARLY_CBMEM_LIST                               : constant boolean := false;
   RELOCATABLE_MODULES                            : constant boolean := true;
   HAVE_ROMSTAGE                                  : constant boolean := true;
   HAVE_RAMSTAGE                                  : constant boolean := true;

end CB.Config;
