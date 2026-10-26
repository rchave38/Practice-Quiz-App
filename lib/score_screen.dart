import 'package:cli/question.dart';
import 'package:dartpedia/review_incorrect_answers.dart';
import 'package:flutter/material.dart';

/// Screen shown after a quiz with the user's score.
class ScoreScreen extends StatelessWidget {
  /// Number of correct answers.
  final int score;

  /// Number of questions in the quiz.
  final int total;

  /// Questions that were answered incorrectly or skipped.
  final List<Question> incorrect;

  /// Creates a score screen showing [score] out of [total].
  const ScoreScreen({
    super.key,
    required this.score,
    required this.total,
    required this.incorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              Text('Incorrect Answers: ${incorrect.length}/$total'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReviewIncorrectAnswers(incorrect: incorrect),
                    ),
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
