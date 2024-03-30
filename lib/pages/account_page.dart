import '../input_pages/category_limit_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../functions.dart';
import '../main.dart';
import '../authentication/login_page.dart';

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
          return SingleChildScrollView(
            padding: EdgeInsets.only(top: constraints.maxHeight * 0.01),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(
                    width: constraints.maxWidth * 0.975,
                    height: constraints.maxHeight * 0.13,
                    child: Card(
                      child: Center(
                        child: ListTile(
                          leading: const Icon(Icons.person),
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
                    height: constraints.maxHeight * 0.13,
                    child: Card(
                      child: Center(
                        child: ListTile(
                          leading: const Icon(Icons.dark_mode),
                          title: const Text('Dark Mode'),
                          trailing: ValueListenableBuilder<ThemeMode>(
                            valueListenable: Provider.of<MyAppState>(context)
                                .themeModeNotifier,
                            builder: (context, themeMode, child) {
                              return Switch(
                                value: themeMode == ThemeMode.dark,
                                onChanged: (bool value) {
                                  Provider.of<MyAppState>(context,
                                          listen: false)
                                      .toggleThemeMode();
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * 0.975,
                    height: constraints.maxHeight * 0.13,
                    child: Card(
                      child: Center(
                        child: ListTile(
                          leading: const Icon(Icons.category_rounded),
                          title: const Text('Category Limit'),
                          trailing: SizedBox(
                            width: 50,
                            height: 50,
                            child: FloatingActionButton(
                              child: const Icon(Icons.edit_rounded),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CategoryLimitPage(),
                                  ),
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
                    height: constraints.maxHeight * 0.13,
                    child: Card(
                      child: Center(
                        child: ListTile(
                          leading: const Icon(Icons.import_export),
                          title: const Text('Import Data'),
                          trailing: SizedBox(
                            width: 50,
                            height: 50,
                            child: FloatingActionButton(
                              child: const Icon(Icons.file_upload),
                              onPressed: () {
                                Provider.of<MyAppState>(context, listen: false)
                                    .importAppState();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * 0.975,
                    height: constraints.maxHeight * 0.13,
                    child: Card(
                      child: Center(
                        child: ListTile(
                          leading: const Icon(Icons.download),
                          title: const Text('Export Data'),
                          trailing: SizedBox(
                            width: 50,
                            height: 50,
                            child: FloatingActionButton(
                              child: const Icon(Icons.file_download),
                              onPressed: () {
                                Provider.of<MyAppState>(context, listen: false)
                                    .exportAppState();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * 0.975,
                    height: constraints.maxHeight * 0.13,
                    child: Card(
                      child: Center(
                        child: ListTile(
                          leading: const Icon(Icons.refresh),
                          title: const Text('Reset Data'),
                          trailing: SizedBox(
                            width: 50,
                            height: 50,
                            child: FloatingActionButton(
                              child: const Icon(Icons.refresh),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Reset Data Confirmation'),
                                      content: const Text(
                                          'Are you sure you want to reset your data? This action cannot be undone.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Yes'),
                                          onPressed: () {
                                            MyAppState().resetUserData();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
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
                    height: constraints.maxHeight * 0.13,
                    child: Card(
                      child: Center(
                        child: ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Delete Account'),
                          trailing: SizedBox(
                            width: 50,
                            height: 50,
                            child: FloatingActionButton(
                              child: const Icon(Icons.delete_forever),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Delete Account Confirmation'),
                                      content: const Text(
                                          'Are you sure you want to delete your account? This action cannot be undone.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Yes'),
                                          onPressed: () {
                                            MyAppState().deleteAccount();
                                            Navigator.of(context).pop();
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage(),
                                              ),
                                            );
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Account Delete Complete'),
                                                  content: const Text('Your account has been successfully deleted.'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    );
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
                    height: constraints.maxHeight * 0.13,
                    child: Card(
                      child: Center(
                        child: ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text('Sign Out'),
                          trailing: SizedBox(
                            width: 50,
                            height: 50,
                            child: FloatingActionButton(
                              child: const Icon(Icons.logout),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Logout Confirmation'),
                                      content: const Text(
                                          'Are you sure you want to log out?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Yes'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage(),
                                              ),
                                            );
                                            MyAppState().logOut();
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Log Out Complete'),
                                                  content: const Text('You have been successfully logged out.'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
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
