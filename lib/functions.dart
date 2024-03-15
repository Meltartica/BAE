import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class EditProfileDialog extends StatelessWidget {
  final TextEditingController _profileImageUrlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  EditProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _profileImageUrlController,
              decoration: const InputDecoration(
                hintText: 'Enter new profile picture URL',
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                hintText: 'Enter new username',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Change'),
          onPressed: () {
            String newProfileImageUrl = _profileImageUrlController.text;
            String newUsername = _usernameController.text;
            Provider.of<MyAppState>(context, listen: false).updateProfile(newProfileImageUrl, newUsername);
          },
        ),
      ],
    );
  }
}

class AppBarBuilder {
  static AppBar buildAppBar(String title) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}