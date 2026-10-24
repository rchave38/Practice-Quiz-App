import 'package:flutter/material.dart';
import 'package:cli/question.dart';

class ReviewIncorrectAnswers extends StatefulWidget {
  final List<Question> incorrect;
  const ReviewIncorrectAnswers({super.key, required this.incorrect});

  @override
  State<ReviewIncorrectAnswers> createState() => _ReviewIncorrectAnswersState();
}

class _ReviewIncorrectAnswersState extends State<ReviewIncorrectAnswers> {
  int index = 0;

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
    );
  }

  /// Shows the question at index with its answer and Previous/Next buttons.
  Widget questionPage() {
    final question = widget.incorrect[index];

    return Column(
      children: [
        Text('Question ${index + 1} of ${widget.incorrect.length}'),
        const SizedBox(height: 16),
        Text(question.question),
        const SizedBox(height: 8),
        if (question is MultipleChoiceQuestion)
          Text('Answer: ${question.options[question.correctOptionIndex - 1]}'),
        if (question is FillInBlankQuestion)
          Text('Answer: ${question.acceptableAnswers.first}'),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              // null disables the button on the first question
              onPressed: index > 0 ? () => setState(() => index--) : null,
              child: const Text('Previous'),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              // null disables the button on the last question
              onPressed: index < widget.incorrect.length - 1
                  ? () => setState(() => index++)
                  : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}
