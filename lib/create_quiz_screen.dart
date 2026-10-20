import 'package:flutter/material.dart';

class CreateQuizScreen extends StatelessWidget{
  const CreateQuizScreen({super.key});

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
            const TextField(decoration: InputDecoration(labelText: 'Quiz Title')),
            const TextField(decoration: InputDecoration(labelText: 'Question Amount:')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Create Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}