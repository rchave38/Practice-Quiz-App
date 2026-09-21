import 'package:http/http.dart' as http;
import 'question.dart';
import 'quiz.dart';
import 'dart:convert';

/// Fetches all quizzes from the course's web service.
class QuestionLoader {
  /// Requests quiz01, quiz02, ... until the server responds with
  /// `"response": false`, and returns all quizzes loaded along the way.
  Future<List<Quiz>> getQuizzesFromUrl() async {
    List<Quiz> allQuizzes = [];
    int i = 1;

    while (true) {
      String formattedIndex = i.toString().padLeft(2, '0');
      final url = Uri.parse(
        'https://www.cs.utep.edu/cheon/cs4381/homework/quiz/?quiz=quiz$formattedIndex');

      try {
        //200 means success anything else is failure
        final response = await http.get(url);
        if (response.statusCode != 200) break;

        // to prevent 'FormatException: Unexpected extension byte (at offset 1499)'
        final bodyString = utf8.decode(response.bodyBytes, allowMalformed: true);
        final jsonMap = json.decode(bodyString) as Map<String, dynamic>;
        final bool isSuccess = jsonMap['response'] ?? false;
        if (!isSuccess) break;

        final quizMap = jsonMap['quiz'] as Map<String, dynamic>;
        final String title = quizMap['name'] as String;
        final questionList = quizMap['questions'] as List<dynamic>;

        List<Question> currentQuizQuestions = [];
        for (int j = 0; j < questionList.length; j++) {
          //get the Map 
          final typeMap = questionList[j] as Map<String, dynamic>;
          final type = typeMap['type'];
          if (type == 1) {
            //get stem, options, answer to build List<Question>
            final stem = typeMap['stem'] as String;
            final options = (typeMap['options'] as List).cast<String>();
            final answer = typeMap['answer'] as int;
            currentQuizQuestions.add(MultipleChoiceQuestion(stem, options, answer));
          } else {
            //get stem, acceptableAnswers to build List<Question>
            final stem = typeMap['stem'] as String;
            final acceptableAnswers = (typeMap['answer'] as List).cast<String>();
            currentQuizQuestions.add(FillInBlankQuestion(stem, acceptableAnswers));
          }
        }
        //allQuizzes in a quiz list
        allQuizzes.add(Quiz(title, currentQuizQuestions));
        print('Loaded $title ($i)');
        i++;
      } catch (e) {
        print('Stopped at i=$i: $e'); // in case a quiz fails to load it shows the index of that quiz
        break;
      }
    }

    if (allQuizzes.isEmpty) {
      throw Exception('Failed to load any quizzes from the server.');
    }

    return allQuizzes;
  }
}