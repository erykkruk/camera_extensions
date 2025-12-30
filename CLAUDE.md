# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is `camera_extensions`, a Flutter package that extends the official [camera](https://pub.dev/packages/camera) package with additional features not available in the base implementation.

## Commands

```bash
# Get dependencies (library)
cd camera_extensions && flutter pub get

# Get dependencies (example app)
cd camera_extensions/example && flutter pub get

# Run the example app
cd camera_extensions/example && flutter run

# Analyze code
cd camera_extensions && flutter analyze

# Format code
cd camera_extensions && dart format .

# Run tests
cd camera_extensions && flutter test
```

## Architecture

The library provides Dart extensions and widgets that enhance the `camera` package functionality without modifying native code.

### Core Components

**Extensions** (`lib/src/extensions/`):
- `camera_controller_extensions.dart` - Extensions on `CameraController` for aspect ratio support and other utilities

**Widgets** (`lib/src/widgets/`):
- `camera_preview_aspect_ratio.dart` - Widget for displaying camera preview with custom aspect ratio
- `widgets.dart` - Barrel file exporting all widgets

**Models** (`lib/src/models/`):
- `camera_aspect_ratio.dart` - Enum and utilities for common aspect ratios (16:9, 4:3, 1:1, etc.)

**Library Entry Point** (`lib/camera_extensions.dart`):
- Exports all public APIs

### Data Flow

1. User initializes `CameraController` from the base `camera` package
2. Extensions provide additional methods/getters on the controller
3. Custom widgets wrap `CameraPreview` with additional functionality
4. Aspect ratio calculations ensure proper display regardless of native camera ratio

### Feature: Aspect Ratio Support

The camera package displays preview in the camera's native aspect ratio. This extension provides:
- `CameraController.aspectRatio` getter - returns current camera aspect ratio
- `CameraPreviewAspectRatio` widget - displays preview with enforced aspect ratio
- `CameraAspectRatio` enum - predefined ratios (ratio16x9, ratio4x3, ratio1x1, etc.)
- Letterboxing/pillarboxing support for non-matching ratios

### Example App Structure

The example app (`example/`) demonstrates:
- Camera initialization and lifecycle management
- Aspect ratio switching at runtime
- Preview with different aspect ratio configurations
