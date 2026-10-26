import 'package:dartpedia/take_quiz_screen.dart';
import 'package:flutter/material.dart';

/// Screen where the user names a quiz and picks how many questions it has.
class CreateQuizScreen extends StatefulWidget {
  /// The logged-in user's username.
  final String user;

  /// The logged-in user's PIN.
  final String pin;

  /// Creates the screen for the given [user] and [pin].
  const CreateQuizScreen({super.key, required this.user, required this.pin});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  /// Starts the quiz if the question amount is a positive number.
  void createQuiz() {
    int? count = int.tryParse(amountController.text);
    if (count == null || count < 1) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TakeQuizScreen(
          questionCount: count,
          title: titleController.text,
          user: widget.user,
          pin: widget.pin,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Quiz Title'),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Question Amount:'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: createQuiz,
              child: const Text('Create Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
