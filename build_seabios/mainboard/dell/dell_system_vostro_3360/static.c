#include <device/device.h>
#include <device/pci.h>
#include "cpu/intel/model_206ax/chip.h"
#include "northbridge/intel/sandybridge/chip.h"
#include "southbridge/intel/bd82x6x/chip.h"

#if !DEVTREE_EARLY
__attribute__((weak)) struct chip_operations mainboard_ops = {};
__attribute__((weak)) struct chip_operations cpu_intel_model_206ax_ops = {};
__attribute__((weak)) struct chip_operations northbridge_intel_sandybridge_ops = {};
__attribute__((weak)) struct chip_operations southbridge_intel_bd82x6x_ops = {};
#endif

#define STORAGE static __unused DEVTREE_CONST

STORAGE struct cpu_intel_model_206ax_config cpu_intel_model_206ax_info_3 = {
	.c1_acpower = 1,
	.c1_battery = 1,
	.c2_acpower = 3,
	.c2_battery = 3,
	.c3_acpower = 5,
	.c3_battery = 5,
};

STORAGE struct northbridge_intel_sandybridge_config northbridge_intel_sandybridge_info_1 = {
	.gfx.link_frequency_270_mhz = 1,
	.gfx.use_spread_spectrum_clock = 1,
	.gpu_cpu_backlight = 0x00001312,
	.gpu_dp_b_hotplug = 4,
	.gpu_dp_c_hotplug = 4,
	.gpu_dp_d_hotplug = 4,
	.gpu_panel_port_select = 0,
	.gpu_panel_power_backlight_off_delay = 3000,
	.gpu_panel_power_backlight_on_delay = 1700,
	.gpu_panel_power_cycle_delay = 5,
	.gpu_panel_power_down_delay = 300,
	.gpu_panel_power_up_delay = 300,
	.gpu_pch_backlight = 0x13121312,
};

STORAGE struct southbridge_intel_bd82x6x_config southbridge_intel_bd82x6x_info_7 = {
	.c2_latency = 0x0065,
	.docking_supported = 1,
	.gen1_dec = 0x00040069,
	.gen2_dec = 0x00040911,
	.gen3_dec = 0x00000000,
	.gen4_dec = 0x000c06a1,
	.pcie_hotplug_map = { 0, 0, 0, 0, 0, 0, 0, 0 },
	.pcie_port_coalesce = 1,
	.sata_interface_speed_support = 0x3,
	.sata_port_map = 0x1,
	.spi_lvscc = 0x2005,
	.spi_uvscc = 0x2005,
	.superspeed_capable_ports = 0x0000000f,
	.xhci_overcurrent_mapping = 0x00000c03,
	.xhci_switchable_ports = 0x0000000f,
};


/* pass 0 */
STORAGE struct bus dev_root_links[];
STORAGE struct device _dev2;
STORAGE struct bus _dev2_links[];
STORAGE struct device _dev6;
STORAGE struct bus _dev6_links[];
STORAGE struct device _dev4;
STORAGE struct device _dev5;
STORAGE struct device _dev8;
STORAGE struct device _dev9;
STORAGE struct device _dev10;
STORAGE struct device _dev11;
STORAGE struct device _dev12;
STORAGE struct device _dev13;
STORAGE struct device _dev14;
STORAGE struct device _dev15;
STORAGE struct device _dev16;
STORAGE struct device _dev17;
STORAGE struct device _dev18;
STORAGE struct device _dev19;
STORAGE struct device _dev20;
STORAGE struct device _dev21;
STORAGE struct device _dev22;
STORAGE struct device _dev23;
STORAGE struct device _dev24;
STORAGE struct device _dev25;
STORAGE struct device _dev26;
STORAGE struct device _dev27;
STORAGE struct device _dev28;
STORAGE struct device _dev29;
STORAGE struct device _dev30;
STORAGE struct device _dev31;
STORAGE struct device _dev32;
STORAGE struct device _dev33;
DEVTREE_CONST struct device * DEVTREE_CONST last_dev = &_dev33;

/* pass 1 */
DEVTREE_CONST struct device dev_root = {
#if !DEVTREE_EARLY
	.ops = &default_dev_ops_root,
#endif
	.bus = &dev_root_links[0],
	.path = { .type = DEVICE_PATH_ROOT },
	.enabled = 1,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = &dev_root_links[0],
#if !DEVTREE_EARLY
	.chip_ops = &mainboard_ops,
	.name = mainboard_name,
#endif
	.next=&_dev2,
};
STORAGE struct bus dev_root_links[] = {
		[0] = {
			.link_num = 0,
			.dev = &dev_root,
			.children = &_dev2,
			.next = NULL,
		},
	};
STORAGE struct device _dev2 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &dev_root_links[0],
	.path = {.type=DEVICE_PATH_CPU_CLUSTER,{.cpu_cluster={ .cluster = 0x0 }}},
	.enabled = 1,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = &_dev2_links[0],
	.sibling = &_dev6,
#if !DEVTREE_EARLY
	.chip_ops = &northbridge_intel_sandybridge_ops,
#endif
	.chip_info = &northbridge_intel_sandybridge_info_1,
	.next=&_dev6,
};
STORAGE struct bus _dev2_links[] = {
		[0] = {
			.link_num = 0,
			.dev = &_dev2,
			.children = &_dev4,
			.next = NULL,
		},
	};
STORAGE struct device _dev6 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &dev_root_links[0],
	.path = {.type=DEVICE_PATH_DOMAIN,{.domain={ .domain = 0x0 }}},
	.enabled = 1,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = &_dev6_links[0],
#if !DEVTREE_EARLY
	.chip_ops = &northbridge_intel_sandybridge_ops,
#endif
	.chip_info = &northbridge_intel_sandybridge_info_1,
	.next=&_dev4,
};
STORAGE struct bus _dev6_links[] = {
		[0] = {
			.link_num = 0,
			.dev = &_dev6,
			.children = &_dev8,
			.next = NULL,
		},
	};
STORAGE struct device _dev4 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev2_links[0],
	.path = {.type=DEVICE_PATH_APIC,{.apic={ .apic_id = 0x0 }}},
	.enabled = 1,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev5,
#if !DEVTREE_EARLY
	.chip_ops = &cpu_intel_model_206ax_ops,
#endif
	.chip_info = &cpu_intel_model_206ax_info_3,
	.next=&_dev5,
};
STORAGE struct device _dev5 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev2_links[0],
	.path = {.type=DEVICE_PATH_APIC,{.apic={ .apic_id = 0xacac }}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
#if !DEVTREE_EARLY
	.chip_ops = &cpu_intel_model_206ax_ops,
#endif
	.chip_info = &cpu_intel_model_206ax_info_3,
	.next=&_dev8,
};
STORAGE struct device _dev8 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x14,0)}}},
	.enabled = 1,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.subsystem_vendor = 0x1028,
	.subsystem_device = 0x055c,
	.link_list = NULL,
	.sibling = &_dev9,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev9,
};
STORAGE struct device _dev9 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x16,0)}}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev10,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev10,
};
STORAGE struct device _dev10 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x16,1)}}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev11,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev11,
};
STORAGE struct device _dev11 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x16,2)}}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev12,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev12,
};
STORAGE struct device _dev12 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x16,3)}}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev13,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev13,
};
STORAGE struct device _dev13 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x19,0)}}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev14,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev14,
};
STORAGE struct device _dev14 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1a,0)}}},
	.enabled = 1,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.subsystem_vendor = 0x1028,
	.subsystem_device = 0x055c,
	.link_list = NULL,
	.sibling = &_dev15,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev15,
};
STORAGE struct device _dev15 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1b,0)}}},
	.enabled = 1,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.subsystem_vendor = 0x1028,
	.subsystem_device = 0x055c,
	.link_list = NULL,
	.sibling = &_dev16,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev16,
};
STORAGE struct device _dev16 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1c,0)}}},
	.enabled = 1,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.subsystem_vendor = 0x1028,
	.subsystem_device = 0x055c,
	.link_list = NULL,
	.sibling = &_dev17,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev17,
};
STORAGE struct device _dev17 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1c,1)}}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev18,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev18,
};
STORAGE struct device _dev18 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1c,2)}}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev19,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev19,
};
STORAGE struct device _dev19 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1c,3)}}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev20,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev20,
};
STORAGE struct device _dev20 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1c,4)}}},
	.enabled = 1,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.subsystem_vendor = 0x1028,
	.subsystem_device = 0x055c,
	.link_list = NULL,
	.sibling = &_dev21,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev21,
};
STORAGE struct device _dev21 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1c,5)}}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev22,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev22,
};
STORAGE struct device _dev22 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1c,6)}}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev23,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev23,
};
STORAGE struct device _dev23 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1c,7)}}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev24,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev24,
};
STORAGE struct device _dev24 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1d,0)}}},
	.enabled = 1,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.subsystem_vendor = 0x1028,
	.subsystem_device = 0x055c,
	.link_list = NULL,
	.sibling = &_dev25,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev25,
};
STORAGE struct device _dev25 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1e,0)}}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev26,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev26,
};
STORAGE struct device _dev26 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1f,0)}}},
	.enabled = 1,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.subsystem_vendor = 0x1028,
	.subsystem_device = 0x055c,
	.link_list = NULL,
	.sibling = &_dev27,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev27,
};
STORAGE struct device _dev27 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1f,2)}}},
	.enabled = 1,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.subsystem_vendor = 0x1028,
	.subsystem_device = 0x055c,
	.link_list = NULL,
	.sibling = &_dev28,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev28,
};
STORAGE struct device _dev28 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1f,3)}}},
	.enabled = 1,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.subsystem_vendor = 0x1028,
	.subsystem_device = 0x055c,
	.link_list = NULL,
	.sibling = &_dev29,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev29,
};
STORAGE struct device _dev29 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1f,5)}}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev30,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev30,
};
STORAGE struct device _dev30 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1f,6)}}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev31,
#if !DEVTREE_EARLY
	.chip_ops = &southbridge_intel_bd82x6x_ops,
#endif
	.chip_info = &southbridge_intel_bd82x6x_info_7,
	.next=&_dev31,
};
STORAGE struct device _dev31 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x0,0)}}},
	.enabled = 1,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.subsystem_vendor = 0x1028,
	.subsystem_device = 0x055c,
	.link_list = NULL,
	.sibling = &_dev32,
#if !DEVTREE_EARLY
	.chip_ops = &northbridge_intel_sandybridge_ops,
#endif
	.chip_info = &northbridge_intel_sandybridge_info_1,
	.next=&_dev32,
};
STORAGE struct device _dev32 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x1,0)}}},
	.enabled = 0,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.link_list = NULL,
	.sibling = &_dev33,
#if !DEVTREE_EARLY
	.chip_ops = &northbridge_intel_sandybridge_ops,
#endif
	.chip_info = &northbridge_intel_sandybridge_info_1,
	.next=&_dev33,
};
STORAGE struct device _dev33 = {
#if !DEVTREE_EARLY
	.ops = NULL,
#endif
	.bus = &_dev6_links[0],
	.path = {.type=DEVICE_PATH_PCI,{.pci={ .devfn = PCI_DEVFN(0x2,0)}}},
	.enabled = 1,
	.hidden = 0,
	.mandatory = 0,
	.on_mainboard = 1,
	.subsystem_vendor = 0x1028,
	.subsystem_device = 0x055c,
	.link_list = NULL,
#if !DEVTREE_EARLY
	.chip_ops = &northbridge_intel_sandybridge_ops,
#endif
	.chip_info = &northbridge_intel_sandybridge_info_1,
};

/* expose_device_names */
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_14_0 = &_dev8;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_16_0 = &_dev9;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_16_1 = &_dev10;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_16_2 = &_dev11;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_16_3 = &_dev12;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_19_0 = &_dev13;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1a_0 = &_dev14;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1b_0 = &_dev15;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1c_0 = &_dev16;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1c_1 = &_dev17;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1c_2 = &_dev18;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1c_3 = &_dev19;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1c_4 = &_dev20;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1c_5 = &_dev21;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1c_6 = &_dev22;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1c_7 = &_dev23;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1d_0 = &_dev24;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1e_0 = &_dev25;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1f_0 = &_dev26;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1f_2 = &_dev27;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1f_3 = &_dev28;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1f_5 = &_dev29;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_1f_6 = &_dev30;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_00_0 = &_dev31;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_01_0 = &_dev32;
DEVTREE_CONST struct device *DEVTREE_CONST __pci_0_02_0 = &_dev33;
