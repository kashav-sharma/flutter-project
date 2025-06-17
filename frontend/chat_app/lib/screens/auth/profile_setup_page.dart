import 'dart:convert';
import 'dart:io';

import 'package:chat_app/env.dart';
import 'package:chat_app/screens/chat/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProfileSetupPage extends StatefulWidget {
  @override
  _ProfileSetupPageState createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController _nameController = TextEditingController();
  File? _profileImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

 Future<void> _continue() async {
  final name = _nameController.text.trim();
  if (name.isEmpty || _profileImage == null) return;

  try {
    // Upload the image first
    final imageUploadRequest = http.MultipartRequest(
      'POST',
      Uri.parse('${Environment.apiUrl}/api/auth/upload-image'),
    );

    imageUploadRequest.files.add(await http.MultipartFile.fromPath(
      'image',
      _profileImage!.path,
    ));

    final uploadResponse = await imageUploadRequest.send();
    final resBody = await uploadResponse.stream.bytesToString();
    final imageUrl = jsonDecode(resBody)['imageUrl'];

    // Now send name + imageUrl
    final updateResponse = await http.post(
      Uri.parse('${Environment.apiUrl}/api/auth/update-profile'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "phone": "8302414670", // replace with real phone
        "name": name,
        "profileImage": imageUrl,
      }),
    );

    if (updateResponse.statusCode == 200) {
      print("Profile updated successfully!");
      Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>ChatListScreen(userId: '',)));

      // Navigate to home or next screen
    } else {
      print("Failed to update profile");
    }
  } catch (e) {
    print("Error: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set up your profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? Icon(Icons.add_a_photo, size: 40,color: const Color(0xFF075E54),)
                    : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Your Name'),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _nameController.text.trim().isEmpty ? null : _continue,
              style:ElevatedButton.styleFrom(backgroundColor:  const Color(0xFF075E54)),
              child: Text('Continue',style:TextStyle(color: Colors.white)),
              
            )
          ],
        ),
      ),
    );
  }
}
