import 'package:flutter/material.dart';
import 'package:voxa/screens/homescreen.dart';

void main() { //entry point of the main application.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Poppins",
        useMaterial3: true 
      ),

      home : const HomeScreen(),
  
      
    );
  }
}
