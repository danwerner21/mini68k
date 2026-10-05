#NO_APP
	.file	"n8io.c"
	.text
	.align	2
	.globl	cpm_memset
	.type	cpm_memset, @function
cpm_memset:
	link.w %fp,#0
	move.l %d2,-(%sp)
	move.l 8(%fp),%d0
	move.l 12(%fp),%d2
	move.l 16(%fp),%d1
	move.l %d0,%a0
	jbra .L2
.L3:
	move.b %d2,(%a0)+
.L2:
	dbra %d1,.L3
	clr.w %d1
	subq.l #1,%d1
	jbcc .L3
	move.l (%sp)+,%d2
	unlk %fp
	rts
	.size	cpm_memset, .-cpm_memset
	.align	2
	.globl	cpm_memcpy
	.type	cpm_memcpy, @function
cpm_memcpy:
	link.w %fp,#0
	move.l 8(%fp),%d0
	move.l 12(%fp),%a1
	move.l 16(%fp),%d1
	move.l %d0,%a0
	jbra .L7
.L8:
	move.b (%a1)+,(%a0)+
.L7:
	dbra %d1,.L8
	clr.w %d1
	subq.l #1,%d1
	jbcc .L8
	unlk %fp
	rts
	.size	cpm_memcpy, .-cpm_memcpy
	.align	2
	.globl	disk_drive_select
	.type	disk_drive_select, @function
disk_drive_select:
	link.w %fp,#0
	move.b 11(%fp),%d0
	cmp.b #15,%d0
	jbhi .L12
	and.w #255,%d0
	move.w %d0,current_drive
	ext.l %d0
	lea partition+8,%a0
	lsl.l #4,%d0
	move.w (%a0,%d0.l),%a1
	move.w %a1,%d1
	swap %d1
	mov.w 2(%a0,%d0.l),%d1
	move.l %d1,%d0
	jbra .L14
.L12:
	move.w #-1,current_drive
	moveq #0,%d0
.L14:
	unlk %fp
	rts
	.size	disk_drive_select, .-disk_drive_select
	.align	2
	.globl	lru_update
	.type	lru_update, @function
lru_update:
	link.w %fp,#0
	move.w 10(%fp),%d0
	move.w %d0,%a0
	add.l #lru,%a0
	move.b (%a0),%d1
	jbra .L17
.L18:
	move.b -1(%a0),(%a0)
	subq.l #1,%a0
.L17:
	dbra %d0,.L18
	move.b %d1,lru
	unlk %fp
	rts
	.size	lru_update, .-lru_update
	.align	2
	.globl	disk_set_track
	.type	disk_set_track, @function
disk_set_track:
	link.w %fp,#0
	move.w 10(%fp),current_track
	moveq #0,%d0
	unlk %fp
	rts
	.size	disk_set_track, .-disk_set_track
	.align	2
	.globl	disk_set_sector
	.type	disk_set_sector, @function
disk_set_sector:
	link.w %fp,#0
	move.w 10(%fp),current_sector
	moveq #0,%d0
	unlk %fp
	rts
	.size	disk_set_sector, .-disk_set_sector
	.align	2
	.globl	disk_set_DMA_address
	.type	disk_set_DMA_address, @function
disk_set_DMA_address:
	link.w %fp,#0
	move.l 8(%fp),DMA_address
	moveq #0,%d0
	unlk %fp
	rts
	.size	disk_set_DMA_address, .-disk_set_DMA_address
	.align	2
	.globl	log2
	.type	log2, @function
log2:
	link.w %fp,#0
	move.l 8(%fp),%d1
	move.l %d1,%d0
	subq.l #1,%d0
	and.l %d1,%d0
	seq %d0
	ext.w %d0
	move.w %d0,%a0
	jbra .L28
.L29:
	addq.l #1,%a0
	lsr.l #1,%d1
.L28:
	tst.l %d1
	jbne .L29
	move.l %a0,%d0
	unlk %fp
	rts
	.size	log2, .-log2
	.align	2
	.globl	disk_home
	.type	disk_home, @function
disk_home:
	link.w %fp,#0
	move.w current_drive,%d0
	ext.l %d0
	lsl.l #4,%d0
	lea partition,%a0
	move.w 12(%a0,%d0.l),%a0
	move.l %a0,-(%sp)
	jbsr _disk_reset
	moveq #0,%d0
	unlk %fp
	rts
	.size	disk_home, .-disk_home
	.align	2
	.globl	purge_to_disk
	.type	purge_to_disk, @function
purge_to_disk:
	link.w %fp,#0
	move.l %a2,-(%sp)
	move.l %d2,-(%sp)
	move.l 8(%fp),%d1
	move.l %d1,%d0
	add.l %d1,%d0
	add.l %d1,%d0
	move.l %d0,%a0
	add.l %d0,%a0
	move.l %a0,%a2
	add.l #content,%a2
	moveq #0,%d0
	move.b 5(%a2),%d0
	btst #4,%d0
	jbeq .L35
	moveq #15,%d2
	and.l %d2,%d0
	jbeq .L35
	moveq #9,%d0
	lsl.l %d0,%d1
	add.l #buffer,%d1
	move.l %d1,-(%sp)
	move.w (%a2),%d2
	move.w %d2,%d1
	swap %d1
	mov.w 2(%a2),%d1
	move.l %d1,-(%sp)
	moveq #0,%d0
	move.b 4(%a2),%d0
	move.l %d0,-(%sp)
	jbsr _write_sector
	move.l %d0,errno
	and.b #-16,5(%a2)
	lea (12,%sp),%sp
.L35:
	moveq #0,%d0
	move.l -8(%fp),%d2
	move.l -4(%fp),%a2
	unlk %fp
	rts
	.size	purge_to_disk, .-purge_to_disk
	.align	2
	.globl	disk_flush_buffers
	.type	disk_flush_buffers, @function
disk_flush_buffers:
	link.w %fp,#0
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	moveq #0,%d2
	moveq #0,%d3
.L40:
	move.l %d2,-(%sp)
	jbsr purge_to_disk
	addq.l #4,%sp
	tst.l errno
	jbeq .L41
	moveq #-1,%d3
.L41:
	addq.l #1,%d2
	moveq #12,%d0
	cmp.l %d2,%d0
	jbne .L40
	move.l %d3,%d0
	move.l -8(%fp),%d2
	move.l -4(%fp),%d3
	unlk %fp
	rts
	.size	disk_flush_buffers, .-disk_flush_buffers
	.align	2
	.globl	get_into_memory
	.type	get_into_memory, @function
get_into_memory:
	link.w %fp,#0
	movm.l #0x3830,-(%sp)
	move.l 12(%fp),%d3
	move.w 10(%fp),%d2
	move.w 18(%fp),%d4
	moveq #0,%d1
.L48:
	lea lru,%a0
	move.b (%a0,%d1.l),%d0
	ext.w %d0
	move.w %d0,%a3
	lea (%a3,%a3.l),%a0
	add.l %a3,%a0
	add.l %a0,%a0
	add.l #content,%a0
	btst #4,5(%a0)
	jbeq .L49
	move.w (%a0),%a1
	move.w %a1,%d0
	swap %d0
	mov.w 2(%a0),%d0
	cmp.l %d0,%d3
	jbne .L49
	moveq #0,%d0
	move.b 4(%a0),%d0
	move.w %d2,%a0
	cmp.l %d0,%a0
	jbeq .L60
.L49:
	addq.l #1,%d1
	moveq #12,%d0
	cmp.l %d1,%d0
	jbne .L48
	move.b lru+11,%d0
	ext.w %d0
	move.w %d0,%a3
	lea (%a3,%a3.l),%a0
	add.l %a3,%a0
	add.l %a0,%a0
	move.l %a0,%a2
	add.l #content,%a2
	move.l %a3,-(%sp)
	jbsr purge_to_disk
	clr.b 5(%a2)
	addq.l #4,%sp
	move.l %a3,%d0
	moveq #9,%d1
	lsl.l %d1,%d0
	tst.w %d4
	jbne .L55
	add.l #buffer,%d0
	move.l %d0,-(%sp)
	move.l %d3,-(%sp)
	move.w %d2,%a0
	move.l %a0,-(%sp)
	jbsr _read_sector
	move.l %d0,errno
	lea (12,%sp),%sp
	jbeq .L57
	move.w #-1,%a3
	jbra .L53
.L60:
	move.w %d1,%a1
	move.l %a1,-(%sp)
	jbra .L63
.L55:
	clr.l errno
	pea 512.w
	clr.l -(%sp)
	add.l #buffer,%d0
	move.l %d0,-(%sp)
	jbsr cpm_memset
	or.b #15,5(%a2)
	lea (12,%sp),%sp
.L57:
	or.b #16,5(%a2)
	move.b %d2,4(%a2)
	move.l %d3,%d0
	clr.w %d0
	swap %d0
	move.w %d0,(%a2)
	move.w %d3,2(%a2)
	pea 11.w
.L63:
	jbsr lru_update
	addq.l #4,%sp
.L53:
	move.l %a3,%d0
	movm.l -20(%fp),#0xc1c
	unlk %fp
	rts
	.size	get_into_memory, .-get_into_memory
	.globl	__udivsi3
	.align	2
	.globl	disk_write_sector
	.type	disk_write_sector, @function
disk_write_sector:
	link.w %fp,#0
	movm.l #0x3e38,-(%sp)
	move.w 10(%fp),%d6
	move.w current_drive,%d0
	ext.l %d0
	lsl.l #4,%d0
	move.l %d0,%a2
	add.l #partition,%a2
	move.w 8(%a2),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 10(%a2),%d0
	move.l %d0,%a0
	move.w 14(%a0),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 16(%a0),%d0
	move.l %d0,%a3
	move.w current_track,%d2
	move.w (%a3),%d1
	move.w current_sector,%d0
	move.w 12(%a2),%d3
	cmp.w #100,%d3
	jbgt .L65
	mulu.w %d2,%d1
	and.l #65535,%d0
	move.l %d1,%d4
	add.l %d0,%d4
	cmp.w #100,%d3
	jbne .L67
	move.w 4(%a2),%a0
	move.w %a0,%d0
	swap %d0
	mov.w 6(%a2),%d0
	cmp.l %d4,%d0
	jbls .L65
	pea 128.w
	move.l DMA_address,-(%sp)
	move.w (%a2),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 2(%a2),%d0
	lsl.l #7,%d4
	move.l %d0,%a0
	pea (%a0,%d4.l)
	jbsr cpm_memcpy
	moveq #0,%d0
	lea (12,%sp),%sp
	jbra .L70
.L67:
	move.w 14(%a2),%d0
	jbge .L71
	add.w #127,%d0
.L71:
	asr.w #7,%d0
	move.w %d0,%a4
	move.l %a4,-(%sp)
	move.l %d4,-(%sp)
	jbsr __udivsi3
	addq.l #8,%sp
	move.l %d0,%d1
	move.w 4(%a2),%a0
	move.w %a0,%d0
	swap %d0
	mov.w 6(%a2),%d0
	cmp.l %d1,%d0
	jbls .L65
	move.w (%a2),%a0
	move.w %a0,%d0
	swap %d0
	mov.w 2(%a2),%d0
	move.l %d1,%d5
	add.l %d0,%d5
	cmp.w #2,%d6
	jbne .L73
	moveq #0,%d0
	move.b 2(%a3),%d0
	subq.l #2,%d0
	moveq #1,%d3
	lsl.l %d0,%d3
	moveq #12,%d0
	sub.l %d3,%d0
	moveq #2,%d1
	cmp.l %d0,%d1
	jbge .L73
	move.l %d5,%d2
	add.l %d3,%d2
	jbra .L76
.L77:
	pea 1.w
	move.l %d2,-(%sp)
	move.w 12(%a2),%a0
	move.l %a0,-(%sp)
	jbsr get_into_memory
	lea (12,%sp),%sp
.L76:
	subq.l #1,%d3
	subq.l #1,%d2
	tst.l %d3
	jbne .L77
.L73:
	cmp.w #2,%d6
	seq %d0
	ext.w %d0
	ext.l %d0
	neg.l %d0
	move.l %d0,-(%sp)
	move.l %d5,-(%sp)
	move.w 12(%a2),%a2
	move.l %a2,-(%sp)
	jbsr get_into_memory
	move.l %d0,%d3
	lea (12,%sp),%sp
	jblt .L65
	move.l %a4,%d0
	subq.l #1,%d0
	move.l %d4,%d2
	and.l %d0,%d2
	lea content+4,%a0
	move.l %d3,%d1
	add.l %d3,%d1
	move.l %d1,%d0
	add.l %d3,%d0
	add.l %d0,%d0
	bset %d2,1(%a0,%d0.l)
	pea 128.w
	move.l DMA_address,-(%sp)
	add.l %d1,%d1
	add.l %d2,%d1
	lsl.l #7,%d1
	add.l #buffer,%d1
	move.l %d1,-(%sp)
	jbsr cpm_memcpy
	lea (12,%sp),%sp
	cmp.w #1,%d6
	jbeq .L79
	moveq #0,%d0
	jbra .L70
.L79:
	move.l %d3,-(%sp)
	jbsr purge_to_disk
	moveq #0,%d0
	addq.l #4,%sp
	jbra .L70
.L65:
	moveq #1,%d0
.L70:
	movm.l -32(%fp),#0x1c7c
	unlk %fp
	rts
	.size	disk_write_sector, .-disk_write_sector
	.align	2
	.globl	disk_read_sector
	.type	disk_read_sector, @function
disk_read_sector:
	link.w %fp,#0
	movm.l #0x3030,-(%sp)
	move.w current_drive,%d0
	ext.l %d0
	lsl.l #4,%d0
	move.l %d0,%a2
	add.l #partition,%a2
	move.w 8(%a2),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 10(%a2),%d0
	move.l %d0,%a0
	move.w 14(%a0),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 16(%a0),%d0
	move.w current_track,%d1
	move.l %d0,%a0
	mulu.w (%a0),%d1
	moveq #0,%d0
	move.w current_sector,%d0
	move.l %d1,%d2
	add.l %d0,%d2
	move.w 12(%a2),%d3
	cmp.w #99,%d3
	jble .L83
	move.w 4(%a2),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 6(%a2),%d0
	cmp.l %d2,%d0
	jbls .L85
	pea 128.w
	move.w (%a2),%a0
	move.w %a0,%d0
	swap %d0
	mov.w 2(%a2),%d0
	lsl.l #7,%d2
	move.l %d0,%a0
	pea (%a0,%d2.l)
	jbra .L92
.L83:
	move.w 14(%a2),%d1
	jbge .L88
	add.w #127,%d1
.L88:
	asr.w #7,%d1
	move.w %d1,%a3
	move.l %a3,-(%sp)
	move.l %d2,-(%sp)
	jbsr __udivsi3
	addq.l #8,%sp
	move.l %d0,%a0
	move.w 4(%a2),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 6(%a2),%d0
	cmp.l %a0,%d0
	jbls .L85
	clr.l -(%sp)
	move.w (%a2),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 2(%a2),%d0
	pea (%a0,%d0.l)
	move.w %d3,%a0
	move.l %a0,-(%sp)
	jbsr get_into_memory
	lea (12,%sp),%sp
	tst.l %d0
	jblt .L85
	pea 128.w
	add.l %d0,%d0
	add.l %d0,%d0
	move.l %a3,%d1
	subq.l #1,%d1
	and.l %d1,%d2
	add.l %d2,%d0
	lsl.l #7,%d0
	add.l #buffer,%d0
	move.l %d0,-(%sp)
.L92:
	move.l DMA_address,-(%sp)
	jbsr cpm_memcpy
	moveq #0,%d0
	lea (12,%sp),%sp
	jbra .L87
.L85:
	moveq #1,%d0
.L87:
	movm.l -16(%fp),#0xc0c
	unlk %fp
	rts
	.size	disk_read_sector, .-disk_read_sector
	.globl	__divsi3
	.align	2
	.globl	init_ramdisk
	.type	init_ramdisk, @function
init_ramdisk:
	link.w %fp,#0
	movm.l #0x3030,-(%sp)
	move.l #_end,%d3
	cmp.l #1048576,%d3
	jbge .L94
	moveq #16,%d3
	swap %d3
.L94:
	jbsr _get_hma
	move.l %d0,%d1
	sub.l %d3,%d1
	cmp.l #511999,%d1
	jble .L103
	lea partition+16,%a3
.L97:
	move.w 4(%a3),%a0
	move.w %a0,%d0
	swap %d0
	mov.w 6(%a3),%d0
	tst.l %d0
	jbeq .L98
	move.w 8(%a3),%a0
	move.w %a0,%d0
	swap %d0
	mov.w 10(%a3),%d0
	tst.l %d0
	jbeq .L98
	cmp.l #partition+240,%a3
	jbeq .L103
	lea (16,%a3),%a3
	jbra .L97
.L98:
	move.l %d1,%d2
	cmp.l #1048576,%d1
	jble .L102
	moveq #16,%d2
	swap %d2
.L102:
	pea 16.w
	pea RAM_partition
	move.l %a3,-(%sp)
	jbsr cpm_memcpy
	move.w 8(%a3),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 10(%a3),%d0
	move.l %d0,%a0
	move.w 14(%a0),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 16(%a0),%d0
	move.l %d0,%a2
	moveq #0,%d1
	move.b 2(%a2),%d1
	moveq #127,%d0
	not.b %d0
	lsl.l %d1,%d0
	move.l %d0,%a0
	pea -1(%a0)
	move.l %d2,-(%sp)
	jbsr __divsi3
	addq.l #8,%sp
	move.w %d0,6(%a2)
	move.l %d2,%d1
	asr.l #7,%d1
	move.l %d1,%d0
	clr.w %d0
	swap %d0
	move.w %d0,4(%a3)
	move.w %d1,6(%a3)
	move.w 8(%a3),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 10(%a3),%d0
	move.l %d0,%a0
	move.w 14(%a0),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 16(%a0),%d0
	move.l %d0,%a0
	moveq #0,%d0
	move.w 8(%a0),%d0
	lsl.l #5,%d0
	move.l %d0,%a0
	pea 32(%a0)
	pea 229.w
	move.l %d3,-(%sp)
	jbsr cpm_memset
	lea (24,%sp),%sp
.L103:
	movm.l -16(%fp),#0xc0c
	unlk %fp
	rts
	.size	init_ramdisk, .-init_ramdisk
	.align	2
	.globl	cpm_malloc
	.type	cpm_malloc, @function
cpm_malloc:
	link.w %fp,#0
	move.l %d3,-(%sp)
	move.l %d2,-(%sp)
	move.l heap,%d3
	move.l 8(%fp),%d2
	addq.l #3,%d2
	moveq #-4,%d0
	and.l %d0,%d2
	clr.l -(%sp)
	jbsr _halloc
	move.l %d0,hma
	move.l %d3,%d1
	add.l %d2,%d1
	addq.l #4,%sp
	cmp.l %d1,%d0
	jbcc .L105
	moveq #0,%d0
	jbra .L107
.L105:
	move.l %d1,heap
	move.l %d2,-(%sp)
	clr.l -(%sp)
	move.l %d3,-(%sp)
	jbsr cpm_memset
	lea (12,%sp),%sp
.L107:
	move.l -8(%fp),%d2
	move.l -4(%fp),%d3
	unlk %fp
	rts
	.size	cpm_malloc, .-cpm_malloc
	.align	2
	.globl	make_dph
	.type	make_dph, @function
make_dph:
	link.w %fp,#0
	movm.l #0x3f38,-(%sp)
	pea 26.w
	lea cpm_malloc,%a2
	jbsr (%a2)
	move.l %d0,%a4
	pea 16.w
	jbsr (%a2)
	move.l %d0,%a2
	clr.w %d0
	swap %d0
	move.w %d0,14(%a4)
	move.w %a2,16(%a4)
	move.l 8(%fp),%d1
	addq.l #8,%sp
	cmp.l #4194304,%d1
	jble .L110
	moveq #64,%d1
	swap %d1
	jbra .L120
.L110:
	cmp.l #11520,%d1
	jbne .L111
	move.w #72,(%a2)
	jbra .L133
.L111:
	cmp.l #5760,%d1
	jbne .L114
	move.w #36,(%a2)
	jbra .L134
.L114:
	cmp.l #9600,%d1
	jbne .L116
	move.w #60,(%a2)
.L133:
	move.w #2,14(%a2)
	jbra .L113
.L116:
	cmp.l #2002,%d1
	jbne .L118
	move.w #26,(%a2)
	move.w #8,14(%a2)
	jbra .L113
.L118:
	cmp.l #4004,%d1
	jbne .L120
	move.w #52,(%a2)
.L134:
	move.w #4,14(%a2)
	jbra .L113
.L120:
	move.w #128,(%a2)
	clr.w 14(%a2)
.L113:
	move.w (%a2),%d0
	mulu.w 14(%a2),%d0
	move.l %d1,%d2
	sub.l %d0,%d2
	move.l %d2,-(%sp)
	lea log2,%a3
	jbsr (%a3)
	addq.l #4,%sp
	moveq #22,%d1
	cmp.l %d0,%d1
	jbge .L122
	moveq #15,%d0
	jbra .L124
.L122:
	move.l %d2,-(%sp)
	jbsr (%a3)
	move.l %d0,%d1
	addq.l #7,%d1
	addq.l #8,%d0
	asr.l #1,%d0
	addq.l #4,%sp
	moveq #11,%d3
	cmp.l %d0,%d3
	jble .L125
	moveq #11,%d0
.L125:
	moveq #18,%d3
	cmp.l %d1,%d3
	jblt .L124
	subq.l #1,%d0
.L124:
	move.l %d0,%a3
	moveq #14,%d0
	cmp.l %a3,%d0
	jbge .L127
	move.w #14,%a3
.L127:
	move.l %a3,%d4
	subq.l #7,%d4
	asr.l %d4,%d2
	moveq #-10,%d0
	add.l %a3,%d0
	moveq #1,%d6
	move.l %d6,%d1
	lsl.l %d0,%d1
	move.l %d1,%d5
	subq.l #1,%d5
	move.l %d2,%d7
	subq.l #1,%d7
	cmp.l #255,%d7
	jble .L128
	asr.l #1,%d5
.L128:
	move.l %d2,-(%sp)
	jbsr log2
	move.l %d0,%d3
	subq.l #2,%d3
	move.l #common_dir_buffer,%d0
	clr.w %d0
	swap %d0
	move.w %d0,10(%a4)
	move.l #common_dir_buffer,%d0
	and.l #65535,%d0
	move.w %d0,12(%a4)
	move.l %d2,%d0
	addq.l #7,%d0
	jbpl .L130
	moveq #14,%d0
	add.l %d2,%d0
.L130:
	asr.l #3,%d0
	move.l %d0,-(%sp)
	jbsr cpm_malloc
	move.l %d0,%d1
	clr.w %d1
	swap %d1
	move.w %d1,22(%a4)
	move.w %d0,24(%a4)
	move.b %d4,2(%a2)
	move.l %d6,%d0
	lsl.l %d4,%d0
	subq.b #1,%d0
	move.b %d0,3(%a2)
	move.w %d7,6(%a2)
	move.l %d6,%d0
	lsl.l %d3,%d0
	subq.w #1,%d0
	move.w %d0,8(%a2)
	move.b %d5,4(%a2)
	sub.l %a3,%d3
	move.l %d3,%d0
	addq.l #5,%d0
	move.l %d6,%d1
	lsl.l %d0,%d1
	addq.l #8,%sp
	tst.l %d1
	jbgt .L131
	moveq #1,%d1
.L131:
	moveq #0,%d0
	not.w %d0
	asr.l %d1,%d0
	not.w %d0
	move.w %d0,10(%a2)
	move.l %a4,%d0
	movm.l -36(%fp),#0x1cfc
	unlk %fp
	rts
	.size	make_dph, .-make_dph
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"Drive has not been partitioned; a single slice is assumed.\n"
.LC1:
	.string	"Device %c: has room for %d slice(s).\n"
.LC2:
	.string	"Created drive %c> on device %c:   (slice)\n"
.LC3:
	.string	"Created drive %c> on device %c:  (CP/M 0x52))\n"
	.text
	.align	2
	.globl	disk_system_init
	.type	disk_system_init, @function
disk_system_init:
	link.w %fp,#0
	movm.l #0x3e3c,-(%sp)
	moveq #0,%d0
	lea content+5,%a1
.L136:
	clr.b (%a1)
	lea lru,%a0
	move.b %d0,(%a0,%d0.l)
	addq.l #1,%d0
	addq.l #6,%a1
	moveq #12,%d1
	cmp.l %d0,%d1
	jbne .L136
	move.l 160.w,%d0
	and.l #-524288,%d0
	add.l 0.w,%d0
	move.l %d0,%d1
	clr.w %d1
	swap %d1
	move.w %d1,partition+80
	move.w %d0,partition+82
	moveq #2,%d3
	moveq #2,%d5
.L138:
	move.w %d5,%d6
	clr.l -(%sp)
	clr.l -(%sp)
	move.l %d5,-(%sp)
	jbsr get_into_memory
	lea (12,%sp),%sp
	tst.l %d0
	jblt .L166
	moveq #9,%d1
	lsl.l %d1,%d0
	move.l %d0,%a5
	add.l #buffer+446,%a5
	move.l %a5,%a3
	moveq #-1,%d2
	moveq #0,%d0
	lea (10,%a5),%a2
.L141:
	tst.b -6(%a2)
	jbeq .L142
	move.w -2(%a2),%d1
	move.w %d1,%d0
	swap %d0
	mov.w (%a2),%d0
	move.l %d0,-(%sp)
	lea bswap,%a4
	jbsr (%a4)
	addq.l #4,%sp
	cmp.l %d2,%d0
	jbls .L144
	moveq #1,%d0
	jbra .L142
.L144:
	move.w -2(%a2),%d1
	move.w %d1,%d0
	swap %d0
	mov.w (%a2),%d0
	move.l %d0,-(%sp)
	jbsr (%a4)
	move.l %d0,%d2
	moveq #1,%d0
	addq.l #4,%sp
.L142:
	lea (16,%a3),%a3
	lea (16,%a2),%a2
	lea (64,%a5),%a0
	cmp.l %a3,%a0
	jbne .L141
	tst.l %d0
	jbeq .L147
	pea 16640.w
	move.l %d2,-(%sp)
	jbsr __udivsi3
	addq.l #8,%sp
	move.l %d0,%a2
	moveq #8,%d0
	cmp.l %a2,%d0
	jbge .L149
	move.w #8,%a2
	jbra .L149
.L147:
	pea .LC0
	jbsr cprintf
	move.w #1,%a2
	addq.l #4,%sp
.L149:
	moveq #65,%d4
	add.l %d5,%d4
	move.l %a2,-(%sp)
	move.l %d4,-(%sp)
	pea .LC1
	jbsr cprintf
	sub.l %a4,%a4
	sub.l %a3,%a3
	lea (12,%sp),%sp
	jbra .L151
.L167:
	lea partition,%a0
	move.l %a3,%d1
	add.l #256,%d1
	move.l %d1,%d0
	clr.w %d0
	swap %d0
	move.w %d0,(%a0,%d2.l)
	move.w %d1,2(%a0,%d2.l)
	clr.w (%a1,%d2.l)
	move.w #16384,2(%a1,%d2.l)
	move.l %d2,%a0
	add.l #partition+14,%a0
	move.w #512,(%a0)
	move.l %d2,%a0
	add.l #partition+12,%a0
	move.w %d6,(%a0)
	move.w (%a1,%d2.l),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 2(%a1,%d2.l),%d0
	move.l %d0,%a0
	add.l %d0,%a0
	pea (%a0,%a0.l)
	jbsr make_dph
	lea partition+8,%a0
	move.l %d0,%d1
	clr.w %d1
	swap %d1
	move.w %d1,(%a0,%d2.l)
	move.w %d0,2(%a0,%d2.l)
	move.l %d4,-(%sp)
	move.b %d3,%d0
	add.b #65,%d0
	ext.w %d0
	move.w %d0,%a0
	move.l %a0,-(%sp)
	pea .LC2
	jbsr cprintf
	lea (16640,%a3),%a3
	lea (16,%sp),%sp
	jbra .L155
.L152:
	moveq #0,%d2
	move.w %d3,%d2
	lea partition+4,%a1
	lsl.l #4,%d2
	move.w (%a1,%d2.l),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 2(%a1,%d2.l),%d0
	tst.l %d0
	jbeq .L167
	addq.w #1,%d3
.L174:
	cmp.w #15,%d3
	jbls .L152
.L155:
	addq.l #1,%a4
.L151:
	cmp.l %a4,%a2
	jbgt .L174
	move.l %a5,%a3
.L158:
	cmp.b #82,4(%a3)
	jbne .L160
	jbra .L175
.L168:
	move.w 8(%a3),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 10(%a3),%d0
	move.l %d0,-(%sp)
	lea bswap,%a2
	jbsr (%a2)
	lea partition,%a0
	move.l %d0,%d1
	clr.w %d1
	swap %d1
	move.w %d1,(%a0,%d2.l)
	move.w %d0,2(%a0,%d2.l)
	move.w 12(%a3),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 14(%a3),%d0
	move.l %d0,-(%sp)
	jbsr (%a2)
	move.l %d0,%d1
	clr.w %d1
	swap %d1
	move.w %d1,(%a4,%d2.l)
	move.w %d0,2(%a4,%d2.l)
	move.l %d2,%a0
	add.l #partition+14,%a0
	move.w #512,(%a0)
	move.l %d2,%a0
	add.l #partition+12,%a0
	move.w %d6,(%a0)
	move.w (%a4,%d2.l),%a0
	move.w %a0,%d0
	swap %d0
	mov.w 2(%a4,%d2.l),%d0
	move.l %d0,%a0
	add.l %d0,%a0
	pea (%a0,%a0.l)
	jbsr make_dph
	lea partition+8,%a0
	move.l %d0,%d1
	clr.w %d1
	swap %d1
	move.w %d1,(%a0,%d2.l)
	move.w %d0,2(%a0,%d2.l)
	move.l %d4,-(%sp)
	move.b %d3,%d0
	add.b #65,%d0
	ext.w %d0
	move.w %d0,%a0
	move.l %a0,-(%sp)
	pea .LC3
	jbsr cprintf
	lea (24,%sp),%sp
	jbra .L160
.L161:
	moveq #0,%d2
	move.w %d3,%d2
	lea partition+4,%a4
	lsl.l #4,%d2
	move.w (%a4,%d2.l),%d1
	move.w %d1,%d0
	swap %d0
	mov.w 2(%a4,%d2.l),%d0
	tst.l %d0
	jbeq .L168
	addq.w #1,%d3
.L175:
	cmp.w #15,%d3
	jbls .L161
.L160:
	lea (48,%a5),%a0
	cmp.l %a3,%a0
	jbeq .L164
	lea (16,%a3),%a3
	jbra .L158
.L164:
	addq.l #1,%d5
	cmp.w #15,%d3
	jbls .L138
.L166:
	movm.l -36(%fp),#0x3c7c
	unlk %fp
	rts
	.size	disk_system_init, .-disk_system_init
	.globl	dpb_rom_400k
	.section	.rodata
	.align	2
	.type	dpb_rom_400k, @object
	.size	dpb_rom_400k, 16
dpb_rom_400k:
	.word	16
	.byte	4
	.byte	15
	.byte	1
	.byte	0
	.word	231
	.word	63
	.word	-32768
	.word	0
	.word	0
	.globl	dpb_flpy_144m
	.align	2
	.type	dpb_flpy_144m, @object
	.size	dpb_flpy_144m, 16
dpb_flpy_144m:
	.word	72
	.byte	4
	.byte	15
	.byte	0
	.byte	0
	.word	710
	.word	255
	.word	-4096
	.word	64
	.word	2
	.globl	dpb_flpy_720k
	.align	2
	.type	dpb_flpy_720k, @object
	.size	dpb_flpy_720k, 16
dpb_flpy_720k:
	.word	36
	.byte	4
	.byte	15
	.byte	0
	.byte	0
	.word	350
	.word	127
	.word	-16384
	.word	32
	.word	4
	.globl	dpb_RAM_1M
	.data
	.align	2
	.type	dpb_RAM_1M, @object
	.size	dpb_RAM_1M, 16
dpb_RAM_1M:
	.word	16
	.byte	4
	.byte	15
	.byte	0
	.byte	0
	.word	511
	.word	511
	.word	-256
	.word	0
	.word	0
	.globl	dph_rom_400k
	.align	2
	.type	dph_rom_400k, @object
	.size	dph_rom_400k, 26
dph_rom_400k:
	.long	0
	.word	0
	.word	0
	.word	0
	.long	common_dir_buffer
	.long	dpb_rom_400k
	.long	0
	.long	alv_rom_400k
	.globl	dph_RAM_1M
	.align	2
	.type	dph_RAM_1M, @object
	.size	dph_RAM_1M, 26
dph_RAM_1M:
	.long	0
	.word	0
	.word	0
	.word	0
	.long	common_dir_buffer
	.long	dpb_RAM_1M
	.long	0
	.long	alv_RAM_1M
	.globl	partition
	.align	2
	.type	partition, @object
	.size	partition, 256
partition:
	.long	0
	.long	0
	.long	0
	.word	0
	.word	512
	.long	0
	.long	0
	.long	0
	.word	0
	.word	512
	.long	0
	.long	0
	.long	0
	.word	0
	.word	512
	.long	0
	.long	0
	.long	0
	.word	0
	.word	512
	.long	0
	.long	0
	.long	0
	.word	0
	.word	512
	.long	-475136
	.long	3712
	.long	dph_rom_400k
	.word	101
	.word	128
	.long	0
	.long	0
	.long	0
	.word	0
	.word	512
	.long	0
	.long	0
	.long	0
	.word	0
	.word	512
	.long	0
	.long	0
	.long	0
	.word	0
	.word	512
	.long	0
	.long	0
	.long	0
	.word	0
	.word	512
	.long	0
	.long	0
	.long	0
	.word	0
	.word	512
	.long	0
	.long	0
	.long	0
	.word	0
	.word	512
	.long	0
	.long	0
	.long	0
	.word	0
	.word	512
	.long	0
	.long	0
	.long	0
	.word	0
	.word	512
	.long	0
	.long	0
	.long	0
	.word	0
	.word	512
	.long	0
	.long	0
	.long	0
	.word	0
	.word	512
	.globl	RAM_partition
	.align	2
	.type	RAM_partition, @object
	.size	RAM_partition, 16
RAM_partition:
	.long	1048576
	.long	8192
	.long	dph_RAM_1M
	.word	100
	.word	128
	.globl	current_drive
	.align	2
	.type	current_drive, @object
	.size	current_drive, 2
current_drive:
	.word	-1
	.comm	chainp,4,4
	.comm	errno,4,4
	.comm	hma,4,4
	.comm	common_dir_buffer,128,1
	.comm	lru,12,1
	.comm	content,72,2
	.comm	buffer,6144,1
	.comm	alv_rom_400k,29,1
	.comm	alv_RAM_1M,64,1
	.comm	current_sector,2,2
	.comm	current_track,2,2
	.comm	DMA_address,4,4
	.ident	"GCC: (GNU) 4.1.1"
