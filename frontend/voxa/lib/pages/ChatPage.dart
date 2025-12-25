import 'package:flutter/material.dart';
import 'package:voxa/customui/customcard.dart';
import 'package:voxa/model/chatmodel.dart';
import 'package:voxa/screens/selectcontact.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {

  List<ChatModel> chats = const [
    ChatModel(
        name: "Alice",
        isGroup: false,
        currentMessage: "Hey! Are we still on for today?",
        time: "10:30 AM"),
    ChatModel(
        name: "Study Group",
        isGroup: true,
        currentMessage: "Don't forget to review chapter 5.",
        time: "9:45 AM"),

   ChatModel(
        name: "Health Group",
        isGroup: true,
        currentMessage: "Hi, everyone.",
        time: "6:56 AM"),

  ChatModel(
        name: "Porimol",
        isGroup: false,
        currentMessage: "Hello, raz.",
        time: "8:23 AM"),

        
  ChatModel(
        name: "Rasel",
        isGroup: false,
        currentMessage: "Hey.",
        time: "7:09 AM"),        

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
               Color.fromARGB(255, 11, 187, 17),
              Color.fromARGB(255, 16, 134, 230),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {

            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => const SelectContact()));
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.chat, color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: ( context, index) => CustomCard(chatModel: chats[index]),
    ));
  }
}
