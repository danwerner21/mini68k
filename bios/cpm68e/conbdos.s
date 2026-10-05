#NO_APP
	.file	"conbdos.c"
	.text
	.align	2
	.globl	getch
	.type	getch, @function
getch:
	link.w %fp,#0
	move.l %d2,-(%sp)
	tst.b gbls
	jbeq .L2
	move.w gbls+108,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+110,%d0
	move.l %d0,%a0
	move.b (%a0)+,%d2
	move.l %a0,%d0
	clr.w %d0
	swap %d0
	move.w %d0,gbls+108
	move.w %a0,gbls+110
	move.b gbls,%d0
	subq.b #1,%d0
	move.b %d0,gbls
	jbne .L4
	move.l #gbls+112,%d0
	clr.w %d0
	swap %d0
	move.w %d0,gbls+104
	move.l #gbls+112,%d1
	and.l #65535,%d1
	move.w %d1,gbls+106
	move.w %d0,gbls+108
	move.w %d1,gbls+110
.L4:
	moveq #0,%d0
	move.b %d2,%d0
	jbra .L6
.L2:
	pea 3.w
	jbsr _bios1
	and.l #255,%d0
	addq.l #4,%sp
.L6:
	move.l -4(%fp),%d2
	unlk %fp
	rts
	.size	getch, .-getch
	.align	2
	.globl	conbrk
	.type	conbrk, @function
conbrk:
	link.w %fp,#0
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	pea 2.w
	jbsr _bios1
	addq.l #4,%sp
	tst.b %d0
	jbeq .L21
	clr.b %d3
	jbra .L27
.L12:
	moveq #1,%d3
.L27:
	pea 3.w
	jbsr _bios1
	move.b %d0,%d2
	addq.l #4,%sp
	cmp.b #3,%d0
	jbne .L13
	pea 2.w
	jbsr warmboot
	addq.l #4,%sp
	jbra .L15
.L13:
	cmp.b #19,%d0
	jbeq .L12
	cmp.b #17,%d0
	jbeq .L21
	cmp.b #16,%d0
	jbne .L15
	tst.b gbls+2
	seq %d0
	neg.b %d0
	move.b %d0,gbls+2
	jbra .L19
.L15:
	cmp.b #125,gbls.l
	jbhi .L19
	move.w gbls+104,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+106,%d0
	move.l %d0,%a0
	move.b %d2,(%a0)+
	move.l %a0,%d0
	clr.w %d0
	swap %d0
	move.w %d0,gbls+104
	move.w %a0,gbls+106
	addq.b #1,gbls
.L19:
	tst.b %d3
	jbne .L27
.L21:
	move.l -8(%fp),%d2
	move.l -4(%fp),%d3
	unlk %fp
	rts
	.size	conbrk, .-conbrk
	.align	2
	.globl	conout
	.type	conout, @function
conout:
	link.w %fp,#0
	movm.l #0x3020,-(%sp)
	move.b 11(%fp),%d2
	jbsr conbrk
	moveq #0,%d3
	move.b %d2,%d3
	move.l %d3,-(%sp)
	pea 4.w
	lea _bios2,%a2
	jbsr (%a2)
	addq.l #8,%sp
	tst.b gbls+2
	jbeq .L29
	move.l %d3,-(%sp)
	pea 5.w
	jbsr (%a2)
	addq.l #8,%sp
.L29:
	cmp.b #31,%d2
	jbls .L31
	addq.w #1,gbls+4
	jbra .L37
.L31:
	cmp.b #13,%d2
	jbne .L34
	clr.w gbls+4
	jbra .L37
.L34:
	cmp.b #8,%d2
	jbne .L37
	subq.w #1,gbls+4
.L37:
	movm.l -12(%fp),#0x40c
	unlk %fp
	rts
	.size	conout, .-conout
	.align	2
	.globl	backsp
	.type	backsp, @function
backsp:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%a0
	move.w 14(%fp),%d2
	move.b 1(%a0),%d0
	jbeq .L39
	subq.b #1,%d0
	move.b %d0,1(%a0)
.L39:
	clr.w %d1
	move.b 1(%a0),%d1
	addq.l #2,%a0
	jbra .L41
.L42:
	move.b (%a0),%d0
	cmp.b #9,%d0
	jbne .L43
	addq.w #8,%d2
	and.w #-8,%d2
	jbra .L45
.L43:
	cmp.b #31,%d0
	jbhi .L46
	addq.w #2,%d2
	jbra .L45
.L46:
	addq.w #1,%d2
.L45:
	addq.l #1,%a0
.L41:
	dbra %d1,.L42
	jbra .L52
.L49:
	pea 8.w
	lea conout,%a2
	jbsr (%a2)
	pea 32.w
	jbsr (%a2)
	pea 8.w
	jbsr (%a2)
	lea (12,%sp),%sp
.L52:
	moveq #0,%d0
	move.w gbls+4,%d0
	move.w %d2,%a0
	cmp.l %d0,%a0
	jblt .L49
	move.l -8(%fp),%d2
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	backsp, .-backsp
	.align	2
	.globl	newline
	.type	newline, @function
newline:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.w 10(%fp),%d2
	pea 13.w
	lea conout,%a2
	jbsr (%a2)
	pea 10.w
	jbsr (%a2)
	addq.l #8,%sp
	jbra .L54
.L55:
	pea 32.w
	jbsr conout
	subq.w #1,%d2
	addq.l #4,%sp
.L54:
	tst.w %d2
	jbne .L55
	move.l -8(%fp),%d2
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	newline, .-newline
	.align	2
	.globl	conin
	.type	conin, @function
conin:
	link.w %fp,#0
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	jbsr getch
	move.b %d0,%d2
	moveq #0,%d3
	move.b %d0,%d3
	move.l %d3,-(%sp)
	jbsr conout
	addq.l #4,%sp
	cmp.b #16,%d2
	jbne .L59
	tst.b gbls+2
	seq %d0
	neg.b %d0
	move.b %d0,gbls+2
.L59:
	move.l %d3,%d0
	move.l -8(%fp),%d2
	move.l -4(%fp),%d3
	unlk %fp
	rts
	.size	conin, .-conin
	.align	2
	.globl	tabout
	.type	tabout, @function
tabout:
	link.w %fp,#0
	move.b 11(%fp),%d0
	cmp.b #9,%d0
	jbne .L63
.L67:
	pea 32.w
	jbsr conout
	move.w gbls+4,%d0
	moveq #7,%d1
	and.l %d1,%d0
	addq.l #4,%sp
	jbeq .L66
	jbra .L67
.L63:
	and.l #255,%d0
	move.l %d0,-(%sp)
	jbsr conout
	addq.l #4,%sp
.L66:
	unlk %fp
	rts
	.size	tabout, .-tabout
	.align	2
	.globl	prt_line
	.type	prt_line, @function
prt_line:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l 8(%fp),%a2
	jbra .L70
.L71:
	addq.l #1,%a2
	and.l #255,%d0
	move.l %d0,-(%sp)
	jbsr tabout
	addq.l #4,%sp
.L70:
	move.b (%a2),%d0
	cmp.b gbls+1.l,%d0
	jbne .L71
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	prt_line, .-prt_line
	.align	2
	.globl	cookdout
	.type	cookdout, @function
cookdout:
	link.w %fp,#0
	move.l %d2,-(%sp)
	move.b 11(%fp),%d2
	cmp.b #9,%d2
	jbne .L75
	pea 9.w
	jbsr tabout
	jbra .L81
.L75:
	cmp.b #31,%d2
	jbhi .L78
	pea 94.w
	jbsr conout
	or.b #64,%d2
	addq.l #4,%sp
.L78:
	moveq #0,%d0
	move.b %d2,%d0
	move.l %d0,-(%sp)
	jbsr conout
.L81:
	addq.l #4,%sp
	move.l -4(%fp),%d2
	unlk %fp
	rts
	.size	cookdout, .-cookdout
	.align	2
	.globl	readline
	.type	readline, @function
readline:
	link.w %fp,#0
	movm.l #0x3020,-(%sp)
	move.l 8(%fp),%a2
	move.w gbls+4,%d3
	clr.b 1(%a2)
	jbra .L122
.L84:
	jbsr getch
	move.b %d0,%d2
	cmp.b #3,%d0
	jbne .L85
	tst.b 1(%a2)
	jbne .L87
	pea 3.w
	jbsr cookdout
	pea 2.w
	jbsr warmboot
	jbra .L119
.L85:
	cmp.b #13,%d0
	jbeq .L89
	cmp.b #10,%d0
	jbne .L91
.L89:
	pea 13.w
	jbsr conout
	addq.l #4,%sp
	jbra .L111
.L91:
	cmp.b #8,%d0
	jbne .L93
.L121:
	move.w %d3,-(%sp)
	clr.w -(%sp)
	move.l %a2,-(%sp)
	jbsr backsp
.L119:
	addq.l #8,%sp
	jbra .L122
.L93:
	cmp.b #127,%d0
	jbne .L95
	tst.b gbls+3
	jbeq .L121
	move.b 1(%a2),%d0
	jbeq .L122
	subq.b #1,%d0
	move.b %d0,1(%a2)
	and.l #255,%d0
	move.b 2(%a2,%d0.l),%d0
	and.l #255,%d0
	move.l %d0,-(%sp)
	jbsr conout
	jbra .L120
.L95:
	cmp.b #16,%d0
	jbne .L100
	tst.b gbls+2
	seq %d0
	neg.b %d0
	move.b %d0,gbls+2
	jbra .L122
.L100:
	cmp.b #24,%d0
	jbne .L102
.L115:
	move.w %d3,-(%sp)
	clr.w -(%sp)
	move.l %a2,-(%sp)
	jbsr backsp
	addq.l #8,%sp
	tst.b 1(%a2)
	jbeq .L122
	jbra .L115
.L102:
	cmp.b #5,%d0
	jbne .L104
	move.w %d3,-(%sp)
	clr.w -(%sp)
	jbsr newline
	jbra .L120
.L104:
	cmp.b #21,%d0
	jbne .L106
	pea 35.w
	jbsr conout
	move.w %d3,-(%sp)
	clr.w -(%sp)
	jbsr newline
	clr.b 1(%a2)
	jbra .L119
.L106:
	cmp.b #18,%d0
	jbne .L87
	pea 35.w
	jbsr conout
	move.w %d3,-(%sp)
	clr.w -(%sp)
	jbsr newline
	moveq #0,%d2
	addq.l #8,%sp
	jbra .L109
.L110:
	moveq #0,%d0
	move.w %d1,%d0
	move.b 2(%a2,%d0.l),%d0
	and.l #255,%d0
	move.l %d0,-(%sp)
	jbsr cookdout
	addq.l #4,%sp
.L109:
	move.w %d2,%d1
	addq.l #1,%d2
	clr.w %d0
	move.b 1(%a2),%d0
	cmp.w %d1,%d0
	jbhi .L110
	jbra .L122
.L87:
	move.b 1(%a2),%d0
	moveq #0,%d1
	move.b %d0,%d1
	move.b %d2,2(%a2,%d1.l)
	addq.b #1,%d0
	move.b %d0,1(%a2)
	moveq #0,%d0
	move.b %d2,%d0
	move.l %d0,-(%sp)
	jbsr cookdout
.L120:
	addq.l #4,%sp
.L122:
	move.b 1(%a2),%d0
	cmp.b (%a2),%d0
	jbcs .L84
.L111:
	movm.l -12(%fp),#0x40c
	unlk %fp
	rts
	.size	readline, .-readline
	.align	2
	.globl	constat
	.type	constat, @function
constat:
	link.w %fp,#0
	tst.b gbls
	jbeq .L124
	move.w #1,%a0
	jbra .L126
.L124:
	pea 2.w
	jbsr _bios1
	ext.w %d0
	move.w %d0,%a0
	addq.l #4,%sp
.L126:
	move.l %a0,%d0
	unlk %fp
	rts
	.size	constat, .-constat
	.align	2
	.globl	rawconio
	.type	rawconio, @function
rawconio:
	link.w %fp,#0
	move.l %d2,-(%sp)
	move.w 10(%fp),%d2
	cmp.w #255,%d2
	jbne .L129
	jbsr getch
	jbra .L135
.L129:
	cmp.w #254,%d2
	jbne .L132
	jbsr constat
.L135:
	and.l #255,%d0
	jbra .L131
.L132:
	moveq #0,%d0
	move.b %d2,%d0
	move.l %d0,-(%sp)
	pea 4.w
	jbsr _bios2
	moveq #0,%d0
	move.b %d2,%d0
	addq.l #8,%sp
.L131:
	move.l -4(%fp),%d2
	unlk %fp
	rts
	.size	rawconio, .-rawconio
	.comm	chainp,4,4
	.ident	"GCC: (GNU) 4.1.1"
