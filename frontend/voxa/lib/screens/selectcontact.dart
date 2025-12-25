import 'package:flutter/material.dart';
import 'package:voxa/colors/colors.dart';
import 'package:voxa/model/chatmodel.dart';
import 'package:voxa/screens/creategroup.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({super.key});

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  final List<ChatModel> contacts = const [
    ChatModel(name: "Dev Stack", about: "Hi Everyone"),
    ChatModel(name: "Kishor Kumar", about: "Hi Kishor"),
    ChatModel(name: "Dev Server Chat", about: "Hi Everyone on this group"),
    ChatModel(name: "Collins", about: "Hi Dev Stack"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select contact",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            SizedBox(height: 2),
            Text(
              "267 contacts",
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {},
          ),
          const SizedBox(width: 12),
          PopupMenuButton<String>(
            color: AppColor.tealGreen,
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              switch (value) {
                case 'invite':
                  print('Invite a friend');
                  break;
                case 'contacts':
                  print('Contacts');
                  break;
                case 'refresh':
                  print('Refresh');
                  break;
                case 'help':
                  print('Help');
                  break;
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'invite',
                child: Text(
                  'Invite a friend',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              PopupMenuItem(
                value: 'contacts',
                child: Text('Contacts', style: TextStyle(color: Colors.white)),
              ),
              PopupMenuItem(
                value: 'refresh',
                child: Text('Refresh', style: TextStyle(color: Colors.white)),
              ),
              PopupMenuItem(
                value: 'help',
                child: Text('Help', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.tealGreen, AppColor.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: ListView(
        children: [
          _topTile(
            icon: Icons.group,
            title: "New group",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (builder) => const CreateGroup()),
              );
            },
          ),
          _topTile(icon: Icons.person_add, title: "New contact", onTap: () {}),
          _topTile(
            icon: Icons.group_add_sharp,
            title: "New Community",
            onTap: () {},
          ),
          const Divider(),

          ...contacts.map(
            (c) => _contactTile(name: c.name ?? "", subtitle: c.about ?? ""),
          ),
        ],
      ),
    );
  }

  Widget _topTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColor.lightGreen,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _contactTile({required String name, required String subtitle}) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.blue,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.deepOrange,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
