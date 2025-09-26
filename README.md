# TS4 Data Manager

A git-style data manager for The Sims 4 that coexists with mod managers.

[![Build Status](https://github.com/LarryAlexander/TS4dataManager/workflows/Build/badge.svg)](https://github.com/LarryAlexander/TS4dataManager/actions)
[![Release](https://img.shields.io/github/v/release/LarryAlexander/TS4dataManager)](https://github.com/LarryAlexander/TS4dataManager/releases)
[![License](https://img.shields.io/github/license/LarryAlexander/TS4dataManager)](LICENSE)

## 🎯 What is TS4 Data Manager?

TS4 Data Manager brings git-style version control to your Sims 4 data. Create snapshots, manage multiple profiles, and safely experiment with mods - all while coexisting peacefully with your favorite mod managers like Vortex, MO2, and CurseForge.

### ✨ Key Features

- **🔄 Non-destructive Backups**: Create snapshots without touching your original files
- **👤 Profile Management**: Multiple isolated configurations with easy switching
- **🤝 Mod Manager Friendly**: Works alongside Vortex, MO2, CurseForge, and others
- **📦 Export/Import**: Share configurations between computers or with friends
- **🔒 Privacy-Focused**: No telemetry by default, all data stays local
- **⚡ Performance Conscious**: Configurable storage limits and smart cleanup

## 📥 Download

### Latest Release

- [Download for Windows](https://github.com/LarryAlexander/TS4dataManager/releases/latest/download/TS4DataManager-Windows.zip)
- [Download for macOS](https://github.com/LarryAlexander/TS4dataManager/releases/latest/download/TS4DataManager-macOS.zip)
- [Download for Linux](https://github.com/LarryAlexander/TS4dataManager/releases/latest/download/TS4DataManager-Linux.tar.gz)

### Beta Releases

- [View All Releases](https://github.com/LarryAlexander/TS4dataManager/releases)
- [Beta Testing Guide](docs/BETA_TESTING.md)

## 🚀 Quick Start

1. **Download** the latest release for your platform
2. **Extract** and run `TS4DataManager.exe` (Windows) or the app bundle (macOS/Linux)
3. **Create Profile** - The app will guide you through setup
4. **Auto-Discovery** - Automatically finds your Sims 4 installation
5. **Start Managing** - Create snapshots, switch profiles, export configurations

## 📖 Documentation

- [Installation Guide](docs/INSTALLATION.md)
- [User Guide](docs/USER_GUIDE.md)
- [FAQ](docs/FAQ.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## 🧪 Beta Testing

We're actively seeking beta testers! Here's how to help:

### How to Participate

1. Download the [latest beta release](https://github.com/LarryAlexander/TS4dataManager/releases)
2. Test core functionality: profile creation, Sims 4 discovery, basic UI
3. [Report bugs](https://github.com/LarryAlexander/TS4dataManager/issues/new?template=bug_report.md) with detailed steps
4. [Suggest features](https://github.com/LarryAlexander/TS4dataManager/issues/new?template=feature_request.md)

### What We're Testing

- ✅ **Profile Management** (Create, switch, delete profiles)
- ✅ **Sims 4 Discovery** (Auto-detection of game folders)
- ✅ **Path Validation** (Storage location selection and validation)
- 🚧 **Snapshot System** (Coming in next beta)
- 🚧 **Export/Import** (Coming soon)

### Beta Feedback

- [Current Beta Issues](https://github.com/LarryAlexander/TS4dataManager/labels/beta)
- [Beta Testing Discussion](https://github.com/LarryAlexander/TS4dataManager/discussions/categories/beta-testing)

## 🛠 Development

### Prerequisites

- Flutter 3.35.2+
- Dart 3.9.0+
- Platform-specific tools (Visual Studio for Windows, Xcode for macOS)

### Building from Source

```bash
git clone https://github.com/LarryAlexander/TS4dataManager.git
cd TS4dataManager/app
flutter pub get
flutter build windows/macos/linux --release
```

### Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 🏗 Architecture

Built with Flutter for native cross-platform performance:

- **Frontend**: Flutter/Dart with Material 3 design
- **Backend**: Service-oriented architecture with clean separation
- **Platform Integration**: Native platform utilities for file system operations
- **Privacy**: Local-first design, no external dependencies

## 📋 Roadmap

### Phase 1: Foundation ✅

- [x] Profile management system
- [x] Sims 4 auto-discovery
- [x] Cross-platform UI
- [x] Path validation and storage

### Phase 2: Core Features 🚧

- [ ] Snapshot creation and restore
- [ ] File change tracking
- [ ] Retention policy management
- [ ] Export/import workflows

### Phase 3: Advanced Features 🔮

- [ ] Integration with popular mod managers
- [ ] Conflict detection and resolution
- [ ] Collaborative sharing features
- [ ] Performance optimizations

## ⚖️ License

Copyright (C) 2025 TS4 Data Manager Contributors

This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.

## 🤝 Support

- **Bug Reports**: [Create an issue](https://github.com/LarryAlexander/TS4dataManager/issues/new?template=bug_report.md)
- **Feature Requests**: [Suggest a feature](https://github.com/LarryAlexander/TS4dataManager/issues/new?template=feature_request.md)
- **Discussions**: [Join the community](https://github.com/LarryAlexander/TS4dataManager/discussions)
- **Beta Testing**: [Join the beta program](#-beta-testing)

## 🙏 Acknowledgments

- The Sims 4 modding community for inspiration and feedback
- Flutter team for the amazing cross-platform framework
- All our beta testers and contributors

---

**⚠️ Disclaimer**: This is an independent project and is not affiliated with Electronic Arts or The Sims 4. Always backup your saves before trying new tools!
