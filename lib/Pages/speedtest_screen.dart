import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifitools/Tips/netspeed.dart';
import 'package:wifitools/Tips/loading.dart';
import 'package:wifitools/Class/net_speed.dart';

class SpeedTestScreen extends StatefulWidget {
  @override
  _SpeedTestScreenState createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  static const platform = const MethodChannel('com.kiko.wifi/act');
  String _up = "--";
  String _down = "--";
  int listFlag = 0;
  List<NetSpeed> _netSpeed = new List<NetSpeed>(); //测速结果
  //调用平台代码获取当前网速
  getNetSpeed() async {
    String speedJson;
    try {
      //通过平台代码获取后端生成的网速信息Json
      speedJson = await platform.invokeMethod('getNetSpeed');
      //用得到的Json字符串直接初始化speed对象
      var speed = NetSpeed(speedJson);
      //print('对象:' + speed.up + speed.down);
      setState(() {
        _up = speed.up;
        _down = speed.down;
        _netSpeed.add(speed);
        if (_netSpeed != null) {
          listFlag = 1;
          //print(_netSpeed[0].down);
        }
      });
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    var netSpeedWidget = NetSpeedWidget(_up, _down);
    return Scaffold(
      appBar: AppBar(
        title: Text('测速'),
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
            //点击时反应
            onTap: () {
              getNetSpeed();
            },
            child: Card(
              child: netSpeedWidget,
            ),
          ),
          //这里获取结果表
          Expanded(
            child: _getListView(),
          )
          //_getListView(),
        ],
      ),
    );
  }

  //根据测速结果动态生成展示列表
  _getListView() {
    if (listFlag == 0) {
      return Text('当前列表为空，请刷新');
    } else if (listFlag == 1) {
      return ListView.builder(
        itemCount: _netSpeed == null ? 0 : _netSpeed.length,
        itemBuilder: (BuildContext context, int position) {
          return _getListTile(_netSpeed[position].up, _netSpeed[position].down);
        },
      );
    } else if (listFlag == -1) {
      return LoadingWidget();
    }
  }

  _getListTile(String up, String down) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  radius: 10,
                  child: Icon(
                    Icons.arrow_upward,
                    size: 16,
                  ),
                ),
                Text(" 上传:"),
                Text(up),
                Text("bps"),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 10,
                  child: Icon(
                    Icons.arrow_downward,
                    size: 16,
                  ),
                ),
                Text(" 下载:"),
                Text(down),
                Text("bps"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
