import 'package:flutter/material.dart';
import 'package:wifitools/Tips/new_connection.dart';
import 'package:wifitools/Tips/select_connection.dart';
import 'package:wifitools/Class/conn.dart';
import 'package:ssh/ssh.dart';
import 'package:flutter/services.dart';


class ToolsPage extends StatefulWidget {
  _ToolsPageState createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  ConnectInfo _connectInfo;
  SSHClient _client;
  TextEditingController _terminalController = TextEditingController();
  TextEditingController _inputController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool _shellFlag=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('工具'),
          actions: <Widget>[
            Builder(
              builder: (BuildContext context) {
                return PopupMenuButton<String>(
                    onSelected: (String value) {
                      if (value == '0') {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => NewConnection()),
                        ).then((value) {
                          if (value != null) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("$value"),
                            ));
                          }
                          //print(value);
                        });
                      } else if (value == '1') {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => SelectConn()),
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              _connectInfo = value;
                              _connectInfo.printUtil();
                              _client = SSHClient(
                                  host: _connectInfo.host,
                                  port: _connectInfo.port,
                                  username: _connectInfo.user,
                                  passwordOrKey: _connectInfo.key);
                            });
                          }
                        });
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuItem<String>>[
                          PopupMenuItem<String>(value: '0', child: Text('新建')),
                          PopupMenuItem<String>(value: '1', child: Text('选择'))
                        ]);
              },
            )
          ],
        ),
        body: new Column(children: <Widget>[
          getCard(context),
          Flexible(
              child: TextField(
            maxLines: 13,
            // enabled: false,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 0)
              )
            ),
            controller: _terminalController,
          )),
          //Divider(height: 1.0),
          TextField(
            focusNode: _focusNode,
            onSubmitted: (value) async {
              //submit(value);
              
              if(_shellFlag==true){
                print(await _client.writeToShell(_inputController.text+'\n'));
              }
              _inputController.clear();
            },
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_focusNode),
            controller: _inputController,
          )
        ]));
  }

  submit(String s) {
    _inputController.clear();
    _terminalController.text += s + '\n';
  }

  getCard(BuildContext context) {
    if (_connectInfo != null) {
      return Card(
          child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Icon(Icons.airplay),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _connectInfo.host + ':' + _connectInfo.port.toString(),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  _connectInfo.user,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: RaisedButton(
              color: _shellFlag==false?Colors.blue:Colors.red,
              textColor: Colors.white,
              child: Text(_shellFlag==false?'连接':'断开'),
              onPressed: () async {
                if(_shellFlag==false){
                  try {
                  String result = await _client.connect();
                  if (result == "session_connected") {
                    result = await _client.startShell(
                       // ptyType: "ansi",
                        callback: (dynamic res) {
                          _terminalController.text += res;
                          print(res+'\n');
                        });

                    if (result == "shell_started") {
                      setState(() {
                       _shellFlag=true; 
                       _terminalController.clear();
                      });
                    }
                  }
                } on PlatformException catch (e) {
                  submit('Error: ${e.code}\nError Message: ${e.message}\n');
                }
                }else{
                  _client.closeShell();
                  _terminalController.clear();
                  _terminalController.text='连接断开';
                  setState(() {
                   _shellFlag=false; 
                  });
                }
              },
            ),
          )
        ],
      ));
    } else {
      return Card(
        child: Text('请先选择或创建用户'),
      );
    }
  }
}
