import 'package:flutter/material.dart';
import 'package:dartpedia/main_menu.dart';
import 'package:cli/login_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userController = TextEditingController();
  final pinController = TextEditingController();
  bool loading = false;
  String? error;

  @override
  void dispose() {
    // Free the controller when this screen is closed
    userController.dispose();
    pinController.dispose();
    super.dispose();
  }

  /// Checks the login with the server and opens Main Menu if it's valid.
  Future<void> logIn() async {
    // Show the spinner and clear any old error
    setState(() {
      loading = true;
      error = null;
    });

    bool ok = await LoginService().login(
      userController.text,
      pinController.text,
    );
    if (!mounted) return; // the screen was closed while waiting

    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainMenu(
            user: userController.text,
            pin: pinController.text,
          ),
        ),
      );
    } else {
      setState(() {
        loading = false;
        error = 'Wrong username or PIN';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: pinController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: logIn, child: const Text('Log In')),
          ],
        ),
      ),
    );
  }
}
