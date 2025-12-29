enum CallType { incoming, outgoing, missed }
enum CallMedia { audio, video }

class CallModel {
  final String name;
  final String avatar;
  final DateTime time;
  final CallType type;
  final CallMedia media;

  CallModel({
    required this.name,
    required this.avatar,
    required this.time,
    required this.type,
    required this.media,
  });
}
