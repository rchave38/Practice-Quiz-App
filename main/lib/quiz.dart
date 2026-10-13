import 'question.dart';

/// Holds a quiz's title and its list of questions.
class Quiz {
  final String title;
  final List<Question> questions;

  Quiz(this.title, this.questions);
}
