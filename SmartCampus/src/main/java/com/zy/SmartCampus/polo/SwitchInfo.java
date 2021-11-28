package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class SwitchInfo {
    private String id;  //主键
    private String devId;  //设备ID
    private String loraSN;  //设备SN
    private String switchAddress;//开关地址
    private String switchName;//开关名称
    private String recordTime;//开关闸记录时间
    private String switchStatus;//开关闸状态
    private String lineCurrent;     //线路电流
    private String lineVoltage;     //线路电压
    private String linePower;       //线路功率
    private String leakageCurrent;  //漏电电流
    private String moduleTemperature;//模块温度
    private String dataUpTime;//实时数据刷新时间

}
