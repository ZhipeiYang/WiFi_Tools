import 'package:flutter/material.dart';
import 'package:wifitools/Tips/new_connection.dart';
import 'package:wifitools/Tips/select_connection.dart';
import 'package:wifitools/Class/conn.dart';
class ToolsPage extends StatefulWidget {
  _ToolsPageState createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  ConnectInfo _connectInfo;
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
                        if(value!=null){
                          Scaffold.of(context).showSnackBar(SnackBar(content: Text("$value"),));
                        }                        
                        //print(value);
                      });
                    } else if (value == '1') {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => SelectConn()),
                      ).then((value){
                       if(value!=null){
                          setState(() {
                         _connectInfo=value;
                         _connectInfo.printUtil(); 
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
      body:Container()
    );
  }
}
