#NO_APP
	.file	"dskutil.c"
	.text
	.align	2
	.globl	dchksum
	.type	dchksum, @function
dchksum:
	link.w %fp,#0
	move.w gbls+14,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+16,%d0
	move.l %d0,%a0
	moveq #0,%d1
	moveq #0,%d0
.L2:
	add.l (%a0,%d0.l),%d1
	addq.l #4,%d0
	cmp.l #128,%d0
	jbne .L2
	move.l %d1,%d0
	swap %d0
	ext.l %d0
	add.l %d1,%d0
	move.l %d0,%d1
	asr.l #8,%d1
	add.l %d1,%d0
	and.l #255,%d0
	unlk %fp
	rts
	.size	dchksum, .-dchksum
	.align	2
	.globl	setaloc
	.type	setaloc, @function
setaloc:
	link.w %fp,#0
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%d0
	move.w %d0,%d3
	jblt .L11
	move.w %d0,%d2
	ext.l %d2
	move.w gbls+18,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,%a0
	moveq #0,%d0
	move.w 6(%a0),%d0
	cmp.l %d2,%d0
	jblt .L11
	move.w gbls+10,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+12,%d0
	move.l %d0,%a0
	move.w 22(%a0),%a1
	move.w %a1,%d1
	swap %d1
	mov.w 24(%a0),%d1
	asr.w #3,%d3
	moveq #7,%d0
	and.l %d0,%d2
	moveq #127,%d0
	not.b %d0
	asr.l %d2,%d0
	move.w %d3,%a1
	move.l %d1,%a0
	or.b %d0,(%a0,%a1.l)
.L11:
	move.l (%sp)+,%d2
	move.l (%sp)+,%d3
	unlk %fp
	rts
	.size	setaloc, .-setaloc
	.align	2
	.globl	clraloc
	.type	clraloc, @function
clraloc:
	link.w %fp,#0
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%d0
	move.w %d0,%d3
	jble .L16
	move.w %d0,%d2
	ext.l %d2
	move.w gbls+18,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,%a0
	moveq #0,%d0
	move.w 6(%a0),%d0
	cmp.l %d2,%d0
	jblt .L16
	move.w gbls+10,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+12,%d0
	move.l %d0,%a0
	move.w 22(%a0),%a1
	move.w %a1,%d1
	swap %d1
	mov.w 24(%a0),%d1
	asr.w #3,%d3
	moveq #7,%d0
	and.l %d0,%d2
	moveq #127,%d0
	not.b %d0
	asr.l %d2,%d0
	not.b %d0
	move.w %d3,%a1
	move.l %d1,%a0
	and.b %d0,(%a0,%a1.l)
.L16:
	move.l (%sp)+,%d2
	move.l (%sp)+,%d3
	unlk %fp
	rts
	.size	clraloc, .-clraloc
	.align	2
	.globl	chkaloc
	.type	chkaloc, @function
chkaloc:
	link.w %fp,#0
	move.l %d2,-(%sp)
	move.w 10(%fp),%d2
	move.w gbls+10,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+12,%d0
	move.l %d0,%a0
	move.w 22(%a0),%d0
	move.w %d0,%d1
	swap %d1
	mov.w 24(%a0),%d1
	move.w %d2,%d0
	lsr.w #3,%d0
	and.l #65535,%d0
	move.l %d1,%a0
	move.b (%a0,%d0.l),%d0
	and.w #255,%d0
	not.w %d0
	moveq #7,%d1
	and.l %d1,%d2
	moveq #127,%d1
	not.b %d1
	asr.l %d2,%d1
	and.w %d1,%d0
	and.l #65535,%d0
	move.l (%sp)+,%d2
	unlk %fp
	rts
	.size	chkaloc, .-chkaloc
	.align	2
	.globl	getaloc
	.type	getaloc, @function
getaloc:
	link.w %fp,#0
	movm.l #0x3800,-(%sp)
	move.l 8(%fp),%d1
	move.w %d1,%d3
	move.w gbls+18,%a0
	move.w %a0,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,%a0
	move.w 6(%a0),%d4
	move.w %d1,%d2
	jbra .L38
.L21:
	subq.w #1,%d3
	move.w %d3,-(%sp)
	clr.w -(%sp)
	jbsr chkaloc
	addq.l #4,%sp
	tst.w %d0
	jbne .L22
	cmp.w %d2,%d4
	jbls .L38
.L24:
	addq.w #1,%d2
	move.w %d2,-(%sp)
	clr.w -(%sp)
	jbsr chkaloc
	addq.l #4,%sp
	tst.w %d0
	jbne .L26
.L38:
	tst.w %d3
	jbne .L21
	cmp.w %d2,%d4
	jbhi .L24
	moveq #-1,%d2
	jbra .L29
.L22:
	move.w %d3,%d2
.L26:
	cmp.w #-1,%d2
	jbeq .L29
	move.w %d2,-(%sp)
	clr.w -(%sp)
	jbsr setaloc
	addq.l #4,%sp
.L29:
	moveq #0,%d0
	move.w %d2,%d0
	movm.l -12(%fp),#0x1c
	unlk %fp
	rts
	.size	getaloc, .-getaloc
	.align	2
	.globl	rdwrt
	.type	rdwrt, @function
rdwrt:
	link.w %fp,#-20
	movm.l #0x3c00,-(%sp)
	move.l 8(%fp),%d4
	move.l 12(%fp),%d5
	move.l 16(%fp),%d0
	move.w %d0,%d3
	move.b gbls+6,%d2
	move.b %d2,-15(%fp)
	tst.w %d0
	jbeq .L40
	move.b #2,-18(%fp)
	subq.b #1,%d0
	move.b %d0,-17(%fp)
	moveq #0,%d1
	move.w ro_dsk,%d1
	moveq #0,%d0
	move.b %d2,%d0
	btst %d0,%d1
	jbeq .L42
	pea 4.w
	jbsr error
	addq.l #4,%sp
	jbra .L42
.L40:
	move.b #1,-18(%fp)
	clr.b -17(%fp)
.L42:
	move.l %d4,%d0
	clr.w %d0
	swap %d0
	move.w %d0,-14(%fp)
	move.w %d4,-12(%fp)
	move.l %d5,%d0
	clr.w %d0
	swap %d0
	move.w %d0,-8(%fp)
	move.w %d5,-6(%fp)
	move.w gbls+10,%d0
	move.w %d0,%d1
	swap %d1
	mov.w gbls+12,%d1
	move.l %d1,%d0
	clr.w %d0
	swap %d0
	move.w %d0,-4(%fp)
	move.w %d1,-2(%fp)
	jbra .L44
.L45:
	tst.w %d3
	sne %d0
	ext.w %d0
	ext.l %d0
	neg.l %d0
	move.l %d0,-(%sp)
	jbsr error
	addq.l #4,%sp
	tst.w %d0
	jbne .L46
.L44:
	pea -18(%fp)
	jbsr do_phio
	addq.l #4,%sp
	tst.w %d0
	jbne .L45
.L46:
	moveq #0,%d0
	movm.l -36(%fp),#0x3c
	unlk %fp
	rts
	.size	rdwrt, .-rdwrt
	.align	2
	.globl	dir_wr
	.type	dir_wr, @function
dir_wr:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	pea 2.w
	move.w gbls+14,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+16,%d0
	move.l %d0,-(%sp)
	move.w 10(%fp),%a2
	move.l %a2,-(%sp)
	jbsr rdwrt
	move.w %d0,%d2
	move.w gbls+18,%a0
	move.w %a0,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,%a0
	moveq #0,%d0
	move.w 12(%a0),%d0
	lea (12,%sp),%sp
	cmp.l %a2,%d0
	jble .L49
	move.w gbls+10,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+12,%d0
	move.l %d0,%a0
	move.w 18(%a0),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 20(%a0),%d0
	lea (%a2,%d0.l),%a2
	jbsr dchksum
	move.b %d0,(%a2)
.L49:
	moveq #0,%d0
	move.w %d2,%d0
	move.l -8(%fp),%d2
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	dir_wr, .-dir_wr
	.align	2
	.globl	dir_rd
	.type	dir_rd, @function
dir_rd:
	link.w %fp,#0
	clr.l -(%sp)
	move.w gbls+14,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+16,%d0
	move.l %d0,-(%sp)
	move.w 10(%fp),%a0
	move.l %a0,-(%sp)
	jbsr rdwrt
	and.l #65535,%d0
	unlk %fp
	rts
	.size	dir_rd, .-dir_rd
	.align	2
	.globl	dirscan
	.type	dirscan, @function
dirscan:
	link.w %fp,#0
	movm.l #0x3f3c,-(%sp)
	move.l 12(%fp),%a5
	move.w gbls+18,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,%a3
	moveq #0,%d6
	move.w 18(%fp),%d6
	btst #0,%d6
	jbne .L55
	clr.w %d4
	jbra .L57
.L55:
	move.w gbls+22,%d4
	addq.w #1,%d4
.L57:
	move.w #255,%a4
	jbra .L58
.L76:
	jbsr (%a0)
	move.b %d0,(%a2)
	jbra .L62
.L77:
	or.w %d1,ro_dsk
	jbra .L62
.L59:
	cmp.w 8(%a3),%d4
	jbhi .L60
	moveq #0,%d7
	move.w %d4,%d7
	moveq #3,%d5
	and.l %d7,%d5
	jbne .L62
.L63:
.L78:
	move.w %d4,%d2
	lsr.w #2,%d2
	moveq #0,%d3
	move.w %d2,%d3
	move.l %d3,-(%sp)
	jbsr dir_rd
	addq.l #4,%sp
	cmp.w 12(%a3),%d2
	jbcc .L62
	move.w gbls+10,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+12,%d0
	move.l %d0,%a0
	move.w 18(%a0),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 20(%a0),%d0
	move.l %d0,%a2
	add.l %d3,%a2
	lea dchksum,%a0
	btst #2,%d6
	jbne .L76
	move.b (%a2),%d2
	jbsr (%a0)
	cmp.b %d2,%d0
	jbeq .L62
	move.w gbls+10,%a0
	move.w %a0,%d0
	swap %d0
	mov.w gbls+12,%d0
	move.l %d0,%a0
	move.w 8(%a3),4(%a0)
	moveq #0,%d2
	move.b gbls+6,%d2
	moveq #1,%d0
	move.l %d0,%d1
	lsl.l %d2,%d1
	move.w %d1,%d0
	and.w crit_dsk,%d0
	jbne .L77
	not.w %d1
	and.w %d1,log_dsk
	move.l %d2,-(%sp)
	jbsr seldsk
	addq.l #4,%sp
	jbra .L78
.L62:
	move.w %d4,gbls+22
	move.l %d7,-(%sp)
	move.w gbls+14,%d0
	move.w %d0,%d1
	swap %d1
	mov.w gbls+16,%d1
	moveq #3,%d0
	and.l %d4,%d0
	lsl.l #5,%d0
	move.l %d1,%a0
	pea (%a0,%d0.l)
	move.l %a5,-(%sp)
	move.l 8(%fp),%a0
	jbsr (%a0)
	lea (12,%sp),%sp
	tst.b %d0
	jbeq .L70
	btst #1,%d6
	jbeq .L72
	sub.l %a4,%a4
.L70:
	addq.w #1,%d4
.L58:
	btst #3,%d6
	jbne .L59
	moveq #0,%d1
	move.w %d4,%d1
	move.w gbls+10,%a0
	move.w %a0,%d0
	swap %d0
	mov.w gbls+12,%d0
	move.l %d0,%a0
	moveq #0,%d0
	move.w 4(%a0),%d0
	addq.l #1,%d0
	cmp.l %d1,%d0
	jbge .L59
.L60:
	moveq #0,%d5
	move.w %a4,%d5
.L72:
	move.l %d5,%d0
	movm.l -40(%fp),#0x3cfc
	unlk %fp
	rts
	.size	dirscan, .-dirscan
	.comm	chainp,4,4
	.ident	"GCC: (GNU) 4.1.1"
