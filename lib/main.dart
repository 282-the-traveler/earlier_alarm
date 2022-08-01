import 'package:earlier_alarm/current_alarm.dart';
import 'package:earlier_alarm/add_alarm.dart';
import 'package:earlier_alarm/data/loading.dart';
import 'package:earlier_alarm/google_map.dart';
import 'package:earlier_alarm/weather.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Earlier alarm',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(title: 'Earlier alarm'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  List<Widget> pages = [
    Loading(),
    AddAlarmScreen(),
    WeatherScreen(),
    GoogleMapScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onItemTapped,
        currentIndex: selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), title: Text('List')),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), title: Text('Add')),
          BottomNavigationBarItem(
              icon: Icon(Icons.wb_sunny_outlined), title: Text('Weather')),
          BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined), title: Text('Map')),
        ],
      ),
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
