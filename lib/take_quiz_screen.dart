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

  @override
  void initState() {
    super.initState();
    loadQuiz();
  }

  /// Loads every quiz from the server and starts a practice test
  /// with [TakeQuizScreen.questionCount] random questions.
  Future loadQuiz() async {
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

    setState(() {
      questionPool = pool;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questionPool == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final question = questionPool!.getCurrentQuestion();
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blue, title: Text(widget.title.isEmpty ? 'Quiz' : widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Question ${questionPool!.currentIndex + 1} of ${questionPool!.questions.length}',
              ),
              const SizedBox(height: 16),
              Text(question.question),
              if (question is MultipleChoiceQuestion)
                for (int i = 0; i < question.options.length; i++)
                  ElevatedButton(
                    onPressed: () {
                      int before = questionPool!.score;
                      questionPool!.submitAnswer(i + 1);
                      if (questionPool!.score == before) {
                        incorrect.add(question);
                      }
                      if (questionPool!.currentIndex ==
                          questionPool!.questions.length - 1) {
                        // Quiz is finished, navigate to score screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ScoreScreen(
                              score: questionPool!.score,
                              total: questionPool!.questions.length,
                              incorrect: incorrect,
                            ),
                          ),
                        );
                      } else {
                        setState(() {
                          questionPool!.goToNextQuestion();
                        });
                      }
                    },
                    child: Text(question.options[i]),
                  ),
              if (question is FillInBlankQuestion)
                TextField(
                  key: ValueKey(questionPool!.currentIndex), // This ensures the TextField is rebuilt for each new question
                  onSubmitted: (answer) {
                    int before = questionPool!.score;
                    questionPool!.submitAnswer(answer);
                    if (questionPool!.score == before) {
                      incorrect.add(question);
                    }
                    if (questionPool!.currentIndex ==
                        questionPool!.questions.length - 1) {
                      // Quiz is finished, navigate to score screen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScoreScreen(
                              score: questionPool!.score,
                              total: questionPool!.questions.length,
                              incorrect: incorrect,
                            ),
                        ),
                      );
                    } else {
                      setState(() {
                        questionPool!.goToNextQuestion();
                      });
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
