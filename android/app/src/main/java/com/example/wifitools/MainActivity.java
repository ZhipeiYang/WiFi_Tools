package com.example.wifitools;

import android.os.Bundle;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.json.*;

import java.util.List;
import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;
import java.util.Locale;
import java.io.BufferedReader;
import java.io.FileReader;
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
        //根据收到的字符串构建一个toast在前端展示
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
        // 这里将域名和端口传入，进行测通，结果通过json传递到前端
        if(call.hasArgument("json")&&!TextUtils.isEmpty(call.argument("json"))){
          //获取json字符串成功
          // System.out.println(call.argument("json").toString());
          //转换成功
          PortBind portBind=getPortBind(call.argument("json").toString());
          // //传过来的IP地址
          // String ip=portBind.getIp();
          // //传过来的要测通的端口List
          // List<Integer> portList=portBind.getPort();
          //这里开始测通流程，采用多线程方法
          PortScanUtile portScan=new PortScanUtile();
          //要返回的端口List
          List<Integer> portSuccess=portScan.connectByList(portBind.getIp(),portBind.getPort());
          // for(int item:portSuccess){
          //   System.out.println(item);
          // }
           //返回给界面处理结果，交由界面处理展示
          result.success(portSuccess);  
        }
      }else if(call.method.equals("getMac")){
        if(call.hasArgument("ip")&&!TextUtils.isEmpty(call.argument("ip"))){
          String str=readArp(call.argument("ip").toString());
          result.success(str);
        }else{
          result.error("error","Input Error",null);
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
      //关闭广播的线程
      @Override
      public void onCancel(Object arguments) {
        unregisterReceiver(netSpeedReceiver);
        netSpeedReceiver = null;
      }
    });
  }
  //通过传过来的json字符串解析得到PortBind类型的对象
  PortBind getPortBind(String json){
    Gson gson=new Gson();
    return gson.fromJson(json,PortBind.class);
  }
  //扫描局域网内所有设备信息
  String getDevices() {
    ScanDeviceUtile s = new ScanDeviceUtile();
    Gson gson = new Gson();
    String result;
    result = gson.toJson(s.scan());
    //readArp();
    return result;
  }

  //负责接收网速检测线程传输过来的广播然后返回给前台
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
  private String readArp(String myIp) {
    String myMac="";
    try {
        BufferedReader br = new BufferedReader(
                new FileReader("/proc/net/arp"));
        String line = "";
        String ip = "";
        String flag = "";
        String mac = "";
        
        while ((line = br.readLine()) != null) {
            try {
                line = line.trim();
                if (line.length() < 63) continue;
                if (line.toUpperCase(Locale.US).contains("IP")) continue;
                ip = line.substring(0, 17).trim();
                
                flag = line.substring(29, 32).trim();
                mac = line.substring(41, 63).trim();
                if (mac.contains("00:00:00:00:00:00")) continue;
                //Log.e("scanner", "readArp: mac= "+mac+" ; ip= "+ip+" ;flag= "+flag);
                //System.out.println("ip:"+ip+" mac:"+mac);
                if(ip.equals(myIp)){
                  myMac=mac;
                }
            } catch (Exception e) {
            }
        }
        br.close();    
    } catch(Exception e) {
    }
    if(!myMac.equals("")){
      return myMac;
    }else{
      return "error";
    }
  }

}
