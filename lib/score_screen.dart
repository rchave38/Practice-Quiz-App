import 'package:dartpedia/review_incorrect_answers.dart';
import 'package:flutter/material.dart';

class ScoreScreen extends StatelessWidget {
  final int score;
  final int total;
  const ScoreScreen({super.key, required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('View Score'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Score: $score/$total'),
              const SizedBox(height: 8),
              Text('Incorrect Answers: ${total - score}/$total'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReviewIncorrectAnswers()),
                  );
                },
                child: const Text('Review Incorrect Answers'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Exit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
