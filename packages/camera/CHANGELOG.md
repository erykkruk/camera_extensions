## 1.2.6

- Maintenance release.

# Changelog

## 1.2.5

* Sets the pubspec `documentation:` field and adds a **Documentation** section to
  the README so the pub.dev "Documentation" link points to the hosted docs at
  codigee.com/open-source/camera-extended (overview, API reference, aspect ratio guide).

## 1.2.4

* Excludes generated example artifacts (`GeneratedPluginRegistrant.java`, `local.properties`) from the repository so `pub publish` runs warning-free.
* Verified compatibility with the upstream `camera` 0.12.0+1 API surface
  (video stabilization + `takePictureAsBytes`), keeping the native aspect-ratio
  support (16:9, 4:3, 1:1) on Android (CameraX) and iOS (AVFoundation).
* Fixed the `camera_extended_platform_interface` test suite, which was failing
  because the `aspectRatio` field added to `MediaSettings` was not reflected in
  the `hashCode` and `create` method-channel expectations.
* Fixed the `camera_extended_ios` example integration test importing the old
  upstream `camera_example` package name instead of `camera_extended_ios_example`.
* Made the native plugin examples resolve the sibling platform interface from
  source via `pubspec_overrides.yaml` so `flutter test` runs in CI.
* Added GitHub Actions CI (format + analyze + test across all four packages),
  auto-release, and pub.dev publish workflows.

## 1.2.3

* Expanded `topics:` in `pubspec.yaml` to the maximum 5 entries (`camera`,
  `video`, `photo`, `preview`, `aspect-ratio`) for improved pub.dev
  discoverability and scoring.

## 1.2.2

* Updated installation docs to ^1.2.2

## 1.2.1

* Fixed internal dependency versions `^1.1.0` → `^1.2.0`
* Updated installation docs to `^1.2.0`
* Added `takePictureAsBytes()` and `VideoStabilizationMode` to README and API docs

## 1.2.0

* Added `VideoStabilizationMode` to barrel export
* Added `videoStabilizationMode` field to `CameraValue`
* Added `getSupportedVideoStabilizationModes()` and `setVideoStabilizationMode()` to `CameraController`
* Made `Optional.of` constructor `const`
* Added `onCameraError` subscription in `initialize` to propagate native error events to `CameraValue.errorDescription`
* Updated all package dependencies to 1.2.0

## 1.1.0

* Added `takePictureAsBytes()` to `CameraController` — captures image and returns raw `Uint8List` without saving to disk, ideal for ML/image processing pipelines
* Updated all package dependencies to 1.1.0

## 0.11.11

* Updated documentation and README consistency
* Updated `camera_extended_ios` dependency to ^0.9.30
* Updated `camera_extended_android` dependency to ^0.6.29

## 0.11.10

* Version bump for pub.dev publication

## 0.11.9

* Updated dependencies to latest versions

## 0.11.8

* Minor bug fixes and improvements

## 0.11.7

* Updated `camera_extended_ios` dependency to ^0.9.28

## 0.11.6

* Updated `camera_extended_android` dependency to ^0.6.28

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
