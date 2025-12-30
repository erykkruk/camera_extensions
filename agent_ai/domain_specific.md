# Flutter/Dart Domain-Specific Guidelines - camera_extensions

## Dart Language Features

### Sealed Classes
Use for type-safe unions:
```dart
sealed class CameraAspectRatio {
  const CameraAspectRatio();
  double get value;
}

final class _Ratio16x9 extends CameraAspectRatio {
  const _Ratio16x9();
  @override
  double get value => 16 / 9;
}
```

### Extensions
Use for adding functionality to external types:
```dart
extension CameraControllerExtensions on CameraController {
  double get aspectRatio { ... }
}
```

### Factory Constructors
Use for complex object creation:
```dart
factory CameraAspectRatio.native(CameraController controller) {
  return _CustomRatio(controller.aspectRatio);
}
```

## Flutter Widget Patterns

### StatelessWidget Preferred
- Use for pure UI components
- Immutable props only
- No internal state

### const Constructors
Always use const where possible:
```dart
const CameraPreviewAspectRatio({
  super.key,
  required this.controller,
  required this.aspectRatio,
});
```

### Widget Composition
Prefer composition over complex widget trees:
```dart
Widget build(BuildContext context) {
  return ColoredBox(
    color: backgroundColor,
    child: AspectRatio(
      aspectRatio: targetRatio,
      child: _buildPreview(),
    ),
  );
}
```

## Camera Package Integration

### CameraController Lifecycle
- Always check `value.isInitialized`
- Handle disposal properly
- Respect app lifecycle (pause/resume)

### CameraPreview Widget
- Wrap, don't replace
- Add functionality around it
- Don't modify its internal behavior

## Error Handling

### StateError for Invalid State
```dart
if (!value.isInitialized) {
  throw StateError(
    'CameraController must be initialized before getting aspect ratio',
  );
}
```

### Graceful Degradation
```dart
if (!controller.value.isInitialized) {
  return ColoredBox(color: backgroundColor);
}
```

## Performance Considerations

### Avoid Rebuilds
- Use const widgets where possible
- Don't rebuild on every frame
- Cache computed values

### Layout Efficiency
- Minimize widget tree depth
- Use LayoutBuilder sparingly
- Prefer AspectRatio over custom calculations

## Platform Specifics

### Android
- Camera requires API 21+
- CameraX used on modern devices
- Handle permission denial gracefully

### iOS
- Camera requires iOS 12+
- AVFoundation under the hood
- Add NSCameraUsageDescription to Info.plist

## Package Publishing

### pubspec.yaml Requirements
- Semantic versioning
- Complete description
- Homepage URL
- Environment constraints
- Proper dependency declarations

### Documentation
- README with quick start
- API documentation in doc/
- Example app with common use cases
