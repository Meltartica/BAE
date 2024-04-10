import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../pages/home_page.dart';
import '../main.dart';

class EditExpensePage extends StatefulWidget {
  final Expense? expense;

  const EditExpensePage({super.key, this.expense});

  @override
  EditExpensePageState createState() => EditExpensePageState();
}

class EditExpensePageState extends State<EditExpensePage> {
  String _type = 'Income';
  bool _isBottomSheetOpen = false;

  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();

  final List<String> _expense = [
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

  final List<String> _income = [
    'Allowance',
    'Salary',
    'Others',
  ];

  void showBottomSheet(BuildContext context, Function(String) onItemSelected) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
            itemCount: _type == 'Income' ? _income.length : _expense.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(_type == 'Income' ? _income[index] : _expense[index]),
                onTap: () {
                  onItemSelected(_type == 'Income' ? _income[index] : _expense[index]);
                  _selectedCategory = _type == 'Income' ? _income[index] : _expense[index];
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
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _itemController.text = widget.expense!.item;
      _priceController.text = widget.expense!.price.toString();
      _categoryController.text = widget.expense!.category;
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
      _selectedTime = widget.expense!.date;
      _type = widget.expense!.type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
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
          toolbarHeight: 100,
        ),
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
                                initialTime: TimeOfDay.fromDateTime(_selectedTime),
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).pop();
            },
            label: const Text('Delete'),
            icon: const Icon(Icons.delete),
          ),
          const SizedBox(width: 10),
          FloatingActionButton.extended(
            heroTag: 'save',
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
                  date: _selectedTime,
                  type: _type,
                );
                Provider.of<MyAppState>(context, listen: false).editExpense(expense);
                Navigator.of(context).pop();
              }
            },
            label: const Text('Save'),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
