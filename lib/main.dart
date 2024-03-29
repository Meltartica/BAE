import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication/firebase_options.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import '../pages/pages.dart';
import '../pages/home_page.dart';
import '../pages/benefits_page.dart';
import 'authentication/login_page.dart';
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

  Map<String, double> categoryLimits = {
    'Food': 1000.0,
    'Transport': 1000.0,
    'Entertainment': 1000.0,
    'Allowance' : 1000.0,
    'Salary': 1000.0,
    'Transportation': 1000.0,
    'Miscellaneous': 1000.0,
    'Utilities': 1000.0,
    'Rent': 1000.0,
    'Clothing': 1000.0,
    'Health': 1000.0,
    'Insurance': 1000.0,
    'Education': 1000.0,
    'Others': 1000.0
  };

  Map<String, double> defaultLimits = {
    'Food': 1000.0,
    'Transport': 1000.0,
    'Entertainment': 1000.0,
    'Allowance' : 1000.0,
    'Salary': 1000.0,
    'Transportation': 1000.0,
    'Miscellaneous': 1000.0,
    'Utilities': 1000.0,
    'Rent': 1000.0,
    'Clothing': 1000.0,
    'Health': 1000.0,
    'Insurance': 1000.0,
    'Education': 1000.0,
    'Others': 1000.0
  };

  Timer? _timer;

  ValueNotifier<ThemeMode> get themeModeNotifier => _themeModeNotifier;

  String _username = 'Anonymous';

  String get username => _username;

  List<Expense> expenses = [];

  double _savings = 0.0;

  double get savings => _savings;

  List<Benefit> _benefits = [];

  List<Benefit> get benefits => _benefits;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String selectedButton = 'All';

  void updateSelectedButton(String newButton) {
    selectedButton = newButton;
    notifyListeners();
  }

  MyAppState() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_auth.currentUser != null) {
        loadAppState();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> saveAppState() async {
    try {
      String userId = _auth.currentUser!.uid;
      await _firestore.collection('appState').doc(userId).set({
        '_username': _username,
        '_savings': _savings,
        '_themeMode':
            _themeModeNotifier.value == ThemeMode.dark ? 'dark' : 'light',
        'categoryLimits': jsonEncode(categoryLimits),
        '_benefits': jsonEncode(_benefits.map((e) => e.toJson()).toList()),
        'expenses': jsonEncode(expenses.map((e) => e.toJson()).toList()),
      });
    } catch (e, s) {
      if (kDebugMode) {
        print('Failed to save app state: $e');
      }
      if (kDebugMode) {
        print('Stack trace: $s');
      }
    }
  }

  Future<void> loadAppState() async {
  try {
    String? userId = _auth.currentUser?.uid;
    DocumentSnapshot doc =
        await _firestore.collection('appState').doc(userId).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    _username = data['_username'] ?? 'Anonymous';
    _savings = data['_savings'] ?? 0.0;
    _themeModeNotifier.value =
        data['_themeMode'] == 'dark' ? ThemeMode.dark : ThemeMode.light;
    categoryLimits = (jsonDecode(data['categoryLimits'] ?? '{}') as Map).map((key, value) => MapEntry(key.toString(), double.parse(value.toString())));
    _benefits = (jsonDecode(data['_benefits'] ?? '[]') as List)
        .map((e) => Benefit.fromJson(e))
        .toList();
    expenses = (jsonDecode(data['expenses'] ?? '[]') as List)
        .map((e) => Expense.fromJson(e))
        .toList();
    notifyListeners();
  } catch (e, s) {
    if (kDebugMode) {
      print('Error loading app state: $e');
    }
    if (kDebugMode) {
      print('Stack trace: $s');
    }
  }
}

  void resetUserData() {
    _benefits.clear();
    expenses.clear();
    _username = 'Anonymous';
    categoryLimits = defaultLimits;
    _savings = 0.0;
    _themeModeNotifier.value = ThemeMode.dark;
    notifyListeners();
    saveAppState();
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

  void removeExpense(Expense expense) {
    expenses.remove(expense);
    notifyListeners();
    saveAppState();
  }

  void addSavings(double amount) {
    _savings += amount;
    notifyListeners();
    saveAppState();
  }

  void updateCategoryLimit(String category, double newLimit) {
    categoryLimits[category] = newLimit;
    notifyListeners();
    saveAppState();
  }

  void addBenefit(Benefit benefit) {
    _benefits.add(benefit);
    notifyListeners();
    saveAppState();
  }

  void deleteBenefit(Benefit benefit) {
    _benefits.remove(benefit);
    notifyListeners();
    saveAppState();
  }

  void updateProfile(String newUsername) {
    _username = newUsername;
    notifyListeners();
    saveAppState();
  }

  List<Expense> getExpenses() {
    return expenses;
  }

  Future<void> importAppState() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String fileContent = await file.readAsString();
        Map<String, dynamic> importedData = jsonDecode(fileContent);

        _username = importedData['_username'] ?? 'Anonymous';
        _savings = importedData['_savings'] ?? 0.0;
        _themeModeNotifier.value = importedData['_themeMode'] == 'dark' ? ThemeMode.dark : ThemeMode.light;
        categoryLimits = (importedData['categoryLimits'] as Map).map((key, value) => MapEntry(key.toString(), double.parse(value.toString())));
        _benefits = (importedData['_benefits'] as List).map((e) => Benefit.fromJson(e)).toList();
        expenses = (importedData['expenses'] as List).map((e) => Expense.fromJson(e)).toList();

        notifyListeners();
        saveAppState();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to import app state: $e');
      }
    }
  }

  Future<void> exportAppState() async {
    try {
      Map<String, dynamic> appState = {
        '_username': _username,
        '_savings': _savings,
        '_themeMode': _themeModeNotifier.value == ThemeMode.dark ? 'dark' : 'light',
        'categoryLimits': categoryLimits,
        '_benefits': _benefits.map((e) => e.toJson()).toList(),
        'expenses': expenses.map((e) => e.toJson()).toList(),
      };

      String fileContent = jsonEncode(appState);
      Uint8List bytes = Uint8List.fromList(fileContent.codeUnits);

      await FlutterFileSaver().writeFileAsBytes(
        fileName: 'app_state.json',
        bytes: bytes,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to export app state: $e');
      }
    }
  }
}