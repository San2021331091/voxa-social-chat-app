import 'package:flutter/material.dart';
import 'package:voxa/pages/camerapage.dart';
import 'package:voxa/pages/statusviewer.dart';
import 'package:voxa/status/statusmodel.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final List<StatusModel> recentStatuses = [
    StatusModel(
      name: 'John',
      image: 'https://i.pravatar.cc/150?img=1',
      time: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    StatusModel(
      name: 'Emma',
      image: 'https://i.pravatar.cc/150?img=2',
      time: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  final List<StatusModel> seenStatuses = [
    StatusModel(
      name: 'Alex',
      image: 'https://i.pravatar.cc/150?img=3',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      seen: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: ListView(
        children: [
          _myStatusTile(),
          _sectionTitle('Recent updates'),
          ...recentStatuses.map(_statusTile),
          _sectionTitle('Viewed updates'),
          ...seenStatuses.map(_statusTile),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF25D366),
        child: const Icon(Icons.camera_alt,color: Colors.white,),
        onPressed: () {
       
        },
      ),
    );
  }

  // My Status
  Widget _myStatusTile() {
    return ListTile(
      leading: Stack(
        children: [
          const CircleAvatar(
            radius: 26,
            backgroundImage:
                NetworkImage('https://i.pravatar.cc/150?img=10'),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF25D366),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, size: 18, color: Colors.white),
            ),
          )
        ],
      ),
      title: const Text('My status',style: TextStyle(color:Colors.blue,fontWeight: FontWeight.w700)),
      subtitle: const Text('Tap to add status update',style: TextStyle(color: Colors.pink,fontWeight: FontWeight.bold)),
      onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (_)=> const CameraPage()));
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green,
      
        ),
      ),
    );
  }

  Widget _statusTile(StatusModel status) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: status.seen ? Colors.grey : const Color(0xFF25D366),
            width: 3,
          ),
        ),
        child: CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(status.image),
        ),
      ),
      title: Text(status.name,style: const TextStyle(color: Colors.deepPurpleAccent,fontWeight: FontWeight.w600)),
      subtitle: Text(_timeAgo(status.time),style: const TextStyle(color: Colors.deepOrange,fontStyle: FontStyle.italic,fontWeight:FontWeight.w700),),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StatusViewer(status: status),
          ),
        );
      },
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    }
    return '${diff.inHours} hours ago';
  }
}
