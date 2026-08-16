REM
REM   make a 400Kb CPM ROMdisk image
REM
echo on
if "%1"=="-l" goto done

@echo Making an 400k ROMdisk image
hex2bin -R 2k -p 0xE5 -o DIR.BIN
hex2bin -R 398k -p 0xFF -o DATA.BIN
hex2bin -R 64k -p 0xFF -o IOLOSS.BIN
copy/b dir.bin+data.bin+ioloss.bin rom400.bin


out2m68k -v c:\m68k\cpm68k\2cpm\cpm.out cpm.sys
@echo placing CP/M-68 within the ROM
cpmcp -f m68k400 rom400.bin cpm.sys 0:
cpmcp -f m68k400 rom400.bin basic/*.* 0:

cpmcp -f m68k400 rom400.bin C:/m68k/cpm68k/2cpm/cpm.map 0:cpm.map
goto done

:done
cpmls -f m68k400 -D rom400.bin
@echo Done.
