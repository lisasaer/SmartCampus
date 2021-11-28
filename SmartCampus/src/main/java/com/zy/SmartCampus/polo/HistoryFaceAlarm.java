package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class HistoryFaceAlarm {
    private int id;
    private String staffName;          //人员姓名
    private String departmentId;       //部门ID
    //private String dName;              //所属部门
    private String dname;               //上一代遗留问题，有些地方只能用小写,大写的前端jsp中无法被调用
    private String imagePath;          //抓拍图片地址
    private String staffId;            //工号
    private String alarmTime;          //报警时间
    private String strAlarmTime;          //报警时间
    private String cardNo;             //卡号
    private String devIP;              //设备IP
    private String dposition;           //设备安装地点

    private String devName;             //设备名称
    private String status;              //进出状态

    private String limit;
    private String offset;

    private String schoolName;              //校区
    private String schoolId;
    private String houseName;               //楼栋
    private String houseId;
    private String floorName;               //楼层
    private String floorId;
    private String roomName;                //房号
    private String roomId;

    private String remark;                  //备注
    private String personType;              //人员类型
    private String personTypeName;          //人员类型名字

}
