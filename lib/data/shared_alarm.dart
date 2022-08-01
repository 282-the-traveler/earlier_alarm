import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  String name ='noname';
  String time = '9:30';
  String minusMins = '10';
  String date = '20220731';
  var week = {'Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'};

  setTime(
      String name, String time, String minusMins, String date, var week) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('time', time);
    prefs.setString('minus', minusMins);
    prefs.setString('date', date);
    prefs.setString('week', week);
  }

  getTime(String time) async{
    final prefs = await SharedPreferences.getInstance();
    if (time == prefs.getString(time)) {
      prefs.getString(name);
      prefs.getString(minusMins);
      prefs.getString(date);
    }

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
