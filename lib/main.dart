import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static const platform = const MethodChannel("com.kiko.wifi/act");
  List<String> _msg;
  Future<void> getMsg() async {
     List<String> msg;
    try {
      msg=await platform.invokeListMethod('getList');
    } on PlatformException catch (e) {
      print(e.toString());
    }
    setState(() {
      _msg=msg;
    });
  }
  showToast(String msg) async {
    try {
      await platform.invokeMethod("showToast",{"msg":msg});
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }
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
