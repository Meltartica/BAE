import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'layout_builder_module.dart';
import 'home_page.dart';
import 'benefits_page.dart';

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

  late final List<Expense> expenses = [];

  void addExpense(Expense expense) {
    expenses.add(expense);
    notifyListeners();
  }

  void deleteExpense(Expense expense) {
    expenses.remove(expense);
    notifyListeners();
  }

  double _savings = 0.0;
  double get savings => _savings;

  void addSavings(double amount) {
    _savings += amount;
    notifyListeners();
  }

  Map<String, double> categoryLimits = {};
  double generalLimit = 0.0;

  void setCategoryLimit(String category, double limit) {
    categoryLimits[category] = limit;
    notifyListeners();
  }

  void setGeneralLimit(double limit) {
    generalLimit = limit;
    notifyListeners();
  }

  final List<Benefit> _benefits = [];

  List<Benefit> get benefits => _benefits;

  void addBenefit(Benefit benefit) {
    _benefits.add(benefit);
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