// import 'package:flutter/material.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ContactListPage extends StatefulWidget {
//   @override
//   _ContactListPageState createState() => _ContactListPageState();
// }

// class _ContactListPageState extends State<ContactListPage> {
//   List<Contact> phoneContacts = [];
//   List<dynamic> appContacts = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchPhoneContacts();
//   }

//   Future<void> fetchPhoneContacts() async {
//     var permission = await Permission.contacts.request();

//     if (permission.isGranted) {
//       Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);
//       phoneContacts = contacts.toList();

//       // Extract phone numbers and send to backend
//       List<String> numbers = [];
//       for (var c in phoneContacts) {
//         for (var p in c.phones!) {
//           numbers.add(p.value!.replaceAll(RegExp(r'[^0-9]'), ''));
//         }
//       }

//       checkRegisteredUsers(numbers);
//     }
//   }

//   Future<void> checkRegisteredUsers(List<String> numbers) async {
//     final response = await http.post(
//       Uri.parse('http://<your-ip>:<port>/api/check-contacts'),
//       headers: {"Content-Type": "application/json"},
//       body: json.encode({"phoneNumbers": numbers}),
//     );

//     if (response.statusCode == 200) {
//       setState(() {
//         appContacts = json.decode(response.body);
//       });
//     } else {
//       print('Failed to fetch registered users');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Contacts"), backgroundColor: Colors.green),
//       body: ListView.builder(
//         itemCount: appContacts.length,
//         itemBuilder: (context, index) {
//           final contact = appContacts[index];
//           return ListTile(
//             leading: CircleAvatar(
//               backgroundImage: NetworkImage('http://<your-ip>:<port>${contact['profileImage']}'),
//             ),
//             title: Text(contact['name']),
//             subtitle: Text(contact['phone']),
//             onTap: () {
//               // Start chat
//             },
//           );
//         },
//       ),
//     );
//   }
// }
