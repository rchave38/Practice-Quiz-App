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
        // stretch makes every row full width so content starts at the left edge
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            // Scrolls when the question and answers don't fit on the screen
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: widget.incorrect.isEmpty
                  ? const Text('No incorrect answers!')
                  : questionPage(),
            ),
          ),
          bottomButtons(),
        ],
      ),
    );
  }

  /// Shows the current question and its correct answer.
  Widget questionPage() {
    final question = widget.incorrect[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

  /// Previous and Next in the bottom corners, with Back to Score Screen
  /// centered underneath them.
  ///
  /// Previous and Next are greyed out when there is nowhere to go.
  Widget bottomButtons() {
    final hasPrevious = index > 0;
    final hasNext = index < widget.incorrect.length - 1;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                // null greys the button out
                onPressed: hasPrevious ? () => setState(() => index--) : null,
                child: const Text('Previous'),
              ),
              ElevatedButton(
                onPressed: hasNext ? () => setState(() => index++) : null,
                child: const Text('Next'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Back to Score Screen'),
          ),
        ],
      ),
    );
  }
}
