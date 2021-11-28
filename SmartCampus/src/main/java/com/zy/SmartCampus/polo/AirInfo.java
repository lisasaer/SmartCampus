package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class AirInfo {
//    private String id;                      //自增主键
//    private String devId;                   //设备地址
//    private String devName;                 //设备名称
    private String devPostion;              //设备位置(为RoomId)
//    private String devStatus;               //设备状态
    private String devType;                 //设备类型：1.空开;2.空调
//    private String devSN;                   //序列号
    private String temperature;             //温度
    private String humidity;                //湿度
    private String infraredInduction;       //人体红外感应(有人/没人)
    private String relayStatus;             //继电器开关状态(已开启/已关闭)
    private String recordTime;              //开启/关闭继电器的时间
    private String type;    //类型 (打开继电器/关闭继电器)
    private String devIdNew;


    private int id;
    private String school;    //校区
    private String house;     //楼栋
    private String floor;     //楼层
    private String room;      //房号
    private String loraSN;//Lora序列号
    private String uuid;//空调通讯地址
    private int switchGroupNum;//空开组数量
    private String sensortype;//终端设备类型
    private String intervaltime;//终端数据上报间隔
    private String port;//终端设备接的端口
    private int chncnt;//终端设备通道数量
    private String chntype;//终端通道类型
    private String devName;//空调名称
    private String devSN;//设备序列号
    private String devId;
    private String devStatus;//设备在线状态
    private String chnData;//设备开关状态
    private String chnId;//通道id

    private String limit;
    private String offset;
}
