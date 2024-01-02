OUTPUT_ARCH(riscv)
ENTRY(_start)

ROM_ORIGIN = 0x00001000;
ROM_LENGTH = 128 * 1024 * 1024;

RAM_ORIGIN = 0x80000000;
RAM_LENGTH = 8 * 1024 * 1024 * 1024;

MEMORY
{
	rom (rx) : ORIGIN = ROM_ORIGIN, LENGTH = ROM_LENGTH
	ram (rwx) : ORIGIN = RAM_ORIGIN, LENGTH = RAM_LENGTH
}

STACK_LENGTH = 1K;

SECTIONS
{
	.text :
	{
		*(.text.init)
	  	*(SORT(.text.sorted*))
	  	*(.text)
		*(.text.*)
	} > rom AT > rom

	.rodata :
	{
		*(.rodata)
		*(.rodata.*)
	} > rom AT > rom

	.tdata :
	{
		*(.tdata)
		*(.tdata.*)
	} > rom AT > ram

	.tbss :
	{
		*(.tbss)
		*(.tbss.*)
		*(.tcommon)
	} > rom AT > ram

	.data :
	{
		__DATA_BEGIN__ = .;
		*(.data)
		*(.data.*)
	} > rom AT > ram

	.sdata :
	{
		__SDATA_BEGIN__ = .;
		*(.srodata.cst16)
		*(.srodata.cst8)
		*(.srodata.cst4)
		*(.srodata.cst2)
		*(.srodata)
		*(.srodata.*)
		*(.sdata)
		*(.sdata.*)
	} > rom AT > ram

	__BSS_START__ = .;
	.sbss :
	{
		*(.sbss)
		*(.sbss.*)
		*(.scommon)
	} > rom AT > ram

	.bss :
	{
		*(.bss)
		*(.bss.*)
		. = ALIGN(. != 0 ? 64 / 8 : 1);
	} > rom AT > ram

	. = ALIGN(64 / 8);
	. = SEGMENT_START("ldata-segment", .);
	. = ALIGN(64 / 8);
	__BSS_END__ = .;

	__global_pointer$ = MIN(
		__SDATA_BEGIN__ + 0x800,
		MAX(__DATA_BEGIN__ + 0x800, __BSS_END__ - 0x800)
	);

	.stack :
	{
		. = ALIGN(16);
		. = . + STACK_LENGTH;
		. = ALIGN(16);
		__STACK_END__ = .;
	} > ram AT > ram
}
