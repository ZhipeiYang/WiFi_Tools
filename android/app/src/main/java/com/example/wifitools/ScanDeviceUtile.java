package com.example.wifitools;

import android.text.TextUtils;

import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

//import com.google.gson.Gson;
//import com.imxiaoyu.common.utils.ALog;

/**
 * Created by Admin on 2017/10/13.
 */

public class ScanDeviceUtile {

    private static final String TAG = ScanDeviceUtile.class.getSimpleName();

    /** 核心池大小 **/
    private static final int CORE_POOL_SIZE = 1;
    /** 线程池最大线程数 **/
    private static final int MAX_IMUM_POOL_SIZE = 255;

    private String mDevAddress;// 本机IP地址-完整
    private String mLocAddress;// 局域网IP地址头,如：192.168.1.
    private Runtime mRun = Runtime.getRuntime();// 获取当前运行环境，来执行ping，相当于windows的cmd
    private Process mProcess = null;// 进程
    private String mPing = "ping -c 1 -w 3 ";// 其中 -c 1为发送的次数，-w 表示发送后等待响应的时间
   // private List<String> mIpList = new ArrayList<String>();// ping成功的IP地址
    private ThreadPoolExecutor mExecutor;// 线程池对象

    private List<DeviceInfo>mDevices=new ArrayList<DeviceInfo>();//所有扫描到的设备信息

    /**
     * <扫描局域网内ip，找到对应服务器>
     *
     * @return void
     */
    public List<DeviceInfo> scan() {
        mDevAddress = getHostIP();// 获取本机IP地址
        mLocAddress = getLocAddrIndex(mDevAddress);// 获取本地ip前缀
       // ALog.e(TAG, "开始扫描设备,本机Ip为：" + mDevAddress);
        System.out.println("开始扫描设备,本机Ip为：" + mDevAddress);
        if (TextUtils.isEmpty(mLocAddress)) {
            //ALog.e(TAG, "扫描失败，请检查wifi网络");
            System.out.println("扫描失败，请检查wifi网络");
            return null;
        }

        /**
         * 1.核心池大小 2.线程池最大线程数 3.表示线程没有任务执行时最多保持多久时间会终止
         * 4.参数keepAliveTime的时间单位，有7种取值,当前为毫秒
         * 5.一个阻塞队列，用来存储等待执行的任务，这个参数的选择也很重要，会对线程池的运行过程产生重大影响
         * ，一般来说，这里的阻塞队列有以下几种选择：
         */
        mExecutor = new ThreadPoolExecutor(CORE_POOL_SIZE, MAX_IMUM_POOL_SIZE,
                2000, TimeUnit.MILLISECONDS, new ArrayBlockingQueue<Runnable>(
                CORE_POOL_SIZE));

        // 新建线程池
        for (int i = 1; i < 255; i++) {// 创建256个线程分别去ping
            final int lastAddress = i;// 存放ip最后一位地址 1-255

            Runnable run = new Runnable() {

                @Override
                public void run() {
                    //Auto-generated method stub
                    String ping = ScanDeviceUtile.this.mPing + mLocAddress
                            + lastAddress;
                    String currnetIp = mLocAddress + lastAddress;
                    if (mDevAddress.equals(currnetIp)) // 如果与本机IP地址相同,跳过
                        return;

                    try {
                        mProcess = mRun.exec(ping);

                        int result = mProcess.waitFor();
//                        ALog.e(TAG, "正在扫描的IP地址为：" + currnetIp + "返回值为：" + result);
                        if (result == 0) {
//                            ALog.e(TAG, "扫描成功,Ip地址为：" + currnetIp);
                            //mIpList.add(currnetIp);
                            InetAddress host = InetAddress.getByName(currnetIp);
	            	        String hostName=host.getHostName();
	            	        DeviceInfo deviceInfo=new DeviceInfo(hostName, currnetIp);
	            	        mDevices.add(deviceInfo);
                        } else {
                            // 扫描失败
//                            ALog.e(TAG, "扫描失败");
                        }
                    } catch (Exception e) {
                       // ALog.e(TAG, "扫描异常" + e.toString());
                        System.out.println("扫描异常" + e.toString());
                    } finally {
                        if (mProcess != null)
                            mProcess.destroy();
                    }
                }
            };

            mExecutor.execute(run);
        }

        mExecutor.shutdown();

        while (true) {
            try {
                if (mExecutor.isTerminated()) {// 扫描结束,开始验证
                    //ALog.e(TAG, "扫描结束,总共成功扫描到" + mIpList.size() + "个设备.");
                    //System.out.println("扫描结束,总共成功扫描到" + mDevices.size() + "个设备.");
                   // ALog.e("设备列表："+new Gson().toJson(mIpList));
                    //System.out.println("设备列表："+new Gson().toJson(mIpList));
                    //return mIpList;
                    return mDevices;
                }
            } catch (Exception e) {
                // handle exception
                e.printStackTrace();
            }
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                // Auto-generated catch block
                e.printStackTrace();
            }
        }
    }

    /**
     * <销毁正在执行的线程池>
     *
     * @return void
     */
    public void destory() {
        if (mExecutor != null) {
            mExecutor.shutdownNow();
        }
    }

    /**
     * <获取本地ip地址>
     *
     * @return String
     */
    private String getLocAddress() {
        String ipaddress = "";

        try {
            Enumeration<NetworkInterface> en = NetworkInterface
                    .getNetworkInterfaces();
            // 遍历所用的网络接口
            while (en.hasMoreElements()) {
                NetworkInterface networks = en.nextElement();
                // 得到每一个网络接口绑定的所有ip
                Enumeration<InetAddress> address = networks.getInetAddresses();
                // 遍历每一个接口绑定的所有ip
                while (address.hasMoreElements()) {
                    InetAddress ip = address.nextElement();
                    if (!ip.isLoopbackAddress()
                            && (ip instanceof Inet4Address)) {
                        ipaddress = ip.getHostAddress();
                    }
                }
            }
        } catch (SocketException e) {
            //ALog.e("", "获取本地ip地址失败");
            System.out.println("获取本地ip地址失败");
            e.printStackTrace();
        }

       // ALog.e(TAG, "本机IP:" + ipaddress);
        System.out.println("本机IP:" + ipaddress);
        return ipaddress;
    }
    /**
     * 获取ip地址
     * @return
     */
    public static String getHostIP() {

        String hostIp = null;
        try {
            Enumeration nis = NetworkInterface.getNetworkInterfaces();
            InetAddress ia = null;
            while (nis.hasMoreElements()) {
                NetworkInterface ni = (NetworkInterface) nis.nextElement();
                Enumeration<InetAddress> ias = ni.getInetAddresses();
                while (ias.hasMoreElements()) {
                    ia = ias.nextElement();
                    if (ia instanceof Inet6Address) {
                        continue;// skip ipv6
                    }
                    String ip = ia.getHostAddress();
                    if (!"127.0.0.1".equals(ip)) {
                        hostIp = ia.getHostAddress();
                        break;
                    }
                }
            }
        } catch (SocketException e) {
           // ALog.e("yao", "SocketException");
            System.out.println("SocketException");
            e.printStackTrace();
        }
        return hostIp;

    }
    /**
     * <获取本机IP前缀>
     *
     * @param devAddress
     *            // 本机IP地址
     * @return String
     */
    private String getLocAddrIndex(String devAddress) {
        if (!devAddress.equals("")) {
            return devAddress.substring(0, devAddress.lastIndexOf(".") + 1);
        }
        return null;
    }
   

}