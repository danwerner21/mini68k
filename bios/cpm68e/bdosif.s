#****************************************************************
#                                                               *
#       CP/M-68K Basic Disk Operating System interface module   *
#               For "C" version of CP/M-68K                     *
#                                                               *
#       Copyright (c) 1982 Digital Research, Inc.               *
#                                                               *
#       Version 0.2 -- September 22, 1982                       *
#                                                               *
#****************************************************************

#  Declare Public Routines

        .globl  _bios1          /* 6 BIOS entry points from BDOS */
        .globl  _bios2
        .globl  _bios3
        .globl  _bios4
        .globl  _bios5
        .globl  _bios6
        .globl  _trap2hnd      /* trap #2 handler */
        .globl  swap           /* byte swapper */
	.globl	bswap	       /* long word byte swapper */	
        .globl  udiv           /* unsigned divide routine */

# Declare external routines
        .globl  __bdos          /* BDOS entry point in bdosmain */

# The following external references were put in just to make sure that all
#       the BDOS modules were referenced, so we could put them in a library
        .globl  _constat        /* references conbdos.o */
        .globl  _dirscan        /* references dskutil.o */
        .globl  _create         /* references fileio.o */
        .globl  _bdosrw         /* references bdosrw.o */

        biosf   = 50
        setsupf = 62

_trap2hnd:
#
#       first save the registers and
#       check for functions handled by assembly language routines
#
        cmpi.w  #setsupf,%d0
        beq     setsup
        movem.l %d1-%d7/%a0-%a6,-(%sp)
        cmpi.w  #biosf,%d0
        beq     bioscall
#
#       function number is passed in D0
#       byte and word pararmeters are passed in D1.W
#       address parameters are passed in D1.L
#
        move.l  %d1,-(%sp)
#jrc      move.w  %d1,-(%sp)
        move.l  %d1,-(%sp)
#jrc      move.w  %d0,-(%sp)
        move.l  %d0,-(%sp)
        jsr     __bdos                  /* call BDOS */
#
#       now restore the regs
#
        ext.l   %d0
###	addq.l   #8,%sp                   /* fix up the stack */
	lea.l	12(%sp),%sp		/* fix up the stack */
bdone:
        movem.l (%sp)+,%a0-%a6/%d1-%d7
        rte                             /* return from trap call */

#
# direct BIOS call function
#
bioscall:
        move.l  %d1,%a0           /* get address of CPB */
###        move.w  (%a0)+,%d0
        move.l  (%a0)+,%d0
        movem.l (%a0)+,%d1-%d2
        trap    #3
        bra     bdone

#
# Set supervisor mode procedure
#
setsup:
        ori.w   #0x2000,(%sp)     /* turn on supervisor bit in SR in the stack */
        rte

#
# BIOS Interface Routines
#
#
#  Note - there are 6 BIOS entry points from the BDOS, labelled BIOS1 -
#    BIOS6, depending on the parameters passed.
#
#  Alcyon C did not save D2, so all the old offsets below are off
#  GCC requires D2 to be saved
#
.if 0
_bios5:
# For BIOS functions sectran and set exception vector
# Has function number and 2 parameters, a word followed by a long word
###	move.l  8(%sp),%d2        /* get 2nd parameter (long word) */
	move.l  12(%sp),%d2        /* get 2nd parameter (long word) */
        bra     _bios2          /* join common routine */

_bios4:
# For BIOS function seldsk
# Has function number followed by 2 word parameters
###	move.w  8(%sp),%d2        /* get 2nd parameter (word) */
	move.l  12(%sp),%d2        /* get 2nd parameter (word) */
        bra     _bios2          /* join common routine */

_bios3:
# For BIOS function set dma
# Has function number followed by 1 long parameter
###	move.l  6(%sp),%d1        /* get long word parameter */
	move.l  8(%sp),%d1        /* get long word parameter */
        bra     _bios1          /* join common routine */

_bios2:
# For all BIOS functions with a word parameter
# Word parameter follows function number
###	move.w  6(%sp),%d1        /* get 1st parameter (word) */
	move.l  8(%sp),%d1        /* get 1st parameter (word) */

_bios6:
_bios1:
# For all BIOS functions that have no parameter other than function number
###     move.w  4(%sp),%d0        /* get function number */
        move.l  4(%sp),%d0        /* get word function number */
.else
_bios1:
_bios2:
_bios3:
_bios4:
_bios5:
_bios6:
	move.l	%d2,-(%sp)		/**** save D2  */
	move.l	16(%sp),%d2	  /* D2 parameter word or long */
	move.l	12(%sp),%d1	  /* D1 parameter word or long */
        move.l  8(%sp),%d0        /* get word function number */
.endif
        movem.l %d3-%d7/%a2-%a6,-(%sp)
#                               /* save C register variables */
        trap    #3              /* do BIOS call */
#                               /* returns value in %d0 */
        movem.l (%sp)+,%d3-%d7/%a2-%a6

	move.l	(%sp)+,%d2	/***** restore D2  */
        rts

#
#  Utility Subroutines
#

swap:
# Swap bytes of a word, return swapped value in %d0
	move.w	6(%sp),%d0		/* pick up word arg */
	rol.w	#8,%d0			/* swap bytes */
        rts

bswap:
# Swap all the bytes of a long, return result in %d0
	move.l	4(%sp),%d0
	rol.w	#8,%d0			/* swap bytes */
	swap	%d0			/* swap hi & lo words */
	rol.w	#8,%d0			/* swap bytes */
	rts

udiv:
# Unsigned divide routine
# returns unsigned quotient in %D0.W

#   UWORD udiv( dividend, divisor, remp )
#
#   REG LONG dividend;
#   UWORD    divisor;
#   UWORD    *remp              /* pointer to remainder (returned) */ */

        move.l  4(%sp), %d0       /* get dividend */
###      divu    8(%sp), %d0       /* do the divide */
        divu    10(%sp), %d0       /* do the divide */
###      movea.l 10(%sp),%a0
        movea.l 12(%sp),%a0
        swap    %d0
        move.w  %d0, (%a0)        /* store remainder */
        clr.w   %d0
        swap    %d0              /* word quotient in %d0 */
        rts

        .end

