/* out2m68k.c 			*/
#define DEBUG 0
/**********************************************************************
	Copyright (C) 2012 John R. Coffman.
	Licensed for hobbyist use on the N8VEM mini-M68000 CPU board.
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

/****************************************************************************
*		Convert GCC cross-compiled A.OUT file
*		to Alcyon MC68000 absolute executable
*		suffixed '.68K'
****************************************************************************/



#include <stdio.h>
#include <ctype.h>
/****************************************************************************/
/*									    */
/*	The following code defines the organization of a "long" variable on */
/*	either the VAX (11) or 68000.  This allows us to use "getw" on the  */
/*	separate parts of the long and to recombine them for 32-bit 	    */
/*	arithmetic operations.						    */
/*									    */
/****************************************************************************/
#include "machine.h"
#include "mytypes.h"
#include "coff.h"
#include "cout.h"


#ifdef	UNIX
#include "../../bios/portab.h"
#endif

#ifdef	MSDOS					/****************************/
#include "portab.h"
#define	fopenb	fopen				/* Not in UNIX/MSDOS library	    */

typedef
union LONGHALVES {
	LONG	l;
	struct	{					/* low word first on MSDOS    */
		WORD	loword;				/*			    */
		WORD	hiword;				/*			    */
	} h;						/****************************/
} T_long;
#if 0
#define GETW(f) getw(f)
#define PUTW(w,f) putw((w),f)
#else
#define GETW(f) swap(getw(f))
#define PUTW(w,f) putw(swap(w),f)
#endif

#if 0
unsigned short swap(unsigned short w)
{
	return (w<<8)|(w>>8);
}
uint32 bswap(uint32 d)
{
	T_long x;
	unsigned short y;

	x.l = d;
	y = swap(x.h.loword);
	x.h.loword = swap(x.h.hiword);
	x.h.hiword = y;

	return x.l;
}
#endif
#endif

#ifdef	VAX					/****************************/
struct	{					/* low word first on VAX    */
	WORD	loword;				/*			    */
	WORD	hiword;				/*			    */
};						/****************************/
#endif

#ifdef	PDP11					/****************************/
struct	{					/* low word first on PDP11  */
	WORD	loword;				/*			    */
	WORD	hiword;				/*			    */
};						/****************************/
#endif

#ifdef	MC68000					/****************************/
struct	{					/*			    */
	WORD	hiword;				/* High word first on 68K   */
	WORD	loword;				/*			    */
};						/****************************/
#endif

#ifdef	UNIX					/****************************/
#define	fopenb	fopen				/* Not in UNIX library	    */
#endif						/****************************/


/****************************************************************************/
/*																									 */
/*			Procedure prototypes																 */
/*																									 */
/****************************************************************************/
VOID usage(VOID);
int main(int argc, char *argv[]);

/* Global variables */
char *infilename, *outfilename;
FILE *infile, *outfile;
char verbose, error;

T_aout_head aout_head;
T_couthd couthd;



/****************************************************************************
*		Convert GCC cross-compiled A.OUT file
*		to Alcyon MC68000 absolute executable
*		suffixed '.68K'
****************************************************************************/
VOID usage(VOID)
{
	printf("\nUsage:\n"
			 "    out2m68k [-v] infile.ext outfile.ext\n\n"
			 );
}

uint16 wswap(uint16 w)
{
	uint16 u = w<<8;
	return u | w>>8;
}

uint32 dswap(uint32 d)
{
	uint32 dd = (uint32)wswap((uint16)d) << 16;
	return dd | wswap((uint16)(d>>16));
}

int main(int argc, char *argv[])
{
	char *cp;
	int i;
	uint32 load;
#if DEBUG
	printf("byte=%d, word=%d, dword=%d\n", (int)sizeof(byte), (int)sizeof(word), (int)sizeof(dword) );
#endif
	for (i=1; i<argc; i++) {
		cp = argv[i];
		if (*cp == '-') switch (*++cp) {
			case 'v':	verbose = 1;  break;
			default:
				printf("??? '%s' is ignored.\n", --cp);
		}
		else if (!infilename) infilename = cp;
		else if (!outfilename) outfilename = cp;
		else {
			printf("Error:  \"%s\" not recognized.\n", cp);
			return 1;
		}
	} /* for */
	if (!infilename) {
		printf("No input file specified.\n");
		usage();
		return 1;
	}
	if (!outfilename) {
		printf("No output file specified.\n");
		usage();
		return 1;
	}
	infile = fopenb(infilename, "rb");
	if (!infile) {
		printf("No input file: %s\n", infilename);
		return 1;
	}
	outfile = fopenb(outfilename, "wb");
	if (!outfile) {
		printf("Cannot open output file: %s\n", outfilename);
		return 1;
	}

	fread(&aout_head, sizeof(aout_head), 1, infile);
	if (verbose) {
		printf("magic=%04hx nsects=%hd   entry point=%06lx\n", 
				aout_head.magic, wswap(aout_head.n_sects), (long)dswap(aout_head.entry_point));
		printf(".text at %06lx   length %04lx\n", (long)(load=dswap(aout_head.text_load_at)),
				(long)dswap(aout_head.sect_len[0]) );
		printf(".data at %06lx   length %04lx\n", (long)dswap(aout_head.data_load_at),
				(long)dswap(aout_head.sect_len[1]) );
		printf(".bss  at %06lx   length %04lx\n", (long)dswap(aout_head.section[2].load_at),
				(long)dswap(aout_head.sect_len[2]) );
	}
	if (	aout_head.text_load_at != aout_head.section[0].load_at  ||
			aout_head.data_load_at != aout_head.section[1].load_at  ||
			aout_head.sect_len[0] != aout_head.section[0].length	||
			aout_head.sect_len[1] != aout_head.section[1].length	||
			aout_head.sect_len[2] != aout_head.section[2].length
		) {
		printf("ERROR: Inconsistent header information.  Panic!\n");
		fcloseall();
		return 1;
	}
	if (load != 0x1000) {
		printf("WARNING: Files usually load at 0x1000, not at 0x%04lx.\n", (long)load);
	}
	couthd.ch_magic = wswap(MAGIC);
	couthd.ch_tsize = aout_head.section[0].length;
	couthd.ch_dsize = aout_head.section[1].length;
	couthd.ch_bsize = aout_head.section[2].length;
	couthd.ch_ssize = 0;		/* symbol table size */
	couthd.ch_stksize = 0;	/* stack size */
	couthd.ch_entry = aout_head.entry_point;
	couthd.ch_rlbflg = (short)0xFFFF;	/* relocation bits suppress */

	fwrite(&couthd, sizeof(couthd), 1, outfile);
	fseek(infile, dswap(aout_head.section[0].file_pos) , SEEK_SET);
	i = fgetc(infile);
	while (i != EOF) {
		fputc(i, outfile);
		i = fgetc(infile);
	}

	fcloseall();
	return 0;
}


