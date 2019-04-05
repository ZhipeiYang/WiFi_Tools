import 'package:flutter/material.dart';
import 'package:wifitools/Tips/netspeed.dart';

class SpeedTestScreen extends StatefulWidget {
  @override
  _SpeedTestScreenState createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  @override
  String _up = "1.0";
  String _down = "2.0";
  Widget build(BuildContext context) {
    var netSpeedWidget = NetSpeedWidget(_up, _down);
    return Scaffold(
      appBar: AppBar(
        title: Text('测速'),
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
            //点击时反应
            onTap: () {
              print("测速控件被点击");
              setState(() {
                _up = (double.parse(_up) + 1.0).toString();
                _down = (double.parse(_down) + 1.0).toString();
              });
            },
            child: Card(
              child: netSpeedWidget,
            ),
          ),
        ],
      ),
    );
  }
}
