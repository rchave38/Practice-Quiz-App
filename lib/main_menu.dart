import 'package:dartpedia/create_quiz_screen.dart';
import 'package:dartpedia/login_screen.dart';
import 'package:dartpedia/take_quiz_screen.dart';
import 'package:flutter/material.dart';

/// Home screen after logging in, with buttons to create or take a quiz.
class MainMenu extends StatelessWidget {
  /// The logged-in user's username.
  final String user;

  /// The logged-in user's PIN.
  final String pin;

  /// Creates the main menu for the given [user] and [pin].
  const MainMenu({super.key, required this.user, required this.pin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateQuizScreen(user: user, pin: pin),
                  ),
                );
              },
              child: const Text('Create a Quiz'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TakeQuizScreen(questionCount: 5, user: user, pin: pin),
                  ),
                );
              },
              child: const Text('Take a Quiz'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
