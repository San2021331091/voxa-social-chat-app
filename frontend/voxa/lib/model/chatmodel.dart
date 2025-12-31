class ChatModel {
  final String name;
  final String img;
  final bool? isGroup;
  final bool? isCommunity;
  final String ? about;
  final String? currentMessage;
  final String? time;
  

  const ChatModel({required this.name, required this.img, this.isGroup,this.isCommunity, this.about, this.currentMessage, this.time});
}
