/// A single question in a quiz.
///
/// Abstract base class extended by [MultipleChoiceQuestion] and
/// [FillInBlankQuestion].
abstract class Question {
  final String _question;

  /// Creates a question with the given [_question] text.
  Question(this._question);

  /// The text of the question shown to the user.
  String get question {
    return _question;
  }

  String display();
}

/// A fill-in-the-blank question with one or more acceptable answers.
class FillInBlankQuestion extends Question {
  final List<String> _acceptableAnswers;

  /// Creates a fill-in-the-blank question with the given [question] text
  /// and list of [_acceptableAnswers].
  FillInBlankQuestion(super.question, this._acceptableAnswers);

  /// All answers that are accepted as correct.
  List<String> get acceptableAnswers {
    return _acceptableAnswers;
  }

  /// Returns a readable description of this question.
  @override
  String display() {
    return 'FillInBlank: $question';
  }
}

/// A multiple choice question with a list of options and one correct index.
class MultipleChoiceQuestion extends Question {
  final int _correctOptionIndex;
  final List<String> _options;

  /// Creates a multiple choice question with the given [question] text,
  /// list of [_options], and the [_correctOptionIndex] of the right answer.
  MultipleChoiceQuestion(super.question, this._options, this._correctOptionIndex);

  /// The answer choices shown to the user.
  List<String> get options {
    return _options;
  }

  /// The index of the correct option.
  int get correctOptionIndex {
    return _correctOptionIndex;
  }

  /// Returns the number of answer choices.
  int numberOfOptions() {
    return _options.length;
  }

  /// Returns true if [selectedOptionIndex] is the correct answer.
  bool isCorrect(int selectedOptionIndex) {
    return selectedOptionIndex == _correctOptionIndex;
  }

  /// Returns a readable description of this question.
  @override
  String display() {
    return 'MultipleChoice: $question';
  }
}
