import 'package:flutter/material.dart';
import 'navigation_destinations.dart';
import 'home_page.dart';
import 'savings_page.dart';
import 'account_page.dart';
import 'alerts_page.dart';
import 'expenses_page.dart';

class ResponsiveLayout extends StatelessWidget {
  final int pageIndex;
  final Function(int) onDestinationSelected;

  const ResponsiveLayout({
    required this.pageIndex,
    required this.onDestinationSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (pageIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const SavingsPage();
        break;
      case 2:
        page = const ExpensesPage();
        break;
      case 3:
        page = const AlertsPage();
        break;
      case 4:
        page = const AccountPage();
        break;
      default:
        throw UnimplementedError('no widget for $pageIndex');
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return Scaffold(
            body: page,
            bottomNavigationBar: NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              selectedIndex: pageIndex,
              onDestinationSelected: onDestinationSelected,
              destinations: NavigationDestinations.getMobileDestinations(),
            ),
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  minWidth: 80,
                  groupAlignment: 0,
                  labelType: NavigationRailLabelType.all,
                  destinations: NavigationDestinations.getDestinations(),
                  selectedIndex: pageIndex,
                  onDestinationSelected: onDestinationSelected,
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: page,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}