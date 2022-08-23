import 'package:intl/intl.dart';

class DateTimeFormat {
  static String getSystemTime() {
    var _now = DateTime.now();
    return DateFormat("h:mm a").format(_now);
  }

  static String getSystemDate() {
    var _now = DateTime.now();
    return DateFormat("EEEE, MMM d yyy").format(_now);
  }

  static String getSystemDateTime() {
    var _now = DateTime.now();
    return DateFormat("HH:mm EEEE, MMM d yyy").format(_now);
  }

  static String getCalculatedTime(String time, int difference) {
    DateTime datetime = DateFormat("h:mm a").parse(time);
    DateTime result = datetime.subtract(Duration(minutes: difference));
    return DateFormat("h:mm a").format(result);
  }

  static String getTomorrow() {
    return DateFormat('yyyy-MM-dd').format(DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day + 1,
    ));
  }

  static String getToday() {
    return DateFormat('yyyy-MM-dd').format(DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    ));
  }

  static bool getWeekday(List<bool> selectedWeek) {
    bool _isSelected = false;
    for (int i=0; i < selectedWeek.length; i++) {
      if (selectedWeek[i]) {
       if (i==DateTime.now().weekday) {
         _isSelected = true;
         break;
       } else {
         _isSelected = false;
       }
      } else {
        _isSelected = false;
      }
    }
    return _isSelected;
  }

  static bool isContain(List<bool> selectedWeek) {
    bool isTrue = false;
    for (int i = 0; i < selectedWeek.length; i++) {
      if (selectedWeek[i]) {
        isTrue = true;
        break;
      } else {
        isTrue = false;
      }
    }
    return isTrue;
  }
}
