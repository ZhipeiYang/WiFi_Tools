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
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.kiko.wifi/act";
  private static final String EVENT_CHANEL = "com.kiko.wifi/speed_event";

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
      }
    });
    new EventChannel(getFlutterView(), EVENT_CHANEL).setStreamHandler(new EventChannel.StreamHandler() {
      // 创建一个广播接收者
      SpeedTestController s=new SpeedTestController(getApplicationContext());
      private BroadcastReceiver netSpeedReceiver;
      // 监听事件
      @Override
      public void onListen(Object arguments, EventChannel.EventSink events) {
        // 设置接收到广播的处理流程并生成接收者
        netSpeedReceiver = createNetSpeedReceiver(events);
        // 添加广播过滤器
        IntentFilter intentFilter = new IntentFilter();
        // 设置广播的名字（设置Action，可以添加多个要监听的动作）
        intentFilter.addAction("speedBroadcast");
        // 注册广播,传入两个参数， 实例化的广播接受者对象，intent 动作筛选对象
        registerReceiver(netSpeedReceiver, intentFilter);
      }

      @Override
      public void onCancel(Object arguments) {
        unregisterReceiver(netSpeedReceiver);
        netSpeedReceiver = null;
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

    //SpeedTestController c = new SpeedTestController();
    return result;
  }

  private BroadcastReceiver createNetSpeedReceiver(final EventChannel.EventSink events) {
    return new BroadcastReceiver() {
      @Override
      // 重写接受事件
      public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals("speedBroadcast")) {
          // 接收到广播，取出里面携带的数据
          String str = intent.getStringExtra("data");
          events.success(str);
          //System.out.println("接收到的广播的数据：" + str);
        }
      }
    };
  }
}
