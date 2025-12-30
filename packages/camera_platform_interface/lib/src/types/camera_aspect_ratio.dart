// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Aspect ratio configuration for camera capture.
///
/// This determines the aspect ratio of the camera preview and captured
/// images/videos at the native sensor level.
enum CameraAspectRatio {
  /// 16:9 widescreen aspect ratio.
  /// Standard for HD video and modern smartphones.
  ratio16x9,

  /// 4:3 standard aspect ratio.
  /// Classic photo format, provides more vertical field of view.
  ratio4x3,

  /// 1:1 square aspect ratio.
  /// Provides the widest horizontal field of view on most sensors.
  ratio1x1,

  /// Use the camera's default aspect ratio.
  /// Typically 4:3 on most mobile cameras.
  ratioDefault,
}

/// Extension methods for [CameraAspectRatio].
extension CameraAspectRatioExtension on CameraAspectRatio {
  /// Returns the numeric value of the aspect ratio (width / height).
  double get value {
    switch (this) {
      case CameraAspectRatio.ratio16x9:
        return 16.0 / 9.0;
      case CameraAspectRatio.ratio4x3:
        return 4.0 / 3.0;
      case CameraAspectRatio.ratio1x1:
        return 1.0;
      case CameraAspectRatio.ratioDefault:
        return 4.0 / 3.0; // Default is typically 4:3
    }
  }

  /// Returns a human-readable label for the aspect ratio.
  String get label {
    switch (this) {
      case CameraAspectRatio.ratio16x9:
        return '16:9';
      case CameraAspectRatio.ratio4x3:
        return '4:3';
      case CameraAspectRatio.ratio1x1:
        return '1:1';
      case CameraAspectRatio.ratioDefault:
        return 'Default';
    }
  }

  /// Returns true if this is a square aspect ratio.
  bool get isSquare => this == CameraAspectRatio.ratio1x1;

  /// Serializes to a string for platform channel communication.
  String serialize() {
    switch (this) {
      case CameraAspectRatio.ratio16x9:
        return 'ratio16x9';
      case CameraAspectRatio.ratio4x3:
        return 'ratio4x3';
      case CameraAspectRatio.ratio1x1:
        return 'ratio1x1';
      case CameraAspectRatio.ratioDefault:
        return 'ratioDefault';
    }
  }

  /// Deserializes from a string.
  static CameraAspectRatio deserialize(String value) {
    switch (value) {
      case 'ratio16x9':
        return CameraAspectRatio.ratio16x9;
      case 'ratio4x3':
        return CameraAspectRatio.ratio4x3;
      case 'ratio1x1':
        return CameraAspectRatio.ratio1x1;
      case 'ratioDefault':
      default:
        return CameraAspectRatio.ratioDefault;
    }
  }
}
