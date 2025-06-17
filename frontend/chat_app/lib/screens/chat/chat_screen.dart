import 'package:chat_app/env.dart';
import 'package:chat_app/screens/chat/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String receiverName;
  final String receiverImage;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.receiverName,
    required this.receiverImage,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showEmojiPicker = false;
  List<Map<String, dynamic>> _messages = [];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add({"isMe": true, "text": text});
      });
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _messages.add({"isMe": true, "text": "[Image]", "image": File(picked.path)});
      });
      _scrollToBottom();
    }
  }

  Widget _buildMessage(Map msg) {
    bool isMe = msg['isMe'];
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFDCF8C6) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: msg["image"] != null
            ? Image.file(msg["image"], width: 150)
            : Text(msg["text"], style: const TextStyle(fontSize: 16)),
      ),
    );
  }

Widget _buildEmojiPicker() {
  return EmojiPicker(
    onEmojiSelected: (category, emoji) {
      _messageController.text += emoji.emoji;
    },
    config: const Config(
      columns: 7,
      emojiSizeMax: 32,
      bgColor: Color(0xFFF2F2F2),
      indicatorColor: Colors.teal,
      iconColorSelected: Colors.teal,
      backspaceColor: Colors.red,
    ),
  );
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        iconTheme: const IconThemeData(color: Colors.white),
        title: InkWell(
          onTap: () {
            // Open profile view page
           Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileView(
              name: widget.receiverName,
              imagePath: widget.receiverImage,
            ),
          ),
        );
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage('${Environment.apiUrl}/${widget.receiverImage}'),
              ),
              const SizedBox(width: 8),
              Text(widget.receiverName, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      actions: [
  IconButton(
    icon: const Icon(Icons.video_call),
    onPressed: () {
      // Future: handle video call
    },
  ),
  IconButton(
    icon: const Icon(Icons.call),
    onPressed: () {
      // Future: handle voice call
    },
  ),
  PopupMenuButton<String>(
    onSelected: (value) {
      if (value == 'profile') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileView(
              name: widget.receiverName,
              imagePath: widget.receiverImage,
            ),
          ),
        );
      } else if (value == 'clear') {
        setState(() {
          _messages.clear();
        });
      }
    },
    itemBuilder: (context) => [
      const PopupMenuItem(value: 'profile', child: Text('View Profile')),
      const PopupMenuItem(value: 'clear', child: Text('Clear Chat')),
    ],
  ),
]
),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(_messages[index]),
            ),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.grey[100],
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _showEmojiPicker = !_showEmojiPicker;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.grey),
                  onPressed: _pickImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
          if (_showEmojiPicker)
  SizedBox(
    height: 250,
    child: _buildEmojiPicker(),
  ),

        ],
      ),
    );
  }
}
