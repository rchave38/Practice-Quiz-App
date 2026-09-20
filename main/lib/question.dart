// This is the question class which is an abstract class that will be 
//extended by the fill in the blank and multiple choice question classes.
abstract class Question {
  final String _question;

  Question(this._question);

  String get question => _question;

  void display();
} //question class

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

// This is the multiple choice question class which extends the question class.
class MultipleChoiceQuestion extends Question {
  final int _correctOptionIndex;
  final List<String> _options;

  List<String> get options => _options;
  int get correctOptionIndex => _correctOptionIndex;

  MultipleChoiceQuestion(super.question, this._options, this._correctOptionIndex);
  
  bool isCorrect(int selectedOptionIndex) {
    return selectedOptionIndex == _correctOptionIndex;
  }

  int numberOfOptions() => _options.length;

  @override
  void display() {
    print('Question: $question');
  }
} // multiple choice question class