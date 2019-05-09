import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifitools/Tips/netspeed.dart';
import 'package:wifitools/Tips/portscan.dart';
import 'package:wifitools/Class/net_speed.dart';
class SpeedTestScreen extends StatefulWidget {
  @override
  _SpeedTestScreenState createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  static const MethodChannel platform = const MethodChannel('com.kiko.wifi/act');
  static const EventChannel eventChannel = const EventChannel('com.kiko.wifi/speed_event');
  String speedJson;//从广播传来的实时网速信息json字符串
  //int listFlag = 0;
  bool broadcastFlag=false;//广播是否开启状态
  NetSpeed _netSpeedShow=new NetSpeed({"down":"0","up":"0"});//和展示UI绑定的网速展示类型
  //List<NetSpeed> _netSpeed = new List<NetSpeed>(); //测速结果
  //初始化
  @override
  void initState() {
    super.initState();
    //初始化eventHandler，开启监听
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);
    broadcastFlag=true;
    switchBroadcast(true);
  }
  @override
  void dispose(){
    //如果页面被销毁前广播时开的，那么关闭广播，否则不作任何响应
    try{
      if(broadcastFlag==true){
        platform.invokeMethod('switchBroadcast',{"cmd":"false"});
        //print("提示:因页面退出测速广播被关闭");
      }
      // }else{
      //   print("提示：广播本来就是关的，页面退出不作响应");
      // }
      
    }on PlatformException{

    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var netSpeedWidget = NetSpeedWidget(_netSpeedShow.up,_netSpeedShow.down);
    return Scaffold(
      appBar: AppBar(
        title: Text('测速'),
      ),
      body: ListView(
        children: <Widget>[
          GestureDetector(
            //点击时反应
            onTap: () {
              //getNetSpeed();

              //测速广播开关
              setState(() {
               broadcastFlag=!broadcastFlag; 
              });
              switchBroadcast(broadcastFlag);
            },
            child: Card(
              child: netSpeedWidget,
            ),
          ),
          //这里获取结果表
          PortScanWidget()
          //_getListView(),
        ],
      ),
    );
  }
  //广播接收到的东西正确时的处理流程
  void _onEvent(Object event) {
    setState(() {
      speedJson = event;
      _netSpeedShow=new NetSpeed(speedJson);
    });
  }
  //广播接收到错误时的处理流程
  void _onError(Object error) {
    setState(() {
      speedJson = "网络状态获取失败";
    });
  }
  //根据开关的状态开启或关闭测速广播
  void switchBroadcast(bool flag) async{
    try{
      await platform.invokeMethod('switchBroadcast',{"cmd":flag==true?"true":"false"});
    }on PlatformException{
      //print("错误:开启广播出错");
      setState(() {
       broadcastFlag=false; 
      });
    }
  }
  //根据测速结果动态生成展示列表
//   _getListView() {
//     if (listFlag == 0) {
//       return Text('当前列表为空，请刷新');
//     } else if (listFlag == 1) {
//       return ListView.builder(
//         itemCount: _netSpeed == null ? 0 : _netSpeed.length,
//         itemBuilder: (BuildContext context, int position) {
//           return _getListTile(_netSpeed[position].up, _netSpeed[position].down);
//         },
//       );
//     } else if (listFlag == -1) {
//       return LoadingWidget();
//     }
//   }
//   //生成上述表的每一项
//   _getListTile(String up, String down) {
//     return Card(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Container(
//             margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
//             child: Row(
//               children: <Widget>[
//                 CircleAvatar(
//                   backgroundColor: Colors.red,
//                   foregroundColor: Colors.white,
//                   radius: 10,
//                   child: Icon(
//                     Icons.arrow_upward,
//                     size: 16,
//                   ),
//                 ),
//                 Text(" 上传:"),
//                 Text(up),
//                 Text("bps"),
//               ],
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
//             child: Row(
//               children: <Widget>[
//                 CircleAvatar(
//                   radius: 10,
//                   child: Icon(
//                     Icons.arrow_downward,
//                     size: 16,
//                   ),
//                 ),
//                 Text(" 下载:"),
//                 Text(down),
//                 Text("bps"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
}
