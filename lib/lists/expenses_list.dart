import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../input_pages/edit_expenses_page.dart';
import '../main.dart';
import '../pages/home_page.dart';

MyAppState appState = MyAppState();

List<Widget> buildExpenseList(BuildContext context, List<MapEntry<String, List<Expense>>> expensesByDate, double cardWidth) {
  return expensesByDate.map((entry) {
    var expensesForDateAndCategory = entry.value.toList();

    if (expensesForDateAndCategory.isEmpty) {
      return Container();
    }

    double totalIncomeForDate = expensesForDateAndCategory
        .where((expense) => expense.type == 'Income')
        .fold(0, (prev, element) => prev + element.price);
    double totalExpenseForDate = expensesForDateAndCategory
        .where((expense) => expense.type != 'Income')
        .fold(0, (prev, element) => prev + element.price);

    return Column(
      children: [
        SizedBox(
          width: cardWidth,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  (totalIncomeForDate - totalExpenseForDate) >= 0
                      ? '\u20B1${(totalIncomeForDate - totalExpenseForDate).toStringAsFixed(2)}'
                      : '-\u20B1${(totalExpenseForDate - totalIncomeForDate).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: (totalIncomeForDate - totalExpenseForDate) >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        ...expensesForDateAndCategory.map((Expense expense) {
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
                      expense.type == 'Income' ? '+' : '-',
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
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        Provider.of<MyAppState>(context,
                            listen: false)
                            .deleteExpense(expense);
                        var newExpense = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditExpensePage(expense: expense),
                          ),
                        );
                        if (newExpense != null) {
                          appState.addExpense(newExpense);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }).toList();
}
