import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("关于")),
      body: Center(
        child: Text('这是关于页面'),
      ),
    );
  }
}
