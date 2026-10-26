import 'dart:convert';

import 'package:http/http.dart' as http;

/// Checks a user's login with the course's web service.
class LoginService {
  /// Returns true if [user] and [pin] are a valid login, or false if not.
  ///
  /// Throws an [Exception] if the server can't be reached.
  Future<bool> login(String user, String pin) async {
    Uri url = Uri.https(
      'www.cs.utep.edu',
      '/cheon/cs4381/homework/quiz/login.php',
      {'user': user, 'pin': pin},
    );

    var response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    Map<String, dynamic> jsonMap = json.decode(response.body);
    return jsonMap['response'] == true;
  }
}
