import 'dart:convert';

import 'package:http/http.dart' as http;

import 'question.dart';
import 'quiz.dart';

/// Fetches quizzes from the course's web service.
class QuestionLoader {
  /// Requests quiz01, quiz02, ... until the server responds with
  /// `"response": false`, and returns all quizzes loaded along the way.
  ///
  /// When [user] and [pin] are given, the login-protected `quiz.php`
  /// service is used. Otherwise the public quiz page is used.
  /// Throws an [Exception] if no quizzes could be loaded.
  Future<List<Quiz>> getQuizzesFromUrl({String? user, String? pin}) async {
    List<Quiz> allQuizzes = [];
    int i = 1;

    while (true) {
      // Turns 1 into "01", 2 into "02"
      String quizNumber = i.toString().padLeft(2, '0');
      Uri url = _quizUrl('quiz$quizNumber', user, pin);

      try {
        var response = await http.get(url);
        if (response.statusCode != 200) break;

        // Decode manually to prevent 'FormatException: Unexpected extension byte'
        String bodyString = utf8.decode(
          response.bodyBytes,
          allowMalformed: true,
        );
        Map<String, dynamic> jsonMap = json.decode(bodyString);

        // Server says "response": false when there are no more quizzes
        bool isSuccess = jsonMap['response'] ?? false;
        if (!isSuccess) break;

        Quiz quiz = _parseQuiz(jsonMap['quiz']);
        allQuizzes.add(quiz);
        print('Loaded ${quiz.title} ($i)');
        i++;
      } catch (e) {
        print('Stopped at quiz$quizNumber: $e');
        break;
      }
    }

    if (allQuizzes.isEmpty) {
      throw Exception('Failed to load any quizzes from the server.');
    }

    return allQuizzes;
  }

  /// Loads every quiz and returns all of their questions in one list.
  Future<List<Question>> getAllQuestions({String? user, String? pin}) async {
    List<Quiz> quizzes = await getQuizzesFromUrl(user: user, pin: pin);

    List<Question> allQuestions = [];
    for (Quiz quiz in quizzes) {
      allQuestions.addAll(quiz.questions);
    }
    return allQuestions;
  }

  /// Builds the address for [quizName], with the login if one is given.
  Uri _quizUrl(String quizName, String? user, String? pin) {
    if (user != null && pin != null) {
      return Uri.https(
        'www.cs.utep.edu',
        '/cheon/cs4381/homework/quiz/quiz.php',
        {'user': user, 'pin': pin, 'quiz': quizName},
      );
    }
    return Uri.https(
      'www.cs.utep.edu',
      '/cheon/cs4381/homework/quiz/',
      {'quiz': quizName},
    );
  }

  /// Turns the server's quiz JSON into a [Quiz].
  ///
  /// [quizData] may be a map or a JSON-encoded string of one.
  Quiz _parseQuiz(dynamic quizData) {
    Map<String, dynamic> quizMap;
    if (quizData is String) {
      quizMap = json.decode(quizData);
    } else {
      quizMap = quizData;
    }
    String title = quizMap['name'];
    List<dynamic> questionList = quizMap['questions'];

    List<Question> questions = [];
    for (var questionMap in questionList) {
      String stem = questionMap['stem'];
      String? figure = questionMap['figure'];

      if (questionMap['type'] == 1) {
        // Type 1 = multiple choice
        List<String> options = List<String>.from(questionMap['options']);
        int answer = questionMap['answer'];
        questions.add(
          MultipleChoiceQuestion(stem, options, answer, figure: figure),
        );
      } else {
        // Any other type = fill in the blank
        List<String> answers = List<String>.from(questionMap['answer']);
        questions.add(FillInBlankQuestion(stem, answers, figure: figure));
      }
    }

    return Quiz(title, questions);
  }
}
