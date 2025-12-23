import 'package:flutter/material.dart';

class IndividualPage extends StatefulWidget {
  const IndividualPage({super.key});

  @override
  IndividualPageState createState() => IndividualPageState();
  
 
}


class IndividualPageState extends State<IndividualPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Individual Page"),
      ),
      body: const Center(
        child: Text("This is the Individual Page"),
      ),
    );
  }
}