#NO_APP
	.file	"bdosmisc.c"
	.text
	.align	2
	.globl	setexc
	.type	setexc, @function
setexc:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l 8(%fp),%a2
	move.w (%a2),%d1
	subq.w #2,%d1
	move.w %d1,%d0
	add.w #-32,%d0
	move.l #65535,%a0
	cmp.w #1,%d0
	jbls .L4
	addq.w #2,%d0
	cmp.w #7,%d0
	jbhi .L5
	add.w #-20,%d1
	jbra .L7
.L5:
	move.w #255,%a0
	cmp.w #9,%d1
	jbhi .L4
.L7:
	move.w %d1,%a0
	lea gbls+32,%a1
	add.l %a0,%a0
	add.l %a0,%a0
	move.w (%a1,%a0.l),%d0
	move.w %d0,%d1
	swap %d1
	mov.w 2(%a1,%a0.l),%d1
	move.l %d1,%d0
	clr.w %d0
	swap %d0
	move.w %d0,6(%a2)
	move.w %d1,8(%a2)
	move.w 2(%a2),%d0
	move.w %d0,%d1
	swap %d1
	mov.w 4(%a2),%d1
	move.l %d1,%d0
	clr.w %d0
	swap %d0
	move.w %d0,(%a1,%a0.l)
	move.w %d1,2(%a1,%a0.l)
	sub.l %a0,%a0
.L4:
	move.l %a0,%d0
	move.l (%sp)+,%a2
	unlk %fp
	rts
	.size	setexc, .-setexc
	.align	2
	.globl	set_tpa
	.type	set_tpa, @function
set_tpa:
	link.w %fp,#0
	move.l %d2,-(%sp)
	move.l 8(%fp),%a0
	moveq #0,%d2
	move.w (%a0),%d2
	btst #0,%d2
	jbeq .L11
	move.w 2(%a0),%d0
	move.w %d0,%d1
	swap %d1
	mov.w 4(%a0),%d1
	move.l %d1,tpa_lt
	move.w 6(%a0),%a1
	move.w %a1,%d0
	swap %d0
	mov.w 8(%a0),%d0
	move.l %d0,tpa_ht
	btst #1,%d2
	jbeq .L15
	move.l %d1,tpa_lp
	move.l %d0,tpa_hp
	jbra .L15
.L11:
	move.w tpa_lt,2(%a0)
	move.w tpa_lt+2,4(%a0)
	move.w tpa_ht,6(%a0)
	move.w tpa_ht+2,8(%a0)
.L15:
	move.l (%sp)+,%d2
	unlk %fp
	rts
	.size	set_tpa, .-set_tpa
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	" error on drive $"
	.text
	.align	2
	.globl	prt_err
	.type	prt_err, @function
prt_err:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l 8(%fp),-(%sp)
	lea prt_line,%a2
	jbsr (%a2)
	pea .LC0
	jbsr (%a2)
	moveq #0,%d0
	move.b gbls+6,%d0
	move.l %d0,%a0
	pea 65(%a0)
	jbsr conout
	lea (12,%sp),%sp
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	prt_err, .-prt_err
	.align	2
	.globl	warmboot
	.type	warmboot, @function
warmboot:
	link.w %fp,#0
	move.l 8(%fp),%d1
	cmp.w #2,%d1
	jbeq .L19
	move.w ro_dsk,%d0
	not.w %d0
	and.w %d0,log_dsk
	clr.w ro_dsk
	clr.w crit_dsk
	tst.w %d1
	jbne .L21
	jbra .L22
.L19:
	moveq #0,%d1
	move.b gbls+6,%d1
	moveq #1,%d0
	lsl.l %d1,%d0
	and.w %d0,log_dsk
	clr.w ro_dsk
	clr.w crit_dsk
.L21:
	clr.b morecmds
	clr.b submit
.L22:
	st gbls+6
	move.l tpa_lp,tpa_lt
	move.l tpa_hp,tpa_ht
	pea gbls+32
	jbsr initexc
	pea 1.w
	jbsr _bios1
	addq.l #8,%sp
	unlk %fp
	rts
	.size	warmboot, .-warmboot
	.section	.rodata.str1.1
.LC1:
	.string	"CP/M Disk file error: $"
.LC2:
	.string	" is read-only.$"
.LC3:
	.string	"\r\nDo you want to: Change it to read/write (C), or Abort (A)? $"
.LC4:
	.string	"\r\n$"
	.text
	.align	2
	.globl	ro_err
	.type	ro_err, @function
ro_err:
	link.w %fp,#0
	movm.l #0x3038,-(%sp)
	move.l 8(%fp),%a4
	move.w 14(%fp),%d3
	pea .LC1
	jbsr prt_line
	move.l %a4,%a2
	addq.l #4,%sp
.L25:
	addq.l #1,%a2
	move.b (%a2),%d0
	moveq #127,%d1
	and.l %d1,%d0
	move.l %d0,-(%sp)
	lea conout,%a3
	jbsr (%a3)
	lea (8,%a4),%a0
	addq.l #4,%sp
	cmp.l %a2,%a0
	jbne .L25
	pea 46.w
	jbsr (%a3)
	addq.l #4,%sp
.L27:
	addq.l #1,%a2
	move.b (%a2),%d0
	moveq #127,%d1
	and.l %d1,%d0
	move.l %d0,-(%sp)
	jbsr conout
	lea (11,%a4),%a0
	addq.l #4,%sp
	cmp.l %a2,%a0
	jbne .L27
	pea .LC2
	lea prt_line,%a2
	jbsr (%a2)
	move.l warning,-(%sp)
	jbsr (%a2)
	addq.l #8,%sp
.L29:
	pea .LC3
	lea prt_line,%a2
	jbsr (%a2)
	jbsr conin
	move.b %d0,%d2
	pea .LC4
	jbsr (%a2)
	addq.l #8,%sp
	and.b #95,%d2
	cmp.b #65,%d2
	jbeq .L31
	cmp.b #67,%d2
	jbeq .L32
	cmp.b #3,%d2
	jbne .L29
	pea 1.w
	jbsr warmboot
	addq.l #4,%sp
.L31:
	pea 1.w
	jbsr warmboot
	addq.l #4,%sp
.L32:
	and.b #127,9(%a4)
	pea 2.w
	move.l %a4,-(%sp)
	pea set_attr
	jbsr dirscan
	asr.w #2,%d3
	move.w %d3,%a0
	move.l %a0,-(%sp)
	jbsr dir_rd
	and.l #65535,%d0
	movm.l -20(%fp),#0x1c0c
	unlk %fp
	rts
	.size	ro_err, .-ro_err
	.section	.rodata.str1.1
.LC5:
	.string	"\n\rDo you want to:  Abort (A),  Retry (R)$"
.LC6:
	.string	", or Continue with bad data (C)$"
.LC7:
	.string	"? $"
	.text
	.align	2
	.globl	ext_err
	.type	ext_err, @function
ext_err:
	link.w %fp,#0
	movm.l #0x3020,-(%sp)
	move.b 11(%fp),%d3
	move.l 12(%fp),-(%sp)
	jbsr prt_err
	move.l warning,-(%sp)
	jbsr prt_line
	addq.l #8,%sp
.L57:
	pea .LC5
	lea prt_line,%a2
	jbsr (%a2)
	addq.l #4,%sp
	tst.b %d3
	jbeq .L42
	pea .LC6
	jbsr (%a2)
	addq.l #4,%sp
.L42:
	pea .LC7
	jbsr (%a2)
	jbsr conin
	move.b %d0,%d2
	pea .LC4
	jbsr (%a2)
	addq.l #8,%sp
	and.b #95,%d2
	cmp.b #65,%d2
	jbeq .L45
	jbhi .L48
	cmp.b #3,%d2
	jbne .L57
	jbra .L44
.L48:
	cmp.b #67,%d2
	jbeq .L46
	cmp.b #82,%d2
	jbne .L57
	moveq #0,%d0
	jbra .L49
.L44:
	pea 1.w
	jbsr warmboot
	addq.l #4,%sp
.L45:
	pea 1.w
	jbsr warmboot
	addq.l #4,%sp
.L46:
	tst.b %d3
	jbeq .L57
	moveq #1,%d0
.L49:
	movm.l -12(%fp),#0x40c
	unlk %fp
	rts
	.size	ext_err, .-ext_err
	.align	2
	.globl	abrt_err
	.type	abrt_err, @function
abrt_err:
	link.w %fp,#0
	move.l 8(%fp),-(%sp)
	jbsr prt_err
	pea 1.w
	jbsr warmboot
	addq.l #8,%sp
	unlk %fp
	rts
	.size	abrt_err, .-abrt_err
	.section	.rodata.str1.1
.LC8:
	.string	"\r\nCP/M Disk $"
.LC9:
	.string	"read$"
.LC10:
	.string	"write$"
.LC11:
	.string	"select$"
.LC12:
	.string	"change$"
	.text
	.align	2
	.globl	error
	.type	error, @function
error:
	link.w %fp,#0
	move.l %d2,-(%sp)
	move.w 10(%fp),%d2
	pea .LC8
	jbsr prt_line
	addq.l #4,%sp
	cmp.w #4,%d2
	jbhi .L61
	moveq #0,%d0
	move.w %d2,%d0
	add.l %d0,%d0
	.set .LI67,.+2
	move.w .L67-.LI67.b(%pc,%d0.l),%d0
	jmp %pc@(2,%d0:w)
	.align	2
	.swbeg	&5
.L67:
	.word .L62-.L67
	.word .L63-.L67
	.word .L64-.L67
	.word .L65-.L67
	.word .L66-.L67
.L61:
	moveq #0,%d0
	jbra .L68
.L62:
	pea .LC9
	jbra .L70
.L63:
	pea .LC10
.L70:
	pea 1.w
.L71:
	jbsr ext_err
	and.l #65535,%d0
	addq.l #8,%sp
	jbra .L68
.L64:
	pea .LC11
	jbsr abrt_err
	addq.l #4,%sp
.L65:
	pea .LC11
	clr.l -(%sp)
	jbra .L71
.L66:
	pea .LC12
	jbsr abrt_err
	moveq #0,%d0
	addq.l #4,%sp
.L68:
	move.l -4(%fp),%d2
	unlk %fp
	rts
	.size	error, .-error
	.align	2
	.globl	bdosinit
	.type	bdosinit, @function
bdosinit:
	link.w %fp,#0
	pea _trap2hnd
	pea 34.w
	pea 22.w
	jbsr _bios5
	clr.b gbls
	move.l #gbls+112,%d0
	move.l %d0,%d1
	clr.w %d1
	swap %d1
	move.w %d1,gbls+108
	and.l #65535,%d0
	move.w %d0,gbls+110
	move.w %d1,gbls+104
	move.w %d0,gbls+106
	move.b #36,gbls+1
	clr.b gbls+2
	move.b #1,gbls+3
	clr.l chainp
	pea 13.w
	jbsr __bdos
	pea 18.w
	jbsr _bios6
	move.l %d0,%a0
	move.w 2(%a0),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 4(%a0),%d0
	move.l %d0,tpa_lp
	move.l %d0,tpa_lt
	move.w 6(%a0),%a1
	move.w %a1,%d1
	swap %d1
	mov.w 8(%a0),%d1
	add.l %d1,%d0
	move.l %d0,tpa_hp
	move.l %d0,tpa_ht
	pea gbls+32
	jbsr initexc
	lea (24,%sp),%sp
	unlk %fp
	rts
	.size	bdosinit, .-bdosinit
	.globl	warning
	.section	.rodata.str1.1
.LC13:
	.string	"\r\nWARNING -- Do not attempt to change disks$"
	.data
	.align	4
	.type	warning, @object
	.size	warning, 4
warning:
	.long	.LC13
	.comm	chainp,4,4
	.ident	"GCC: (GNU) 4.1.1"
