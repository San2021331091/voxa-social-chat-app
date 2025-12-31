import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voxa/colors/colors.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  String name = "Santosh Saha";
  String about = "Hey there! I am using Voxa";
  String email = "santosh@email.com";
  String status = "Available";
  String location = "Bangladesh";
  final String phone = "+880 1234 567890";

  /// Pick image from camera/gallery
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() => _profileImage = File(image.path));
    }
  }

  /// Show bottom sheet for image picker
  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _imageOption(
              icon: Icons.camera_alt,
              label: "Camera",
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            _imageOption(
              icon: Icons.photo,
              label: "Gallery",
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.teal,
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.teal)),
      ],
    );
  }

  /// Edit bottom sheet for any field
  void _editField(String title, String initial, Function(String) onSave) {
    final controller = TextEditingController(text: initial);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit $title",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: () {
                  onSave(controller.text);
                  Navigator.pop(context);
                },
                child: const Text("SAVE",style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Profile"),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.tealGreen,AppColor.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: ListView(
        children: [
          /// HEADER
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.dartTealGreen,AppColor.lightGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : null,
                      child: _profileImage == null
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImagePicker,
                        child: const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xff25D366),
                          child: Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Tap to edit profile photo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// PROFILE INFO TILES
          _infoTile(
            icon: Icons.person,
            color: Colors.blue,
            title: "Name",
            value: name,
            onTap: () =>
                _editField("Name", name, (v) => setState(() => name = v)),
          ),
          _infoTile(
            icon: Icons.info,
            color: Colors.orange,
            title: "About",
            value: about,
            onTap: () =>
                _editField("About", about, (v) => setState(() => about = v)),
          ),
          _infoTile(
            icon: Icons.email,
            color: Colors.purple,
            title: "Email",
            value: email,
            onTap: () =>
                _editField("Email", email, (v) => setState(() => email = v)),
          ),
          _infoTile(
            icon: Icons.circle,
            color: Colors.green,
            title: "Status",
            value: status,
            onTap: () =>
                _editField("Status", status, (v) => setState(() => status = v)),
          ),
          _infoTile(
            icon: Icons.location_on,
            color: Colors.redAccent,
            title: "Location",
            value: location,
            onTap: () => _editField(
                "Location", location, (v) => setState(() => location = v)),
          ),
          _infoTile(
            icon: Icons.phone,
            color: Colors.teal,
            title: "Phone",
            value: phone,
            enabled: false,
          ),
        ],
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: TextStyle(color: color,fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(color: Colors.blue,fontWeight: FontWeight.bold)),
        trailing: enabled ? Icon(Icons.edit, size: 18, color: color) : null,
        onTap: enabled ? onTap : null,
      ),
    );
  }
}
