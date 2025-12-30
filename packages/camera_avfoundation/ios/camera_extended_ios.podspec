#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'camera_extended_ios'
  s.version          = '0.0.1'
  s.summary          = 'Flutter Camera Extended'
  s.description      = <<-DESC
A Flutter plugin to use the camera from your Flutter app with native aspect ratio support.
                       DESC
  s.homepage         = 'https://github.com/erykkruk/camera_extensions'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Eryk Kruk' => 'eryk@example.com' }
  s.source           = { :http => 'https://github.com/erykkruk/camera_extensions/tree/main/packages/camera_avfoundation' }
  s.documentation_url = 'https://pub.dev/packages/camera_extended_ios'
  # Combine camera_extended_ios and camera_extended_ios_objc sources into a single pod, unlike
  # SwiftPM, where separate Swift and Objective-C targets are required.
  s.source_files = 'camera_extended_ios/Sources/camera_avfoundation*/**/*.{h,m,swift}'
  s.public_header_files = 'camera_extended_ios/Sources/camera_avfoundation_objc/include/**/*.h'
  s.swift_version = '5.0'
  s.xcconfig = {
     'LIBRARY_SEARCH_PATHS' => '$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)/ $(SDKROOT)/usr/lib/swift',
     'LD_RUNPATH_SEARCH_PATHS' => '/usr/lib/swift',
  }
  s.dependency 'Flutter'

  s.platform = :ios, '13.0'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'HEADER_SEARCH_PATHS' => '"$(PODS_TARGET_SRCROOT)/camera_extended_ios/Sources/camera_avfoundation_objc/include/camera_avfoundation"'
  }
  s.resource_bundles = {'camera_extended_ios_privacy' => ['camera_extended_ios/Sources/camera_avfoundation/Resources/PrivacyInfo.xcprivacy']}
end
