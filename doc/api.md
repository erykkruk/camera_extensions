# camera_extensions API Reference

Complete API documentation for the camera_extensions package.

## Table of Contents

- [Extensions](#extensions)
  - [CameraControllerExtensions](#cameracontrollerextensions)
- [Widgets](#widgets)
  - [CameraPreviewAspectRatio](#camerapreviewaspectratio)
- [Models](#models)
  - [CameraAspectRatio](#cameraaspectratio)
  - [CameraPreviewFit](#camerapreviewfit)
- [Usage Examples](#usage-examples)

---

## Extensions

### CameraControllerExtensions

Extensions on `CameraController` from the camera package.

```dart
extension CameraControllerExtensions on CameraController
```

#### Properties

##### aspectRatio

```dart
double get aspectRatio
```

Returns the camera's native aspect ratio (width / height).

| Returns | Description |
|---------|-------------|
| `double` | Aspect ratio value (e.g., 1.777... for 16:9) |

**Example:**

```dart
final controller = CameraController(camera, ResolutionPreset.high);
await controller.initialize();

final ratio = controller.aspectRatio;
print('Camera aspect ratio: $ratio'); // e.g., 1.7777777777777777
```

##### previewSize

```dart
Size get previewSize
```

Returns the preview size in pixels.

| Returns | Description |
|---------|-------------|
| `Size` | Preview dimensions (width x height) |

**Example:**

```dart
final size = controller.previewSize;
print('Preview: ${size.width}x${size.height}'); // e.g., 1920x1080
```

---

## Widgets

### CameraPreviewAspectRatio

A widget that displays the camera preview with a controlled aspect ratio.

```dart
class CameraPreviewAspectRatio extends StatelessWidget
```

#### Constructor

```dart
const CameraPreviewAspectRatio({
  super.key,
  required this.controller,
  required this.aspectRatio,
  this.fit = CameraPreviewFit.contain,
  this.backgroundColor = Colors.black,
})
```

#### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `controller` | `CameraController` | Yes | - | Initialized camera controller |
| `aspectRatio` | `CameraAspectRatio` | Yes | - | Desired aspect ratio for preview |
| `fit` | `CameraPreviewFit` | No | `contain` | How preview fits in container |
| `backgroundColor` | `Color` | No | `Colors.black` | Color for letterbox/pillarbox areas |

#### Behavior

- **contain** mode: Shows the entire preview within the aspect ratio box, adding letterbox (horizontal bars) or pillarbox (vertical bars) as needed
- **cover** mode: Fills the entire aspect ratio box, cropping the preview if necessary

#### Example

```dart
CameraPreviewAspectRatio(
  controller: _controller,
  aspectRatio: CameraAspectRatio.ratio16x9,
  fit: CameraPreviewFit.contain,
  backgroundColor: Colors.black,
)
```

---

## Models

### CameraAspectRatio

Represents a camera preview aspect ratio.

```dart
sealed class CameraAspectRatio
```

#### Factory Constructors

##### ratio16x9

```dart
const factory CameraAspectRatio.ratio16x9()
```

Widescreen 16:9 aspect ratio (1.777...). Common for HD video.

##### ratio4x3

```dart
const factory CameraAspectRatio.ratio4x3()
```

Standard 4:3 aspect ratio (1.333...). Classic photo format.

##### ratio1x1

```dart
const factory CameraAspectRatio.ratio1x1()
```

Square 1:1 aspect ratio (1.0). Instagram-style.

##### ratio3x2

```dart
const factory CameraAspectRatio.ratio3x2()
```

Classic 3:2 aspect ratio (1.5). 35mm film format.

##### ratio21x9

```dart
const factory CameraAspectRatio.ratio21x9()
```

Ultra-wide 21:9 aspect ratio (2.333...). Cinematic format.

##### custom

```dart
const factory CameraAspectRatio.custom(double value)
```

Custom aspect ratio with any value.

| Parameter | Type | Description |
|-----------|------|-------------|
| `value` | `double` | Custom aspect ratio value (width / height) |

**Example:**

```dart
// Cinemascope 2.35:1
CameraAspectRatio.custom(2.35)

// IMAX 1.43:1
CameraAspectRatio.custom(1.43)
```

##### native

```dart
factory CameraAspectRatio.native(CameraController controller)
```

Uses the camera's native aspect ratio from the controller.

| Parameter | Type | Description |
|-----------|------|-------------|
| `controller` | `CameraController` | Initialized camera controller |

#### Properties

##### value

```dart
double get value
```

Returns the numeric aspect ratio value.

| Ratio | Value |
|-------|-------|
| 16:9 | 1.7777... |
| 4:3 | 1.3333... |
| 1:1 | 1.0 |
| 3:2 | 1.5 |
| 21:9 | 2.3333... |

#### Aspect Ratio Reference

| Format | Ratio | Value | Common Use |
|--------|-------|-------|------------|
| Square | 1:1 | 1.0 | Instagram, social media |
| Standard | 4:3 | 1.333... | Classic photography |
| 35mm Film | 3:2 | 1.5 | DSLR cameras |
| HD Video | 16:9 | 1.777... | TV, YouTube |
| Ultra-wide | 21:9 | 2.333... | Cinema, gaming |
| Cinemascope | 2.35:1 | 2.35 | Widescreen films |
| IMAX | 1.43:1 | 1.43 | IMAX theaters |

---

### CameraPreviewFit

Defines how the camera preview fits within the aspect ratio container.

```dart
enum CameraPreviewFit
```

#### Values

| Value | Description |
|-------|-------------|
| `contain` | Scales preview to fit entirely within container, may show letterbox/pillarbox |
| `cover` | Scales preview to fill container entirely, may crop edges |

#### Visual Comparison

```
CONTAIN (16:9 preview in 1:1 container):
┌─────────────────┐
│  ░░░░░░░░░░░░░  │  ← letterbox
│  ┌───────────┐  │
│  │  preview  │  │
│  └───────────┘  │
│  ░░░░░░░░░░░░░  │  ← letterbox
└─────────────────┘

COVER (16:9 preview in 1:1 container):
┌─────────────────┐
│                 │
│    preview      │  ← sides cropped
│                 │
└─────────────────┘
```

---

## Usage Examples

### Basic Camera Setup with Aspect Ratio

```dart
import 'package:camera/camera.dart';
import 'package:camera_extensions/camera_extensions.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
    );

    await _controller!.initialize();

    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Center(
        child: CameraPreviewAspectRatio(
          controller: _controller!,
          aspectRatio: CameraAspectRatio.ratio16x9,
        ),
      ),
    );
  }
}
```

### Switchable Aspect Ratios

```dart
class SwitchableAspectRatioCamera extends StatefulWidget {
  const SwitchableAspectRatioCamera({super.key});

  @override
  State<SwitchableAspectRatioCamera> createState() =>
      _SwitchableAspectRatioCameraState();
}

class _SwitchableAspectRatioCameraState
    extends State<SwitchableAspectRatioCamera> {
  CameraController? _controller;
  CameraAspectRatio _currentRatio = const CameraAspectRatio.ratio16x9();

  final _ratios = const [
    CameraAspectRatio.ratio16x9(),
    CameraAspectRatio.ratio4x3(),
    CameraAspectRatio.ratio1x1(),
    CameraAspectRatio.ratio3x2(),
  ];

  void _switchRatio() {
    final currentIndex = _ratios.indexOf(_currentRatio);
    final nextIndex = (currentIndex + 1) % _ratios.length;
    setState(() => _currentRatio = _ratios[nextIndex]);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: CameraPreviewAspectRatio(
        controller: _controller!,
        aspectRatio: _currentRatio,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _switchRatio,
        child: const Icon(Icons.aspect_ratio),
      ),
    );
  }
}
```

### Using Native Aspect Ratio

```dart
// Display preview at camera's native aspect ratio
if (_controller != null && _controller!.value.isInitialized) {
  CameraPreviewAspectRatio(
    controller: _controller!,
    aspectRatio: CameraAspectRatio.native(_controller!),
  );
}
```

### Cover vs Contain Comparison

```dart
Row(
  children: [
    Expanded(
      child: Column(
        children: [
          const Text('Contain'),
          CameraPreviewAspectRatio(
            controller: _controller!,
            aspectRatio: CameraAspectRatio.ratio1x1,
            fit: CameraPreviewFit.contain,
          ),
        ],
      ),
    ),
    Expanded(
      child: Column(
        children: [
          const Text('Cover'),
          CameraPreviewAspectRatio(
            controller: _controller!,
            aspectRatio: CameraAspectRatio.ratio1x1,
            fit: CameraPreviewFit.cover,
          ),
        ],
      ),
    ),
  ],
)
```

---

## Platform Notes

### Android

- Minimum SDK: 21 (Lollipop)
- Uses CameraX on API 21+
- Native aspect ratios vary by device

### iOS

- Minimum iOS: 12.0
- Uses AVFoundation
- Common aspect ratios: 4:3, 16:9

### Permissions

Remember to add camera permissions to your app:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.CAMERA"/>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for taking photos</string>
```
