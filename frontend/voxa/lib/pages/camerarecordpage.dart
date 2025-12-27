import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:voxa/media/media_result.dart';
import 'package:voxa/pages/videoview.dart';
import 'package:voxa/screens/cameraview.dart';

class CameraRecordPage extends StatefulWidget {
  final File? file;

  const CameraRecordPage({super.key, this.file});

  @override
  State<CameraRecordPage> createState() => _CameraRecordPageState();
}

class _CameraRecordPageState extends State<CameraRecordPage> {
  CameraController? _controller;
  bool _isRecording = false;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();

    // If a file is provided, open it immediately
    if (widget.file != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openFile(widget.file!);
      });
    } else {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      _controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: true,
      );
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Camera initialization error: $e");
    }
  }

  void _openFile(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    if (['mp4', 'mov', 'avi', 'mkv'].contains(ext)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => VideoViewPage(path: file.path)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => CameraView(file: file)),
      );
    }
  }

  /// Take photo
  Future<void> _takePhoto() async {
    if (_isRecording || _isBusy || _controller == null) return;
    _isBusy = true;

    try {
      final XFile file = await _controller!.takePicture();
      _isBusy = false;

      final result = await Navigator.push<MediaResult>(
        context,
        MaterialPageRoute(
          builder: (_) => CameraView(file: File(file.path)),
        ),
      );

      if (result != null) {
        Navigator.pop(context, result);
      }
    } catch (e) {
      _isBusy = false;
      debugPrint("Photo capture error: $e");
    }
  }

  /// Start video recording
  Future<void> _startVideo(LongPressStartDetails _) async {
    if (_isRecording || _isBusy || _controller == null) return;

    try {
      await _controller!.startVideoRecording();
      setState(() => _isRecording = true);
    } catch (e) {
      debugPrint("Start video error: $e");
    }
  }

  /// Stop video recording
  Future<void> _stopVideo(LongPressEndDetails _) async {
    if (!_isRecording || _controller == null) return;

    try {
      final XFile file = await _controller!.stopVideoRecording();
      setState(() => _isRecording = false);

      // Fix for Samsung debug mode: ensure file is fully written
      await Future.delayed(const Duration(milliseconds: 200));

      // Navigate to video preview
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoViewPage(path: file.path),
        ),
      );

      // Return result to previous screen
      Navigator.pop(
        context,
        MediaResult(file: File(file.path), isVideo: true, caption: ''),
      );
    } catch (e) {
      setState(() => _isRecording = false);
      debugPrint("Stop video error: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Camera UI
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          CameraPreview(_controller!),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _takePhoto,
                onLongPressStart: _startVideo,
                onLongPressEnd: _stopVideo,
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: _isRecording ? Colors.red : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
