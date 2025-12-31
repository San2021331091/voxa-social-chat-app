import 'package:flutter/material.dart';
import 'package:voxa/model/chatmodel.dart';
import 'package:voxa/pages/groupchatpage.dart';
import 'package:voxa/screens/createcommunity.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<Map<String, String>> communities = [
    {
      "name": "Flutter Devs",
      "description": "All things Flutter",
      "img": "https://i.pravatar.cc/150?img=5",
    },
    {
      "name": "Family",
      "description": "Family chat group",
      "img": "https://i.pravatar.cc/150?img=6",
    },
    {
      "name": "Work",
      "description": "Office updates",
      "img": "https://i.pravatar.cc/150?img=7",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECE5DD),
      appBar: AppBar(
        backgroundColor: const Color(0xff075E54),
        title: const Text(
          "My Communities",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateNewCommunity()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          // Top card: Start a Community
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xff25D366),
                  child: Icon(Icons.add, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Start a Community",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Bring your groups together",
                        style: TextStyle(fontSize: 14, color: Colors.pink),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateNewCommunity(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              "Your Communities",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          // List of communities
          ...communities.map(
            (community) {
              final chatModel = ChatModel(
                name: community["name"]!,
                img: community["img"]!,
                isGroup: true,
                isCommunity: true,
                about: community["description"],
              );
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(community["img"]!),
                    radius: 24,
                  ),
                  title: Text(
                    community["name"]!,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.deepOrange),
                  ),
                  subtitle: Text(
                    community["description"]!,
                    style: const TextStyle(color: Colors.purple,fontWeight: FontWeight.bold),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => GroupChatPage(group: chatModel),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}



