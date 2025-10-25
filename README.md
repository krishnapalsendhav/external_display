# External Display

A Flutter plugin for managing external displays on Android and iOS. This plugin allows you to detect, show content on, and transfer data to secondary displays like HDMI monitors, wireless displays, and external screens.

[![pub package](https://img.shields.io/pub/v/external_display.svg)](https://pub.dev/packages/external_display)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

✨ **Platform Support**
- ✅ Android (API 21+, optimized for API 36 with Java 17)
- ✅ iOS (iOS 13.0+)

🎯 **Capabilities**
- 🖥️ Detect connected external displays
- 📺 Show Flutter UI on secondary displays
- 📤 Transfer data between main and secondary displays
- 🔌 Monitor display connection/disconnection events
- ��️ Support for multiple display categories (Android)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  external_display: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Platform Configuration

### Android

The plugin is configured with:
- **Minimum SDK**: 21
- **Target SDK**: 36
- **Compile SDK**: 36
- **Java**: 17
- **Kotlin**: 1.9.22

No additional configuration required.

### iOS

**Minimum iOS version**: 13.0

No additional configuration required.

## Quick Start

### 1. Import the package

```dart
import 'package:external_display/display_manager.dart';
import 'package:external_display/display.dart';
import 'package:external_display/secondary_display.dart';
```

### 2. List available displays

```dart
final DisplayManager displayManager = DisplayManager();

// Get all displays
List<Display>? displays = await displayManager.getDisplays();

// Display information
for (var display in displays ?? []) {
  print('Display ID: ${display.displayId}');
  print('Name: ${display.name}');
}
```

### 3. Show content on external display

```dart
// Show presentation
await displayManager.showSecondaryDisplay(
  displayId: displayId,
  routerName: '/presentation',
);
```

### 4. Transfer data

```dart
await displayManager.transferDataToPresentation({
  'message': 'Hello External Display!',
  'value': 42,
});
```

## Complete Example

See the [example](example) directory for a complete working app.

## API Reference

### DisplayManager

| Method | Description |
|--------|-------------|
| `getDisplays()` | Get list of available displays |
| `showSecondaryDisplay()` | Show presentation on display |
| `hideSecondaryDisplay()` | Hide presentation |
| `transferDataToPresentation()` | Send data to presentation |
| `connectedDisplaysChangedStream` | Monitor connection events |

## License

MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Krishna Pal Sendhav

## Support

- 🐛 [Issue Tracker](https://github.com/krishnapalsendhav/external_display/issues)
- 📝 [Documentation](https://pub.dev/packages/external_display)
