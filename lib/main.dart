import 'package:earlier_alarm/add_alarm.dart';
import 'package:earlier_alarm/alarm_list.dart';
import 'package:earlier_alarm/data/loading.dart';
import 'package:earlier_alarm/google_map.dart';
import 'package:earlier_alarm/weather.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Earlier alarm',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(title: 'Earlier alarm'),
      // initialRoute: '/',
      // routes: {
      //   '/' (context) => const AlarmListScreen(),
      //   '/add_alarm' (context) => const AddAlarmScreen(),
      //   '/google_map' (context) => const GoogleMapScreen(),
      //   '/weather' (context) => const WeatherScreen(),
      // },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  List<Widget> pages = [
    Loading(),
    AlarmListScreen(),
    WeatherScreen(),
    GoogleMapScreen()
  ];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        child: pages[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onItemTapped,
        currentIndex: selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.add), title: Text('Add')),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_rounded), title: Text('List')),
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
