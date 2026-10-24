import 'dart:convert';
import 'package:http/http.dart' as http;

/// Checks a user's login with the course's web service.
class LoginService {
  /// Returns true if [user] and [pin] are a valid login.
  ///
  /// Returns false if the login is wrong or the server can't be reached.
  Future<bool> login(String user, String pin) async {
    // Builds .../login.php?user=<user>&pin=<pin>
    Uri url = Uri.https(
      'www.cs.utep.edu',
      '/cheon/cs4381/homework/quiz/login.php',
      {'user': user, 'pin': pin},
    );

    try {
      var response = await http.get(url);
      if (response.statusCode != 200) return false;

      Map<String, dynamic> jsonMap = json.decode(response.body);

      // Server says "response": true when the login is valid
      return jsonMap['response'] == true;
    } catch (e) {
      print('Login failed: $e');
      return false;
    }
  }
}
