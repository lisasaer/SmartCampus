package com.zy.SmartCampus.polo;
import lombok.Data;

@Data
public class LoraDevInfo {
    private String id;
    private String school;    //校区
    private String house;     //楼栋
    private String floor;     //楼层
    private String loraSN;           //设备序列号
    private String ip;              //设备ip
    private int port;               //端口号
    private String netmask;         //子网掩码
    private String defaultGateway;  //默认网关
    private String macAddress;      //MAC地址

    private String driverVerID;     //版本号
    private String verDate;         //版本日期
    private String onLine;             //状态监测
    private String onUse;              //是否启用
    private String seqNumber;       //服务器发送数据流水号(四字节)
    private String fwVer;           //设备固件版本号（网关）
    private String sub1gNum;           //sub1g接口数量
    private String switchGroupNum;  //空开组数量
    private long data;//心跳时间

    private String limit;
    private String offset;
}
