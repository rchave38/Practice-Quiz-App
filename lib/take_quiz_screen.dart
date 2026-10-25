import 'package:dartpedia/score_screen.dart';
import 'package:flutter/material.dart';
import 'package:cli/question_pool.dart';
import 'package:cli/question_loader.dart';
import 'package:cli/quiz.dart';
import 'package:cli/question.dart';

class TakeQuizScreen extends StatefulWidget {
  final int questionCount;
  final String title;
  final String user;
  final String pin;
  const TakeQuizScreen({
    super.key,
    required this.questionCount,
    this.title = 'Quiz', // used when no title is given
    required this.user,
    required this.pin,
  });

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  QuestionPool? questionPool;
  List<Question> incorrect = [];
  String? error; // set when loading fails

  // Answers saved by question number, so the user can go back and change them
  Map<int, dynamic> answers = {};
  Map<int, String> answerLabels = {}; // the answer text shown on screen

  @override
  void initState() {
    super.initState();
    loadQuiz();
  }

  /// Loads every quiz from the server and starts a practice test
  /// with [TakeQuizScreen.questionCount] random questions.
  Future loadQuiz() async {
    try {
      QuestionLoader loader = QuestionLoader();
      List<Quiz> quizzes = await loader.getQuizzesFromUrl(
        user: widget.user,
        pin: widget.pin,
      );
      // Combine the questions from every quiz into one pool
      List<Question> allQuestions = [];
      for (Quiz quiz in quizzes) {
        allQuestions.addAll(quiz.questions);
      }
      final pool = QuestionPool(allQuestions);

      // Don't ask for more questions than the pool has
      int count = widget.questionCount;
      if (count > allQuestions.length) {
        count = allQuestions.length;
      }
      pool.startPracticeTest(count);

      if (!mounted) return; // screen was closed while loading
      setState(() {
        questionPool = pool;
      });
    } catch (e) {
      // No internet, server down, or wrong login: show a message instead of spinning
      if (!mounted) return;
      setState(() {
        error = 'Could not load quizzes. Check your connection and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: Colors.blue, title: const Text('Quiz')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(error!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Clear the error so the spinner shows, then try again
                  setState(() {
                    error = null;
                  });
                  loadQuiz();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (questionPool == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = questionPool!.getCurrentQuestion();
    final index = questionPool!.currentIndex;
    final total = questionPool!.questions.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title.isEmpty ? 'Quiz' : widget.title),
      ),
      body: Column(
        children: [
          // Progress bar at the top: fills up as questions are answered
          LinearProgressIndicator(value: answers.length / total),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Question ${index + 1} of $total'),
                    const SizedBox(height: 16),
                    Text(question.question),
                    const SizedBox(height: 16),
                    if (question is MultipleChoiceQuestion)
                      for (int i = 0; i < question.options.length; i++)
                        ElevatedButton(
                          onPressed: () {
                            answerQuestion(i + 1, question.options[i]);
                          },
                          child: Text(question.options[i]),
                        ),
                    if (question is FillInBlankQuestion)
                      TextField(
                        key: ValueKey(index), // fresh, empty TextField for each question
                        onSubmitted: (answer) {
                          answerQuestion(answer, answer);
                        },
                      ),
                    if (answerLabels[index] != null)
                      Text('Your answer: ${answerLabels[index]}'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          // null greys the button out on the first question
                          onPressed: index > 0 ? goBack : null,
                          child: const Text('Previous'),
                        ),
                        ElevatedButton(
                          // null greys the button out on the last question
                          onPressed: index < total - 1 ? goForward : null,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Moves to the previous question.
  void goBack() {
    setState(() {
      questionPool!.goToPreviousQuestion();
    });
  }

  /// Moves to the next question without answering.
  void goForward() {
    setState(() {
      questionPool!.goToNextQuestion();
    });
  }

  /// Saves [answer] for the current question, then moves to the next one.
  /// On the last question, it finishes the quiz instead.
  void answerQuestion(dynamic answer, String label) {
    int index = questionPool!.currentIndex;
    answers[index] = answer;
    answerLabels[index] = label;

    if (index == questionPool!.questions.length - 1) {
      finishQuiz();
    } else {
      goForward();
    }
  }

  /// Scores every saved answer, then opens the score screen.
  ///
  /// Scoring happens here at the end (not on each tap) so that going back
  /// and changing an answer doesn't count it twice.
  void finishQuiz() {
    final pool = questionPool!;
    pool.resetQuiz(); // back to question 1, score 0
    incorrect = [];

    for (int i = 0; i < pool.questions.length; i++) {
      int before = pool.score;
      if (answers.containsKey(i)) {
        pool.submitAnswer(answers[i]);
      }
      // Score didn't go up, so it was wrong (or skipped)
      if (pool.score == before) {
        incorrect.add(pool.getCurrentQuestion());
      }
      if (i < pool.questions.length - 1) {
        pool.goToNextQuestion();
      }
    }

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
}
