import 'package:earlier_alarm/providers/alarm_provider.dart';
import 'package:earlier_alarm/providers/weather_provider.dart';
import 'package:earlier_alarm/loading.dart';
import 'package:earlier_alarm/stop_watch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      theme: ThemeData(scaffoldBackgroundColor: Colors.white70),
      darkTheme: ThemeData.dark(),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext context) => WeatherProvider(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => AlarmProvider(),
          ),
        ],
        child: const MyHomePage(),
      ),
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
    const Loading(),
    const StopWatchScreen(),
  ];

  int _currentIndex = 0;

  late List<GlobalKey<NavigatorState>> _navigatorKeyList;

  @override
  void initState() {
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
                Icons.watch_later_outlined,
              ),
              label: 'Stopwatch',
            ),
          ],
        ),
      ),
    );
  }
}
