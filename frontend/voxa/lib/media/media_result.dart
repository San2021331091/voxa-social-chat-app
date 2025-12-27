import 'dart:io';

class MediaResult {
  final File file;
  final bool isVideo;
  final String caption;

  MediaResult({
    required this.file,
    required this.isVideo,
    required this.caption,
  });
}
