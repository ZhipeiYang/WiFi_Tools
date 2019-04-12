package com.example.wifitools;


import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;

import android.os.Bundle;

public class BroadcastUtile{
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
