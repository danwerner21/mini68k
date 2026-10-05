#NO_APP
	.file	"ccp.c"
	.text
	.align	2
	.globl	cpy
	.type	cpy, @function
cpy:
	link.w %fp,#0
	move.l 8(%fp),%a1
	move.l 12(%fp),%a0
.L3:
	move.b (%a1)+,%d0
	move.b %d0,(%a0)+
	jbne .L3
	unlk %fp
	rts
	.size	cpy, .-cpy
	.align	2
	.globl	ccp_strcmp
	.type	ccp_strcmp, @function
ccp_strcmp:
	link.w %fp,#0
	move.l 8(%fp),%a1
	move.l 12(%fp),%a0
	jbra .L9
.L10:
	move.b (%a0),%d1
	cmp.b %d0,%d1
	jblt .L19
	jbgt .L14
	addq.l #1,%a1
	addq.l #1,%a0
.L9:
	move.b (%a1),%d0
	jbne .L10
	tst.b (%a0)
	jbne .L14
	moveq #0,%d0
	jbra .L13
.L19:
	moveq #1,%d0
	jbra .L13
.L14:
	moveq #0,%d0
	not.w %d0
.L13:
	unlk %fp
	rts
	.size	ccp_strcmp, .-ccp_strcmp
	.align	2
	.globl	copy_cmd
	.type	copy_cmd, @function
copy_cmd:
	link.w %fp,#0
	move.l %a3,-(%sp)
	move.l %a2,-(%sp)
	move.l 8(%fp),%a3
	lea save_sub,%a0
	lea parm,%a2
	tst.b subprompt
	jbne .L24
	jbra .L31
.L25:
	move.b %d0,(%a0)
	move.l %a1,%a0
	addq.l #1,%a2
.L24:
	move.b (%a2),%d0
	lea (1,%a0),%a1
	jbne .L25
	move.b #32,(%a0)
	move.l %a1,%a0
	clr.b subprompt
	jbra .L31
.L27:
	move.b %d0,(%a0)+
	addq.l #1,%a3
.L31:
	move.b (%a3),%d0
	jbeq .L28
	cmp.b #33,%d0
	jbne .L27
.L28:
	clr.b (%a0)
	move.l (%sp)+,%a2
	move.l (%sp)+,%a3
	unlk %fp
	rts
	.size	copy_cmd, .-copy_cmd
	.align	2
	.globl	check_cmd
	.type	check_cmd, @function
check_cmd:
	link.w %fp,#0
	move.l 8(%fp),%a0
	jbra .L33
.L34:
	addq.l #1,%a0
.L33:
	move.b (%a0),%d0
	jbeq .L35
	cmp.b #33,%d0
	jbne .L34
	jbra .L49
.L50:
	move.b #1,morecmds
	jbra .L39
.L40:
	addq.l #1,%a0
.L39:
	cmp.b #32,(%a0)
	jbeq .L40
	move.l %a0,user_ptr
	jbra .L48
.L35:
	tst.b submit
	jbeq .L43
	tst.b end_of_file
	jbeq .L51
	clr.b submit
	move.l user_ptr,%a0
	tst.b (%a0)
	jbeq .L48
.L51:
	move.b #1,morecmds
	jbra .L48
.L43:
	clr.b morecmds
	jbra .L48
.L49:
	addq.l #1,%a0
	tst.b (%a0)
	jbeq .L35
	jbra .L50
.L48:
	unlk %fp
	rts
	.size	check_cmd, .-check_cmd
	.align	2
	.globl	scan_cmd
	.type	scan_cmd, @function
scan_cmd:
	link.w %fp,#0
	move.l 8(%fp),%a0
	jbra .L53
.L54:
	addq.l #1,%a0
.L53:
	move.b (%a0),%d0
	cmp.b #33,%d0
	jbeq .L61
	tst.b %d0
	jbne .L54
	jbra .L61
.L57:
	addq.l #1,%a0
.L61:
	move.b (%a0),%d1
	move.b %d1,%d0
	add.b #-32,%d0
	cmp.b #1,%d0
	jbls .L57
	cmp.b #9,%d1
	jbeq .L57
	move.l %a0,%d0
	unlk %fp
	rts
	.size	scan_cmd, .-scan_cmd
	.align	2
	.globl	get_parms
	.type	get_parms, @function
get_parms:
	link.w %fp,#0
	movm.l #0x3c00,-(%sp)
	move.l 8(%fp),%a1
	lea parm,%a0
.L63:
	clr.b (%a0)+
	cmp.l #parm+120,%a0
	jbne .L63
	moveq #0,%d5
	jbra .L65
.L66:
	cmp.w #28,%d4
	jbhi .L67
	moveq #0,%d2
	move.w %d4,%d2
	move.l %d5,%d1
	add.l %d5,%d1
	move.l %d5,%d0
	lsl.l #5,%d0
	sub.l %d1,%d0
	move.l %d0,%a0
	add.l #parm,%a0
	move.b %d3,(%a0,%d2.l)
	addq.w #1,%d4
.L67:
	addq.l #1,%a1
.L69:
	move.b (%a1),%d3
	move.b %d3,%d0
	add.b #-32,%d0
	cmp.b #1,%d0
	jbls .L70
	cmp.b #9,%d3
	jbeq .L70
	tst.b %d3
	jbne .L66
.L70:
	moveq #0,%d2
	move.w %d4,%d2
	move.l %d5,%d1
	add.l %d5,%d1
	move.l %d5,%d0
	lsl.l #5,%d0
	sub.l %d1,%d0
	move.l %d0,%a0
	add.l #parm,%a0
	clr.b (%a0,%d2.l)
	move.b (%a1),%d0
	cmp.b #32,%d0
	jbeq .L73
	cmp.b #9,%d0
	jbne .L75
.L73:
	addq.l #1,%a1
.L75:
	tst.w %d5
	jbne .L76
	move.l %a1,tail
.L76:
	addq.l #1,%d5
.L65:
	move.b (%a1),%d0
	jbeq .L82
	cmp.b #33,%d0
	jbeq .L82
	moveq #4,%d0
	cmp.l %d5,%d0
	jbeq .L82
	clr.w %d4
	jbra .L69
.L82:
	movm.l (%sp)+,#0x3c
	unlk %fp
	rts
	.size	get_parms, .-get_parms
	.align	2
	.globl	delim
	.type	delim, @function
delim:
	link.w %fp,#0
	move.l 8(%fp),%a0
	move.b (%a0),%d0
	cmp.b #32,%d0
	jble .L86
	lea del,%a0
.L88:
	cmp.b (%a0),%d0
	jbeq .L86
	addq.l #1,%a0
	cmp.l #del+16,%a0
	jbne .L88
	moveq #0,%d0
	jbra .L91
.L86:
	moveq #1,%d0
.L91:
	unlk %fp
	rts
	.size	delim, .-delim
	.align	2
	.globl	true_char
	.type	true_char, @function
true_char:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l 8(%fp),%a2
	cmp.b #42,(%a2)
	jbne .L96
	move.w #63,%a0
	jbra .L98
.L96:
	move.l %a2,-(%sp)
	jbsr delim
	addq.l #4,%sp
	tst.w %d0
	jbeq .L99
	move.w #32,%a0
	jbra .L98
.L99:
	addq.w #1,index
	move.b (%a2),%d0
	ext.w %d0
	move.w %d0,%a0
.L98:
	move.l %a0,%d0
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	true_char, .-true_char
	.align	2
	.globl	find_colon
	.type	find_colon, @function
find_colon:
	link.w %fp,#0
	sub.l %a1,%a1
.L103:
	moveq #0,%d0
	move.w %a1,%d0
	lea parm,%a0
	move.b 30(%a0,%d0.l),%d1
	jbeq .L104
	addq.l #1,%a1
	cmp.b #58,%d1
	jbne .L103
.L104:
	unlk %fp
	rts
	.size	find_colon, .-find_colon
	.align	2
	.globl	sub_read
	.type	sub_read, @function
sub_read:
	link.w %fp,#0
	pea subfcb
	pea 20.w
	jbsr bdos
	addq.l #8,%sp
	tst.w %d0
	jbne .L109
	moveq #1,%d0
	jbra .L111
.L109:
	move.b #1,end_of_file
	moveq #0,%d0
.L111:
	unlk %fp
	rts
	.size	sub_read, .-sub_read
	.align	2
	.globl	dollar
	.type	dollar, @function
dollar:
	link.w %fp,#0
	movm.l #0x3c20,-(%sp)
	move.l 16(%fp),%a2
	move.w 10(%fp),%d2
	move.w 14(%fp),%d5
	move.w sub_index,%d3
	cmp.w #127,%d2
	jbls .L114
	jbsr sub_read
	tst.w %d0
	jbne .L116
	moveq #0,%d0
	jbra .L118
.L116:
	clr.w %d2
.L114:
	moveq #0,%d4
	move.w %d2,%d4
	lea subdma,%a0
	move.b (%a0,%d4.l),%d1
	move.b %d1,%d0
	add.b #-48,%d0
	cmp.b #9,%d0
	jbhi .L119
	move.b %d1,%d0
	ext.w %d0
	move.w %d0,%a1
	lea (-48,%a1),%a1
	cmp.b #83,(%a2)
	jbne .L121
	lea (1,%a2),%a0
	cmp.b #85,(%a0)
	jbne .L121
	addq.l #1,%a0
	cmp.b #66,(%a0)
	jbne .L121
	addq.l #1,%a0
	cmp.b #77,(%a0)
	jbne .L121
	addq.l #1,%a0
	cmp.b #73,(%a0)
	jbne .L121
	addq.l #1,%a0
	cmp.b #84,(%a0)
	jbne .L121
	cmp.b #32,1(%a0)
	jbne .L121
	addq.w #1,%a1
.L121:
	moveq #1,%d1
	jbra .L129
.L130:
	addq.l #1,%a2
.L153:
	move.b (%a2),%d0
	cmp.b #32,%d0
	jbeq .L132
	tst.b %d0
	jbne .L130
	jbra .L134
.L132:
	addq.l #1,%a2
.L134:
	addq.w #1,%d1
.L129:
	cmp.w %a1,%d1
	jbls .L153
	jbra .L158
.L136:
	lea (1,%a2),%a1
	cmp.w #1,%d5
	jbne .L137
	moveq #0,%d0
	move.w %d3,%d0
	lea subcom,%a0
	move.b %d1,(%a0,%d0.l)
	addq.w #1,%d3
	move.l %a1,%a2
	jbra .L158
.L137:
	move.l %a1,%a2
	move.b %d1,%d0
	ext.w %d0
	move.w %d0,%a0
	move.l %a0,-(%sp)
	pea 2.w
	jbsr bdos
	addq.l #8,%sp
.L158:
	move.b (%a2),%d1
	cmp.b #32,%d1
	jbeq .L157
	tst.b %d1
	jbeq .L157
	cmp.w #127,%d3
	jbls .L136
	jbra .L157
.L119:
	cmp.w #1,%d5
	jbne .L143
	moveq #0,%d0
	move.w %d3,%d0
	lea subcom,%a0
	move.b #36,(%a0,%d0.l)
	addq.w #1,%d3
	jbra .L145
.L143:
	pea 36.w
	pea 2.w
	jbsr bdos
	addq.l #8,%sp
.L145:
	lea subdma,%a0
	cmp.b #36,(%a0,%d4.l)
	jbne .L142
.L157:
	addq.w #1,%d2
.L142:
	move.w %d3,sub_index
	cmp.w #127,%d2
	jbls .L147
	jbsr sub_read
	clr.w %d2
.L147:
	moveq #0,%d0
	move.w %d2,%d0
.L118:
	movm.l -20(%fp),#0x43c
	unlk %fp
	rts
	.size	dollar, .-dollar
	.align	2
	.globl	fill_fcb
	.type	fill_fcb, @function
fill_fcb:
	link.w %fp,#0
	movm.l #0x3838,-(%sp)
	move.l 12(%fp),%a4
	move.w 10(%fp),%d4
	clr.b (%a4)
	lea (12,%a4),%a0
	moveq #12,%d0
.L160:
	clr.b (%a0)+
	addq.w #1,%d0
	cmp.w #36,%d0
	jbne .L160
	lea (1,%a4),%a0
	move.b #1,%d0
.L162:
	move.b #32,(%a0)+
	addq.w #1,%d0
	cmp.w #12,%d0
	jbne .L162
	tst.b dirflag
	jbeq .L164
	moveq #63,%d3
	jbra .L166
.L164:
	moveq #32,%d3
.L166:
	clr.w index
	moveq #0,%d2
	move.w %d4,%d2
	move.l %d2,%d0
	add.l %d2,%d0
	move.l %d2,%d1
	lsl.l #5,%d1
	sub.l %d0,%d1
	lea parm,%a0
	move.b (%a0,%d1.l),%d0
	jbne .L167
	lea (1,%a4),%a1
.L169:
	move.b %d3,(%a1)+
	lea (12,%a4),%a0
	cmp.l %a1,%a0
	jbne .L169
	clr.l -(%sp)
	pea 25.w
	jbsr bdos
	addq.b #1,%d0
	move.b %d0,(%a4)
	addq.l #8,%sp
	jbra .L206
.L167:
	move.l %d1,%a0
	add.l #parm,%a0
	cmp.b #58,1(%a0)
	jbne .L173
	add.b #-64,%d0
	move.b %d0,(%a4)
	move.w index,%d0
	addq.w #2,%d0
	move.w %d0,index
	and.l #65535,%d0
	tst.b (%a0,%d0.l)
	jbne .L175
	lea (1,%a4),%a1
.L177:
	move.b %d3,(%a1)+
	lea (12,%a4),%a0
	cmp.l %a1,%a0
	jbne .L177
.L206:
	tst.b dirflag
	jbne .L171
	jbra .L172
.L173:
	clr.l -(%sp)
	pea 25.w
	jbsr bdos
	addq.b #1,%d0
	move.b %d0,(%a4)
	addq.l #8,%sp
.L175:
	lea (1,%a4),%a3
	mulu.w #30,%d4
	move.l %a3,%a2
.L179:
	moveq #0,%d0
	move.w index,%d0
	add.l %d4,%d0
	add.l #parm,%d0
	move.l %d0,-(%sp)
	jbsr true_char
	move.b %d0,(%a2)+
	lea (9,%a4),%a0
	addq.l #4,%sp
	cmp.l %a2,%a0
	jbne .L179
	lea (8,%a3),%a2
	jbra .L181
.L182:
	addq.w #1,index
.L181:
	moveq #0,%d0
	move.w index,%d0
	add.l %d4,%d0
	add.l #parm,%d0
	move.l %d0,-(%sp)
	jbsr delim
	addq.l #4,%sp
	tst.w %d0
	jbeq .L182
	move.w index,%d3
	moveq #0,%d1
	move.w %d3,%d1
	move.l %d2,%d0
	add.l %d2,%d0
	lsl.l #5,%d2
	sub.l %d0,%d2
	move.l %d2,%a0
	add.l #parm,%a0
	cmp.b #46,(%a0,%d1.l)
	jbne .L184
	addq.w #1,%d3
	move.w %d3,index
.L186:
	moveq #0,%d0
	move.w index,%d0
	add.l %d4,%d0
	add.l #parm,%d0
	move.l %d0,-(%sp)
	jbsr true_char
	move.b %d0,(%a2)+
	lea (12,%a4),%a0
	addq.l #4,%sp
	cmp.l %a2,%a0
	jbne .L186
.L184:
	lea (1,%a4),%a0
	moveq #1,%d1
	clr.w %d0
.L187:
	cmp.b #63,(%a0)
	jbne .L188
	addq.w #1,%d0
.L188:
	addq.w #1,%d1
	addq.l #1,%a0
	cmp.w #12,%d1
	jbne .L187
	and.l #65535,%d0
	jbra .L191
.L171:
	moveq #11,%d0
	jbra .L191
.L172:
	moveq #0,%d0
.L191:
	movm.l -24(%fp),#0x1c1c
	unlk %fp
	rts
	.size	fill_fcb, .-fill_fcb
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"SUB"
	.text
	.align	2
	.globl	cmd_file
	.type	cmd_file, @function
cmd_file:
	link.w %fp,#0
	movm.l #0x3f3c,-(%sp)
	move.w 10(%fp),%d5
	clr.b dirflag
	move.b #1,load_try
	pea 255.w
	pea 32.w
	lea bdos,%a2
	jbsr (%a2)
	move.w %d0,user
	clr.l -(%sp)
	pea 25.w
	jbsr (%a2)
	move.w %d0,cur_disk
	lea (16,%sp),%sp
	cmp.w #10,%d5
	seq %d3
	neg.b %d3
	pea cmdfcb
	moveq #0,%d0
	move.b %d3,%d0
	eor.w #1,%d0
	move.l %d0,-(%sp)
	jbsr fill_fcb
	addq.l #8,%sp
	tst.w %d0
	jbeq .L208
	pea msg7
	pea 9.w
	jbsr (%a2)
	jbra .L293
.L208:
	lea load_tbl,%a4
	move.w load_tbl,%d1
	move.w %d1,%d0
	swap %d0
	mov.w load_tbl+2,%d0
	move.l %d0,%a5
	cmp.b #32,cmdfcb+9.l
	jbeq .L211
	move.l %a4,%a3
	clr.b %d7
	jbra .L213
.L211:
	lea load_tbl+9,%a0
	jbra .L214
.L215:
	clr.b (%a0)
	clr.b -1(%a0)
	lea (10,%a0),%a0
.L214:
	move.w -9(%a0),%a1
	move.w %a1,%d0
	swap %d0
	mov.w -7(%a0),%d0
	move.l %d0,%a1
	tst.b (%a1)
	jbne .L215
	move.b cmdfcb,%d0
	ext.w %d0
	move.w %d0,%a0
	pea -1(%a0)
	pea 14.w
	lea bdos,%a2
	jbsr (%a2)
	move.b #63,cmdfcb
	clr.b cmdfcb+12
	pea cmdfcb
	pea 17.w
	jbsr (%a2)
	clr.b %d7
	clr.b %d6
	lea (16,%sp),%sp
	jbra .L217
.L218:
	move.w %d0,%d4
	lsl.w #5,%d4
	moveq #0,%d2
	move.w %d4,%d2
	lea dma,%a1
	move.b (%a1,%d2.l),%d0
	jbeq .L219
	ext.w %d0
	move.w %d0,%a0
	moveq #0,%d0
	move.w user,%d0
	cmp.l %a0,%d0
	jbne .L221
.L219:
	and.b #127,9(%a1,%d2.l)
	and.b #127,10(%a1,%d2.l)
	and.b #127,11(%a1,%d2.l)
	clr.b 12(%a1,%d2.l)
	lea load_tbl+8,%a3
	jbra .L222
.L223:
	pea cmdfcb+9
	move.l %d0,-(%sp)
	jbsr cpy
	moveq #0,%d0
	move.w %d4,%d0
	add.l #dma+1,%d0
	move.l %d0,-(%sp)
	pea cmdfcb+1
	jbsr ccp_strcmp
	lea (16,%sp),%sp
	tst.w %d0
	jbne .L224
	lea dma,%a0
	move.b (%a0,%d2.l),%d0
	ext.w %d0
	move.w %d0,%a0
	moveq #0,%d0
	move.w user,%d0
	cmp.l %a0,%d0
	jbne .L226
	move.b #1,(%a3)
	jbra .L228
.L226:
	move.b #1,1(%a3)
.L228:
	tst.b %d3
	jbeq .L229
	move.l %a5,-(%sp)
	move.w (%a2),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 2(%a2),%d0
	move.l %d0,-(%sp)
	jbsr ccp_strcmp
	addq.l #8,%sp
	tst.w %d0
	jbne .L229
	tst.b (%a3)
	jbeq .L229
	moveq #1,%d7
	moveq #1,%d6
	jbra .L224
.L229:
	moveq #1,%d7
.L224:
	lea (10,%a3),%a3
.L222:
	lea (-8,%a3),%a2
	move.w (%a2),%a0
	move.w %a0,%d0
	swap %d0
	mov.w 2(%a2),%d0
	move.l %d0,%a1
	tst.b (%a1)
	jbne .L223
.L221:
	pea 18.w
	jbsr bdos
	addq.l #4,%sp
.L217:
	cmp.w #255,%d0
	jbeq .L233
	tst.b %d6
	jbeq .L218
.L233:
	tst.b %d7
	jbne .L235
	cmp.w #7,%d5
	jbne .L237
	pea msg11
	pea 9.w
	jbsr bdos
	addq.l #8,%sp
.L237:
	move.b #1,dirflag
	clr.b load_try
	moveq #0,%d0
	move.w cur_disk,%d0
	move.l %d0,-(%sp)
	pea 14.w
	jbsr bdos
.L293:
	moveq #0,%d0
	addq.l #8,%sp
	jbra .L210
.L235:
	lea fill_fcb,%a0
	tst.b %d3
	jbeq .L239
	pea cmdfcb
	clr.l -(%sp)
	jbra .L289
.L239:
	pea cmdfcb
	pea 1.w
.L289:
	jbsr (%a0)
	addq.l #8,%sp
	lea load_tbl,%a3
	jbra .L242
.L243:
	tst.w 8(%a3)
	jbeq .L244
	tst.b %d3
	jbne .L246
	pea .LC0
	move.l %d0,-(%sp)
	jbsr ccp_strcmp
	addq.l #8,%sp
	tst.w %d0
	jbeq .L248
.L244:
	lea (10,%a3),%a3
.L242:
	move.w (%a3),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 2(%a3),%d0
	move.l %d0,%a0
	tst.b (%a0)
	jbne .L243
	jbra .L213
.L248:
	move.w (%a3),%a1
	move.w %a1,%d0
	swap %d0
	mov.w 2(%a3),%d0
	move.l %d0,%a0
	tst.b (%a0)
	jbeq .L213
.L246:
	tst.b 8(%a3)
	jbne .L249
	clr.l -(%sp)
	pea 32.w
	jbsr bdos
	addq.l #8,%sp
.L249:
	pea cmdfcb+9
	move.w (%a3),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 2(%a3),%d0
	move.l %d0,-(%sp)
	jbsr cpy
	addq.l #8,%sp
.L213:
	moveq #0,%d0
	move.w cur_disk,%d0
	move.l %d0,-(%sp)
	pea 14.w
	jbsr bdos
.L290:
	addq.w #4,%sp
	move.l #cmdfcb,(%sp)
	pea 15.w
	lea bdos,%a2
	jbsr (%a2)
	addq.l #8,%sp
	cmp.w #3,%d0
	jbhi .L252
	and.b #127,cmdfcb+9
	and.b #127,cmdfcb+10
	move.b cmdfcb+11,%d0
	and.b #127,%d0
	move.b %d0,cmdfcb+11
	cmp.b #83,cmdfcb+9.l
	jbne .L254
	cmp.b #85,cmdfcb+10.l
	jbne .L254
	cmp.b #66,%d0
	jbne .L254
	pea 255.w
	pea 32.w
	jbsr (%a2)
	move.w %d0,sub_user
	addq.l #8,%sp
	tst.b submit
	jbeq .L258
	move.b #1,chain_sub
	jbra .L260
.L258:
	move.b #1,first_sub
.L260:
	moveq #0,%d0
.L261:
	lea cmdfcb,%a1
	lea subfcb,%a0
	move.b (%a1,%d0.l),(%a0,%d0.l)
	addq.l #1,%d0
	moveq #36,%d1
	cmp.l %d0,%d1
	jbne .L261
	tst.b %d3
	jbeq .L263
	clr.b subprompt
.L263:
	move.b #1,submit
	clr.b end_of_file
	jbra .L283
.L254:
	cmp.w #7,%d5
	jbne .L266
	jbra .L267
.L252:
	pea 255.w
	pea 32.w
	jbsr (%a2)
	addq.l #8,%sp
	tst.w %d0
	jbeq .L268
	clr.l -(%sp)
	pea 32.w
	jbsr (%a2)
	jbra .L290
.L268:
	cmp.w #7,%d5
	jbne .L270
	jbra .L267
.L271:
	pea cmdfcb+9
	move.l %d0,-(%sp)
	jbsr ccp_strcmp
	addq.l #8,%sp
	tst.w %d0
	jbeq .L272
	lea (10,%a4),%a4
.L287:
	move.w (%a4),%a0
	move.w %a0,%d0
	swap %d0
	mov.w 2(%a4),%d0
	move.l %d0,%a1
	tst.b (%a1)
	jbne .L271
	jbra .L275
.L288:
	move.l %a3,%a4
.L272:
	move.w (%a4),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 2(%a4),%d0
	move.l %d0,%a0
	tst.b (%a0)
	jbeq .L275
	move.w 4(%a4),%a1
	move.w %a1,%d0
	swap %d0
	mov.w 6(%a4),%d0
	jbra .L278
.L275:
	move.l #load68k,%d0
.L278:
	move.l glb_index,-(%sp)
	move.l %d0,%a0
	jbsr (%a0)
	addq.l #4,%sp
	cmp.w #2,%d0
	jbeq .L281
	cmp.w #3,%d0
	jbeq .L282
	lea bdos,%a0
	cmp.w #1,%d0
	jbne .L279
	pea lderr1
	jbra .L294
.L281:
	pea lderr2
	jbra .L295
.L282:
	pea lderr3
.L295:
	pea 9.w
	jbsr bdos
	jbra .L292
.L279:
	pea lderror
.L294:
	pea 9.w
	jbsr (%a0)
.L292:
	addq.l #8,%sp
	jbra .L283
.L267:
	pea msg11
	pea 9.w
	jbsr bdos
	addq.l #8,%sp
	jbra .L270
.L266:
	move.l glb_index,-(%sp)
	jbsr check_cmd
	addq.l #4,%sp
	tst.b %d7
	jbeq .L287
	jbra .L288
.L270:
	moveq #0,%d0
	move.w user,%d0
	move.l %d0,-(%sp)
	pea 32.w
	jbsr bdos
	move.b #1,dirflag
	clr.b load_try
	clr.b morecmds
	moveq #0,%d0
	jbra .L291
.L283:
	moveq #0,%d0
	move.w user,%d0
	move.l %d0,-(%sp)
	pea 32.w
	jbsr bdos
	move.b #1,dirflag
	clr.b load_try
	clr.b morecmds
	moveq #1,%d0
.L291:
	addq.l #8,%sp
	and.l #65535,%d0
.L210:
	movm.l -40(%fp),#0x3cfc
	unlk %fp
	rts
	.size	cmd_file, .-cmd_file
	.align	2
	.globl	decode
	.type	decode, @function
decode:
	link.w %fp,#0
	movm.l #0x3020,-(%sp)
	move.l 8(%fp),%d3
	moveq #0,%d2
	sub.l %a2,%a2
.L297:
	lea cmd_tbl,%a0
	move.w (%a0,%a2.l),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 2(%a0,%a2.l),%d0
	move.l %d0,-(%sp)
	move.l %d3,-(%sp)
	jbsr ccp_strcmp
	addq.l #8,%sp
	tst.w %d0
	jbeq .L323
	addq.l #1,%d2
	addq.l #6,%a2
	moveq #7,%d0
	cmp.l %d2,%d0
	jbne .L297
	clr.b %d0
	jbra .L302
.L303:
	addq.w #1,%d2
	addq.l #1,%d0
	moveq #29,%d1
	cmp.l %d0,%d1
	jbeq .L304
.L302:
	move.w %d0,%d2
	lea parm,%a0
	cmp.b #58,(%a0,%d0.l)
	jbne .L303
.L304:
	cmp.w #1,%d2
	jbne .L305
	tst.b parm+2
	jbne .L307
	tst.b parm+30
	jbne .L307
	move.b parm,%d0
	add.b #-65,%d0
	cmp.b #15,%d0
	jbhi .L310
	moveq #5,%d0
	jbra .L300
.L307:
	move.b parm,%d0
	add.b #-65,%d0
	cmp.b #15,%d0
	jbls .L312
	jbra .L310
.L305:
	moveq #0,%d0
	move.w %d2,%d0
	lea parm,%a0
	cmp.b #58,(%a0,%d0.l)
	jbeq .L310
.L312:
	pea cmdfcb
	clr.l -(%sp)
	jbsr fill_fcb
	addq.l #8,%sp
	tst.w %d0
	jbne .L310
	cmp.w #1,%d2
	jbne .L314
	move.b #2,%d0
	jbra .L316
.L314:
	clr.w %d0
.L316:
	and.l #65535,%d0
	add.l #parm,%d0
	move.l %d0,-(%sp)
	jbsr delim
	addq.l #4,%sp
	lea parm,%a0
	tst.w %d0
	jbeq .L318
	jbra .L310
.L319:
	cmp.b #31,%d0
	jble .L310
	addq.l #1,%a0
	cmp.l #parm+29,%a0
	jbeq .L321
.L318:
	move.b (%a0),%d0
	jbne .L319
	jbra .L321
.L310:
	moveq #0,%d0
	not.w %d0
	jbra .L300
.L323:
	move.l %a2,%a0
	add.l #cmd_tbl+4,%a0
	moveq #0,%d0
	move.w (%a0),%d0
	jbra .L300
.L321:
	moveq #8,%d0
.L300:
	movm.l -12(%fp),#0x40c
	unlk %fp
	rts
	.size	decode, .-decode
	.align	2
	.globl	cr_lf
	.type	cr_lf, @function
cr_lf:
	link.w %fp,#0
	move.l %a2,-(%sp)
	pea 13.w
	pea 2.w
	lea bdos,%a2
	jbsr (%a2)
	pea 10.w
	pea 2.w
	jbsr (%a2)
	lea (16,%sp),%sp
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	cr_lf, .-cr_lf
	.align	2
	.globl	get_cmd
	.type	get_cmd, @function
get_cmd:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%a2
	move.l 12(%fp),%a0
	add.l %a2,%a0
	move.l %a0,%d2
	subq.l #1,%d2
	move.b #-128,dma
	pea dma
	pea 10.w
	jbsr bdos
	addq.l #8,%sp
	tst.b dma+1
	jbeq .L329
	cmp.b #59,dma+2.l
	jbeq .L329
	jbsr cr_lf
.L329:
	moveq #0,%d0
	move.b dma+1,%d0
	lea dma,%a0
	move.b #10,2(%a0,%d0.l)
	cmp.b #59,dma+2.l
	jbne .L332
	move.b #10,dma+2
.L332:
	lea dma+2,%a0
	jbra .L334
.L335:
	addq.l #1,%a0
.L334:
	move.b (%a0),%d0
	cmp.b #32,%d0
	jbeq .L335
	cmp.b #9,%d0
	jbeq .L335
	jbra .L354
.L338:
	move.b %d1,%d0
	add.b #-97,%d0
	cmp.b #25,%d0
	jbhi .L339
	add.b #-32,%d1
.L339:
	move.b %d1,(%a2)
	move.b (%a0),%d0
	cmp.b #32,%d0
	jbeq .L356
	cmp.b #9,%d0
	jbne .L343
.L356:
	addq.l #1,%a0
	move.b (%a0),%d0
	cmp.b #32,%d0
	jbeq .L356
	cmp.b #9,%d0
	jbeq .L356
	jbra .L345
.L343:
	addq.l #1,%a0
.L345:
	addq.l #1,%a2
.L354:
	move.b (%a0),%d1
	cmp.b #10,%d1
	jbeq .L346
	cmp.l %a2,%d2
	jbgt .L338
.L346:
	clr.b (%a2)
	move.l -8(%fp),%d2
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	get_cmd, .-get_cmd
	.align	2
	.globl	prompt
	.type	prompt, @function
prompt:
	link.w %fp,#-4
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	pea 255.w
	pea 32.w
	lea bdos,%a2
	jbsr (%a2)
	move.w %d0,%d2
	clr.l -(%sp)
	pea 25.w
	jbsr (%a2)
	move.w %d0,%a2
	jbsr cr_lf
	lea (16,%sp),%sp
	tst.w %d2
	jbeq .L358
	cmp.w #9,%d2
	jbls .L360
	move.b #49,-3(%fp)
	add.b #38,%d2
	move.b %d2,-2(%fp)
	move.b #36,-1(%fp)
	jbra .L362
.L360:
	add.b #48,%d2
	move.b %d2,-3(%fp)
	move.b #36,-2(%fp)
.L362:
	pea -3(%fp)
	pea 9.w
	jbsr bdos
	addq.l #8,%sp
.L358:
	lea (65,%a2),%a2
	move.w %a2,-(%sp)
	clr.w -(%sp)
	pea 2.w
	lea bdos,%a2
	jbsr (%a2)
	pea 62.w
	pea 2.w
	jbsr (%a2)
	lea (16,%sp),%sp
	move.l -12(%fp),%d2
	move.l -8(%fp),%a2
	unlk %fp
	rts
	.size	prompt, .-prompt
	.align	2
	.globl	comments
	.type	comments, @function
comments:
	link.w %fp,#0
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	move.l 12(%fp),%d3
	move.w 10(%fp),%d2
	jbsr prompt
	jbra .L390
.L366:
	move.w %d2,%d1
	addq.w #1,%d1
	cmp.b #36,%d0
	jbne .L367
	move.l %d3,-(%sp)
	clr.l -(%sp)
	move.w %d1,-(%sp)
	clr.w -(%sp)
	jbsr dollar
	move.w %d0,%d2
	lea (12,%sp),%sp
	jbra .L390
.L367:
	move.w %d1,%d2
	ext.w %d0
	move.w %d0,%a0
	move.l %a0,-(%sp)
	pea 2.w
	jbsr bdos
	addq.l #8,%sp
.L390:
	cmp.w #127,%d2
	jbhi .L369
.L385:
	moveq #0,%d0
	move.w %d2,%d0
	lea subdma,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #26,%d0
	jbeq .L371
	cmp.b #13,%d0
	jbne .L366
	jbra .L373
.L369:
	cmp.w #128,%d2
	jbne .L374
	move.b subdma+128,%d0
	cmp.b #26,%d0
	jbeq .L371
	cmp.b #13,%d0
	jbeq .L377
	jbsr sub_read
	tst.w %d0
	jbeq .L384
	clr.b %d2
	jbra .L385
.L374:
	moveq #0,%d0
	move.w %d2,%d0
	lea subdma,%a0
	cmp.b #13,(%a0,%d0.l)
	jbne .L371
.L373:
	addq.w #2,%d2
	cmp.w #127,%d2
	jbls .L381
.L377:
	jbsr sub_read
.L384:
	clr.w %d2
	jbra .L381
.L371:
	move.b #1,end_of_file
.L381:
	moveq #0,%d0
	move.w %d2,%d0
	move.l -8(%fp),%d2
	move.l -4(%fp),%d3
	unlk %fp
	rts
	.size	comments, .-comments
	.align	2
	.globl	translate
	.type	translate, @function
translate:
	link.w %fp,#0
	movm.l #0x3800,-(%sp)
	move.l 8(%fp),%d4
	move.w sub_index,%d1
	clr.w %d3
	jbra .L449
.L393:
	cmp.b #26,%d2
	jbeq .L397
	jbgt .L400
	cmp.b #9,%d2
	jbeq .L395
	cmp.b #10,%d2
	jbne .L394
	jbra .L447
.L400:
	cmp.b #36,%d2
	jbeq .L398
	cmp.b #59,%d2
	jbeq .L399
	cmp.b #32,%d2
	jbne .L394
	jbra .L395
.L399:
	move.l %d4,-(%sp)
	move.l %d0,-(%sp)
	jbsr comments
	move.w %d0,%d1
	addq.l #8,%sp
	jbra .L449
.L395:
	tst.w %d3
	jbeq .L440
	moveq #0,%d0
	move.w %d3,%d0
	lea subcom,%a0
	move.b %d2,(%a0,%d0.l)
	addq.w #1,%d3
.L403:
	addq.w #1,%d1
.L440:
	cmp.w #127,%d1
	jbhi .L404
.L435:
	moveq #0,%d0
	move.w %d1,%d0
	lea subdma,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #32,%d0
	jbeq .L403
	cmp.b #9,%d0
	jbeq .L403
	jbra .L449
.L404:
	jbsr sub_read
	tst.w %d0
	jbeq .L448
	clr.w %d1
	jbra .L435
.L398:
	move.w %d3,sub_index
	move.l %d4,-(%sp)
	pea 1.w
	addq.w #1,%d1
	move.w %d1,-(%sp)
	clr.w -(%sp)
	jbsr dollar
	move.w %d0,%d1
	move.w sub_index,%d3
	lea (12,%sp),%sp
	jbra .L449
.L397:
	move.b #1,end_of_file
	jbra .L449
.L394:
	moveq #0,%d0
	move.w %d3,%d0
	lea subcom,%a0
	move.b %d2,(%a0,%d0.l)
	addq.w #1,%d3
.L447:
	addq.w #1,%d1
	cmp.w #127,%d1
	jbls .L449
	jbsr sub_read
.L448:
	clr.w %d1
.L449:
	tst.b end_of_file
	jbne .L411
	cmp.w #127,%d3
	jbhi .L411
	moveq #0,%d0
	move.w %d1,%d0
	lea subdma,%a0
	move.b (%a0,%d0.l),%d2
	cmp.b #13,%d2
	jbeq .L442
	cmp.b #33,%d2
	jbne .L393
	jbra .L445
.L411:
	moveq #0,%d0
	move.w %d1,%d0
	lea subdma,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #13,%d0
	jbeq .L442
.L417:
	cmp.b #33,%d0
	jbne .L418
	jbra .L442
.L434:
	clr.w %d1
	jbra .L418
.L419:
	addq.w #1,%d1
.L442:
	cmp.w #127,%d1
	jbhi .L420
.L436:
	moveq #0,%d0
	move.w %d1,%d0
	lea subdma,%a0
	move.b (%a0,%d0.l),%d0
	cmp.b #13,%d0
	jbeq .L419
	cmp.b #10,%d0
	jbeq .L419
	cmp.b #33,%d0
	jbeq .L419
	jbra .L424
.L420:
	cmp.w #128,%d1
	jbne .L424
	jbsr sub_read
	tst.w %d0
	jbeq .L434
	clr.w %d1
	jbra .L436
.L424:
	moveq #0,%d0
	move.w %d1,%d0
	lea subdma,%a0
	cmp.b #26,(%a0,%d0.l)
	jbne .L418
	move.b #1,end_of_file
	jbra .L418
.L445:
	lea subdma,%a0
	move.b (%a0,%d0.l),%d0
	jbra .L417
.L418:
	move.w %d1,sub_index
	movm.l -12(%fp),#0x1c
	unlk %fp
	rts
	.size	translate, .-translate
	.align	2
	.globl	submit_cmd
	.type	submit_cmd, @function
submit_cmd:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	lea subcom,%a0
.L451:
	clr.b (%a0)+
	cmp.l #subcom+129,%a0
	jbne .L451
	pea 255.w
	pea 32.w
	lea bdos,%a2
	jbsr (%a2)
	move.w %d0,%d2
	moveq #0,%d0
	move.w sub_user,%d0
	move.l %d0,-(%sp)
	pea 32.w
	jbsr (%a2)
	pea subdma
	pea 26.w
	jbsr (%a2)
	lea (24,%sp),%sp
	tst.b first_sub
	jbne .L453
	tst.b chain_sub
	jbeq .L455
.L453:
	lea subdma,%a0
.L456:
	clr.b (%a0)+
	cmp.l #subdma+128,%a0
	jbne .L456
	jbsr sub_read
	clr.w sub_index
.L455:
	tst.b end_of_file
	jbne .L458
	move.l 8(%fp),-(%sp)
	jbsr translate
	addq.l #4,%sp
.L458:
	lea subcom,%a0
.L460:
	move.b (%a0),%d1
	move.b %d1,%d0
	add.b #-97,%d0
	cmp.b #25,%d0
	jbhi .L461
	add.b #-32,%d1
.L461:
	move.b %d1,(%a0)+
	cmp.l #subcom+128,%a0
	jbne .L460
	pea dma
	pea 26.w
	lea bdos,%a2
	jbsr (%a2)
	move.w %d2,-(%sp)
	clr.w -(%sp)
	pea 32.w
	jbsr (%a2)
	and.l #65535,%d0
	move.l -8(%fp),%d2
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	submit_cmd, .-submit_cmd
	.align	2
	.globl	echo_cmd
	.type	echo_cmd, @function
echo_cmd:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%a2
	move.w 14(%fp),%d2
	cmp.w #1,%d2
	jbne .L483
	tst.b autost
	jbeq .L474
	tst.b autorom
	jbne .L483
.L474:
	jbsr prompt
	jbra .L483
.L476:
	addq.l #1,%a2
	ext.w %d0
	move.w %d0,%a0
	move.l %a0,-(%sp)
	pea 2.w
	jbsr bdos
	addq.l #8,%sp
.L483:
	move.b (%a2),%d0
	jbeq .L477
	cmp.b #33,%d0
	jbne .L476
.L477:
	tst.w %d2
	jbne .L479
	pea 63.w
	pea 2.w
	jbsr bdos
	addq.l #8,%sp
	jbra .L482
.L479:
	jbsr cr_lf
.L482:
	move.l -8(%fp),%d2
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	echo_cmd, .-echo_cmd
	.align	2
	.globl	ren_cmd
	.type	ren_cmd, @function
ren_cmd:
	link.w %fp,#-36
	movm.l #0x3e30,-(%sp)
	tst.b parm+30
	jbne .L485
	pea msg3
	pea 9.w
	lea bdos,%a3
	jbsr (%a3)
	pea 29.w
	pea parm+90
	lea get_cmd,%a2
	jbsr (%a2)
	lea (16,%sp),%sp
	tst.b parm+90
	jbeq .L540
	pea msg4
	pea 9.w
	jbsr (%a3)
	pea 29.w
	pea parm+30
	jbsr (%a2)
	move.b #61,parm+60
	clr.w %d6
	lea (16,%sp),%sp
	jbra .L489
.L485:
	moveq #0,%d3
.L490:
	moveq #0,%d2
	move.w %d3,%d2
	lea parm,%a0
	move.b 30(%a0,%d2.l),%d1
	cmp.b #61,%d1
	jbeq .L491
	addq.l #1,%d3
	tst.b %d1
	jbeq .L549
	jbra .L490
.L491:
	tst.w %d3
	jbeq .L494
	tst.b 31(%a0,%d2.l)
	jbeq .L494
	tst.b parm+60
	jbne .L494
	jbra .L550
.L549:
	cmp.b #61,parm+60.l
	jbne .L494
	tst.b parm+61
	jbne .L494
	tst.b parm+90
	jbeq .L494
	jbra .L556
.L501:
	moveq #0,%d0
	move.w %d2,%d0
	lea parm,%a0
	move.b 30(%a0,%d0.l),%d1
	moveq #0,%d0
	move.w %a1,%d0
	move.b %d1,90(%a0,%d0.l)
	addq.w #1,%d2
	addq.l #1,%a1
	tst.b %d1
	jbne .L501
	move.b #61,parm+60
.L556:
	clr.w %d6
	jbra .L489
.L494:
	moveq #1,%d6
.L489:
	clr.w %d4
	moveq #1,%d5
	jbra .L560
.L504:
	addq.w #1,%d4
.L560:
	moveq #0,%d3
	move.w %d5,%d3
	moveq #0,%d2
	move.w %d4,%d2
	move.l %d3,%d1
	add.l %d3,%d1
	move.l %d3,%d0
	lsl.l #5,%d0
	sub.l %d1,%d0
	move.l %d0,%a0
	add.l #parm,%a0
	move.b (%a0,%d2.l),%d0
	cmp.b #58,%d0
	jbeq .L505
	tst.b %d0
	jbne .L504
.L505:
	cmp.w #1,%d4
	jbls .L507
	cmp.b #58,%d0
	jbne .L507
	moveq #1,%d6
.L507:
	move.l %d3,%d0
	add.l %d3,%d0
	lsl.l #5,%d3
	sub.l %d0,%d3
	lea parm,%a0
	move.b (%a0,%d3.l),%d0
	lea del,%a0
.L510:
	cmp.b (%a0),%d0
	jbeq .L542
	addq.l #1,%a0
	cmp.l #del+16,%a0
	jbne .L510
	addq.w #2,%d5
	cmp.w #3,%d5
	jbhi .L514
	clr.w %d4
	jbra .L560
.L514:
	tst.w %d6
	jbne .L516
	tst.b parm+30
	jbeq .L540
	tst.b parm+90
	jbeq .L540
	pea -36(%fp)
	pea 1.w
	lea fill_fcb,%a2
	jbsr (%a2)
	move.w %d0,%d2
	pea cmdfcb
	pea 3.w
	jbsr (%a2)
	lea (16,%sp),%sp
	tst.w %d2
	jbne .L520
	tst.w %d0
	jbne .L520
	move.b -36(%fp),%d1
	move.b cmdfcb,%d0
	cmp.b %d1,%d0
	jbeq .L523
	cmp.b #58,parm+31.l
	jbne .L525
	cmp.b #58,parm+91.l
	jbeq .L527
	move.b %d1,cmdfcb
	jbra .L523
.L525:
	cmp.b #58,parm+91.l
	jbne .L527
	move.b %d0,-36(%fp)
	jbra .L523
.L527:
	moveq #1,%d6
.L523:
	move.b -36(%fp),%d0
	subq.b #1,%d0
	cmp.b #15,%d0
	jbhi .L530
	tst.w %d6
	jbne .L532
	pea -36(%fp)
	pea 17.w
	lea bdos,%a2
	jbsr (%a2)
	addq.l #8,%sp
	cmp.w #255,%d0
	jbeq .L532
	pea msg5
	jbra .L558
.L530:
	moveq #1,%d6
.L532:
	moveq #0,%d0
.L535:
	lea cmdfcb,%a0
	move.b -36(%fp,%d0.l),16(%a0,%d0.l)
	addq.l #1,%d0
	moveq #20,%d1
	cmp.l %d0,%d1
	jbne .L535
	cmp.b #15,cmdfcb.l
	jbhi .L516
	tst.w %d6
	jbne .L516
	move.l %a0,-(%sp)
	pea 23.w
	lea bdos,%a2
	jbsr (%a2)
	addq.l #8,%sp
	tst.w %d0
	jbeq .L540
	pea msg6
.L558:
	pea 9.w
	jbsr (%a2)
	jbra .L557
.L520:
	pea msg7
	jbra .L559
.L516:
	pea msg8
.L559:
	pea 9.w
	jbsr bdos
	jbra .L557
.L550:
	lea parm,%a0
	clr.b 30(%a0,%d2.l)
	move.w %d3,%d2
	addq.w #1,%d2
	sub.l %a1,%a1
	jbra .L501
.L542:
	clr.l -(%sp)
	move.w %d5,%d0
	mulu.w #30,%d0
	add.l #parm,%d0
	move.l %d0,-(%sp)
	jbsr echo_cmd
.L557:
	addq.l #8,%sp
.L540:
	movm.l -64(%fp),#0xc7c
	unlk %fp
	rts
	.size	ren_cmd, .-ren_cmd
	.align	2
	.globl	chk_colon
	.type	chk_colon, @function
chk_colon:
	link.w %fp,#0
	move.w 10(%fp),%d1
	moveq #0,%d0
	move.w %d1,%d0
	lea parm,%a0
	cmp.b #58,30(%a0,%d0.l)
	jbne .L562
	cmp.w #1,%d1
	jbne .L564
	move.b parm+30,%d0
	cmp.b #64,%d0
	jble .L564
	cmp.b #80,%d0
	jble .L562
.L564:
	clr.l -(%sp)
	pea parm+30
	jbsr echo_cmd
	moveq #0,%d0
	addq.l #8,%sp
	jbra .L567
.L562:
	moveq #1,%d0
.L567:
	unlk %fp
	rts
	.size	chk_colon, .-chk_colon
	.align	2
	.globl	too_many
	.type	too_many, @function
too_many:
	link.w %fp,#0
	tst.b parm+60
	jbne .L570
	moveq #0,%d0
	jbra .L572
.L570:
	pea msg13
	pea 9.w
	jbsr bdos
	clr.l -(%sp)
	pea parm+60
	jbsr echo_cmd
	moveq #1,%d0
	lea (16,%sp),%sp
.L572:
	unlk %fp
	rts
	.size	too_many, .-too_many
	.align	2
	.globl	user_cmd
	.type	user_cmd, @function
user_cmd:
	link.w %fp,#0
	move.l %d2,-(%sp)
	tst.b parm+30
	jbne .L575
	pea msg10
	pea 9.w
	jbsr bdos
	pea 29.w
	pea parm+30
	jbsr get_cmd
	lea (16,%sp),%sp
	tst.b parm+30
	jbeq .L577
.L575:
	jbsr too_many
	tst.w %d0
	jbne .L577
	move.b parm+30,%d1
	move.b %d1,%d0
	add.b #-48,%d0
	cmp.b #9,%d0
	jbhi .L579
	ext.w %d1
	add.w #-48,%d1
	cmp.w #9,%d1
	jbhi .L579
	move.b parm+31,%d2
	jbeq .L582
	move.w %d1,%d0
	mulu.w #10,%d0
	move.b %d2,%d1
	ext.w %d1
	add.w %d0,%d1
	add.w #-48,%d1
	cmp.w #15,%d1
	jbhi .L579
.L582:
	tst.b parm+32
	jbne .L579
	move.w %d1,-(%sp)
	clr.w -(%sp)
	pea 32.w
	jbsr bdos
	moveq #1,%d0
	addq.l #8,%sp
	jbra .L585
.L577:
	moveq #1,%d0
	jbra .L585
.L579:
	moveq #0,%d0
.L585:
	move.l -4(%fp),%d2
	unlk %fp
	rts
	.size	user_cmd, .-user_cmd
	.align	2
	.globl	era_cmd
	.type	era_cmd, @function
era_cmd:
	link.w %fp,#0
	move.l %a2,-(%sp)
	tst.b parm+30
	jbne .L588
	pea msg2
	pea 9.w
	jbsr bdos
	pea 29.w
	pea parm+30
	jbsr get_cmd
	lea (16,%sp),%sp
	tst.b parm+30
	jbeq .L604
.L588:
	jbsr too_many
	tst.w %d0
	jbne .L604
	jbsr find_colon
	move.w %d0,-(%sp)
	clr.w -(%sp)
	jbsr chk_colon
	addq.l #4,%sp
	tst.w %d0
	jbeq .L604
	cmp.b #58,parm+31.l
	jbne .L593
	tst.b parm+32
	jbne .L593
	clr.l -(%sp)
	pea parm+30
	jbsr echo_cmd
	jbra .L605
.L593:
	pea cmdfcb
	pea 1.w
	jbsr fill_fcb
	addq.l #8,%sp
	tst.w %d0
	jbeq .L596
	tst.b submit
	jbne .L596
	pea msg9
	pea 9.w
	lea bdos,%a2
	jbsr (%a2)
	clr.l -(%sp)
	pea 1.w
	jbsr (%a2)
	move.b %d0,%d1
	add.b #-97,%d0
	lea (16,%sp),%sp
	cmp.b #25,%d0
	jbhi .L599
	add.b #-32,%d1
.L599:
	move.b %d1,parm+60
	jbsr cr_lf
	move.b parm+60,%d0
	cmp.b #78,%d0
	jbeq .L604
	cmp.b #89,%d0
	jbne .L604
	jbra .L602
.L596:
	cmp.b #78,parm+60.l
	jbeq .L604
.L602:
	pea cmdfcb
	pea 19.w
	lea bdos,%a2
	jbsr (%a2)
	addq.l #8,%sp
	tst.w %d0
	jbeq .L604
	pea msg6
	pea 9.w
	jbsr (%a2)
.L605:
	addq.l #8,%sp
.L604:
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	era_cmd, .-era_cmd
	.align	2
	.globl	type_cmd
	.type	type_cmd, @function
type_cmd:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	tst.b parm+30
	jbne .L607
	pea msg2
	pea 9.w
	jbsr bdos
	pea 29.w
	pea parm+30
	jbsr get_cmd
	lea (16,%sp),%sp
.L607:
	jbsr too_many
	tst.w %d0
	jbne .L623
	jbsr find_colon
	move.w %d0,-(%sp)
	clr.w -(%sp)
	jbsr chk_colon
	addq.l #4,%sp
	tst.w %d0
	jbeq .L623
	pea cmdfcb
	pea 1.w
	jbsr fill_fcb
	move.w %d0,%d2
	addq.l #8,%sp
	jbne .L612
	tst.b parm+30
	jbeq .L623
	pea cmdfcb
	pea 15.w
	jbsr bdos
	addq.l #8,%sp
	cmp.w #3,%d0
	jbhi .L612
	jbra .L633
.L616:
	lea dma,%a2
.L617:
	move.b (%a2),%d0
	cmp.b #26,%d0
	jbeq .L633
	ext.w %d0
	move.w %d0,%a0
	move.l %a0,-(%sp)
	pea 2.w
	jbsr bdos
	addq.l #1,%a2
	addq.l #8,%sp
	cmp.l #dma+128,%a2
	jbne .L617
.L633:
	pea cmdfcb
	pea 20.w
	lea bdos,%a2
	jbsr (%a2)
	addq.l #8,%sp
	tst.w %d0
	jbeq .L616
	move.b cmdfcb,%d0
	ext.w %d0
	move.w %d0,%a0
	move.l %a0,-(%sp)
	pea 37.w
	jbsr (%a2)
	jbra .L631
.L612:
	tst.b parm+30
	jbeq .L623
	lea bdos,%a0
	tst.w %d2
	jbeq .L621
	pea msg7
	jbra .L632
.L621:
	pea msg6
.L632:
	pea 9.w
	jbsr (%a0)
.L631:
	addq.l #8,%sp
.L623:
	move.l -8(%fp),%d2
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	type_cmd, .-type_cmd
	.align	2
	.globl	dir_cmd
	.type	dir_cmd, @function
dir_cmd:
	link.w %fp,#0
	movm.l #0x3f38,-(%sp)
	move.w 10(%fp),%d6
	jbsr too_many
	tst.w %d0
	jbne .L665
	jbsr find_colon
	move.w %d0,-(%sp)
	clr.w -(%sp)
	jbsr chk_colon
	addq.l #4,%sp
	tst.w %d0
	jbeq .L665
	pea cmdfcb
	pea 1.w
	jbsr fill_fcb
	move.b cmdfcb,%d5
	ext.w %d5
	add.w #64,%d5
	pea cmdfcb
	pea 17.w
	lea bdos,%a2
	jbsr (%a2)
	move.w %d0,%d3
	lea (16,%sp),%sp
	cmp.w #255,%d0
	jbne .L638
	pea msg6
	pea 9.w
	jbsr (%a2)
	addq.l #8,%sp
.L638:
	move.w %d3,%d2
	lsl.w #5,%d2
	addq.w #1,%d2
	clr.b %d7
	clr.w %d4
	sub.l %a4,%a4
	jbra .L675
.L641:
	moveq #0,%d0
	move.w %d2,%d0
	lea dma,%a0
	tst.w %d6
	jbeq .L642
	tst.b 9(%a0,%d0.l)
	jbge .L645
	jbra .L644
.L642:
	tst.b 9(%a0,%d0.l)
	jblt .L645
.L644:
	tst.b %d7
	jbeq .L646
	jbsr cr_lf
.L646:
	tst.w %d4
	jbne .L648
	move.w %d5,-(%sp)
	clr.w -(%sp)
	pea 2.w
	jbsr bdos
	addq.l #8,%sp
	jbra .L648
.L645:
	pea 18.w
	jbsr bdos
	move.w %d0,%d3
	move.w %d0,%d2
	lsl.w #5,%d2
	addq.w #1,%d2
	move.w #1,%a4
	addq.l #4,%sp
	jbra .L675
.L648:
	move.w %d3,%d2
	lsl.w #5,%d2
	addq.w #1,%d2
	pea 58.w
	pea 2.w
	lea bdos,%a2
	jbsr (%a2)
	pea 32.w
	pea 2.w
	jbsr (%a2)
	moveq #0,%d0
	move.w %d2,%d0
	lea dma,%a0
	move.b (%a0,%d0.l),%d0
	moveq #127,%d1
	and.l %d1,%d0
	move.l %d0,-(%sp)
	pea 2.w
	jbsr (%a2)
	moveq #2,%d3
	lea (24,%sp),%sp
.L650:
	addq.w #1,%d2
	cmp.w #9,%d3
	jbne .L651
	pea 32.w
	pea 2.w
	lea bdos,%a2
	jbsr (%a2)
	moveq #0,%d0
	move.w %d2,%d0
	addq.w #1,%d2
	lea dma,%a0
	move.b (%a0,%d0.l),%d0
	moveq #127,%d1
	and.l %d1,%d0
	move.l %d0,-(%sp)
	pea 2.w
	jbsr (%a2)
	move.b #10,%d3
	lea (16,%sp),%sp
.L651:
	moveq #0,%d0
	move.w %d2,%d0
	lea dma,%a3
	move.b (%a3,%d0.l),%d0
	moveq #127,%d1
	and.l %d1,%d0
	move.l %d0,-(%sp)
	pea 2.w
	lea bdos,%a2
	jbsr (%a2)
	addq.w #1,%d3
	addq.l #8,%sp
	cmp.w #11,%d3
	jbls .L650
	pea 32.w
	pea 2.w
	jbsr (%a2)
	pea 18.w
	jbsr (%a2)
	move.w %d0,%d3
	lea (12,%sp),%sp
	cmp.w #255,%d0
	jbeq .L654
	addq.w #1,%d4
	move.w %d0,%d2
	lsl.w #5,%d2
	addq.w #1,%d2
	cmp.w #5,%d4
	jbeq .L656
	clr.b %d7
	jbra .L675
.L656:
	moveq #0,%d0
	move.w %d2,%d0
	tst.w %d6
	jbeq .L658
	tst.b 9(%a3,%d0.l)
	jbge .L661
	jbra .L660
.L658:
	tst.b 9(%a3,%d0.l)
	jblt .L661
.L660:
	jbsr cr_lf
	clr.b %d7
	jbra .L673
.L661:
	moveq #1,%d7
.L673:
	clr.w %d4
.L675:
	cmp.w #255,%d3
	jbne .L641
.L654:
	move.w %a4,%d0
	jbeq .L665
	jbsr cr_lf
	lea bdos,%a0
	tst.w %d6
	jbeq .L663
	pea msg
	jbra .L674
.L663:
	pea msg+4
.L674:
	pea 9.w
	jbsr (%a0)
	addq.l #8,%sp
.L665:
	movm.l -36(%fp),#0x1cfc
	unlk %fp
	rts
	.size	dir_cmd, .-dir_cmd
	.align	2
	.globl	execute_cmd
	.type	execute_cmd, @function
execute_cmd:
	link.w %fp,#0
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),-(%sp)
	jbsr decode
	addq.l #4,%sp
	cmp.w #9,%d0
	jbhi .L677
	and.l #65535,%d0
	add.l %d0,%d0
	.set .LI687,.+2
	move.w .L687-.LI687.b(%pc,%d0.l),%d0
	jmp %pc@(2,%d0:w)
	.align	2
	.swbeg	&10
.L687:
	.word .L678-.L687
	.word .L679-.L687
	.word .L680-.L687
	.word .L681-.L687
	.word .L682-.L687
	.word .L683-.L687
	.word .L684-.L687
	.word .L677-.L687
	.word .L685-.L687
	.word .L686-.L687
.L685:
	moveq #10,%d2
	jbra .L688
.L678:
	clr.l -(%sp)
	jbra .L702
.L686:
	pea 1.w
.L702:
	jbsr dir_cmd
	addq.l #4,%sp
	jbra .L700
.L679:
	jbsr type_cmd
	jbra .L700
.L680:
	jbsr ren_cmd
	jbra .L700
.L681:
	jbsr era_cmd
	jbra .L700
.L682:
	jbsr user_cmd
	tst.w %d0
	jbne .L700
	pea msg12
	pea 9.w
	jbra .L704
.L683:
	move.b parm,%d0
	ext.w %d0
	move.w %d0,%a0
	pea -65(%a0)
	pea 14.w
.L704:
	jbsr bdos
	jbra .L703
.L684:
	tst.b parm+30
	jbne .L691
	pea msg2
	pea 9.w
	jbsr bdos
	pea 127.w
	pea subdma
	jbsr get_cmd
	sub.l %a1,%a1
	lea (16,%sp),%sp
	jbra .L693
.L694:
	lea parm,%a0
	move.b %d0,29(%a0,%a1.l)
.L693:
	move.w %a1,%d2
	move.l %a1,%d1
	lea subdma,%a0
	move.b (%a0,%d1.l),%d0
	cmp.b #32,%d0
	jbeq .L695
	tst.b %d0
	jbeq .L695
	move.l %d1,%a1
	addq.l #1,%a1
	moveq #30,%d3
	cmp.l %a1,%d3
	jbne .L694
.L695:
	lea parm,%a0
	clr.b 30(%a0,%d1.l)
	tst.w %d2
	jbeq .L700
	move.b #1,subprompt
	jbra .L701
.L691:
	clr.b subprompt
.L701:
	moveq #7,%d2
.L688:
	moveq #15,%d0
	and.l %d2,%d0
	move.l %d0,-(%sp)
	jbsr cmd_file
	addq.l #4,%sp
	tst.w %d0
	jbne .L700
	cmp.w #7,%d2
	jbeq .L700
.L677:
	clr.l -(%sp)
	pea parm
	jbsr echo_cmd
.L703:
	addq.l #8,%sp
.L700:
	move.l -8(%fp),%d2
	move.l -4(%fp),%d3
	unlk %fp
	rts
	.size	execute_cmd, .-execute_cmd
	.align	2
	.globl	ccp_main
	.type	ccp_main, @function
ccp_main:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.b #1,dirflag
	pea dma
	pea 26.w
	lea bdos,%a2
	jbsr (%a2)
	addq.l #8,%sp
	tst.b load_try
	jbeq .L706
	moveq #0,%d0
	move.w cur_disk,%d0
	move.l %d0,-(%sp)
	pea 14.w
	jbsr (%a2)
	moveq #0,%d0
	move.w user,%d0
	move.l %d0,-(%sp)
	pea 32.w
	jbsr (%a2)
	clr.b load_try
	lea (16,%sp),%sp
.L706:
	move.l chainp,%a0
	cmp.w #0,%a0
	jbeq .L708
	lea (1,%a0),%a2
	moveq #0,%d0
	move.b (%a0),%d0
	clr.b (%a2,%d0.l)
	clr.l chainp
	jbra .L756
.L708:
	tst.b morecmds
	jbeq .L711
	tst.b submit
	jbeq .L713
	jbra .L757
.L716:
	tst.b end_of_file
	jbne .L749
.L757:
	pea save_sub
	jbsr submit_cmd
	addq.l #4,%sp
	tst.b subcom
	jbeq .L716
	lea subcom,%a2
	jbra .L719
.L749:
	move.l user_ptr,%a2
	clr.b submit
	jbra .L719
.L713:
	move.l user_ptr,%a2
.L719:
	clr.b morecmds
	jbra .L731
.L711:
	jbsr prompt
	tst.b autost
	jbeq .L722
	tst.b autorom
	jbeq .L722
	pea 1.w
	pea usercmd
	jbsr echo_cmd
	clr.b autorom
	jbra .L761
.L722:
	pea 128.w
	pea usercmd
	jbsr get_cmd
.L761:
	lea usercmd,%a2
	jbra .L760
.L725:
	move.l %a2,glb_index
	move.l %a2,-(%sp)
	jbsr get_parms
	move.b parm,%d0
	addq.l #4,%sp
	jbeq .L726
	cmp.b #59,%d0
	jbeq .L726
	pea parm
	jbsr execute_cmd
	addq.l #4,%sp
.L726:
	tst.b submit
	jbne .L729
	move.l %a2,-(%sp)
	jbsr scan_cmd
	move.l %d0,%a2
	addq.l #4,%sp
	jbra .L731
.L729:
	tst.b first_sub
	jbne .L732
	tst.b chain_sub
	jbeq .L734
.L732:
	lea copy_cmd,%a0
	tst.b subprompt
	jbeq .L735
	pea subdma
	jbra .L758
.L735:
	move.l glb_index,-(%sp)
.L758:
	jbsr (%a0)
	addq.l #4,%sp
	tst.b first_sub
	jbeq .L738
	move.l glb_index,-(%sp)
	jbsr scan_cmd
	move.l %d0,user_ptr
	addq.l #4,%sp
.L738:
	pea save_sub
	jbsr submit_cmd
	clr.b chain_sub
	clr.b first_sub
	jbra .L759
.L750:
	move.l user_ptr,%a2
	clr.b submit
	jbra .L731
.L734:
	clr.b subcom
	jbra .L754
.L741:
	tst.b end_of_file
	jbne .L750
	pea save_sub
	jbsr submit_cmd
.L759:
	addq.l #4,%sp
.L754:
	tst.b subcom
	jbeq .L741
	lea subcom,%a2
.L731:
	tst.b (%a2)
	jbeq .L756
	pea 1.w
	move.l %a2,-(%sp)
	jbsr echo_cmd
.L760:
	addq.l #8,%sp
.L756:
	tst.b (%a2)
	jbne .L725
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	ccp_main, .-ccp_main
	.globl	cmd_tbl
	.section	.rodata.str1.1
.LC1:
	.string	"DIR"
.LC2:
	.string	"DIRS"
.LC3:
	.string	"TYPE"
.LC4:
	.string	"REN"
.LC5:
	.string	"ERA"
.LC6:
	.string	"USER"
.LC7:
	.string	"SUBMIT"
	.data
	.align	2
	.type	cmd_tbl, @object
	.size	cmd_tbl, 48
cmd_tbl:
	.long	.LC1
	.word	0
	.long	.LC2
	.word	9
	.long	.LC3
	.word	1
	.long	.LC4
	.word	2
	.long	.LC5
	.word	3
	.long	.LC6
	.word	4
	.long	.LC7
	.word	6
	.long	0
	.word	-1
	.globl	msg
	.section	.rodata
	.type	msg, @object
	.size	msg, 26
msg:
	.string	"NON-SYSTEM FILE(S) EXIST$"
	.globl	msg2
	.type	msg2, @object
	.size	msg2, 18
msg2:
	.string	"Enter Filename: $"
	.globl	msg3
	.type	msg3, @object
	.size	msg3, 18
msg3:
	.string	"Enter Old Name: $"
	.globl	msg4
	.type	msg4, @object
	.size	msg4, 18
msg4:
	.string	"Enter New Name: $"
	.globl	msg5
	.type	msg5, @object
	.size	msg5, 21
msg5:
	.string	"File already exists$"
	.globl	msg6
	.type	msg6, @object
	.size	msg6, 9
msg6:
	.string	"No file$"
	.globl	msg7
	.type	msg7, @object
	.size	msg7, 23
msg7:
	.string	"No wildcard filenames$"
	.globl	msg8
	.type	msg8, @object
	.size	msg8, 29
msg8:
	.string	"Syntax: REN Newfile=Oldfile$"
	.globl	msg9
	.type	msg9, @object
	.size	msg9, 16
msg9:
	.string	"Confirm(Y/N)? $"
	.globl	msg10
	.type	msg10, @object
	.size	msg10, 17
msg10:
	.string	"Enter User No: $"
	.globl	msg11
	.type	msg11, @object
	.size	msg11, 21
msg11:
	.string	".SUB file not found$"
	.globl	msg12
	.type	msg12, @object
	.size	msg12, 24
msg12:
	.string	"User # range is [0-15]$"
	.globl	msg13
	.type	msg13, @object
	.size	msg13, 22
msg13:
	.string	"Too many arguments: $"
	.globl	lderr1
	.type	lderr1, @object
	.size	lderr1, 40
lderr1:
	.string	"Insufficient memory or bad file header$"
	.globl	lderr2
	.type	lderr2, @object
	.size	lderr2, 28
lderr2:
	.string	"Read error on program load$"
	.globl	lderr3
	.type	lderr3, @object
	.size	lderr3, 33
lderr3:
	.string	"Bad relocation information bits$"
	.globl	lderror
	.type	lderror, @object
	.size	lderror, 20
lderror:
	.string	"Program load error$"
	.globl	del
	.data
	.type	del, @object
	.size	del, 16
del:
	.byte	62
	.byte	60
	.byte	46
	.byte	44
	.byte	61
	.byte	91
	.byte	93
	.byte	59
	.byte	124
	.byte	38
	.byte	47
	.byte	40
	.byte	41
	.byte	43
	.byte	45
	.byte	92
	.comm	load_try,1,1
	.comm	first_sub,1,1
	.comm	chain_sub,1,1
	.comm	end_of_file,1,1
	.comm	dirflag,1,1
	.comm	subprompt,1,1
	.comm	sub_index,2,2
	.comm	index,2,2
	.comm	sub_user,2,2
	.comm	user,2,2
	.comm	cur_disk,2,2
	.comm	subcom,129,1
	.comm	subdma,128,1
	.comm	user_ptr,4,4
	.comm	glb_index,4,4
	.comm	save_sub,129,1
	.comm	subfcb,36,1
	.comm	cmdfcb,36,1
	.comm	tail,4,4
	.comm	autorom,1,1
	.comm	dma,131,1
	.comm	parm,120,1
	.comm	chainp,4,4
	.ident	"GCC: (GNU) 4.1.1"
