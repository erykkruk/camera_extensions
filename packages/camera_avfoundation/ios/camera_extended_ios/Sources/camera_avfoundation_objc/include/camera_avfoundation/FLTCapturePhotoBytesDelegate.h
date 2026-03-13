// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

@import AVFoundation;
@import Flutter;
@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/// The completion handler block for in-memory photo capture operations.
/// @param data the captured photo data.
/// @param error photo capture error.
typedef void (^FLTCapturePhotoBytesDelegateCompletionHandler)(
    FlutterStandardTypedData *_Nullable data, NSError *_Nullable error);

/// Delegate object that handles photo capture and returns raw bytes without saving to disk.
@interface FLTCapturePhotoBytesDelegate : NSObject <AVCapturePhotoCaptureDelegate>

/// Initialize a photo capture delegate for in-memory capture.
/// @param completionHandler The completion handler block for capture operations.
- (instancetype)initWithCompletionHandler:
    (FLTCapturePhotoBytesDelegateCompletionHandler)completionHandler;
@end

NS_ASSUME_NONNULL_END
