import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'login_page.dart';
import 'functions.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';

  void checkEmailVerification(User user, BuildContext context) {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      await user.reload();
      if (user.emailVerified) {
        timer.cancel();
        showSimpleDialog(context, 'Email Verification', 'Verification Complete!');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    });
  }

  void _trySignup() async {
  final form = _formKey.currentState;
  if (form!.validate()) {
    form.save();
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email, password: _password);
      User? user = userCredential.user;
      showSimpleDialog(context, 'Email Verification', 'Sign Up Successful! Please check your email for verification link.');
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        checkEmailVerification(user, context);
      }
    } on FirebaseAuthException catch (e) {
      showSimpleDialog(context, 'Sign Up Failed', e.message!);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBarBuilder.buildAppBar('BenefitsAtEase'),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.975,
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Align(
            alignment: Alignment.topCenter,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your email' : null,
                      onSaved: (value) => _email = value!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your password' : null,
                      onSaved: (value) => _password = value!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextButton(
                        onPressed: _trySignup,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 50.0),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_add),
                            SizedBox(width: 8),
                            Text('Sign Up'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?  ',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const LoginPage()),
                            );
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}