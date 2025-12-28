import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoViewPage extends StatefulWidget {
  final String path;

  const VideoViewPage({super.key, required this.path});

  @override
  State<VideoViewPage> createState() => _VideoViewPageState();
}

class _VideoViewPageState extends State<VideoViewPage> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      _controller = VideoPlayerController.file(File(widget.path));
      await _controller!.initialize();
      _controller!
        ..setLooping(true)
        ..play();

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Video init error: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body: Center(
        child: _controller == null || !_controller!.value.isInitialized
            ? const CircularProgressIndicator()
            : GestureDetector(
                onTap: () {
                  _controller!.value.isPlaying
                      ? _controller!.pause()
                      : _controller!.play();
                  setState(() {});
                },
                child: AspectRatio(
                  aspectRatio: _controller!.value.aspectRatio,
                  child: VideoPlayer(_controller!),
                ),
              ),
      ),
    );
  }
}
