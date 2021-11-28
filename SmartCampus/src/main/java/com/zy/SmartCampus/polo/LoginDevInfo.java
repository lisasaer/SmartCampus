package com.zy.SmartCampus.polo;

import com.sun.jna.NativeLong;
import lombok.Data;

/**
 * 注册成功设备信息
 */
@Data
public class LoginDevInfo {

    private int  iDevID;    //设备ID
    private String strDevIP;//设备IP
    private int iDepartmentID;//设备所属部门ID
    private NativeLong lUserID;//设备注册成功ID

    public LoginDevInfo(int iDevID, String strDevIP,/* int iDepartmentID,*/ NativeLong lUserID) {
        this.iDevID = iDevID;
        this.strDevIP = strDevIP;
//        this.iDepartmentID = iDepartmentID;
        this.lUserID = lUserID;
    }
}
