import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../functions.dart';
import '../main.dart';

class Notification {
  final String title;
  final String body;
  final bool isUrgent;

  Notification({required this.title, required this.body, this.isUrgent = false}); // Modify this line

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'isUrgent': isUrgent,
  };

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      title: json['title'],
      body: json['body'],
      isUrgent: json['isUrgent'],
    );
  }
}

class AlertsPage extends StatefulWidget {
  const AlertsPage({super.key});

  @override
  AlertsPageState createState() => AlertsPageState();
}

class AlertsPageState extends State<AlertsPage> {
  late MyAppState appState;

  @override
  void initState() {
  super.initState();
  appState = Provider.of<MyAppState>(context, listen: false);
  }

  void dismissNotification(int key) {
    Notification dismissedNotification = appState.notifications[key]!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        appState.notifications.remove(key);
        appState.saveAppState();
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
              appState.notifications[key] = dismissedNotification;
              appState.saveAppState();
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
          if (appState.notifications.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none_rounded,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary),
                      const Text('No notifications yet?',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const Text('You will see your notifications here when they arrive.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(top: constraints.maxHeight * 0.01),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: constraints.maxWidth * 0.975,
                  child: ListView.builder(
                    itemCount: appState.notifications.length,
                    itemBuilder: (context, index) {
                      int key = appState.notifications.keys.toList().reversed.elementAt(index);
                      return Dismissible(
                        key: Key(key.toString()),
                        onDismissed: (direction) {
                          dismissNotification(key);
                        },
                        child: Card(
                          child: ListTile(
                            title: Text(
                              appState.notifications[key]!.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: appState.notifications[key]!.isUrgent ? Colors.red : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            subtitle: Text(
                              appState.notifications[key]!.body,
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
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        appState.notifications[key]!.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(appState.notifications[key]!.body),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: appState.notifications.isEmpty
          ? null
          : FloatingActionButton.extended(
              heroTag: 'clearAll',
              onPressed: () {
                Map<int, String> tempNotifications = Map.from(appState.notifications);
                setState(() {
                  appState.notifications.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('All Notifications Cleared'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        setState(() {
                          appState.notifications = Map.from(tempNotifications);
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