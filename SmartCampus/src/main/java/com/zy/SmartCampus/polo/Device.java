package com.zy.SmartCampus.polo;

import com.sun.jna.NativeLong;
import lombok.Data;

import java.util.Date;

@Data
public class Device {
    private int deviceId;
    private String dname;
    private String dtype;
    private String dip;
    private String dnetMask;
    private String dgateWay;
    private String duser;
    private String dpassWord;
    private String encryptedPassword; //加密密码
    private String dposition;
    private Integer departmentId;
    private String departmentName;
    private short port;

    private String schoolName;              //校区
    private String schoolId;
    private String houseName;               //楼栋
    private String houseId;
    private String floorName;               //楼层
    private String floorId;
    private String roomName;                //房号
    private String roomId;
    private String devStatus;           //设备状态
    private String createdTime;             //创建时间
    private String strCreatedTime;             //创建时间(string)

    private NativeLong lAlarmHandleData;    //报警布防返回值

    private String value;   //设备ID
    private String title;   //设备名称
}
