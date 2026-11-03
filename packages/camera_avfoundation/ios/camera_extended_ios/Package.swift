// swift-tools-version: 5.9

// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import PackageDescription

let package = Package(
  name: "camera_extended_ios",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(
      name: "camera-extended-ios", targets: ["camera_extended_ios", "camera_avfoundation_objc"])
  ],
  dependencies: [],
  targets: [
    // Flutter's generated registrant does `@import camera_extended_ios;`, so
    // the module declaring CameraPlugin must carry the plugin's name. The
    // sources stay in the upstream-named folder to keep the fork easy to sync.
    .target(
      name: "camera_extended_ios",
      dependencies: ["camera_avfoundation_objc"],
      path: "Sources/camera_avfoundation",
      resources: [
        .process("Resources")
      ]
    ),
    .target(
      name: "camera_avfoundation_objc",
      dependencies: [],
      path: "Sources/camera_avfoundation_objc",
      resources: [
        .process("Resources")
      ],
      cSettings: [
        .headerSearchPath("include/camera_avfoundation")
      ]
    ),
  ]
)
