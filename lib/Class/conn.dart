import 'package:sqflite/sqflite.dart';


final String columnId = "uuid";
final String columnNick = "nick";
final String columnUser = "user";
final String columnAuth = "auth";
final String columnKey = "key";
final String columnHost = "host";
final String columnPort = "port";
final String tableConInfo="conInfo";
class ConnectInfo {
  String uuid;
  String nick;
  String user;
  int auth=-1;
  String key;
  String host;
  int port=-1;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: uuid,
      columnNick: nick,
      columnUser: user,
      columnAuth: auth,
      columnKey: key,
      columnHost: host,
      columnPort: port
    };
    return map;
  }

  ConnectInfo();
  ConnectInfo.fromMap(Map<String, dynamic> map) {
    uuid = map[columnId];
    nick = map[columnNick];
    user = map[columnUser];
    auth = map[columnAuth];
    key = map[columnKey];
    host = map[columnHost];
    port = map[columnPort];
  }
  bool check(){
    if(uuid!=""&&nick!=""&&user!=""&&auth!=-1&&key!=""&&host!=""&&port!=-1){
      return true;
    }
    return false;
  }
  void printUtil(){
    print(uuid+' '+nick+' '+user+' '+auth.toString()+' '+key+' '+host+ ' '+port.toString());
  }
}

class ConnectInfoUtil{
  Database db;

  //打开或创建数据库
  Future open(String path) async{
    db=await openDatabase(path,version:1,onCreate: (Database db,int version)async{
      await db.execute('''
      create table $tableConInfo(
        $columnId text primary key,
        $columnNick text not null,
        $columnUser text not null,
        $columnAuth integer not null,
        $columnKey text not null,
        $columnHost text not null,
        $columnPort integer not null
      )
      ''');
    });
    //if(db!=null){print('db不为空');}else{print('db空了');}
  }
  //插入
  Future<int> insert(ConnectInfo conn)async{
    //print('开始插入');
    return await db.insert(tableConInfo, conn.toMap());
  }
  //查询
  Future<List<Map>> getAll() async{
    List<Map> maps= await db.query(tableConInfo);
    if(maps.length>0){
      return maps;
    }else{
      return null;
    }
  }
  //删除
  Future<int> delete(String uuid)async{
    return await db.delete(tableConInfo,where: '$columnId =?',whereArgs: [uuid]);
  }
  //更新
  Future<int> update(ConnectInfo conn)async{
    return await db.update(tableConInfo, conn.toMap(),where: '$columnId=?',whereArgs: [conn.uuid]);
  }
  //关闭
  Future close()=>db.close();
}
