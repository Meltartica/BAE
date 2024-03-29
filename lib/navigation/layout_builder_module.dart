import 'package:flutter/material.dart';
import 'navigation_destinations.dart';
import '../pages/home_page.dart';
import '../pages/account_page.dart';
import '../pages/alerts_page.dart';
import '../pages/overview_page.dart';
import '../pages/benefits_page.dart';

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
      const BenefitsPage(),
      const OverviewPage(),
      const AlertsPage(),
      const AccountPage(),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return Scaffold(
            body: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                onDestinationSelected(index);
              },
              physics: const NeverScrollableScrollPhysics(),
              children: pages,
            ),
            bottomNavigationBar: NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              selectedIndex: pageIndex,
              onDestinationSelected: (index) {
                _pageController.jumpToPage(index);
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
                    _pageController.jumpToPage(index);
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
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      children: pages,
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