package com.example.wifitools;

import java.net.InetAddress;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;

public class PortScanUtile {
    
    private  boolean flag = false;
    public  void connect(String server, int servPort)
            throws IOException, UnknownHostException, SocketTimeoutException {
        // 根据传入的server获取地址
        InetAddress ad = InetAddress.getByName(server);
        //System.out.println("初始化InetAddrss成功");
        Socket socket = new Socket();
        socket.setReceiveBufferSize(8192);
        socket.setSoTimeout(1000);
        //System.out.println("初始化套接字成功");
        // socket.setSoTimeout(2000);
        SocketAddress address = new InetSocketAddress(server, servPort);
        //System.out.println("初始化IP地址成功");
        new Thread(new Runnable() {
            public volatile boolean exit = false; 
            @Override
            public void run() {
               while(!exit){
                try {
                    socket.connect(address, 100);
                    //System.out.println("连接完成");
                    setFlag(true);
                    exit=true;
                } catch (IOException e) {
                    //System.out.println("新建一个 socket server " + servPort + "连接失败");
                    setFlag(false);
                    exit=true;
                } catch (Exception e) {
                    e.printStackTrace();
                    setFlag(false);
                    exit=true;
                }
               }
            }
        }).start();  
    }

    private  void setFlag(boolean t) {
        flag = t;
    }
    public  boolean getFlag(){
        return flag;
    }

}