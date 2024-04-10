import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../lists/expenses_list.dart';
import 'package:intl/intl.dart';
import '../input_pages/add_expenses_page.dart';
import 'search_page.dart';
import '../main.dart';

class Expense {
  final String item;
  final double price;
  final String category;
  final DateTime date;
  final String type;

  Expense({
    required this.item,
    required this.price,
    required this.category,
    required this.date,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'item': item,
        'price': price,
        'category': category,
        'date': date.toIso8601String(),
        'type': type,
      };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    item: json['item'],
    price: (json['price'] is int) ? (json['price'] as int).toDouble() : json['price'],
    category: json['category'],
    date: DateTime.parse(json['date']),
    type: json['type'],
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String? selectedCategory;
  String? selectedExpenseType;
  String selectedButton = 'All';

  final ScrollController _scrollController = ScrollController();
  bool _showFab = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_showFab == true) {
          setState(() {
            _showFab = false;
          });
        }
      }

      if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (_showFab == false) {
          setState(() {
            _showFab = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<MyAppState>(
      builder: (context, appState, child) {
        double totalSpent = appState.expenses
            .where((expense) => expense.type != 'Income')
            .fold(0, (prev, element) => prev + element.price);
        double totalIncome = appState.expenses
            .where((expense) => expense.type == 'Income')
            .fold(0, (prev, element) => prev + element.price);
        double totalBalance = totalIncome - totalSpent;

        final categories = appState.expenses.map((e) => e.category).toSet().toList();
        final expenseTypes = appState.expenses.map((e) => e.type).toSet().toList();
        final List<String> dateFilters = [
          'All',
          'Daily',
          'Weekly',
          'Monthly',
          'Yearly',
          'Select Date Range'
        ];

        final filteredExpenses = appState.expenses
            .where((expense) =>
            (selectedCategory == null ||
                expense.category == selectedCategory) &&
            (selectedExpenseType == null ||
                expense.type == selectedExpenseType))
            .toList();

        final groupedExpenses = groupBy(filteredExpenses, (Expense e) {
          return DateFormat('MMMM dd, yyyy').format(e.date);
        });

        final dateFilteredExpenses =
        Map.fromEntries(groupedExpenses.entries.where((entry) {
          var entryDate = DateFormat('MMMM dd, yyyy').parse(entry.key);
          if (appState.selectedButton == 'All') {
            return true;
          } else if (appState.selectedButton == 'Daily') {
            return entryDate.day == DateTime.now().day &&
                entryDate.month == DateTime.now().month &&
                entryDate.year == DateTime.now().year;
          } else if (appState.selectedButton == 'Weekly') {
            return entryDate
                .isAfter(DateTime.now().subtract(const Duration(days: 7)));
          } else if (appState.selectedButton == 'Monthly') {
            return entryDate.month == DateTime.now().month &&
                entryDate.year == DateTime.now().year;
          } else if (appState.selectedButton == 'Yearly') {
            return entryDate.year == DateTime.now().year;
          } else if (appState.selectedButton == 'Select Date Range' && appState.selectedDateRange != null) {
            return entryDate.isAfter(appState.selectedDateRange!.start) &&
                entryDate.isBefore(appState.selectedDateRange!.end);
          } else {
            return false;
          }
        }));

        final expensesByDate = dateFilteredExpenses.entries.toList();

        // Sort the expenses by date in descending order (from now to before)
        expensesByDate.sort((a, b) {
          DateTime dateA = DateFormat('MMMM dd, yyyy').parse(a.key);
          DateTime dateB = DateFormat('MMMM dd, yyyy').parse(b.key);
          return dateB.compareTo(dateA);
        });

        String getGreeting() {
          var hour = DateTime.now().hour;
          if (hour < 12) {
            return 'Good morning';
          }
          if (hour < 18) {
            return 'Good afternoon';
          }
          return 'Good evening';
        }

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: AppBar(
              title: const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                  'Benefits',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, right: 15),
                  child: SizedBox(
                    width: 130,
                    height: 40,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.search),
                      label: const Text('Search'),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SearchPage(expenses: appState.expenses),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primaryContainer,
                        ),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              toolbarHeight: 100,
            ),
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              double cardWidth = constraints.maxWidth * 0.975;
              return Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, bottom: 8.0),
                          child: SizedBox(
                            width: cardWidth,
                            child: Text(
                              '${getGreeting()}, ${appState.username}!',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: Card(
                            child: ListTile(
                              title: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Total Balance',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            totalBalance >= 0
                                                ? '\u20B1${totalBalance.toStringAsFixed(2)}'
                                                : '-\u20B1${(-totalBalance).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: totalBalance >= 0
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Total',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Income',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            '+\u20B1${totalIncome.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            ),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Row(
                                            children: [
                                              Text(
                                                'Expenses',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '-\u20B1${totalSpent.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 8, bottom: 8.0),
                          child: SizedBox(
                            width: cardWidth,
                            child: const Text(
                              'This month',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: cardWidth / 2,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.green.shade400
                                              .withOpacity(0.5),
                                          child: const Icon(
                                            Icons.south_west,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Income',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '\u20B1${totalIncome.toStringAsFixed(2)}',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: cardWidth / 2,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.red.shade400
                                              .withOpacity(0.5),
                                          child: const Icon(
                                            Icons.south_east,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Spent',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '\u20B1${totalSpent.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, top: 8, bottom: 8.0),
                          child: SizedBox(
                            width: cardWidth,
                            child: const Text(
                              'Transactions',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding (
                          padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(50, 50),
                                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  ),
                                  child: Text(appState.selectedButton),
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SimpleDialog(
                                          title: const Text('Select Date Filter'),
                                          children: dateFilters.map((String value) {
                                            return SimpleDialogOption(
                                              child: Text(value),
                                              onPressed: () {
                                                if (value == 'Select Date Range') {
                                                  showDateRangePicker(
                                                    context: context,
                                                    firstDate: DateTime(DateTime.now().year - 1),
                                                    lastDate: DateTime(DateTime.now().year + 1),
                                                    initialDateRange: appState.selectedDateRange,
                                                  ).then((dateRange) {
                                                    if (dateRange == null) {
                                                      return;
                                                    }
                                                    setState(() {
                                                      DateTime startDate = DateTime(dateRange.start.year, dateRange.start.month, dateRange.start.day - 1, 23, 59, 59);
                                                      DateTime endDate = DateTime(dateRange.end.year, dateRange.end.month, dateRange.end.day, 23, 59, 59);
                                                      appState.selectedButton = value;
                                                      appState.selectedDateRange = DateTimeRange(start: startDate, end: endDate);
                                                      Navigator.pop(context);
                                                    });
                                                  });
                                                } else {
                                                  setState(() {
                                                    appState.selectedButton =
                                                        value;
                                                  });
                                                  Navigator.pop(context);
                                                }
                                              },
                                            );
                                          }).toList(),
                                        );
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(50, 50),
                                    backgroundColor:
                                    Theme.of(context).colorScheme.primaryContainer,
                                  ),
                                  child: Text(selectedCategory ?? 'Select Category'),
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SimpleDialog(
                                          title: const Text('Select Category'),
                                          children: categories.map((String value) {
                                            return SimpleDialogOption(
                                              child: Text(value),
                                              onPressed: () {
                                                setState(() {
                                                  selectedCategory = value;
                                                });
                                                Navigator.pop(context);
                                              },
                                            );
                                          }).toList(),
                                        );
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(50, 50),
                                    backgroundColor:
                                    Theme.of(context).colorScheme.primaryContainer,
                                  ),
                                  child: Text(
                                      selectedExpenseType ?? 'Select Expense Type'),
                                  onPressed: () {
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SimpleDialog(
                                          title: const Text('Select Expense Type'),
                                          children: expenseTypes.map((String value) {
                                            return SimpleDialogOption(
                                              child: Text(value),
                                              onPressed: () {
                                                setState(() {
                                                  selectedExpenseType = value;
                                                });
                                                Navigator.pop(context);
                                              },
                                            );
                                          }).toList(),
                                        );
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(50, 50),
                                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  ),
                                  child: const Text('Clear Filters'),
                                  onPressed: () {
                                    setState(() {
                                      appState.selectedButton = 'All';
                                      selectedCategory = null;
                                      selectedExpenseType = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (appState.expenses.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.money_off_rounded,
                                      size: 80,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  const Text('No expenses yet?',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  const Text('Start adding your expenses.',
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          )
                        else
                          Column(
                            children: buildExpenseList(context, expensesByDate, cardWidth),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
          floatingActionButton: _showFab
          ? FloatingActionButton.extended(
            heroTag: 'addExpense',
            onPressed: () async {
              final newExpense = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddExpensePage()),
              );
              if (newExpense != null) {
                appState.addExpense(newExpense);
              }
            },
            label: const Text('Add'),
            icon: const Icon(Icons.add),
          ): null,
        );
      },
    );
  }
}