import 'question.dart';

/// Holds a quiz's title and its list of questions.
class Quiz {
  /// The quiz's name, e.g. "Quiz 01".
  final String title;

  /// The questions in this quiz.
  final List<Question> questions;

  /// Creates a quiz with the given [title] and [questions].
  Quiz(this.title, this.questions);
}
