	.section	.text.init

	.globl	_start
_start:
	li	s0, 42
	li	s1, 58
	add	a0, s0, s1
	add	s2, zero, s0
	add	s3, zero, s1
	add	a1, zero, zero
