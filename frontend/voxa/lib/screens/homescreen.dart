import 'package:flutter/material.dart';
import 'package:voxa/pages/ChatPage.dart';

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
                   Color(0xFF075E54), // deep teal green
                   Color(0xFF25D366), // modern light green
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
                        
                        onSelected: (value) => print(value)
                        
                        ,itemBuilder: (BuildContext context) => [

                       PopupMenuItem(value: "New Group",child: const Text("New Group")),
                       
                       PopupMenuItem(value: "New Broadcast",child: const Text("New Broadcast")),
                       
                       PopupMenuItem(value: "Voxa Web",child: const Text("Voxa Web")),
                       
                       PopupMenuItem(value: "Starred Messages",child: const Text("Starred Messages")),
                       
                       PopupMenuItem(value: "Settings",child: const Text("Settings")),

                      ])

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
        children:  [
          Center(child: Text("Camera Screen")),
          ChatPage(),
          Center(child: Text("Status Screen")),
          Center(child: Text("Calls Screen")),
        ],
      ),
    );
  }
}
