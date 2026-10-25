import 'package:cli/question.dart';
import 'package:cli/question_loader.dart';
import 'package:cli/question_pool.dart';
import 'package:dartpedia/score_screen.dart';
import 'package:flutter/material.dart';

/// Screen that loads questions from the server and shows them one at a time.
class TakeQuizScreen extends StatefulWidget {
  /// How many questions the practice test should have.
  final int questionCount;

  /// Title shown in the app bar.
  final String title;

  /// The logged-in user's username.
  final String user;

  /// The logged-in user's PIN.
  final String pin;

  /// Creates a quiz screen with [questionCount] questions.
  const TakeQuizScreen({
    super.key,
    required this.questionCount,
    this.title = 'Quiz',
    required this.user,
    required this.pin,
  });

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  /// The practice test, or null while it is still loading.
  QuestionPool? questionPool;

  /// Message shown when loading fails, or null if there is none.
  String? error;

  @override
  void initState() {
    super.initState();
    loadQuiz();
  }

  /// Loads every quiz from the server and starts a practice test
  /// with [TakeQuizScreen.questionCount] random questions.
  Future<void> loadQuiz() async {
    try {
      List<Question> allQuestions = await QuestionLoader().getAllQuestions(
        user: widget.user,
        pin: widget.pin,
      );
      final pool = QuestionPool(allQuestions);
      pool.startPracticeTest(widget.questionCount);

      if (!mounted) return; // the screen was closed while loading
      setState(() {
        questionPool = pool;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Could not load quizzes. Check your connection and try again.';
      });
    }
  }

  /// Clears the error and tries loading again.
  void retry() {
    setState(() {
      error = null;
    });
    loadQuiz();
  }

  /// Moves to the previous question.
  void goBack() {
    setState(() {
      questionPool!.goToPreviousQuestion();
    });
  }

  /// Moves to the next question.
  void goForward() {
    setState(() {
      questionPool!.goToNextQuestion();
    });
  }

  /// Saves [answer] for the current question. It is scored on submit.
  void saveAnswer(dynamic answer) {
    setState(() {
      questionPool!.saveAnswer(answer);
    });
  }

  /// Scores all answers and opens the score screen.
  void finishQuiz() {
    final pool = questionPool!;
    List<Question> incorrect = pool.gradeAnswers();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreScreen(
          score: pool.score,
          total: pool.questions.length,
          incorrect: incorrect,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return errorScreen();
    }
    if (questionPool == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pool = questionPool!;
    final question = pool.getCurrentQuestion();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title.isEmpty ? 'Quiz' : widget.title),
      ),
      body: Column(
        children: [
          // Fills up as questions are answered
          LinearProgressIndicator(
            value: pool.answeredCount / pool.questions.length,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Question ${pool.currentIndex + 1} of ${pool.questions.length}',
                    ),
                    const SizedBox(height: 16),
                    if (question.figureUrl != null)
                      Image.network(question.figureUrl!, height: 200),
                    Text(question.question),
                    const SizedBox(height: 16),
                    if (question is MultipleChoiceQuestion)
                      for (int i = 0; i < question.options.length; i++)
                        optionButton(i + 1, question.options[i]),
                    if (question is FillInBlankQuestion)
                      TextFormField(
                        // A new key gives each question its own text box
                        key: ValueKey(pool.currentIndex),
                        initialValue: pool.currentAnswer ?? '',
                        onChanged: saveAnswer,
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  // null greys the button out
                  onPressed: pool.isFirstQuestion ? null : goBack,
                  child: const Text('Previous'),
                ),
                if (pool.isLastQuestion)
                  ElevatedButton(
                    onPressed: finishQuiz,
                    child: const Text('Submit Quiz'),
                  )
                else
                  ElevatedButton(
                    onPressed: goForward,
                    child: const Text('Next'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// A button for option [number]. The selected option is shown in blue.
  Widget optionButton(int number, String text) {
    bool selected = questionPool!.currentAnswer == number;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.blue : null,
        foregroundColor: selected ? Colors.white : null,
      ),
      onPressed: () {
        saveAnswer(number);
      },
      child: Text(text),
    );
  }

  /// Shown instead of the quiz when loading fails.
  Widget errorScreen() {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, title: const Text('Quiz')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: retry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
