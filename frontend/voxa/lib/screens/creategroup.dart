import 'package:flutter/material.dart';
import 'package:voxa/colors/colors.dart';
import 'package:voxa/model/chatmodel.dart';
import 'package:voxa/pages/addnewgroup.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final List<ChatModel> contacts = const [
    ChatModel(name: "Balram", about: "Flutter Developer", img: ''),
    ChatModel(name: "Saket", about: "Web developer", img: ''),
    ChatModel(name: "Bhanu Dev", about: "App developer", img: ''),
    ChatModel(name: "Collins", about: "React developer", img: ''),
    ChatModel(name: "Kishor", about: "Full Stack Web", img: ''),
    ChatModel(name: "Divyanshu", about: "Love to code", img: ''),
    ChatModel(name: "Helper", about: "Love you Mom Dad", img: ''),
  ];

  final Set<String> selectedUsers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New group",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white)),
            SizedBox(height: 2),
            Text("Add participants",
                style: TextStyle(fontSize: 12, color: Colors.white70,fontWeight:FontWeight.bold)),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.dartTealGreen, AppColor.lightGreen],
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
                  MaterialPageRoute(
                    builder: (_) => AddNewGroup(
                      members: selectedUsers.toList(),
                    ),
                  ),
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

  Widget _selectedUsersBar() {
    return SizedBox(
      height: 90,
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
                      backgroundColor: Color.fromRGBO(33, 150, 243, 1),
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
                          child:
                              Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(name,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.deepPurple)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _contactsList() {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        final name = contact.name;
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
                    child:
                        Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                ),
            ],
          ),
          title: Text(name,
              style: const TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.w600)),
          subtitle: Text(contact.about ?? "",
              style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic)),
          onTap: () {
            setState(() {
              isSelected
                  ? selectedUsers.remove(name)
                  : selectedUsers.add(name);
            });
          },
        );
      },
    );
  }
}
