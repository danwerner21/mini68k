echo off
dir *.zip > %tmp%\foo
sort < %tmp%\foo
if "%1"=="" goto err2
if exist %1.zip goto err1
copy /b C:\cpmtools\diskdefs
pkzip -P %1.zip copying. notice. diskdefs. make*.*
pkzip -Pa %1.zip *.hex *.b* *.a* *.s* *.c* *.h* *.doc *.txt *.out
REM  pkzip -Pa %1.zip ..\lib\libc.a ..\lib\libgcc.a
echo .
copy %1.zip D:\M68K
echo .
echo Place backup diskette in Drive A:
pause
chkdsk A:
dir %1.zip
pause
xcopy %1.zip A: /v
dir A:
goto end
:err1
echo %1.zip ALREADY EXISTS
goto end
:err2
echo .
echo Usage:  SAVE  filename
:end
