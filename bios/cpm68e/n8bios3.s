#  n8bios3.s
/**********************************************************************
	Codes beginning "N8*.*" are affected by this notice.
	Other codes are copyrighted by Digital Research Inc.
***********************************************************************
	Copyright (C) 2012 John R. Coffman.
	Licensed for hobbyist use on the N8VEM mini-M68000 CPU board.
***********************************************************************

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    in the file COPYING in the distribution directory along with this
    program.  If not, see <http://www.gnu.org/licenses/>.

**********************************************************************/

/* entry points */
	.globl	_init
	.globl	bios3_trap_entry
	.globl	warm_boot

	.text
_init:
	movea.l	(%sp)+,%a6		/* grab the return address */
/* clearing the .BSS below will kill the return */

	/* any initialization goes here */
addr_trap3	=   (32+3)*4
	move.l	#bios3_trap_entry,addr_trap3	/* install CP/M-68 BIOS on trap #3 */

/* clear the .BSS */
	movea.l	#__bss_start,%a0
	move.l	#_end,%d1
	sub.l	%a0,%d1
	lsr.l	#2,%d1
	br.s	zap1
zap:	clr.l	(%a0)+
zap1:	dbra	%d1,zap


/* first part of the disk system initialization */
	jsr	disk_system_init

/* last part of disk initialization is to set up the RAMdisk */
/* this must always be done last, after all the other disks/partitions */
	jsr	init_ramdisk	/* in 'n8io.c' */

	movea.l	#copyright,%a0
	clr.l	%d1		/* NUL terminator */
	moveq.l	#3,%d0		/* put string call */
	trap	#8
	
	movea.l	#retrobrew,%a0	/* moved to exceptn.s */
	clr.l	%d1		/* NUL terminator */
	moveq.l	#3,%d0		/* put string */
	trap	#8

	move.w	#0x0005,%d0	/* set user=0 and disk=5 */
	jmp	(%a6)		/* return */




/*
  CP/M bios calls [0-22]
*/
/************************************************************************
	enter with:

		D0.w		call number
		D1.w, D1.l	parameter 1
		D2.w, D2.l	parameter 2

	return with:

		possible code in D0.b,w,l

************************************************************************/
bios3_trap_entry:
	cmp.w	#n_cpm_vectors/4,%d0	
	blo.s	okay
	move.l	#n_cpm_vectors/4,%d0	/* set to 23 -- undefined */
okay:
	movem.l	%d1-%d2/%a0-%a1,-(%sp)	/* register save */
	lsl.w	#2,%d0			/* multiply by 4 */
	move.l	cpm_vector(%pc,%d0.w),%a1
.if !RETAIL
	lsr.w	#2,%d0			/* restore D0 */
.endif
	jsr	(%a1)			/* C-callable routine */
	movem.l	(%sp)+,%d1-%d2/%a0-%a1
	rte				/* return from exception */

undefined:
.if !RETAIL
	illegal
.endif
	move.l	#-1,%d0			/* give error return */
	rts

cpm_vector:
	.long	cold_boot		/* 0 -- cold initialization */
	.long	warm_boot		/* 1 -- warm boot */
	.long	console_status		/* 2 -- console status */
	.long	console_read		/* 3 -- console read character (waits) */
	.long	console_write		/* 4 -- console put character */
	.long	list_output		/* 5 -- list device output */
	.long	aux_output		/* 6 -- auxiliary output */
	.long	aux_input		/* 7 -- auxiliary input */
	.long	disk_home		/* 8 -- home selected disk drive */
	.long	disk_drive_select	/* 9 -- select disk drive */
	.long	disk_set_track		/* 10 -  */
	.long	disk_set_sector		/* 11 -  */
	.long	disk_set_DMA_address	/* 12 -  */
	.long	disk_read_sector	/* 13 -  */
	.long	disk_write_sector	/* 14 -  */
	.long	list_status		/* 15 - list ready status */
	.long	sector_translate	/* 16 - sector translation */
	.long	undefined		/* 17 - ??? alternate set DMA ??? */
	.long	get_TPA_pointer		/* 18 - get TPA pointer */
	.long	get_iobyte		/* 19 - get IObyte */
	.long	set_iobyte		/* 20 - set IObyte */
	.long	disk_flush_buffers	/* 21 -  */
	.long	set_trap_vector		/* 22 - set exception vector */
n_cpm_vectors	=	. - cpm_vector
	.long	undefined		/* 23 - error vector */


/* function 0 */
cold_boot:
	jmp	cpm		/* start from the beginning */

/* function 1 */
warm_boot:
	lea	stack,%sp	/* set up the supervisor stack */
				/* _ccp will set the user stack pointer */

	jsr	disk_flush_buffers
  /* do a lot of init in here */
	jmp	_ccp		/* execute CCP in supervisor state */


/* function 2 */
console_status:
	move.l	#5,%d0
	trap	#8
	tst.w	%d0
	beq.w	csret
	move.w	#0x00FF,%d0
csret:
	rts

/* function 3 */
console_read:
	move.l	#4,%d0
	trap	#8
	clr.l	%d0		/* eliminate; D0 comes back = 0 */
	move.b	%d1,%d0
	rts

/* function 4 */
console_write:
	move.l	#2,%d0
	trap	#8
	rts

/* function 5 */
list_output:
	rts

/* function 6 */
aux_output:
	move.w	%d1,%d0		/* return same character in D0 */
	rts

/* function 7 */
aux_input:
	move.l	#0x1A,%d0	/* Ctrl-Z == End-of-File */
	rts

.if 0
/* function 9 -- made into a C-call */
drive_select:
/* 	D0.b is drive number
	D1.b is logged in flag

    Returns:
	D0.l	address of drive's DPH
		(Null if error)			*/
	clr.l	%d0
	rts
.endif

/* function 15 */
list_status:
	move.l	#0xFF,%d0		/* FF == ready, 00 == not ready */
	rts

/* function 16 - logical CP/M sector to physical CP/M sector mapping */
sector_translate:
	move.w	%d1,%d0		/* no sector translation */
	rts


	.data
ioword:	.byte	0
iobyte:	.byte	0b10010100	/* 2=LPT:, 1=PTP:, 1=PTR:, 0=TTY: */

tpa_start	=	0x1000	/* start TPA */

tpa_stuff:
	.word	1		/* one entry only */
	.long	tpa_start
	.long	cpm - tpa_start	/* length */

	.text
/* function 18 	*/
get_TPA_pointer:
	move.l	#tpa_stuff,%d0
	rts

/* function 19  */
get_iobyte:
	move.w	ioword,%d0
	rts

/* function 20  */
set_iobyte:
	move.b	%d0,iobyte
	rts

/* function 22   */
set_trap_vector:
	cmp.w	#64,%d1		/* up to 64 trap vectors */
	bcc	undefined
	add.w	%d1,%d1		/* multiply by 4 */
	add.w	%d1,%d1
	ext.l	%d1		/* sign extend to 32 bits */
	move.l	%d1,%a1		/* address the trap vector */
	move.l	(%a1),%d0	/* return old vector */
	move.l	%d2,(%a1)	/* set new vector */
	rts


	.end


