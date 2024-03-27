import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'functions.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String _email = '';

  void _tryResetPassword() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      try {
        await _auth.sendPasswordResetEmail(email: _email);
        showSimpleDialog(context, 'Password Reset',
            'A password reset email has been sent to $_email. Please check your inbox and reset your password.');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } on FirebaseAuthException catch (e) {
        showSimpleDialog(context, 'Invalid Email Address', e.message!);
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
                      'Reset Password?',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom:8.0),
                    child: Text(
                      'Enter your email below to receive an email to reset your password.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
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
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: TextButton(
                        onPressed: _tryResetPassword,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 50.0),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.email),
                            SizedBox(width: 8),
                            Text('Send Reset Email'),
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
                          'Remember your password?  ',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
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
