import 'package:chat_app/screens/auth/authCheck.dart';
import 'package:chat_app/screens/auth/register_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      home: const AuthCheck(), // Start here
    );
  }
}





  
