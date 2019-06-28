#include <device/device.h>
#include <device/pci.h>
#include "southbridge/intel/i82371eb/chip.h"

#if !DEVTREE_EARLY
__attribute__((weak)) struct chip_operations mainboard_ops = {};
__attribute__((weak)) struct chip_operations cpu_qemu_x86_ops = {};
__attribute__((weak)) struct chip_operations mainboard_emulation_qemu_i440fx_ops = {};
__attribute__((weak)) struct chip_operations southbridge_intel_i82371eb_ops = {};
#endif
DEVTREE_CONST struct southbridge_intel_i82371eb_config southbridge_intel_i82371eb_info_7 = {
	.gpo = 0x7fffbbff,
	.ide0_enable = 1,
	.ide1_enable = 1,
};


/* pass 0 */
DEVTREE_CONST struct bus dev_root_links[];
static DEVTREE_CONST struct device _dev2;
DEVTREE_CONST struct bus _dev2_links[];
static DEVTREE_CONST struct device _dev5;
DEVTREE_CONST struct bus _dev5_links[];
static DEVTREE_CONST struct device _dev4;
static DEVTREE_CONST struct device _dev6;
static DEVTREE_CONST struct device _dev8;
static DEVTREE_CONST struct device _dev9;
static DEVTREE_CONST struct device _dev10;
DEVTREE_CONST struct device * DEVTREE_CONST last_dev = &_dev10;

/* pass 1 */
DEVTREE_CONST struct device dev_root = {
#if !DEVTREE_EARLY
	.ops = &default_dev_ops_root,
#endif
	.bus = &dev_root_links[0],
	.path = { .type = DEVICE_PATH_ROOT },
	.enabled = 1,
	.hidden = 0,
	.on_mainboard = 1,
	.link_list = &dev_root_links[0],
#if !DEVTREE_EARLY
	.chip_ops = &mainboard_ops,
	.name = mainboard_name,
#endif
	.next=&_dev2,
};
DEVTREE_CONST struct bus dev_root_links[] = {
		[0] = {
			.link_num = 0,
			.dev = &dev_root,
			.children = &_dev2,
			.next = NULL,
		},
	};
static DEVTREE_CONST struct device _dev2 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &dev_root_links[0],
	.path = {.type=DEVICE_PATH_CPU_CLUSTER,{.cpu_cluster={ .cluster = 0x0 }}},
	.enabled = 1,
	.hidden = 0,
	.on_mainboard = 1,
	.link_list = &_dev2_links[0],
	.sibling = &_dev5,
#if !DEVTREE_EARLY
	.chip_ops = &mainboard_emulation_qemu_i440fx_ops,
#endif
	.next=&_dev5,
};
DEVTREE_CONST struct bus _dev2_links[] = {
		[0] = {
			.link_num = 0,
			.dev = &_dev2,
			.children = &_dev4,
			.next = NULL,
		},
	};
static DEVTREE_CONST struct device _dev5 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &dev_root_links[0],
	.path = {.type=DEVICE_PATH_DOMAIN,{.domain={ .domain = 0x0 }}},
	.enabled = 1,
	.hidden = 0,
	.on_mainboard = 1,
	.link_list = &_dev5_links[0],
#if !DEVTREE_EARLY
	.chip_ops = &mainboard_emulation_qemu_i440fx_ops,
#endif
	.next=&_dev4,
};
DEVTREE_CONST struct bus _dev5_links[] = {
		[0] = {
			.link_num = 0,
			.dev = &_dev5,
			.children = &_dev6,
			.next = NULL,
		},
	};
static DEVTREE_CONST struct device _dev4 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev2_links[0],
	.path = {.type=DEVICE_PATH_APIC,{.apic={ .apic_id = 0x0 }}},
	.enabled = 1,
	.hidden = 0,
	.on_mainboard = 1,
	.link_list = NULL,
#if !DEVTREE_EARLY
	.chip_ops = &cpu_qemu_x86_ops,
#endif
	.next=&_dev6,
};
static DEVTREE_CONST struct device _dev6 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev5_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x0,0)}}},
	.enabled = 1,
	.hidden = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev8,
#if !DEVTREE_EARLY
	.chip_ops = &mainboard_emulation_qemu_i440fx_ops,
#endif
	.next=&_dev8,
};
static DEVTREE_CONST struct device _dev8 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev5_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1,0)}}},
	.enabled = 1,
	.hidden = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev9,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_i82371eb_ops,
#endif
	.chip_info = &southbridge_intel_i82371eb_info_7,
	.next=&_dev9,
};
static DEVTREE_CONST struct device _dev9 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev5_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1,1)}}},
	.enabled = 1,
	.hidden = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev10,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_i82371eb_ops,
#endif
	.chip_info = &southbridge_intel_i82371eb_info_7,
	.next=&_dev10,
};
static DEVTREE_CONST struct device _dev10 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev5_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1,3)}}},
	.enabled = 1,
	.hidden = 0,
	.on_mainboard = 1,
	.link_list = NULL,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_i82371eb_ops,
#endif
	.chip_info = &southbridge_intel_i82371eb_info_7,
};
