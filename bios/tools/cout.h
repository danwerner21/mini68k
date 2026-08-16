/* cout.h */

typedef
struct hdr {
        word ch_magic;         /*c.out magic number 060016 = $600E*/
        dword ch_tsize;          /*text size*/
        dword ch_dsize;          /*data size*/
        dword ch_bsize;          /*bss size*/
        dword ch_ssize;          /*symbol table size*/
        dword ch_stksize;        /*stack size*/
        dword ch_entry;          /*entry point*/
        word ch_rlbflg;        /*relocation bits suppressed flag*/
} T_couthd;

#define MAGIC   0x601a  /* bra .+26 instruction */

/* end cout.h */

