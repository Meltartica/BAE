import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'functions.dart';

class Expense {
  final String item;
  final double price;
  final String category;

  Expense({required this.item, required this.price, required this.category});
}

class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context);
    double totalSpent = appState.expenses.fold(0, (prev, element) => prev + element.price);
    var expensesByCategory = groupBy(appState.expenses, (Expense e) => e.category);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBarBuilder.buildAppBar('Expenses'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double cardWidth = constraints.maxWidth * 0.975;

          return Column(
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
              Expanded(
                child: ListView(
                  children: expensesByCategory.entries.map((entry) {
                    return SizedBox(
                      width: cardWidth,
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                entry.key,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: entry.value.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text('${entry.value[index].item} - \$${entry.value[index].price.toStringAsFixed(2)}'),
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
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newExpense = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddExpensePage()),
          );
          if (newExpense != null) {
            appState.addExpense(newExpense);
          }
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class AddExpensePage extends StatelessWidget {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _itemController,
                decoration: const InputDecoration(labelText: 'Item'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (Form.of(context).validate()) {
                    final expense = Expense(
                      item: _itemController.text,
                      price: double.parse(_priceController.text),
                      category: _categoryController.text,
                    );
                    Provider.of<MyAppState>(context, listen: false).addExpense(expense);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}