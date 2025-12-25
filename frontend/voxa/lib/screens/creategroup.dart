import 'package:flutter/material.dart';
import 'package:voxa/colors/colors.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final List<Map<String, String>> contacts = [
    {"name": "Balram", "about": "Flutter Developer"},
    {"name": "Saket", "about": "Web developer"},
    {"name": "Bhanu Dev", "about": "App developer"},
    {"name": "Collins", "about": "React developer"},
    {"name": "Kishor", "about": "Full Stack Web"},
    {"name": "Testing1", "about": "Example work"},
    {"name": "Testing2", "about": "Sharing is caring"},
    {"name": "Divyanshu", "about": ""},
    {"name": "Helper", "about": "Love you Mom Dad"},
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
                // Next screen (Group name page)
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
                      backgroundColor: Colors.grey,
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
                          backgroundColor: Colors.grey,
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
                  style: const TextStyle(fontSize: 12),
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
        final isSelected = selectedUsers.contains(contact["name"]);

        return ListTile(
          leading: Stack(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.grey,
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
            contact["name"]!,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(contact["about"] ?? ""),
          onTap: () {
            setState(() {
              isSelected
                  ? selectedUsers.remove(contact["name"])
                  : selectedUsers.add(contact["name"]!);
            });
          },
        );
      },
    );
  }
}
