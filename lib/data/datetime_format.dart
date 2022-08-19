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
}
