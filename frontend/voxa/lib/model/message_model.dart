class MessageModel {
  final String sender;
  final String message;
  final String time;
  final bool isMe;

  MessageModel({
    required this.sender,
    required this.message,
    required this.time,
    required this.isMe,
  });
}
