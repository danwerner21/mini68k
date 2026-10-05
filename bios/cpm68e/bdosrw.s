#NO_APP
	.file	"bdosrw.c"
	.text
	.align	2
	.globl	blkindx
	.type	blkindx, @function
blkindx:
	link.w %fp,#0
	move.l %d2,-(%sp)
	move.l 8(%fp),%a1
	move.w gbls+18,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,%a0
	moveq #0,%d2
	move.b 2(%a0),%d2
	move.b 12(%a1),%d0
	and.b 4(%a0),%d0
	and.l #255,%d0
	moveq #7,%d1
	sub.l %d2,%d1
	lsl.l %d1,%d0
	moveq #0,%d1
	move.b 32(%a1),%d1
	asr.l %d2,%d1
	add.w %d1,%d0
	ext.l %d0
	move.l (%sp)+,%d2
	unlk %fp
	rts
	.size	blkindx, .-blkindx
	.align	2
	.globl	calcext
	.type	calcext, @function
calcext:
	link.w %fp,#0
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%a1
	lea (32,%a1),%a0
	moveq #15,%d2
.L4:
	tst.b -(%a0)
	jbne .L5
	subq.w #1,%d2
	jbne .L4
.L5:
	move.w gbls+18,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,%a0
	cmp.w #255,6(%a0)
	jbls .L7
	lsr.w #1,%d2
.L7:
	clr.w %d0
	move.b 4(%a0),%d0
	not.w %d0
	move.b 12(%a1),%d1
	and.w #31,%d1
	and.w %d1,%d0
	moveq #0,%d1
	move.w %d2,%d1
	moveq #0,%d2
	move.b 2(%a0),%d2
	moveq #7,%d3
	sub.l %d2,%d3
	asr.l %d3,%d1
	or.w %d1,%d0
	and.l #65535,%d0
	move.l (%sp)+,%d2
	move.l (%sp)+,%d3
	unlk %fp
	rts
	.size	calcext, .-calcext
	.align	2
	.globl	get_rc
	.type	get_rc, @function
get_rc:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l 8(%fp),%a2
	move.l %a2,-(%sp)
	jbsr calcext
	move.w %d0,%a0
	clr.w %d1
	move.b 12(%a2),%d1
	addq.l #4,%sp
	cmp.w %d0,%d1
	jbne .L12
	moveq #0,%d0
	move.b 15(%a2),%d0
	jbra .L14
.L12:
	moveq #127,%d0
	not.b %d0
	cmp.w %a0,%d1
	jbcs .L14
	clr.b %d0
.L14:
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	get_rc, .-get_rc
	.align	2
	.globl	new_ext
	.type	new_ext, @function
new_ext:
	link.w %fp,#0
	movm.l #0x3e30,-(%sp)
	move.l 8(%fp),%a2
	move.b 15(%fp),%d6
	tst.w 18(%fp)
	jbeq .L19
	move.b 34(%a2),%d1
	moveq #0,%d0
	move.b 33(%a2),%d0
	lsl.l #4,%d0
	move.b %d1,%d3
	lsr.b #4,%d3
	or.b %d0,%d3
	move.b %d1,%d2
	and.b #15,%d2
	add.b %d2,%d2
	tst.b 35(%a2)
	jbge .L21
	or.b #1,%d2
	jbra .L21
.L19:
	move.b 14(%a2),%d3
	and.b #63,%d3
	move.b 12(%a2),%d2
	addq.b #1,%d2
.L21:
	cmp.b #31,%d2
	jbls .L23
	addq.b #1,%d3
	clr.b %d2
.L23:
	cmp.b #63,%d3
	jbls .L25
	moveq #6,%d0
	jbra .L27
.L25:
	moveq #0,%d1
	move.b %d3,%d1
	move.b 14(%a2),%d0
	moveq #63,%d4
	and.l %d4,%d0
	cmp.l %d1,%d0
	jbne .L28
	move.b 12(%a2),%d1
	eor.b %d2,%d1
	move.w gbls+18,%a0
	move.w %a0,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,%a0
	move.b 4(%a0),%d0
	not.l %d0
	move.b #31,%d4
	and.l %d4,%d0
	and.l %d1,%d0
	jbne .L28
	move.b %d2,12(%a2)
	jbra .L27
.L28:
	move.l %a2,-(%sp)
	jbsr close_fi
	addq.l #4,%sp
	cmp.w #254,%d0
	jbls .L31
	moveq #3,%d0
	jbra .L27
.L31:
	move.b 14(%a2),%d5
	move.b 12(%a2),%d4
	move.b %d3,14(%a2)
	move.b %d2,12(%a2)
	clr.l -(%sp)
	move.l %a2,-(%sp)
	pea openfile
	lea dirscan,%a3
	jbsr (%a3)
	lea (12,%sp),%sp
	cmp.w #254,%d0
	jbls .L33
	tst.b %d6
	jbeq .L35
	move.b %d5,14(%a2)
	move.b %d4,12(%a2)
	moveq #4,%d0
	jbra .L27
.L35:
	pea 8.w
	move.l %a2,-(%sp)
	pea create
	jbsr (%a3)
	lea (12,%sp),%sp
	cmp.w #254,%d0
	jbls .L33
	moveq #5,%d0
	jbra .L27
.L33:
	moveq #0,%d0
.L27:
	movm.l -28(%fp),#0xc7c
	unlk %fp
	rts
	.size	new_ext, .-new_ext
	.align	2
	.globl	do_io
	.type	do_io, @function
do_io:
	link.w %fp,#0
	move.w gbls+18,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,%a0
	move.w 18(%fp),%a1
	move.l %a1,-(%sp)
	move.w gbls+24,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+26,%d0
	move.l %d0,-(%sp)
	moveq #0,%d1
	move.w 10(%fp),%d1
	moveq #0,%d0
	move.b 2(%a0),%d0
	lsl.l %d0,%d1
	move.b 15(%fp),%d0
	and.b 3(%a0),%d0
	and.l #255,%d0
	move.l %d1,%a0
	pea (%a0,%d0.l)
	jbsr rdwrt
	and.l #65535,%d0
	unlk %fp
	rts
	.size	do_io, .-do_io
	.align	2
	.globl	setblk
	.type	setblk, @function
setblk:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%a2
	move.w 14(%fp),%a0
	move.w 22(%fp),%d0
	and.b #127,14(%a2)
	move.l %a0,%d2
	tst.w 18(%fp)
	jbeq .L42
	move.w %d0,-(%sp)
	clr.w -(%sp)
	jbsr swap
	move.l %d2,%d1
	add.l %d2,%d1
	move.w %d0,16(%a2,%d1.l)
	addq.l #4,%sp
	jbra .L45
.L42:
	move.b %d0,16(%a2,%a0.l)
.L45:
	move.l -8(%fp),%d2
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	setblk, .-setblk
	.align	2
	.globl	blknum
	.type	blknum, @function
blknum:
	link.w %fp,#0
	move.l 8(%fp),%a1
	move.w 14(%fp),%a0
	tst.w 18(%fp)
	jbeq .L47
	add.l %a0,%a0
	move.w 16(%a1,%a0.l),%a1
	move.l %a1,-(%sp)
	jbsr swap
	and.l #65535,%d0
	addq.l #4,%sp
	jbra .L49
.L47:
	moveq #0,%d0
	move.b 16(%a1,%a0.l),%d0
.L49:
	unlk %fp
	rts
	.size	blknum, .-blknum
	.align	2
	.globl	bdosrw
	.type	bdosrw, @function
bdosrw:
	link.w %fp,#0
	movm.l #0x3f38,-(%sp)
	move.l 8(%fp),%a2
	move.l 12(%fp),%d1
	move.b %d1,%d4
	move.w 18(%fp),%d6
	move.w gbls+18,%a0
	move.w %a0,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,%a0
	move.w 6(%a0),%d3
	tst.b %d1
	jbne .L52
	tst.b 9(%a2)
	jbge .L52
	move.w gbls+10,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+12,%d0
	move.l %d0,%a0
	move.w 14(%a0),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 16(%a0),%d0
	move.l %d0,%a0
	moveq #0,%d0
	move.w 8(%a0),%d0
	move.l %d0,-(%sp)
	move.l %a2,-(%sp)
	jbsr ro_err
	addq.l #8,%sp
.L52:
	tst.w %d6
	jbeq .L55
	pea 1.w
	move.b %d4,%d0
	ext.w %d0
	move.w %d0,%a0
	move.l %a0,-(%sp)
	move.l %a2,-(%sp)
	jbsr new_ext
	lea (12,%sp),%sp
	tst.w %d0
	jbne .L83
	move.b 35(%a2),%d0
	and.b #127,%d0
	move.b %d0,32(%a2)
	jbra .L60
.L55:
	cmp.b #-128,32(%a2)
	jbne .L60
	clr.l -(%sp)
	move.b %d4,%d0
	ext.w %d0
	move.w %d0,%a0
	move.l %a0,-(%sp)
	move.l %a2,-(%sp)
	jbsr new_ext
	lea (12,%sp),%sp
	tst.w %d0
	jbne .L62
	clr.b 32(%a2)
.L60:
	move.b 15(%a2),%d7
	clr.w %d2
	move.b 32(%a2),%d2
	move.l %a2,-(%sp)
	jbsr get_rc
	addq.l #4,%sp
	cmp.w %d2,%d0
	jbhi .L64
	tst.b %d4
	jbne .L62
	and.b #127,14(%a2)
	move.b 32(%a2),%d7
	addq.b #1,%d7
.L64:
	move.l %a2,-(%sp)
	jbsr blkindx
	move.w %d0,%d2
	and.w #-256,%d3
	move.w %d3,%a4
	move.w %d0,%a3
	move.l %a4,(%sp)
	move.l %a3,-(%sp)
	move.l %a2,-(%sp)
	jbsr blknum
	move.w %d0,%d3
	lea (12,%sp),%sp
	jbeq .L67
	tst.b %d4
	seq %d0
	move.b %d0,%d1
	ext.w %d1
	neg.w %d1
	jbra .L69
.L67:
	tst.b %d4
	jbne .L62
	tst.w %d2
	jbne .L71
	sub.l %a0,%a0
	jbra .L73
.L71:
	lea (-1,%a3),%a0
.L73:
	move.l %a4,-(%sp)
	move.l %a0,-(%sp)
	move.l %a2,-(%sp)
	jbsr blknum
	move.w %d0,-(%sp)
	clr.w -(%sp)
	jbsr getaloc
	move.w %d0,%d3
	lea (16,%sp),%sp
	cmp.w #-1,%d0
	jbne .L74
	moveq #2,%d0
	jbra .L59
.L74:
	moveq #0,%d5
	move.w %d0,%d5
	move.l %d5,-(%sp)
	move.l %a4,-(%sp)
	move.l %a3,-(%sp)
	move.l %a2,-(%sp)
	jbsr setblk
	lea (16,%sp),%sp
	cmp.w #2,%d6
	jbeq .L76
	moveq #3,%d1
	jbra .L69
.L76:
	move.w gbls+24,%d0
	move.w %d0,%d4
	swap %d4
	mov.w gbls+26,%d4
	move.w gbls+14,%a0
	move.w %a0,%d1
	swap %d1
	mov.w gbls+16,%d1
	move.l %d1,%d0
	clr.w %d0
	swap %d0
	move.w %d0,gbls+24
	move.w %d1,gbls+26
	moveq #127,%d1
.L78:
	move.w gbls+24,%a0
	move.w %a0,%d0
	swap %d0
	mov.w gbls+26,%d0
	move.l %d0,%a0
	clr.b (%a0,%d1.l)
	dbra %d1,.L78
	clr.w %d1
	subq.l #1,%d1
	jbcc .L78
	moveq #3,%d1
	moveq #0,%d2
	jbra .L80
.L81:
	move.w %d1,%a0
	move.l %a0,-(%sp)
	moveq #0,%d0
	move.b %d2,%d0
	move.l %d0,-(%sp)
	move.l %d5,-(%sp)
	jbsr do_io
	addq.l #1,%d2
	moveq #1,%d1
	lea (12,%sp),%sp
.L80:
	move.w gbls+18,%a0
	move.w %a0,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,%a0
	moveq #0,%d0
	move.b 3(%a0),%d0
	cmp.l %d2,%d0
	jbge .L81
	move.l %d4,%d0
	clr.w %d0
	swap %d0
	move.w %d0,gbls+24
	move.w %d4,gbls+26
.L69:
	move.w %d1,%a0
	move.l %a0,-(%sp)
	moveq #0,%d0
	move.b 32(%a2),%d0
	move.l %d0,-(%sp)
	move.w %d3,-(%sp)
	clr.w -(%sp)
	jbsr do_io
	lea (12,%sp),%sp
	tst.w %d0
	jbne .L83
	move.b %d7,15(%a2)
	tst.w %d6
	jbne .L83
	addq.b #1,32(%a2)
.L83:
	and.l #65535,%d0
	jbra .L59
.L62:
	moveq #1,%d0
.L59:
	movm.l -36(%fp),#0x1cfc
	unlk %fp
	rts
	.size	bdosrw, .-bdosrw
	.comm	chainp,4,4
	.ident	"GCC: (GNU) 4.1.1"
