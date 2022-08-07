import 'package:earlier_alarm/current_alarm.dart';
import 'package:earlier_alarm/add_alarm.dart';
import 'package:earlier_alarm/data/loading.dart';
import 'package:earlier_alarm/google_map.dart';
import 'package:earlier_alarm/weather_page.dart';
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  final List<Widget> _pages = [
    Loading(),
    AddAlarmScreen(
      title: 'earlier_alarm',
      time: '24:00 PM',
      isOn: false,
      index: 9999,
    ),
    WeatherScreen(),
  ];

  int _currentIndex = 0;

  late List<GlobalKey<NavigatorState>> _navigatorKeyList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _navigatorKeyList =
        List.generate(_pages.length, (index) => GlobalKey<NavigatorState>());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !(await _navigatorKeyList[_currentIndex]
            .currentState!
            .maybePop());
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages.map((page) {
            int index = _pages.indexOf(page);
            return Navigator(
              key: _navigatorKeyList[index],
              onGenerateRoute: (_) {
                return MaterialPageRoute(builder: (context) => page);
              },
            );
          }).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list_alt_rounded,
              ),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
              ),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.wb_sunny_outlined,
              ),
              label: 'Weather',
            ),
          ],
        ),
      ),
    );
  }
}
