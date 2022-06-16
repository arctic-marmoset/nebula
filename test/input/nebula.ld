OUTPUT_ARCH(riscv)
ENTRY(_start)

RAM_ORIGIN = 0x80000000;
RAM_LENGTH = 8 * 1024 * 1024 * 1024;

MEMORY
{
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
	} > ram AT > ram

	.rodata :
	{
		*(.rodata)
		*(.rodata.*)
	} > ram AT > ram

	.tdata :
	{
		*(.tdata)
		*(.tdata.*)
	} > ram AT > ram

	.tbss :
	{
		*(.tbss)
		*(.tbss.*)
		*(.tcommon)
	} > ram AT > ram

	.data :
	{
		__DATA_BEGIN__ = .;
		*(.data)
		*(.data.*)
	} > ram AT > ram

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
	} > ram AT > ram

	__BSS_START__ = .;
	.sbss :
	{
		*(.sbss)
		*(.sbss.*)
		*(.scommon)
	} > ram AT > ram
 
	.bss :
	{
		*(.bss)
		*(.bss.*)
		. = ALIGN(. != 0 ? 64 / 8 : 1);
	} > ram AT > ram

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
