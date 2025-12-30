# Architecture Review Guidelines - camera_extensions

## Project Architecture Pattern

**Extension-Based Architecture** - Pure Dart extensions and widgets that enhance existing camera package functionality without modifying native code.

## Layer Responsibilities

### Extensions Layer (`lib/src/extensions/`)
- Dart extensions on `CameraController`
- Read-only getters for camera properties
- No state management, purely computed values
- MUST NOT modify camera state

### Models Layer (`lib/src/models/`)
- Immutable data classes and enums
- `CameraAspectRatio` - sealed class for aspect ratio values
- `CameraPreviewFit` - enum for fit modes
- All models MUST be immutable

### Widgets Layer (`lib/src/widgets/`)
- StatelessWidget preferred where possible
- Wraps `CameraPreview` from camera package
- Handles layout calculations for aspect ratio
- MUST NOT manage camera lifecycle

## Dependency Flow Rules

```
widgets/ → extensions/, models/
extensions/ → camera package only
models/ → camera package (for CameraController type)
```

- Extensions and models have no internal dependencies
- Widgets can depend on extensions and models
- NEVER create circular dependencies

## Common Anti-patterns

### DON'T:
- Modify CameraController state in extensions
- Create stateful widgets for simple layout tasks
- Duplicate camera package functionality
- Add native platform code
- Store mutable state in models

### DO:
- Use sealed classes for type-safe unions
- Prefer composition over inheritance
- Keep widgets focused on single responsibility
- Document public API with dartdoc comments

## Adding New Features

When adding new camera extensions:

1. Check if feature requires native code → if yes, this package is NOT the right place
2. Create models first if new data types needed
3. Add extension getter/method on CameraController
4. Create widget if UI component needed
5. Export from `camera_extensions.dart`
6. Add documentation and examples
