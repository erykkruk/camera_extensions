# camera_extended_ios

iOS implementation of [`camera_extended`](https://pub.dev/packages/camera_extended) with native aspect ratio support.

Built with AVFoundation.

## Features

This package extends the original `camera_avfoundation` with:

* **Native Aspect Ratio Selection** - Configure aspect ratio at AVFoundation level
* **Format Selection** - Automatically selects best format for requested ratio
* **Automatic Fallback** - Falls back to 4:3 when 1:1 not available

## Aspect Ratio Support

| Ratio | Support | Notes |
|-------|---------|-------|
| 16:9  | Native  | Full support |
| 4:3   | Native  | Full support |
| 1:1   | Fallback | Falls back to 4:3 (iOS has no native 1:1) |

## Usage

This package is automatically included when you use `camera_extended`.

```yaml
dependencies:
  camera_extended: ^0.11.3
```

## How It Works

The plugin uses AVFoundation's format selection:

```swift
// Select format matching aspect ratio
FormatUtils.selectBestFormatForAspectRatio(
  for: captureDevice,
  aspectRatio: mediaSettings.aspectRatio,
  resolutionPreset: mediaSettings.resolutionPreset,
  videoDimensionsConverter: videoDimensionsConverter
)
```

## Permissions

Add to `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access required.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access required.</string>
```

## Based On

Fork of [`camera_avfoundation`](https://pub.dev/packages/camera_avfoundation) version 0.9.22+8.
