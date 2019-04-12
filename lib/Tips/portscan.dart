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
        // FractionallySizedBox(
        //   heightFactor: 0.2,
        //   child: _getPortList(),
        // ),
        LimitedBox(
          maxHeight: 290.0,
          child: _getPortList(),
        ),
        RaisedButton(
          color: Colors.blue,
          textColor: Colors.white,
          splashColor: Colors.lightBlue,
          child: Text('开始扫描'),
          onPressed: () {
            var ipStr = _ipController.text;
            var portStr = _portController.text;
            setState(() {
              _portBind = PortBind.init();
            });
            //IP文本框不为空时填充对象IP地址
            if (ipStr != null && ipStr != "") {
              setState(() {
                _portBind.setIp(ipStr);
              });
            }
            //填充端口
            var checkedPorts = _tileList.list;
            setState(() {
              for (var item in checkedPorts) {
                if (item.checked) {
                  _portBind.port.add(item.port);
                }
              }
              if (portStr != null && portStr != "") {
                if (!_portBind.port.contains(int.parse(portStr))) {
                  _portBind.port.add(int.parse(portStr));
                }
              }
            });
            bool portFlag = _portBind.port.length != 0;
            bool ipFlag = _portBind.ip != "";
            if (portFlag && ipFlag) {
              String s = _portBind.toString();
              ScanPortByJson(s);
            } else if (!portFlag && !ipFlag) {
              showToast("请填写IP地址并至少添加一个端口号");
            } else if (!portFlag && ipFlag) {
              showToast("请至少添加一个端口号");
            } else if (portFlag && !ipFlag) {
              showToast("请填写IP地址");
            }
          },
        ),
      ],
    ));
  }

  void ScanPortByJson(String json) async {
    try {
      List<int> success =
          await platform.invokeListMethod("portScan", {"json": json});
     
      String successPortStr = "已测通的端口:";
      if (success.length != 0) {
        for (var item in success) {
          //print("_success:"+item.toString());
          successPortStr += item.toString() + " ";
        }
      } else {
        successPortStr += "无";
      }
      //print(successPortStr);
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: Text(successPortStr),
      ));
    } on PlatformException {}
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

  //通过平台代码弹出Toast提示信息
  showToast(String msg) async {
    try {
      await platform.invokeMethod("showToast", {"msg": msg});
    } on PlatformException catch (e) {
      print("Toast出错:" + e.toString());
    }
  }
}
