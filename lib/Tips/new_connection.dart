import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:wifitools/Class/conn.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

class NewConnection extends StatefulWidget {
  _NewConnectionState createState() => _NewConnectionState();
}

class _NewConnectionState extends State<NewConnection> {
  TextEditingController _nickController = TextEditingController();
  TextEditingController _userController = TextEditingController();
  TextEditingController _hostController = TextEditingController();
  TextEditingController _portController = TextEditingController();
  TextEditingController _authController = TextEditingController();

  FocusNode _nickFocusNode = FocusNode();
  FocusNode _userFocusNode = FocusNode();
  FocusNode _hostFocusNode = FocusNode();
  FocusNode _portFocusNode = FocusNode();
  FocusNode _authFocusNode = FocusNode();

  ConnectInfo _connectInfo;
  int _authFlag = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('新建'),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: <Widget>[
              TextField(
                focusNode: _nickFocusNode,
                decoration: InputDecoration(labelText: '昵称:'),
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
                controller: _nickController,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_userFocusNode),
                onSubmitted: (value){},
              ),
              TextField(
                focusNode: _userFocusNode,
                decoration: InputDecoration(labelText: '用户名:'),
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
                controller: _userController,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_authFocusNode),
                    onSubmitted: (value){},
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
                focusNode: _authFocusNode,
                decoration: InputDecoration(labelText: '密钥:'),
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
                controller: _authController,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_hostFocusNode),
                    onSubmitted: (value){},
              ),
              TextField(
                focusNode: _hostFocusNode,
                decoration: InputDecoration(labelText: '地址:'),
                style: TextStyle(fontSize: 18.0, color: Colors.blue),
                controller: _hostController,
                onEditingComplete: () =>
                    FocusScope.of(context).requestFocus(_portFocusNode),
                    onSubmitted: (value){
                     // FocusScope.of(context).requestFocus(_portFocusNode);
                    },
              ),
              TextField(
                focusNode: _portFocusNode,
                  decoration: InputDecoration(labelText: '端口:'),
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  //inputFormatters:[],
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 18.0, color: Colors.blue),
                  controller: _portController,
                  onSubmitted: (n) {
                    if (_initConnectInfo()) {
                      // String databasePath = await getDatabasesPath();
                      getDatabasesPath().then((databasePath) {
                        String path = join(databasePath, 'connInfo.db');
                        ConnectInfoUtil util = ConnectInfoUtil();
                        util.open(path).then((value) {
                          util.insert(_connectInfo).then((onValue) {
                            if (onValue > 0) {
                              //print('插入成功');
                              // Scaffold.of(context).showSnackBar(new SnackBar(
                              //   content: Text('插入成功'),
                              // ));
                              //print('插入成功');
                              Navigator.pop(context, '插入成功!');
                            } else {
                              Navigator.pop(context, '插入失败!');
                            }
                          });
                          //util.close();
                        });
                      });
                    }
              }),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (_initConnectInfo()) {
                          String databasePath = await getDatabasesPath();
                          String path = join(databasePath, 'connInfo.db');
                          ConnectInfoUtil util = ConnectInfoUtil();
                          util.open(path).then((value) {
                            util.insert(_connectInfo).then((onValue) {
                              if (onValue > 0) {
                                //print('插入成功');
                                // Scaffold.of(context).showSnackBar(new SnackBar(
                                //   content: Text('插入成功'),
                                // ));
                                //print('插入成功');
                                Navigator.pop(context, '插入成功!');
                              } else {
                                Navigator.pop(context, '插入失败!');
                              }
                            });
                            //util.close();
                          });
                        }
                      },
                      child: Text('插入'),
                    ),
                  )),
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: RaisedButton(
                          color: Colors.red,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context, '已取消!');
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
    connectInfo.uuid = Uuid().v4().toString();
    connectInfo.nick = _nickController.text != ""
        ? _nickController.text
        : _hostController.text + ":" + _portController.text;
    connectInfo.user = _userController.text;
    connectInfo.auth = _authFlag;
    connectInfo.key = _authController.text;
    connectInfo.host = _hostController.text;
    connectInfo.port = int.parse(_portController.text);
    if (connectInfo.check()) {
      setState(() {
        _connectInfo = connectInfo;
      });
      return true;
    }
    return false;
  }
}
