package com.example.wifitools;


import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
//import android.support.v7.app.AppCompatActivity;
//import android.support.v4.content.LocalBroadcastManager;
import android.os.Bundle;

public class BroadcastUtile{
    //private static BroadCastReceive mBroadCastReceive;

    // public static void send(String data) {
    //     // 新建intent 对象
    //     Intent intent = new Intent();
    //     // 设置 动作
    //     intent.setAction("speedBroadcast");
    //     // 添加传递的参数
    //     intent.putExtra("data", data);
    //     //发送广播
    //     // sendBroadcast(intent);
    //     BroadcastManager.getInstance(context).sendBroadcast(intent);
    // }

    public static void send(Context context, String data) {
		if(context == null){
			return;
		}
		Intent intent = new Intent();
        intent.setAction("speedBroadcast");
        intent.putExtra("data", data);
		context.sendBroadcast(intent);
	}

}
