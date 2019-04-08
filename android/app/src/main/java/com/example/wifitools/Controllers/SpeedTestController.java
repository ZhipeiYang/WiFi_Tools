package com.example.wifitools;

import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.Timer;
import java.util.TimerTask;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.json.*;

import android.content.Context;
import android.os.Message;
import android.os.Handler;
import android.net.TrafficStats;

public class SpeedTestController {
    private long rxtxTotal = 0;
    private long total_preRx;
    private long total_nowRx;
    private long total_resultRx;

    private long total_preTx;
    private long total_nowTx;
    private long total_resultTx;
    private DecimalFormat showFloatFormat = new DecimalFormat("0.00");
    private static final int UPDATE_MSG = 0;
    private Context context;


    private Timer myTimer=new Timer();

    final Handler mHandler = new Handler() {
         @Override
         public void handleMessage(Message msg) {
             switch (msg.what) {
             case UPDATE_MSG:
                 total_nowRx = TrafficStats.getTotalRxBytes();
                 total_resultRx = total_nowRx - total_preRx;
                 
                 // 设置下载流量信息

                 total_preRx = total_nowRx;
                 // 修改前后数据接收流量信息

                 total_nowTx = TrafficStats.getTotalTxBytes();
                 total_resultTx = total_nowTx - total_preTx;
                 //用广播将转换得到的json发出去
                 BroadcastUtile.send(context,speedJson(handleUnit(total_resultTx), handleUnit(total_resultRx))); 
                 // 修改前后数据传送流量信息
                 total_preTx = total_nowTx;
                 break;

             default:
                 break;
             }
         }
     };

    //根据传入的context内容初始化类，context用于获取上下文发送广播
    SpeedTestController(Context context){
        this.context=context;
    }
    
    //格式转换，将得到的网速转换为合适的单位，以字符串格式返回
    private String handleUnit(long result) {
        String txt = "";
        double loadSpeed;
        if (result < 1024) {
            loadSpeed = result;
            txt = String.format("%1$.0f", loadSpeed);
        } else if (result >= 1024 && result < (1024 * 1024)) {
            loadSpeed = Math.round(result / 1024);
            txt = String.format("%1$.0fK", loadSpeed);
        } else if (result > 1024 * 1024) {
            loadSpeed = Math.round(result / 1024 / 1024);
            txt = String.format("%1$.0fM", loadSpeed);
        }
        return txt;
    }
    //开启线程获取网速，每秒获取一次
    public void fetchTotalTraffic() {
        myTimer=new Timer();
        myTimer.schedule(new TimerTask() {
            @Override
            public void run() {
                mHandler.sendEmptyMessage(UPDATE_MSG);
            }
        }, 1000, 1000);
    }
    public void cancelBroadcast(){
        myTimer.cancel();
    }
    
    //把扫描得到的上传和下载速度转换为json字串
    private String speedJson(String up,String down){
        NetSpeed ns=new NetSpeed(up,down);
        Gson gson=new Gson();
        String result=gson.toJson(ns);
        //System.out.println(result);
        return result;
    }

}
