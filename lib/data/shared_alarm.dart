import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  setTime(
      String name, String time, String minusMins, String date, var week) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('time', time);
    prefs.setString('minus', minusMins);
    prefs.setString('date', date);
    prefs.setString('week', week);
  }

  setBackground(String background) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('background', background);
  }

  getBackground() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getString('background');
  }
}
