import 'package:flutter/material.dart';
import 'package:cli/question_pool.dart';
import 'package:cli/question_loader.dart';
import 'package:cli/quiz.dart';

class TakeQuizScreen extends StatefulWidget {
  const TakeQuizScreen({super.key});

  @override
  State<TakeQuizScreen> createState() => _TakeQuizScreenState();
}

class _TakeQuizScreenState extends State<TakeQuizScreen> {
  QuestionPool? questionPool;

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
            ],
          ),
        ),
      ),
    );
  }
}
