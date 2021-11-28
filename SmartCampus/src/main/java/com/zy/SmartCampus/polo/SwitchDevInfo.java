package com.zy.SmartCampus.polo;

import lombok.Data;

import java.util.List;

@Data
public class SwitchDevInfo {
    private int id;
    private String school;    //校区
    private String house;     //楼栋
    private String floor;     //楼层
    private String room;      //房号
    private String loraSN;//Lora序列号
    private String uuid;//空开通讯地址
    private int switchGroupNum;//空开组数量
    private String sensortype;//终端设备类型
    private String intervaltime;//终端数据上报间隔
    private String port;//终端设备接的端口
    private int chncnt;//终端设备通道数量
    private String chntype;//终端通道类型
    private String devSN;//设备序列号
    private int devId;
    private String devStatus;//设备在线状态
    private String chnData;//设备开关状态
    private String chnId;//通道id

    private String page;
    private String limit;
    private String offset;
}
