/* elf2m68k.c -- convert an ELF/M68k file to a CP/M-68 executable *.68K */
/*
	Copyright (C) 2016 John R Coffman.
	Licensed for hobbyist use only.
***********************************************************************

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    in the file COPYING in the distribution directory along with this
    program.  If not, see <http://www.gnu.org/licenses/>.

**********************************************************************/
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "mytypes.h"
#include "elf3.h"
#include "cout.h"


#define LTH 255

char *inname, *outname;
FILE *infile, *outfile;
Elf32_Ehdr hdr;
#define Ehdr_fmt "bbbbbbbbbbbbbbbbwwlllllwwwwww"


union {
    word eword;
    byte ebs[2];
} endian;

#define ENDIAN endian.ebs[0]    /* will be 0 if no swap needed, 3 if swap is needed */

word wswap(void *p)
{
    union {
        word w;
        byte b[2];
    } work;
    byte tmp;
    
    work.w = *(word*)p;
    tmp = work.b[0];
    work.b[0] = work.b[1];
    work.b[1] = tmp;
    *(word*)p = work.w;
    
    return work.w;
}


dword lswap(void *p)
{
    union {
        dword d;
        byte b[4];
    } work;
    byte tmp;
    
    work.d = *(dword*)p;
    tmp = work.b[0];
    work.b[0] = work.b[3];
    work.b[3] = tmp;
    tmp = work.b[1];
    work.b[1] = work.b[2];
    work.b[2] = tmp;
    *(dword*)p = work.d;
    
    return work.d;
}


void reformat(void *p, const char *fmt)
{
    if (ENDIAN) {
        while (*fmt) {
            if (*fmt == 'l') {
                lswap(p);
                p += sizeof(dword);
            }
            else if (*fmt == 'w') {
                wswap(p);
                p += sizeof(word);
            }
            else if (*fmt == 'b') {
                p += sizeof(byte);
            }
            fmt++;
        }
    }
}



int main(int argc, char* argv[])
{
    int i;
    int verbose = 1;
    int args = 0;
    size_t io;
    
    endian.eword = 0x0201;

/* scan the arguments */    
    for (i=1; i<argc; i++) { 
        printf("%s\n", argv[i]);
        if (*argv[i] == '-')
            switch(*++argv[i]) {
                case 'v':
                    verbose ^= 1;
                    break;
                default:
                    printf("Unrecognized switch: \"-%c\"\n", *argv[i]);
            }
        else if (args == 0) {
            inname = argv[i];
            args++;
        }
        else if (args == 1) {
            outname = argv[i];
            args++;
        }
        else { printf("Too many arguments: \"%s\"\n", argv[i]); return 1; }
    }
    
/* open the input and output files */
    infile = fopen(inname, "r");
    if (infile == NULL) {
        printf("Cannot open input file: \"%s\"\n", inname);
        return 1;
    }
    outfile = fopen(outname, "w");
    if (outfile == NULL) {
        printf("Cannot open output file: \"%s\"\n", outname);
        return 1;
    }
   
/* read and verify the ELF signature */
    io = fread(&hdr, 1, sizeof(hdr), infile);
    if (io != sizeof(hdr))
        {printf("Input read error.\n"); return 1;}
    if (strncmp(hdr.e_ident, "\177ELF", 4) != 0)
        {printf("Input is not an ELF file.\n"); return 1;}
    endian.ebs[0] ^= hdr.e_ident[EI_DATA];
    if (verbose) {
        printf("File is ELF-%s %s-endian\n",
            hdr.e_ident[EI_CLASS] == ELFCLASS32 ? "32" :
            hdr.e_ident[EI_CLASS] == ELFCLASS64 ? "64" : "??",
                hdr.e_ident[EI_DATA] == 1 ? "Little" :
                hdr.e_ident[EI_DATA] == 2 ? "Big" : "unknown"
        );
        printf("Byte swapping will%sbe needed on this host.\n", ENDIAN ? " " : " not " );
    } 
    if (hdr.e_ident[EI_CLASS] != ELFCLASS32)
        {printf("Input is not for a 32-bit processor.\n"); return 1;}

    reformat(&hdr, Ehdr_fmt);
    
    
    
    
    return 0;
}
/* end  elf2m68k.c */

