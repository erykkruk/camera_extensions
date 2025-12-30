# Code Quality Guidelines - camera_extensions

## Naming Conventions

### Files
- `snake_case.dart` for all files
- Prefix with category: `camera_aspect_ratio.dart`, `camera_preview_fit.dart`

### Classes
- `PascalCase` for classes
- Prefix with `Camera` for public API: `CameraAspectRatio`, `CameraPreviewAspectRatio`
- Private implementations use underscore: `_Ratio16x9`

### Extensions
- Named extensions: `CameraControllerExtensions`
- Descriptive getter/method names: `aspectRatio`, `previewSize`

### Variables
- `camelCase` for variables and parameters
- Descriptive names: `targetRatio`, `cameraRatio`, `backgroundColor`

## File Organization

```
lib/
  camera_extensions.dart      # Main export file
  src/
    extensions/
      camera_controller_extensions.dart
    models/
      camera_aspect_ratio.dart
      camera_preview_fit.dart
    widgets/
      camera_preview_aspect_ratio.dart
```

## Code Style Rules

### Imports
- Relative imports within package
- Package imports for external dependencies
- Sort: dart → package → relative

### Documentation
- Dartdoc comments for all public APIs
- Include examples in complex methods
- Document exceptions thrown

### Formatting
- Run `dart format .` before committing
- Max line length: 80 characters (Dart default)
- Use trailing commas for multi-line argument lists

## Review Checklist

### Before PR:
- [ ] `flutter analyze` passes with no issues
- [ ] `dart format .` applied
- [ ] All public APIs documented
- [ ] No unused imports
- [ ] No `print()` statements (use `debugPrint` if needed)
- [ ] Constants extracted for magic numbers
- [ ] Error cases handled with meaningful messages

### Widget Review:
- [ ] Uses `const` constructor where possible
- [ ] Has `Key` parameter in constructor
- [ ] Handles uninitialized controller gracefully
- [ ] No memory leaks (dispose patterns)

### Extension Review:
- [ ] Pure getters (no side effects)
- [ ] Throws `StateError` for invalid state
- [ ] Documents preconditions
