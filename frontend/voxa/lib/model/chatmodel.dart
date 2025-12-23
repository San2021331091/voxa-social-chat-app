class ChatModel{
  final String name;
  final bool isGroup;
  final String ?currentMessage;
  final String time;

 const ChatModel({ required this.name,required this.isGroup, this.currentMessage, required this.time});

}