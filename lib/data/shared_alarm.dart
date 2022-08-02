import 'package:earlier_alarm/data/earlier_alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedData {
  String name ='noname';
  String time = '9:30';
  String minusMins = '10';
  String date = '20220731';
  var week = {};



  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();




  // EarlierAlarm getTime _pref.then(SharedPreferences prefs){
  //   if (time == prefs.getString(time)) {
  //     prefs.getString(name);
  //     prefs.getString(minusMins);
  //     prefs.getString(date);
  //   }
  //   return EarlierAlarm(name, time, minusMins, date, week);
  // }

  setBackground(String background) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('background', background);
  }

  getBackground() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getString('background');
  }
}
