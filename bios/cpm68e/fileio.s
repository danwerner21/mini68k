#NO_APP
	.file	"fileio.c"
	.text
	.align	2
	.globl	move
	.type	move, @function
move:
	link.w %fp,#0
	move.l 8(%fp),%a1
	move.l 12(%fp),%a0
	move.w 18(%fp),%d0
	jbra .L2
.L3:
	move.b (%a1)+,(%a0)+
.L2:
	dbra %d0,.L3
	unlk %fp
	rts
	.size	move, .-move
	.align	2
	.globl	match
	.type	match, @function
match:
	link.w %fp,#0
	movm.l #0x3820,-(%sp)
	move.l 8(%fp),%a1
	move.l 12(%fp),%a0
	move.b 19(%fp),%d3
	moveq #12,%d2
.L7:
	move.b (%a1),%d1
	move.b (%a0),%d0
	eor.b %d1,%d0
	moveq #127,%d4
	and.l %d4,%d0
	jbeq .L8
	cmp.b #63,%d1
	jbne .L10
.L8:
	addq.l #1,%a1
	addq.l #1,%a0
	cmp.w #1,%d2
	jbeq .L11
	subq.w #1,%d2
	jbra .L7
.L11:
	tst.b %d3
	jbne .L13
	moveq #1,%d0
	jbra .L15
.L13:
	move.b (%a1),%d1
	cmp.b #63,%d1
	jbeq .L16
	move.b (%a0),%d0
	eor.b %d0,%d1
	and.l #255,%d1
	move.w gbls+18,%d2
	move.w %d2,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,%a2
	moveq #0,%d0
	move.b 4(%a2),%d0
	not.l %d0
	and.l %d0,%d1
	jbne .L10
.L16:
	move.b 2(%a1),%d0
	move.b 2(%a0),%d1
	eor.b %d1,%d0
	moveq #63,%d2
	and.l %d2,%d0
	sne %d0
	neg.b %d0
	eor.b #1,%d0
	and.l #255,%d0
	jbra .L15
.L10:
	moveq #0,%d0
.L15:
	movm.l (%sp)+,#0x41c
	unlk %fp
	rts
	.size	match, .-match
	.align	2
	.globl	openfile
	.type	openfile, @function
openfile:
	link.w %fp,#0
	movm.l #0x3820,-(%sp)
	move.l 8(%fp),%a2
	move.l 12(%fp),%d4
	pea 1.w
	move.l %d4,-(%sp)
	move.l %a2,-(%sp)
	jbsr match
	move.b %d0,%d3
	lea (12,%sp),%sp
	jbeq .L20
	move.b 12(%a2),%d2
	pea 32.w
	move.l %a2,-(%sp)
	move.l %d4,-(%sp)
	jbsr move
	move.b %d2,12(%a2)
	or.b #-128,14(%a2)
	moveq #0,%d1
	move.b gbls+6,%d1
	moveq #1,%d0
	lsl.l %d1,%d0
	or.w %d0,crit_dsk
	lea (12,%sp),%sp
.L20:
	move.b %d3,%d0
	ext.w %d0
	ext.l %d0
	movm.l -16(%fp),#0x41c
	unlk %fp
	rts
	.size	openfile, .-openfile
	.align	2
	.globl	alltrue
	.type	alltrue, @function
alltrue:
	link.w %fp,#0
	moveq #1,%d0
	unlk %fp
	rts
	.size	alltrue, .-alltrue
	.align	2
	.globl	matchit
	.type	matchit, @function
matchit:
	link.w %fp,#0
	pea 1.w
	move.l 12(%fp),-(%sp)
	move.l 8(%fp),-(%sp)
	jbsr match
	ext.w %d0
	ext.l %d0
	unlk %fp
	rts
	.size	matchit, .-matchit
	.align	2
	.globl	extsize
	.type	extsize, @function
extsize:
	link.w %fp,#0
	move.l %d2,-(%sp)
	move.l 8(%fp),%a0
	move.b 12(%a0),%d0
	moveq #31,%d1
	and.l %d1,%d0
	lsl.l #7,%d0
	move.b 14(%a0),%d1
	moveq #63,%d2
	and.l %d2,%d1
	move.b #12,%d2
	lsl.l %d2,%d1
	or.l %d1,%d0
	move.l (%sp)+,%d2
	unlk %fp
	rts
	.size	extsize, .-extsize
	.align	2
	.globl	setran
	.type	setran, @function
setran:
	link.w %fp,#-4
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%a2
	moveq #0,%d2
	move.b 32(%a2),%d2
	move.l %a2,-(%sp)
	jbsr extsize
	addq.l #4,%sp
	add.l %d0,%d2
	move.l %d2,%d0
	clr.w %d0
	swap %d0
	move.w %d0,-4(%fp)
	move.w %d2,-2(%fp)
	move.b -3(%fp),33(%a2)
	move.b -2(%fp),34(%a2)
	move.b -1(%fp),35(%a2)
	move.l -12(%fp),%d2
	move.l -8(%fp),%a2
	unlk %fp
	rts
	.size	setran, .-setran
	.align	2
	.globl	fsize
	.type	fsize, @function
fsize:
	link.w %fp,#-4
	movm.l #0x3030,-(%sp)
	move.l 8(%fp),%a3
	move.l 12(%fp),%a2
	clr.l -(%sp)
	move.l %a2,-(%sp)
	move.l %a3,-(%sp)
	jbsr match
	move.b %d0,%d3
	lea (12,%sp),%sp
	jbeq .L32
	moveq #0,%d2
	move.b 15(%a2),%d2
	move.l %a2,-(%sp)
	jbsr extsize
	addq.l #4,%sp
	add.l %d0,%d2
	move.l %d2,%d0
	clr.w %d0
	swap %d0
	move.w %d0,-4(%fp)
	move.w %d2,-2(%fp)
	move.b -3(%fp),33(%a3)
	move.b -2(%fp),34(%a3)
	move.b -1(%fp),35(%a3)
.L32:
	move.b %d3,%d0
	ext.w %d0
	ext.l %d0
	movm.l -20(%fp),#0xc0c
	unlk %fp
	rts
	.size	fsize, .-fsize
	.align	2
	.globl	getsize
	.type	getsize, @function
getsize:
	link.w %fp,#-8
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%a2
	clr.w -4(%fp)
	clr.w -2(%fp)
	clr.w -8(%fp)
	clr.w -6(%fp)
	moveq #0,%d2
	clr.w %d0
	jbra .L36
.L37:
	move.b 33(%a2),-7(%fp)
	move.b 34(%a2),-6(%fp)
	move.b 35(%a2),-5(%fp)
	move.w -8(%fp),%d1
	move.w %d1,%d0
	swap %d0
	mov.w -6(%fp),%d0
	cmp.l %d2,%d0
	jble .L38
	move.l %d0,%d2
.L38:
	moveq #1,%d0
.L36:
	moveq #1,%d1
	and.l %d0,%d1
	move.l %d1,-(%sp)
	move.l %a2,-(%sp)
	pea fsize
	jbsr dirscan
	lea (12,%sp),%sp
	cmp.w #254,%d0
	jbls .L37
	move.l %d2,%d0
	clr.w %d0
	swap %d0
	move.w %d0,-4(%fp)
	move.w %d2,-2(%fp)
	move.b -3(%fp),33(%a2)
	move.b -2(%fp),34(%a2)
	move.b -1(%fp),35(%a2)
	move.l -16(%fp),%d2
	move.l -12(%fp),%a2
	unlk %fp
	rts
	.size	getsize, .-getsize
	.align	2
	.globl	set_attr
	.type	set_attr, @function
set_attr:
	link.w %fp,#0
	movm.l #0x3030,-(%sp)
	move.l 8(%fp),%a3
	move.l 12(%fp),%a2
	move.w 18(%fp),%d2
	clr.l -(%sp)
	move.l %a2,-(%sp)
	move.l %a3,-(%sp)
	jbsr match
	move.b %d0,%d3
	lea (12,%sp),%sp
	jbeq .L42
	pea 11.w
	pea 1(%a2)
	pea 1(%a3)
	jbsr move
	asr.w #2,%d2
	move.w %d2,%a0
	move.l %a0,-(%sp)
	jbsr dir_wr
	lea (16,%sp),%sp
.L42:
	move.b %d3,%d0
	ext.w %d0
	ext.l %d0
	movm.l -16(%fp),#0xc0c
	unlk %fp
	rts
	.size	set_attr, .-set_attr
	.align	2
	.globl	create
	.type	create, @function
create:
	link.w %fp,#0
	movm.l #0x3020,-(%sp)
	move.l 8(%fp),%a2
	move.l 12(%fp),%a1
	move.w 18(%fp),%d2
	cmp.b #-27,(%a1)
	seq %d3
	neg.b %d3
	jbeq .L46
	lea (15,%a2),%a0
	moveq #17,%d0
.L48:
	clr.b (%a0)+
	subq.w #1,%d0
	jbne .L48
	pea 32.w
	move.l %a1,-(%sp)
	move.l %a2,-(%sp)
	jbsr move
	move.w %d2,%d0
	asr.w #2,%d0
	move.w %d0,%a0
	move.l %a0,-(%sp)
	jbsr dir_wr
	move.w gbls+10,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+12,%d0
	move.l %d0,%a1
	move.w %d2,%a0
	moveq #0,%d0
	move.w 4(%a1),%d0
	lea (16,%sp),%sp
	cmp.l %a0,%d0
	jbge .L50
	move.w %d2,4(%a1)
.L50:
	moveq #0,%d1
	move.b gbls+6,%d1
	moveq #1,%d0
	lsl.l %d1,%d0
	or.w %d0,crit_dsk
.L46:
	move.b %d3,%d0
	ext.w %d0
	ext.l %d0
	movm.l -12(%fp),#0x40c
	unlk %fp
	rts
	.size	create, .-create
	.align	2
	.globl	rename
	.type	rename, @function
rename:
	link.w %fp,#0
	movm.l #0x3030,-(%sp)
	move.l 8(%fp),%a2
	move.l 12(%fp),%a3
	move.w 18(%fp),%d2
	clr.l -(%sp)
	move.l %a3,-(%sp)
	move.l %a2,-(%sp)
	jbsr match
	move.b %d0,%d3
	lea (12,%sp),%sp
	jbeq .L56
	tst.b 9(%a3)
	jbge .L58
	move.w %d2,%a0
	move.l %a0,-(%sp)
	move.l %a2,-(%sp)
	jbsr ro_err
	addq.l #8,%sp
.L58:
	lea (17,%a2),%a1
	lea (1,%a3),%a0
	moveq #11,%d0
.L60:
	move.b (%a1)+,%d1
	and.b #127,%d1
	move.b %d1,(%a0)+
	subq.w #1,%d0
	jbne .L60
	asr.w #2,%d2
	move.w %d2,%a0
	move.l %a0,-(%sp)
	jbsr dir_wr
	addq.l #4,%sp
.L56:
	move.b %d3,%d0
	ext.w %d0
	ext.l %d0
	movm.l -16(%fp),#0xc0c
	unlk %fp
	rts
	.size	rename, .-rename
	.align	2
	.globl	delete
	.type	delete, @function
delete:
	link.w %fp,#0
	movm.l #0x3820,-(%sp)
	move.l 8(%fp),%d3
	move.l 12(%fp),%a2
	move.w 18(%fp),%d2
	clr.l -(%sp)
	move.l %a2,-(%sp)
	move.l %d3,-(%sp)
	jbsr match
	move.b %d0,%d4
	lea (12,%sp),%sp
	jbeq .L66
	tst.b 9(%a2)
	jbge .L68
	move.w %d2,%a0
	move.l %a0,-(%sp)
	move.l %d3,-(%sp)
	jbsr ro_err
	addq.l #8,%sp
.L68:
	move.b #-27,(%a2)
	asr.w #2,%d2
	move.w %d2,%a0
	move.l %a0,-(%sp)
	jbsr dir_wr
	move.w gbls+18,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+20,%d0
	addq.l #4,%sp
	move.l %d0,%a0
	cmp.w #255,6(%a0)
	jbhi .L70
	lea (31,%a2),%a2
	moveq #16,%d2
.L72:
	subq.w #1,%d2
	moveq #0,%d0
	move.b (%a2),%d0
	move.l %d0,-(%sp)
	jbsr clraloc
	subq.l #1,%a2
	addq.l #4,%sp
	tst.w %d2
	jbeq .L66
	jbra .L72
.L70:
	lea (30,%a2),%a2
	moveq #8,%d2
.L73:
	subq.w #1,%d2
	moveq #0,%d0
	move.w (%a2),%d0
	move.l %d0,-(%sp)
	jbsr swap
	move.w %d0,-(%sp)
	clr.w -(%sp)
	jbsr clraloc
	subq.l #2,%a2
	addq.l #8,%sp
	tst.w %d2
	jbne .L73
.L66:
	move.b %d4,%d0
	ext.w %d0
	ext.l %d0
	movm.l -16(%fp),#0x41c
	unlk %fp
	rts
	.size	delete, .-delete
	.align	2
	.globl	close
	.type	close, @function
close:
	link.w %fp,#0
	movm.l #0x3038,-(%sp)
	move.l 8(%fp),%a3
	move.l 12(%fp),%a2
	move.w 18(%fp),%d3
	pea 1.w
	move.l %a2,-(%sp)
	move.l %a3,-(%sp)
	jbsr match
	lea (12,%sp),%sp
	tst.b %d0
	jbeq .L106
	lea (16,%a3),%a0
	lea (16,%a2),%a1
	move.w gbls+18,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,%a4
	cmp.w #255,6(%a4)
	jbhi .L81
	moveq #16,%d2
.L83:
	move.b (%a1),%d0
	jbeq .L84
	move.b (%a0),%d1
	jbeq .L86
	cmp.b %d0,%d1
	jbeq .L89
	jbra .L88
.L86:
	move.b %d0,(%a0)
	jbra .L89
.L84:
	move.b (%a0),(%a1)
.L89:
	cmp.w #1,%d2
	jbeq .L90
	addq.l #1,%a0
	addq.l #1,%a1
	subq.w #1,%d2
	jbra .L83
.L81:
	moveq #8,%d2
.L92:
	move.w (%a1),%d0
	jbeq .L93
	move.w (%a0),%d1
	jbeq .L95
	cmp.w %d0,%d1
	jbeq .L97
	jbra .L88
.L95:
	move.w %d0,(%a0)
	jbra .L97
.L93:
	move.w (%a0),(%a1)
.L97:
	cmp.w #1,%d2
	jbeq .L90
	addq.l #2,%a0
	addq.l #2,%a1
	subq.w #1,%d2
	jbra .L92
.L90:
	move.l %a3,-(%sp)
	jbsr calcext
	move.b 12(%a2),%d1
	and.w #31,%d1
	addq.l #4,%sp
	cmp.w %d0,%d1
	jbcs .L99
	jbne .L101
	move.b 15(%a3),%d1
	cmp.b 15(%a2),%d1
	jbls .L101
.L99:
	move.b 15(%a3),15(%a2)
	move.b %d0,12(%a2)
.L101:
	move.b 13(%a3),13(%a2)
	tst.b 9(%a2)
	jbge .L103
	move.w %d3,%a0
	move.l %a0,-(%sp)
	move.l %a3,-(%sp)
	jbsr ro_err
	addq.l #8,%sp
.L103:
	and.b #127,11(%a2)
	asr.w #2,%d3
	move.w %d3,%a4
	move.l %a4,-(%sp)
	jbsr dir_wr
	moveq #1,%d0
	addq.l #4,%sp
	jbra .L80
.L88:
	moveq #0,%d1
	move.b gbls+6,%d1
	moveq #1,%d0
	lsl.l %d1,%d0
	or.w %d0,ro_dsk
.L106:
	moveq #0,%d0
.L80:
	movm.l -20(%fp),#0x1c0c
	unlk %fp
	rts
	.size	close, .-close
	.align	2
	.globl	flushit
	.type	flushit, @function
flushit:
	link.w %fp,#-20
	move.l %d2,-(%sp)
	move.b #3,-18(%fp)
	jbra .L108
.L109:
	pea 1.w
	jbsr error
	addq.l #4,%sp
	tst.w %d0
	jbne .L110
.L108:
	pea -18(%fp)
	jbsr do_phio
	move.w %d0,%d2
	addq.l #4,%sp
	jbne .L109
.L110:
	moveq #0,%d0
	move.w %d2,%d0
	move.l -24(%fp),%d2
	unlk %fp
	rts
	.size	flushit, .-flushit
	.align	2
	.globl	close_fi
	.type	close_fi, @function
close_fi:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l 8(%fp),%a2
	jbsr flushit
	tst.b 14(%a2)
	jbge .L113
	moveq #0,%d0
	jbra .L115
.L113:
	clr.l -(%sp)
	move.l %a2,-(%sp)
	pea close
	jbsr dirscan
	and.l #65535,%d0
	lea (12,%sp),%sp
.L115:
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	close_fi, .-close_fi
	.align	2
	.globl	seldsk
	.type	seldsk, @function
seldsk:
	link.w %fp,#-20
	movm.l #0x3800,-(%sp)
	move.l 8(%fp),%d2
	move.b %d2,%d1
	moveq #0,%d4
	move.b %d2,%d4
	moveq #0,%d0
	move.w log_dsk,%d0
	asr.l %d4,%d0
	move.b %d0,%d3
	not.b %d3
	and.b #1,%d3
	cmp.b gbls+6.l,%d2
	jbne .L118
	tst.b %d3
	jbeq .L132
.L118:
	clr.b -20(%fp)
	move.b %d2,-17(%fp)
	move.b %d2,gbls+6
	cmp.b #15,%d1
	jbls .L121
	pea 2.w
	jbsr error
	addq.l #4,%sp
.L121:
	move.b %d3,%d0
	eor.b #1,%d0
	move.b %d0,-19(%fp)
.L123:
	pea -20(%fp)
	jbsr do_phio
	move.w -6(%fp),%a0
	move.w %a0,%d1
	swap %d1
	mov.w -4(%fp),%d1
	move.l %d1,%d0
	clr.w %d0
	swap %d0
	move.w %d0,gbls+10
	move.w %d1,gbls+12
	addq.l #4,%sp
	tst.l %d1
	jbne .L124
	pea 3.w
	jbsr error
	addq.l #4,%sp
	tst.w %d0
	jbeq .L123
.L124:
	move.w gbls+10,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+12,%d0
	move.l %d0,%a0
	move.w 10(%a0),%a1
	move.w %a1,%d1
	swap %d1
	mov.w 12(%a0),%d1
	move.l %d1,%d0
	clr.w %d0
	swap %d0
	move.w %d0,gbls+14
	move.w %d1,gbls+16
	move.w 14(%a0),%d0
	move.w %d0,%d1
	swap %d1
	mov.w 16(%a0),%d1
	move.l %d1,%d0
	clr.w %d0
	swap %d0
	move.w %d0,gbls+18
	move.w %d1,gbls+20
	tst.b %d3
	jbeq .L132
	move.l %d1,%a0
	move.w 6(%a0),%d2
.L127:
	move.w %d2,%a1
	move.l %a1,-(%sp)
	jbsr clraloc
	addq.l #4,%sp
	dbra %d2,.L127
	move.w gbls+18,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,%a0
	pea -2(%fp)
	move.b 3(%a0),%d0
	lsl.l #2,%d0
	and.l #1020,%d0
	move.l %d0,%a1
	pea 4(%a1)
	moveq #0,%d0
	move.w 8(%a0),%d0
	move.l %d0,%a0
	pea 1(%a0)
	jbsr udiv
	move.w %d0,%d2
	lea (12,%sp),%sp
	tst.w -2(%fp)
	jbeq .L133
	addq.w #1,%d2
.L133:
	subq.w #1,%d2
	move.w %d2,%a1
	move.l %a1,-(%sp)
	jbsr setaloc
	addq.l #4,%sp
	tst.w %d2
	jbne .L133
	pea 14.w
	clr.l -(%sp)
	pea alloc
	jbsr dirscan
	moveq #1,%d0
	lsl.l %d4,%d0
	or.w %d0,log_dsk
	lea (12,%sp),%sp
.L132:
	movm.l -32(%fp),#0x1c
	unlk %fp
	rts
	.size	seldsk, .-seldsk
	.align	2
	.globl	free_sp
	.type	free_sp, @function
free_sp:
	link.w %fp,#-4
	movm.l #0x3030,-(%sp)
	moveq #0,%d0
	move.b 11(%fp),%d0
	move.l %d0,-(%sp)
	jbsr seldsk
	move.w gbls+10,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+12,%d0
	move.l %d0,%a0
	move.w 22(%a0),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 24(%a0),%d0
	move.l %d0,%a3
	move.w gbls+18,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,%a2
	moveq #0,%d2
	move.w 6(%a2),%d2
	clr.w %d3
	sub.l %a1,%a1
	clr.w %d1
	sub.l %a0,%a0
	addq.l #4,%sp
	jbra .L140
.L141:
	tst.w %d1
	jbne .L142
	move.w (%a3)+,%d3
	not.w %d3
	move.w #-32768,%d1
.L142:
	move.w %d3,%d0
	and.w %d1,%d0
	jbeq .L144
	moveq #0,%d0
	move.b 3(%a2),%d0
	lea 1(%a1,%d0.l),%a1
.L144:
	lsr.w #1,%d1
	addq.l #1,%a0
.L140:
	cmp.l %a0,%d2
	jbge .L141
	move.l %fp,%a0
	move.l %a1,-(%a0)
	pea 4.w
	move.w gbls+24,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+26,%d0
	move.l %d0,-(%sp)
	move.l %a0,-(%sp)
	jbsr move
	lea (12,%sp),%sp
	movm.l -20(%fp),#0xc0c
	unlk %fp
	rts
	.size	free_sp, .-free_sp
	.align	2
	.globl	search
	.type	search, @function
search:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%a2
	move.w 14(%fp),%d2
	cmp.b #63,(%a2)
	jbne .L149
	moveq #0,%d0
	move.b gbls+7,%d0
	move.l %d0,-(%sp)
	jbsr seldsk
	move.w %d2,-(%sp)
	clr.w -(%sp)
	move.l %a2,-(%sp)
	pea alltrue
	jbsr dirscan
	move.w %d0,%a2
	lea (16,%sp),%sp
	jbra .L151
.L149:
	move.l 16(%fp),-(%sp)
	jbsr tmp_sel
	addq.l #4,%sp
	cmp.b #63,12(%a2)
	jbeq .L152
	clr.b 12(%a2)
.L152:
	clr.b 14(%a2)
	move.w %d2,-(%sp)
	clr.w -(%sp)
	move.l %a2,-(%sp)
	pea matchit
	jbsr dirscan
	move.w %d0,%a2
	lea (12,%sp),%sp
.L151:
	pea 128.w
	move.w gbls+24,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+26,%d0
	move.l %d0,-(%sp)
	move.w gbls+14,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+16,%d0
	move.l %d0,-(%sp)
	jbsr move
	moveq #0,%d0
	move.w %a2,%d0
	move.l -8(%fp),%d2
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	search, .-search
	.align	2
	.globl	alloc
	.type	alloc, @function
alloc:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.l 12(%fp),%a0
	move.l 16(%fp),%d1
	cmp.b #15,(%a0)
	jbls .L156
	moveq #0,%d0
	jbra .L158
.L156:
	move.w gbls+10,%a1
	move.w %a1,%d0
	swap %d0
	mov.w gbls+12,%d0
	move.l %d0,%a1
	move.w %d1,4(%a1)
	move.w gbls+18,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+20,%d0
	lea (16,%a0),%a0
	move.l %d0,%a1
	cmp.w #255,6(%a1)
	jbhi .L159
	move.l %a0,%a2
	clr.w %d2
.L161:
	addq.w #1,%d2
	moveq #0,%d0
	move.b (%a2)+,%d0
	move.l %d0,-(%sp)
	jbsr setaloc
	addq.l #4,%sp
	cmp.w #16,%d2
	jbeq .L162
	jbra .L161
.L159:
	move.l %a0,%a2
	clr.w %d2
.L163:
	addq.w #1,%d2
	moveq #0,%d0
	move.w (%a2)+,%d0
	move.l %d0,-(%sp)
	jbsr swap
	move.w %d0,-(%sp)
	clr.w -(%sp)
	jbsr setaloc
	addq.l #8,%sp
	cmp.w #8,%d2
	jbne .L163
.L162:
	moveq #1,%d0
.L158:
	move.l -8(%fp),%d2
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	alloc, .-alloc
	.comm	chainp,4,4
	.ident	"GCC: (GNU) 4.1.1"
