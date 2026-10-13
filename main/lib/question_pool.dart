import 'question.dart';

/// Tracks progress and score through a quiz's list of questions.
class QuestionPool {
  List<Question> _allQuestions;
  List<Question> _questions = [];
  int _currentIndex = 0;
  int _score = 0;

  QuestionPool(this._allQuestions);

  List<Question> get questions {
  return _questions;
  }

  int get currentIndex {
    return _currentIndex;
  }

  int get score {
    return _score;
  }
  /// Randomly selects count questions from the full pool to
  /// use for this practice test.
  void startPracticeTest(int count) {
    // Copy the list so the original order is not changed
    List<Question> shuffled = List.from(_allQuestions);
    shuffled.shuffle();

    // Keep only the first [count] questions
    _questions = shuffled.sublist(0, count);
    _currentIndex = 0;
    _score = 0;
  }

  /// Submits userAnswer for the current question and updates the score.
  void submitAnswer(dynamic userAnswer) {
    Question currentQuestion = getCurrentQuestion();
    bool correct = false;

    if (currentQuestion is MultipleChoiceQuestion) {
      // Check if the chosen option number is the right one
      correct = currentQuestion.isCorrect(userAnswer);
    } else if (currentQuestion is FillInBlankQuestion) {
      // Check if the typed text matches one of the acceptable answers
      correct = currentQuestion.acceptableAnswers.contains(userAnswer);
    }

    // Add a point if the answer was correct
    if (correct) {
      _score++;
    }
  }

  /// Returns the question at the current index.
  Question getCurrentQuestion() {
    return _questions[_currentIndex];
  }

  /// Advances to the next question, if any remain.
  void goToNextQuestion() {
    if (_currentIndex < _questions.length) {
      _currentIndex++;
    }
  }

  /// Resets progress and score back to the start.
  void resetQuiz() {
    _currentIndex = 0;
    _score = 0;
  }

  /// Returns the current score.
  int trackScore() {
    return _score;
  }
}
