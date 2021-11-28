package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class DevInfo {
    private String id;          //主键

    private String devId;       //设备ID
    private String devName;     //设备名称
    private String devType;     //设备类型
    private String devSN;

    private String school;    //校区
    private String house;     //楼栋
    private String floor;     //楼层
    private String room;      //房号

    private String lineCount;
    private String devPostion;  //位置
    private String devStatus;   //状态
    private long recordTime;


    private String temperature ;    //温度
    private String humidity ;       //湿度
    private String infrared;        //红外
    private String relay;           //继电器

    private String lineCurrent;     //线路电流
    private String lineVoltage;     //线路电压
    private String linePower;       //线路功率
    private String leakageCurrent;  //漏电电流
    private String moduleTemperature;//模块温度
    private String switchAddress;//开关地址
    private String devIdNew;
}
