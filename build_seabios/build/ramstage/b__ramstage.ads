pragma Warnings (Off);
pragma Ada_95;
pragma Restrictions (No_Exception_Handlers);
with System;
package ramstage_adamain is

   procedure ramstage_adainit;
   pragma Export (C, ramstage_adainit, "ramstage_adainit");
   pragma Linker_Constructor (ramstage_adainit);

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#033fbd9b#;
   pragma Export (C, u00001, "hw__gfx__gma__configB");
   u00002 : constant Version_32 := 16#53c5b915#;
   pragma Export (C, u00002, "hw__gfx__gma__configS");
   u00003 : constant Version_32 := 16#eeb0befe#;
   pragma Export (C, u00003, "hw__gfx__dp_aux_chB");
   u00004 : constant Version_32 := 16#ef5af001#;
   pragma Export (C, u00004, "hw__gfx__dp_aux_chS");
   u00005 : constant Version_32 := 16#e2948386#;
   pragma Export (C, u00005, "hw__gfx__dp_defsS");
   u00006 : constant Version_32 := 16#a7984cb7#;
   pragma Export (C, u00006, "hw__gfx__dp_infoB");
   u00007 : constant Version_32 := 16#7ebe2cde#;
   pragma Export (C, u00007, "hw__gfx__dp_infoS");
   u00008 : constant Version_32 := 16#fa52b79f#;
   pragma Export (C, u00008, "hw__gfx__dp_trainingB");
   u00009 : constant Version_32 := 16#be38ed00#;
   pragma Export (C, u00009, "hw__gfx__dp_trainingS");
   u00010 : constant Version_32 := 16#cd05dfd3#;
   pragma Export (C, u00010, "hw__gfx__edidB");
   u00011 : constant Version_32 := 16#4bdfd417#;
   pragma Export (C, u00011, "hw__gfx__edidS");
   u00012 : constant Version_32 := 16#e8d38bf2#;
   pragma Export (C, u00012, "hw__gfx__framebuffer_fillerB");
   u00013 : constant Version_32 := 16#cc363673#;
   pragma Export (C, u00013, "hw__gfx__framebuffer_fillerS");
   u00014 : constant Version_32 := 16#fcad0896#;
   pragma Export (C, u00014, "hw__gfx__gma__config_helpersB");
   u00015 : constant Version_32 := 16#bd6f5251#;
   pragma Export (C, u00015, "hw__gfx__gma__config_helpersS");
   u00016 : constant Version_32 := 16#49832ec2#;
   pragma Export (C, u00016, "hw__gfx__gma__connector_infoB");
   u00017 : constant Version_32 := 16#44c11f12#;
   pragma Export (C, u00017, "hw__gfx__gma__connector_infoS");
   u00018 : constant Version_32 := 16#9c8ea594#;
   pragma Export (C, u00018, "hw__gfx__gma__display_probingB");
   u00019 : constant Version_32 := 16#617c1874#;
   pragma Export (C, u00019, "hw__gfx__gma__display_probingS");
   u00020 : constant Version_32 := 16#53944791#;
   pragma Export (C, u00020, "hw__gfx__gma__dp_aux_chB");
   u00021 : constant Version_32 := 16#05cf326c#;
   pragma Export (C, u00021, "hw__gfx__gma__dp_aux_chS");
   u00022 : constant Version_32 := 16#e76b2d22#;
   pragma Export (C, u00022, "hw__gfx__gma__dp_aux_requestB");
   u00023 : constant Version_32 := 16#8e288b50#;
   pragma Export (C, u00023, "hw__gfx__gma__dp_aux_requestS");
   u00024 : constant Version_32 := 16#38def494#;
   pragma Export (C, u00024, "hw__gfx__gma__dp_infoB");
   u00025 : constant Version_32 := 16#47bfba63#;
   pragma Export (C, u00025, "hw__gfx__gma__dp_infoS");
   u00026 : constant Version_32 := 16#4e54e6c3#;
   pragma Export (C, u00026, "hw__gfx__gma__i2cB");
   u00027 : constant Version_32 := 16#51db4f1c#;
   pragma Export (C, u00027, "hw__gfx__gma__i2cS");
   u00028 : constant Version_32 := 16#3e890a5d#;
   pragma Export (C, u00028, "hw__gfx__gma__panelB");
   u00029 : constant Version_32 := 16#00cff013#;
   pragma Export (C, u00029, "hw__gfx__gma__panelS");
   u00030 : constant Version_32 := 16#5c929740#;
   pragma Export (C, u00030, "hw__gfx__gma__pch__fdiB");
   u00031 : constant Version_32 := 16#9accaa52#;
   pragma Export (C, u00031, "hw__gfx__gma__pch__fdiS");
   u00032 : constant Version_32 := 16#780f6032#;
   pragma Export (C, u00032, "hw__gfx__gma__pch__sidebandB");
   u00033 : constant Version_32 := 16#6e79b0ce#;
   pragma Export (C, u00033, "hw__gfx__gma__pch__sidebandS");
   u00034 : constant Version_32 := 16#a734a064#;
   pragma Export (C, u00034, "hw__gfx__gma__pch__transcoderB");
   u00035 : constant Version_32 := 16#c8134541#;
   pragma Export (C, u00035, "hw__gfx__gma__pch__transcoderS");
   u00036 : constant Version_32 := 16#8a787d1b#;
   pragma Export (C, u00036, "hw__gfx__gma__pch__vgaB");
   u00037 : constant Version_32 := 16#65e1fddd#;
   pragma Export (C, u00037, "hw__gfx__gma__pch__vgaS");
   u00038 : constant Version_32 := 16#b519a61a#;
   pragma Export (C, u00038, "hw__gfx__gma__pchS");
   u00039 : constant Version_32 := 16#e5bdebbd#;
   pragma Export (C, u00039, "hw__gfx__gma__pcodeB");
   u00040 : constant Version_32 := 16#1d7d517e#;
   pragma Export (C, u00040, "hw__gfx__gma__pcodeS");
   u00041 : constant Version_32 := 16#5fda6f8b#;
   pragma Export (C, u00041, "hw__gfx__gma__pipe_setupB");
   u00042 : constant Version_32 := 16#aff745cf#;
   pragma Export (C, u00042, "hw__gfx__gma__pipe_setupS");
   u00043 : constant Version_32 := 16#b8bd1c58#;
   pragma Export (C, u00043, "hw__gfx__gma__registersB");
   u00044 : constant Version_32 := 16#6be0fc70#;
   pragma Export (C, u00044, "hw__gfx__gma__registersS");
   u00045 : constant Version_32 := 16#1f991605#;
   pragma Export (C, u00045, "hw__gfx__gma__transcoderB");
   u00046 : constant Version_32 := 16#83964105#;
   pragma Export (C, u00046, "hw__gfx__gma__transcoderS");
   u00047 : constant Version_32 := 16#73b4f78d#;
   pragma Export (C, u00047, "hw__gfx__gmaB");
   u00048 : constant Version_32 := 16#fbdc2186#;
   pragma Export (C, u00048, "hw__gfx__gmaS");
   u00049 : constant Version_32 := 16#37290eac#;
   pragma Export (C, u00049, "hw__gfx__i2cS");
   u00050 : constant Version_32 := 16#d263ba5b#;
   pragma Export (C, u00050, "hw__gfxS");
   u00051 : constant Version_32 := 16#cc68e0a6#;
   pragma Export (C, u00051, "hw__gfx__gma__connectors__edpB");
   u00052 : constant Version_32 := 16#b70e0f24#;
   pragma Export (C, u00052, "hw__gfx__gma__connectors__edpS");
   u00053 : constant Version_32 := 16#db9f7da4#;
   pragma Export (C, u00053, "hw__gfx__gma__connectors__fdiB");
   u00054 : constant Version_32 := 16#23b8d145#;
   pragma Export (C, u00054, "hw__gfx__gma__connectors__fdiS");
   u00055 : constant Version_32 := 16#d967dfa8#;
   pragma Export (C, u00055, "hw__gfx__gma__connectorsB");
   u00056 : constant Version_32 := 16#a40ca226#;
   pragma Export (C, u00056, "hw__gfx__gma__connectorsS");
   u00057 : constant Version_32 := 16#90b40552#;
   pragma Export (C, u00057, "hw__gfx__gma__pch__dpB");
   u00058 : constant Version_32 := 16#54b4bee7#;
   pragma Export (C, u00058, "hw__gfx__gma__pch__dpS");
   u00059 : constant Version_32 := 16#b29daf66#;
   pragma Export (C, u00059, "hw__gfx__gma__pch__hdmiB");
   u00060 : constant Version_32 := 16#51ede2f1#;
   pragma Export (C, u00060, "hw__gfx__gma__pch__hdmiS");
   u00061 : constant Version_32 := 16#8e5f59d0#;
   pragma Export (C, u00061, "hw__gfx__gma__pch__lvdsB");
   u00062 : constant Version_32 := 16#038cf85f#;
   pragma Export (C, u00062, "hw__gfx__gma__pch__lvdsS");
   u00063 : constant Version_32 := 16#4e570d3a#;
   pragma Export (C, u00063, "hw__gfx__gma__pllsB");
   u00064 : constant Version_32 := 16#4f49b036#;
   pragma Export (C, u00064, "hw__gfx__gma__pllsS");
   u00065 : constant Version_32 := 16#b4c3864a#;
   pragma Export (C, u00065, "hw__gfx__gma__port_detectB");
   u00066 : constant Version_32 := 16#094f58ce#;
   pragma Export (C, u00066, "hw__gfx__gma__port_detectS");
   u00067 : constant Version_32 := 16#2e5e8462#;
   pragma Export (C, u00067, "hw__gfx__gma__power_and_clocksS");
   u00068 : constant Version_32 := 16#8bd100e5#;
   pragma Export (C, u00068, "hw__gfx__gma__power_and_clocks_ironlakeB");
   u00069 : constant Version_32 := 16#b21439e7#;
   pragma Export (C, u00069, "hw__gfx__gma__power_and_clocks_ironlakeS");
   u00070 : constant Version_32 := 16#43f6a17e#;
   pragma Export (C, u00070, "hw__mmio_rangeB");
   u00071 : constant Version_32 := 16#ce9421df#;
   pragma Export (C, u00071, "hw__mmio_rangeS");
   u00072 : constant Version_32 := 16#ce716a67#;
   pragma Export (C, u00072, "hw__pci__devB");
   u00073 : constant Version_32 := 16#19713f06#;
   pragma Export (C, u00073, "hw__pci__devS");
   u00074 : constant Version_32 := 16#ff7aacc6#;
   pragma Export (C, u00074, "hw__mmio_regsB");
   u00075 : constant Version_32 := 16#f8568111#;
   pragma Export (C, u00075, "hw__mmio_regsS");
   u00076 : constant Version_32 := 16#d9a1d01d#;
   pragma Export (C, u00076, "hw__pci__mmconfB");
   u00077 : constant Version_32 := 16#1638822d#;
   pragma Export (C, u00077, "hw__pci__mmconfS");
   u00078 : constant Version_32 := 16#e63e29d4#;
   pragma Export (C, u00078, "hw__pciS");
   u00079 : constant Version_32 := 16#edda6f07#;
   pragma Export (C, u00079, "hw__port_ioB");
   u00080 : constant Version_32 := 16#7678d008#;
   pragma Export (C, u00080, "hw__port_ioS");
   u00081 : constant Version_32 := 16#ab5919c7#;
   pragma Export (C, u00081, "hw__sub_regsS");
   u00082 : constant Version_32 := 16#055de4f9#;
   pragma Export (C, u00082, "hw__timeB");
   u00083 : constant Version_32 := 16#d36a20ac#;
   pragma Export (C, u00083, "hw__timeS");
   u00084 : constant Version_32 := 16#bd96d023#;
   pragma Export (C, u00084, "hwS");
   u00085 : constant Version_32 := 16#45f1c9c0#;
   pragma Export (C, u00085, "hw__debugB");
   u00086 : constant Version_32 := 16#27b64be9#;
   pragma Export (C, u00086, "hw__debugS");
   u00087 : constant Version_32 := 16#ce77d9a2#;
   pragma Export (C, u00087, "hw__debug_sinkS");
   u00088 : constant Version_32 := 16#09662dc7#;
   pragma Export (C, u00088, "hw__configS");
   u00089 : constant Version_32 := 16#f4bcc71d#;
   pragma Export (C, u00089, "gmaB");
   u00090 : constant Version_32 := 16#b0c08193#;
   pragma Export (C, u00090, "gmaS");
   u00091 : constant Version_32 := 16#fbf5ba40#;
   pragma Export (C, u00091, "gma__gfx_initB");
   u00092 : constant Version_32 := 16#3fca6799#;
   pragma Export (C, u00092, "gma__gfx_initS");
   u00093 : constant Version_32 := 16#e6df39c3#;
   pragma Export (C, u00093, "cbS");
   u00094 : constant Version_32 := 16#7e567a1e#;
   pragma Export (C, u00094, "hw__time__timerB");
   u00095 : constant Version_32 := 16#17f3ab21#;
   pragma Export (C, u00095, "hw__time__timerS");
   u00096 : constant Version_32 := 16#5346569a#;
   pragma Export (C, u00096, "gma__mainboardS");
   u00097 : constant Version_32 := 16#9410b3cb#;
   pragma Export (C, u00097, "cb__configS");

   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  gnat%s
   --  gnat.source_info%s
   --  interfaces%s
   --  system%s
   --  system.machine_code%s
   --  system.parameters%s
   --  interfaces.c%s
   --  interfaces.c%b
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.unsigned_types%s
   --  cb%s
   --  cb.config%s
   --  hw%s
   --  hw.config%s
   --  hw.debug_sink%s
   --  hw.gfx%s
   --  hw.gfx.dp_defs%s
   --  hw.gfx.i2c%s
   --  hw.pci%s
   --  hw.port_io%s
   --  hw.port_io%b
   --  hw.sub_regs%s
   --  hw.time%s
   --  hw.time.timer%s
   --  hw.time.timer%b
   --  hw.time%b
   --  hw.debug%s
   --  hw.debug%b
   --  hw.gfx.dp_aux_ch%s
   --  hw.gfx.dp_aux_ch%b
   --  hw.gfx.dp_info%s
   --  hw.gfx.dp_info%b
   --  hw.gfx.dp_training%s
   --  hw.gfx.dp_training%b
   --  hw.gfx.edid%s
   --  hw.gfx.edid%b
   --  hw.mmio_range%s
   --  hw.mmio_range%b
   --  hw.gfx.framebuffer_filler%s
   --  hw.gfx.framebuffer_filler%b
   --  hw.mmio_regs%s
   --  hw.mmio_regs%b
   --  hw.pci.mmconf%s
   --  hw.pci.mmconf%b
   --  hw.pci.dev%s
   --  hw.pci.dev%b
   --  hw.gfx.gma%s
   --  hw.gfx.gma.config%s
   --  hw.gfx.gma.port_detect%s
   --  hw.gfx.gma.plls%s
   --  hw.gfx.gma.connectors%s
   --  hw.gfx.gma.connectors.edp%s
   --  hw.gfx.gma.registers%s
   --  hw.gfx.gma.registers%b
   --  hw.gfx.gma.pcode%s
   --  hw.gfx.gma.pcode%b
   --  hw.gfx.gma.panel%s
   --  hw.gfx.gma.panel%b
   --  hw.gfx.gma.connector_info%s
   --  hw.gfx.gma.config_helpers%s
   --  hw.gfx.gma.dp_aux_request%s
   --  hw.gfx.gma.dp_aux_ch%s
   --  hw.gfx.gma.dp_aux_ch%b
   --  hw.gfx.gma.dp_info%s
   --  hw.gfx.gma.dp_info%b
   --  hw.gfx.gma.pch%s
   --  hw.gfx.gma.config%b
   --  hw.gfx.gma.power_and_clocks_ironlake%s
   --  hw.gfx.gma.power_and_clocks%s
   --  hw.gfx.gma.port_detect%b
   --  hw.gfx.gma.plls%b
   --  hw.gfx.gma.pch.lvds%s
   --  hw.gfx.gma.connectors.fdi%s
   --  hw.gfx.gma.connectors.edp%b
   --  hw.gfx.gma.pch.hdmi%s
   --  hw.gfx.gma.pch.dp%s
   --  hw.gfx.gma.transcoder%s
   --  hw.gfx.gma.transcoder%b
   --  hw.gfx.gma.pipe_setup%s
   --  hw.gfx.gma.pch.vga%s
   --  hw.gfx.gma.pch.transcoder%s
   --  hw.gfx.gma.pch.sideband%s
   --  hw.gfx.gma.pch.fdi%s
   --  hw.gfx.gma.connector_info%b
   --  hw.gfx.gma.config_helpers%b
   --  hw.gfx.gma.dp_aux_request%b
   --  hw.gfx.gma.power_and_clocks_ironlake%b
   --  hw.gfx.gma%b
   --  hw.gfx.gma.pch.lvds%b
   --  hw.gfx.gma.connectors%b
   --  hw.gfx.gma.connectors.fdi%b
   --  hw.gfx.gma.pch.hdmi%b
   --  hw.gfx.gma.pch.dp%b
   --  hw.gfx.gma.pipe_setup%b
   --  hw.gfx.gma.pch.vga%b
   --  hw.gfx.gma.pch.transcoder%b
   --  hw.gfx.gma.pch.sideband%b
   --  hw.gfx.gma.pch.fdi%b
   --  hw.gfx.gma.i2c%s
   --  hw.gfx.gma.i2c%b
   --  hw.gfx.gma.display_probing%s
   --  hw.gfx.gma.display_probing%b
   --  gma%s
   --  gma%b
   --  gma.mainboard%s
   --  gma.gfx_init%s
   --  gma.gfx_init%b
   --  END ELABORATION ORDER

end ramstage_adamain;
