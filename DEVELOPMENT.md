# TS4 Data Manager — Developer Setup (macOS)

This repo uses Flutter for the desktop app. An optional Rust helper can be added later for performance hotspots.

## Prerequisites

- Flutter 3.35+ with desktop support
  - macOS SDK (Xcode) for macOS builds
  - Windows builds require building on Windows (CI or a Windows dev machine)
- For optional Rust helper (later):
  - Rust toolchain (rustup + cargo)

## First run

```bash
# from repo root
cd app
flutter pub get
flutter run -d macos
```

## Notes

- Telemetry is OFF by default. Diagnostics are manual export only.
- Options (game settings/config) are tracked alongside Mods, Saves, Screenshots, and Recordings.
- Profiles live at user-chosen paths; the UI shows friendly labels, not internal IDs.
