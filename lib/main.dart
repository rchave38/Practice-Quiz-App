import 'package:flutter/material.dart';

import 'login_screen.dart';

/// Starts the Practice Quiz app.
void main() {
  runApp(const MyApp());
}

/// The root of the app. Opens on the login screen.
class MyApp extends StatelessWidget {
  /// Creates the app.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Every screen's app bar is blue
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
      ),
      home: const LoginScreen(),
    );
  }
}
