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
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        entry.key,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    const Divider(color: Colors.grey), // Added Divider here
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

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;

  final List<String> _categories = ['Food', 'Transportation', 'Miscellaneous', 'Utilities', 'Rent', 'Entertainment', 'Clothing', 'Health', 'Insurance', 'Education'];

  bool _isBottomSheetOpen = false;

  void showBottomSheet(BuildContext context, Function(String) onItemSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _categories.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(_categories[index]),
              onTap: () {
                onItemSelected(_categories[index]);
                Navigator.of(context).pop();
              },
            );
          },
        );
      },
    ).then((value) {
      setState(() {
        _isBottomSheetOpen = false;
      });
    });

    setState(() {
      _isBottomSheetOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _itemController,
                  decoration: InputDecoration(
                    labelText: 'Item',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Add this
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Add this
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  readOnly: true,
                  controller: _categoryController,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0), // Add your desired padding here
                      child: IconButton(
                        icon: Icon(_isBottomSheetOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                        onPressed: () {
                          showBottomSheet(context, (selectedCategory) {
                            _categoryController.text = selectedCategory;
                          });
                        },
                      ),
                    ),
                  ),
                  onTap: () {
                    showBottomSheet(context, (selectedCategory) {
                      _categoryController.text = selectedCategory;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (_selectedCategory == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a category')),
              );
              return;
            }
            final expense = Expense(
              item: _itemController.text,
              price: double.parse(_priceController.text),
              category: _selectedCategory!,
            );
            Provider.of<MyAppState>(context, listen: false).addExpense(expense);
            Navigator.of(context).pop();
          }
        },
        label: const Text('Save'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}