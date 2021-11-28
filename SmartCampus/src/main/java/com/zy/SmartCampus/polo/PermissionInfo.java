package com.zy.SmartCampus.polo;

import lombok.Data;

//权限设置
@Data
public class PermissionInfo {
    private int id;
    //private String name;            //权限名称
    private String permissionNum;   //模块
    private String creatDate;       //创建时间
    private String staffId;//员工工号
    private String name;//员工姓名
    private String cardNo;//员工所持卡号
    private String wgSNAndDoorID;//
    private String doorName;//权限门名称
    private String departmentName;//部门名称
    private String ctrlerSN;//
    private String strCreatedTime;
}
