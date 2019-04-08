package com.example.wifitools;

import android.os.Bundle;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.json.*;

import java.util.List;
import android.text.TextUtils;
import android.widget.Toast;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.kiko.wifi/act";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    // getNetSpeed();
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler((call, result) -> {
      if (call.method.equals("getDevices")) {
        String devices = getDevices();
        // System.out.println("Json数据:"+devices);
        if (devices.length() != 0) {
          result.success(devices);
        } else {
          result.error("UNVAILABLE", "Devices JSon is Empty", null);
        }
      } else if (call.method.equals("showToast")) {
        if (call.hasArgument("msg") && !TextUtils.isEmpty(call.argument("msg").toString())) {
          Toast.makeText(MainActivity.this, call.argument("msg").toString(), Toast.LENGTH_SHORT).show();
        } else {
          Toast.makeText(MainActivity.this, "toast text must not null", Toast.LENGTH_SHORT).show();
        }
      } else if (call.method.equals("getNetSpeed")) {
        // 调用测速方法返回一个对象转换来的json字符串
        //TODO:后期将这些方法重写，换成Event通道，通过Event通道来更新前台ui
        String s = getNetSpeed();

        if (s.length() != 0) {
          result.success(s);
        } else {
          result.error("UNVAILABLE", "NetSpeed JSon is Empty", null);
        }
      }
    });
  }

  String getDevices() {
    ScanDeviceUtile s = new ScanDeviceUtile();
    Gson gson = new Gson();
    String result;
    result = gson.toJson(s.scan());
    return result;
  }

  String getNetSpeed() {
    NetSpeed n = new NetSpeed("1.0", "2.0");
    Gson gson = new Gson();
    String result = gson.toJson(n);
    // System.out.println(result);
    SpeedTestController c=new SpeedTestController();
    return result;
  }
}
