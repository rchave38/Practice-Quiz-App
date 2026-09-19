abstract class Question {
  final String _question;
  final List<String> _options;
  final int _correctOptionIndex;

  Question(this._question, this._options, this._correctOptionIndex);

  String get question => _question;
  List<String> get options => _options;
  int get correctOptionIndex => _correctOptionIndex;

  int numberOfOptions() => _options.length;

  bool isCorrect(int selectedOptionIndex) {
    return selectedOptionIndex == _correctOptionIndex;
  }
  void display();
} //questoin

class FillInBlankQuestion extends Question {
  FillInBlankQuestion(String question, List<String> options, int correctOptionIndex)
      : super(question, options, correctOptionIndex);

  @override
  void display() {
    print('Question: $question');
  }
}

class MultipleChoiceQuestion extends Question {
  MultipleChoiceQuestion(String question, List<String> options, int correctOptionIndex)
      : super(question, options, correctOptionIndex);

  @override
  void display() {
    print('Question: $question');
  }
}