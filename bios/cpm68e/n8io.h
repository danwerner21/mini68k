/* n8io.h

	Definitions for N8VEM mini-M68k CPU I/O operations

	includes:
		Disk Parameter block for 80k ROMdisk
*/
/**********************************************************************
	Codes beginning "N8*.*" are affected by this notice.
	Other codes are copyrighted by Digital Research Inc.
***********************************************************************
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
#include "bdosinc.h"
#include "bdosdef.h"

#define nelem(x)	(sizeof(x)/sizeof(*x))
#undef NULL
#define NULL (void*)0

#define HIGH_MEMORY_BASE 0x100000		/* start of high memory */
#define MAXPARTITION	nelem(partition)	/* same as CCP   NO_OF_DRIVES */
#define SECTOR_SIZE 512						/* LBA sector size */
#define MAXBUFFERS 12						/* maximum number of cache buffers */

/* N8VEM bios definitions:				*/
typedef
struct PARTITION {
	ULONG		offset;			/* base of partition on a drive */
	ULONG		length;			/* number of h/w sectors on partition */
	struct dph *dphp;			/* pointer to CP/M dph, or NULL */
	WORD		drive;			/* BIOS8 drive #; 100 means ram/rom disk */
	WORD		sec_size;		/* sector size; h/w = 512; ram/rom = 128 */
} T_partition;

typedef
struct PT_ENTRY {
	UBYTE	active;				/* active flag if 0x80 */
	UBYTE	head_begin;			/* Geometric head number */
	UBYTE	sector_begin;		/* Geo. sector # & 2 hi-bits of cylinder */
	UBYTE	cylinder_begin;	/* Geo. low 8 bits of cylinder number */
	UBYTE	p_type;				/* partition type FAT12, FAT16, CPM==0x52 */
	UBYTE	head_end;			/* ending head number */
	UBYTE	sector_end;			/* ending sector number */
	UBYTE	cylinder_end;		/* ending cylinder number */
	ULONG lba_begin;			/* LBA beginning; needs BSWAP!! */
	ULONG lba_length;			/* LBA number of sectors; needs BSWAP!! */
} T_pt_entry;

typedef
struct CONTENT {
	ULONG	lba_address;		/* LBA address of h/w sector in buffer */
	UBYTE	drive;				/* h/w drive number of lba_address */
	UBYTE	flags;				/* 1,2,4,8 mark offsets that are dirty; i.e.,
										need to be written out;
										0x10 marks the buffer in use */
} T_content;

typedef
UBYTE T_buffer[SECTOR_SIZE];


#define DIRTY_0		0x01
#define DIRTY_ANY		0x0F
#define IN_USE			0x10

#define WR_NORMAL		0
#define WR_DIRECTORY 1
#define WR_FIRST		2

long _get_hma(void);			/* in n8bios3.s */
EXTERN int _read_sector(int drive, int LBA, UBYTE* buffer);
EXTERN int _write_sector(int drive, int LBA, UBYTE* buffer);
EXTERN int _disk_reset(int drive);
EXTERN ULONG _halloc(ULONG);
EXTERN ULONG bswap(ULONG);			/* longword byte swapper */
EXTERN UWORD swap(UWORD);			/* word byte swapper */

/*  end n8io.h  */

#if 0
/* from 'bdosdef.h'   Just here for reference */


/* Declaration of disk parameter tables         */
struct dpb                      /* disk parameter table         */
{
        UWORD   spt;            /* sectors per track            */
        UBYTE   bsh;            /* block shift factor           */
        UBYTE   blm;            /* block mask                   */
        UBYTE   exm;            /* extent mask                  */
        UBYTE   dpbdum;         /* dummy byte for fill          */
        UWORD   dsm;            /* max disk size in blocks      */
        UWORD   drm;            /* max directory entries        */
        UWORD   dir_al;         /* initial allocation for dir   */
        UWORD   cks;            /* number dir sectors to checksum */
        UWORD   trk_off;        /* track offset                 */
};

struct  dph                     /* disk parameter header        */
{
        UBYTE   *xlt;           /* pointer to sector translate table    */
        UWORD   hiwater;        /* high water mark for this disk        */
        UWORD   dum1;           /* dummy (unused)                       */
        UWORD   dum2;
        UBYTE   *dbufp;         /* pointer to 128 byte directory buffer */
        struct dpb *dpbp;       /* pointer to disk parameter block      */
        UBYTE   *csv;           /* pointer to check vector              */
        UBYTE   *alv;           /* pointer to allocation vector         */
};


#endif

