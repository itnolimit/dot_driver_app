# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application named "dot_driver_app" - a standard Flutter project initialized with the default counter app template. The project uses Flutter SDK 3.9.0+ and follows standard Flutter conventions.

## Development Commands

### Package Management
- `flutter pub get` - Install dependencies
- `flutter pub upgrade` - Upgrade dependencies
- `flutter pub outdated` - Check for outdated packages

### Building and Running
- `flutter run` - Run the app in debug mode with hot reload
- `flutter run --release` - Run the app in release mode
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app (requires macOS)
- `flutter build web` - Build web app
- `flutter build windows` - Build Windows app
- `flutter build macos` - Build macOS app
- `flutter build linux` - Build Linux app

### Testing and Quality
- `flutter test` - Run all tests
- `flutter test test/widget_test.dart` - Run specific test file
- `flutter analyze` - Run static analysis and linting
- `flutter doctor` - Check Flutter installation and dependencies

### Development Tools
- `flutter clean` - Clean build artifacts
- `flutter devices` - List available devices
- `flutter logs` - Show device logs

## Project Structure

### Core Application
- `lib/main.dart` - Entry point with MaterialApp and counter demo
- `test/widget_test.dart` - Basic widget test for counter functionality

### Platform-Specific Code
- `android/` - Android platform configuration and native code
- `ios/` - iOS platform configuration and native code  
- `web/` - Web platform assets and configuration
- `windows/`, `linux/`, `macos/` - Desktop platform configurations

### Configuration
- `pubspec.yaml` - Project dependencies and Flutter configuration
- `analysis_options.yaml` - Static analysis rules using flutter_lints package

## Code Architecture

The current codebase follows the standard Flutter app template:
- Single-file application with StatefulWidget pattern
- Material Design UI components
- State management using setState() for simple counter logic
- Standard Flutter project structure for multi-platform support

## Dependencies

### Production Dependencies
- `flutter` - Flutter SDK
- `cupertino_icons` - iOS-style icons

### Development Dependencies  
- `flutter_test` - Testing framework
- `flutter_lints` - Linting rules for code quality

## Testing Strategy

- Widget tests using `flutter_test` package
- Basic smoke test for counter functionality
- Run tests with `flutter test` for the full suite