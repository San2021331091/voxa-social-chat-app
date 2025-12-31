import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:voxa/model/chatmodel.dart';
import 'package:voxa/pages/individualpage.dart';
import 'package:voxa/screens/videocallscreen.dart';
import 'package:voxa/screens/voicecallscreen.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    searchController.addListener(_filterContacts);
  }

  Future<void> _fetchContacts() async {
    if (!await FlutterContacts.requestPermission()) return;
    final allContacts =
        await FlutterContacts.getContacts(withProperties: true, withPhoto: true);
    setState(() {
      contacts = allContacts;
      filteredContacts = allContacts;
      isLoading = false;
    });
  }

  void _filterContacts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredContacts = contacts
          .where((c) => c.displayName.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _buildContactTile(Contact contact) {
    return ListTile(
      leading: (contact.photo != null && contact.photo!.isNotEmpty)
          ? CircleAvatar(backgroundImage: MemoryImage(contact.photo!))
          : const CircleAvatar(child: Icon(Icons.person)),
      title: Text(contact.displayName),
      subtitle: contact.phones.isNotEmpty ? Text(contact.phones.first.number) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min, 
        children: [
          IconButton(
            icon: const Icon(Icons.message, color: Colors.green),
            onPressed: () {
             ChatModel chat = ChatModel(name: contact.displayName,img: "assets/person.svg",isGroup: false);
             Navigator.push(context, MaterialPageRoute(builder: (_)=> IndividualPage(chatModel: chat)));
            },
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.blue),
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (_)=> VoiceCallScreen(callerName: contact.displayName, callerAvatar: "https://i.pravatar.cc/150?img=1")));
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.purple),
            onPressed: () {
                 Navigator.push(context,MaterialPageRoute(builder: (_)=> VideoCallScreen(callerName: contact.displayName, callerAvatar: "https://i.pravatar.cc/150?img=1")));
            },
          ),
        ],
      ),
      onTap: () {
        print("Selected: ${contact.displayName}");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff075E54),
        title: const Text("Contacts", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search contacts",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = filteredContacts[index];
                      return _buildContactTile(contact);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
