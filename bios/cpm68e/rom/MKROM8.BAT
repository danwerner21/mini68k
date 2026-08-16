REM
REM   make an 80Kb CPM ROMdisk image
REM
echo on
if "%1"=="-l" goto done

@echo Making an 80k ROMdisk image
hex2bin -R 2k -p 0xE5 -o DIR.BIN
hex2bin -R 78k -p 0xFF -o DATA.BIN
copy/b dir.bin+data.bin rom80.bin

out2m68k -v c:\m68k\cpm68k\2cpm\cpm.out cpm.sys
@echo placing CP/M-68 within the ROM
cpmcp -f m68k80 rom80.bin cpm.sys 0:
REM cpmcp -f m68k80 rom80.bin D:/m68k/68k/disk1/reloc.rel 0:reloc.rel
cpmcp -f m68k80 rom80.bin disk/init.68k 0:
cpmcp -f m68k80 rom80.bin disk/pip.68k 0:
cpmcp -f m68k80 rom80.bin disk/reloc.68k 0:reloc.68k
cpmcp -f m68k80 rom80.bin disk/stat.68k 0:
cpmcp -f m68k80 rom80.bin disk/dump.68k 0:

goto done

:done
cpmls -f m68k80 -D rom80.bin
@echo Done.
