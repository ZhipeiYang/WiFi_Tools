import 'dart:convert' show json;

class TileList {

  List<PortTile> list;

  TileList.fromParams({this.list});

  factory TileList(jsonStr) => jsonStr == null ? null : jsonStr is String ? new TileList.fromJson(json.decode(jsonStr)) : new TileList.fromJson(jsonStr);
  
  TileList.fromJson(jsonRes) {
    // list = jsonRes == null ? null : [];

    // for (var listItem in list == null ? [] : jsonRes['list']){
    //         list.add(listItem == null ? null : new PortTile.fromJson(listItem));
    // }
    if (jsonRes == null)
      print("Json数据为空");
    else
      //print(jsonRes[0]);
      //初始化列表
      list = jsonRes == null ? null : [];
    for (var item in jsonRes) {
      if (item == null) break;
      //Device device=Device.fromJson(item);
      //print('name:'+device.getName());
      list.add(new PortTile.fromJson(item));
    }
  }

  @override
  String toString() {
    return '{"json_list": $list}';
  }
}

class PortTile {

  int port;
  bool checked;
  String information;

  PortTile.fromParams({this.port, this.checked, this.information});
  
  PortTile.fromJson(jsonRes) {
    port = jsonRes['port'];
    checked = jsonRes['checked'];
    information = jsonRes['information'];
  }

  @override
  String toString() {
    return '{"port": $port,"checked": $checked,"information": ${information != null?'${json.encode(information)}':'null'}}';
  }
}

