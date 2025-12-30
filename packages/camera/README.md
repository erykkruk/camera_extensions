# camera_extended

Extended Flutter camera plugin with **native aspect ratio support** (16:9, 4:3, 1:1).

Fork of the official [camera](https://pub.dev/packages/camera) package with sensor-level aspect ratio configuration for both iOS and Android.

|                | Android | iOS       |
|----------------|---------|-----------|
| **Support**    | SDK 24+ | iOS 13.0+ |

## What's New vs Original Camera Package

| Feature | camera | camera_extended |
|---------|--------|-----------------|
| Aspect Ratio Control | No | **Yes** (16:9, 4:3, 1:1) |
| Native 1:1 Square | No | **Yes** (Android) |
| Sensor-Level Config | No | **Yes** |

## Features

- **Native Aspect Ratio Selection** - Configure camera aspect ratio at the sensor level
- **1:1 Square Format** - Native 1:1 on Android (1088x1088), falls back to 4:3 on iOS
- **4:3 Standard Format** - Classic aspect ratio with wider field of view
- **16:9 Widescreen Format** - Modern widescreen ratio
- Full compatibility with original `camera` package API

## Why This Package?

The standard `camera` package doesn't allow you to configure the aspect ratio at the native level. This package extends it to:

1. Request specific aspect ratios from the camera sensor
2. Get wider field of view with 4:3 or 1:1 vs 16:9
3. Capture square photos/videos natively on supported devices

### Aspect Ratio Comparison

| Ratio | Field of View | Use Case |
|-------|---------------|----------|
| 16:9  | Narrowest     | Video, Widescreen |
| 4:3   | Wider         | Photos, Standard |
| 1:1   | Square        | Social Media, Profile Photos |

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  camera_extended: ^1.0.0
```

## Usage

### Basic Setup

```dart
import 'package:camera_extended/camera_extended.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}
```

### Initialize with Aspect Ratio

```dart
final controller = CameraController(
  cameras.first,
  ResolutionPreset.high,
  enableAudio: false,
  aspectRatio: CameraAspectRatio.ratio4x3, // NEW: aspect ratio parameter
);

await controller.initialize();
```

### Available Aspect Ratios

```dart
enum CameraAspectRatio {
  ratio16x9,    // 16:9 widescreen
  ratio4x3,     // 4:3 standard
  ratio1x1,     // 1:1 square
  ratioDefault, // Camera's default ratio
}
```

### Complete Example

```dart
import 'package:camera_extended/camera_extended.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const CameraApp());
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController? _controller;
  CameraAspectRatio _aspectRatio = CameraAspectRatio.ratio4x3;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    await _controller?.dispose();

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      aspectRatio: _aspectRatio, // Set aspect ratio here
    );

    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  void _changeAspectRatio(CameraAspectRatio ratio) {
    setState(() => _aspectRatio = ratio);
    _initCamera(); // Reinitialize camera with new ratio
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: _controller?.value.isInitialized == true
                  ? CameraPreview(_controller!)
                  : const Center(child: CircularProgressIndicator()),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SegmentedButton<CameraAspectRatio>(
                segments: const [
                  ButtonSegment(value: CameraAspectRatio.ratio16x9, label: Text('16:9')),
                  ButtonSegment(value: CameraAspectRatio.ratio4x3, label: Text('4:3')),
                  ButtonSegment(value: CameraAspectRatio.ratio1x1, label: Text('1:1')),
                ],
                selected: {_aspectRatio},
                onSelectionChanged: (selected) => _changeAspectRatio(selected.first),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Platform Support

| Platform | 16:9 | 4:3 | 1:1 |
|----------|------|-----|-----|
| Android  | Native | Native | Native (1088x1088) |
| iOS      | Native | Native | Fallback to 4:3 |

### Android

Uses CameraX with `ResolutionSelector` to request specific aspect ratios. Many Android devices support native 1:1 formats (e.g., 1088x1088, 720x720).

### iOS

Uses AVFoundation with format selection based on aspect ratio. iOS cameras typically don't offer native 1:1 formats, so 1:1 falls back to 4:3.

## Permissions

### Android

Add to `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

### iOS

Add to `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for taking photos.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required for recording video.</string>
```

## Migration from `camera` Package

This package is API-compatible with the original `camera` package. To migrate:

1. Replace `camera` with `camera_extended` in `pubspec.yaml`
2. Update imports: `import 'package:camera_extended/camera_extended.dart'`
3. Optionally add `aspectRatio` parameter to `CameraController`

```dart
// Before (camera package)
import 'package:camera/camera.dart';
CameraController(camera, ResolutionPreset.high);

// After (camera_extended)
import 'package:camera_extended/camera_extended.dart';
CameraController(camera, ResolutionPreset.high, aspectRatio: CameraAspectRatio.ratio4x3);
```

## Handling Lifecycle States

Same as the original camera package - you need to handle lifecycle changes:

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  final CameraController? cameraController = controller;

  if (cameraController == null || !cameraController.value.isInitialized) {
    return;
  }

  if (state == AppLifecycleState.inactive) {
    cameraController.dispose();
  } else if (state == AppLifecycleState.resumed) {
    _initCamera();
  }
}
```

## License

BSD 3-Clause License - same as the original Flutter camera package.

## Credits

Based on the official [Flutter camera plugin](https://pub.dev/packages/camera) by the Flutter team.

Extended with native aspect ratio support.
