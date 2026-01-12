# 🎮 Vegas Map Game - Quick Start Reference

## ⚡ Prerequisites Installed?

```
✅ Flutter SDK
✅ Android Studio
✅ Android Emulator
```

**Not yet?** → See [`SETUP_GUIDE.md`](SETUP_GUIDE.md)

---

## 🚀 Launch in 3 Steps

### Option A: Automated (Recommended)

```batch
# Double-click this file in Windows Explorer:
run-app.bat
```

### Option B: Manual

```powershell
# Step 1: Navigate to project
cd "C:\Users\0voigu\Documents\Abhilash\nofomo\HeatCheck\HeatCheck_src\roamer\flutter_project\vegas_map_game"

# Step 2: Start emulator
flutter emulators --launch Pixel_6_API_33

# Step 3: Run app (wait 30 seconds for emulator boot first)
flutter run
```

---

## 🎯 Essential Commands

### Check System Status
```powershell
flutter doctor           # Check installation
flutter devices          # List connected devices
flutter emulators        # List available emulators
```

### Run Commands
```powershell
flutter pub get          # Get dependencies
flutter run              # Run app
flutter run -d chrome    # Run in web browser
flutter clean            # Clean build cache
```

### While App Running
| Key | Action |
|-----|--------|
| `r` | Hot Reload (instant UI updates) |
| `R` | Hot Restart (full restart) |
| `q` | Quit app |
| `d` | Detach (keep running) |
| `h` | Show help |

---

## 📱 Device Options

### Android Emulator (Recommended)
```powershell
flutter emulators --launch Pixel_6_API_33
flutter run
```
**Features:** ✅ Full 3D Mapbox • ✅ Best performance

### Physical Android Device
1. Enable Developer Mode + USB Debugging
2. Connect via USB
3. `flutter run`

**Features:** ✅ Full 3D Mapbox • ✅ Real device testing

### Chrome Browser (Quick Test)
```powershell
flutter run -d chrome
```
**Features:** ⚠️ 2D Fallback map • ✅ No emulator needed

---

## 🎮 How to Play

1. **Launch app** → See main menu
2. **Tap "START EXPLORING"** → Enter game
3. **Tap map** → Move your character
4. **Get close to locations** → Discover them
5. **Tap discovered markers** → Visit & earn points

**Goal:** Visit all 10 Vegas locations! 🏆

---

## 🔧 Common Issues & Fixes

### "No devices found"
```powershell
# Check if emulator is running
flutter devices

# If empty, launch emulator:
flutter emulators --launch Pixel_6_API_33
```

### Build errors
```powershell
flutter clean
flutter pub get
flutter run
```

### Emulator slow
- Allocate more RAM in AVD settings
- Enable Hardware Acceleration (HAXM)
- Use x86 system image (not ARM)

### App crashes on start
```powershell
flutter logs           # Check error logs
flutter run --debug    # Run in debug mode
```

---

## 📊 Development Workflow

```
┌─────────────────────────────────────────┐
│  1. Start Emulator                      │
│     flutter emulators --launch ...      │
└─────────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────┐
│  2. Run App                             │
│     flutter run                         │
└─────────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────┐
│  3. Make Code Changes                   │
│     Edit files in lib/                  │
└─────────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────┐
│  4. Hot Reload                          │
│     Press 'r' in terminal               │
│     See changes instantly! 🔥           │
└─────────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────┐
│  5. Test Changes                        │
│     Play game in emulator               │
└─────────────────────────────────────────┘
                 ↓
          Repeat steps 3-5
```

---

## 🗂️ Project Structure Quick Reference

```
vegas_map_game/
├── lib/
│   ├── main.dart              ← App entry & main menu
│   ├── models/
│   │   └── game_models.dart   ← Data classes
│   ├── engine/
│   │   └── game_engine.dart   ← Game logic
│   ├── screens/
│   │   └── game_screen.dart   ← Main game UI
│   ├── widgets/
│   │   ├── vegas_map_widget.dart         ← 2D map
│   │   └── mapbox_vegas_map_widget.dart  ← 3D map
│   └── data/
│       └── vegas_locations.dart  ← Location data
├── android/               ← Android config
├── ios/                   ← iOS config
├── test/                  ← Unit tests
├── pubspec.yaml          ← Dependencies
├── SETUP_GUIDE.md        ← Full setup instructions
├── QUICK_START.md        ← This file!
├── check-setup.bat       ← System checker
└── run-app.bat           ← Quick launcher
```

---

## 🎨 Customization Ideas

Want to modify the game? Here are easy starting points:

### Change Colors
📍 File: `lib/main.dart`
```dart
// Line 38-40: Main theme colors
colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
```

### Add New Locations
📍 File: `lib/data/vegas_locations.dart`
```dart
// Add to the list:
VegasLocation(
  id: 'new_location',
  name: 'Your Location',
  description: 'Description here',
  x: 0.5, y: 0.5,
  points: 100,
  iconPath: '🎯',
  type: LocationType.landmark,
),
```

### Adjust Energy System
📍 File: `lib/engine/game_engine.dart`
```dart
// Line 30: Change energy cost
int energyCost = (distance * 100).round(); // Make smaller = less cost

// Line 54: Change energy restore
_player.energy = min(_player.maxEnergy, _player.energy + 20); // Increase number
```

### Change Discovery Radius
📍 File: `lib/engine/game_engine.dart`
```dart
// Line 72: Discovery distance
if (distance <= 0.15) { // Make larger = discover from farther away

// Line 98: Visit distance
return distance <= 0.05; // Make larger = visit from farther away
```

---

## 🆘 Need Help?

1. **Check setup:** Run `check-setup.bat`
2. **Read full guide:** Open `SETUP_GUIDE.md`
3. **View logs:** Run `flutter logs`
4. **Ask for help:** Share error messages

---

## 🎉 Shortcuts for Pros

### One-liner Setup Check
```powershell
flutter doctor -v && flutter devices && flutter emulators
```

### Run on Specific Device
```powershell
flutter run -d emulator-5554
```

### Build Release APK
```powershell
flutter build apk --release
```

### Run with Hot Reload on Save (VS Code)
1. Open project in VS Code
2. Install Flutter extension
3. Press F5
4. Auto-reloads on every save! 🔥

---

**Happy Gaming! 🎰🗺️**

*Vegas Map Game v1.0.0 | Last updated: January 2026*
