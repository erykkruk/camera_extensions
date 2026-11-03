#!/usr/bin/env bash
# Builds a brand new Flutter app that depends on camera_extended. A fresh app gets
# the defaults library users get (Swift Package Manager, current AGP), which the
# checked-in example app and unit tests do not exercise.
#
# Usage: build_fresh_app.sh ios true|false   (use Swift Package Manager or not)
#        build_fresh_app.sh android
set -euo pipefail

target="$1"
swiftpm="${2:-false}"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
app_dir="$(mktemp -d)/ci_probe"

flutter create --platforms="$target" --project-name ci_probe "$app_dir"
cd "$app_dir"

# camera_extended resolves its implementations from pub.dev, so point them at this
# checkout to build the code under review rather than the last published release.
cat > pubspec_overrides.yaml <<EOF
dependency_overrides:
  camera_extended_android:
    path: $repo_root/packages/camera_android_camerax
  camera_extended_ios:
    path: $repo_root/packages/camera_avfoundation
  camera_extended_platform_interface:
    path: $repo_root/packages/camera_platform_interface
EOF

flutter pub add camera_extended --path "$repo_root/packages/camera"
perl -0pi -e "s/^flutter:\n/flutter:\n  config:\n    enable-swift-package-manager: $swiftpm\n/m" pubspec.yaml

if [ "$target" = "ios" ]; then
  flutter build ios --simulator --debug
else
  flutter build apk --debug
fi
