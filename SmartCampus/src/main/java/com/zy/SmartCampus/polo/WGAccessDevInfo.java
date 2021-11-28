package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class WGAccessDevInfo {
    private String id;
    private String ctrlerSN;           //设备序列号
    private String ip;              //ip
    private String school;
    private String house;
    private String floor;
    private String room;
    private String status;
    private String devName;
    private int port;               //端口号
    private String netmask;         //子网掩码
    private String defaultGateway;  //默认网关
    private String macAddress;      //MAC地址
    private String driverVerID;     //版本号
    private String verDate;         //版本日期
    private int onLine;             //状态监测
    private int onUse;              //是否启用
    private int departmentId;              //所属部门ID
    //区域
}
