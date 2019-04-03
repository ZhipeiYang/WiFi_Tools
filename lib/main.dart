import 'package:flutter/material.dart';
import 'BottomNavigationWidget.dart';
void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with AutomaticKeepAliveClientMixin{
 
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wifi_Tools',
      theme: ThemeData.light(),
      home: BottomNavigationWidget(),
    );
  }
}
