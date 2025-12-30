# Testing Guidelines - camera_extensions

## Test Structure

```
test/
  models/
    camera_aspect_ratio_test.dart
    camera_preview_fit_test.dart
  extensions/
    camera_controller_extensions_test.dart
  widgets/
    camera_preview_aspect_ratio_test.dart
```

## Unit Tests

### Models
- Test all predefined ratio values
- Test custom ratio creation
- Test equality and hashCode
- Test toString representations

```dart
test('ratio16x9 has correct value', () {
  expect(CameraAspectRatio.ratio16x9.value, closeTo(16/9, 0.0001));
});

test('custom ratio preserves value', () {
  const ratio = CameraAspectRatio.custom(2.35);
  expect(ratio.value, 2.35);
});
```

### Extensions
- Mock CameraController for testing
- Test initialized vs uninitialized states
- Verify StateError for invalid states

```dart
test('aspectRatio throws when not initialized', () {
  final controller = MockCameraController();
  when(controller.value).thenReturn(
    CameraValue.uninitialized(MockCameraDescription()),
  );

  expect(() => controller.aspectRatio, throwsStateError);
});
```

## Widget Tests

### CameraPreviewAspectRatio
- Test with mock controller
- Verify AspectRatio widget is created with correct value
- Test contain vs cover fit modes
- Test background color application

```dart
testWidgets('displays with correct aspect ratio', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: CameraPreviewAspectRatio(
        controller: mockController,
        aspectRatio: CameraAspectRatio.ratio16x9,
      ),
    ),
  );

  final aspectRatio = tester.widget<AspectRatio>(
    find.byType(AspectRatio),
  );
  expect(aspectRatio.aspectRatio, closeTo(16/9, 0.0001));
});
```

## Integration Tests

### Example App
- Test camera initialization flow
- Test aspect ratio switching
- Test fit mode toggling
- Test camera switching (front/back)

## Mocking Strategy

### CameraController Mock
```dart
class MockCameraController extends Mock implements CameraController {}
class MockCameraDescription extends Mock implements CameraDescription {}
```

### Dependencies
- `mocktail` or `mockito` for mocking
- `flutter_test` for widget tests

## Coverage Goals

- Models: 100% coverage
- Extensions: 100% coverage
- Widgets: 90%+ coverage (layout edge cases)
