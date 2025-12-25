import 'package:flutter/material.dart';
import 'package:voxa/colors/colors.dart';
import 'package:voxa/model/chatmodel.dart';
import 'package:voxa/screens/AddNewGroup.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final List<ChatModel> contacts = const [
    ChatModel(name: "Balram", about: "Flutter Developer"),
    ChatModel(name: "Saket", about: "Web developer"),
    ChatModel(name: "Bhanu Dev", about: "App developer"),
    ChatModel(name: "Collins", about: "React developer"),
    ChatModel(name: "Kishor", about: "Full Stack Web"),
    ChatModel(name: "Divyanshu", about: "Love to code"),
    ChatModel(name: "Helper", about: "Love you Mom Dad"),
  ];

  final Set<String> selectedUsers = {};

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
              "New group",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Add participants",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
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

      floatingActionButton: selectedUsers.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: AppColor.lightGreen,
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (builder) => const AddNewGroup()),
              );
              },
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            )
          : null,

      body: Column(
        children: [
          if (selectedUsers.isNotEmpty) _selectedUsersBar(),
          Expanded(child: _contactsList()),
        ],
      ),
    );
  }

  // Selected users (top horizontal list)
  Widget _selectedUsersBar() {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: selectedUsers.map((name) {
          return Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: GestureDetector(
                        onTap: () {
                          setState(() => selectedUsers.remove(name));
                        },
                        child: const CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Contacts list
  Widget _contactsList() {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        final name = contact.name ?? "";
        final isSelected = selectedUsers.contains(name);

        return ListTile(
          leading: Stack(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white),
              ),
              if (isSelected)
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: AppColor.lightGreen,
                    child: Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                ),
            ],
          ),
          title: Text(
            name,
            style: const TextStyle(
              color: Colors.deepOrange,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            contact.about ?? "",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
          onTap: () {
            setState(() {
              isSelected ? selectedUsers.remove(name) : selectedUsers.add(name);
            });
          },
        );
      },
    );
  }
}
