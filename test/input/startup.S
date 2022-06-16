	.section	.text.init

	.globl	_start
_start:
	.option	push
	.option	norelax
	la	gp, __global_pointer$
	.option	pop
	la	sp, __STACK_END__
	call	main
1:
	wfi
	j	1b
