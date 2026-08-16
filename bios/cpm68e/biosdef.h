/********************************************************
*                                                       *
*       BIOS definitions for CP/M-68K                   *
*                                                       *
*       Copyright (c) 1982 Digital Research, Inc.       *
*                                                       *
*       This include file simply defines the BIOS calls *
*                                                       *
********************************************************/
#ifndef _BIOSDEF_H
#define _BIOSDEF_H 1


EXTERN UBYTE    _bios1();        /* used for character I/O functions */
/*EXTERN VOID     _bios2(); */       /* parm1 is word, no return value   */
EXTERN UWORD	_bios2();	 /* actually there is a return value */
EXTERN VOID     _bios3();        /* used for set dma only            */
                                 /* parm1 is a pointer, no return    */
EXTERN UBYTE    *_bios4();       /* seldsk only, parm1 and parm2 are */
                                /*   words, returns a pointer to dph */
EXTERN UWORD    _bios5();        /* for sectran and set exception    */
EXTERN BYTE     *_bios6();       /* for get memory segment table     */


#define bwboot()        _bios1(1)        /* warm boot            */      
#define bconstat()      _bios1(2)        /* console status       */
#define bconin()        _bios1(3)        /* console input        */
#define bconout(parm)   _bios2(4,parm)   /* console output parm  */
#define blstout(parm)   _bios2(5,parm)   /* list device output   */
#define bpun(parm)      _bios2(6,parm)   /* punch char output    */
#define brdr()          _bios1(7)        /* reader input         */
#define bhome()         _bios1(8)        /* recalibrate drive    */
#define bseldsk(parm1,parm2) _bios4(9,parm1,parm2)
                                        /* select disk and return info */
#define bsettrk(parm)   _bios2(10,parm)  /* set track on disk    */
#define bsetsec(parm)   _bios2(11,parm)  /* set sector for disk  */
#define bsetdma(parm)   _bios3(12,parm)  /* set dma address      */
#define bread()         _bios1(13)       /* read sector from disk */
#define bwrite(parm)    _bios2(14,parm)  /* write sector to disk */
#define blistst()       _bios1(15)       /* list device status   */
#define bsectrn(parm1,parm2) _bios5(16,parm1,parm2)
                                        /* sector translate     */
#define bgetseg()       _bios6(18)        /* get memory segment tbl */
#define bgetiob()       _bios1(19)       /* get I/O byte         */
#define bsetiob(parm)   _bios2(20,parm)  /* set I/O byte         */
#define bflush()        _bios1(21)       /* flush buffers        */
#define bsetvec(parm1,parm2) _bios5(22,parm1,parm2)
                                        /* set exception vector */
#endif /* _BIOSDEF_H */

