import 'dart:convert';

class NetSpeed {
  String down;
  String up;

  NetSpeed.fromParams({this.down, this.up});
  
  factory NetSpeed(jsonStr) => jsonStr == null
      ? null
      : jsonStr is String
          ? new NetSpeed.fromJson(json.decode(jsonStr))
          : new NetSpeed.fromJson(jsonStr);

  NetSpeed.fromJson(jsonRes) {
    //print("JsonTest"+jsonRes[0]);
    down = jsonRes['down'];
    up = jsonRes['up'];
  }

  @override
  String toString() {
    return '{"down": ${down != null ? '${json.encode(down)}' : 'null'},"up": ${up != null ? '${json.encode(up)}' : 'null'}}';
  }
}
