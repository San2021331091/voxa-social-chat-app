class StatusModel {
  final String name;
  final String image;
  final DateTime time;
  final bool seen;

  StatusModel({
    required this.name,
    required this.image,
    required this.time,
    this.seen = false,
  });
}
