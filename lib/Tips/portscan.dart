import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifitools/Class/port_bind.dart';
import 'package:wifitools/Class/port_tile.dart';
import 'dart:async';

class PortScanWidget extends StatefulWidget {
  @override
  _PortScanWidgetState createState() => _PortScanWidgetState();
}

class _PortScanWidgetState extends State<PortScanWidget> {
  static const platform = const MethodChannel("com.kiko.wifi/act");
  var _textStyle = TextStyle(fontSize: 16);
  TileList _tileList;
  bool _tileListFlag = false;
  PortBind _portBind;
  TextEditingController _ipController = TextEditingController();
  TextEditingController _portController = TextEditingController();
  @override
  void initState() {
    // var jsonStr="[{\"checked\":false,\"port\":21,\"information\":\"FTP\"},{\"checked\":false,\"port\":22,\"information\":\"SSH\"},{\"checked\":false,\"port\":23,\"information\":\"Telnet\"},{\"checked\":false,\"port\":25,\"information\":\"SMTP\"},{\"checked\":false,\"port\":53,\"information\":\"DNS\"},{\"checked\":false,\"port\":69,\"information\":\"TFTP\"},{\"checked\":false,\"port\":80,\"information\":\"Http\"},{\"checked\":false,\"port\":110,\"information\":\"POP3\"},{\"checked\":false,\"port\":161,\"information\":\"SNMP\"},{\"checked\":false,\"port\":389,\"information\":\"LDAP\"},{\"checked\":false,\"port\":443,\"information\":\"HTTPS\"},{\"checked\":false,\"port\":445,\"information\":\"SMB\"},{\"checked\":false,\"port\":1080,\"information\":\"SOCKS Proxy\"},{\"checked\":false,\"port\":5900,\"information\":\"VNC\"},{\"checked\":false,\"port\":3306,\"information\":\"MySQL\"},{\"checked\":false,\"port\":1433,\"information\":\"SqlServer Server\"},{\"checked\":false,\"port\":1434,\"information\":\"SqlServer Monitor\"},{\"checked\":false,\"port\":1521,\"information\":\"Oracle\"},]";
    // print(jsonStr);
    // _tileList=new TileList("jsonStr");
    _getTileJson().then((value) {
      //print(value);
      setState(() {
        _tileList = new TileList(value);
        _tileListFlag = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: TextField(
                decoration: InputDecoration(labelText: 'IP地址:'),
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
              Expanded(
                  child: TextField(
                decoration: InputDecoration(labelText: '端口:'),
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
                controller: _portController,
              )),
            ],
          ),
        ),
        LimitedBox(
          maxHeight: 336,
          child: _getPortList(),
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

  void ScanPort() async {
    var ipStr = _ipController.text;
    var portStr = _portController.text;
    //print("IP:" + ipStr + " Port:" + portStr);
    try {
      //TODO:到时候要把这里转换为json，预备传一个PortBind类型转换来的json进去，然后再后端进行处理
      await platform
          .invokeMethod("portScan", {"domain": ipStr, "port": portStr});
    } on PlatformException {}

    //await platform.invokeMethod("showToast", {"msg": msg});
  }

  _getPortList() {
    if (_tileListFlag) {
      return ListView.builder(
        physics: new ClampingScrollPhysics(),
        itemCount: _tileList.list == null ? 0 : _tileList.list.length,
        itemBuilder: (BuildContext context, int position) {
          return _getPortTile(position);
        },
      );
    }
  }

  _getPortTile(int index) {
    return CheckboxListTile(
      value: _tileList.list[index].checked,
      onChanged: (value) {
        setState(() {
          _tileList.list[index].checked = value;
        });
      },
      title: Text(_tileList.list[index].port.toString()),
      subtitle: Text(_tileList.list[index].information),
    );
  }

  Future<String> _getTileJson() {
    return rootBundle.loadString("lib/assets/ports.json");
  }
}
