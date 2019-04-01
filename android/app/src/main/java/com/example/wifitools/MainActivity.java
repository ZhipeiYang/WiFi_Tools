package com.example.wifitools;

import android.os.Bundle;

import java.util.List;
import android.text.TextUtils;
import android.widget.Toast;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

//import ScanDeviceUtile;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.kiko.wifi/act";
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(),CHANNEL).setMethodCallHandler(
        (call,result)->{
            if(call.method.equals("getList")){
                List<String> list=getList();;
                if(list!=null){
                    result.success(list);
                }else{
                    result.error("UNAVAILABLE", "IpListIsNull", null);
                }
            }else if (call.method.equals("showToast")) {
              if (call.hasArgument("msg") && !TextUtils.isEmpty(call.argument("msg").toString())) {
                  Toast.makeText(MainActivity.this, call.argument("msg").toString(), Toast.LENGTH_SHORT).show();
              } else {
                  Toast.makeText(MainActivity.this, "toast text must not null", Toast.LENGTH_SHORT).show();
              }
          }
        });
  }
  List<String> getList(){
    ScanDeviceUtile s=new ScanDeviceUtile();
    return  s.scan();
  }
}
