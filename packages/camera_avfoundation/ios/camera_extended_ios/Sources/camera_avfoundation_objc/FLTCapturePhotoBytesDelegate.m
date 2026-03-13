// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "./include/camera_avfoundation/FLTCapturePhotoBytesDelegate.h"

@interface FLTCapturePhotoBytesDelegate ()
@property(readonly, nonatomic) FLTCapturePhotoBytesDelegateCompletionHandler completionHandler;
@end

@implementation FLTCapturePhotoBytesDelegate

- (instancetype)initWithCompletionHandler:
    (FLTCapturePhotoBytesDelegateCompletionHandler)completionHandler {
  self = [super init];
  NSAssert(self, @"super init cannot be nil");
  _completionHandler = completionHandler;
  return self;
}

- (void)captureOutput:(AVCapturePhotoOutput *)output
    didFinishProcessingPhoto:(AVCapturePhoto *)photo
                       error:(NSError *)error {
  if (error) {
    self.completionHandler(nil, error);
    return;
  }

  NSData *photoData = [photo fileDataRepresentation];
  if (photoData == nil) {
    NSError *dataError = [NSError errorWithDomain:@"FLTCameraErrorDomain"
                                             code:-1
                                         userInfo:@{
                                           NSLocalizedDescriptionKey :
                                               @"Failed to get photo data representation."
                                         }];
    self.completionHandler(nil, dataError);
    return;
  }

  FlutterStandardTypedData *typedData =
      [FlutterStandardTypedData typedDataWithBytes:photoData];
  self.completionHandler(typedData, nil);
}

@end
