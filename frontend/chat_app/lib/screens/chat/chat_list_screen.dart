import 'package:chat_app/env.dart';
import 'package:chat_app/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatListScreen extends StatefulWidget {
  final String userId; // current user ID
  const ChatListScreen({required this.userId});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  List<dynamic> chatList = [];

  @override
  void initState() {
    super.initState();
     fetchContacts();
  }

  Future<void> fetchContacts() async {
    // Example phone numbers, replace with your actual contacts list
    List<String> phoneNumbers = [
      '9549547869',
      '8302414670',
      // ... your contacts here
    ];

    List<dynamic> users = await checkContacts(phoneNumbers);

    setState(() {
      chatList = users;
    });
  }

 Future<List<dynamic>> checkContacts(List<String> phoneNumbers) async {
  final url = Uri.parse('${Environment.apiUrl}/api/auth/check-contacts');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'phoneNumbers': phoneNumbers,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> users = json.decode(response.body);
      print("usersssss:$users");
      return users;
      
    } else {
      print('Failed to check contacts: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error checking contacts: $e');
    return [];
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Chats",style:TextStyle(color: Colors.white) ,),
        backgroundColor: const Color(0xFF075E54),
      ),
      body: ListView.builder(
        itemCount: chatList.length,
itemBuilder: (context, index) {
  final chat = chatList[index];

  final profileImage = chat['profileImage'] ?? '';
  final name = chat['name'] ?? 'Unknown';
  final lastMessage = chat['lastMessage'] ?? '';
  final timestamp = chat['timestamp']?.toString() ?? '';
  final unreadCount = chat['unreadCount'] ?? 0;

  return ListTile(
    leading: CircleAvatar(
      backgroundImage: profileImage.isNotEmpty
          ?  NetworkImage('${Environment.apiUrl}/$profileImage')
          : null,
      child: profileImage.isEmpty ? Icon(Icons.person) : null,
    ),
    title: Text(name),
    subtitle: Text(lastMessage),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          timestamp.length >= 16 ? timestamp.substring(11, 16) : '',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        if (unreadCount > 0)
          Container(
            margin: EdgeInsets.only(top: 4),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$unreadCount',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
      ],
    ),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatScreen(
            chatId: chat['chatId'] ?? '',
            receiverName: name,
            receiverImage: profileImage,
          ),
        ),
      );
    },
  );
}
     ),
    );
  }
}
