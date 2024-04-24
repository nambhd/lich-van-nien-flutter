import 'package:calendar/container/info_container.dart';
import 'package:calendar/container/month_container.dart';
import 'package:calendar/container/single_day_container.dart';
import 'package:flutter/material.dart';

import 'components/bottom_tabs/BottomTab.dart';
import 'components/bottom_tabs/TabItemData.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _widgets = [
    SingleDayContainer(),
    MonthContainer(),
    InfoContainer()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
            IndexedStack(
              index: _currentIndex,
              children: <Widget>[
                ..._widgets
              ],
            ),
                // new
                BottomTab(
                  currentIndex: _currentIndex,
                  onTabTapped: _onItemTapped,
                  items: [
                    TabItemData(
                        index: 0,
                        title: "Ngày",
                        image: "assets/calendar_day.png"),
                    TabItemData(
                        index: 1,
                        title: "Tháng",
                        image: "assets/calendar_month.png"),
                    TabItemData(
                        index: 2, title: "Mở rộng", image: "assets/menu.png")
                  ],
                )
              ],
            ),
            bottom: true,
            top: false));
  }
}
