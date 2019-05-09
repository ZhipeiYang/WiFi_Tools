import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
class SettingScreen extends StatelessWidget {
  var text='''
It took me way too long to learn this.
I realise I was just surrounded by toxic people,
of course their objective was to cut me down.
Jealousy is a poison.
Only after I removed myself from all that
and started healing
and slowly started getting actual support
did I start seeing that fact,
I was just fed so many lies by people to cut me down
so I wouldn't ever achieve anything.
I had such a low self concept
and yet it wasn't even real,
it was just based on judgments made by others.
The thing is,
if someone took the time to try to cut you down,
that means they recognised a lot of potential in you,
enough to be deemed a threat.
Take it from your enemies that you are a formidable opponent
and use that to propel you forward.
Surround yourself with good vibes
it will do wonders for your self esteem.
Come to terms with your past and grieve
for as long as necessary
so that you can move forward.
You can do stuff you'd never even dreamed of
and deep down, you know it.
  ''';
  @override
  Widget build(BuildContext context) {
    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            child:_buildButtonColumn(context, Icons.email, "Email"),
            onTap: (){
              const url = 'mailto:yzp@live.cn?subject=Feedback&body=none';
              canLaunch(url).then((onValue){
                if(onValue){
                  launch(url);
                }else{
                  print("不能跳转");
                }
              });
            },
          ),
           GestureDetector(
            child:_buildButtonColumn(context, Icons.web, "Github"),
            onTap: (){
              const url = 'https://github.com/ZhipeiYang';
              canLaunch(url).then((onValue){
                if(onValue){
                  launch(url);
                }else{
                  print("不能跳转");
                }
              });
            },
          ), GestureDetector(
            child: _buildButtonColumn(context, Icons.share, "Share"),
            onTap: (){
              Clipboard.setData(ClipboardData(text: '这里有一个有趣的灵魂和一个有灵魂的主页:\nhttps://github.com/ZhipeiYang'));
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('已复制到剪切板，您可以分享给您的朋友'),));
            },
          ),  
        ],
      ),
    );
    Widget textSection = Container(
      padding: EdgeInsets.all(32.0),
      child: Text(
        text,
        softWrap: true,

      ),
    );
    Widget titleSection =  Container(
      padding: EdgeInsets.all(32.0),
      child: Row(
        //3个child 水平排列
        children: <Widget>[
          //占满剩余空间
          Expanded(
            // 2 个child竖直排列
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Zhipei Yang",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "https://www.github.com/ZhipeiYang",
                  style: TextStyle(color: Colors.grey[500]),
                )
              ],
            ),
          ),

          Icon(
            Icons.star,
            color: Colors.red[500],
          ),

          Text("41"),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text("关于")),
      body: Center(
        child: ListView(
          children: <Widget>[
            Image.asset(
              "lib/assets/top.jpg",
              height: 240.0,
              fit: BoxFit.cover,
            ),
            titleSection,
            buttonSection,
            textSection,
          ],
        ),
      ),
    );
  }

   Column _buildButtonColumn(BuildContext context, IconData icon, String label) {
    Color color = Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      //列布局
      children: <Widget>[
        Icon(
          icon,
          color: color,
        ),
        Container(
          margin: EdgeInsets.only(top: 8.0),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        )
      ],
    );
  }
}
