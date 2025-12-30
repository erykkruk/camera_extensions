# Changelog

## 2.12.1

* Renamed library entry point to `camera_extended_platform_interface.dart`

## 2.12.0

Fork of `camera_platform_interface` with native aspect ratio support.

### New Features

* **CameraAspectRatio enum** - New enum for aspect ratio selection
  * `ratio16x9` - 16:9 widescreen
  * `ratio4x3` - 4:3 standard
  * `ratio1x1` - 1:1 square
  * `ratioDefault` - Camera's default ratio

* **MediaSettings.aspectRatio** - New field for configuring camera aspect ratio at sensor level

### Based On

Original `camera_platform_interface` version 2.12.0 from Flutter team.

---

## Previous Versions

See [original camera_platform_interface changelog](https://pub.dev/packages/camera_platform_interface/changelog).
