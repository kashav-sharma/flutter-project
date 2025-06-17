import 'package:chat_app/env.dart';
import 'package:chat_app/screens/auth/profile_setup_page.dart';
import 'package:chat_app/screens/chat/chat_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({required this.phone, Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

 Future<void> _verifyOtp() async {
  final otp = _otpController.text.trim();
  if (otp.length < 4) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Enter a valid OTP')),
    );
    return;
  }

  setState(() => _isLoading = true);

  try {
    final response = await http.post(
      Uri.parse('${Environment.apiUrl}/api/auth/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': widget.phone, 'otp': otp}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Save token and user ID
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("........ ${data['token']}");

      await prefs.setString('token', data['token']);
      await prefs.setString('userId', data['userId']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'OTP Verified!')),
      );

      // Navigate based on user type
      if (data['isNewUser'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ProfileSetupPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ChatListScreen(userId: data['userId']),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Invalid OTP')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Network error')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}
  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Enter OTP sent to ${widget.phone}'),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(hintText: 'OTP'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              // onPressed: (){ Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>ProfileSetupPage()));},
               onPressed: _isLoading ? null : _verifyOtp,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('VERIFY OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
