#NO_APP
	.file	"bdosmain.c"
	.text
	.align	2
	.globl	tmp_sel
	.type	tmp_sel, @function
tmp_sel:
	link.w %fp,#0
	move.l %a3,-(%sp)
	move.l %a2,-(%sp)
	move.l 8(%fp),%a2
	move.w 2(%a2),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 4(%a2),%d0
	move.l %d0,%a3
	move.b (%a3),%d0
	move.b %d0,(%a2)
	jbeq .L2
	subq.b #1,%d0
	and.l #255,%d0
	jbra .L4
.L2:
	moveq #0,%d0
	move.b gbls+7,%d0
.L4:
	move.l %d0,-(%sp)
	jbsr seldsk
	move.b gbls+8,(%a3)
	move.b #1,1(%a2)
	addq.l #4,%sp
	move.l -8(%fp),%a2
	move.l -4(%fp),%a3
	unlk %fp
	rts
	.size	tmp_sel, .-tmp_sel
	.align	2
	.globl	__bdos
	.type	__bdos, @function
__bdos:
	link.w %fp,#-8
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.l 16(%fp),%a2
	move.w 10(%fp),%d1
	move.w 14(%fp),%d2
	clr.b -5(%fp)
	move.l %a2,%d0
	clr.w %d0
	swap %d0
	move.w %d0,-4(%fp)
	move.w %a2,-2(%fp)
	cmp.w #63,%d1
	jbhi .L7
	moveq #0,%d0
	move.w %d1,%d0
	add.l %d0,%d0
	.set .LI52,.+2
	move.w .L52-.LI52.b(%pc,%d0.l),%d0
	jmp %pc@(2,%d0:w)
	.align	2
	.swbeg	&64
.L52:
	.word .L8-.L52
	.word .L9-.L52
	.word .L10-.L52
	.word .L11-.L52
	.word .L12-.L52
	.word .L13-.L52
	.word .L14-.L52
	.word .L15-.L52
	.word .L16-.L52
	.word .L17-.L52
	.word .L18-.L52
	.word .L19-.L52
	.word .L20-.L52
	.word .L21-.L52
	.word .L22-.L52
	.word .L23-.L52
	.word .L24-.L52
	.word .L25-.L52
	.word .L26-.L52
	.word .L27-.L52
	.word .L28-.L52
	.word .L29-.L52
	.word .L30-.L52
	.word .L31-.L52
	.word .L32-.L52
	.word .L33-.L52
	.word .L34-.L52
	.word .L7-.L52
	.word .L35-.L52
	.word .L36-.L52
	.word .L37-.L52
	.word .L38-.L52
	.word .L39-.L52
	.word .L40-.L52
	.word .L41-.L52
	.word .L42-.L52
	.word .L43-.L52
	.word .L44-.L52
	.word .L7-.L52
	.word .L7-.L52
	.word .L45-.L52
	.word .L7-.L52
	.word .L7-.L52
	.word .L7-.L52
	.word .L7-.L52
	.word .L7-.L52
	.word .L46-.L52
	.word .L47-.L52
	.word .L48-.L52
	.word .L7-.L52
	.word .L7-.L52
	.word .L7-.L52
	.word .L7-.L52
	.word .L7-.L52
	.word .L7-.L52
	.word .L7-.L52
	.word .L7-.L52
	.word .L7-.L52
	.word .L7-.L52
	.word .L49-.L52
	.word .L7-.L52
	.word .L50-.L52
	.word .L7-.L52
	.word .L51-.L52
.L20:
	move.l #8226,%d0
	jbra .L53
.L7:
	moveq #0,%d0
	not.w %d0
	jbra .L53
.L8:
	clr.l -(%sp)
	jbsr warmboot
	addq.l #4,%sp
.L9:
	jbsr conin
	and.l #255,%d0
	jbra .L53
.L10:
	moveq #0,%d0
	move.b %d2,%d0
	move.l %d0,-(%sp)
	jbsr tabout
	jbra .L62
.L11:
	pea 7.w
	jbra .L75
.L12:
	moveq #0,%d0
	move.b %d2,%d0
	move.l %d0,-(%sp)
	pea 6.w
	jbra .L63
.L13:
	moveq #0,%d0
	move.b %d2,%d0
	move.l %d0,-(%sp)
	pea 5.w
.L63:
	jbsr _bios2
.L64:
	clr.w %d0
.L69:
	addq.l #8,%sp
	jbra .L54
.L14:
	move.w %d2,-(%sp)
	clr.w -(%sp)
	jbsr rawconio
.L71:
	and.l #255,%d0
.L72:
	addq.l #4,%sp
	jbra .L53
.L15:
	pea 19.w
.L75:
	jbsr _bios1
	jbra .L71
.L16:
	move.w %d2,-(%sp)
	clr.w -(%sp)
	pea 20.w
	jbra .L63
.L17:
	move.l %a2,-(%sp)
	jbsr prt_line
	jbra .L62
.L18:
	move.l %a2,-(%sp)
	jbsr readline
	jbra .L62
.L19:
	jbsr constat
	ext.w %d0
	jbra .L55
.L21:
	clr.w log_dsk
	clr.w ro_dsk
	clr.w crit_dsk
	st gbls+6
	clr.b gbls+7
	jbra .L70
.L22:
	moveq #0,%d0
	move.b %d2,%d0
	move.l %d0,-(%sp)
	jbsr seldsk
	move.b %d2,gbls+7
	jbra .L62
.L23:
	pea -6(%fp)
	jbsr tmp_sel
	clr.b 12(%a2)
	clr.b 14(%a2)
	clr.l -(%sp)
	move.l %a2,-(%sp)
	pea openfile
	jbra .L74
.L24:
	pea -6(%fp)
	jbsr tmp_sel
	move.l %a2,-(%sp)
	jbsr close_fi
	jbra .L69
.L25:
	move.l %a2,%d0
	clr.w %d0
	swap %d0
	move.w %d0,gbls+28
	move.w %a2,gbls+30
	pea -6(%fp)
	clr.l -(%sp)
	jbra .L73
.L26:
	move.w gbls+28,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+30,%d0
	move.l %d0,%a2
	clr.w %d0
	swap %d0
	move.w %d0,-4(%fp)
	move.w %a2,-2(%fp)
	pea -6(%fp)
	pea 1.w
.L73:
	move.l %a2,-(%sp)
	jbsr search
	jbra .L68
.L27:
	pea -6(%fp)
	jbsr tmp_sel
	pea 2.w
	move.l %a2,-(%sp)
	pea delete
	jbra .L74
.L28:
	pea -6(%fp)
	jbsr tmp_sel
	clr.l -(%sp)
	jbra .L76
.L29:
	pea -6(%fp)
	jbsr tmp_sel
	clr.l -(%sp)
	jbra .L65
.L30:
	pea -6(%fp)
	jbsr tmp_sel
	clr.b 12(%a2)
	clr.b 13(%a2)
	clr.b 14(%a2)
	clr.b 15(%a2)
	pea 8.w
	move.l %a2,-(%sp)
	pea create
	jbra .L74
.L31:
	pea -6(%fp)
	jbsr tmp_sel
	pea 2.w
	move.l %a2,-(%sp)
	pea rename
	jbra .L74
.L32:
	moveq #0,%d0
	move.w log_dsk,%d0
	jbra .L53
.L33:
	moveq #0,%d0
	move.b gbls+7,%d0
	jbra .L53
.L34:
	move.l %a2,%d0
	clr.w %d0
	swap %d0
	move.w %d0,gbls+24
	move.w %a2,gbls+26
.L70:
	clr.w %d0
	jbra .L55
.L35:
	moveq #0,%d1
	move.b gbls+7,%d1
	moveq #1,%d0
	lsl.l %d1,%d0
	or.w %d0,ro_dsk
	jbra .L70
.L36:
	moveq #0,%d0
	move.w ro_dsk,%d0
	jbra .L53
.L37:
	pea -6(%fp)
	jbsr tmp_sel
	pea 2.w
	move.l %a2,-(%sp)
	pea set_attr
.L74:
	jbsr dirscan
	jbra .L67
.L38:
	move.b gbls+7,%d0
	cmp.b gbls+6.l,%d0
	jbeq .L56
	and.l #255,%d0
	move.l %d0,-(%sp)
	jbsr seldsk
	addq.l #4,%sp
.L56:
	pea 16.w
	move.l %a2,-(%sp)
	move.w gbls+18,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+20,%d0
	move.l %d0,-(%sp)
	jbsr move
	clr.w %d0
.L68:
	lea (12,%sp),%sp
	jbra .L54
.L39:
	moveq #0,%d0
	move.b %d2,%d0
	moveq #15,%d1
	cmp.l %d0,%d1
	jblt .L58
	move.b %d2,gbls+8
.L58:
	moveq #0,%d0
	move.b gbls+8,%d0
	jbra .L53
.L40:
	pea -6(%fp)
	jbsr tmp_sel
	pea 1.w
.L76:
	pea 1.w
	jbra .L66
.L41:
	pea -6(%fp)
	jbsr tmp_sel
	pea 1.w
	jbra .L65
.L42:
	pea -6(%fp)
	jbsr tmp_sel
	move.l %a2,-(%sp)
	jbsr getsize
	jbra .L64
.L43:
	pea -6(%fp)
	jbsr tmp_sel
	move.l %a2,-(%sp)
	jbsr setran
	jbra .L64
.L44:
	move.w %d2,%d0
	not.w %d0
	and.w %d0,log_dsk
	and.w %d0,ro_dsk
	and.w %d0,crit_dsk
	jbra .L70
.L45:
	pea -6(%fp)
	jbsr tmp_sel
	pea 2.w
.L65:
	clr.l -(%sp)
.L66:
	move.l %a2,-(%sp)
	jbsr bdosrw
.L67:
	lea (16,%sp),%sp
	jbra .L54
.L46:
	move.w %d2,-(%sp)
	clr.w -(%sp)
	jbsr free_sp
	jbra .L62
.L47:
	move.w gbls+24,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+26,%d0
	move.l %d0,chainp
	clr.l -(%sp)
	jbsr warmboot
	addq.l #4,%sp
.L48:
	jbsr flushit
	jbra .L55
.L49:
	move.w gbls+24,%d1
	move.w %d1,%d0
	swap %d0
	mov.w gbls+26,%d0
	move.l %d0,-(%sp)
	move.l %a2,-(%sp)
	jbsr pgmld
	and.l #65535,%d0
	addq.l #8,%sp
	jbra .L53
.L50:
	move.l %a2,-(%sp)
	jbsr setexc
	and.l #65535,%d0
	jbra .L72
.L51:
	move.l %a2,-(%sp)
	jbsr set_tpa
.L62:
	clr.w %d0
	addq.l #4,%sp
.L54:
	tst.b -5(%fp)
	jbeq .L55
	move.b -6(%fp),(%a2)
.L55:
	and.l #65535,%d0
.L53:
	move.l -16(%fp),%d2
	move.l -12(%fp),%a2
	unlk %fp
	rts
	.size	__bdos, .-__bdos
	.comm	chainp,4,4
	.comm	log_dsk,2,2
	.comm	ro_dsk,2,2
	.comm	crit_dsk,2,2
	.comm	tpa_lp,4,4
	.comm	tpa_lt,4,4
	.comm	tpa_hp,4,4
	.comm	tpa_ht,4,4
	.comm	gbls,238,2
	.ident	"GCC: (GNU) 4.1.1"
