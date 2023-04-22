import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

enum AuthMode { login, register, forget }

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String error = '';
  String verificationId = '';

  AuthMode mode = AuthMode.login;

  @override
  void initState() {
    super.initState();
  }

  void _login() {
    setState(() {
      mode = AuthMode.login;
    });
  }

  void _forgetPassword() {
    setState(() {
      mode = AuthMode.forget;
    });
  }

  void _signUp() {
    setState(() {
      mode = AuthMode.register;
    });
  }

  Future<void> _submit() async {
    if (mode == AuthMode.login) {
      await auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print('login');
    } else if (mode == AuthMode.register) {
      await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print('register');
      _login();
    } else if (mode == AuthMode.forget) {
      await auth.sendPasswordResetEmail(
        email: emailController.text
      );
      print('forget email sent');
      _login();
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Sign-In';
    if (mode == AuthMode.forget) {
      title = 'Reset password';
    } else if (mode == AuthMode.register) {
      title = 'Register';
    }
    return GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
            body: Center(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(title, style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    validator: (value) =>
                        value != null && value.isNotEmpty ? null : 'Required',
                  ),
                  if (mode != AuthMode.forget) ...[
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value != null && value.isNotEmpty ? null : 'Required',
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Submit'),
                  ),
                  if (mode != AuthMode.forget) ... [
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: _forgetPassword,
                      child: const Text("Forget password?"),
                    ),
                  ],
                  if (mode != AuthMode.register) ... [
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _signUp,
                      child: const Text("Register"),
                    ),
                  ],
                  if (mode != AuthMode.login) ... [
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _login,
                      child: const Text("Login"),
                    )
                  ]
                ],
              )),
        )));
  }
}
