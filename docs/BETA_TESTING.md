# Beta Testing Guide

Welcome to the TS4 Data Manager beta testing program! Your feedback helps us create a better tool for the Sims 4 community.

## 🧪 Current Beta Status

**Current Phase:** Foundation Testing (Profile Management)
**Beta Version:** v1.0.0-beta.1
**Focus Areas:** Core functionality, UI/UX, cross-platform compatibility

## 🎯 What We're Testing

### ✅ Ready for Testing

- **Profile Creation**: Create and configure new profiles
- **Sims 4 Discovery**: Automatic detection of Sims 4 installation
- **Path Validation**: Storage location selection and validation
- **Profile Management**: Switch between profiles, edit, delete
- **Cross-Platform**: Windows, macOS, and Linux compatibility
- **UI/UX**: Material 3 interface, responsiveness, accessibility

### 🚧 Coming in Next Beta

- **Snapshot System**: Create and restore snapshots
- **File Tracking**: Monitor changes in Sims 4 directories
- **Export/Import**: Share profiles between computers

### 🔮 Future Features

- **Mod Manager Integration**: Direct integration with Vortex, MO2
- **Conflict Resolution**: Detect and resolve file conflicts
- **Performance Optimization**: Faster scanning and operations

## 📥 Getting Started

### 1. Download Beta

1. Go to [Releases](https://github.com/LarryAlexander/TS4dataManager/releases)
2. Find the latest beta release (marked with "Pre-release")
3. Download for your platform:
   - **Windows**: `TS4DataManager-Windows.zip`
   - **macOS**: `TS4DataManager-macOS.zip`
   - **Linux**: `TS4DataManager-Linux.tar.gz`

### 2. Installation

**Windows:**

1. Extract ZIP to a folder (e.g., `C:\TS4DataManager\`)
2. Run `ts4_data_manager.exe`
3. Windows may show a security warning (normal for unsigned apps)

**macOS:**

1. Extract ZIP file
2. Drag app to Applications or run from Downloads
3. macOS may require "Allow" in Security preferences

**Linux:**

1. Extract: `tar -xzf TS4DataManager-Linux.tar.gz`
2. Run: `./ts4_data_manager`
3. May need to install GTK3: `sudo apt install libgtk-3-0`

### 3. First Launch

1. The app will start with an empty state
2. Click "Create Profile" to begin setup
3. Follow the guided profile creation process

## 🧪 Testing Scenarios

### Scenario 1: Standard Setup

**Goal**: Test typical user workflow
**Steps**:

1. Launch app for first time
2. Create profile with auto-detected Sims 4 path
3. Use default storage location
4. Verify profile appears in list
5. Switch between profiles

**Expected**: Smooth workflow, clear feedback, no errors

### Scenario 2: Custom Paths

**Goal**: Test manual path configuration
**Steps**:

1. Create profile
2. Manually browse for Sims 4 folder
3. Choose custom storage location
4. Test path validation feedback

**Expected**: Path validation works, helpful error messages

### Scenario 3: Edge Cases

**Goal**: Test unusual configurations
**Test Cases**:

- Sims 4 in OneDrive folder
- Paths with special characters/spaces
- Network drives (if applicable)
- Multiple Sims 4 installations
- Very large mod folders (>5GB)

### Scenario 4: Error Handling

**Goal**: Test error conditions
**Test Cases**:

- No Sims 4 installation
- Invalid storage paths
- Permission issues
- Disk space limitations
- App crashes/recovery

### Scenario 5: Platform-Specific

**Goal**: Test platform features
**Windows**: Windows Defender interaction, paths with backslashes
**macOS**: Gatekeeper, app bundle behavior, paths in iCloud
**Linux**: Different desktop environments, package dependencies

## 📊 What to Test

### ✅ Core Functionality Checklist

- [ ] App launches successfully
- [ ] Profile creation wizard works
- [ ] Sims 4 auto-discovery functions
- [ ] Manual path selection works
- [ ] Path validation provides feedback
- [ ] Profile list shows created profiles
- [ ] Profile switching works
- [ ] Profile editing functions
- [ ] Profile deletion works (with confirmation)
- [ ] App remembers settings between launches

### 🎨 UI/UX Checklist

- [ ] Interface is intuitive and clear
- [ ] Navigation makes sense
- [ ] Buttons and controls are responsive
- [ ] Text is readable and well-formatted
- [ ] Icons and layout look professional
- [ ] Window resizing works properly
- [ ] Dark/light theme support (if applicable)

### 🚀 Performance Checklist

- [ ] App starts quickly (< 5 seconds)
- [ ] UI remains responsive during operations
- [ ] Path validation is fast
- [ ] Memory usage seems reasonable
- [ ] No unexpected crashes or freezes

## 🐛 Reporting Issues

### Bug Reports

Use our [Bug Report Template](https://github.com/LarryAlexander/TS4dataManager/issues/new?template=bug_report.md)

**Include**:

- Exact steps to reproduce
- What you expected vs. what happened
- Screenshots if helpful
- Your system information
- Sims 4 setup details

### Beta Feedback

Use our [Beta Feedback Template](https://github.com/LarryAlexander/TS4dataManager/issues/new?template=beta_feedback.md)

**Include**:

- Overall experience rating
- What worked well
- What was confusing
- Suggestions for improvement

## 🔍 Known Issues

### Current Limitations

- **Windows**: May trigger antivirus warnings (false positive)
- **macOS**: Requires allowing unsigned app in Security preferences
- **Linux**: Needs GTK3 libraries installed
- **All Platforms**: Snapshot/restore not yet implemented

### Common Problems

1. **"Sims 4 not found"**: Try manual path selection
2. **Permission denied**: Run as administrator or choose different storage
3. **Slow performance**: Check available disk space and close other apps

## 📈 Beta Progress Tracking

### Completed Features

- [x] Cross-platform Flutter app structure
- [x] Profile management system
- [x] Sims 4 auto-discovery (Windows/macOS/Linux)
- [x] Path validation and feedback
- [x] Material 3 UI implementation

### In Progress

- [ ] Snapshot creation system
- [ ] File change tracking
- [ ] Export/import functionality

### Planned for Future Betas

- [ ] Mod manager integration hooks
- [ ] Advanced profile settings
- [ ] Performance optimizations
- [ ] Comprehensive help system

## 🤝 Beta Community

### Communication

- **Issues**: Report bugs and problems
- **Discussions**: Ask questions, share ideas
- **Beta Label**: All beta-related issues are tagged

### Beta Tester Benefits

- Early access to new features
- Direct influence on development priorities
- Recognition in release notes
- Exclusive beta tester role (if desired)

## 📅 Beta Schedule

### Phase 1: Foundation (Current)

- **Duration**: 2-3 weeks
- **Focus**: Profile management, basic UI
- **Success Criteria**: Stable profile creation/management

### Phase 2: Core Features

- **Duration**: 3-4 weeks
- **Focus**: Snapshots, file tracking
- **Success Criteria**: Basic backup/restore functionality

### Phase 3: Integration

- **Duration**: 2-3 weeks
- **Focus**: Mod manager compatibility, polish
- **Success Criteria**: Production-ready release

## ❓ Questions?

- **General Questions**: [Start a Discussion](https://github.com/LarryAlexander/TS4dataManager/discussions)
- **Bug Reports**: [Create an Issue](https://github.com/LarryAlexander/TS4dataManager/issues)
- **Feature Ideas**: [Feature Request](https://github.com/LarryAlexander/TS4dataManager/issues/new?template=feature_request.md)

---

Thank you for being part of our beta testing program! Your feedback makes TS4 Data Manager better for everyone in the Sims 4 community. 🎉
