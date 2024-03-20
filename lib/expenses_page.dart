import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
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

  Expense({required this.item, required this.price, required this.category, required this.date});
}

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MyAppState>(
      builder: (context, appState, child) {
        double totalSpent = appState.expenses.fold(0, (prev, element) => prev + element.price);
        var expensesByCategory = groupBy(appState.expenses, (Expense e) => e.category);

        PageController pageController = PageController();

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: AppBarBuilder.buildAppBar('Expenses'),
          ),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double cardWidth = constraints.maxWidth * 0.975;
              return Padding(
                padding: EdgeInsets.only(top: constraints.maxHeight * 0.01),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Total spent today: \$${totalSpent.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Expenses',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: expensesByCategory.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: SizedBox(
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      pageController.animateToPage(
                                        expensesByCategory.keys.toList().indexOf(entry.key),
                                        duration: const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                                      foregroundColor: Theme.of(context).colorScheme.secondary,
                                    ),
                                    child: Text(entry.key),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: cardWidth,
                          child: PageView(
                            controller: pageController,
                            children: expensesByCategory.entries.map((entry) {
                              return Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 8.0),
                                      child: Text(
                                        entry.key,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Divider(color: Colors.grey),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: entry.value.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text('${entry.value[index].item} - \$${entry.value[index].price.toStringAsFixed(2)}'),
                                          subtitle: Text('Date: ${DateFormat('MMMM d, yyyy').format(entry.value[index].date)}'),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () {
                                              // TODO: Implement edit functionality
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
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