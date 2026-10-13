import 'dart:io';
import 'package:cli/question.dart';
import 'package:cli/question_pool.dart';
import 'package:cli/quiz.dart';

/// Handles the console menu and quiz-taking flow.
class UiLogic {
  final List<Quiz> _quizzes;
  int _quizIndex = 0;

  UiLogic(this._quizzes);

  Quiz get _activeQuiz {
    return _quizzes[_quizIndex];
  }

  void _nextQuiz() {
    _quizIndex = (_quizIndex + 1) % _quizzes.length;
  }

  /// Prints a prompt and returns the typed number (null if not a number).
  int? _readInt(String prompt) {
    stdout.write(prompt);
    return int.tryParse(stdin.readLineSync() ?? '');
  }

  /// Main menu loop. Runs until the user picks Exit.
  void displayMenu() {
    while (true) {
      _printMenu();
      int? choice = _readInt('Select Option (1-3): ');

      switch (choice) {
        case 1:
          _startQuiz();
        case 2:
          print('Moving to next Quiz...');
          _nextQuiz();
        case 3:
          print('Goodbye...');
          return;
        default:
          print('Please enter an integer value (1-3)');
      }
    }
  }

  void _printMenu() {
    print('\n========================================');
    print('Welcome to the Quiz App!');
    print('Current Loaded Quiz: ${_activeQuiz.title}');
    print('========================================');
    print('1: Take Practice Quiz');
    print('2: Move to Next Quiz');
    print('3: Exit');
  }

  /// Asks how many questions, then runs the quiz.
  void _startQuiz() {
    final quiz = _activeQuiz;
    final total = quiz.questions.length;

    int? count = _readInt('How many questions? (1-$total) ');
    if (count == null || count < 1 || count > total) {
      print('Invalid number of questions.');
      return;
    }

    final pool = QuestionPool(quiz.questions);
    pool.startPracticeTest(count);

    print('Starting ${quiz.title}');
    takeQuiz(pool);
    _nextQuiz();
  }

  /// Asks every question in [pool], then prints the final score.
  void takeQuiz(QuestionPool pool) {
    while (pool.currentIndex < pool.questions.length) {
      final question = pool.getCurrentQuestion();

      print('\n[Question ${pool.currentIndex + 1}/${pool.questions.length}]');
      print(question.question);

      bool answered;
      if (question is MultipleChoiceQuestion) {
        answered = _askMultipleChoice(question, pool);
      } else {
        answered = _askFillInBlank(pool);
      }

      // Only move on if the answer was valid
      if (answered) {
        pool.goToNextQuestion();
      }
    }

    print('\n------------------------');
    print('Quiz Completed!');
    print('Your Final Score: ${pool.trackScore()} / ${pool.questions.length}');
    print('------------------------');
  }

  /// Returns true if the user gave a valid number.
  bool _askMultipleChoice(MultipleChoiceQuestion question, QuestionPool pool) {
    for (int i = 0; i < question.options.length; i++) {
      print('${i + 1}. ${question.options[i]}');
    }

    int? choice = _readInt('Enter Answer (1-${question.options.length}): ');
    if (choice == null) {
      print('Invalid input. Enter a number.');
      return false;
    }

    pool.submitAnswer(choice);
    return true;
  }

  /// Fill-in-the-blank always counts as answered.
  bool _askFillInBlank(QuestionPool pool) {
    stdout.write('Fill in the blank: ');
    pool.submitAnswer(stdin.readLineSync());
    return true;
  }
}
