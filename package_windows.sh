#!/bin/bash

# TS4 Data Manager - Create Windows Distribution Package
# This script creates a distributable package from the Windows build

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$SCRIPT_DIR/app"
BUILD_DIR="$APP_DIR/build/windows/x64/runner/Release"
DIST_DIR="$SCRIPT_DIR/dist"
PACKAGE_DIR="$DIST_DIR/TS4DataManager-Windows"

echo "Creating TS4 Data Manager Windows distribution package..."

# Check if build exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "ERROR: Windows build not found at $BUILD_DIR"
    echo "Please build the Windows version first using build_windows.bat on a Windows machine"
    exit 1
fi

# Create distribution directory
rm -rf "$DIST_DIR"
mkdir -p "$PACKAGE_DIR"

echo "Copying build files..."
cp -r "$BUILD_DIR"/* "$PACKAGE_DIR/"

# Copy documentation
echo "Adding documentation..."
cp "$SCRIPT_DIR/README_WINDOWS_DISTRIBUTION.md" "$PACKAGE_DIR/README.md"
cp "$SCRIPT_DIR/WINDOWS_BUILD_INSTRUCTIONS.md" "$PACKAGE_DIR/BUILD_INSTRUCTIONS.md"

# Create version info
echo "Creating version info..."
cat > "$PACKAGE_DIR/VERSION.txt" << EOF
TS4 Data Manager v1.0.0
Built on: $(date)
Platform: Windows x64

Features in this version:
- Profile management
- Sims 4 auto-discovery
- Path validation
- Privacy-focused design
- Mod manager coexistence

For support and updates, visit the project repository.
EOF

# Create simple launcher script (optional)
cat > "$PACKAGE_DIR/Launch TS4 Data Manager.bat" << 'EOF'
@echo off
cd /d "%~dp0"
start "" "ts4_data_manager.exe"
EOF

echo "Package created at: $PACKAGE_DIR"
echo ""
echo "Distribution contents:"
ls -la "$PACKAGE_DIR"

echo ""
echo "To distribute:"
echo "1. Zip the contents of $PACKAGE_DIR"
echo "2. Share the zip file with your tester"
echo "3. Tester extracts and runs ts4_data_manager.exe"

# Create zip if zip command is available
if command -v zip >/dev/null 2>&1; then
    echo ""
    echo "Creating ZIP package..."
    cd "$DIST_DIR"
    zip -r "TS4DataManager-Windows-v1.0.0.zip" "TS4DataManager-Windows/"
    echo "ZIP package created: $DIST_DIR/TS4DataManager-Windows-v1.0.0.zip"
fi