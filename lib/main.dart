import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication/firebase_options.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:flutter/services.dart';
import '../pages/alerts_page.dart' as alerts;
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
            // For Debugging home: const MyHomePage(),
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

  Map<int, alerts.Notification> notifications = {};

  String _username = 'Anonymous';
  String get username => _username;

  List<Expense> expenses = [];

  double savings = 0.0;

  List<Benefit> _benefits = [];
  List<Benefit> get benefits => _benefits;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String selectedButton = 'All';

  bool isInBenefitsPage = false;

  void updateSelectedButton(String newButton) {
    selectedButton = newButton;
    notifyListeners();
  }

  MyAppState() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_auth.currentUser != null && !isInBenefitsPage) {
        loadAppState();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void notificationsListener(Map<String, String> data) {
    int key = DateTime.now().millisecondsSinceEpoch;

    notifications[key] = alerts.Notification(
      title: data['title'] ?? '',
      body: data['description'] ?? '',
      isUrgent: false,
    );
    notifyListeners();
    saveAppState();
  }

  void urgentNotificationsListener(Map<String, String> data) {
    int key = DateTime.now().millisecondsSinceEpoch;

    notifications[key] = alerts.Notification(
      title: data['title'] ?? '',
      body: data['description'] ?? '',
      isUrgent: true,
    );
    notifyListeners();
    saveAppState();
  }

  int getNotificationCount() {
    return notifications.length;
  }

  Future<void> saveAppState() async {
    try {
      String userId = _auth.currentUser!.uid;
      await _firestore.collection('appState').doc(userId).set({
        '_username': _username,
        'savings': savings,
        '_themeMode': _themeModeNotifier.value == ThemeMode.dark ? 'dark' : 'light',
        'categoryLimits': jsonEncode(categoryLimits),
        '_benefits': jsonEncode(_benefits.map((e) => e.toJson()).toList()),
        'expenses': jsonEncode(expenses.map((e) => e.toJson()).toList()),
        'notifications': jsonEncode(notifications.map((key, value) => MapEntry(key.toString(), value.toJson()))),
      });
    } catch (e, s) {
      if (kDebugMode) {
        print('Error loading app state: $e');
        print('Stack trace: $s');
        Clipboard.setData(ClipboardData(text: 'Error loading app state: $e\nStack trace: $s'));
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
      savings = (data['savings'] ?? 0).toDouble();
      _themeModeNotifier.value =
      data['_themeMode'] == 'dark' ? ThemeMode.dark : ThemeMode.light;
      categoryLimits = (jsonDecode(data['categoryLimits'] ?? '{}') as Map).map((key, value) => MapEntry(key.toString(), double.parse(value.toString())));
      _benefits = (jsonDecode(data['_benefits'] ?? '[]') as List)
          .map((e) => Benefit.fromJson(e))
          .toList();
      expenses = (jsonDecode(data['expenses'] ?? '[]') as List)
          .map((e) => Expense.fromJson(e))
          .toList();
      notifications = (jsonDecode(data['notifications'] ?? '{}') as Map).map((key, value) => MapEntry(int.parse(key), alerts.Notification.fromJson(value)));
      notifyListeners();
      if (kDebugMode) {
        print ('Loaded app state');
      }
    } catch (e, s) {
      if (kDebugMode) {
        print('Error loading app state: $e');
        print('Stack trace: $s');
        Clipboard.setData(ClipboardData(text: 'Error loading app state: $e\nStack trace: $s'));
      }
    }
  }

  void resetUserData() {
    _benefits.clear();
    expenses.clear();
    _username = 'Anonymous';
    categoryLimits = defaultLimits;
    savings = 0.0;
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
    notificationsListener({
      'title': 'New Transaction',
      'description': 'A new transaction has been added successfully.'
    });
    checkCategoryLimits();
    notifyListeners();
    saveAppState();
  }

  void editExpense(Expense expense) {
    expenses.add(expense);
    notificationsListener({
      'title': 'Edited Transaction',
      'description': 'An existing transaction has been edited successfully.'
    });
    checkCategoryLimits();
    notifyListeners();
    saveAppState();
  }

  void deleteExpense(Expense expense) {
    expenses.remove(expense);
    notifyListeners();
    saveAppState();
  }

  void removeExpense(Expense expense) {
    expenses.remove(expense);
    notificationsListener({
      'title': 'Deleted Transaction',
      'description': 'A existing transaction has been deleted successfully.'
    });
    checkCategoryLimits();
    notifyListeners();
    saveAppState();
  }

  void checkCategoryLimits() {
    // Initialize a map to hold the total expense for each category
    Map<String, double> categoryTotals = {};

    // Iterate over the expenses
    for (var expense in expenses) {
      // Only process expenses of type "Expenses"
      if (expense.type == "Expense") {
        // If the category is not in the map, add it
        if (!categoryTotals.containsKey(expense.category)) {
          categoryTotals[expense.category] = 0.0;
        }
        // Add the expense amount to the total for its category
        categoryTotals[expense.category] = (categoryTotals[expense.category] ?? 0.0) + expense.price;
      }
    }

    // Iterate over the categories and compare the total expense with the limit
    for (var category in categoryLimits.keys) {
      if (categoryTotals.containsKey(category)) {
        double remainingAmount = categoryLimits[category]! - categoryTotals[category]!;
        if (remainingAmount < 0) {
          // If the total expense for a category exceeds its limit, send a notification
          urgentNotificationsListener({
            'title': 'Category Limit Exceeded',
            'description': 'Your spending in the $category category has exceeded the limit by ${remainingAmount.abs().toStringAsFixed(2)}.'
          });
        } else if (remainingAmount < (categoryLimits[category]! * 0.90)) {
          // If the total expense for a category is within its limit, send a notification
          urgentNotificationsListener({
            'title': 'Category Limit Status',
            'description': 'You have ${remainingAmount.toStringAsFixed(2)} left in the $category category before reaching the limit.',
          });
        }
      }
    }
  }

  void addSavings(double amount) {
    savings += amount;
    notifyListeners();
    saveAppState();
  }

  void updateCategoryLimit(String category, double newLimit) {
    categoryLimits[category] = newLimit;
    notificationsListener({
      'title': 'Updated Category Limit',
      'description': 'The category limit has been updated successfully.'
    });
    notifyListeners();
    saveAppState();
  }

  void addBenefit(Benefit benefit) {
    _benefits.add(benefit);
    notificationsListener({
      'title': 'New Benefit',
      'description': 'A new benefit has been added successfully.'
    });
    notifyListeners();
    saveAppState();
  }

  void editBenefit(Benefit benefit) {
    _benefits.add(benefit);
    notificationsListener({
      'title': 'Edited Benefit',
      'description': 'An existing benefit has been edited successfully.'
    });
    notifyListeners();
    saveAppState();
  }

  void removeBenefit(Benefit benefit) {
    _benefits.remove(benefit);
    notificationsListener({
      'title': 'Deleted Benefit',
      'description': 'An existing benefit has been deleted successfully.'
    });
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
    notificationsListener({
      'title': 'Updated Profile Name',
      'description': 'Your profile Name has been successfully renamed to $_username.'
    });
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
        Uint8List fileBytes = result.files.single.bytes!;
        String fileContent = utf8.decode(fileBytes);
        Map<String, dynamic> importedData = jsonDecode(fileContent);

        _username = importedData['_username'] ?? 'Anonymous';
        savings = importedData['savings'] ?? 0.0;
        _themeModeNotifier.value = importedData['_themeMode'] == 'dark' ? ThemeMode.dark : ThemeMode.light;
        categoryLimits = (importedData['categoryLimits'] as Map).map((key, value) => MapEntry(key.toString(), double.parse(value.toString())));
        _benefits = (importedData['_benefits'] as List).map((e) => Benefit.fromJson(e)).toList();
        expenses = (importedData['expenses'] as List).map((e) => Expense.fromJson(e)).toList();
        notifications = (jsonDecode(importedData['notifications'] ?? '{}') as Map).map((key, value) => MapEntry(int.parse(key), alerts.Notification.fromJson(value)));
        notifyListeners();
        saveAppState();
      }
      notificationsListener(
        {
          'title': 'Imported App State',
          'description': 'Your app state has been successfully imported.'
        }
      );
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
        'savings': savings,
        '_themeMode': _themeModeNotifier.value == ThemeMode.dark ? 'dark' : 'light',
        'categoryLimits': categoryLimits,
        '_benefits': _benefits.map((e) => e.toJson()).toList(),
        'expenses': expenses.map((e) => e.toJson()).toList(),
        'notifications': notifications.map((key, value) => MapEntry(key.toString(), value.toJson())),
      };

      String fileContent = jsonEncode(appState);
      Uint8List bytes = Uint8List.fromList(fileContent.codeUnits);

      await FlutterFileSaver().writeFileAsBytes(
        fileName: 'app_state.json',
        bytes: bytes,
      );

      notificationsListener(
        {
          'title': 'Exported App State',
          'description': 'Your app state has been successfully exported.'
        }
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to export app state: $e');
      }
    }
  }
}