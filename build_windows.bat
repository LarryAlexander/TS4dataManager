@echo off
echo Building TS4 Data Manager for Windows...
echo.

:: Check if Flutter is installed
flutter doctor > nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Flutter is not installed or not in PATH
    echo Please install Flutter from https://docs.flutter.dev/get-started/install/windows
    pause
    exit /b 1
)

:: Navigate to app directory
cd /d "%~dp0\app"

echo Getting Flutter dependencies...
flutter pub get

echo.
echo Building Windows release...
flutter build windows --release

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Build failed
    echo Make sure Visual Studio with C++ tools is installed
    pause
    exit /b 1
)

echo.
echo Build completed successfully!
echo.
echo Release files are located at:
echo %cd%\build\windows\x64\runner\Release\
echo.
echo To create a distribution package:
echo 1. Copy the entire Release folder contents
echo 2. Include README_WINDOWS_DISTRIBUTION.md
echo 3. Zip the package for distribution
echo.
pause