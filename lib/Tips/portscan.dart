import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class PortScanWidget extends StatefulWidget {
  @override
  _PortScanWidgetState createState() => _PortScanWidgetState();
}

class _PortScanWidgetState extends State<PortScanWidget> {
  static const platform = const MethodChannel("com.kiko.wifi/act");
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
                                InputDecoration(labelText: 'IP地址:'),
                            style: TextStyle(fontSize: 18.0, color: Colors.blue), 
                            keyboardType: TextInputType.number,                          
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
                            keyboardType: TextInputType.number,
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
  void ScanPort()async {
    var ipStr = _ipController.text;
    var portStr = _portController.text;
    //print("IP:" + ipStr + " Port:" + portStr);
    try{
      await platform.invokeMethod("portScan",{"domain":ipStr,"port":portStr});
    }on PlatformException{

    }

    //await platform.invokeMethod("showToast", {"msg": msg});
  }
}