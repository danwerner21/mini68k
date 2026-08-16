REM  cpm.bat
REM	Create a new CPM.OUT file
REM
@echo on
if "%shell" != "4dos" goto ERR

echo .ascii "%_date at %_time" > stamp.s
set R=0
if "%1%" == "RETAIL" set R=1
if "%1%" == "retail" set R=1
delay 1

nmake RETAIL=%R alles

:COPY
copy /b *.out F:\
copy /b *.sys F:\
@echo Done.
@goto EXIT
:ERR
@echo Must use 4DOS.COM to do the 'make'
@echo Exit.
:EXIT
@set R
