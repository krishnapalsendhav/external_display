## 0.0.4

* Fix: Removed duplicate Objective-C wrapper files (ExternalDisplayPlugin.h and ExternalDisplayPlugin.m)
* This resolves the "Duplicate interface definition for class 'ExternalDisplayPlugin'" build error on iOS
* The Swift implementation handles plugin registration directly

## 0.0.3

* Fix: Updated Swift bridging header imports in ExternalDisplayPlugin.m to use `external_screen-Swift.h` instead of `external_display-Swift.h`
* This resolves the "file not found" build error on iOS

## 0.0.2

* Fix: Renamed iOS podspec file from `external_display.podspec` to `external_screen.podspec` to match package name
* Fix: Updated podspec metadata with correct package information
* This resolves the "No podspec found" error when running `pod install`

## 0.0.1

* Initial release
* Support for detecting external displays on Android and iOS
* Show Flutter UI on secondary displays
* Transfer data between main and secondary displays
* Monitor display connection/disconnection events
* Android: API Level 36, Java 17, Kotlin 1.9.22
* iOS: iOS 13.0+, Swift 5.0
* Comprehensive example app demonstrating all features
* Full test coverage with 6 unit tests
