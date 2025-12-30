# Changelog

## 0.11.5

* Updated `camera_extended_ios` dependency to ^0.9.24

## 0.11.4

* Updated dependencies to latest versions

## 0.11.3

Fork of `camera` package with native aspect ratio support.

### New Features

* **Native Aspect Ratio Control** - Configure camera aspect ratio at sensor level
  * `CameraAspectRatio.ratio16x9` - 16:9 widescreen
  * `CameraAspectRatio.ratio4x3` - 4:3 standard (wider field of view)
  * `CameraAspectRatio.ratio1x1` - 1:1 square
  * `CameraAspectRatio.ratioDefault` - Camera's default ratio

* **CameraController.aspectRatio** - New parameter for aspect ratio selection
  ```dart
  CameraController(
    camera,
    ResolutionPreset.high,
    aspectRatio: CameraAspectRatio.ratio4x3,
  );
  ```

### Platform Support

| Platform | 16:9 | 4:3 | 1:1 |
|----------|------|-----|-----|
| Android  | Native | Native | Native (1088x1088) |
| iOS      | Native | Native | Fallback to 4:3 |

### Based On

Original `camera` package version 0.11.3 from Flutter team.

---

## Previous Versions

See [original camera changelog](https://pub.dev/packages/camera/changelog).
