@echo off
REM FH DualSense - Windows launcher (zuv).
REM Args starting with -- forward to fhds.zuv.py (e.g. --prerelease, --headless).
REM Remaining args = optional Steam wrapper game cmd (e.g. start "" steam://rungameid/1551360).
setlocal EnableDelayedExpansion
set "DIR=%~dp0"
set "BUNDLE=%DIR%fhds.zuv.py"
set "FLAGS="
set "GAME="

:argloop
if "%~1"=="" goto ready
set "a=%~1"
if "!a:~0,2!"=="--" (set "FLAGS=!FLAGS! %1") else (set "GAME=!GAME! %1")
shift
goto argloop

:ready
if not exist "%BUNDLE%" (
    echo Could not find %BUNDLE%.
    echo Download fhds.zuv.py from https://github.com/HamzaYslmn/Forza-Horizon-DualSense-Python/releases/latest
    pause
    exit /b 1
)

where uv >nul 2>nul
if errorlevel 1 (
    echo Installing uv...
    powershell -NoProfile -Command "irm https://astral.sh/uv/install.ps1 | iex"
    set "PATH=%USERPROFILE%\.local\bin;%PATH%"
    where uv >nul 2>nul || (echo uv not on PATH - restart terminal. & pause & exit /b 1)
)

if defined GAME start "" %GAME%

uv run "%BUNDLE%" %FLAGS%
if not defined GAME pause >nul
endlocal
