import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'functions.dart';

class Transaction {
  final String description;
  final double amount;

  Transaction({required this.description, required this.amount});
}

class SavingsPage extends StatelessWidget {
  const SavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBarBuilder.buildAppBar('Savings'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.only(top: constraints.maxHeight * 0.01),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: constraints.maxWidth * 0.975,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Total Savings: \$${appState.totalSavings.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final newTransaction = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddTransactionPage()),
          );
          if (newTransaction != null) {
            appState.addTransaction(newTransaction);
          }
        },
        label: const Text('Add'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class AddTransactionPage extends StatelessWidget {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  AddTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (Form.of(context).validate()) {
                    final transaction = Transaction(
                      description: _descriptionController.text,
                      amount: double.parse(_amountController.text),
                    );
                    Provider.of<MyAppState>(context, listen: false).addTransaction(transaction);
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