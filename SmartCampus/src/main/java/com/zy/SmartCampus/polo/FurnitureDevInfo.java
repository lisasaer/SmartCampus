package com.zy.SmartCampus.polo;

/**
 * @author: duzhibin
 * @description:
 * @date: create in 19:53 2021/7/22
 */
public class FurnitureDevInfo {
    private String devId;  //设备ID
    private String devName; //设备名称

    @Override
    public String toString() {
        return "FurnitureDevInfo{" +
                "devId='" + devId + '\'' +
                ", devName='" + devName + '\'' +
                '}';
    }
    public FurnitureDevInfo(){}
    public FurnitureDevInfo(String devId, String devName) {
        this.devId = devId;
        this.devName = devName;
    }

    public String getDevId() {
        return devId;
    }

    public void setDevId(String devId) {
        this.devId = devId;
    }

    public String getDevName() {
        return devName;
    }

    public void setDevName(String devName) {
        this.devName = devName;
    }
}
