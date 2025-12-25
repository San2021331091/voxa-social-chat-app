import 'package:flutter/material.dart';
import 'package:voxa/colors/colors.dart';


class SelectContact extends StatefulWidget {
  const SelectContact({super.key});

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  final List<Map<String, String>> contacts = [
    {"name": "Dev Stack", "subtitle": "Hi Everyone"},
    {"name": "Kishor Kumar", "subtitle": "Hi Kishor"},
    {"name": "Dev Server Chat", "subtitle": "Hi Everyone on this group"},
    {"name": "Collins", "subtitle": "Hi Dev Stack"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const BackButton(),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select contact", style: TextStyle(fontSize: 18,color:Colors.white)),
            SizedBox(height: 2),
            Text(
              "267 contacts",
              style: TextStyle(fontSize: 12, color: Colors.white70,fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 12),
          Icon(Icons.more_vert, color: Colors.white),
          SizedBox(width: 8),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.tealGreen,
                AppColor.lightGreen,
              ],
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
          ),
          _topTile(
            icon: Icons.person_add,
            title: "New contact",
          ),
          const Divider(),

          ...contacts.map((c) => _contactTile(
                name: c["name"]!,
                subtitle: c["subtitle"]!,
              )),
        ],
      ),
    );
  }

  Widget _topTile({required IconData icon, required String title}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColor.lightGreen,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.red),
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
        style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.deepOrange),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color:Colors.green,fontWeight: FontWeight.w800),
      ),
    );
  }
}
