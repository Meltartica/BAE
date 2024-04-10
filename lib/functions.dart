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
            MyAppState().revertLoading();
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
  bool isSelected = appState.selectedBenefit == sortType;

  return Padding(
    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
    child: ElevatedButton(
      onPressed: () {
        appState.updateSelectedBenefit(sortType);
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

Widget customDateButton(BuildContext context, String label, String sortType) {
  var appState = Provider.of<MyAppState>(context, listen: false);
  bool isSelected = appState.selectedBenefit == sortType;

  return Padding(
    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
    child: ElevatedButton(
      onPressed: () {
        appState.updateSelectedBenefit(sortType);
        selectDateRange(context);
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

Future<void> selectDateRange(BuildContext context) async {
  var appState = Provider.of<MyAppState>(context, listen: false);
  DateTimeRange initialRange = appState.selectedBenefitDateRange ?? DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 7)),
  );

  final DateTimeRange? picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2015, 8),
    lastDate: DateTime(2101),
    initialDateRange: initialRange,
  );

  if (picked != null) {
    DateTime startDate = DateTime(picked.start.year, picked.start.month, picked.start.day - 1, 23, 59, 59);
    DateTime endDate = DateTime(picked.end.year, picked.end.month, picked.end.day, 23, 59, 59);
    appState.updateBenefitDateRange(DateTimeRange(start: startDate, end: endDate));
  }
}