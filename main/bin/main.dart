import 'package:cli/question_loader.dart';
import 'package:cli/quiz.dart';
import 'package:cli/ui_logic.dart';

/// Author: Ruben Chavez
/// Class: CS 4381
///
/// Loads quizzes from the server and starts the console menu.
void main(List<String> arguments) async {
  try {
    print('Connecting to server...');

    // Download all quizzes from the server
    QuestionLoader loader = QuestionLoader();
    List<Quiz> quizzes = await loader.getQuizzesFromUrl();

    // Start the menu
    UiLogic menu = UiLogic(quizzes);
    menu.displayMenu();
  } catch (e) {
    print('Error starting application: $e');
  }
}