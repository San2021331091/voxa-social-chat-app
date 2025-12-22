import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage>{

 @override
  Widget build(BuildContext context) {

 return Scaffold(
     floatingActionButton: FloatingActionButton(onPressed: (){},
     child: Icon(Icons.chat),) ,
      
    );
  }
}
 