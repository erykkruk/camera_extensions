# camera_extensions

[![pub package](https://img.shields.io/pub/v/camera_extensions.svg)](https://pub.dev/packages/camera_extensions)
[![likes](https://img.shields.io/pub/likes/camera_extensions)](https://pub.dev/packages/camera_extensions/score)
[![popularity](https://img.shields.io/pub/popularity/camera_extensions)](https://pub.dev/packages/camera_extensions/score)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A Flutter package that extends the official [camera](https://pub.dev/packages/camera) package with additional features. Add aspect ratio control, preview enhancements, and more to your camera implementation.

## Why camera_extensions?

- **No Native Code** - Pure Dart extensions, works with existing camera setup
- **Easy Integration** - Drop-in widgets and extensions for CameraController
- **Aspect Ratio Control** - Force any aspect ratio on camera preview
- **Lightweight** - Only depends on the camera package
cd packages/camera_platform_interface && flutter pub publish
  cd packages/camera_android_camerax && flutter pub publish
  cd packages/camera_avfoundation && flutter pub publish
  cd packages/camera && flutter pub publish
## Features

| Feature | Status |
|---------|:------:|
| Aspect ratio extensions for CameraController | ✅ |
| CameraPreviewAspectRatio widget | ✅ |
| Predefined aspect ratios (16:9, 4:3, 1:1, etc.) | ✅ |
| Letterboxing/pillarboxing support | ✅ |
| Custom aspect ratio values | ✅ |

## Installation

```yaml
dependencies:
  camera: ^0.11.0
  camera_extensions: ^1.0.0
```

```bash
flutter pub add camera camera_extensions
```

## Quick Start

```dart
import 'package:camera/camera.dart';
import 'package:camera_extensions/camera_extensions.dart';

class CameraScreen extends StatefulWidget {
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.high);
    await _controller.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    // Use CameraPreviewAspectRatio for controlled aspect ratio
    return CameraPreviewAspectRatio(
      controller: _controller,
      aspectRatio: CameraAspectRatio.ratio16x9,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

## Usage Examples

### Get Camera Aspect Ratio

```dart
// Extension getter on CameraController
final ratio = _controller.aspectRatio; // e.g., 1.777... for 16:9
```

### Predefined Aspect Ratios

```dart
CameraPreviewAspectRatio(
  controller: _controller,
  aspectRatio: CameraAspectRatio.ratio16x9, // 1.777...
);

CameraPreviewAspectRatio(
  controller: _controller,
  aspectRatio: CameraAspectRatio.ratio4x3,  // 1.333...
);

CameraPreviewAspectRatio(
  controller: _controller,
  aspectRatio: CameraAspectRatio.ratio1x1,  // 1.0 (square)
);
```

### Custom Aspect Ratio

```dart
CameraPreviewAspectRatio(
  controller: _controller,
  aspectRatio: CameraAspectRatio.custom(2.35), // Cinemascope
);
```

### Native Camera Aspect Ratio

```dart
// Use the camera's native aspect ratio
CameraPreviewAspectRatio(
  controller: _controller,
  aspectRatio: CameraAspectRatio.native(_controller),
);
```

### Fit Modes

```dart
CameraPreviewAspectRatio(
  controller: _controller,
  aspectRatio: CameraAspectRatio.ratio16x9,
  fit: CameraPreviewFit.contain,  // Letterbox/pillarbox (default)
);

CameraPreviewAspectRatio(
  controller: _controller,
  aspectRatio: CameraAspectRatio.ratio16x9,
  fit: CameraPreviewFit.cover,    // Fill and crop
);
```

### Background Color

```dart
CameraPreviewAspectRatio(
  controller: _controller,
  aspectRatio: CameraAspectRatio.ratio1x1,
  backgroundColor: Colors.black,  // Letterbox color
);
```

## API Reference

### CameraAspectRatio

Enum with predefined aspect ratios:

| Value | Ratio | Description |
|-------|-------|-------------|
| `ratio16x9` | 1.777... | Widescreen (HD video) |
| `ratio4x3` | 1.333... | Standard (classic photos) |
| `ratio1x1` | 1.0 | Square (Instagram style) |
| `ratio3x2` | 1.5 | Classic 35mm film |
| `ratio21x9` | 2.333... | Ultra-wide |
| `custom(double)` | Custom | Any custom value |
| `native(controller)` | Camera native | Uses camera's native ratio |

### CameraPreviewAspectRatio Widget

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `controller` | `CameraController` | required | Initialized camera controller |
| `aspectRatio` | `CameraAspectRatio` | required | Desired aspect ratio |
| `fit` | `CameraPreviewFit` | `contain` | How preview fits in container |
| `backgroundColor` | `Color` | `Colors.black` | Color for letterbox/pillarbox |

### CameraController Extensions

| Extension | Type | Description |
|-----------|------|-------------|
| `aspectRatio` | `double` | Returns camera's native aspect ratio |
| `previewSize` | `Size` | Returns preview size in pixels |

## Platform Support

| Platform | Support |
|----------|---------|
| Android | ✅ (API 21+) |
| iOS | ✅ (iOS 12+) |

## Requirements

- Flutter: `>=3.0.0`
- Dart SDK: `>=3.0.0 <4.0.0`
- camera: `^0.11.0`

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests on [GitHub](https://github.com/erykkruk/camera_extensions).

## License

MIT License - see [LICENSE](LICENSE) for details.

---

<p align="center">
  Made with ❤️ by <a href="https://codigee.com">Codigee</a>
</p>
