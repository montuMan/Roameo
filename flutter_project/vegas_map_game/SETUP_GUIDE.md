# 🚀 Complete Setup Guide - Vegas Map Game

## Step-by-Step Installation for Windows

This guide will help you set up Flutter, Android Studio, and run the Vegas Map Game in an Android emulator.

**Estimated Total Time:** 40-60 minutes (depending on download speeds)

---

## 📋 Prerequisites Checklist

Before starting, ensure you have:
- [ ] Windows 10 or later (64-bit)
- [ ] At least 10 GB free disk space
- [ ] Stable internet connection
- [ ] Administrator access on your computer

---

## Part 1: Install Flutter SDK (15 minutes)

### Step 1.1: Download Flutter

1. **Open your web browser** and go to:
   ```
   https://docs.flutter.dev/get-started/install/windows
   ```

2. **Click on "flutter_windows_X.X.X-stable.zip"** to download
   - File size: ~1.5 GB
   - Save to your Downloads folder

3. **Wait for download to complete**

### Step 1.2: Extract Flutter

1. **Open File Explorer** (Windows + E)

2. **Navigate to** `C:\` drive (root directory)

3. **Create a new folder** called `src`
   - Right-click → New → Folder
   - Name it: `src`
   - Full path should be: `C:\src`

4. **Go to your Downloads folder**

5. **Right-click** on `flutter_windows_X.X.X-stable.zip`

6. **Select** "Extract All..."

7. **Change the destination** to `C:\src`

8. **Click "Extract"**
   - Wait for extraction (2-3 minutes)
   - You should now have: `C:\src\flutter`

### Step 1.3: Add Flutter to System PATH

1. **Press Windows key** and type: `environment variables`

2. **Click** "Edit the system environment variables"

3. **Click** "Environment Variables" button (bottom right)

4. **In "User variables"** section (top half):
   - Find and select `Path`
   - Click "Edit..."

5. **Click "New"**

6. **Type**: `C:\src\flutter\bin`

7. **Click "OK"** on all open windows

8. **Close and reopen** any open PowerShell/Command Prompt windows

### Step 1.4: Verify Flutter Installation

1. **Open PowerShell** (Windows + X → Windows PowerShell)

2. **Type and press Enter**:
   ```powershell
   flutter --version
   ```

3. **You should see** something like:
   ```
   Flutter 3.x.x • channel stable
   ```

4. **If you see this**, Flutter is installed! ✅
5. **If you get "not recognized" error**, check PATH setup again

---

## Part 2: Install Android Studio (20 minutes)

### Step 2.1: Download Android Studio

1. **Open browser** and go to:
   ```
   https://developer.android.com/studio
   ```

2. **Click** "Download Android Studio"

3. **Accept** the terms and conditions

4. **Click** "Download Android Studio for Windows"
   - File size: ~1 GB
   - Wait for download

### Step 2.2: Install Android Studio

1. **Locate** `android-studio-xxxx.exe` in Downloads

2. **Double-click** to run installer

3. **Click "Next"** on welcome screen

4. **Select components**:
   - ✅ Android Studio
   - ✅ Android Virtual Device
   - Click "Next"

5. **Choose install location** (or use default):
   - Default: `C:\Program Files\Android\Android Studio`
   - Click "Next"

6. **Click "Install"**
   - Wait 5-10 minutes for installation

7. **Click "Finish"** when done

### Step 2.3: First Time Android Studio Setup

1. **Android Studio will launch** automatically

2. **Import Settings**:
   - Select "Do not import settings"
   - Click "OK"

3. **Setup Wizard Welcome**:
   - Click "Next"

4. **Install Type**:
   - Select **"Standard"**
   - Click "Next"

5. **Select UI Theme**:
   - Choose Light or Dark (your preference)
   - Click "Next"

6. **Verify Settings**:
   - Review the components to be downloaded
   - Should include:
     - Android SDK
     - Android SDK Platform
     - Android Emulator
     - Performance (Intel HAXM)
   - Click "Next"

7. **Accept Licenses**:
   - Click "Accept" for each license
   - Click "Finish"

8. **Wait for downloads** (10-15 minutes)
   - Android SDK components will download
   - You'll see progress bars

9. **Click "Finish"** when complete

---

## Part 3: Configure Flutter for Android (5 minutes)

### Step 3.1: Run Flutter Doctor

1. **Open PowerShell**

2. **Run**:
   ```powershell
   flutter doctor
   ```

3. **You'll see a report** like:
   ```
   Doctor summary (to see all details, run flutter doctor -v):
   [✓] Flutter (Channel stable, 3.x.x)
   [✓] Windows Version
   [✓] Android toolchain - develop for Android devices
   [✗] Chrome - develop for the web (Not installed)
   [✓] Android Studio (version 202x.x)
   [✓] VS Code (version x.x)
   [!] Connected device
   ```

4. **Don't worry about** ✗ or ! marks for now - as long as Android toolchain shows ✓ or !

### Step 3.2: Accept Android Licenses

1. **In PowerShell, run**:
   ```powershell
   flutter doctor --android-licenses
   ```

2. **Press 'y'** and Enter for each license prompt

3. **Wait** until all licenses are accepted

---

## Part 4: Create Android Emulator (10 minutes)

### Step 4.1: Open Device Manager

1. **Open Android Studio**

2. **On welcome screen**, click **"More Actions"** (three dots)

3. **Select** "Virtual Device Manager"
   - (Or: Tools → Device Manager if you have a project open)

### Step 4.2: Create New Virtual Device

1. **Click** "+ Create Device" or "Create Virtual Device"

2. **Select Hardware**:
   - Category: **Phone**
   - Select: **Pixel 6** (recommended)
     - Or any device with "Play Store" icon
   - Click "Next"

3. **Select System Image**:
   - Click **"Recommended"** tab
   - Look for: **Tiramisu (API 33)** or latest available
   - If you see "Download" next to it:
     - Click "Download"
     - Accept license
     - Wait for download (5 minutes)
   - Select the downloaded image
   - Click "Next"

4. **Verify Configuration**:
   - AVD Name: `Pixel_6_API_33` (or similar)
   - Startup orientation: Portrait
   - Click **"Show Advanced Settings"** (optional):
     - RAM: 2048 MB or higher (if your PC has 8GB+ RAM)
     - Internal Storage: 2048 MB
     - SD Card: 512 MB
   - Click "Finish"

5. **Emulator created!** ✅

### Step 4.3: Test Emulator

1. **In Device Manager**, find your new emulator

2. **Click** the ▶️ (Play/Launch) button

3. **Wait** for emulator to boot (1-3 minutes first time)
   - You'll see Android logo
   - Then Android home screen

4. **If emulator opens successfully**, you're ready! ✅

5. **Close the emulator** for now (we'll launch with app)

---

## Part 5: Prepare Your Project (5 minutes)

### Step 5.1: Navigate to Project

1. **Open PowerShell**

2. **Navigate to project**:
   ```powershell
   cd "C:\Users\0voigu\Documents\Abhilash\nofomo\HeatCheck\HeatCheck_src\roamer\flutter_project\vegas_map_game"
   ```

3. **Verify you're in correct folder**:
   ```powershell
   dir
   ```
   - You should see: `pubspec.yaml`, `lib`, `android`, etc.

### Step 5.2: Get Dependencies

1. **Run**:
   ```powershell
   flutter pub get
   ```

2. **Wait** for packages to download (1-2 minutes)

3. **Look for**: "Got dependencies!" message ✅

### Step 5.3: Check Connected Devices

1. **If emulator is NOT running**, start it:
   ```powershell
   flutter emulators
   ```
   - This lists available emulators

2. **Launch your emulator**:
   ```powershell
   flutter emulators --launch Pixel_6_API_33
   ```
   - (Use the name from the list)
   - Wait for emulator to fully boot

3. **Verify device is connected**:
   ```powershell
   flutter devices
   ```
   
4. **You should see**:
   ```
   Pixel 6 API 33 (mobile) • emulator-5554 • android • Android 13 (API 33)
   ```

---

## Part 6: 🎮 RUN THE APP! (2 minutes)

### Step 6.1: Launch the Game

1. **Make sure emulator is running** (you should see Android home screen)

2. **In PowerShell (in project directory), run**:
   ```powershell
   flutter run
   ```

3. **First build takes 3-5 minutes**:
   - You'll see: "Running Gradle task 'assembleDebug'..."
   - Be patient! This is normal for first run
   - Subsequent runs are much faster (~30 seconds)

4. **Watch for**:
   ```
   Syncing files to device...
   Flutter run key commands.
   ```

5. **App launches on emulator!** 🎉

### Step 6.2: Explore the Game

1. **On emulator**, you'll see:
   - Vegas Map Game splash screen
   - "START EXPLORING" button

2. **Click "START EXPLORING"**

3. **You'll see**:
   - 3D Mapbox map of Las Vegas (night mode)
   - Game stats (Score, Energy, etc.)
   - 10 Vegas locations to discover

4. **Tap anywhere** on map to move
5. **Discover and visit locations** to earn points!

---

## 🎯 Quick Commands Reference

### Start Emulator
```powershell
cd "C:\Users\0voigu\Documents\Abhilash\nofomo\HeatCheck\HeatCheck_src\roamer\flutter_project\vegas_map_game"
flutter emulators --launch Pixel_6_API_33
```

### Run App
```powershell
cd "C:\Users\0voigu\Documents\Abhilash\nofomo\HeatCheck\HeatCheck_src\roamer\flutter_project\vegas_map_game"
flutter run
```

### Hot Reload (while app is running)
- Press `r` in terminal - instantly see changes!

### Hot Restart (while app is running)
- Press `R` in terminal - full restart

### Stop App
- Press `q` in terminal

---

## ⚠️ Troubleshooting Common Issues

### Issue 1: "flutter is not recognized"
**Solution**: 
- Recheck PATH setup in Step 1.3
- Make sure you closed and reopened PowerShell
- Run: `$env:Path` to verify `C:\src\flutter\bin` is listed

### Issue 2: Emulator won't start
**Solution**:
- Enable Virtualization in BIOS (if needed)
- Or use a different system image (try x86 instead of x86_64)
- Increase RAM in emulator settings

### Issue 3: "Gradle build failed"
**Solution**:
- Check internet connection
- Run: `flutter clean` then `flutter pub get`
- Try again: `flutter run`

### Issue 4: "No devices found"
**Solution**:
- Make sure emulator is fully booted (can see home screen)
- Run: `flutter devices` to verify
- Restart emulator if needed

### Issue 5: Mapbox map not showing
**Solution**:
- This is expected! Mapbox requires API token validation
- The app will show the 3D satellite view
- Check Android Studio Logcat for any errors

### Issue 6: App builds but crashes on start
**Solution**:
- Check logs: `flutter logs`
- Make sure Mapbox token is valid
- Try running in debug mode: `flutter run --debug`

---

## 🎊 Success Checklist

- [ ] Flutter SDK installed and in PATH
- [ ] Android Studio installed
- [ ] Android SDK licenses accepted
- [ ] Android emulator created
- [ ] Emulator launches successfully
- [ ] `flutter devices` shows emulator
- [ ] `flutter run` builds successfully
- [ ] App launches on emulator
- [ ] Vegas Map Game displays correctly
- [ ] Can tap on map and see interactions

---

## 📱 Alternative: Run on Physical Android Device

If you have an Android phone:

1. **Enable Developer Mode**:
   - Settings → About Phone
   - Tap "Build Number" 7 times
   - You'll see "You are now a developer!"

2. **Enable USB Debugging**:
   - Settings → System → Developer Options
   - Enable "USB Debugging"

3. **Connect phone** via USB to computer

4. **On phone**, allow USB debugging when prompted

5. **Verify connection**:
   ```powershell
   flutter devices
   ```
   - Should show your phone

6. **Run app**:
   ```powershell
   flutter run
   ```
   - App installs and runs on your phone!

---

## 🎓 Learning Resources

- **Flutter Documentation**: https://docs.flutter.dev
- **Flutter YouTube Channel**: https://www.youtube.com/c/flutterdev
- **Flutter Codelabs**: https://docs.flutter.dev/codelabs
- **Mapbox Flutter Plugin**: https://github.com/mapbox/mapbox-maps-flutter

---

## 💬 Need More Help?

If you encounter issues:
1. Copy the error message
2. Share with me and I'll help troubleshoot
3. Or search: "Flutter [your error message]"

---

## 🎉 You're All Set!

Enjoy exploring Vegas virtually! 🎰🗺️

**Tips for Development**:
- Use Hot Reload (press `r`) to see UI changes instantly
- Check terminal for helpful debug messages
- Have fun modifying the game!

---

*Last Updated: January 2026*
*Vegas Map Game v1.0.0*
