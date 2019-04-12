package com.example.wifitools;
import java.util.ArrayList;
import java.util.List;
public class PortBind
{
    private String ip;

    private List<Integer> port;

    public void setIp(String ip){
        this.ip = ip;
    }
    public String getIp(){
        return this.ip;
    }
    public void setPort(List<Integer> port){
        this.port = port;
    }
    public List<Integer> getPort(){
        return this.port;
    }
}
