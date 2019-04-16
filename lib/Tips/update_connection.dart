import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:wifitools/Class/conn.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
class UpdateConnection extends StatefulWidget {
  ConnectInfo conn;
  UpdateConnection({this.conn}):super();
  @override
  _UpdateConnectionState createState() => _UpdateConnectionState(conn);
}

class _UpdateConnectionState extends State<UpdateConnection> {

  TextEditingController _nickController = TextEditingController();
  TextEditingController _userController = TextEditingController();
  TextEditingController _hostController = TextEditingController();
  TextEditingController _portController = TextEditingController();
  TextEditingController _authController = TextEditingController();
  ConnectInfo _connectInfo;
  int _authFlag = 0;
  String _uuid;
  _UpdateConnectionState(ConnectInfo conn){
    // print('初始信息:');
    // conn.printUtil();
    if (conn != null) {
      _nickController.text = conn.nick;
      _userController.text = conn.user;
      _hostController.text = conn.host;
      _portController.text = conn.port.toString();
      _uuid=conn.uuid;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('更新'),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: '昵称:'),
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
                controller: _nickController,
              ),
              TextField(
                decoration: InputDecoration(labelText: '用户名:'),
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
                controller: _userController,
              ),
              Row(
                children: <Widget>[
                  Text("认证方式:"),
                  Radio(
                    value: 0,
                    groupValue: _authFlag,
                    onChanged: (value) {
                      setState(() {
                        _authFlag = value;
                        print('密码');
                      });
                    },
                  ),
                  Text('密码'),
                  Radio(
                    value: 1,
                    groupValue: _authFlag,
                    onChanged: (value) {
                      setState(() {
                        _authFlag = value;
                        print('私钥');
                      });
                    },
                  ),
                  Text('私钥'),
                ],
              ),
              TextField(
                decoration: InputDecoration(labelText: '密钥:'),
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
                controller: _authController,
              ),
              TextField(
                decoration: InputDecoration(labelText: '地址:'),
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
                controller: _hostController,
              ),
              TextField(
                decoration: InputDecoration(labelText: '端口:'),
                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
                controller: _portController,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (_initConnectInfo()) {
                          String databasePath = await getDatabasesPath();
                          String path = join(databasePath, 'connInfo.db');
                          ConnectInfoUtil util = ConnectInfoUtil();
                          util.open(path).then((value){
                            util.update(_connectInfo).then((onValue){
                              if(onValue>0){
                                //print('更新成功');
                                Navigator.pop(context,'更新成功!');
                              }else{
                                //print('更新失败');
                                Navigator.pop(context,'更新失败!');
                              }
                             
                            });
                          });                        
                        }
                      },
                      child: Text('更新'),
                    ),
                  )),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: RaisedButton(
                          color: Colors.red,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context,'已取消!');
                          },
                          child: Text('取消'),
                        )),
                  )
                ],
              )
            ],
          ),
        ));
  }
   bool _initConnectInfo() {
    ConnectInfo connectInfo = ConnectInfo();
    //生成一个uuid填充
    connectInfo.uuid = _uuid;
    connectInfo.nick = _nickController.text != ""
        ? _nickController.text
        : _hostController.text +":"+ _portController.text;
    connectInfo.user = _userController.text;
    connectInfo.auth = _authFlag;
    connectInfo.key = _authController.text;
    connectInfo.host = _hostController.text;
    connectInfo.port = int.parse(_portController.text);
    if (connectInfo.check()) {
      //connectInfo.printUtil();
      setState(() {
        _connectInfo = connectInfo;
      });

      return true;
    }
    return false;
  }
}
