import 'package:flutter/material.dart';

class NavigationDestinations {
  static const paddingValue = EdgeInsets.symmetric(vertical: 5);

  static List<NavigationRailDestination> getDestinations() {
    return const [
      NavigationRailDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home_rounded),
        label: Text('Home'),
        padding: paddingValue,
      ),
      NavigationRailDestination(
        icon: Icon(Icons.paid_outlined),
        selectedIcon: Icon(Icons.paid_rounded),
        label: Text('Benefits'),
        padding: paddingValue,
      ),
      NavigationRailDestination(
        icon: Icon(Icons.sort_outlined),
        selectedIcon: Icon(Icons.sort_rounded),
        label: Text('Overview'),
        padding: paddingValue,
      ),
      NavigationRailDestination(
        icon: Icon(Icons.notifications_outlined),
        selectedIcon: Icon(Icons.notifications_rounded),
        label: Text('Alerts'),
        padding: paddingValue,
      ),
      NavigationRailDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person_rounded),
        label: Text('Account'),
        padding: paddingValue,
      ),
    ];
  }

  static List<NavigationDestination> getMobileDestinations() {
    return const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home_rounded),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.paid_outlined),
        selectedIcon: Icon(Icons.paid_rounded),
        label: 'Benefits',
      ),
      NavigationDestination(
        icon: Icon(Icons.sort_outlined),
        selectedIcon: Icon(Icons.sort),
        label: 'Overview',
      ),
      NavigationDestination(
        icon: Icon(Icons.notifications_outlined),
        selectedIcon: Icon(Icons.notifications_rounded),
        label: 'Alerts',
      ),
      NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person_rounded),
        label: 'Account',
      ),
    ];
  }
}