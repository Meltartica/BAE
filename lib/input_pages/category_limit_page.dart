import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class CategoryLimitPage extends StatefulWidget {
  const CategoryLimitPage({super.key});

  @override
  CategoryLimitPageState createState() => CategoryLimitPageState();
}

class CategoryLimitPageState extends State<CategoryLimitPage> {

  Future<void> showEditDialog(String category) async {
    TextEditingController controller = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Limit for $category'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter new limit',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                double? newLimit = double.tryParse(controller.text);
                if (newLimit != null) {
                  Provider.of<MyAppState>(context, listen: false).updateCategoryLimit(category, newLimit);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Category Limits'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.only(top: constraints.maxHeight * 0.01),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: constraints.maxWidth * 0.975,
                child: ListView.builder(
                  itemCount: Provider.of<MyAppState>(context).categoryLimits.length,
                  itemBuilder: (context, index) {
                    String category = Provider.of<MyAppState>(context).categoryLimits.keys.elementAt(index);
                    return Card(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListTile(
                              title: Text(category),
                              subtitle: Text('Limit: ${Provider.of<MyAppState>(context).categoryLimits[category]}'),
                              trailing: SizedBox(
                                width: 50,
                                height: 50,
                                child: FloatingActionButton(
                                  child: const Icon(Icons.edit_rounded),
                                  onPressed: () {
                                    showEditDialog(category);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}