import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:voxa/media/media_result.dart';
import 'package:voxa/emoji/emoji_data.dart';

class CameraView extends StatefulWidget {
  final File file;
  const CameraView({super.key, required this.file});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  double rotationAngle = 0.0;
  bool showEmojiPicker = false;
  bool showCropOverlay = false;
  bool isDrawing = false;
  List<Offset?> points = [];
  List<_TextInfo> texts = [];
  Color textColor = Colors.white;
  double textSize = 24;

  final double _captionBarHeight = 70;
  final double _emojiPickerHeight = 120;

  final TextEditingController _captionController = TextEditingController();

  void _rotateImage() => setState(() => rotationAngle += pi / 2);

  void _addTextOverlay() async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text("Add Text", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter text",
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                texts.add(_TextInfo(
                  text: controller.text,
                  offset: const Offset(80, 80),
                  color: textColor,
                  size: textSize,
                ));
              }
              Navigator.pop(context);
            },
            child: const Text("Add", style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image preview with drawing and text
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanUpdate: (details) {
                if (isDrawing) points.add(details.localPosition);
                setState(() {});
              },
              onPanEnd: (_) {
                if (isDrawing) points.add(null);
                setState(() {});
              },
              child: Transform.rotate(
                angle: rotationAngle,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(widget.file, fit: BoxFit.cover),
                    CustomPaint(painter: _DrawingPainter(points)),
                    ...texts.map(
                      (t) => Positioned(
                        left: t.offset.dx,
                        top: t.offset.dy,
                        child: Text(
                          t.text,
                          style: TextStyle(color: t.color, fontSize: t.size),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Crop overlay
          if (showCropOverlay)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Top buttons
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _topButton(Icons.arrow_back, () => Navigator.pop(context)),
                Row(
                  children: [
                    _topButton(Icons.crop, () => setState(() => showCropOverlay = !showCropOverlay)),
                    _topButton(Icons.crop_rotate, _rotateImage),
                    _topButton(Icons.text_fields, _addTextOverlay),
                    _topButton(Icons.edit, () => setState(() => isDrawing = !isDrawing)),
                    _topButton(Icons.emoji_emotions_outlined, () => setState(() => showEmojiPicker = !showEmojiPicker)),
                  ],
                ),
              ],
            ),
          ),

          // Emoji picker
          if (showEmojiPicker)
            Positioned(
              bottom: _captionBarHeight,
              left: 0,
              right: 0,
              child: Container(
                height: _emojiPickerHeight,
                color: Colors.black87,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: EmojiData.emojis.length,
                  itemBuilder: (_, i) {
                    final emoji = EmojiData.emojis[i];
                    return InkWell(
                      onTap: () {
                        _captionController.text += emoji;
                        _captionController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _captionController.text.length),
                        );
                      },
                      child: Center(
                        child: Text(emoji, style: const TextStyle(fontSize: 28)),
                      ),
                    );
                  },
                ),
              ),
            ),

          // Caption bar / send
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                height: _captionBarHeight,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _captionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Add a caption...",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.check),
                      onPressed: () {
                        Navigator.pop(
                          context,
                          MediaResult(
                            file: widget.file,
                            isVideo: false,
                            caption: _captionController.text,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topButton(IconData icon, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white),
        ),
      );
}

class _DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  _DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => true;
}

class _TextInfo {
  final String text;
  final Offset offset;
  final Color color;
  final double size;

  _TextInfo({
    required this.text,
    required this.offset,
    required this.color,
    required this.size,
  });
}
