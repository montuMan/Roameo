@echo off
REM Vegas Map Game - Quick Run Script

echo.
echo ========================================
echo   Vegas Map Game - Quick Launcher
echo ========================================
echo.

REM Check if Flutter is installed
where flutter >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Flutter not found!
    echo Please install Flutter first. See SETUP_GUIDE.md
    echo.
    pause
    exit /b 1
)

REM Check for dependencies
if not exist "pubspec.lock" (
    echo [INFO] First time setup - getting dependencies...
    flutter pub get
    echo.
)

REM Check for connected devices
echo Checking for available devices...
flutter devices | findstr /C:"emulator" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [WARNING] No emulator detected!
    echo.
    echo Available emulators:
    flutter emulators
    echo.
    echo Would you like to launch an emulator?
    set /p launch_emu="Enter emulator name (or press Enter to skip): "
    if not "!launch_emu!"=="" (
        echo Launching emulator: !launch_emu!
        start flutter emulators --launch !launch_emu!
        echo Waiting for emulator to boot...
        timeout /t 20 /nobreak
    )
)

echo.
echo ========================================
echo   Starting Vegas Map Game...
echo ========================================
echo.
echo Tips:
echo   - Press 'r' for hot reload
echo   - Press 'R' for hot restart
echo   - Press 'q' to quit
echo.
echo First build may take 3-5 minutes...
echo.

REM Run the app
flutter run

echo.
echo App stopped.
pause
