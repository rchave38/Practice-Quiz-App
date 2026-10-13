import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question.dart';
import 'quiz.dart';

/// Fetches all quizzes from the course's web service.
class QuestionLoader {
  /// Requests quiz01, quiz02, ... until the server responds with
  /// `"response": false`, and returns all quizzes loaded along the way.
  Future<List<Quiz>> getQuizzesFromUrl() async {
    List<Quiz> allQuizzes = [];
    int i = 1;

    while (true) {
      // Turns 1 into "01", 2 into "02"
      String quizNumber = i.toString().padLeft(2, '0');
      Uri url = Uri.parse(
          'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/?quiz=quiz$quizNumber');

      try {
        // 200 means success, anything else is failure
        var response = await http.get(url);
        if (response.statusCode != 200) break;

        // Decode manually to prevent 'FormatException: Unexpected extension byte'
        String bodyString = utf8.decode(response.bodyBytes, allowMalformed: true);
        Map<String, dynamic> jsonMap = json.decode(bodyString);

        // Server says "response": false when there are no more quizzes
        bool isSuccess = jsonMap['response'] ?? false;
        if (!isSuccess) break;

        // Pull the title and question list out of the JSON
        Map<String, dynamic> quizMap = jsonMap['quiz'];
        String title = quizMap['name'];
        List<dynamic> questionList = quizMap['questions'];

        // Turn each JSON question into a Question object
        List<Question> questions = [];
        for (var questionMap in questionList) {
          String stem = questionMap['stem'];

          if (questionMap['type'] == 1) {
            // Type 1 = multiple choice
            List<String> options = List<String>.from(questionMap['options']);
            int answer = questionMap['answer'];
            questions.add(MultipleChoiceQuestion(stem, options, answer));
          } else {
            // Any other type = fill in the blank
            List<String> answers = List<String>.from(questionMap['answer']);
            questions.add(FillInBlankQuestion(stem, answers));
          }
        }

        allQuizzes.add(Quiz(title, questions));
        print('Loaded $title ($i)');
        i++;
      } catch (e) {
        // If a quiz fails to load, show which one
        print('Stopped at i=$i: $e');
        break;
      }
    }

    if (allQuizzes.isEmpty) {
      throw Exception('Failed to load any quizzes from the server.');
    }

    return allQuizzes;
  }
}
