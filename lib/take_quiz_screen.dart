import 'package:dartpedia/score_screen.dart';
import 'package:flutter/material.dart';
import 'package:cli/question_pool.dart';
import 'package:cli/question_loader.dart';
import 'package:cli/quiz.dart';
import 'package:cli/question.dart';

class TakeQuizScreen extends StatefulWidget {
  const TakeQuizScreen({super.key});

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

  Future loadQuiz() async {
    QuestionLoader loader = QuestionLoader();
    List<Quiz> quizzes = await loader.getQuizzesFromUrl();
    Quiz quiz = quizzes[0];
    final pool = QuestionPool(quiz.questions);
    pool.startPracticeTest(5); //[5 questions for practice test]

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
      appBar: AppBar(backgroundColor: Colors.blue, title: const Text('Quiz')),
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
