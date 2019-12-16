PHDRS
{
 to_load PT_LOAD;
}
ENTRY(_start)
SECTIONS
{
 _ = ASSERT(. <= 0xfffffff0 - 0x10000 + 0x10, "bootblock overlaps the previous region!"); . = 0xfffffff0 - 0x10000 + 0x10; _bootblock = .; _ebootblock = _bootblock + 0x10000; _ = ASSERT(_eprogram - _program <= 0x10000, "Bootblock exceeded its allotted size! (0x10000)"); INCLUDE "bootblock/lib/program.ld"
. = 0xfefe0000;
.car.data . (NOLOAD) : {
 _car_region_start = . ;
 _car_stack = .;
 . += 0x10000;
 _ecar_stack = .;
 _ = ASSERT(. <= ., "preram_cbmem_console overlaps the previous region!"); . = .; _preram_cbmem_console = .; _ = ASSERT(. == ALIGN(4), "preram_cbmem_console must be aligned to 4!"); _ = ASSERT(. <= . + 0xc00, "epreram_cbmem_console overlaps the previous region!"); . = . + 0xc00; _epreram_cbmem_console = .;
 _ = ASSERT(. <= ., "timestamp overlaps the previous region!"); . = .; _timestamp = .; _ = ASSERT(. == ALIGN(8), "timestamp must be aligned to 8!"); _ = ASSERT(. <= . + 0x200, "etimestamp overlaps the previous region!"); . = . + 0x200; _etimestamp = .; _ = ASSERT(0x200 >= 212, "Timestamp region must fit timestamp_cache!");
 _ = ASSERT(. <= ., "fmap_cache overlaps the previous region!"); . = .; _fmap_cache = .; _ = ASSERT(. == ALIGN(4), "fmap_cache must be aligned to 4!"); _ = ASSERT(. <= . + 0x10a, "efmap_cache overlaps the previous region!"); . = . + 0x10a; _efmap_cache = .; _ = ASSERT(0x10a >= 0x10a, "FMAP does not fit in FMAP_CACHE! (0x10a < 0x10a)");
 _car_ehci_dbg_info = .;
        . += 80;
        _ecar_ehci_dbg_info = .;
 . = ALIGN(8);
 _bss = .;
 *(.bss)
 *(.bss.*)
 *(.sbss)
 *(.sbss.*)
 . = ALIGN(8);
 _ebss = .;
 _car_unallocated_start = .;
 _car_region_end = . + 0x20000 - (. - _car_region_start);
}
. = 0xffffff00;
.illegal_globals . : {
 *(EXCLUDE_FILE ("*/libagesa.*.a:" "*/romstage*/buildOpts.o" "*/romstage*/agesawrapper.o" "*/vendorcode/amd/agesa/*" "*/vendorcode/amd/cimx/*") .data)
  *(EXCLUDE_FILE ("*/libagesa.*.a:" "*/romstage*/buildOpts.o" "*/romstage*/agesawrapper.o" "*/vendorcode/amd/agesa/*" "*/vendorcode/amd/cimx/*") .data.*)
}
_bogus = ASSERT((0x20000 == 0) || (SIZEOF(.car.data) <= 0x20000), "Cache as RAM area is too full");
_bogus3 = ASSERT(0x10000 > 0x0, "BSP stack size not configured");
}
 gdtptr16_offset = gdtptr16 & 0xffff;
 nullidt_offset = nullidt & 0xffff;
 ap_sipi_vector_in_rom = (_start16bit >> 12) & 0xff;
SECTIONS {
 _TOO_LOW = 0xfffffff0 - 0xfff0;
 _bogus = ASSERT(_start16bit >= _TOO_LOW, "_start16bit too low. Please report.");
 . = 0xfffffff0;
 .reset . : {
  *(.reset);
  . = 15;
  BYTE(0x00);
 }
}
SECTIONS {
 . = (0xfffffff0 - 0x80) - (__id_end - __id_start) + 0x10;
 .id (.): {
  KEEP(*(.id))
 }
}
