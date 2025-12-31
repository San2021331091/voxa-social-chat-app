import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:voxa/model/chatmodel.dart';
import 'package:voxa/model/message_model.dart';
import 'package:voxa/screens/videocallscreen.dart';
import 'package:voxa/screens/voicecallscreen.dart';

class GroupChatPage extends StatefulWidget {
  final ChatModel group;
  const GroupChatPage({super.key, required this.group});

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool showEmojiPicker = false;

  final List<MessageModel> messages = [];

  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECE5DD),
      appBar: _greenAppBar(),
      body: Column(
        children: [
          Expanded(child: _messageList()),
          _inputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _greenAppBar() {
    return AppBar(
      elevation: 1,
      backgroundColor: const Color(0xff075E54),
      iconTheme: const IconThemeData(color: Colors.white),
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              widget.group.img ?? "https://i.pravatar.cc/150?img=10",
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.group.name ?? "Group",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const Text(
                "Online",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VideoCallScreen(
                  callerName: widget.group.name!,
                  callerAvatar: "https://i.pravatar.cc/150?img=1",
                ),
              ),
            );
          },
          icon: const Icon(Icons.videocam, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VoiceCallScreen(
                  callerName: widget.group.name!,
                  callerAvatar: "https://i.pravatar.cc/150?img=1",
                ),
              ),
            );
          },
          icon: const Icon(Icons.call, color: Colors.white),
        ),
      ],
    );
  }

  Widget _messageList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return Align(
          alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(14),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              gradient: msg.isMe
                  ? const LinearGradient(
                      colors: [Color(0xff25D366), Color(0xff128C7E)],
                    )
                  : null,
              color: msg.isMe ? null : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!msg.isMe)
                  Text(
                    msg.sender,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff075E54),
                    ),
                  ),
                if (!msg.isMe) const SizedBox(height: 4),
                Text(
                  msg.message,
                  style: TextStyle(
                    fontSize: 15,
                    color: msg.isMe ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    msg.time,
                    style: TextStyle(
                      fontSize: 10,
                      color: msg.isMe ? Colors.white70 : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _inputBar() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  // Emoji Button
                  IconButton(
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.pink,
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        showEmojiPicker = !showEmojiPicker;
                      });
                    },
                  ),

                  // TextField
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                        hintText: "Type a message",
                        border: InputBorder.none,
                      ),
                      onTap: () {
                        if (showEmojiPicker) {
                          setState(() {
                            showEmojiPicker = false;
                          });
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Attach Button
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.green),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (_) => _attachmentBottomSheet(),
                      );
                    },
                  ),

                  // Send Button
                  CircleAvatar(
                    backgroundColor: const Color(0xff25D366),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Emoji Picker
          Offstage(
            offstage: !showEmojiPicker,
            child: SizedBox(
              height: 260,
              child: EmojiPicker(
                textEditingController: _messageController,
                config: Config(
                  checkPlatformCompatibility: true,
                  emojiViewConfig: EmojiViewConfig(
                    emojiSizeMax:
                        28 *
                        (foundation.defaultTargetPlatform ==
                                TargetPlatform.android
                            ? 1.0
                            : 1.2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _attachmentBottomSheet() {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xff075E54),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _attachmentItem(
                Icons.insert_drive_file,
                "Document",
                Colors.indigo,
                () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'doc', 'docx', 'zip'],
                  );
                  if (result != null) {
                    print("Picked Document: ${result.files.single.name}");
                  }
                },
              ),
              _attachmentItem(
                Icons.camera_alt,
                "Camera",
                Colors.pink,
                () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => Container(
                      height: 120,
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo),
                            title: const Text("Image"),
                            onTap: () async {
                              Navigator.pop(context);
                              final image = await _imagePicker.pickImage(
                                source: ImageSource.camera,
                              );
                              if (image != null)
                                print("Captured Image: ${image.path}");
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.videocam),
                            title: const Text("Video"),
                            onTap: () async {
                              Navigator.pop(context);
                              final video = await _imagePicker.pickVideo(
                                source: ImageSource.camera,
                              );
                              if (video != null)
                                print("Captured Video: ${video.path}");
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              _attachmentItem(Icons.photo, "Gallery", Colors.purple, () async {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => Container(
                    height: 120,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.photo,color: Colors.deepOrange,),
                          title: const Text("Image"),
                          onTap: () async {
                            Navigator.pop(context);
                            final image = await _imagePicker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null)
                              print("Picked Image: ${image.path}");
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.videocam,color: Colors.green,),
                          title: const Text("Video"),
                          onTap: () async {
                            Navigator.pop(context);
                            final video = await _imagePicker.pickVideo(
                              source: ImageSource.gallery,
                            );
                            if (video != null)
                              print("Picked Video: ${video.path}");
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _attachmentItem(
                Icons.headphones,
                "Audio",
                Colors.orange,
                () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.audio,
                  );
                  if (result != null)
                    print("Picked Audio: ${result.files.single.name}");
                },
              ),
              _attachmentItem(
                Icons.location_on,
                "Location",
                Colors.green,
                () async {
                  bool serviceEnabled =
                      await Geolocator.isLocationServiceEnabled();
                  if (!serviceEnabled) return;
                  LocationPermission permission =
                      await Geolocator.checkPermission();
                  if (permission == LocationPermission.denied) {
                    permission = await Geolocator.requestPermission();
                  }
                  if (permission == LocationPermission.deniedForever) return;
                  final pos = await Geolocator.getCurrentPosition();
                  print("Location: ${pos.latitude}, ${pos.longitude}");
                },
              ),
              _attachmentItem(Icons.person, "Contact", Colors.blue, () async {
                if (!await FlutterContacts.requestPermission()) return;
                final contacts = await FlutterContacts.getContacts(
                  withProperties: true,
                );

                // Show popup to pick contact
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Select Contact"),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: contacts.length,
                        itemBuilder: (_, index) {
                          final contact = contacts[index];
                          return ListTile(
                            leading:
                                (contact.photo != null &&
                                    contact.photo!.isNotEmpty)
                                ? CircleAvatar(
                                    backgroundImage: MemoryImage(
                                      contact.photo!,
                                    ),
                                  )
                                : const CircleAvatar(child: Icon(Icons.person)),
                            title: Text(contact.displayName),
                            onTap: () {
                              Navigator.pop(context);
                              print("Selected contact: ${contact.displayName}");
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _attachmentItem(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      messages.add(
        MessageModel(
          sender: "You",
          message: _messageController.text,
          time: TimeOfDay.now().format(context),
          isMe: true,
        ),
      );
      _messageController.clear();
    });
  }
}
