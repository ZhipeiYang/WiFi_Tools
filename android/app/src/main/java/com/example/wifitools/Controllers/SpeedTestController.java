package com.example.wifitools;

import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.Timer;
import java.util.TimerTask;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import org.json.*;

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
    final Handler mHandler = new Handler() {
         @Override
         public void handleMessage(Message msg) {
             switch (msg.what) {
             case UPDATE_MSG:
                 total_nowRx = TrafficStats.getTotalRxBytes();
                 total_resultRx = total_nowRx - total_preRx;
                 // Log.d("zbv", "total_resultRx="+total_resultRx);
                 // tv_download.setText(handleUnit(total_resultRx));
                 //System.out.println("下载："+handleUnit(total_resultRx));
                 // 设置下载流量信息

                 total_preRx = total_nowRx;
                 // 修改前后数据接收流量信息

                 total_nowTx = TrafficStats.getTotalTxBytes();
                 total_resultTx = total_nowTx - total_preTx;
                 // Log.d("zbv", "total_resultTx="+total_resultTx);
                 // tv_upload.setText(handleUnit(total_resultTx));
                 // 设置上传流量信息
                 //System.out.println("上传:"+handleUnit(total_resultTx));
                 speedJson(handleUnit(total_resultTx), handleUnit(total_resultRx));
                 // 修改前后数据传送流量信息
                 total_preTx = total_nowTx;
                 break;

             default:
                 break;
             }
         }
     };
    SpeedTestController(){
        fetchTotalTraffic();
    }
    

    private String handleUnit(long result) {
        String txt = "";
        double loadSpeed;
        if (result < 1024) {
            loadSpeed = result;
            txt = String.format("%1$.2fbps", loadSpeed);
        } else if (result >= 1024 && result < (1024 * 1024)) {
            loadSpeed = Math.round(result / 1024);
            txt = String.format("%1$.2fKbps", loadSpeed);
        } else if (result > 1024 * 1024) {
            loadSpeed = Math.round(result / 1024 / 1024);
            txt = String.format("%1$.2fMbps", loadSpeed);
        }
        return txt;
    }

    private void fetchTotalTraffic() {
        new Timer().schedule(new TimerTask() {

            @Override
            public void run() {
                mHandler.sendEmptyMessage(UPDATE_MSG);
            }
        }, 1000, 1000);
    }
    private String speedJson(String up,String down){
        NetSpeed ns=new NetSpeed(up,down);
        Gson gson=new Gson();
        String result=gson.toJson(ns);
        System.out.println(result);
        return result;
    }

}
