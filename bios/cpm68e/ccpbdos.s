#************************************************************************
#									*
#			INTERFACE MODULE BETWEEN			*
#			    CCP and THE BDOS				*
#									*
#									*
#	    THIS IS THE DUAL PROCESSOR,ROMABLE CP/M-68K SYSTEM		*
#	    ==================================================		*
#									*
#       (C) Copyright Digital Research 1983 all rights reserved    	*
#									*
#************************************************************************

.globl  bdos
bdos:
.if 0
	        move.w 4(%sp),%d0
		move.l 6(%sp),%d1
.else
		move.w	6(%sp),%d0
		move.l	8(%sp),%d1
.endif
		trap #2
		rts

		.end

