import 'package:flutter/material.dart';
import 'Pages/home_screen.dart';
import 'Pages/speedtest_screen.dart';
import 'Pages/tools_screen.dart';
import 'Pages/settings_screen.dart';


class BottomNavigationWidget extends StatefulWidget {
  final Widget child;

  BottomNavigationWidget({Key key, this.child}) : super(key: key);

  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final _BottomNavigationColor=Colors.blue;
  int _currentIndex=0;
  List<Widget> pageList=List();
  @override
  // 重写初始化状态方法，即页面List
  void initState(){
    pageList..add(HomeScreen())
            ..add(SpeedTestScreen())
            ..add(ToolScreen())
            ..add(SettingScreen());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items:[
          BottomNavigationBarItem(
            icon:Icon(
              Icons.home,
              color: _BottomNavigationColor,
            ),
            title: Text('主页',style: TextStyle(color: _BottomNavigationColor),)
          ),
           BottomNavigationBarItem(
            icon:Icon(
              Icons.wifi,
              color: _BottomNavigationColor,
            ),
            title: Text('测速',style: TextStyle(color: _BottomNavigationColor),)
          ),
           BottomNavigationBarItem(
            icon:Icon(
              Icons.airplay,
              color: _BottomNavigationColor,
            ),
            title: Text('工具',style: TextStyle(color: _BottomNavigationColor),)
          ),
          BottomNavigationBarItem(
            icon:Icon(
              Icons.settings,
              color: _BottomNavigationColor,
            ),
            title: Text('设置',style: TextStyle(color: _BottomNavigationColor),)
          ),
        ],
        //高亮的部分
        currentIndex: _currentIndex,
        //OnTap事件
        onTap: (int index){
          setState(() {
            _currentIndex=index;
          });
        },
      ),
    );
  }
}