import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class SetLimitsPage extends StatelessWidget {
  final TextEditingController _generalLimitController = TextEditingController();

  SetLimitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Limits'),
      ),
      body: Consumer<MyAppState>(
        builder: (context, appState, child) {
          return ListView(
            children: [
              for (var category in appState.categoryLimits.keys)
                ListTile(
                  title: Text(category),
                  trailing: SizedBox(
                    width: 100,
                    child: TextField(
                      controller: TextEditingController()..text = appState.categoryLimits[category].toString(),
                      keyboardType: TextInputType.number,
                      onSubmitted: (value) {
                        appState.setCategoryLimit(category, double.parse(value));
                      },
                    ),
                  ),
                ),
              ListTile(
                title: const Text('General Limit'),
                trailing: SizedBox(
                  width: 100,
                  child: TextField(
                    controller: _generalLimitController..text = appState.generalLimit.toString(),
                    keyboardType: TextInputType.number,
                    onSubmitted: (value) {
                      appState.setGeneralLimit(double.parse(value));
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}