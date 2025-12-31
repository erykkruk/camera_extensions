# camera_extended API Reference

Complete API documentation for the camera_extended package.

## Table of Contents

- [Overview](#overview)
- [CameraController](#cameracontroller)
- [CameraAspectRatio](#cameraaspectratio)
- [CameraPreview](#camerapreview)
- [Other Exports](#other-exports)
- [Usage Examples](#usage-examples)
- [Platform Notes](#platform-notes)

---

## Overview

`camera_extended` is a fork of the official Flutter camera plugin with native aspect ratio support. It provides the same API as the original `camera` package, plus the ability to configure aspect ratio at the sensor level.

### Quick Start

```dart
import 'package:camera_extended/camera_extended.dart';

// Initialize with aspect ratio
final controller = CameraController(
  cameras.first,
  ResolutionPreset.high,
  aspectRatio: CameraAspectRatio.ratio4x3, // NEW parameter
);

await controller.initialize();
```

---

## CameraController

Extended `CameraController` with aspect ratio support.

### Constructor

```dart
CameraController(
  CameraDescription description,
  ResolutionPreset? resolutionPreset, {
  bool enableAudio = true,
  ImageFormatGroup? imageFormatGroup,
  CameraAspectRatio aspectRatio = CameraAspectRatio.ratioDefault, // NEW
})
```

### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `description` | `CameraDescription` | Yes | - | Camera to use |
| `resolutionPreset` | `ResolutionPreset?` | Yes | - | Resolution quality preset |
| `enableAudio` | `bool` | No | `true` | Enable audio recording |
| `imageFormatGroup` | `ImageFormatGroup?` | No | `null` | Image format for streaming |
| `aspectRatio` | `CameraAspectRatio` | No | `ratioDefault` | **NEW:** Aspect ratio configuration |

### Properties

| Property | Type | Description |
|----------|------|-------------|
| `value` | `CameraValue` | Current camera state |
| `description` | `CameraDescription` | Camera description |
| `resolutionPreset` | `ResolutionPreset?` | Resolution preset |

### Methods

| Method | Return Type | Description |
|--------|-------------|-------------|
| `initialize()` | `Future<void>` | Initialize camera |
| `dispose()` | `Future<void>` | Dispose camera resources |
| `takePicture()` | `Future<XFile>` | Take a picture |
| `startVideoRecording()` | `Future<void>` | Start video recording |
| `stopVideoRecording()` | `Future<XFile>` | Stop video and get file |
| `pauseVideoRecording()` | `Future<void>` | Pause recording |
| `resumeVideoRecording()` | `Future<void>` | Resume recording |
| `setFlashMode(FlashMode)` | `Future<void>` | Set flash mode |
| `setExposureMode(ExposureMode)` | `Future<void>` | Set exposure mode |
| `setFocusMode(FocusMode)` | `Future<void>` | Set focus mode |
| `lockCaptureOrientation(DeviceOrientation)` | `Future<void>` | Lock orientation |
| `unlockCaptureOrientation()` | `Future<void>` | Unlock orientation |

### Example

```dart
final controller = CameraController(
  cameras.first,
  ResolutionPreset.high,
  enableAudio: false,
  aspectRatio: CameraAspectRatio.ratio4x3,
);

await controller.initialize();

// Take picture
final file = await controller.takePicture();

// Cleanup
await controller.dispose();
```

---

## CameraAspectRatio

Enum for selecting camera aspect ratio at the sensor level.

```dart
enum CameraAspectRatio {
  ratio16x9,    // 16:9 widescreen
  ratio4x3,     // 4:3 standard
  ratio1x1,     // 1:1 square
  ratioDefault, // Camera's default ratio
}
```

### Values

| Value | Numeric Ratio | Description | Use Case |
|-------|---------------|-------------|----------|
| `ratio16x9` | 1.777... | Widescreen format | Video, YouTube, TV |
| `ratio4x3` | 1.333... | Standard format | Photos, documents |
| `ratio1x1` | 1.0 | Square format | Social media, profiles |
| `ratioDefault` | Varies | Camera's native ratio | Default behavior |

### Platform Support

| Ratio | Android | iOS |
|-------|---------|-----|
| `ratio16x9` | Native | Native |
| `ratio4x3` | Native | Native |
| `ratio1x1` | Native (1088x1088, 720x720) | Fallback to 4:3 |
| `ratioDefault` | Native | Native |

### Example

```dart
// Widescreen for video
CameraController(camera, ResolutionPreset.high,
  aspectRatio: CameraAspectRatio.ratio16x9,
);

// Standard for photos
CameraController(camera, ResolutionPreset.high,
  aspectRatio: CameraAspectRatio.ratio4x3,
);

// Square for social media
CameraController(camera, ResolutionPreset.high,
  aspectRatio: CameraAspectRatio.ratio1x1,
);

// Let camera decide
CameraController(camera, ResolutionPreset.high,
  aspectRatio: CameraAspectRatio.ratioDefault,
);
```

---

## CameraPreview

Widget for displaying the camera preview.

```dart
class CameraPreview extends StatelessWidget
```

### Constructor

```dart
const CameraPreview(
  CameraController controller, {
  Widget? child,
})
```

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `controller` | `CameraController` | Yes | Initialized camera controller |
| `child` | `Widget?` | No | Optional overlay widget |

### Example

```dart
if (controller.value.isInitialized) {
  CameraPreview(controller);
}

// With overlay
CameraPreview(
  controller,
  child: Center(
    child: Icon(Icons.camera, color: Colors.white),
  ),
);
```

---

## Other Exports

The package re-exports common types from the platform interface:

### Enums

| Enum | Values | Description |
|------|--------|-------------|
| `CameraLensDirection` | `front`, `back`, `external` | Camera position |
| `CameraLensType` | Various | Lens type (wide, ultrawide, telephoto) |
| `ResolutionPreset` | `low`, `medium`, `high`, `veryHigh`, `ultraHigh`, `max` | Video quality |
| `FlashMode` | `off`, `auto`, `always`, `torch` | Flash settings |
| `ExposureMode` | `auto`, `locked` | Exposure settings |
| `FocusMode` | `auto`, `locked` | Focus settings |
| `ImageFormatGroup` | `unknown`, `jpeg`, `yuv420`, `bgra8888`, `nv21` | Image format |

### Classes

| Class | Description |
|-------|-------------|
| `CameraDescription` | Camera device descriptor |
| `CameraException` | Camera error type |
| `XFile` | Cross-platform file reference |

### Functions

| Function | Return Type | Description |
|----------|-------------|-------------|
| `availableCameras()` | `Future<List<CameraDescription>>` | Get available cameras |

---

## Usage Examples

### Basic Camera Setup

```dart
import 'package:camera_extended/camera_extended.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      aspectRatio: CameraAspectRatio.ratio4x3,
    );

    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller?.value.isInitialized != true) {
      return const Center(child: CircularProgressIndicator());
    }

    return CameraPreview(_controller!);
  }
}
```

### Switching Aspect Ratios

```dart
class AspectRatioSwitcher extends StatefulWidget {
  const AspectRatioSwitcher({super.key});

  @override
  State<AspectRatioSwitcher> createState() => _AspectRatioSwitcherState();
}

class _AspectRatioSwitcherState extends State<AspectRatioSwitcher> {
  CameraController? _controller;
  CameraAspectRatio _ratio = CameraAspectRatio.ratio4x3;

  Future<void> _initCamera() async {
    await _controller?.dispose();

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      aspectRatio: _ratio,
    );

    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  void _switchRatio(CameraAspectRatio ratio) {
    setState(() => _ratio = ratio);
    _initCamera(); // Must reinitialize to change ratio
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _controller?.value.isInitialized == true
              ? CameraPreview(_controller!)
              : const CircularProgressIndicator(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _switchRatio(CameraAspectRatio.ratio16x9),
              child: const Text('16:9'),
            ),
            ElevatedButton(
              onPressed: () => _switchRatio(CameraAspectRatio.ratio4x3),
              child: const Text('4:3'),
            ),
            ElevatedButton(
              onPressed: () => _switchRatio(CameraAspectRatio.ratio1x1),
              child: const Text('1:1'),
            ),
          ],
        ),
      ],
    );
  }
}
```

### Taking Pictures

```dart
Future<void> _takePicture() async {
  if (_controller?.value.isInitialized != true) return;

  try {
    final file = await _controller!.takePicture();
    print('Picture saved to: ${file.path}');
  } on CameraException catch (e) {
    print('Error taking picture: ${e.description}');
  }
}
```

### Recording Video

```dart
Future<void> _startRecording() async {
  if (_controller?.value.isRecordingVideo == true) return;

  await _controller!.startVideoRecording();
}

Future<void> _stopRecording() async {
  if (_controller?.value.isRecordingVideo != true) return;

  final file = await _controller!.stopVideoRecording();
  print('Video saved to: ${file.path}');
}
```

---

## Platform Notes

### Android

- **Minimum SDK:** 24
- **Implementation:** CameraX with `ResolutionSelector`
- **1:1 Support:** Native square formats (1088x1088, 720x720)
- **Fallback:** Falls back to 4:3 when exact ratio unavailable

### iOS

- **Minimum iOS:** 13.0
- **Implementation:** AVFoundation with format selection
- **1:1 Support:** Fallback to 4:3 (iOS has no native 1:1 formats)
- **Fallback:** Uses closest available format

### Permissions

**Android** (`android/app/src/main/AndroidManifest.xml`):

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

**iOS** (`ios/Runner/Info.plist`):

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access required</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access required for video</string>
```

---

## Changelog

See [CHANGELOG.md](../packages/camera/CHANGELOG.md) for version history.

## License

BSD 3-Clause License - same as the original Flutter camera package.
