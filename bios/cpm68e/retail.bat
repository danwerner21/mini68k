REM retail.bat
REM
@echo on
if "%shell" != "4dos" goto ERR

echo .ascii "%_date at %_time" > stamp.s
delay 1

nmake RETAIL=1 alles

:COPY
copy /b *.out F:\
copy /b *.sys F:\
@echo Done.
@goto EXIT
:ERR
@echo Must use 4DOS.COM to do the 'make'
@echo Exit.
:EXIT



