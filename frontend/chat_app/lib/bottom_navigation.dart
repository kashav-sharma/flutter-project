import 'package:chat_app/screens/chat/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Adjust path as needed

class BottomNavigationBarWhatsApp extends StatefulWidget {
  const BottomNavigationBarWhatsApp({super.key});

  @override
  State<BottomNavigationBarWhatsApp> createState() => _BottomNavigationBarWhatsAppState();
}

class _BottomNavigationBarWhatsAppState extends State<BottomNavigationBarWhatsApp> {
  int _selectedIndex = 0;
  String? userId;
  bool isLoading = true;
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');

    // Initialize _pages after userId is loaded
    _pages = [
      ChatListScreen(userId: userId ?? ''),
      const StatusPage(),
      const CallsPage(),
    ];

    setState(() {
      isLoading = false;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("WhatsApp"),
      //   backgroundColor: Colors.teal[800],
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.circle), label: 'Status'),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Status Page'));
}

class CallsPage extends StatelessWidget {
  const CallsPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('Calls Page'));
}
