import 'package:flutter/material.dart';

class ReviewIncorrectAnswers extends StatelessWidget {
  const ReviewIncorrectAnswers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Review Incorrect Answers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Incorrect Answers: [List of Incorrect Answers Here]'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back to Score Screen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}