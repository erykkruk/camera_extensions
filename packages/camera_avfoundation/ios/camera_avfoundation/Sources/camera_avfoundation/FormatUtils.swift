// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import AVFoundation

// Import Objective-C part of the implementation when SwiftPM is used.
#if canImport(camera_avfoundation_objc)
  import camera_avfoundation_objc
#endif

/// Determines the video dimensions (width and height) for a given capture device format.
/// Used in tests to mock CMVideoFormatDescriptionGetDimensions.
typealias VideoDimensionsConverter = (CaptureDeviceFormat) -> CMVideoDimensions

enum FormatUtils {
  /// Returns the target aspect ratio value for a given PlatformCameraAspectRatio.
  static func targetAspectRatio(for aspectRatio: FCPPlatformCameraAspectRatio) -> Double? {
    switch aspectRatio {
    case .ratio16x9:
      return 16.0 / 9.0
    case .ratio4x3:
      return 4.0 / 3.0
    case .ratio1x1:
      return 1.0
    case .ratioDefault:
      return nil
    @unknown default:
      return nil
    }
  }

  /// Calculates the aspect ratio of given dimensions (width / height).
  static func aspectRatio(for dimensions: CMVideoDimensions) -> Double {
    guard dimensions.height > 0 else { return 0 }
    return Double(dimensions.width) / Double(dimensions.height)
  }

  /// Checks if the format's aspect ratio matches the target aspect ratio within a tolerance.
  static func formatMatchesAspectRatio(
    _ format: CaptureDeviceFormat,
    targetRatio: Double,
    videoDimensionsConverter: VideoDimensionsConverter,
    tolerance: Double = 0.01
  ) -> Bool {
    let dimensions = videoDimensionsConverter(format)
    let formatRatio = aspectRatio(for: dimensions)
    return abs(formatRatio - targetRatio) < tolerance
  }

  /// Finds the best format matching the requested aspect ratio and resolution preset.
  /// Returns nil if no suitable format is found, allowing fallback to default behavior.
  static func selectBestFormatForAspectRatio(
    for captureDevice: CaptureDevice,
    aspectRatio: FCPPlatformCameraAspectRatio,
    resolutionPreset: FCPPlatformResolutionPreset,
    videoDimensionsConverter: VideoDimensionsConverter
  ) -> CaptureDeviceFormat? {
    guard let targetRatio = targetAspectRatio(for: aspectRatio) else {
      return nil
    }

    // Get minimum pixel count based on resolution preset
    let minPixelCount: UInt
    switch resolutionPreset {
    case .low:
      minPixelCount = 352 * 288  // CIF
    case .medium:
      minPixelCount = 640 * 480  // VGA
    case .high:
      minPixelCount = 1280 * 720  // 720p
    case .veryHigh:
      minPixelCount = 1920 * 1080  // 1080p
    case .ultraHigh:
      minPixelCount = 3840 * 2160  // 4K
    case .max:
      minPixelCount = 0  // Any resolution
    @unknown default:
      minPixelCount = 0
    }

    let preferredSubType = CMFormatDescriptionGetMediaSubType(
      captureDevice.flutterActiveFormat.formatDescription)

    var bestFormat: CaptureDeviceFormat? = nil
    var bestPixelCount: UInt = 0
    var isBestSubTypePreferred = false

    for format in captureDevice.flutterFormats {
      // Check if format matches the target aspect ratio
      if !formatMatchesAspectRatio(
        format, targetRatio: targetRatio,
        videoDimensionsConverter: videoDimensionsConverter)
      {
        continue
      }

      let dimensions = videoDimensionsConverter(format)
      let pixelCount = UInt(dimensions.width) * UInt(dimensions.height)

      // Skip formats below minimum resolution
      if resolutionPreset != .max && pixelCount < minPixelCount {
        continue
      }

      let subType = CMFormatDescriptionGetMediaSubType(format.formatDescription)
      let isSubTypePreferred = subType == preferredSubType

      // Select the best matching format
      if bestFormat == nil || pixelCount > bestPixelCount
        || (pixelCount == bestPixelCount && isSubTypePreferred && !isBestSubTypePreferred)
      {
        bestFormat = format
        bestPixelCount = pixelCount
        isBestSubTypePreferred = isSubTypePreferred
      }
    }

    // If 1:1 requested but not found, fallback to 4:3
    if aspectRatio == .ratio1x1 && bestFormat == nil {
      print("[CameraExtensions] 1:1 aspect ratio not directly supported. Using 4:3 fallback.")
      return selectBestFormatForAspectRatio(
        for: captureDevice,
        aspectRatio: .ratio4x3,
        resolutionPreset: resolutionPreset,
        videoDimensionsConverter: videoDimensionsConverter
      )
    }

    return bestFormat
  }

  /// Returns frame rate supported by format closest to targetFrameRate.
  static private func bestFrameRate(for format: CaptureDeviceFormat, targetFrameRate: Double)
    -> Double
  {
    var bestFrameRate: Double = 0
    var minDistance: Double = Double.greatestFiniteMagnitude

    for range in format.flutterVideoSupportedFrameRateRanges {
      let frameRate = min(
        max(targetFrameRate, Double(range.minFrameRate)), Double(range.maxFrameRate))
      let distance = abs(frameRate - targetFrameRate)
      if distance < minDistance {
        bestFrameRate = frameRate
        minDistance = distance
      }
    }

    return bestFrameRate
  }

  /// Finds format with same resolution as current activeFormat in captureDevice for which
  /// bestFrameRate returned frame rate closest to mediaSettings.framesPerSecond.
  /// Preferred are formats with the same subtype as current activeFormat. Sets this format
  /// as activeFormat and also updates mediaSettings.framesPerSecond to value which
  /// bestFrameRate returned for that format.
  static func selectBestFormat(
    for captureDevice: CaptureDevice,
    mediaSettings: FCPPlatformMediaSettings,
    videoDimensionsConverter: VideoDimensionsConverter
  ) {
    let targetResolution = videoDimensionsConverter(captureDevice.flutterActiveFormat)
    let targetFrameRate = mediaSettings.framesPerSecond?.doubleValue ?? 0
    let preferredSubType = CMFormatDescriptionGetMediaSubType(
      captureDevice.flutterActiveFormat.formatDescription)

    var bestFormat = captureDevice.flutterActiveFormat
    var resolvedBastFrameRate = bestFrameRate(for: bestFormat, targetFrameRate: targetFrameRate)
    var minDistance = abs(resolvedBastFrameRate - targetFrameRate)
    var isBestSubTypePreferred = true

    for format in captureDevice.flutterFormats {
      let resolution = videoDimensionsConverter(format)
      if resolution.width != targetResolution.width || resolution.height != targetResolution.height
      {
        continue
      }

      let frameRate = bestFrameRate(for: format, targetFrameRate: targetFrameRate)
      let distance = abs(frameRate - targetFrameRate)
      let subType = CMFormatDescriptionGetMediaSubType(format.formatDescription)
      let isSubTypePreferred = subType == preferredSubType

      if distance < minDistance
        || (distance == minDistance && isSubTypePreferred && !isBestSubTypePreferred)
      {
        bestFormat = format
        resolvedBastFrameRate = frameRate
        minDistance = distance
        isBestSubTypePreferred = isSubTypePreferred
      }
    }

    captureDevice.flutterActiveFormat = bestFormat
    mediaSettings.framesPerSecond = NSNumber(value: resolvedBastFrameRate)
  }
}
