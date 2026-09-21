import 'package:cli/question_pool.dart';
import 'package:cli/quiz.dart';
import 'question.dart';
import 'dart:io';

/// Handles the console menu and quiz-taking flow.
class UiLogic {
  final List<Quiz> _quizzes;
  int _quizIndex = 0;

  UiLogic(this._quizzes);

  /// Shows the main menu loop until the user exits.
  void displayMenu() {

    bool condition = true;
    while(condition){
      final activeQuiz = _quizzes[_quizIndex];
      print('\n========================================');
      print('Welcome to the Quiz App!');
      print('Current Loaded Quiz: ${activeQuiz.title}');
      print('========================================');
      print('1: Take Practice Quiz');
      print('2: Move to Next Quiz');  
      print('3: Exit');    
      stdout.write('Select Option (1-3)');
      String? rawInput = stdin.readLineSync();

      // try to parse it, but if it fails, it becomes null instead of crashing
      int? input = int.tryParse(rawInput ?? '');
      final questionPool = QuestionPool(activeQuiz.questions);
      switch(input){
        case 1:
          print ('Starting ${activeQuiz.title}');
          takeQuiz(questionPool);
          _quizIndex = (_quizIndex + 1) % _quizzes.length;
        case 2:
          print('Moving to next Quiz...');
          _quizIndex = (_quizIndex + 1) % _quizzes.length;
        case 3:
          print('Goodbye...');
          questionPool.resetQuiz();
          condition = false;
        default:
          print('Please enter an integer value (1-3)');
      }
    }  
  }

  /// Prints a single question to the console.
  void displayQuestion(Question question) {
    question.display();
  }

  /// Runs through every question in [pool], collecting answers and
  /// printing the final score.
  void takeQuiz(QuestionPool pool){
    //as long as there are questions left take quiz
    while(pool.currentIndex < pool.questions.length){
      final currentQuestion = pool.getCurrentQuestion();
    //show question in nice way
    print('\n[Question ${pool.currentIndex + 1}/${pool.questions.length}]');
    print(currentQuestion.question);

    //print answer choices in a neat way
    if(currentQuestion is MultipleChoiceQuestion){
      for(int i = 0; i < currentQuestion.options.length;i++){
        print('${i + 1}. ${currentQuestion.options[i]}');
      }//for
    }//if

    //if statement to tell dart its MultipleChoiceQuestion
    if (currentQuestion is MultipleChoiceQuestion) {
      print('Enter Answer (1-${currentQuestion.options.length})');
    }

    if(currentQuestion is FillInBlankQuestion) {
      print('Fill in the blank: ');
    }

    String? rawInput = stdin.readLineSync();

    if(currentQuestion is MultipleChoiceQuestion){
      int? choice = int.tryParse(rawInput ?? '');
      if(choice != null){
        pool.submitAnswer(choice);
      }else{
        print('Invalid input. Enter a number:');
        continue;
      }
    } else if (currentQuestion is FillInBlankQuestion){
      pool.submitAnswer(rawInput);
    }
    pool.goToNextQuestion();
    }
    print('\n------------------------');
    print('Quiz Completed!');
    print('Your Final Score: ${pool.trackScore()} / ${pool.questions.length}');
    print('------------------------');
  }

  /// Prints [pool]'s current score.
  void showScore(QuestionPool pool){
    print('\n------------------------');
    print('Your score: ${pool.trackScore()} / ${pool.questions.length}');
    print('--------------------------');
  }
}