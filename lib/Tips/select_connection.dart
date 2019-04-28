import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:wifitools/Class/conn.dart';
import 'package:sqflite/sqflite.dart';
import 'update_connection.dart';
class SelectConn extends StatefulWidget {
  @override
  _SelectConnState createState() => _SelectConnState();
}

class _SelectConnState extends State<SelectConn> {
  List<Map> _connList;
  bool _connListFlag = false;
  List<ConnectInfo> _connInfoList;
  @override
  void initState() {
    initList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择'),
      ),
      body: Container(child: getListView()),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          initList();
        },
      ),
    );
  }

  initList() {
    String dataBasePath;
    String path;
    ConnectInfoUtil util = ConnectInfoUtil();
    setState(() {
      _connListFlag = false;
    });
    getDatabasesPath().then((value) {
      dataBasePath = value;
      path = join(dataBasePath, 'connInfo.db');
      util.open(path).then((value2) {
        util.getAll().then((onValue) {
          if (onValue != null) {
            setState(() {
              _connList = List<Map>();
              _connList = onValue;
              _connInfoList = List<ConnectInfo>();
              for (var item in _connList) {
                ConnectInfo conn = ConnectInfo.fromMap(item);
                _connInfoList.add(conn);
              }
              _connListFlag = true;
            });
          }
          //util.close();
        });
      });
    });
  }

  getListView() {
    if (_connListFlag) {
      return ListView.builder(
        physics: new ClampingScrollPhysics(),
        itemCount: _connInfoList.length,
        itemBuilder: (BuildContext context, int position) {
          return getItem(context,position);
        },
      );
    } else {
      return Center(
        child: Text('列表为空'),
      );
    }
  }

  getItem(BuildContext context,int position) {
    return Card(
      child: Row(children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _connInfoList[position].nick,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  _connInfoList[position].host+':'+_connInfoList[position].port.toString(),
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        PopupMenuButton<int>(
            onSelected: (int value) {
              //print(value);
              if (value == 0) {
                Navigator.pop(context,_connInfoList[position]);
              } else if (value == 1) {
                Navigator.push(context,MaterialPageRoute(
                  builder: (context)=>UpdateConnection(conn:_connInfoList[position]),
                )).then((value){
                  //print(value);
                  if(value!=null){
                    Scaffold.of(context).showSnackBar(SnackBar(content: Text("$value"),));
                  }
                                 
                });
              } else if (value == 2) {
                String dataBasePath;
                String path;
                ConnectInfoUtil util = ConnectInfoUtil();
                getDatabasesPath().then((value) {
                  dataBasePath = value;
                  path = join(dataBasePath, 'connInfo.db');
                  util.open(path).then((value2) {
                    util.delete(_connInfoList[position].uuid).then((onValue) {
                      if (onValue > 0) {
                        //print('delete success');
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('已删除!'),));
                        //initList();
                      }else{
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('删除失败!'),));
                        //initList();
                      }
                    });
                    //util.close();
                  });
                });
              }
              initList();
            },
            itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
                  PopupMenuItem<int>(
                      value: 0,
                      child: Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                              child: Icon(Icons.looks_one),),
                          Text('选择'),
                        ],
                  )),
                  PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                              child: Icon(Icons.looks_two)),
                          Text('修改'),
                        ],
                  )),
                  PopupMenuItem<int>(
                      value: 2,
                      child: Row(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                              child: Icon(Icons.delete)),
                          Text('删除'),
                        ],
                  )),
                ])
      ]),
    );
  }
}
