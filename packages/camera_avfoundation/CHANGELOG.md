# Changelog

## 0.9.30

* Updated documentation and README consistency

## 0.9.29

* Version bump for pub.dev publication

## 0.9.28

* Minor bug fixes and improvements

## 0.9.27

* Updated dependency to `camera_extended_platform_interface: ^2.12.2`

## 0.9.26

* Performance improvements

## 0.9.25

* Bug fixes for aspect ratio selection

## 0.9.24

* Renamed iOS podspec and directory to `camera_extended_ios`

## 0.9.23

* Renamed library entry point to `camera_extended_ios.dart`
* Updated dependency to `camera_extended_platform_interface: ^2.12.2`

## 0.9.22+8

Fork of `camera_avfoundation` with native aspect ratio support.

### New Features

* **Native Aspect Ratio Selection** - Configure camera aspect ratio at AVFoundation level
  * Uses `AVCaptureDevice` format selection based on aspect ratio
  * Supports 16:9 and 4:3 native formats
  * Automatic fallback to 4:3 when 1:1 not available (iOS doesn't support native 1:1)

* **FormatUtils Extensions** - New utilities for aspect ratio format selection
  * `selectBestFormatForAspectRatio()` - Find best matching format
  * `targetAspectRatio()` - Get ratio value for enum
  * `formatMatchesAspectRatio()` - Check format compatibility

### Based On

Original `camera_avfoundation` version 0.9.22+8 from Flutter team.

---

## Previous Versions

See [original camera_avfoundation changelog](https://pub.dev/packages/camera_avfoundation/changelog).
