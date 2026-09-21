import 'question.dart';

/// Holds a quiz's title and its list of questions.
//Quiz object holds the title of a quiz, and a list of its questions
class Quiz {
  final String title;
  final List<Question> questions;

  Quiz(this.title, this.questions);
}