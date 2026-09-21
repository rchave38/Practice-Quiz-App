import 'question_loader.dart';
import 'quiz.dart';
import 'question.dart';

/// Tracks progress and score through a quiz's list of questions.
class QuestionPool {
  List<Question> _questions;
  int _currentIndex = 0;
  int _score = 0;

  QuestionPool(this._questions);

  List<Question> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;

  /// Submits [userAnswer] for the current question and updates the score.
  //submit question
  void submitAnswer(dynamic userAnswer){
    final currentQuestion = getCurrentQuestion();
    bool correct = false;
    if(currentQuestion is MultipleChoiceQuestion){
      // check if user answer is correct 
      correct = currentQuestion.isCorrect(userAnswer as int);
    }else if(currentQuestion is FillInBlankQuestion){
      //check if user input matches acceptable Answers
      correct = currentQuestion.acceptableAnswers.contains(userAnswer);
    }
    //if answer is correct increase score
    if(correct){_score++;}
  }

  /// Returns the question at the current index.
  //get the current question at current index in question list
  Question getCurrentQuestion(){
    return _questions[_currentIndex];
  }

  /// Advances to the next question, if any remain.
  //get the next question in the question list
  void goToNextQuestion(){
     if (_currentIndex < _questions.length){
      _currentIndex++;
     }
  }

  /// Resets progress and score back to the start.
  //reset question
  void resetQuiz(){
    _currentIndex = 0;
    _score = 0;
  }

  /// Returns the current score.
  int trackScore(){
    return _score;
  }
}