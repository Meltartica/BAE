import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BAE',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BAE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isDarkMode = false;
  int _counter = 0;
  int _selectedIndex = 0;
  static const paddingValue = EdgeInsets.symmetric(vertical: 5);

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              elevation: 5,
              groupAlignment: 0,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                  padding: paddingValue,
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.savings_outlined),
                  selectedIcon: Icon(Icons.savings),
                  label: Text('Savings'),
                  padding: paddingValue,
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.payments_outlined),
                  selectedIcon: Icon(Icons.payments),
                  label: Text('Expenses'),
                  padding: paddingValue,
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: Text('Account'),
                  padding: paddingValue,
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'You have pushed the button this many times:',
                    ),
                    Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: _isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 16),
            FloatingActionButton(
              onPressed: _toggleDarkMode,
              tooltip: _isDarkMode ? 'Light Mode' : 'Dark Mode',
              child: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            ),
          ],
        ),
      ),
    );
  }
}

