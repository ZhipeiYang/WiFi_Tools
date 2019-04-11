import 'dart:convert' show json;

class PortBind {

  //ip地址
  String ip;
  //for-each循环可以遍历端口并进行处理
  List<int> port;

  PortBind.fromParams({this.ip, this.port});

  factory PortBind(jsonStr) => jsonStr == null ? null : jsonStr is String ? new PortBind.fromJson(json.decode(jsonStr)) : new PortBind.fromJson(jsonStr);
  
  PortBind.fromJson(jsonRes) {
    ip = jsonRes['ip'];
    port = jsonRes['port'] == null ? null : [];

    for (var portItem in port == null ? [] : jsonRes['port']){
            port.add(portItem);
    }
  }

  @override
  String toString() {
    return '{"ip": ${ip != null?'${json.encode(ip)}':'null'},"port": $port}';
  }
}

