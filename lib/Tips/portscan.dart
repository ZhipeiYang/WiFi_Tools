import 'package:flutter/material.dart';

class PortScanWidget extends StatefulWidget {
  @override
  _PortScanWidgetState createState() => _PortScanWidgetState();
}

class _PortScanWidgetState extends State<PortScanWidget> {
  var _textStyle = TextStyle(fontSize: 16);
  TextEditingController _ipController = TextEditingController();
  TextEditingController _portController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Card(
                child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      // Container(
                      //   margin: EdgeInsets.only(right: 20),
                      //   child: LimitedBox(
                      //     child: Text(
                      //       "域名:",
                      //       style:_textStyle,                           
                      //     ),
                      //     maxWidth: 70,
                      //   ),
                      // ),
                      Expanded(
                          child: TextField(
                            decoration:
                                InputDecoration(labelText: '域名:'),
                            style: TextStyle(fontSize: 18.0, color: Colors.blue),                           
                            controller: _ipController,
                      )),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      // Container(
                      //   margin: EdgeInsets.only(right: 20),
                      //   child: LimitedBox(
                      //     child: Text(
                      //       "端口:",
                      //       style: _textStyle,
                      //     ),
                      //     maxWidth: 70,
                      //   ),
                      // ),
                      Expanded(
                          child: TextField(
                            decoration:
                                InputDecoration(labelText: '端口:'),
                            style: TextStyle(fontSize: 18.0, color: Colors.blue),                          
                            controller: _portController,
                      )),
                    ],
                  ),
                ),
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  splashColor: Colors.lightBlue,
                  child: Text('开始扫描'),
                  onPressed: ScanPort,
                ),
              ],
            ));
  }
  void ScanPort() {
    var ipStr = _ipController.text;
    var portStr = _portController.text;
    print("IP:" + ipStr + " Port:" + portStr);
  }
}