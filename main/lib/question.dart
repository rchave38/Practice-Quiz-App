/// A single question in a quiz.
///
/// Abstract base class extended by [MultipleChoiceQuestion] and
/// [FillInBlankQuestion].
abstract class Question {
  final String _question;

  /// The image file name for this question, or null if it has no picture.
  final String? figure;

  /// Creates a question with the given [_question] text and an
  /// optional [figure] image file name.
  Question(this._question, {this.figure});

  /// The text of the question shown to the user.
  String get question {
    return _question;
  }

  /// The web address of this question's picture, or null if it has none.
  String? get figureUrl {
    if (figure == null) {
      return null;
    }
    return Uri.https(
      'www.cs.utep.edu',
      '/cheon/cs4381/homework/quiz/figure.php',
      {'name': figure},
    ).toString();
  }

  /// The correct answer, written out for the user to read.
  String get correctAnswer;

  /// Returns true if [answer] is a correct answer to this question.
  ///
  /// A null [answer] (unanswered) is never correct.
  bool isCorrectAnswer(dynamic answer);

  /// Returns a readable description of this question.
  String display();
}

/// A fill-in-the-blank question with one or more acceptable answers.
class FillInBlankQuestion extends Question {
  final List<String> _acceptableAnswers;

  /// Creates a fill-in-the-blank question with the given [question] text
  /// and list of [_acceptableAnswers].
  FillInBlankQuestion(super.question, this._acceptableAnswers, {super.figure});

  /// All answers that are accepted as correct.
  List<String> get acceptableAnswers {
    return _acceptableAnswers;
  }

  @override
  String get correctAnswer {
    return _acceptableAnswers.first;
  }

  @override
  bool isCorrectAnswer(dynamic answer) {
    return _acceptableAnswers.contains(answer);
  }

  @override
  String display() {
    return 'FillInBlank: $question';
  }
}

/// A multiple choice question with a list of options and one correct option.
///
/// Options are numbered starting at 1, so [correctOptionIndex] 1 means the
/// first option.
class MultipleChoiceQuestion extends Question {
  final int _correctOptionIndex;
  final List<String> _options;

  /// Creates a multiple choice question with the given [question] text,
  /// list of [_options], and the [_correctOptionIndex] of the right answer.
  MultipleChoiceQuestion(
    super.question,
    this._options,
    this._correctOptionIndex, {
    super.figure,
  });

  /// The answer choices shown to the user.
  List<String> get options {
    return _options;
  }

  /// The number of the correct option, starting at 1.
  int get correctOptionIndex {
    return _correctOptionIndex;
  }

  /// Returns the number of answer choices.
  int numberOfOptions() {
    return _options.length;
  }

  /// Returns true if [selectedOptionIndex] is the correct option number.
  bool isCorrect(int selectedOptionIndex) {
    return selectedOptionIndex == _correctOptionIndex;
  }

  @override
  String get correctAnswer {
    return _options[_correctOptionIndex - 1];
  }

  @override
  bool isCorrectAnswer(dynamic answer) {
    return answer == _correctOptionIndex;
  }

  @override
  String display() {
    return 'MultipleChoice: $question';
  }
}
