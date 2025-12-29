import 'package:flutter/material.dart';
import 'package:voxa/pages/camerapage.dart';
import 'package:voxa/pages/chatpage.dart';
import 'package:voxa/colors/colors.dart';
import 'package:voxa/screens/calllistscreen.dart';
import 'package:voxa/screens/creategroup.dart';
import 'package:voxa/screens/status_screen.dart';

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
              colors: [AppColor.dartTealGreen, AppColor.lightGreen],
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
                        color: AppColor.dartTealGreen,
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: "New Group",
                            child: const Text(
                              "New Group",
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                     const CreateGroup(),
                                ),
                              );
                            },
                          ),

                          PopupMenuItem(
                            value: "New Community",
                            child: const Text(
                              "New Community",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                         
                          PopupMenuItem(
                            value: "My Profile",
                            child: const Text(
                              "My profile",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                          PopupMenuItem(
                            value: "Contacts",
                            child: const Text(
                              "Contacts",
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
          const StatusScreen(),
          const CallListScreen(),
        ],
      ),
    );
  }
}
