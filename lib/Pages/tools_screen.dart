import 'package:flutter/material.dart';

class ToolScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("工具")),
      body: Center(
        child: Text('这是工具页面'),
      ),
    );
  }
}