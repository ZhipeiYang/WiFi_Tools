import 'dart:convert' show json;

class DeviceList {
  List<Device> list;
  DeviceList.fromParams({this.list});

  factory DeviceList(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new DeviceList.fromJson(json.decode(jsonStr))
          : new DeviceList.fromJson(jsonStr);

  DeviceList.fromJson(jsonRes) {
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
      list.add(new Device.fromJson(item));
    }
  }

  @override
  String toString() {
    return '{"json_list": $list}';
  }
}

class Device {
  String ip;
  String name;

  Device.fromParams({this.ip, this.name});

  Device.fromJson(jsonRes) {
    ip = jsonRes['ip'];
    name = jsonRes['name'];
  }

  @override
  String toString() {
    return '{"ip": ${ip != null ? '${json.encode(ip)}' : 'null'},"name": ${name != null ? '${json.encode(name)}' : 'null'}}';
  }

  getName() {
    return name;
  }

  getIp() {
    return ip;
  }
}
