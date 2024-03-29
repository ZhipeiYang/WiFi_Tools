package com.example.wifitools;

import java.net.InetAddress;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.net.SocketTimeoutException;
import java.net.UnknownHostException;
import java.util.List;
import java.util.ArrayList;

public class PortScanUtile {

    List<Integer> success = new ArrayList<>();

    public List<Integer> connectByList(String ip, List<Integer> port) {
        // 创建线程池
        List<Thread> threadPool = new ArrayList<>();
        //给每个端口开启线程测通
        for (int item : port) {
            Thread thread = new Thread(new Runnable() {
                @Override
                public void run() {
                    try {
                        Socket socket = new Socket();
                        socket.setReceiveBufferSize(8192);
                        socket.setSoTimeout(1000);
                        SocketAddress address = new InetSocketAddress(ip, item);
                        socket.connect(address, 500);
                        success.add(item);
                    } catch (IOException e) {
                        System.out.println("新建一个 socket" + ip + " " + item + "连接失败");
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            });
            thread.start();
            threadPool.add(thread);
        }
        //强制主线程等待所有子线程完成后再处理
        for (int i = 0; i < threadPool.size(); i++) {
            try {
                threadPool.get(i).join();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        // for (int item : success) {
        //     System.out.println(item);
        // }
        //返回已经测通的端口号
        return success;
    }
}