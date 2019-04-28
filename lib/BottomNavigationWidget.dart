import 'package:flutter/material.dart';
import 'Pages/home_screen.dart';
import 'Pages/speedtest_screen.dart';
import 'Pages/settings_screen.dart';
import 'Pages/toolspage.dart';

class BottomNavigationWidget extends StatefulWidget {
  final Widget child;

  BottomNavigationWidget({Key key, this.child}) : super(key: key);

  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  final _bottom_navigation_color=Colors.blue;
  int _currentIndex=0;
  List<Widget> pageList=List();
  @override
  // 重写初始化状态方法，即页面List
  void initState(){
    pageList..add(HomeScreen())
            ..add(SpeedTestScreen())
            ..add(ToolsPage())
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
              color: _bottom_navigation_color,
            ),
            title: Text('主页',style: TextStyle(color: _bottom_navigation_color),)
          ),
           BottomNavigationBarItem(
            icon:Icon(
              Icons.wifi,
              color: _bottom_navigation_color,
            ),
            title: Text('测速',style: TextStyle(color: _bottom_navigation_color),)
          ),
           BottomNavigationBarItem(
            icon:Icon(
              Icons.airplay,
              color: _bottom_navigation_color,
            ),
            title: Text('工具',style: TextStyle(color: _bottom_navigation_color),)
          ),
          BottomNavigationBarItem(
            icon:Icon(
              Icons.info_outline,
              color: _bottom_navigation_color,
            ),
            title: Text('关于',style: TextStyle(color: _bottom_navigation_color),)
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