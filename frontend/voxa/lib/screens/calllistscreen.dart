import 'package:flutter/material.dart';
import 'package:voxa/model/call_model.dart';

class CallListScreen extends StatefulWidget {
  const CallListScreen({super.key});

  @override
  State<CallListScreen> createState() => _CallListScreenState();
}

class _CallListScreenState extends State<CallListScreen> {
  final List<CallModel> calls = [
    CallModel(
      name: 'John',
      avatar: 'https://i.pravatar.cc/150?img=1',
      time: DateTime.now().subtract(const Duration(minutes: 10)),
      type: CallType.incoming,
      media: CallMedia.audio,
    ),
    CallModel(
      name: 'Emma',
      avatar: 'https://i.pravatar.cc/150?img=2',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      type: CallType.outgoing,
      media: CallMedia.video,
    ),
    CallModel(
      name: 'Alex',
      avatar: 'https://i.pravatar.cc/150?img=3',
      time: DateTime.now().subtract(const Duration(days: 1)),
      type: CallType.missed,
      media: CallMedia.audio,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE8F5F9),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: calls.length,
        itemBuilder: (context, index) {
          return _callTile(calls[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 4,
        child: const Icon(Icons.add_call, color: Colors.white),
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Start new call')),
          );
        },
      ),
    );
  }

  // ================= MODERN CALL TILE =================

  Widget _callTile(CallModel call) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.orange,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showCallDetails(call),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(call.avatar),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        call.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _nameColor(call.type),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            _callTypeIcon(call.type),
                            size: 16,
                            color: _callTypeColor(call.type),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _callTypeText(call.type),
                            style: TextStyle(
                              fontSize: 13,
                              color: _callTypeColor(call.type),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTime(call.time),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: _buttonBackground(call.media),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      call.media == CallMedia.video
                          ? Icons.videocam
                          : Icons.call,
                      color: Colors.white,

                    ),
                    onPressed: () => _startCall(call),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Color _nameColor(CallType type) {
    switch (type) {
      case CallType.missed:
        return Colors.redAccent;
      case CallType.outgoing:
        return Colors.deepOrange;
      case CallType.incoming:
        return Colors.teal;
    }
  }

  IconData _callTypeIcon(CallType type) {
    switch (type) {
      case CallType.incoming:
        return Icons.call_received;
      case CallType.outgoing:
        return Icons.call_made;
      case CallType.missed:
        return Icons.call_missed;
    }
  }

  Color _callTypeColor(CallType type) {
    switch (type) {
      case CallType.missed:
        return Colors.redAccent;
      case CallType.outgoing:
        return Colors.deepOrange;
      case CallType.incoming:
        return Colors.teal;
    }
  }

  String _callTypeText(CallType type) {
    switch (type) {
      case CallType.incoming:
        return 'Incoming';
      case CallType.outgoing:
        return 'Outgoing';
      case CallType.missed:
        return 'Missed';
    }
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays == 0) {
      return TimeOfDay.fromDateTime(time).format(context);
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    }
    return '${time.day}/${time.month}/${time.year}';
  }

  // ================= ACTIONS =================

  void _startCall(CallModel call) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Starting ${call.media.name} call with ${call.name}',
        ),
      ),
    );
  }

  void _showCallDetails(CallModel call) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 42,
                backgroundImage: NetworkImage(call.avatar),
              ),
              const SizedBox(height: 14),
              Text(
                call.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _callTypeText(call.type),
                style: TextStyle(
                  color: _callTypeColor(call.type),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionIcon(Icons.call, () => _startCall(call), Colors.greenAccent),
                  _actionIcon(Icons.videocam, () => _startCall(call), Colors.orangeAccent),
                  _actionIcon(Icons.message, () {

                  }, Colors.purpleAccent),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _actionIcon(IconData icon, VoidCallback onTap, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
       
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: bgColor),
        onPressed: onTap,
      ),
    );
  }

  Color _buttonBackground(CallMedia media) {
    return media == CallMedia.video
        ? Colors.orangeAccent
        : Colors.green;
  }

  }

