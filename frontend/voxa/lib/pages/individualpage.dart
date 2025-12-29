import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marquee/marquee.dart';
import 'package:voxa/colors/colors.dart';
import 'package:voxa/model/chatmodel.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:voxa/screens/videocallscreen.dart';
import 'package:voxa/screens/voicecallscreen.dart';

class IndividualPage extends StatefulWidget {
  const IndividualPage({super.key, required this.chatModel});
  final ChatModel chatModel;

  @override
  State<IndividualPage> createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  final TextEditingController _messageController = TextEditingController();
  bool isTyping = false;
  final FocusNode _focusNode = FocusNode();
  bool showEmojiPicker = false;

  @override
  void initState() {
    super.initState();

    _messageController.addListener(() {
      setState(() {
        isTyping = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // HEADER
          Container(
            height: 90,
            padding: const EdgeInsets.only(top: 35, left: 8, right: 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColor.dartTealGreen, AppColor.lightGreen],
              ),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueGrey,
                  child: SvgPicture.asset(
                    widget.chatModel.isGroup!
                        ? "assets/groups.svg"
                        : "assets/persons.svg",
                    height: 34,
                    width: 34,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.chatModel.name!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.5,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        height: 16,
                        child: Marquee(
                          text: "last seen today at 12:00 PM",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                          velocity: 20.0,
                          pauseAfterRound: const Duration(seconds: 1),
                          startPadding: 0.0,
                          blankSpace: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoCallScreen(callerName: widget.chatModel.name!, callerAvatar: "https://i.pravatar.cc/150?img=1" )
                          ),
                        );
                      },
                      icon: const Icon(Icons.videocam, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, 
                        MaterialPageRoute(builder: (_)=> VoiceCallScreen(callerName: widget.chatModel.name!, callerAvatar: "https://i.pravatar.cc/150?img=1")));
                      },
                      icon: const Icon(Icons.call, color: Colors.white),
                    ),
                    PopupMenuButton<String>(
                      color: AppColor.dartTealGreen,
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) {},
                      itemBuilder: (BuildContext context) {
                        return [
                          const PopupMenuItem(
                            value: "View Contact",
                            child: Text(
                              "View Contact",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const PopupMenuItem(
                            value: "Media, Links, and Docs",
                            child: Text(
                              "Media, Links, and Docs",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const PopupMenuItem(
                            value: "Search",
                            child: Text(
                              "Search",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const PopupMenuItem(
                            value: "Mute Notifications",
                            child: Text(
                              "Mute Notifications",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ];
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // BODY - Chat area (Gradient Background)
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColor.lightGreen, // light green
                    AppColor.dartTealGreen, // dark green
                  ],
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Hello! How are you?",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColor.dartTealGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "I'm fine, thanks!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            color: Colors.white,
            child: Row(
              children: [
                // Message field
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: [
                        // Emoji
                        IconButton(
                          icon: Icon(
                            Icons.emoji_emotions_outlined,
                            size: 26,
                            color: Colors.grey.shade700,
                            weight: 900,
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus(); // hide keyboard
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
                            maxLines: 5,
                            minLines: 1,
                            decoration: const InputDecoration(
                              hintText: "Message",
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

                        // Attach
                        IconButton(
                          icon: Icon(
                            Icons.attach_file,
                            size: 26,
                            color: Colors.grey.shade700,
                            weight: 600,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (builder) => bottomSheet(),
                            );
                          },
                        ),

                        // Camera
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            size: 26,
                            color: Colors.grey.shade700,
                            weight: 700,
                          ),
                          onPressed: () {
                            openCamera();
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                // Mic / Send button
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColor.dartTealGreen,
                  child: IconButton(
                    icon: Icon(
                      isTyping ? Icons.send : Icons.mic,
                      color: Colors.white,
                      size: 26,
                      weight: 700,
                    ),
                    onPressed: () {
                      if (isTyping) {
                        // SEND MESSAGE
                        final message = _messageController.text.trim();
                        if (message.isNotEmpty) {
                          print("Sending: $message");
                          _messageController
                              .clear(); // auto switches back to mic
                        }
                      } else {
                        // MIC ACTION
                        print("Start recording");
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          Offstage(
            offstage: !showEmojiPicker,
            child: SizedBox(
              height: 256, // fixed height solves unbounded constraint
              child: EmojiPicker(
                textEditingController: _messageController,
                onEmojiSelected: (category, emoji) {},
                onBackspacePressed: () {
                  _messageController.text = _messageController.text.characters
                      .skipLast(1)
                      .toString();
                  _messageController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _messageController.text.length),
                  );
                },
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
                  viewOrderConfig: const ViewOrderConfig(
                    top: EmojiPickerItem.categoryBar,
                    middle: EmojiPickerItem.emojiView,
                    bottom: EmojiPickerItem.searchBar,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColor.dartTealGreen,
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
                icon: Icons.insert_drive_file,
                label: "Document",
                color: Colors.indigo,
                onTap: () {
                  Navigator.pop(context);
                  pickDocument();
                },
              ),
              _attachmentItem(
                icon: Icons.camera_alt,
                label: "Camera",
                color: Colors.pink,
                onTap: () {
                  Navigator.pop(context);
                  openCamera();
                },
              ),
              _attachmentItem(
                icon: Icons.photo,
                label: "Gallery",
                color: Colors.purple,
                onTap: () {
                  Navigator.pop(context);
                  pickImage();
                },
              ),
            ],
          ),

          const SizedBox(height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _attachmentItem(
                icon: Icons.headphones,
                label: "Audio",
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(context);
                  pickAudio();
                },
              ),
              _attachmentItem(
                icon: Icons.location_on,
                label: "Location",
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  shareLocation();
                },
              ),
              _attachmentItem(
                icon: Icons.person,
                label: "Contact",
                color: Colors.blue,
                onTap: () {
                  Navigator.pop(context);
                  openContactPicker();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _attachmentItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Future<void> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'zip'],
    );

    if (result != null) {
      final file = result.files.single;
      print("Document picked: ${file.name}");
    }
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      print("Image picked: ${image.path}");
    }
  }

  Future<void> openCamera() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
    );

    if (photo != null) {
      print("Photo captured: ${photo.path}");
    }
  }

  Future<void> pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);

    if (result != null) {
      print("Audio picked: ${result.files.single.name}");
    }
  }

  Future<void> shareLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    print("Location: ${position.latitude}, ${position.longitude}");
  }

  Future<void> openContactPicker() async {
    if (!await FlutterContacts.requestPermission()) return;

    final contacts = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (_, index) {
              final c = contacts[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    c.displayName.isNotEmpty ? c.displayName[0] : "?",
                  ),
                ),
                title: Text(c.displayName),
                subtitle: Text(
                  c.phones.isNotEmpty ? c.phones.first.number : "No number",
                ),
                onTap: () {
                  Navigator.pop(context);
                  print(
                    "Selected: ${c.displayName} - ${c.phones.isNotEmpty ? c.phones.first.number : 'No number'}",
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
