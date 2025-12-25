import 'package:flutter/material.dart';
import 'package:voxa/pages/camerapage.dart';
import 'package:voxa/pages/chatpage.dart';
import 'package:voxa/colors/colors.dart';

// HomeScreen widget with TabBar and AppBar
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

// State class for HomeScreen
class HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.tealGreen, // deep teal green
                AppColor.lightGreen, // modern light green
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // AppBar content
                ListTile(
                  title: const Text(
                    "Voxa",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {},
                      ),
                      PopupMenuButton<String>(
                        color: AppColor.tealGreen,
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: "New Group",
                            child: const Text(
                              "New Group",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                          PopupMenuItem(
                            value: "New Broadcast",
                            child: const Text(
                              "New Broadcast",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                          PopupMenuItem(
                            value: "Voxa Web",
                            child: const Text(
                              "Voxa Web",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          PopupMenuItem(
                            value: "Starred Messages",
                            child: const Text(
                              "Starred Messages",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                          PopupMenuItem(
                            value: "Settings",
                            child: const Text(
                              "Settings",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // TabBar
                TabBar(
                  controller: tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Colors.white,
                  tabs: const [
                    Tab(icon: Icon(Icons.camera_alt)),
                    Tab(text: "Chats"),
                    Tab(text: "Status"),
                    Tab(text: "Calls"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          const CameraPage(),
          const ChatPage(),
          Center(child: Text("Status Screen")),
          Center(child: Text("Calls Screen")),
        ],
      ),
    );
  }
}
