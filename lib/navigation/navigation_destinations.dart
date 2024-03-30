import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class NavigationDestinations {
  static const paddingValue = EdgeInsets.symmetric(vertical: 5);

  static List<NavigationRailDestination> getDestinations(BuildContext context) {
    var appState = Provider.of<MyAppState>(context, listen: false);
    return [
      const NavigationRailDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home_rounded),
        label: Text('Home'),
        padding: paddingValue,
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.paid_outlined),
        selectedIcon: Icon(Icons.paid_rounded),
        label: Text('Benefits'),
        padding: paddingValue,
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.sort_outlined),
        selectedIcon: Icon(Icons.sort_rounded),
        label: Text('Overview'),
        padding: paddingValue,
      ),
      NavigationRailDestination(
        icon: Stack(
          children: <Widget>[
            const Icon(Icons.notifications_outlined),
            if (appState.getNotificationCount() > 0)
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    '${appState.getNotificationCount()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        selectedIcon: Stack(
          children: <Widget>[
            const Icon(Icons.notifications_rounded),
            if (appState.getNotificationCount() > 0)
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    '${appState.getNotificationCount()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        label: const Text('Alerts'),
        padding: paddingValue,
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person_rounded),
        label: Text('Account'),
        padding: paddingValue,
      ),
    ];
  }

  static List<NavigationDestination> getMobileDestinations(BuildContext context) {
    var appState = Provider.of<MyAppState>(context, listen: false);
    return [
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home_rounded),
        label: 'Home',
      ),
      const NavigationDestination(
        icon: Icon(Icons.paid_outlined),
        selectedIcon: Icon(Icons.paid_rounded),
        label: 'Benefits',
      ),
      const NavigationDestination(
        icon: Icon(Icons.sort_outlined),
        selectedIcon: Icon(Icons.sort),
        label: 'Overview',
      ),
      NavigationDestination(
        icon: Stack(
          children: <Widget>[
            const Icon(Icons.notifications_outlined),
            if (appState.getNotificationCount() > 0)
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    '${appState.getNotificationCount()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        selectedIcon: Stack(
          children: <Widget>[
            const Icon(Icons.notifications_rounded),
            if (appState.getNotificationCount() > 0)
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    '${appState.getNotificationCount()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        label: 'Alerts',
      ),
      const NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person_rounded),
        label: 'Account',
      ),
    ];
  }
}