import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'layout_builder_module.dart';
import 'expenses_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: Consumer<MyAppState>(
        builder: (context, appState, child) {
          return MaterialApp(
            title: 'BAE',
            theme: ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.deepPurple,
            ),
            darkTheme: ThemeData.dark(),
            themeMode: appState.themeModeNotifier.value,
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  String _profileImageUrl = '';
  String _username = 'Win';

  String get profileImageUrl => _profileImageUrl;
  String get username => _username;

  void updateProfile(String newProfileImageUrl, String newUsername) {
    _profileImageUrl = newProfileImageUrl;
    _username = newUsername;
    notifyListeners();
  }

  final ValueNotifier<ThemeMode> _themeModeNotifier = ValueNotifier(ThemeMode.dark);

  ValueNotifier<ThemeMode> get themeModeNotifier => _themeModeNotifier;

  void toggleThemeMode() {

    if (_themeModeNotifier.value == ThemeMode.light) {
      _themeModeNotifier.value = ThemeMode.dark;
    } else {
      _themeModeNotifier.value = ThemeMode.light;
    }
    notifyListeners();
  }

  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  void deleteExpense(Expense expense) {
    _expenses.remove(expense);
    notifyListeners();
  }

  double _savings = 0.0;
  double get savings => _savings;

  void addSavings(double amount) {
    _savings += amount;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      pageIndex: pageIndex,
      onDestinationSelected: (value) {
        setState(() {
          pageIndex = value;
        });
      },
    );
  }
}