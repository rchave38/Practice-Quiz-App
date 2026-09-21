/// A single question in a quiz.
///
/// Abstract base class extended by [MultipleChoiceQuestion] and
/// [FillInBlankQuestion].
abstract class Question {
  final String _question;

  Question(this._question);

  String get question => _question;

  void display();
} //question class

/// A fill-in-the-blank question with one or more acceptable answers.
// This is the fill in the blank question class which extends the question class.
class FillInBlankQuestion extends Question {
  final List<String> _acceptableAnswers;
  List<String> get acceptableAnswers => _acceptableAnswers;

  FillInBlankQuestion(super.question, this._acceptableAnswers);

  @override
  void display() {
    print('Question: $question');
  }
} //fill in the blank question class

/// A multiple choice question with a list of options and one correct index.
// This is the multiple choice question class which extends the question class.
class MultipleChoiceQuestion extends Question {
  final int _correctOptionIndex;
  final List<String> _options;

  List<String> get options => _options;
  int get correctOptionIndex => _correctOptionIndex;

  MultipleChoiceQuestion(super.question, this._options, this._correctOptionIndex);

  /// Returns true if [selectedOptionIndex] is the correct answer.
  bool isCorrect(int selectedOptionIndex) {
    return selectedOptionIndex == _correctOptionIndex;
  }

  int numberOfOptions() => _options.length;

  @override
  void display() {
    print('Question: $question');
  }
} // multiple choice question class