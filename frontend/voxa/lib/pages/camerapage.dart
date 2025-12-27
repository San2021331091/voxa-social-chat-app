import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voxa/pages/camerarecordpage.dart';


enum CameraMode { photo, video }

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  int selectedCameraIndex = 0;

  FlashMode flashMode = FlashMode.off;
  final ImagePicker _picker = ImagePicker();

  CameraMode mode = CameraMode.photo;
  bool isRecording = false;
  bool isPaused = false;

  Timer? _timer;
  int recordingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(
      cameras![selectedCameraIndex],
      ResolutionPreset.high,
      enableAudio: true,
    );
    await _controller!.initialize();
    setState(() {});
  }

  /// -------- GALLERY --------
Future<void> _pickFromGallery() async {
  final XFile? image =
      await _picker.pickImage(source: ImageSource.gallery);

  if (image == null || !mounted) return;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CameraRecordPage(file: File(image.path)),
    ),
  );
}


  /// -------- CAMERA CONTROLS --------
  Future<void> _switchCamera() async {
    selectedCameraIndex = selectedCameraIndex == 0 ? 1 : 0;
    await _controller?.dispose();
    _initCamera();
  }

  Future<void> _toggleFlash() async {
    flashMode = flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    await _controller?.setFlashMode(flashMode);
    setState(() {});
  }

  /// -------- PHOTO --------
  Future<void> _capturePhoto() async {
    final XFile file = await _controller!.takePicture();

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CameraRecordPage(file: File(file.path))),
    );
  }

  /// -------- VIDEO --------
  Future<void> _startVideo() async {
    await _controller!.startVideoRecording();
    recordingSeconds = 0;
    isRecording = true;
    isPaused = false;
    _startTimer();
    setState(() {});
  }

  Future<void> _pauseVideo() async {
    await _controller!.pauseVideoRecording();
    _timer?.cancel();
    isPaused = true;
    setState(() {});
  }

  Future<void> _resumeVideo() async {
    await _controller!.resumeVideoRecording();
    _startTimer();
    isPaused = false;
    setState(() {});
  }

Future<void> _stopVideo() async {
  _timer?.cancel();

  final XFile file = await _controller!.stopVideoRecording();

  isRecording = false;
  isPaused = false;

  if (!mounted) return;

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CameraRecordPage(file: File(file.path)),
    ),
  );
}


  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => recordingSeconds++);
    });
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

          /// TOP BAR
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circleButton(Icons.close, () => Navigator.pop(context)),
                _circleButton(
                  flashMode == FlashMode.off ? Icons.flash_off : Icons.flash_on,
                  _toggleFlash,
                ),
              ],
            ),
          ),

          /// TIMER
          if (isRecording)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  _formatTime(recordingSeconds),
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          /// BOTTOM CONTROLS
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _circleButton(Icons.photo, _pickFromGallery),

                    /// CAPTURE BUTTON
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {
                        if (mode == CameraMode.photo) {
                          _capturePhoto();
                        } else {
                          isRecording ? _stopVideo() : _startVideo();
                        }
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isRecording ? Colors.red : Colors.white,
                            width: 5,
                          ),
                        ),
                      ),
                    ),

                    _circleButton(Icons.cameraswitch, _switchCamera),
                  ],
                ),

                const SizedBox(height: 10),

                /// PAUSE / RESUME BUTTON (VIDEO ONLY)
                if (mode == CameraMode.video && isRecording)
                  InkWell(
                    onTap: isPaused ? _resumeVideo : _pauseVideo,
                    child: Text(
                      isPaused ? "Resume" : "Pause",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                const SizedBox(height: 10),

                /// MODE SWITCH
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => setState(() => mode = CameraMode.video),
                      child: Text(
                        "Video",
                        style: TextStyle(
                          color: mode == CameraMode.video
                              ? Colors.white
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    InkWell(
                      onTap: () => setState(() => mode = CameraMode.photo),
                      child: Text(
                        "Photo",
                        style: TextStyle(
                          color: mode == CameraMode.photo
                              ? Colors.white
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.black54,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
