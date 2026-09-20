import 'package:http/http.dart' as http;
import 'question.dart';
import 'quiz.dart';
import 'dart:convert';

// This is the question loader class which will be used to load the questions from the URL.
// It is meant to grab the data from the website and get a Quiz and its list of questions.
class QuestionLoader  {
// Function to fetch questions from the specified URL
// This function retrieves the JSON data from the URL and decodes it into a Map
// The function is asynchronous and uses the http package to perform the read request.
Future<Quiz> getQuestionsFromUrl() async {
  final httpPackageUrl = Uri.parse('http://www.cs.utep.edu/cheon/cs4381/homework/quiz/');
  final httpPackageResponse = await http.get(httpPackageUrl);
  if(httpPackageResponse.statusCode != 200) {
    throw Exception('Failed to load questions from URL');
  }
  final httpPackageJson = json.decode(httpPackageResponse.body) as Map<String, dynamic>;
  // Grab inner map from the JSON data
  final bool isSuccess = httpPackageJson['response'];
  if(isSuccess){
    //grab quiz data
    final quizMap = httpPackageJson['quiz'] as Map<String,dynamic>;
    //quiz title
    final title = quizMap['title'] as String;
    //grab questions list from quiz
    final questionList = quizMap['questions'] as List<dynamic>;
    //parsed questions
    final List<Question> parsedQuestion = [];
    //grab map from inside quistionList
    for(int i = 0; i < questionList.length; i++){
      final typeMap = questionList[i] as Map<String, dynamic>;
      final type = typeMap['type'];
      if(type == 1){
        final stem = typeMap['stem'] as String;
        //cast it as a list first and then cast the contents using .cast<String>();
        final options = (typeMap['options'] as List).cast<String>();
        final answer = typeMap['answer'] as int;
        //create object
        MultipleChoiceQuestion questionMC = MultipleChoiceQuestion (stem, options, answer);
        //add questionMc to parsed question list 
        parsedQuestion.add(questionMC);
      }else{
        final stem = typeMap['stem'] as String;
        final acceptableAnswers = typeMap['answer'] as List<String>;
        //create object
        FillInBlankQuestion questionFB = FillInBlankQuestion(stem, acceptableAnswers);
        //add questionFB to parsed question list 
        parsedQuestion.add(questionFB);
      }
    }
    //return quiz
    return Quiz(title, parsedQuestion);
  }else{
    throw Exception('Quiz not found!');
  }
}
}
