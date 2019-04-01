import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifitools/turn_box.dart';
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = const MethodChannel("com.kiko.wifi/act");
  List<String> _msg;
  double _turns=.0;
  //通过平台代码获取当前局域网下设备的IP列表
  getMsg() async {
    // setState(() {
    //   _turns+=1.0; 
    // });
    List<String> msg;
    try {
      msg=await platform.invokeListMethod('getList');
    } on PlatformException catch (e) {
      print("获取IP列表出错:"+e.toString());
    }
    setState(() {
      _msg=msg;
    });
    //获取成功后通过平台代码显示Toast来显示获取结果
    if(_msg==null){
        showToast('扫描失败，请检查Wifi网络');
    }else{
        showToast('获取成功,共有'+_msg.length.toString()+'个设备');
    }
  }
  //通过平台代码弹出Toast提示信息
  showToast(String msg) async {
    try {
      await platform.invokeMethod("showToast",{"msg":msg});
    } on PlatformException catch (e) {
      print("Toast出错:"+e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text("IP扫描"),
        ),
      body:  Center(
            child: _getListView(),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Refresh',
        child: TurnBox(
          turns: _turns,
            speed: 800,
            child: Icon(Icons.refresh,
          ),
        ),
        onPressed: () {
          setState(() {
           _turns+=1.0; 
          });
          getMsg();
             
        },
      ),
    );
  }

  //动态构建ListView用以展示搜索到的设备IP
  Widget _getListView()
  {
      return ListView.builder(
        itemCount: _msg==null?0:_msg.length,
        itemBuilder: (BuildContext context,int position){
          return _getItem(_msg[position]);
        },
      );  
  }
  //使用后台传送过来的列表构建IP列表项
  Widget _getItem(String s){
    //print(s);
    return GestureDetector(
      onTap: (){
        showToast('你点击了'+s);
      },
      child:  ListTile(
        title: Text(s),
        leading: Icon(Icons.devices),
    ),
    );
  }
  
}
