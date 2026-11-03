// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Umbrella header for camera_extended_ios module
// CocoaPods flattens public headers into one folder, while Swift Package
// Manager keeps the nested layout and pulls this header into the module.
#if __has_include("QueueUtils.h")
#import "QueueUtils.h"
#import "messages.g.h"
#else
#import "../camera_avfoundation/QueueUtils.h"
#import "../camera_avfoundation/messages.g.h"
#endif
