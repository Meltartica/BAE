import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'layout_builder_module.dart';
import 'home_page.dart';
import 'benefits_page.dart';
import 'login_page.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      create: (context) {
        MyAppState appState = MyAppState();
        appState.loadAppState();
        return appState;
      },
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
            home: const LoginPage(),
          );
        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  final ValueNotifier<ThemeMode> _themeModeNotifier =
      ValueNotifier(ThemeMode.dark);

  ValueNotifier<ThemeMode> get themeModeNotifier => _themeModeNotifier;

  String _profileImageUrl = '';
  String _username = 'Anonymous';

  String get profileImageUrl => _profileImageUrl;

  String get username => _username;

  List<Expense> expenses = [];

  double _savings = 0.0;

  double get savings => _savings;

  Map<String, double> categoryLimits = {};
  double generalLimit = 0.0;

  List<Benefit> _benefits = [];

  List<Benefit> get benefits => _benefits;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveAppState() async {
    try {
      String userId = _auth.currentUser!.uid;
      await _firestore.collection('appState').doc(userId).set({
        '_profileImageUrl': _profileImageUrl,
        '_username': _username,
        '_savings': _savings,
        '_themeMode':
            _themeModeNotifier.value == ThemeMode.dark ? 'dark' : 'light',
        'categoryLimits': jsonEncode(categoryLimits),
        'generalLimit': generalLimit,
        '_benefits': jsonEncode(_benefits.map((e) => e.toJson()).toList()),
        'expenses': jsonEncode(expenses.map((e) => e.toJson()).toList()),
      });
    } catch (e, s) {
      print('Failed to save app state: $e');
      print('Stack trace: $s');
    }
  }

  Future<void> loadAppState() async {
    try {
      String userId = _auth.currentUser!.uid;
      DocumentSnapshot doc =
          await _firestore.collection('appState').doc(userId).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      _profileImageUrl = data['_profileImageUrl'] ?? '';
      _username = data['_username'] ?? 'Anonymous';
      _savings = data['_savings'] ?? 0.0;
      _themeModeNotifier.value =
          data['_themeMode'] == 'dark' ? ThemeMode.dark : ThemeMode.light;
      categoryLimits = (jsonDecode(data['categoryLimits'] ?? '{}') as Map).map((key, value) => MapEntry(key.toString(), double.parse(value.toString())));
      generalLimit = data['generalLimit'] ?? 0.0;
      _benefits = (jsonDecode(data['_benefits'] ?? '[]') as List)
          .map((e) => Benefit.fromJson(e))
          .toList();
      expenses = (jsonDecode(data['expenses'] ?? '[]') as List)
          .map((e) => Expense.fromJson(e))
          .toList();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void toggleThemeMode() {
    if (_themeModeNotifier.value == ThemeMode.light) {
      _themeModeNotifier.value = ThemeMode.dark;
    } else {
      _themeModeNotifier.value = ThemeMode.light;
    }
    notifyListeners();
    saveAppState();
  }

  void addExpense(Expense expense) {
    expenses.add(expense);
    notifyListeners();
    saveAppState();
  }

  void deleteExpense(Expense expense) {
    expenses.remove(expense);
    notifyListeners();
    saveAppState();
  }

  void addSavings(double amount) {
    _savings += amount;
    notifyListeners();
    saveAppState();
  }

  void setCategoryLimit(String category, double limit) {
    categoryLimits[category] = limit;
    notifyListeners();
    saveAppState();
  }

  void setGeneralLimit(double limit) {
    generalLimit = limit;
    notifyListeners();
    saveAppState();
  }

  void addBenefit(Benefit benefit) {
    _benefits.add(benefit);
    notifyListeners();
    saveAppState();
  }

  void updateProfile(String newProfileImageUrl, String newUsername) {
    _profileImageUrl = newProfileImageUrl;
    _username = newUsername;
    notifyListeners();
    saveAppState();
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
