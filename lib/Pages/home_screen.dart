import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    static const platform = const MethodChannel("com.kiko.wifi/act");
  List<String> _msg;
  getMsg() async {
     List<String> msg;
    try {
      msg=await platform.invokeListMethod('getList');
    } on PlatformException catch (e) {
      print(e.toString());
    }
    setState(() {
      _msg=msg;
      if(_msg==null){
        showToast('扫描失败，请检查Wifi网络');
      }else{
        showToast('firstIp:'+_msg[0]);
      }
    });
  }
  showToast(String msg) async {
    try {
      await platform.invokeMethod("showToast",{"msg":msg});
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text("IP扫描"),
        ),
      body:  Center(
            child: Column(
              children: <Widget>[
                
            ],
            ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
        onPressed: () {
          getMsg();
          
         
        },
      ),
    );
  }
}

