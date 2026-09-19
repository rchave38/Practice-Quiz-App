import 'question.dart';

class UiLogic {
  void displayMenu() {
    print('Welcome to the Quiz App!');
    print('1. Take practice quiz');
    print('2. Exit');
  }

  void displayQuestion(Question question) {
    question.display();
  }
}