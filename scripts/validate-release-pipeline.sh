#!/bin/bash

# TS4 Data Manager - Release Pipeline Test Script
# This script helps validate the release pipeline setup

set -e  # Exit on any error

echo "🚀 TS4 Data Manager - Release Pipeline Validator"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_success() {
    print_status $GREEN "✅ $1"
}

print_warning() {
    print_status $YELLOW "⚠️  $1"
}

print_error() {
    print_status $RED "❌ $1"
}

print_info() {
    print_status $BLUE "ℹ️  $1"
}

# Validate we're in the right directory
if [[ ! -d "app" || ! -f ".github/workflows/build-and-release.yml" ]]; then
    print_error "This script must be run from the root of the TS4dataManager repository"
    exit 1
fi

print_success "Repository structure validated"

# Check Git repository status
print_info "Checking Git repository status..."
if ! git status >/dev/null 2>&1; then
    print_error "Not a Git repository or Git not available"
    exit 1
fi

# Check for remote origin
if ! git remote get-url origin >/dev/null 2>&1; then
    print_error "No remote origin configured"
    exit 1
fi

REMOTE_URL=$(git remote get-url origin)
print_success "Git repository configured with remote: $REMOTE_URL"

# Validate Flutter installation
print_info "Validating Flutter installation..."
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    print_info "Install Flutter from: https://flutter.dev/docs/get-started/install"
    exit 1
fi

FLUTTER_VERSION=$(flutter --version | head -n1)
print_success "Flutter installed: $FLUTTER_VERSION"

# Check Flutter configuration for desktop
print_info "Checking Flutter desktop configuration..."
if ! flutter config | grep -q "enable-linux-desktop: true\|enable-macos-desktop: true\|enable-windows-desktop: true"; then
    print_warning "Desktop platforms may not be enabled"
    print_info "Run: flutter config --enable-windows-desktop --enable-macos-desktop --enable-linux-desktop"
fi

# Validate app dependencies
print_info "Validating Flutter app dependencies..."
cd app
if ! flutter pub get >/dev/null 2>&1; then
    print_error "Failed to get Flutter dependencies"
    exit 1
fi
print_success "Flutter dependencies resolved"

# Run tests
print_info "Running Flutter tests..."
if ! flutter test >/dev/null 2>&1; then
    print_error "Flutter tests failed"
    print_info "Run 'flutter test' in the app directory for details"
    exit 1
fi
print_success "All Flutter tests passed"

# Try building for current platform
print_info "Testing build for current platform..."
cd ..
CURRENT_OS=""
if [[ "$OSTYPE" == "darwin"* ]]; then
    CURRENT_OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    CURRENT_OS="linux"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    CURRENT_OS="windows"
fi

if [[ -n "$CURRENT_OS" ]]; then
    print_info "Building for $CURRENT_OS..."
    cd app
    if flutter build $CURRENT_OS --release >/dev/null 2>&1; then
        print_success "Local build for $CURRENT_OS successful"
    else
        print_warning "Local build failed (this may be expected in some environments)"
    fi
    cd ..
fi

# Validate GitHub Actions workflow
print_info "Validating GitHub Actions workflow..."
WORKFLOW_FILE=".github/workflows/build-and-release.yml"
if [[ ! -f "$WORKFLOW_FILE" ]]; then
    print_error "GitHub Actions workflow file not found"
    exit 1
fi

# Check workflow syntax (basic YAML validation)
if ! python3 -c "import yaml; yaml.safe_load(open('$WORKFLOW_FILE'))" 2>/dev/null; then
    if ! python -c "import yaml; yaml.safe_load(open('$WORKFLOW_FILE'))" 2>/dev/null; then
        print_warning "Could not validate YAML syntax (Python/PyYAML not available)"
    else
        print_success "GitHub Actions workflow YAML is valid"
    fi
else
    print_success "GitHub Actions workflow YAML is valid"
fi

# Check for required workflow triggers
if grep -q "refs/tags" "$WORKFLOW_FILE"; then
    print_success "Release trigger configured (tags)"
else
    print_warning "No release trigger found in workflow"
fi

# Validate issue templates
print_info "Validating GitHub issue templates..."
TEMPLATE_DIR=".github/ISSUE_TEMPLATE"
if [[ -d "$TEMPLATE_DIR" ]]; then
    TEMPLATE_COUNT=$(find "$TEMPLATE_DIR" -name "*.md" | wc -l)
    print_success "Found $TEMPLATE_COUNT issue template(s)"
else
    print_warning "Issue templates directory not found"
fi

# Validate documentation
print_info "Validating project documentation..."
REQUIRED_DOCS=(
    "README.md"
    "CONTRIBUTING.md" 
    "LICENSE"
    "CODE_OF_CONDUCT.md"
    "SECURITY.md"
    "docs/BETA_TESTING.md"
)

for doc in "${REQUIRED_DOCS[@]}"; do
    if [[ -f "$doc" ]]; then
        print_success "Documentation: $doc"
    else
        print_warning "Missing documentation: $doc"
    fi
done

# Check for latest tags
print_info "Checking release tags..."
if git tag -l | grep -q "v"; then
    LATEST_TAG=$(git tag -l "v*" | sort -V | tail -n1)
    print_success "Latest release tag: $LATEST_TAG"
    
    # Check if tag is pushed to remote
    if git ls-remote --tags origin | grep -q "$LATEST_TAG"; then
        print_success "Tag pushed to remote - should trigger release build"
    else
        print_warning "Tag exists locally but not pushed to remote"
        print_info "Push with: git push origin $LATEST_TAG"
    fi
else
    print_warning "No release tags found"
    print_info "Create first release with: git tag -a v1.0.0-beta.1 -m 'First beta release'"
fi

# Summary
echo ""
echo "📋 Release Pipeline Validation Summary"
echo "======================================"

# Check GitHub Actions status (if gh CLI is available)
if command -v gh &> /dev/null; then
    print_info "Checking GitHub Actions status..."
    if gh run list --limit 5 >/dev/null 2>&1; then
        print_success "GitHub Actions accessible via gh CLI"
        echo ""
        print_info "Recent workflow runs:"
        gh run list --limit 5
    else
        print_warning "Could not access GitHub Actions (check 'gh auth status')"
    fi
else
    print_info "GitHub CLI not installed - cannot check Actions status"
    print_info "Install with: brew install gh (macOS) or visit https://cli.github.com/"
fi

echo ""
print_info "Manual checks to perform:"
echo "  1. Visit https://github.com/LarryAlexander/TS4dataManager/actions"
echo "  2. Verify workflow runs are successful"
echo "  3. Check https://github.com/LarryAlexander/TS4dataManager/releases for beta releases"
echo "  4. Test downloads from different platforms"

echo ""
print_success "Release pipeline validation complete!"
print_info "If all checks passed, your release pipeline is ready for beta testing!"