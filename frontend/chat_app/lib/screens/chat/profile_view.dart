import 'package:chat_app/env.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  final String name;
  final String imagePath;

  const ProfileView({super.key, required this.name, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF075E54),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage('${Environment.apiUrl}/$imagePath'),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text("Voice Call"),
            onTap: () {}, // implement call
          ),
          ListTile(
            leading: const Icon(Icons.videocam),
            title: const Text("Video Call"),
            onTap: () {}, // implement video call
          ),
        ],
      ),
    );
  }
}
