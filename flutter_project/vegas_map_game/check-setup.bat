@echo off
REM Vegas Map Game - Setup Checker
REM This script checks if your system is ready to run the app

echo.
echo ========================================
echo   Vegas Map Game - Setup Checker
echo ========================================
echo.

REM Check 1: Flutter
echo [1/5] Checking Flutter installation...
where flutter >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] Flutter is installed
    flutter --version | findstr /C:"Flutter"
) else (
    echo [X] Flutter NOT found in PATH
    echo     Install Flutter: https://docs.flutter.dev/get-started/install/windows
    echo.
)

REM Check 2: Flutter Doctor
echo.
echo [2/5] Running Flutter Doctor...
where flutter >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    flutter doctor
) else (
    echo [X] Skipped - Flutter not installed
)

REM Check 3: Android SDK
echo.
echo [3/5] Checking Android SDK...
if exist "%LOCALAPPDATA%\Android\Sdk" (
    echo [OK] Android SDK found at: %LOCALAPPDATA%\Android\Sdk
) else (
    if exist "%ANDROID_HOME%" (
        echo [OK] Android SDK found at: %ANDROID_HOME%
    ) else (
        echo [X] Android SDK NOT found
        echo     Install Android Studio: https://developer.android.com/studio
    )
)

REM Check 4: Available Emulators
echo.
echo [4/5] Checking for Android Emulators...
where flutter >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    flutter emulators
) else (
    echo [X] Cannot check - Flutter not installed
)

REM Check 5: Connected Devices
echo.
echo [5/5] Checking for connected devices...
where flutter >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    flutter devices
) else (
    echo [X] Cannot check - Flutter not installed
)

echo.
echo ========================================
echo   Setup Check Complete
echo ========================================
echo.
echo Next Steps:
echo   1. If all checks pass, run: flutter run
echo   2. If checks fail, see SETUP_GUIDE.md
echo   3. Start emulator: flutter emulators --launch [emulator_name]
echo.
pause
