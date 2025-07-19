@echo off
REM Simple Auto Gen Assets Watcher for Windows
REM This script works in any Flutter project directory

echo 🚀 Starting auto_gen_assets watcher...
echo 📁 Current directory: %CD%
echo ⏹️  Press Ctrl+C to stop
echo.

REM Check if we're in a Flutter project
if not exist "pubspec.yaml" (
    echo ❌ Error: pubspec.yaml not found in current directory
    echo    Please run this script from your Flutter project root
    pause
    exit /b 1
)

REM Check if auto_gen_assets is in dependencies
findstr /C:"auto_gen_assets:" pubspec.yaml >nul
if errorlevel 1 (
    echo ❌ Error: auto_gen_assets not found in pubspec.yaml
    echo    Please add it to your dependencies first:
    echo    dependencies:
    echo      auto_gen_assets: ^1.0.4
    pause
    exit /b 1
)

REM Check if assets directory exists
if not exist "assets" (
    echo ⚠️  Warning: assets directory not found
    echo    Creating assets directory...
    mkdir assets
)

REM Start watcher
echo 👀 Starting watcher...
dart run auto_gen_assets --watch 