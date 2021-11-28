package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class SwitchCtrlInfo {
    private int devId;   //从机设备ID
    private String type;    //开关闸类型
    private String address;    //开关地址
}
