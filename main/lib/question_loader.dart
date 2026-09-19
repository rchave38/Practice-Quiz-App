import 'package:http/http.dart' as http;
import 'dart:convert';

class QuestionLoader  {

}

// Function to fetch questions from the specified URL
// This function retrieves the JSON data from the URL and decodes it into a Map
// The function is asynchronous and uses the http package to perform the read request.
Future<List<dynamic>> getQuestionsFromUrl() async {
  final httpPackageUrl = Uri.parse('http://www.cs.utep.edu/cheon/cs4381/homework/quiz/');
  final httpPackageResponse = await http.get(httpPackageUrl);
  if(httpPackageResponse.statusCode != 200) {
    throw Exception('Failed to load questions from URL');
  }
  final httpPackageJson = json.decode(httpPackageResponse.body) as Map<String, dynamic>;
  
  return httpPackageJson;
}


