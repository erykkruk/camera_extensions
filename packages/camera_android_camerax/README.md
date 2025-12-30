# camera_extended_android

Android implementation of [`camera_extended`](https://pub.dev/packages/camera_extended) with native aspect ratio support.

Built with the [CameraX library](https://developer.android.com/training/camerax).

## Features

This package extends the original `camera_android_camerax` with:

* **Native Aspect Ratio Selection** - Configure aspect ratio at CameraX level
* **Native 1:1 Square Support** - Uses native square formats (1088x1088, 720x720)
* **Automatic Fallback** - Falls back to 4:3 when requested ratio not available

## Aspect Ratio Support

| Ratio | Support | Resolution Examples |
|-------|---------|---------------------|
| 16:9  | Native  | 1920x1080, 1280x720 |
| 4:3   | Native  | 1440x1080, 640x480  |
| 1:1   | Native  | 1088x1088, 720x720  |

## Usage

This package is automatically included when you use `camera_extended`.

```yaml
dependencies:
  camera_extended: ^0.11.3
```

## How It Works

The plugin uses CameraX's `ResolutionSelector` with `AspectRatioStrategy`:

```kotlin
// For 1:1, requests native square format
ResolutionSelector(
  resolutionStrategy: ResolutionStrategy(
    boundSize: Size(1088, 1088),
    fallbackRule: CLOSEST_HIGHER_THEN_LOWER
  ),
  aspectRatioStrategy: AspectRatioStrategy(
    preferredAspectRatio: RATIO_4_3, // fallback
    fallbackRule: AUTO
  )
)
```

## Permissions

Add to `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

## Based On

Fork of [`camera_android_camerax`](https://pub.dev/packages/camera_android_camerax) version 0.6.26+2.
