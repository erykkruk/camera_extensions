# Changelog

## 0.6.27

* Renamed library entry point to `camera_extended_android.dart`
* Updated dependency to `camera_extended_platform_interface: ^2.12.2`

## 0.6.26+2

Fork of `camera_android_camerax` with native aspect ratio support.

### New Features

* **Native Aspect Ratio Selection** - Configure camera aspect ratio at CameraX level
  * Uses `ResolutionSelector` with `AspectRatioStrategy`
  * Native 1:1 square support (1088x1088, 720x720, 480x480)
  * Automatic fallback to 4:3 when 1:1 not available

* **Square Format Support** - Native 1:1 formats on supported devices
  * Samsung devices: 1088x1088
  * Other devices: 720x720, 480x480

### Based On

Original `camera_android_camerax` version 0.6.26+2 from Flutter team.

---

## Previous Versions

See [original camera_android_camerax changelog](https://pub.dev/packages/camera_android_camerax/changelog).
