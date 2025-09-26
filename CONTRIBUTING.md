# Contributing to TS4 Data Manager

Thank you for your interest in contributing to TS4 Data Manager! This document provides guidelines for contributing to the project.

## 🎯 Ways to Contribute

### 🧪 Beta Testing

- Download and test beta releases
- Report bugs using our [bug report template](https://github.com/YOUR_USERNAME/TS4dataManager/issues/new?template=bug_report.md)
- Provide feedback using our [beta feedback template](https://github.com/YOUR_USERNAME/TS4dataManager/issues/new?template=beta_feedback.md)

### 🐛 Bug Reports

- Use the [bug report template](https://github.com/YOUR_USERNAME/TS4dataManager/issues/new?template=bug_report.md)
- Include detailed steps to reproduce
- Specify your environment (OS, Sims 4 version, etc.)
- Add screenshots when helpful

### 💡 Feature Requests

- Use the [feature request template](https://github.com/YOUR_USERNAME/TS4dataManager/issues/new?template=feature_request.md)
- Explain the problem your feature would solve
- Describe your proposed solution
- Consider alternative approaches

### 💻 Code Contributions

- Fork the repository
- Create a feature branch (`git checkout -b feature/amazing-feature`)
- Make your changes
- Add tests if applicable
- Commit with clear messages
- Push to your branch
- Open a Pull Request

## 🏗 Development Setup

### Prerequisites

- Flutter 3.35.2+
- Dart 3.9.0+
- Git

### Platform-specific Requirements

- **Windows**: Visual Studio 2019+ with C++ tools
- **macOS**: Xcode 12+
- **Linux**: `ninja-build`, `libgtk-3-dev`

### Getting Started

```bash
# Clone your fork
git clone https://github.com/YOUR_FORK/TS4dataManager.git
cd TS4dataManager

# Install Flutter dependencies
cd app
flutter pub get

# Run tests
flutter test

# Run the app
flutter run -d windows/macos/linux
```

## 📝 Code Style

### Dart/Flutter Guidelines

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter analyze` to check for lint issues
- Format code with `dart format .`
- Add documentation comments for public APIs

### Commit Messages

Use conventional commit format:

```
type(scope): description

feat(profiles): add profile export functionality
fix(discovery): handle Sims 4 paths with special characters
docs(readme): update installation instructions
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

## 🔍 Pull Request Process

1. **Fork & Branch**: Create a feature branch from `main`
2. **Develop**: Make your changes with appropriate tests
3. **Test**: Ensure all tests pass (`flutter test`)
4. **Lint**: Check code style (`flutter analyze`)
5. **Document**: Update documentation if needed
6. **PR**: Open a Pull Request with:
   - Clear title and description
   - Link to related issues
   - Screenshots for UI changes
   - Testing instructions

### PR Checklist

- [ ] Code follows style guidelines
- [ ] Tests added/updated and passing
- [ ] Documentation updated
- [ ] No breaking changes (or clearly documented)
- [ ] Tested on target platforms

## 🧪 Testing Guidelines

### Types of Tests

- **Unit Tests**: Test individual functions/classes
- **Widget Tests**: Test UI components
- **Integration Tests**: Test complete workflows

### Running Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/models/profile_test.dart

# With coverage
flutter test --coverage
```

### Test Expectations

- New features should include tests
- Bug fixes should include regression tests
- Maintain >80% code coverage
- Tests should be reliable and fast

## 📦 Release Process

### Versioning

We use [Semantic Versioning](https://semver.org/):

- `MAJOR.MINOR.PATCH` (e.g., `1.0.0`)
- `MAJOR.MINOR.PATCH-beta.N` for beta releases
- `MAJOR.MINOR.PATCH-alpha.N` for alpha releases

### Release Types

- **Alpha**: Early development, may have significant bugs
- **Beta**: Feature-complete but needs testing
- **Stable**: Production-ready releases

### Automated Releases

- Push tags trigger automated builds
- GitHub Actions builds all platforms
- Artifacts uploaded to GitHub Releases

## 🏷 Labels and Workflow

### Issue Labels

- `bug`: Something isn't working
- `enhancement`: New feature or improvement
- `beta`: Beta testing related
- `good first issue`: Good for new contributors
- `help wanted`: Community help needed
- `needs-triage`: Needs initial review
- `priority-high/medium/low`: Priority levels

### Project Phases

- **Phase 1**: Foundation (Profile management) ✅
- **Phase 2**: Core Features (Snapshots, tracking)
- **Phase 3**: Advanced Features (Mod manager integration)

## 🤝 Community Guidelines

### Code of Conduct

- Be respectful and inclusive
- Assume positive intent
- Focus on constructive feedback
- Help newcomers get started

### Communication

- **Issues**: Bug reports and feature requests
- **Discussions**: General questions and ideas
- **Pull Requests**: Code changes and reviews

## 📚 Resources

### Documentation

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design Guidelines](https://material.io/design)

### Project Architecture

- Models: Data structures (`lib/models/`)
- Services: Business logic (`lib/services/`)
- Platform: OS-specific utilities (`lib/platform/`)
- UI: Flutter widgets (`lib/widgets/`, `lib/pages/`)

## ❓ Questions?

- **General Questions**: [Start a discussion](https://github.com/YOUR_USERNAME/TS4dataManager/discussions)
- **Bug Reports**: [Create an issue](https://github.com/YOUR_USERNAME/TS4dataManager/issues)
- **Beta Testing**: Join our beta program through releases

---

Thank you for contributing to TS4 Data Manager! 🎉
