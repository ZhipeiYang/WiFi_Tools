import 'package:flutter/material.dart';

class ToolScreen extends StatefulWidget {
  @override
  _ToolScreenState createState() => _ToolScreenState();
}

class _ToolScreenState extends State<ToolScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(("工具")),
        ),
        body: Text('这是工具界面')
    );
  }

  
}
