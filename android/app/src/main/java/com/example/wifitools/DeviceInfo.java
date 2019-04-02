package com.example.wifitools;
public class DeviceInfo{
    private String name;
    private String ip;
    public DeviceInfo(String name,String ip){
        this.name=name;
        this.ip=ip;
    }
    String getName(){
        return this.name;
    }
    String getIp(){
        return this.ip;
    }
    void setName(String name){
        this.name=name;
    }
    void setIp(String ip){
        this.ip=ip;
    }
}