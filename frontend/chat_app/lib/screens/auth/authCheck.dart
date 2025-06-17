import 'package:chat_app/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../chat/chat_list_screen.dart';
import 'register_page.dart';


class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

 Future<void> _checkAuth() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final userId = prefs.getString('userId');
  print("$userId,$token kashav");

  if (token != null && token.isNotEmpty && userId != null && userId.isNotEmpty) {
    Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => const BottomNavigationBarWhatsApp()),
);

  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => RegisterPage()),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    // Show loading while checkingx
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
