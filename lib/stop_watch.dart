import 'package:flutter/material.dart';

class StopWatchScreen extends StatelessWidget {
  const StopWatchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('stopwatch'),
      ),
    );
  }
}
