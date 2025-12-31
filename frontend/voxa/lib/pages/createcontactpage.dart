import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voxa/colors/colors.dart';

class CreateContactPage extends StatefulWidget {
  const CreateContactPage({super.key});

  @override
  State<CreateContactPage> createState() => _CreateContactPageState();
}

class _CreateContactPageState extends State<CreateContactPage> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  /// Open Camera
  Future<void> _openCamera() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() => _profileImage = File(image.path));
    }
  }

  /// Open Gallery
  Future<void> _openGallery() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _profileImage = File(image.path));
    }
  }

  /// Image Source Popup
  void _showImageSourcePopup() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Image Source",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _imageSourceItem(
                    icon: Icons.camera_alt,
                    label: "Camera",
                    onTap: () {
                      Navigator.pop(context);
                      _openCamera();
                    },
                  ),
                  _imageSourceItem(
                    icon: Icons.photo,
                    label: "Gallery",
                    onTap: () {
                      Navigator.pop(context);
                      _openGallery();
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _imageSourceItem({
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
            radius: 28,
            backgroundColor: AppColor.dartTealGreen,
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          "Create new contact",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // SAVE CONTACT
            },
            child: const Text(
              "SAVE",
              style: TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColor.dartTealGreen, AppColor.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.pink,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showImageSourcePopup,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColor.lightGreen,
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// First Name
            _inputField(
              controller: _firstName,
              label: "First name",
              icon: Icons.person_outline,
              color: Colors.deepOrange,
            ),

            const SizedBox(height: 20),

            /// Last Name
            _inputField(
              controller: _lastName,
              label: "Last name",
              icon: Icons.badge_outlined,
              color: Colors.purple,
            ),

            const SizedBox(height: 20),

            /// Phone Number
            _inputField(
              controller: _phone,
              label: "Phone number",
              icon: Icons.phone_android,
              color: Colors.blue,
              keyboard: TextInputType.phone,
            ),

            const SizedBox(height: 40),

            const Text(
              "This contact will be saved to your device",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Custom colorful input field
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: color),
        labelText: label,
        labelStyle: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 2),
        ),
      ),
    );
  }
}
