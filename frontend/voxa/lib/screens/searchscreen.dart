import 'package:flutter/material.dart';
import 'package:voxa/colors/colors.dart';
import 'package:voxa/screens/userprofilescreen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;

  // Contacts data: name + phone + info
  final List<Map<String, String>> allContacts = [
    {
      "name": "Santosh Saha",
      "phone": "+8801234567890",
      "info": "Hey there! I'm using Voxa",
    },
    {
      "name": "Rina Das",
      "phone": "+8809876543210",
      "info": "Available for calls",
    },
    {"name": "Amit Roy", "phone": "+8801122334455", "info": "Busy right now"},
    {"name": "Tina Sen", "phone": "+8805566778899", "info": "At work"},
    {"name": "John Doe", "phone": "+8806677889900", "info": "Hey there!"},
    {"name": "Jane Smith", "phone": "+8804455667788", "info": "Offline"},
  ];

  List<Map<String, String>> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    filteredContacts = List.from(allContacts);

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      final queryDigits = query.replaceAll(
        RegExp(r'\D'),
        '',
      ); // remove non-digits

      setState(() {
        isSearching = query.isNotEmpty;

        filteredContacts = allContacts.where((contact) {
          // Name match
          final nameMatch = contact["name"]!.toLowerCase().contains(query);

          // Phone match: remove non-digit chars from phone
          final phoneDigits = contact["phone"]!.replaceAll(RegExp(r'\D'), '');
          final phoneMatch =
              queryDigits.isNotEmpty && phoneDigits.contains(queryDigits);

          return nameMatch || phoneMatch;
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.dartTealGreen,
        foregroundColor: Colors.white,
        title: _buildSearchBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: filteredContacts.isEmpty
            ? const Center(
                child: Text(
                  "No contacts found",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: filteredContacts.length,
                itemBuilder: (_, index) {
                  final contact = filteredContacts[index];
                  return _buildContactCard(contact);
                },
              ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
          colors: [AppColor.lightGreen, AppColor.dartTealGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search by name or phone...",
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          if (isSearching)
            GestureDetector(
              onTap: () => _searchController.clear(),
              child: const Icon(Icons.close, color: Colors.redAccent),
            ),
        ],
      ),
    );
  }

  Widget _buildContactCard(Map<String, String> contact) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade400,
          child: Text(
            contact["name"]![0].toUpperCase(),
            style: const TextStyle(
              color: Color.fromARGB(255, 242, 230, 230),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          contact["name"]!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
        subtitle: Text(
          "${contact["phone"]} ${contact["info"]}",
          style: const TextStyle(color: Colors.purple),
        ),
        trailing: IconButton(
          icon: Icon(Icons.info_outline, color: AppColor.tealGreen),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserProfileScreen(
                  name: contact["name"]!,
                  status: contact["info"]!,
                  lastSeen: "Online",
                  phone: contact["phone"]!,
                ),
              ),
            );
          },
        ),
        onTap: () {
          print("Tapped on ${contact["name"]}");
        },
      ),
    );
  }
}
