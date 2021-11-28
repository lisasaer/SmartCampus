package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class Staff {
    private String staffId;//工号
    private String cardNo;  //卡号
    private String name;    //用户名
    private String sex;     //性别
    private String photo;   //人脸图片地址
    private Integer departmentId;//部门ID
    /*private String dName;     */  //部门名称
    private String dname;
    private Integer positionId; //岗位ID
    private String pName;       //岗位名称
    private String telphone;//联系电话
    private String birth;//生日
    private String qq;  //QQ
    private String workState;//在职情况
    private String email;//邮件

    private int id;//historyfacealarm表的ID
    private String imagePath;          //抓拍图片地址
    private String alarmTime;          //报警时间
    private String strAlarmTime;          //报警时间
    private String devIP;              //设备IP


    private String schoolName;              //校区
    private String schoolId;
    private String houseName;               //楼栋
    private String houseId;
    private String floorName;               //楼层
    private String floorId;
    private String roomName;                //房号
    private String roomId;
    private String devStatus;               //设备状态
    private String createdTime;             //创建时间
    private String strCreatedTime;          //创建时间(string)
    private String updatedTime;             //补卡时间
    private String strUpdatedTime;          //补卡时间(string)

    private String remark;                  //备注
    private String personType;              //人员类型
    private String personTypeName;          //人员类型名字
    private String staffName;
}