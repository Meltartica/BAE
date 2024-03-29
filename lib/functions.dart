import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

// Edit Profile Dialog That is used in the Account Page
class EditProfileDialog extends StatelessWidget {
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
            String newUsername = _usernameController.text;
            Provider.of<MyAppState>(context, listen: false).updateProfile(newUsername);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

// AppBar Builder that is Called in All Pages
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
      toolbarHeight: 100,
    );
  }
}

// Custom Dialog for Screen Width More than 600
void showCustomDialog(BuildContext context, int index, Map<int, String> notifications) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Notification ${index + 1}'),
        content: Container(
          constraints: const BoxConstraints(
            maxWidth: 500,
            maxHeight: 600,
            minWidth: 300,
            minHeight: 300,
          ),
          child: Text(
            notifications[index]!,
            textAlign: TextAlign.justify,
          ),
        ),
        actions: <Widget>[
          ElevatedButton.icon(
            icon: const Icon(Icons.close),
            label: const Text('Close'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.onPrimary),
              foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// Custom Bottom Sheet for Screen Width Less than 600
void showCustomBottomSheet(BuildContext context, int index, Map<int, String> notifications) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.95,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25, right: 25),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.close),
                        label: const Text('Close'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.onPrimary),
                          foregroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.secondary),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text('Notification ${index + 1}', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: constraints.maxWidth * 0.85,
                    child: Text(
                      notifications[index]!,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

void showSimpleDialog(BuildContext context, String title, String notifications) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Container(
          constraints: const BoxConstraints(
            maxWidth: 500,
            maxHeight: 500,
          ),
          child: Text(
            notifications,
            textAlign: TextAlign.justify,
          ),
        ),
        actions: <Widget>[
          ElevatedButton.icon(
            icon: const Icon(Icons.close),
            label: const Text('OK'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.onPrimary),
              foregroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.secondary),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget createSortButton(BuildContext context, String label, String sortType) {
  var appState = Provider.of<MyAppState>(context, listen: false);
  bool isSelected = appState.selectedButton == sortType;

  return Padding(
    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
    child: ElevatedButton(
      onPressed: () {
        appState.updateSelectedButton(sortType);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(50, 50),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        side: isSelected
            ? const BorderSide(
          color: Colors.blue,
          width: 2,
        )
            : null,
      ),
      child: Text(label),
    ),
  );
}