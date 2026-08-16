#************************************************************************
#									*
#		     THIS IS THE SYSTEM STACK AREA			*
#									*
#									*
#	   THIS IS THE DUAL PROCESSOR,ROMABLE CP/M-68K SYSTEM		*
#	   ==================================================		*
#************************************************************************

	.globl	stack

	.bss
				/* supervisor stack or
					master stack on 68020 and above */

	.ds.l	1024		/* add extra 200 on mini-M68k */
stack:
	.ds.w	1

	.end

