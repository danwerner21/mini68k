/*****************************************************************************
*
*                   C P / M   C   H E A D E R   F I L E
*                   -----------------------------------
*       Copyright 1982 by Digital Research Inc.  All rights reserved.
*
*       This is an include file for assisting the user to write portable
*       programs for C.
*
*****************************************************************************/
#ifndef _BDOSINC_H
#define _BDOSINC_H 1

#define ALCYON 0           /* NOT using Alcyon compiler   */
/* instead, we use AshWare GCC 2.91 on Windows 2000   */
/* Now we are using GCC 4.1.1 on Linux */
#define GCC 1

/*
 *      Standard type definitions
 */
                                                /***************************/
#define BYTE    char                            /* Signed byte             */
#define BOOLEAN char                            /* 2 valued (true/false)   */
#define WORD    short                           /* Signed word (16 bits)   */
#define UWORD   unsigned short                  /* unsigned word           */
#define LONG    long                            /* signed long (32 bits)   */
#define ULONG   unsigned long                   /* Unsigned long           */
#define REG     register                        /* register variable       */
#define LOCAL   auto                            /* Local var on 68000      */
#define EXTERN  extern                          /* External variable       */
#define MLOCAL  static                          /* Local to module         */
#define GLOBAL  /**/                            /* Global variable         */
#ifndef VOID
#define VOID    void /**/                       /* Void function return    */
#endif
																/***************************/
#if ALCYON
#define UBYTE   char
#else
#define UBYTE   unsigned char                   /* Unsigned byte           */
#endif
          /* Unsigned byte to word cast   */
#define UBWORD(a) ((UWORD)(a) & 0xff)



/****************************************************************************/
/*      Miscellaneous Definitions:                                          */
/****************************************************************************/
#define FAILURE (-1)                    /*      Function failure return val */
#define SUCCESS (0)                     /*      Function success return val */
#define YES     1                       /*      "TRUE"                      */
#define NO      0                       /*      "FALSE"                     */
#define FOREVER for(;;)                 /*      Infinite loop declaration   */
#ifdef NULL
#undef NULL
#endif
#define NULL    (void*)0               /*      Null pointer value          */
#ifndef EOF
#define EOF     (-1)                    /*      EOF Value                   */
#define TRUE    (1)                     /*      Function TRUE  value        */
#define FALSE   (0)                     /*      Function FALSE value        */
#endif

/****************************************************************************/
/*                                                                          */
/*                              M A C R O S                                 */
/*                              -----------                                 */
/*                                                                          */
/*      Define some stuff as macros ....                                    */
/*                                                                          */
/****************************************************************************/

#define abs(x)  ((x) < 0 ? -(x) : (x))  /*      Absolute value function     */

#define max(x,y)   (((x) > (y)) ? (x) :  (y))   /* Max function             */
#define min(x,y)   (((x) < (y)) ? (x) :  (y))   /* Min function             */

/*************************** end of stdio.h *********************************/

UWORD udiv(ULONG dividend, UWORD divisor, UWORD *remainder);

#endif
/* _BDOSINC_H */

