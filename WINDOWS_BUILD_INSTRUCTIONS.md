# TS4 Data Manager - Windows Build Instructions

This guide will help you build the TS4 Data Manager for Windows distribution.

## Prerequisites

1. **Flutter SDK**: Install Flutter for Windows from https://docs.flutter.dev/get-started/install/windows
2. **Visual Studio**: Install Visual Studio 2019 or later with "Desktop development with C++" workload
3. **Git**: For cloning the repository

## Building the Windows Package

### Step 1: Clone and Setup

```cmd
git clone <repository-url>
cd TS4dataManager/app
flutter doctor
flutter pub get
```

### Step 2: Build Release Executable

```cmd
flutter build windows --release
```

This will create the executable at: `build/windows/x64/runner/Release/`

### Step 3: Package for Distribution

The release folder contains:

- `ts4_data_manager.exe` - Main executable
- `data/` - Flutter assets and data
- Various DLL files needed for runtime

## Distribution Package Contents

Copy the entire `build/windows/x64/runner/Release/` folder contents to create your distribution package.

### Required Files for Distribution:

```
ts4_data_manager.exe          # Main application
flutter_windows.dll          # Flutter runtime
data/                        # Application assets
  icudtl.dat
  flutter_assets/
    AssetManifest.json
    FontManifest.json
    fonts/
    packages/
    shaders/
    ...
```

## Troubleshooting

### Common Issues:

1. **Missing Visual Studio**: Ensure Visual Studio with C++ tools is installed
2. **Flutter not in PATH**: Run `flutter doctor` to verify installation
3. **Build errors**: Check that all dependencies in pubspec.yaml are compatible with Windows

### Verification:

- Run the executable on a clean Windows machine to verify it works without development tools
- Test all application features: profile creation, Sims 4 discovery, path validation

## User Installation

Users simply need to:

1. Extract the package to a folder (e.g., `C:\Program Files\TS4 Data Manager\`)
2. Run `ts4_data_manager.exe`
3. No additional installation required - it's a portable application

## Notes

- The application automatically discovers Sims 4 installations in standard Windows locations
- User data is stored in `%USERPROFILE%\Documents\TS4DataManager\` by default
- The app is designed to coexist with mod managers like Vortex, MO2, and CurseForge
- All telemetry is disabled by default for privacy
