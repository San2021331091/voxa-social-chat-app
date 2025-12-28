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
  DateTime? _recordStartTime;

  @override
  void initState() {
    super.initState();

    if (widget.file != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openFile(widget.file!);
      });
    } else {
      _initCamera();
    }
  }

  /// 🔥 CameraX-safe initialization
  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();

      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
      );

      _controller = CameraController(
        backCamera,
        ResolutionPreset.medium, // ✅ best for Samsung
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _controller!.initialize();

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  /// Open captured media
  void _openFile(File file) {
    final ext = file.path.split('.').last.toLowerCase();

    if (['mp4', 'mov', 'avi', 'mkv'].contains(ext)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VideoViewPage(path: file.path),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CameraView(file: file),
        ),
      );
    }
  }

  /// 📸 Take photo
  Future<void> _takePhoto() async {
    if (_isRecording || _isBusy) return;
    if (_controller == null || !_controller!.value.isInitialized) return;

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
      debugPrint('Photo capture error: $e');
    }
  }

  /// 🎥 Start video (CameraX debounce safe)
  Future<void> _startVideo(LongPressStartDetails _) async {
    if (_isRecording || _isBusy) return;
    if (_controller == null || !_controller!.value.isInitialized) return;

    _isBusy = true;

    // ✅ Samsung / CameraX debounce
    await Future.delayed(const Duration(milliseconds: 180));

    try {
      await _controller!.startVideoRecording();
      _recordStartTime = DateTime.now();

      setState(() {
        _isRecording = true;
        _isBusy = false;
      });
    } catch (e) {
      _isBusy = false;
      debugPrint('Start video error: $e');
    }
  }

  /// ⏹ Stop video (CameraX file flush safe)
  Future<void> _stopVideo(LongPressEndDetails _) async {
    if (!_isRecording) return;
    if (_controller == null) return;

    // ✅ Ignore fake stop (<600ms)
    if (_recordStartTime != null &&
        DateTime.now()
                .difference(_recordStartTime!)
                .inMilliseconds <
            600) {
      return;
    }

    try {
      final XFile file = await _controller!.stopVideoRecording();
      setState(() => _isRecording = false);

      // ✅ CameraX file write completion
      await Future.delayed(const Duration(milliseconds: 500));

      final videoFile = File(file.path);
      if (!videoFile.existsSync() || videoFile.lengthSync() == 0) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoViewPage(path: videoFile.path),
        ),
      );

      Navigator.pop(
        context,
        MediaResult(
          file: videoFile,
          isVideo: true,
          caption: '',
        ),
      );
    } catch (e) {
      setState(() => _isRecording = false);
      debugPrint('Stop video error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _controller!.value.hasError) {
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

          /// Capture button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _takePhoto,
                onLongPressStart: _startVideo,
                onLongPressEnd: _stopVideo,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRecording ? Colors.red : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
