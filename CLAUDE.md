# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is `camera_extended`, a fork of the official Flutter [camera](https://pub.dev/packages/camera) package with native aspect ratio support (16:9, 4:3, 1:1). It provides sensor-level aspect ratio configuration for both iOS and Android.

## Commands

```bash
# Get dependencies (main package)
cd packages/camera && flutter pub get

# Get dependencies (example app)
cd example && flutter pub get

# Run the example app
cd example && flutter run

# Analyze code
flutter analyze

# Format code
dart format .

# Run tests (main package)
cd packages/camera && flutter test

# Run tests (Android)
cd packages/camera_android_camerax && flutter test

# Run tests (iOS)
cd packages/camera_avfoundation && flutter test
```

## Architecture

This is a monorepo containing multiple Flutter packages that together implement camera functionality with native aspect ratio support.

### Package Structure

```
camera_extensions/
├── packages/
│   ├── camera/                      # camera_extended - Main plugin (federated)
│   ├── camera_platform_interface/   # camera_extended_platform_interface
│   ├── camera_android_camerax/      # camera_extended_android - Android impl
│   └── camera_avfoundation/         # camera_extended_ios - iOS impl
├── example/                         # Example app demonstrating the plugin
└── doc/                             # API documentation
```

### Package Versions

| Package | Version | Description |
|---------|---------|-------------|
| `camera_extended` | 0.11.11 | Main federated plugin |
| `camera_extended_platform_interface` | 2.12.2 | Platform interface with CameraAspectRatio |
| `camera_extended_android` | 0.6.29 | Android CameraX implementation |
| `camera_extended_ios` | 0.9.30 | iOS AVFoundation implementation |

### Core Components

**Platform Interface** (`packages/camera_platform_interface/`):
- `CameraAspectRatio` enum - Aspect ratio options (ratio16x9, ratio4x3, ratio1x1, ratioDefault)
- `MediaSettings` - Extended with `aspectRatio` parameter
- `CameraPlatform` - Platform abstraction

**Main Plugin** (`packages/camera/`):
- `CameraController` - Extended with `aspectRatio` parameter
- `CameraPreview` - Camera preview widget
- Re-exports platform interface types

**Android Implementation** (`packages/camera_android_camerax/`):
- Uses CameraX with `ResolutionSelector` and `AspectRatioStrategy`
- Native support for 1:1 square formats (1088x1088, 720x720)
- Kotlin native code in `android/src/main/kotlin/`

**iOS Implementation** (`packages/camera_avfoundation/`):
- Uses AVFoundation with format selection based on aspect ratio
- Falls back to 4:3 for 1:1 (iOS has no native square formats)
- Swift native code in `ios/camera_avfoundation/Sources/`

### Data Flow

1. User creates `CameraController` with optional `aspectRatio` parameter
2. `CameraController` passes `MediaSettings` (with aspect ratio) to platform implementation
3. Platform implementation (Android/iOS) configures native camera with requested ratio
4. Native camera captures at the requested aspect ratio at sensor level

### Key Feature: Native Aspect Ratio

Unlike the original camera package which only displays at camera's native ratio, this fork:
- Requests specific aspect ratios from the camera sensor
- On Android: Uses CameraX ResolutionSelector to find native formats
- On iOS: Uses AVFoundation format selection
- Fallback: Uses closest available ratio when exact match unavailable

### Aspect Ratio Support by Platform

| Ratio | Android | iOS |
|-------|---------|-----|
| 16:9 | Native | Native |
| 4:3 | Native | Native |
| 1:1 | Native (1088x1088) | Fallback to 4:3 |

### Example App

The example app (`example/`) demonstrates:
- Camera initialization with aspect ratio
- Aspect ratio switching (requires camera reinitialization)
- Photo and video capture
- Flash and exposure controls
