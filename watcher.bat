@echo off
REM Auto Gen Assets Background Watcher for Windows
REM Copy this file to your project root and run: watcher.bat start

set PID_FILE=.watcher.pid
set LOG_FILE=watcher.log

if "%1"=="start" goto start
if "%1"=="stop" goto stop
if "%1"=="restart" goto restart
if "%1"=="status" goto status
if "%1"=="logs" goto logs
goto help

:start
if exist %PID_FILE% (
    echo Watcher already running (PID: 
    type %PID_FILE%
    echo )
    goto end
)
echo Starting watcher in background...
start /B dart run auto_gen_assets --watch > %LOG_FILE% 2>&1
for /f "tokens=2" %%a in ('tasklist /fi "imagename eq dart.exe" /fo table /nh ^| find "dart.exe"') do (
    echo %%a > %PID_FILE%
    echo ✅ Watcher started (PID: %%a)
    echo 📋 Logs: type %LOG_FILE%
    echo 🛑 Stop: %0 stop
)
goto end

:stop
if exist %PID_FILE% (
    set /p PID=<%PID_FILE%
    echo Stopping watcher (PID: %PID%)...
    taskkill /PID %PID% /F >nul 2>&1
    del %PID_FILE%
    echo ✅ Watcher stopped
) else (
    echo Watcher not running
)
goto end

:restart
call %0 stop
timeout /t 1 /nobreak >nul
call %0 start
goto end

:status
if exist %PID_FILE% (
    set /p PID=<%PID_FILE%
    tasklist /FI "PID eq %PID%" 2>nul | find "%PID%" >nul
    if errorlevel 1 (
        echo ❌ Watcher crashed
        del %PID_FILE%
    ) else (
        echo ✅ Watcher is running (PID: %PID%)
    )
) else (
    echo ❌ Watcher not running
)
goto end

:logs
if exist %LOG_FILE% (
    type %LOG_FILE%
) else (
    echo No log file found. Start watcher first: %0 start
)
goto end

:help
echo Auto Gen Assets Background Watcher
echo.
echo Usage: %0 {start^|stop^|restart^|status^|logs}
echo.
echo Commands:
echo   start   - Start watcher in background
echo   stop    - Stop watcher
echo   restart - Restart watcher
echo   status  - Check watcher status
echo   logs    - Show watcher logs
echo.
echo Examples:
echo   %0 start    # Start watcher in background
echo   %0 status   # Check if running
echo   %0 logs     # View logs
echo   %0 stop     # Stop watcher
echo.
echo Workflow:
echo   1. %0 start    # Start watcher
echo   2. Add/remove assets in assets/ folder
echo   3. Watcher auto-updates lib/generated/assets.dart
echo   4. %0 stop     # Stop when done

:end 