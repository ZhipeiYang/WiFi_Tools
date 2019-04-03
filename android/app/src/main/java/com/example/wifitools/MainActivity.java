package com.example.wifitools;

import android.os.Bundle;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import java.util.List;
import android.text.TextUtils;
import android.widget.Toast;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import org.json.*;
public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.kiko.wifi/act";
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(),CHANNEL).setMethodCallHandler(
        (call,result)->{
              if(call.method.equals("getDevices")){
                String devices=getDevices();
                //System.out.println("Json数据:"+devices);

                if(devices.length()!=0){
                  result.success(devices);
                }else{
                  result.error("UNVAILABLE","Devices JSon is Empty",null);
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

  String getDevices()
  {
    ScanDeviceUtile s=new ScanDeviceUtile();
    Gson gson=new Gson();
    String result;
    result = gson.toJson(s.scan());
    return result;
  }
}
