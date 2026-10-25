import 'question.dart';

/// Tracks progress, saved answers, and score through a practice test.
class QuestionPool {
  final List<Question> _allQuestions;
  List<Question> _questions = [];
  final Map<int, dynamic> _answers = {};
  int _currentIndex = 0;
  int _score = 0;

  /// Creates a pool that picks practice test questions from [_allQuestions].
  QuestionPool(this._allQuestions);

  /// The questions in the current practice test.
  List<Question> get questions {
    return _questions;
  }

  /// The position of the current question, starting at 0.
  int get currentIndex {
    return _currentIndex;
  }

  /// The number of correct answers so far.
  int get score {
    return _score;
  }

  /// The number of questions that have a saved answer.
  int get answeredCount {
    return _answers.length;
  }

  /// The saved answer for the current question, or null if it has none.
  dynamic get currentAnswer {
    return _answers[_currentIndex];
  }

  /// Whether the current question is the first one in the test.
  bool get isFirstQuestion {
    return _currentIndex == 0;
  }

  /// Whether the current question is the last one in the test.
  bool get isLastQuestion {
    return _currentIndex == _questions.length - 1;
  }

  /// Randomly selects [count] questions from the full pool to use for this
  /// practice test. If [count] is more than the pool has, all are used.
  void startPracticeTest(int count) {
    List<Question> shuffled = List.from(_allQuestions);
    shuffled.shuffle();

    if (count > shuffled.length) {
      count = shuffled.length;
    }

    _questions = shuffled.sublist(0, count);
    _answers.clear();
    _currentIndex = 0;
    _score = 0;
  }

  /// Checks [userAnswer] for the current question right away and adds a
  /// point if it is correct.
  void submitAnswer(dynamic userAnswer) {
    if (getCurrentQuestion().isCorrectAnswer(userAnswer)) {
      _score++;
    }
  }

  /// Saves [answer] for the current question without scoring it yet.
  ///
  /// The answer can be changed later. An empty answer clears it.
  void saveAnswer(dynamic answer) {
    if (answer == null || answer == '') {
      _answers.remove(_currentIndex);
    } else {
      _answers[_currentIndex] = answer;
    }
  }

  /// Scores every saved answer and returns the questions that were answered
  /// incorrectly or skipped.
  List<Question> gradeAnswers() {
    _score = 0;
    List<Question> incorrect = [];

    for (int i = 0; i < _questions.length; i++) {
      if (_questions[i].isCorrectAnswer(_answers[i])) {
        _score++;
      } else {
        incorrect.add(_questions[i]);
      }
    }
    return incorrect;
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

  /// Moves back to the previous question, if there is one.
  void goToPreviousQuestion() {
    if (_currentIndex > 0) {
      _currentIndex--;
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
