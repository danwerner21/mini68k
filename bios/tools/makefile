# makefile for utilities
#

#EXE = .exe
EXE =
#OBJ = .obj
OBJ = .o

CC = gcc
LD = ld


EHFILES = mytypes.h elf3.h cout.h


all:	elf2m68k$(EXE)


elf2m68k$(EXE):   elf2m68k.c $(EHFILES)
	$(CC) elf2m68k.c -o elf2m68k$(EXE)
    
