import 'package:flutter/material.dart';
import 'package:dartpedia/take_quiz_screen.dart';

class CreateQuizScreen extends StatefulWidget{
  const CreateQuizScreen({super.key});

  @override
  State<CreateQuizScreen> createState() => _CreateQuizScreenState();
}

class _CreateQuizScreenState extends State<CreateQuizScreen> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void dispose() {
    // Free the controller when this screen is closed
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
              onPressed: () {
                // tryParse gives null instead of crashing on bad input
                int? count = int.tryParse(amountController.text);
                if (count == null || count < 1) return;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TakeQuizScreen(
                      questionCount: count,
                      title: titleController.text,
                    ),
                  ),
                );
              },
              child: const Text('Create Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}