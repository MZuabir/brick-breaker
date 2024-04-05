import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  storeHighestScore(String score) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('score', score);
  }

  Future<String?> getScore() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('score');
  }
}
