import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../lists/expenses_list.dart';
import 'home_page.dart';

class SearchPage extends StatefulWidget {
  final List<Expense> expenses;

  const SearchPage({super.key, required this.expenses});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  String query = '';
  String? selectedCategory;
  String? selectedExpenseType;

  @override
  Widget build(BuildContext context) {
    final categories = widget.expenses.map((e) => e.category).toSet().toList();
    final expenseTypes = widget.expenses.map((e) => e.type).toSet().toList();

    final filteredExpenses = widget.expenses
        .where((expense) =>
    expense.item.toLowerCase().contains(query.toLowerCase()) &&
        (selectedCategory == null || expense.category == selectedCategory) &&
        (selectedExpenseType == null || expense.type == selectedExpenseType))
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
      } else {
        return false;
      }
    }));

    final expensesByDate = dateFilteredExpenses.entries.toList();

    expensesByDate.sort((a, b) {
      DateTime dateA = DateFormat('MMMM dd, yyyy').parse(a.key);
      DateTime dateB = DateFormat('MMMM dd, yyyy').parse(b.key);
      return dateB.compareTo(dateA);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Expenses'),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double cardWidth = constraints.maxWidth * 0.95;
            return SizedBox(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: cardWidth,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Name of Expense',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: query.isEmpty
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        query = '';
                                      });
                                    },
                                  ),
                                ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            query = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the description';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16, right: 16, left: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                              selectedCategory = null;
                              selectedExpenseType = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children:
                        buildExpenseList(context, expensesByDate, cardWidth),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
