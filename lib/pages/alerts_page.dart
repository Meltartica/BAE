import 'package:flutter/material.dart';
import '../functions.dart';

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  AlertsPageState createState() => AlertsPageState();
}

class AlertsPageState extends State<AlertsPage> {
  String loremIpsum =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
  late Map<int, String> notifications;

  @override
  void initState() {
    super.initState();
    notifications = Map.fromIterable(
      List.generate(10, (index) => index),
      value: (index) => loremIpsum.split(" ").take(50).join(" "),
    );
  }

  void dismissNotification(int key) {
    String dismissedNotification = notifications[key]!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        notifications.remove(key);
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notification Dismissed',
            style: Theme.of(context).textTheme.bodyLarge),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              notifications[key] = dismissedNotification;
            });
          },
          textColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBarBuilder.buildAppBar('Alerts'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.only(top: constraints.maxHeight * 0.01),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: constraints.maxWidth * 0.975,
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    int key = notifications.keys.elementAt(index);
                    return Dismissible(
                      key: Key(key.toString()),
                      onDismissed: (direction) {
                        dismissNotification(key);
                      },
                      child: Card(
                        child: ListTile(
                          title: Text('Notification ${index + 1}'),
                          subtitle: Text(
                            notifications[key]!,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              dismissNotification(key);
                            },
                          ),
                          onTap: () {
                            if (MediaQuery.of(context).size.width > 600) {
                              showCustomDialog(context, index, notifications);
                            } else {
                              showCustomBottomSheet(
                                  context, index, notifications);
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: notifications.isEmpty
          ? null
          : FloatingActionButton.extended(
              heroTag: 'clearAll',
              onPressed: () {
                Map<int, String> tempNotifications = Map.from(notifications);
                setState(() {
                  notifications.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All Notifications Cleared'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        setState(() {
                          notifications = Map.from(tempNotifications);
                        });
                      },
                    ),
                  ),
                );
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
