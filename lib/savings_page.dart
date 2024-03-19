import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'functions.dart';
import 'main.dart';

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SavingsModel(),
      child: Consumer<SavingsModel>(
        builder: (context, model, child) {
          return DefaultTabController(
            length: 3, // number of tabs
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: AppBarBuilder.buildAppBar('Savings'),
              ),
              body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double boxWidth = constraints.maxWidth * 0.975;

                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: boxWidth,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'Total Amount: \$${model.totalSavings.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Transactions',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: model.transactions.length,
                          itemBuilder: (context, index) {
                            final transaction = model.transactions[index];
                            return ListTile(
                              title: Text(transaction['name']),
                              subtitle: Text(transaction['description']),
                              trailing: Text('\$${transaction['amount'].toStringAsFixed(2)}'),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  final newTransaction = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AddTransactionPage(),
                    ),
                  );
                  if (newTransaction != null) {
                    model.addTransaction(context, newTransaction);
                  }
                },
                label: const Text('Add'),
                icon: const Icon(Icons.add),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SavingsModel extends ChangeNotifier {
  double _totalSavings = 0;
  final List<Map<String, dynamic>> _transactions = [];

  double get totalSavings => _totalSavings;
  List<Map<String, dynamic>> get transactions => _transactions;

  void subtractSavings(double amount) {
    _totalSavings -= amount;
    notifyListeners();
  }

  void addTransaction(BuildContext context, Map<String, dynamic> transaction) {
    _transactions.add(transaction);
    _totalSavings += transaction['amount'];
    Provider.of<MyAppState>(context, listen: false).addSavings(transaction['amount']);
    notifyListeners();
  }
}

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
              Container(
                width: screenWidth * 0.975,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: screenWidth * 0.975,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: screenWidth * 0.975,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
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
            final transaction = {
              'name': _nameController.text,
              'description': _descriptionController.text,
              'amount': double.parse(_amountController.text),
            };
            Navigator.of(context).pop(transaction);
          }
        },
        label: const Text('Save'),
        icon: const Icon(Icons.save),
      ),
    );
  }
}