#NO_APP
	.file	"iosys.c"
	.text
	.align	2
	.globl	do_phio
	.type	do_phio, @function
do_phio:
	link.w %fp,#-4
	movm.l #0x38,-(%sp)
	move.l 8(%fp),%a4
	move.b (%a4),%d0
	cmp.b #2,%d0
	jbhi .L6
	cmp.b #1,%d0
	jbcc .L4
	jbra .L13
.L6:
	cmp.b #3,%d0
	jbeq .L5
	clr.w %d0
	jbra .L7
.L13:
	moveq #0,%d0
	move.b 3(%a4),%d0
	move.b %d0,last_dsk.1015
	moveq #0,%d1
	move.b 1(%a4),%d1
	move.l %d1,-(%sp)
	move.l %d0,-(%sp)
	pea 9.w
	jbsr _bios4
	move.l %d0,%d1
	clr.w %d1
	swap %d1
	move.w %d1,14(%a4)
	move.w %d0,16(%a4)
	clr.w %d0
	lea (12,%sp),%sp
	jbra .L7
.L4:
	move.b 3(%a4),%d0
	cmp.b last_dsk.1015.l,%d0
	jbeq .L8
	move.b %d0,last_dsk.1015
	clr.l -(%sp)
	and.l #255,%d0
	move.l %d0,-(%sp)
	pea 9.w
	jbsr _bios4
	lea (12,%sp),%sp
.L8:
	move.w 14(%a4),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 16(%a4),%d0
	move.l %d0,%a2
	move.w 14(%a2),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 16(%a2),%d0
	move.l %d0,%a3
	pea -2(%fp)
	moveq #0,%d0
	move.w (%a3),%d0
	move.l %d0,-(%sp)
	move.w 4(%a4),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 6(%a4),%d0
	move.l %d0,-(%sp)
	jbsr udiv
	and.l #65535,%d0
	moveq #0,%d1
	move.w 14(%a3),%d1
	move.l %d0,%a0
	pea (%a0,%d1.l)
	pea 10.w
	lea _bios2,%a3
	jbsr (%a3)
	move.w (%a2),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 2(%a2),%d0
	move.l %d0,-(%sp)
	moveq #0,%d0
	move.w -2(%fp),%d0
	move.l %d0,-(%sp)
	pea 16.w
	jbsr _bios5
	lea (32,%sp),%sp
	move.w %d0,-(%sp)
	clr.w -(%sp)
	pea 11.w
	jbsr (%a3)
	move.w 10(%a4),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 12(%a4),%d0
	move.l %d0,-(%sp)
	pea 12.w
	jbsr _bios3
	lea (16,%sp),%sp
	cmp.b #1,(%a4)
	jbne .L10
	pea 13.w
	jbra .L14
.L10:
	moveq #0,%d0
	move.b 1(%a4),%d0
	move.l %d0,-(%sp)
	pea 14.w
	jbsr (%a3)
	addq.l #8,%sp
	jbra .L7
.L5:
	pea 21.w
.L14:
	jbsr _bios1
	and.w #255,%d0
	addq.l #4,%sp
.L7:
	and.l #65535,%d0
	movm.l -16(%fp),#0x1c00
	unlk %fp
	rts
	.size	do_phio, .-do_phio
	.local	last_dsk.1015
	.comm	last_dsk.1015,1,1
	.comm	chainp,4,4
	.ident	"GCC: (GNU) 4.1.1"
