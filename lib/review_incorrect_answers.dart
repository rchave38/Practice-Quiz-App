import 'package:cli/question.dart';
import 'package:flutter/material.dart';

/// Screen that shows each incorrectly answered question with its correct
/// answer, one at a time.
class ReviewIncorrectAnswers extends StatefulWidget {
  /// Questions that were answered incorrectly or skipped.
  final List<Question> incorrect;

  /// Creates a review screen for the [incorrect] questions.
  const ReviewIncorrectAnswers({super.key, required this.incorrect});

  @override
  State<ReviewIncorrectAnswers> createState() => _ReviewIncorrectAnswersState();
}

class _ReviewIncorrectAnswersState extends State<ReviewIncorrectAnswers> {
  /// Position of the question being shown.
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Review Incorrect Answers'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.incorrect.isEmpty)
                      const Text('No incorrect answers!')
                    else
                      questionPage(),
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
          ),
          if (widget.incorrect.isNotEmpty) navigationButtons(),
        ],
      ),
    );
  }

  /// Shows the current question and its correct answer.
  Widget questionPage() {
    final question = widget.incorrect[index];

    return Column(
      children: [
        Text('Question ${index + 1} of ${widget.incorrect.length}'),
        const SizedBox(height: 16),
        if (question.figureUrl != null)
          Image.network(question.figureUrl!, height: 200),
        Text(question.question),
        const SizedBox(height: 8),
        Text('Answer: ${question.correctAnswer}'),
      ],
    );
  }

  /// Previous and Next buttons pinned to the bottom corners.
  Widget navigationButtons() {
    final isFirst = index == 0;
    final isLast = index == widget.incorrect.length - 1;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            // null greys the button out
            onPressed: isFirst ? null : () => setState(() => index--),
            child: const Text('Previous'),
          ),
          ElevatedButton(
            onPressed: isLast ? null : () => setState(() => index++),
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
