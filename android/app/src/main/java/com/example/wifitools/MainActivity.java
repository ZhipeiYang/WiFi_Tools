package com.example.wifitools;

import android.os.Bundle;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.json.*;

import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
// import javax.swing.SpinnerDateModel;

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
  private SpeedTestController s;

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
      } else if (call.method.equals("switchBroadcast")) {
        // 传入的cmd为开启广播时，打开广播
        if (call.hasArgument("cmd") && call.argument("cmd").toString().equals("true")) {
          s = new SpeedTestController(getApplicationContext());
          s.fetchTotalTraffic();
        } else {// 否则关闭广播
          s.cancelBroadcast();
        }
      } else if (call.method.equals("portScan")) {
        // TODO:这里将域名和端口传入，进行测通，暂时让结果在后台输出，调试完成后再加参数传递到前端
        if (call.hasArgument("domain") && !TextUtils.isEmpty(call.argument("domain").toString())
            && call.hasArgument("port")) {
          String domain = call.argument("domain").toString();
          int port = Integer.parseInt(call.argument("port").toString());
          System.out.println(domain + "  " + port);
          try {
            PortScanUtile portScan = new PortScanUtile();
            portScan.connect(domain, port);
            Timer timer = new Timer();// 实例化Timer类
            timer.schedule(new TimerTask() {
              public void run() {
                if (portScan.getFlag() == true) {
                  System.out.println("可以通");
                } else {
                  System.out.println("通不了");
                }
                this.cancel();
              }
            }, 100);// 五百毫秒

          } catch (Exception e) {

          }

        }
      }
    });
    new EventChannel(getFlutterView(), EVENT_CHANEL).setStreamHandler(new EventChannel.StreamHandler() {
      // 创建一个广播接收者
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

  // String getNetSpeed() {
  // NetSpeed n = new NetSpeed("1.0", "2.0");
  // Gson gson = new Gson();
  // String result = gson.toJson(n);
  // // System.out.println(result);

  // //SpeedTestController c = new SpeedTestController();
  // return result;
  // }

  private BroadcastReceiver createNetSpeedReceiver(final EventChannel.EventSink events) {
    return new BroadcastReceiver() {
      @Override
      // 重写接受事件
      public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals("speedBroadcast")) {
          // 接收到广播，取出里面携带的数据
          String str = intent.getStringExtra("data");
          events.success(str);
          // System.out.println("接收到的广播的数据：" + str);
        }
      }
    };
  }
}
