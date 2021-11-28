package com.zy.SmartCampus.polo;

import com.sun.jna.NativeLong;
import lombok.Data;

@Data

public class FaceCardInfo {

    private NativeLong lUserID;     //注册设备ID
    private String strCardNo;       //卡号
    private String strStartTime;    //起始时间
    private String strEndTime;      //截止时间
    private String strCardPSW;      //卡密
    private int     iEmployeeNo;    //工号
    private String strCardUserName; //持卡人姓名
    private String strPicPath;      // 人脸图片地址
    private String type;            //类型(用于人员删除的权限下发)

    public FaceCardInfo(NativeLong lUserID, String strCardNo, String strStartTime, String strEndTime, String strCardPSW, int iEmployeeNo, String strCardUserName, String strPicPath,String type) {
        this.lUserID = lUserID;
        this.strCardNo = strCardNo;
        this.strStartTime = strStartTime;
        this.strEndTime = strEndTime;
        this.strCardPSW = strCardPSW;
        this.iEmployeeNo = iEmployeeNo;
        this.strCardUserName = strCardUserName;
        this.strPicPath = strPicPath;
        this.type = type;
    }

}
