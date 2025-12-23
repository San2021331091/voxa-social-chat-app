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
                // BACK BUTTON
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 12),
                // AVATAR
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
                      onPressed: () {
                     
                      },
                      icon: const Icon(Icons.videocam, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                      
                      },
                      icon: const Icon(Icons.call, color: Colors.white),
                    ),
                    PopupMenuButton<String>(
                      color: AppColor.tealGreen,
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) {
                  
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                            value: "View Contact",
                            child: Text("View Contact", style: TextStyle(color: Colors.white)),
                          ),
                          const PopupMenuItem(
                            value: "Media, Links, and Docs",
                            child: Text("Media, Links, and Docs", style: TextStyle(color: Colors.white)),
                          ),
                          const PopupMenuItem(
                            value: "Search",
                            child: Text("Search", style: TextStyle(color: Colors.white)),
                          ),
                          const PopupMenuItem(
                            value: "Mute Notifications",
                            child: Text("Mute Notifications", style: TextStyle(color: Colors.white)),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // BODY
          const Expanded(
            child: Center(child: Text("Chat Screen")),
          ),
        ],
      ),
    );
  }
}
