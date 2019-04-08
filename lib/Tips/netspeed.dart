import 'package:flutter/material.dart';

class NetSpeedWidget extends StatelessWidget {
  NetSpeedWidget(this.up, this.down) : super();
  final String up, down;
  @override
  Widget build(BuildContext context) {
    var _textStyle = TextStyle(fontSize: 36);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 20, top: 20, bottom: 20),
          child: Column(
            children: <Widget>[
              Row(
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
                  Text(
                    " 上传 ",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "bps",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  )
                ],
              ),
              Text(
                up,
                style: _textStyle,
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, top: 20, bottom: 20),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 10,
                    child: Icon(
                      Icons.arrow_downward,
                      size: 16,
                    ),
                  ),
                  Text(
                    " 下载 ",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "bps",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  )
                ],
              ),
              Text(
                down,
                style: _textStyle,
              ),
            ],
          ),
        )
      ],
    );
  }
}
