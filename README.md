# Roameo
app to roam around like a romeo - only this time the juilet is but a cool cafe!
# 🎰 Vegas Map Game

An interactive location-based exploration game set in Las Vegas, built with Flutter.

![Flutter](https://img.shields.io/badge/Flutter-3.10.4-02569B?logo=flutter)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green)
![License](https://img.shields.io/badge/License-Private-red)

## 🎮 About the Game

Explore the Entertainment Capital of the World! Navigate an interactive map of Las Vegas, discover 10 famous landmarks, manage your energy strategically, and earn achievements.

**Features:**
- 🗺️ Interactive 3D Mapbox map (mobile) or 2D fallback (web)
- 📍 10 famous Vegas locations to discover and visit
- ⚡ Strategic energy management system
- 🏆 Achievement system with multiple milestones
- 🎯 Point-based scoring (total 1,530 points available)
- 🌃 Beautiful Vegas-themed UI with night mode

## 🚀 Quick Start

### New to Flutter?
**📘 See [`SETUP_GUIDE.md`](SETUP_GUIDE.md)** for complete step-by-step installation instructions (40 mins)

### Already Have Flutter?
**📗 See [`QUICK_START.md`](QUICK_START.md)** for quick reference commands

### Super Quick Launch
```bash
# Check your setup
check-setup.bat

# Run the app
run-app.bat
```

## 📋 Prerequisites

- Flutter SDK 3.10.4 or higher
- Android Studio (for Android emulator) or Xcode (for iOS simulator)
- Android/iOS emulator or physical device

## 🎯 How to Play

1. **Launch** the app and tap "START EXPLORING"
2. **Tap** anywhere on the map to move your character (costs energy)
3. **Discover** locations by moving close to them
4. **Tap** discovered location markers to visit them (restores energy)
5. **Earn** points and unlock achievements

## 🏛️ Vegas Locations

| Location | Points | Type | Description |
|----------|--------|------|-------------|
| 🏔️ Red Rock Canyon | 250 | Landmark | Natural beauty outside the city |
| 🗼 Stratosphere Tower | 200 | Landmark | Tallest observation tower |
| 🌈 Fremont Street | 180 | Entertainment | Historic LED canopy |
| 🎡 High Roller | 160 | Entertainment | World's largest observation wheel |
| 🏨 Bellagio | 150 | Hotel | Famous fountains |
| 🦁 MGM Grand | 140 | Hotel | Massive hotel complex |
| 🚤 The Venetian | 130 | Hotel | Italian gondola rides |
| 🏛️ Caesars Palace | 120 | Casino | Roman-themed resort |
| 🔺 Luxor | 110 | Casino | Egyptian pyramid |
| 🛍️ Forum Shops | 90 | Shopping | Upscale Roman architecture |

## 🏆 Achievements

- 🎯 **First Visit** - Visit your first location
- 🏆 **Explorer** - Visit 5 locations
- 👑 **Vegas Master** - Visit all 10+ locations
- 🎡 **High Roller** - Visit the High Roller specifically

## 🏗️ Project Structure

```
lib/
├── main.dart                           # App entry & main menu
├── models/game_models.dart             # Data models
├── engine/game_engine.dart             # Game logic (Singleton)
├── screens/game_screen.dart            # Main game UI
├── widgets/
│   ├── vegas_map_widget.dart           # 2D map (web fallback)
│   └── mapbox_vegas_map_widget.dart    # 3D Mapbox (mobile)
└── data/vegas_locations.dart           # Location definitions
```

## 🛠️ Development

### Run on Android Emulator
```bash
flutter emulators --launch Pixel_6_API_33
flutter run
```

### Run on Web Browser (2D fallback)
```bash
flutter run -d chrome
```

### Run on Physical Device
```bash
# Enable USB debugging on your device first
flutter devices
flutter run
```

### Hot Reload
Press `r` in terminal while app is running for instant updates!

## 🧪 Testing

```bash
flutter test                 # Run all tests
flutter test --coverage      # Generate coverage report
```

## 📦 Dependencies

- **mapbox_maps_flutter** ^2.0.0 - 3D map rendering (mobile only)
- **cupertino_icons** ^1.0.8 - iOS-style icons

## 🔧 Configuration

**Mapbox Access Token:**  
Located in `lib/main.dart` line 21. Replace with your own token from [Mapbox](https://account.mapbox.com/).

## 📱 Platform Support

| Platform | Status | Features |
|----------|--------|----------|
| Android | ✅ Full Support | 3D Mapbox, All features |
| iOS | ✅ Full Support | 3D Mapbox, All features |
| Web | ✅ Fallback | 2D custom map |
| Desktop | ⚠️ Not tested | Should work with web fallback |

## 📖 Documentation

- [`SETUP_GUIDE.md`](SETUP_GUIDE.md) - Complete installation guide for beginners
- [`QUICK_START.md`](QUICK_START.md) - Quick reference for developers
- [`IMPLEMENTATION.md`](IMPLEMENTATION.md) - Technical implementation details

## 🐛 Troubleshooting

Run the setup checker:
```bash
check-setup.bat
```

Common issues:
- **No devices found?** → Start emulator first
- **Build errors?** → Run `flutter clean && flutter pub get`
- **Slow emulator?** → Allocate more RAM in AVD settings

## 📄 License

Private project - Not for public distribution

## 👨‍💻 Development Commands

```bash
flutter pub get              # Get dependencies
flutter analyze              # Run static analysis
flutter clean                # Clean build files
flutter doctor               # Check system setup
flutter logs                 # View app logs
flutter build apk            # Build Android APK
```

## 🎓 Learning Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Mapbox Flutter Plugin](https://github.com/mapbox/mapbox-maps-flutter)
- [Flutter Codelabs](https://docs.flutter.dev/codelabs)

---

**Built with Flutter 🚀 | Vegas themed 🎰 | Map-based gameplay 🗺️**

*Version 1.0.0 | Last updated: January 2026*
