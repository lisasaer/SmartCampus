package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class WGAccessDoorInfo {
    private String id;

    private String school;
    private String house;
    private String floor;
    private String room;

    private String ctrlerSN;    //控制器SN
    private String readerID;    //控制器上所有门编号，最多4个-读卡器名称
    private String doorID;      //控制上门ID
    private String doorName;    //控制器上所有门名称
    private String doorCtrlWay; //控制方式
    private String doorDelay;   //开门延时
    private int onUse;          //是否启用
    private String inType;//进门读卡器性质
    private String outType;//出门读卡器性质
    private String createdTime;

    private String value;   //设备ID
    private String title;   //设备名称
}
