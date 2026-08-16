/* 0cpm68k.s -- header for a CP/M-68 *.68K file */


	.globl	__text_size
	.globl	__data_size
	.globl	__bss_size
	.globl	_start

	.text

h0	=	.
	.word	0x601a
	.long	__text_size - lh0
	.long	__data_size
	.long	__bss_size
	.long	0				/* symbol table size */
	.long	0				/* stack size */
	.long	_start			/* entry point */
	.word	0xffff			/* relocation bits suppressed flag */
lh0	=	. - h0

	.end
