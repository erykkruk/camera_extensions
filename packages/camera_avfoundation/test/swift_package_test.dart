// Copyright 2013 The Flutter Authors
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Flutter generates `@import camera_extended_ios;` and links the product named
/// after the plugin with dashes, so a mismatch only fails in an app's iOS build,
/// which the unit tests never run. See issue #5.
void main() {
  const String packageRoot = 'ios/camera_extended_ios';
  final String manifest = File('$packageRoot/Package.swift').readAsStringSync();

  test('the package is named after the plugin', () {
    expect(manifest, contains('name: "camera_extended_ios"'));
  });

  test('the library product uses the name Flutter links against', () {
    expect(
      manifest,
      contains('name: "camera-extended-ios", targets: ["camera_extended_ios"'),
    );
  });

  test('the module declaring the plugin carries the plugin name', () {
    expect(
      manifest,
      matches(
        RegExp(
          r'name: "camera_extended_ios",\s+dependencies: \["camera_avfoundation_objc"\]',
        ),
      ),
    );
  });

  test(
    'the umbrella header resolves in both CocoaPods and SwiftPM layouts',
    () {
      final String header = File(
        '$packageRoot/Sources/camera_avfoundation_objc/include/'
        'camera_extended_ios/camera_extended_ios.h',
      ).readAsStringSync();

      expect(header, contains('__has_include("QueueUtils.h")'));
      expect(header, contains('#import "QueueUtils.h"'));
      expect(header, contains('#import "../camera_avfoundation/QueueUtils.h"'));
    },
  );
}
