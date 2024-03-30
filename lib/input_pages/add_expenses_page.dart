import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../pages/home_page.dart';
import '../main.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  AddExpensePageState createState() => AddExpensePageState();
}

class AddExpensePageState extends State<AddExpensePage> {
  String _type = 'Income';

  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateController.text = _selectedDate.toIso8601String().substring(0, 10);
  }

  final List<String> _categories = [
    'Allowance',
    'Salary',
    'Food',
    'Transportation',
    'Miscellaneous',
    'Utilities',
    'Rent',
    'Entertainment',
    'Clothing',
    'Health',
    'Insurance',
    'Education',
    'Others'
  ];

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
                  _selectedCategory = _categories[index];
                  Navigator.of(context).pop();
                },
              );
            },
          );
        }).then((value) {
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
        title: const Text('Add Transaction'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _type = 'Income';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(50, 50),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        side: _type == 'Income'
                            ? const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              )
                            : null,
                      ),
                      child: const Text('Income'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _type = 'Expense';
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(50, 50),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        side: _type == 'Expense'
                            ? const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              )
                            : null,
                      ),
                      child: const Text('Expense'),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _itemController,
                  decoration: InputDecoration(
                    labelText: 'Item',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
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
                      borderRadius: BorderRadius.circular(10.0),
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
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(_isBottomSheetOpen
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85 / 2,
                        child: Card(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: ListTile(
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  DateFormat('MM/dd/yyyy').format(_selectedDate),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            onTap: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(DateTime.now().year - 5),
                                lastDate: DateTime(DateTime.now().year + 5),
                              );
                              if (date != null) {
                                setState(() {
                                  _selectedDate = date;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85 / 2,
                        child: Card(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: ListTile(
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.access_time,
                                  size: 18,
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  DateFormat('hh:mm a').format(_selectedTime),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime:
                                    TimeOfDay.fromDateTime(_selectedTime),
                              );
                              if (time != null) {
                                setState(() {
                                  _selectedTime = DateTime(
                                    _selectedDate.year,
                                    _selectedDate.month,
                                    _selectedDate.day,
                                    time.hour,
                                    time.minute,
                                  );
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
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
              date: _selectedDate,
              type: _type,
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
