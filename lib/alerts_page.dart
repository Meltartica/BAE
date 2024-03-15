import 'package:flutter/material.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  _AlertsPageState createState() => _AlertsPageState();
}

class _AlertsPageState extends State<AlertsPage> {
  List<String> notifications = List<String>.generate(10, (index) => 'Notification ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(notifications[index]),
            onDismissed: (direction) {
              setState(() {
                notifications.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification dismissed')),
              );
            },
            child: Card(
              child: ListTile(
                title: Text('Notification ${index + 1}'),
                subtitle: Text(notifications[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      notifications.removeAt(index);
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            notifications.clear();
          });
        },
        label: Text(
          'Clear All',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        icon: const Icon(Icons.clear_all),
      ),
    );
  }
}