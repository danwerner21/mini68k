#
#  Makefile for KISS/Mini M68k
#	CPM68 -- CCP, BDOS
#
#	Uses cross development tools GCC 4.1.1
#
#
# The 'RETAIL' version of the software excludes the debugging information
# The non-RETAIL verson has all the debugging information included
#
ifndef RETAIL
RETAIL=0
endif



# make ELF output with GCC 4.1.1 cross-compiler
TOOLS = ../../tools
CROSSDIR = /usr/cross/m68k-elf
BIN = $(CROSSDIR)/bin
#
CC = $(BIN)/m68k-elf-gcc
COPT = -Os -ansi -malign-int -nostdlib -m68000 -Wall -Werror -DRETAIL=$(RETAIL)
#COPT = -Os -malign-int -nostdlib -m68000 -Wall -DRETAIL=$(RETAIL) -fno-builtin
AS = $(BIN)/m68k-elf-as
AOPT = --defsym M68000=68000 -m68000 -alhms --defsym RETAIL=$(RETAIL)
AOPT10 = --defsym M68000=68010 -m68010 -alhms --defsym RETAIL=$(RETAIL)
AOPT20 = --defsym M68000=68020 -m68020 -alhms --defsym RETAIL=$(RETAIL)
LD = $(BIN)/m68k-elf-ld
LOPT = --entry=cpm -Ttext 0xF0000 # -Tdata 0xF5c00
LIB = $(BIN)/m68k-elf-ar
LIBS = -L$(CROSSDIR)/m68k-elf/lib/m68000 -L$(CROSSDIR)/lib/gcc/m68k-elf/4.1.1/m68000 -lc -lgcc
O2M = ..\tools\OUT2M68K




.SUFFIXES:   .c .s .o .out .sys


.c.s:
	$(CC) -S $(COPT) $*.c
.s.o:
	$(AS) $(AOPT) -a=$*.lst -o $*.o $*.s
.c.o:
	$(AS) $(AOPT) -a=$*.lst -o $*.o $*.s
#	$(CC) -c $(COPT) $*.c

.out.sys:
	$(O2M) -v $*.out $*.sys


HFILES = bdosdef.h bdosinc.h biosdef.h pktio.h n8io.h cprintf.h
SFILES = bdosmain.s bdosmisc.s bdosrw.s conbdos.s dskutil.s fileio.s \
	 iosys.s ccp.s n8io.s cprintf.s
OFILES1 = ccpif.o ccpbdos.o ccpload.o ccp.o bdosif.o
OFILES2 = conbdos.o bdosmisc.o dskutil.o fileio.o bdosrw.o bdosmain.o
OFILES3 = iosys.o pgmld.o except.o except10.o except20.o filetyps.o
OFILES4 = stack.o stack20.o n8bios3.o n8io.o n8iox.o cprintf.o
OFILES = $(OFILES1) $(OFILES2) $(OFILES3) $(OFILES4)


LIBFILES =
# cprintf.o bioscall.o crt0.o




all:	cpm.sys kcpm.sys jcpm.sys

out:	cpm.out jcpm.out kcpm.out


gccver:
	$(CC) -v




cpm.sys:	ccpif.o cpmlib.a 0cpm68k.o
	$(LD) -T cpm.lnk -s -Map cpm.map -o cpm.sys  0cpm68k.o \
		ccpif.o cpmlib.a $(LIBS)

jcpm.sys:	ccpif.o except10.o cpmlib.a 0cpm68k.o
	$(LD) -T cpm.lnk -s -Map jcpm.map -o jcpm.sys  0cpm68k.o \
		ccpif.o except10.o cpmlib.a $(LIBS)

kcpm.sys:	ccpif.o except20.o cpmlib.a 0cpm68k.o
	$(LD) -T cpm.lnk -s -Map kcpm.map -o kcpm.sys  0cpm68k.o \
		ccpif.o except20.o cpmlib.a $(LIBS)




cpmlib.a:	$(OFILES) makefile
	$(LIB) -r $*.a $(OFILES)

cpm.out:	ccpif.o cpmlib.a
	$(LD) $(LOPT) -s -Map $*.map -o $*.out ccpif.o cpmlib.a $(LIBS)

kcpm.out:	cpmlib.a except20.o ccpif20.o
	$(LD) $(LOPT) -s -Map $*.map -o $*.out ccpif20.o except20.o stack20.o cpmlib.a $(LIBS)

jcpm.out:	cpmlib.a except10.o
	$(LD) $(LOPT) -s -Map $*.map -o $*.out ccpif.o except10.o cpmlib.a $(LIBS)

except.o:	exceptn.s
	$(AS) $(AOPT) -a=$*.lst -o $*.o exceptn.s

except10.o:	exceptn.s
	$(AS) $(AOPT10) -a=$*.lst -o $*.o exceptn.s

except20.o:	exceptn.s
	$(AS) $(AOPT20) -a=$*.lst -o $*.o exceptn.s

stack20.o:	stack.s
	$(AS) $(AOPT20) -a=$*.lst -o $*.o stack.s

#ccpif20.o:	ccpif.s
#	$(AS) $(AOPT20) -a=$*.lst -o $*.o ccpif.s

stamp.s:
	echo " .ascii \""`date`"\"" >stamp.s

sweep:
	rm -f $(SFILES)

tidy:
	rm -f *.lst *.LST
	rm -f *.map

clean:	tidy
	rm -f *.o
	rm -f $(SFILES)
	rm -f *.a
	rm -f *.out

spotless:	clean
	rm -f stamp.s




## Dependencies
bdosmain.o:	bdosmain.s
bdosmain.s:	bdosmain.c $(HFILES)
bdosmisc.o:	bdosmisc.s
bdosmisc.s:	bdosmisc.c $(HFILES)
bdosrw.o:	bdosrw.s
bdosrw.s:	bdosrw.c $(HFILES)
conbdos.o:	conbdos.s
conbdos.s:	conbdos.c $(HFILES)
dskutil.o:	dskutil.s
dskutil.s:	dskutil.c $(HFILES)
fileio.o:	fileio.s
fileio.s:	fileio.c $(HFILES)
iosys.o:	iosys.s
iosys.s:	iosys.c $(HFILES)
ccp.o:		ccp.s
ccp.s:		ccp.c ccpdef.h
cprintf.o:		cprintf.s
cprintf.s:		cprintf.c $(HFILES)

bdosif.o:	bdosif.s
pgmld.o:	pgmld.s
ccpbdos.o:	ccpbdos.s
ccpif.o:	ccpif.s stamp.s
ccpload.o:	ccpload.s
filetyps.o:	filetyps.s
stack.o:	stack.s

#  Added BIOS codes for the N8VEM mini-M68000 CPU board:
n8bios3.o:	n8bios3.s
n8io.o:		n8io.s
n8io.s:		n8io.c $(HFILES)
n8iox.o:	n8iox.s biostrap.s
0cpm68k.o:	0cpm68k.s
#muldiv.o:   muldiv.s
