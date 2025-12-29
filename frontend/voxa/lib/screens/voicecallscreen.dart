import 'package:flutter/material.dart';
import 'package:voxa/colors/colors.dart';
import 'package:voxa/screens/videocallscreen.dart';


class VoiceCallScreen extends StatefulWidget {
  final String callerName;
  final String callerAvatar;

  const VoiceCallScreen({
    super.key,
    required this.callerName,
    required this.callerAvatar,
  });

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  bool isMuted = false;
  bool isSpeakerOn = false;

  String callStatus = "Ringing...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColor.lightGreen,AppColor.dartTealGreen,AppColor.tealGreen],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 50),
              // Caller info
              Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(widget.callerAvatar),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.callerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    callStatus,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              // Action buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mute
                    _buildActionButton(
                      icon: isMuted ? Icons.mic_off : Icons.mic,
                      label: 'Mute',
                      color: Colors.white,
                      bgColor: isMuted ? Colors.redAccent : Colors.deepOrange,
                      onTap: () {
                        setState(() {
                          isMuted = !isMuted;
                        });
                      },
                    ),
                    // Speaker
                    _buildActionButton(
                      icon: isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                      label: 'Speaker',
                      color: Colors.white,
                      bgColor: isSpeakerOn ? const Color.fromARGB(255, 6, 239, 14) : const Color.fromARGB(255, 222, 4, 117),
                      onTap: () {
                        setState(() {
                          isSpeakerOn = !isSpeakerOn;
                        });
                      },
                    ),
                    // End Call
                    _buildActionButton(
                      icon: Icons.call_end,
                      label: 'End',
                      color: Colors.white,
                      bgColor: Colors.redAccent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    // Video call
                    _buildActionButton(
                      icon: Icons.videocam,
                      label: 'Video',
                      color: Colors.white,
                      bgColor: Colors.blueAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VideoCallScreen(callerName: widget.callerName, callerAvatar: widget.callerAvatar)
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
