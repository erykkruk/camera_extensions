# camera_extended_platform_interface

Platform interface for [`camera_extended`](https://pub.dev/packages/camera_extended) plugin with native aspect ratio support.

## Features

This package extends the original `camera_platform_interface` with:

* **CameraAspectRatio enum** - Aspect ratio selection (16:9, 4:3, 1:1)
* **MediaSettings.aspectRatio** - Configure aspect ratio at sensor level

## Usage

This package is used by platform-specific implementations:
- [`camera_extended_android`](https://pub.dev/packages/camera_extended_android)
- [`camera_extended_ios`](https://pub.dev/packages/camera_extended_ios)

To implement a new platform-specific implementation, extend `CameraPlatform` with an implementation that performs the platform-specific behavior.

## API

```dart
/// Aspect ratio options for camera configuration.
enum CameraAspectRatio {
  ratio16x9,    // 16:9 widescreen
  ratio4x3,     // 4:3 standard
  ratio1x1,     // 1:1 square
  ratioDefault, // Camera's default
}

/// Media settings with aspect ratio support.
class MediaSettings {
  final ResolutionPreset? resolutionPreset;
  final int? fps;
  final int? videoBitrate;
  final int? audioBitrate;
  final bool enableAudio;
  final CameraAspectRatio aspectRatio; // NEW
}
```

## Based On

Fork of [`camera_platform_interface`](https://pub.dev/packages/camera_platform_interface) version 2.12.0.
