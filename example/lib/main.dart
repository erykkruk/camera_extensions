import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const CameraExtensionsExample());
}

class CameraExtensionsExample extends StatelessWidget {
  const CameraExtensionsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Extensions Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  CameraAspectRatio _selectedAspectRatio = CameraAspectRatio.ratio4x3;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (cameras.isEmpty) {
      return;
    }

    setState(() => _isInitializing = true);

    await _controller?.dispose();

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: false,
      aspectRatio: _selectedAspectRatio,
    );

    try {
      await _controller!.initialize();
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() => _isInitializing = false);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onAspectRatioChanged(CameraAspectRatio? ratio) {
    if (ratio == null || ratio == _selectedAspectRatio) return;
    setState(() => _selectedAspectRatio = ratio);
    _initializeCamera();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final XFile image = await _controller!.takePicture();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Picture saved: ${image.path}')),
        );
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Extensions'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildCameraPreview(),
          ),
          _buildControls(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _takePicture,
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildCameraPreview() {
    if (_isInitializing) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: Text('Camera not available'));
    }

    // Wyświetl preview bez modyfikacji - kamera sama ustawia aspect ratio
    return Container(
      color: Colors.black,
      child: Center(
        child: CameraPreview(_controller!),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aspect Ratio',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SegmentedButton<CameraAspectRatio>(
            segments: const [
              ButtonSegment(
                value: CameraAspectRatio.ratio16x9,
                label: Text('16:9'),
              ),
              ButtonSegment(
                value: CameraAspectRatio.ratio4x3,
                label: Text('4:3'),
              ),
              ButtonSegment(
                value: CameraAspectRatio.ratio1x1,
                label: Text('1:1'),
              ),
            ],
            selected: {_selectedAspectRatio},
            onSelectionChanged: (selected) {
              _onAspectRatioChanged(selected.first);
            },
          ),
          const SizedBox(height: 16),
          if (_controller?.value.isInitialized == true)
            Text(
              'Preview size: ${_controller!.value.previewSize?.width.toInt()}x'
              '${_controller!.value.previewSize?.height.toInt()}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
