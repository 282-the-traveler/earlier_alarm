import 'package:earlier_alarm/common/datetime_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class AlertAlarm extends StatefulWidget {
  const AlertAlarm({Key? key}) : super(key: key);

  @override
  State<AlertAlarm> createState() => _AlertAlarmState();
}

class _AlertAlarmState extends State<AlertAlarm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(DateTimeFormat.getSystemTime(),
            style: const TextStyle(
              fontSize: 45.0,
            )),
        Text(DateTimeFormat.getSystemDate(),
            style: const TextStyle(
              fontSize: 30.0,
            )),
        const SizedBox(
          height: 50.0,
        ),
        IconButton(
          icon: const Icon(Icons.close),
          iconSize: 45.0,
          onPressed: () {
            FlutterRingtonePlayer.stop();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
