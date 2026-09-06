@echo off
setlocal

REM don't forget to set up the build environment to be non-matching:
REM python configure.py --non-matching

set ROOT_DIR=_iso
set OUT_ISO=Animal Crossing (ACME).iso

echo Building main.dol:
ninja  || exit /b

echo Updating files in %ROOT_DIR%:
copy /Y "build\GAFE01_00\static.dol" "%ROOT_DIR%\sys\main.dol" || exit /b
copy /Y "build\GAFE01_00\foresta\foresta.rel" "%ROOT_DIR%\files\foresta.rel" || exit /b
copy /Y "build\GAFE01_00\foresta\foresta.rel.szs" "%ROOT_DIR%\files\foresta.rel.szs" || exit /b

echo Rebuilding ISO:
python -m pyisotools "%ROOT_DIR%" B --dest "%~dp0%OUT_ISO%" || exit /b

echo Success! Created: %OUT_ISO%

if exist "%~dp0xdelta3.exe" (
    echo Creating xdelta patch:
    "%~dp0xdelta3.exe" -9 -S lzma -e -f -s "Animal Crossing (USA).iso" "%OUT_ISO%" "Animal Crossing (ACME).xdelta" || exit /b
    echo Success! Created: Animal Crossing ^(ACME^).xdelta
)

endlocal