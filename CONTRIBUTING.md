# Contributing to External Display

Thank you for your interest in contributing to External Display! We welcome contributions from the community.

## How to Contribute

### Reporting Bugs

If you find a bug, please create an issue on GitHub with:
- A clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Device/OS information
- Flutter and Dart versions

### Suggesting Features

We love feature suggestions! Please create an issue describing:
- The feature you'd like to see
- Why it would be useful
- Possible implementation approach

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Add tests for your changes
5. Ensure all tests pass (`flutter test`)
6. Run `flutter analyze` and fix any issues
7. Commit your changes (`git commit -m 'Add amazing feature'`)
8. Push to your branch (`git push origin feature/amazing-feature`)
9. Open a Pull Request

### Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Add comments for complex logic
- Write tests for new features

### Testing

- All new features must include tests
- Ensure existing tests still pass
- Test on both Android and iOS if possible

### Documentation

- Update README.md if adding user-facing features
- Update CHANGELOG.md following Keep a Changelog format
- Add inline documentation for public APIs

## Development Setup

```bash
# Clone the repository
git clone https://github.com/krishnapalsendhav/external_display.git
cd external_display

# Get dependencies
flutter pub get

# Run tests
flutter test

# Run example
cd example
flutter run
```

## Questions?

Feel free to ask questions by creating an issue or discussion on GitHub.

Thank you for contributing! 🎉
