@echo on
setlocal

set "TEST_ROOT=%CD%\autotools-smoke"
set "RECIPE_DIR=%TEST_ROOT%"
set "SRC_DIR=%TEST_ROOT%\project"
set "BUILD_PREFIX=%PREFIX%"
set "LIBRARY_PREFIX=%PREFIX%\Library"
set "LIBRARY_BIN=%LIBRARY_PREFIX%\bin"
set "LIBRARY_INC=%LIBRARY_PREFIX%\include"
set "LIBRARY_LIB=%LIBRARY_PREFIX%\lib"
set "PKG_NAME=autotools_smoke"
set "REMOVE_LIB_PREFIX=no"

cd /d "%SRC_DIR%"
call "%LIBRARY_BIN%\run_autotools_clang_conda_build.bat" smoke-build.sh
if errorlevel 1 exit /b 1

"%LIBRARY_BIN%\autotools-smoke.exe"
if errorlevel 1 exit /b 1

set "SMOKE_DLL="
for %%F in ("%LIBRARY_BIN%\*autotools_smoke*.dll") do if exist "%%~fF" set "SMOKE_DLL=%%~fF"
if not defined SMOKE_DLL exit /b 1

if /I "%target_platform%"=="win-arm64" (
    dumpbin /headers "%LIBRARY_BIN%\autotools-smoke.exe" | findstr /I /C:"AA64 machine (ARM64)"
    if errorlevel 1 exit /b 1
    dumpbin /headers "%SMOKE_DLL%" | findstr /I /C:"AA64 machine (ARM64)"
    if errorlevel 1 exit /b 1
) else (
    dumpbin /headers "%LIBRARY_BIN%\autotools-smoke.exe" | findstr /I /C:"8664 machine (x64)"
    if errorlevel 1 exit /b 1
    dumpbin /headers "%SMOKE_DLL%" | findstr /I /C:"8664 machine (x64)"
    if errorlevel 1 exit /b 1
)

endlocal
