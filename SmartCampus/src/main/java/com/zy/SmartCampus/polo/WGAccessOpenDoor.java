package com.zy.SmartCampus.polo;

import lombok.Data;

//wpp 2020-3-30开门记录
@Data
public class WGAccessOpenDoor {
    private String id;
    private String ctrlerID;//控制器id
    private String username;          //人员姓名
    private String departmentId;       //部门ID
    private String staffId;            //工号
    private int doorID; //门编号
    private String doorName;
    private String cardID;//卡号
    private int openDoorWay;//开门方式
    private int isPass;//是否通过
    private int direction;//开门方向
    private String doorDateTime;//开门时间

    private String schoolName;              //校区
    private String schoolId;
    private String houseName;               //楼栋
    private String houseId;
    private String floorName;               //楼层
    private String floorId;
    private String roomName;                //房号
    private String roomId;

}
