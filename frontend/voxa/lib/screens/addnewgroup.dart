import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewGroup extends StatefulWidget {
  const AddNewGroup({super.key});

  @override
  State<AddNewGroup> createState() => _AddNewGroupState();
}

class _AddNewGroupState extends State<AddNewGroup> {
  final ImagePicker _picker = ImagePicker();
  File? _groupImage;

  /// WhatsApp-like states
  String disappearingMessage = "Off";
  bool onlyAdminsEditInfo = false;
  bool onlyAdminsSendMessage = false;

  /// Open Camera
  Future<void> _openCamera() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _groupImage = File(image.path);
      });
    }
  }

  /// Disappearing Messages Bottom Sheet
  void _showDisappearingMessages() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Disappearing messages",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            _disappearOption("Off"),
            _disappearOption("24 hours"),
            _disappearOption("7 days"),
            _disappearOption("90 days"),
          ],
        );
      },
    );
  }

  Widget _disappearOption(String value) {
    return ListTile(
      title: Text(value),
      trailing:
          disappearingMessage == value ? const Icon(Icons.check) : null,
      onTap: () {
        setState(() {
          disappearingMessage = value;
        });
        Navigator.pop(context);
      },
    );
  }

  /// Group Permissions Dialog
  void _showGroupPermissions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Group permissions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              const Text("Edit group info"),
              RadioListTile(
                title: const Text("All participants"),
                value: false,
                groupValue: onlyAdminsEditInfo,
                onChanged: (value) {
                  setState(() => onlyAdminsEditInfo = value!);
                },
              ),
              RadioListTile(
                title: const Text("Admins only"),
                value: true,
                groupValue: onlyAdminsEditInfo,
                onChanged: (value) {
                  setState(() => onlyAdminsEditInfo = value!);
                },
              ),

              const Divider(),

              const Text("Send messages"),
              RadioListTile(
                title: const Text("All participants"),
                value: false,
                groupValue: onlyAdminsSendMessage,
                onChanged: (value) {
                  setState(() => onlyAdminsSendMessage = value!);
                },
              ),
              RadioListTile(
                title: const Text("Admins only"),
                value: true,
                groupValue: onlyAdminsSendMessage,
                onChanged: (value) {
                  setState(() => onlyAdminsSendMessage = value!);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String get permissionSubtitle {
    if (onlyAdminsEditInfo || onlyAdminsSendMessage) {
      return "Admins only";
    }
    return "All participants";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "New group",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {},
        child: const Icon(Icons.check),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Group Image + Name
            Row(
              children: [
                GestureDetector(
                  onTap: _openCamera,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                        _groupImage != null ? FileImage(_groupImage!) : null,
                    child: _groupImage == null
                        ? const Icon(Icons.camera_alt, color: Colors.white)
                        : null,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Group name",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.green, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                )
              ],
            ),

            const SizedBox(height: 24),

            /// Disappearing Messages
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Disappearing messages"),
              subtitle: Text(disappearingMessage),
              trailing: const Icon(Icons.timer),
              onTap: _showDisappearingMessages,
            ),

            const Divider(),

            /// Group Permissions
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Group permissions"),
              subtitle: Text(permissionSubtitle),
              trailing: const Icon(Icons.settings),
              onTap: _showGroupPermissions,
            ),

            const SizedBox(height: 16),

            /// Members
            const Text(
              "Members: 2",
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 12),

            Row(
              children: const [
                _MemberAvatar(name: "Karim Uddin"),
                SizedBox(width: 16),
                _MemberAvatar(name: "Rahim Miah"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Member Avatar Widget
class _MemberAvatar extends StatelessWidget {
  final String name;

  const _MemberAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: Colors.grey.shade300,
          child: const Icon(Icons.person, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
