package com.zy.SmartCampus.polo;

import lombok.Data;

//视频监控
@Data
public class VideoInfo {
    private String id;
    private String deviceId;
    private String devName;
    private String username;
    private String password;
    private String encryptedPassword; //加密密码
    private int port;
    private String ip;
    private String treeID;       //区域
    private String createDate;
    private String strCreateDate;

    private String schoolId;    //校区
    private String schoolName;
    private String houseId;
    private String houseName;//楼栋
    private String floorId;     //楼层
    private String floorName;
    private String roomId;      //房号
    private String roomName;

    private String devType;     //设备类型
    private String netMask;     //子网掩码
    private String gateWay;     //网关
    private String devStatus;   //设备状态

    private String pId;                 //父节点id
    private String iconCls;             //图标样式
}
