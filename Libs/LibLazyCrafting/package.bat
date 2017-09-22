:: Package your ESO add-on ready for distribution.
:: Version 1.3 Sat, 14 Nov 2015 22:36:23 +0000
@echo off
setlocal enableextensions enabledelayedexpansion

set zip=%ProgramFiles%\7-Zip\7z.exe
if not exist "%zip%" goto :zipnotfound

for %%* in (.) do set name=%%~nx*

if not exist %name%.txt (
  echo * Please enter the name of your add-on:
  set /P name=^>
)

for /F "tokens=3" %%i in ('findstr /C:"## Version:" %name%.txt') do set version=%%i

set archive=%name%-%version%.zip

echo * Packaging %archive%...

md .package\%name%

set files=%name%.txt

for /F %%i in ('findstr /B /R "[^#;]" %name%.txt') do (
  set file=%%~nxi
  set files=!files! !file:$^(language^)=*!
)

if exist package.manifest (
  for /F "tokens=*" %%i in (package.manifest) do (
    set files=!files! %%~nxi
  )
)

robocopy . .package\%name% %files% /S /XD .* /NJH /NJS /NFL /NDL > nul

cd .package
"%zip%" a -tzip -bd ..\%archive% %name% > nul
cd ..
rd /S /Q .package

echo * Done^^!
echo.

pause
exit /B

:zipnotfound
echo 7-Zip cannot be found, get it free at http://www.7-zip.org
pause
exit /B
