import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifitools/Class/device_list.dart';
import 'package:wifitools/Tips/loading.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = const MethodChannel("com.kiko.wifi/act");
  DeviceList _deviceList; //获取到的设备列表就要放在这里
  var listFlag = 0; //列表是否已经初始化的标志
  //通过平台代码获取设备详细信息列表
  Future<bool> getDevices() async {
    String devices;
    DeviceList deviceList;
    try {
      //showToast("正在扫描，请稍后");
      devices = await platform.invokeMethod('getDevices');
      deviceList = DeviceList(devices);
      _deviceList = deviceList;
      if (_deviceList != null) {
        showToast('扫描成功,共有' + _deviceList.list.length.toString() + '个设备');
        // setState(() {
        //   listFlag = 1;
        // });
        return true;
      } else {
        // setState(() {
        //   listFlag = 0;
        // });
        showToast("获取列表出错,请检查Wifi网络");
        return false;
      }
    } on PlatformException {
      //print("获取设备列表出错:" + e.toString());
      showToast("获取列表出错，请检查Wifi网络");
      // setState(() {
      //  listFlag=0;
      // });
      return false;
    }
  }

  //通过平台代码弹出Toast提示信息
  Future showToast(String msg) async {
    try {
      await platform.invokeMethod("showToast", {"msg": msg});
    } on PlatformException catch (e) {
      print("Toast出错:" + e.toString());
      return false;
    }
    return true;
  }

  // @override
  // void initState() {
  //   //Scaffold.of(context).showSnackBar(SnackBar(content: Text('请稍候'),));
  //   platform.invokeMethod("getDevices").then((onValue) {
  //     DeviceList deviceList = DeviceList(onValue);
  //     setState(() {
  //       _deviceList = deviceList;
  //       if (deviceList != null) {
  //         listFlag = 1;
  //       }
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("IP扫描"),
      ),
      body: Center(
        child: _getListView(),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
        onPressed: () {
          //Scaffold.of(context).showSnackBar(SnackBar(content: Text('正在刷新，请稍候'),));
          getDevices().then((value) {
            if (value) {
              setState(() {
                listFlag = 1;
              });
            } else {
              setState(() {
                listFlag = 0;
              });
            }
          });
        },
      ),
    );
  }

  //动态构建ListView用以展示搜索到的设备IP
  _getListView() {
    if (listFlag == 0) {
      return Text('请点击刷新按钮开始扫描');
    } else if (listFlag == 1) {
      return ListView.builder(
        itemCount: _deviceList.list == null ? 0 : _deviceList.list.length,
        itemBuilder: (BuildContext context, int position) {
          return _getItem(_deviceList.list[position]);
        },
      );
    } else if (listFlag == -1) {
      return LoadingWidget();
    }
  }

  //使用后台传送过来的列表构建IP列表项
  Widget _getItem(Device d) {
    //print(s);
    return GestureDetector(
        onTap: () {
          //showToast('你点击了' + d.getName());
          platform.invokeMethod('getMac', {"ip": d.getIp()}).then((value) {
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('设备信息',style: TextStyle(color: Colors.blue),),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('设备名:\n' + d.getName()),
                        Text('\nIP:\n' + d.getIp()),
                        Text('\nMAC:\n' + value)
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('复制'),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text: '设备名: ' +
                                d.getName() +
                                '\nIP: ' +
                                d.getIp() +
                                '\nMAC: ' +
                                value));
                        showToast('复制成功');
                      },
                    ),
                    FlatButton(
                      child: Text('确定'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            ).then((val) {
              print(val);
            });
          });
        },
        child: Card(
          child: ListTile(
            title: Text(d.getName()),
            subtitle: Text(d.getIp()),
            leading: Icon(Icons.devices),
          ),
        ));
  }
}
