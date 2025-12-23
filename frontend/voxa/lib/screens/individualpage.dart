import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:voxa/colors/colors.dart';
import 'package:voxa/model/chatmodel.dart';

class IndividualPage extends StatefulWidget {
  const IndividualPage({super.key, required this.chatModel});
  final ChatModel chatModel;

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  final TextEditingController _messageController = TextEditingController();
  bool isTyping = false;
 
@override
void initState() {
  super.initState();

  _messageController.addListener(() {
    setState(() {
      isTyping = _messageController.text.trim().isNotEmpty;
    });
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER
          Container(
            height: 90,
            padding: const EdgeInsets.only(top: 35, left: 8, right: 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColor.tealGreen,
                  AppColor.lightGreen,
                ],
              ),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueGrey,
                  child: SvgPicture.asset(
                    widget.chatModel.isGroup
                        ? "assets/groups.svg"
                        : "assets/persons.svg",
                    height: 34,
                    width: 34,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.chatModel.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        height: 16,
                        child: Marquee(
                          text: "last seen today at 12:00 PM",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          velocity: 20.0,
                          pauseAfterRound: const Duration(seconds: 1),
                          startPadding: 0.0,
                          blankSpace: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.videocam, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.call, color: Colors.white),
                    ),
                    PopupMenuButton<String>(
                      color: AppColor.tealGreen,
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) {},
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                            value: "View Contact",
                            child:
                                Text("View Contact", style: TextStyle(color: Colors.white)),
                          ),
                          const PopupMenuItem(
                            value: "Media, Links, and Docs",
                            child: Text("Media, Links, and Docs",
                                style: TextStyle(color: Colors.white)),
                          ),
                          const PopupMenuItem(
                            value: "Search",
                            child: Text("Search", style: TextStyle(color: Colors.white)),
                          ),
                          const PopupMenuItem(
                            value: "Mute Notifications",
                            child: Text("Mute Notifications",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // BODY - Chat area
          Expanded(
            child: Container(
              color: Colors.blueAccent[100],
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                children: [
                  // Sample messages
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text("Hello! How are you?"),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColor.tealGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "I'm fine, thanks!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        
Container(
  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
  color: Colors.white,
  child: Row(
    children: [
      // Message field
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              // Emoji
              IconButton(
                icon: Icon(
                  Icons.emoji_emotions_outlined,
                  size: 26,
                  color: Colors.grey.shade700,
                  weight: 700,
                ),
                onPressed: () {},
              ),

              // TextField
              Expanded(
                child: TextField(
                  controller: _messageController,
                  maxLines: 5,
                  minLines: 1,
                  decoration: const InputDecoration(
                    hintText: "Message",
                    border: InputBorder.none,
                  ),
                ),
              ),

              // Attach
              IconButton(
                icon: Icon(
                  Icons.attach_file,
                  size: 26,
                  color: Colors.grey.shade700,
                  weight: 700,
                ),
                onPressed: () {},
              ),

              // Camera
              IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  size: 26,
                  color: Colors.grey.shade700,
                  weight: 700,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),

      const SizedBox(width: 6),

      // Mic / Send button
  CircleAvatar(
  radius: 25,
  backgroundColor: AppColor.tealGreen,
  child: IconButton(
    icon: Icon(
      isTyping ? Icons.send : Icons.mic,
      color: Colors.white,
      size: 26,
      weight: 700,
    ),
    onPressed: () {
      if (isTyping) {
        // SEND MESSAGE
        final message = _messageController.text.trim();
        if (message.isNotEmpty) {
          print("Sending: $message");
          _messageController.clear(); // auto switches back to mic
        }
      } else {
        // MIC ACTION
        print("Start recording");
      }
    },
  ),
),

    ],
  ),
),

        ],
      ),
    );
  }
}
