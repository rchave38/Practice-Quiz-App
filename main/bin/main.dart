import 'package:cli/question.dart';
import 'package:cli/ui_logic.dart';
import 'package:cli/question_pool.dart';
import 'package:cli/quiz.dart';
import 'package:cli/question_loader.dart';
import 'dart:io';

///Author: Ruben Chavez
///Class: CS 4381
///
///
///
/// Loads quizzes from the server and starts the console menu.
void main(List<String> arguments) async {
  try {
    print('Connecting to server...');
    final loader = QuestionLoader();
    
    // Create quiz object and grab questions from URL
    List<Quiz> quizzes = await loader.getQuizzesFromUrl();
    final selectedQuiz = quizzes[0];
    // Get questions list
    final questionPool = QuestionPool(selectedQuiz.questions);
    
    // Display menu 
    final menu = UiLogic(quizzes);
    menu.displayMenu();
    
  } catch (e) {
    print(' Error starting application: $e');
  }
}