import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'functions.dart';
import 'main.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBarBuilder.buildAppBar('Account'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Padding(
            padding: EdgeInsets.only(top: constraints.maxHeight * 0.01),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(
                    width: constraints.maxWidth * 0.975,
                    height: constraints.maxHeight * 0.15,
                    child: Card(
                      child: Center(
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                              image: const DecorationImage(
                                image: NetworkImage('https://img.taotu.cn/ssd/ssd3/1/2023-07-08/1_a063a0e567a59854a31aae342cd0fcf9.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Consumer<MyAppState>(
                            builder: (context, appState, child) {
                              return Text(
                                appState.username,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              );
                            },
                          ),
                          trailing: SizedBox(
                            width: 50,
                            height: 50,
                            child: FloatingActionButton(
                              child: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return EditProfileDialog();
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * 0.975,
                    height: constraints.maxHeight * 0.15,
                    child: Card(
                      child: Center(
                        child: ListTile(
                          leading: const Icon(Icons.dark_mode),
                          title: const Text('Dark Mode'),
                          trailing: ValueListenableBuilder<ThemeMode>(
                            valueListenable: Provider.of<MyAppState>(context).themeModeNotifier,
                            builder: (context, themeMode, child) {
                              return Switch(
                                value: themeMode == ThemeMode.dark,
                                onChanged: (bool value) {
                                  Provider.of<MyAppState>(context, listen: false).toggleThemeMode();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}