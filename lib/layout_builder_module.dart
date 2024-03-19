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
  final PageController _pageController;

  ResponsiveLayout({
    required this.pageIndex,
    required this.onDestinationSelected,
    super.key,
  }) : _pageController = PageController(initialPage: pageIndex);

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const HomePage(),
      const SavingsPage(),
      const ExpensesPage(),
      const AlertsPage(),
      const AccountPage(),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return Scaffold(
            body: PageView(
              controller: _pageController,
              children: pages,
              onPageChanged: (index) {
                onDestinationSelected(index);
              },
            ),
            bottomNavigationBar: NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              selectedIndex: pageIndex,
              onDestinationSelected: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
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
                  onDestinationSelected: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        onDestinationSelected(index);
                      },
                      scrollDirection: Axis.vertical,
                      children: pages, // Add this line
                    ),
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