import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'add_expenses_page.dart';
import 'functions.dart';
import 'main.dart';

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
        price: json['price'],
        category: json['category'],
        date: DateTime.parse(json['date']),
        type: json['type'],
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory;

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

        final expensesByDate = groupBy(appState.expenses, (Expense e) {
          return DateFormat('MMMM dd, yyyy').format(e.date);
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
            child: AppBarBuilder.buildAppBar('Home'),
          ),
          body: SingleChildScrollView(
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
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Transactions',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
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
                            children: expensesByDate.entries.map((entry) {
                              // Filter the expenses by the selected category
                              var expensesForDateAndCategory =
                                  entry.value.where((Expense expense) {
                                return selectedCategory == null ||
                                    expense.category == selectedCategory;
                              }).toList();

                              if (expensesForDateAndCategory.isEmpty) {
                                return Container();
                              }

                              // Calculate total income and expense for the date
                              double totalIncomeForDate =
                                  expensesForDateAndCategory
                                      .where(
                                          (expense) => expense.type == 'Income')
                                      .fold(
                                          0,
                                          (prev, element) =>
                                              prev + element.price);
                              double totalExpenseForDate =
                                  expensesForDateAndCategory
                                      .where(
                                          (expense) => expense.type != 'Income')
                                      .fold(
                                          0,
                                          (prev, element) =>
                                              prev + element.price);

                              return Column(
                                children: [
                                  SizedBox(
                                    width: cardWidth,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            entry.key,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            (totalIncomeForDate -
                                                        totalExpenseForDate) >=
                                                    0
                                                ? '\u20B1${(totalIncomeForDate - totalExpenseForDate).toStringAsFixed(2)}'
                                                : '-\u20B1${(totalExpenseForDate - totalIncomeForDate).toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: (totalIncomeForDate -
                                                          totalExpenseForDate) >=
                                                      0
                                                  ? Colors.green
                                                  : Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ...expensesForDateAndCategory
                                      .map((Expense expense) {
                                    return SizedBox(
                                      width: cardWidth,
                                      child: Card(
                                          child: ListTile(
                                        title: Text(expense.item),
                                        subtitle: Text(
                                            '${expense.category} \u00B7 ${DateFormat('hh:mm a').format(expense.date)} \u00B7 ${expense.type}'),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              expense.type == 'Income'
                                                  ? '+'
                                                  : '-',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: expense.type == 'Income'
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                            Text(
                                              '\u20B1${expense.price.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: expense.type == 'Income'
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                    );
                                  }),
                                ],
                              );
                            }).toList(),
                          )
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
          floatingActionButton: FloatingActionButton.extended(
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
          ),
        );
      },
    );
  }
}
