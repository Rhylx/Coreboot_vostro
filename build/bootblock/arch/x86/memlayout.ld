PHDRS
{
 to_load PT_LOAD;
}
ENTRY(_start)
SECTIONS
{
 _ = ASSERT(. <= 0xffffffff - 0x4000 + 1, "bootblock overlaps the previous region!"); . = 0xffffffff - 0x4000 + 1; _bootblock = .; _ebootblock = _bootblock + 0x4000; _ = ASSERT(_eprogram - _program <= 0x4000, "Bootblock exceeded its allotted size! (0x4000)"); INCLUDE "bootblock/lib/program.ld"
. = 0x10000;
.car.data . (NOLOAD) : {
 _car_region_start = . ;
 _car_stack_start = .;
 . += 0x4000;
 _car_stack_end = .;
 _ = ASSERT(. <= ., "preram_cbmem_console overlaps the previous region!"); . = .; _preram_cbmem_console = .; _ = ASSERT(. == ALIGN(4), "preram_cbmem_console must be aligned to 4!"); _ = ASSERT(. <= . + 0xc00, "epreram_cbmem_console overlaps the previous region!"); . = . + 0xc00; _epreram_cbmem_console = .;
 _car_relocatable_data_start = .;
 _ = ASSERT(. <= ., "timestamp overlaps the previous region!"); . = .; _timestamp = .; _ = ASSERT(. == ALIGN(8), "timestamp must be aligned to 8!"); _ = ASSERT(. <= . + 0x200, "etimestamp overlaps the previous region!"); . = . + 0x200; _etimestamp = .; _ = ASSERT(0x200 >= 212, "Timestamp region must fit timestamp_cache!");
 _car_ehci_dbg_info_start = .;
        . += 80;
        _car_ehci_dbg_info_end = .;
 _car_global_start = .;
 *(.bss)
 *(.bss.*)
 *(.sbss)
 *(.sbss.*)
 . = ALIGN(8);
 _car_global_end = .;
 _car_relocatable_data_end = .;
 _car_region_end = . + 0x90000 - (. - _car_region_start);
}
. = 0xffffff00;
.illegal_globals . : {
 *(EXCLUDE_FILE ("*/libagesa.*.a:" "*/romstage*/buildOpts.o" "*/romstage*/agesawrapper.o" "*/vendorcode/amd/agesa/*" "*/vendorcode/amd/cimx/*") .data)
  *(EXCLUDE_FILE ("*/libagesa.*.a:" "*/romstage*/buildOpts.o" "*/romstage*/agesawrapper.o" "*/vendorcode/amd/agesa/*" "*/vendorcode/amd/cimx/*") .data.*)
 *(.car.global_data);
}
_bogus = ASSERT((0x90000 == 0) || (SIZEOF(.car.data) <= 0x90000), "Cache as RAM area is too full");
_bogus3 = ASSERT(0x4000 > 0x0, "BSP stack size not configured");
}
 gdtptr16_offset = gdtptr16 & 0xffff;
 nullidt_offset = nullidt & 0xffff;
 ap_sipi_vector_in_rom = (_start16bit >> 12) & 0xff;
SECTIONS {
 _bogus = ASSERT(_start16bit >= 0xffff0000, "_start16bit too low. Please report.");
 _ROMTOP = 0xfffffff0;
 . = _ROMTOP;
 .reset . : {
  *(.reset);
  . = 15;
  BYTE(0x00);
 }
}
SECTIONS {
 . = (0xffffffff - 0x80) - (__id_end - __id_start) + 1;
 .id (.): {
  KEEP(*(.id))
 }
}
