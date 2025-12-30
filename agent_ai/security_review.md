# Security Guidelines - camera_extensions

## Camera Access

### Permission Handling
- Package does NOT handle permissions (app responsibility)
- Document permission requirements clearly
- Example app demonstrates proper permission flow

### Privacy Considerations
- No data collection or transmission
- No caching of camera frames
- No access to captured media
- Extensions only read camera metadata (dimensions, aspect ratio)

## Input Validation

### CameraController
- Always check `value.isInitialized` before accessing properties
- Throw `StateError` with clear message for uninitialized controller
- Never assume controller state

### Aspect Ratio Values
- Validate custom ratio values are positive
- Handle edge cases (zero, negative, infinity)

## No Sensitive Operations

This package:
- Does NOT capture photos or video
- Does NOT store any data
- Does NOT access file system
- Does NOT make network requests
- Does NOT use native platform channels

## Dependency Security

### Minimal Dependencies
- Only depends on `camera` package
- No additional third-party dependencies
- Regularly update to latest stable camera version

### Example App Dependencies
- `permission_handler` for demo only
- Not a dependency of the main package
