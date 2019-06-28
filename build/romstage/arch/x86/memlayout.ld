PHDRS
{
 to_load PT_LOAD;
}
ENTRY(_start)
SECTIONS
{
 _ = ASSERT(. <= 0x2000000, "romstage overlaps the previous region!"); . = 0x2000000; _romstage = .; _eromstage = _romstage + 1M; _ = ASSERT(_eprogram - _program <= 1M, "Romstage exceeded its allotted size! (1M)"); INCLUDE "romstage/lib/program.ld"
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
