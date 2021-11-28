package com.zy.SmartCampus.hik;

import com.alibaba.fastjson.JSONObject;
import com.sun.jna.NativeLong;
import com.sun.jna.Pointer;
import com.zy.SmartCampus.mapper.HkMapper;
import com.zy.SmartCampus.mapper.HkMapper;
import com.zy.SmartCampus.polo.Device;
import com.zy.SmartCampus.polo.FaceCardInfo;
import com.zy.SmartCampus.polo.HistoryFaceAlarm;
import com.zy.SmartCampus.polo.LoginDevInfo;
import com.zy.SmartCampus.polo.LoginDevInfo;
import com.zy.SmartCampus.service.DeviceService;
import com.zy.SmartCampus.service.StaffService;
import com.zy.SmartCampus.util.MyUtil;
import com.zy.SmartCampus.webSocket.MyWebSocketHander;
import com.zy.SmartCampus.webSocket.WebSocketUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.*;
import java.nio.ByteBuffer;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.List;

@Component
public class HkSetting {

    @Autowired
    private HkMapper hkMapper;
    @Autowired
    private StaffService staffService;
    @Autowired
    private DeviceService deviceService;
    private static HCNetSDK hCNetSDK = HCNetSDK.INSTANCE;

    private FMSGCallBack_V31 fMSFCallBack_V31;

    /**
     * 根据设备IP返回注册设备信息
     * @param strIP
     * @return
     */
    public LoginDevInfo getLoginDevInfoByDevID(String strIP){
        LoginDevInfo loginDevInfo = null;
        for(LoginDevInfo temp:HkStaticInfo.g_loginDevInfoList){
            if (strIP.equals(temp.getStrDevIP()) ){
                loginDevInfo = temp;
                break;
            }
        }
        return loginDevInfo;
    }

    /**
     * 初始化SDK
     * @return
     */
    public boolean init(){
        boolean bInit = hCNetSDK.NET_DVR_Init();
        //MyUtil.printfInfo(bInit?"Init succ":"Init error code:"+hCNetSDK.NET_DVR_GetLastError());
        if(bInit){
            MyUtil.printfInfo("Init succ");
            deviceService.updateDevOffLine();//所有人脸识别设备状态设为"离线"
        }else{
            MyUtil.printfInfo("Init error code:"+hCNetSDK.NET_DVR_GetLastError());
        }
        //断线重连
        hCNetSDK.NET_DVR_SetConnectTime(2000, 1);
        hCNetSDK.NET_DVR_SetReconnect(10000, true);

        return bInit;
    }

    /**
     * 释放SDK
     * @return
     */
    public  boolean cleanUp(){
        boolean bRet =  hCNetSDK.NET_DVR_Cleanup();
        MyUtil.printfInfo(bRet?"释放SDK成功":"释放SDK失败"+hCNetSDK.NET_DVR_GetLastError());
        return bRet;
    }
    public  void setPictureData(NativeLong lUserID) {
//        HCNetSDK.NET_DVR_SNAPCFG struSnapCfg = new HCNetSDK.NET_DVR_SNAPCFG();
//        struSnapCfg.dwSize = struSnapCfg.size();
//        struSnapCfg.bySnapTimes = 2;
//        struSnapCfg.wIntervalTime[0] = 1000;
//        struSnapCfg.struJpegPara.wPicSize=1;
//
//
//        if(!hCNetSDK.NET_DVR_ContinuousShoot(lUserID,struSnapCfg)){
//            MyUtil.printfInfo("建立设置抓拍参数长连接失败，错误号：" + hCNetSDK.NET_DVR_GetLastError());
//            return;
//        }else{
//            MyUtil.printfInfo("设置抓拍参数长连接成功");
//        }

        HCNetSDK.NET_DVR_SNAPCFG struSnapCfg = new HCNetSDK.NET_DVR_SNAPCFG();
        struSnapCfg.dwSize=struSnapCfg.size();
        struSnapCfg.bySnapTimes =1;//抓拍次数： 0-不抓拍，非 0-连拍次数，目前最大 5 次
        struSnapCfg.wSnapWaitTime =1000;
        struSnapCfg.wIntervalTime[0] =1000;//连拍间隔时间，单位 ms，取值范围[67,60000]
        struSnapCfg.struJpegPara.wPicSize = 163;
        struSnapCfg.struJpegPara.wPicQuality = 1;
        struSnapCfg.write();

        boolean bSnapCfg = hCNetSDK.NET_DVR_ContinuousShoot(lUserID, struSnapCfg);
        MyUtil.printfInfo(bSnapCfg?"配置触发抓拍参数成功":"配置触发抓拍参数失败"+hCNetSDK.NET_DVR_GetLastError());

    }
//    public  void getPictureData(NativeLong lUserID) {
//        HCNetSDK.NET_DVR_XML_CONFIG_INPUT xml = new HCNetSDK.NET_DVR_XML_CONFIG_INPUT();
//        xml.dwSize = xml.size();
//        String url="GET /ISAPI/AccessControl/SnapConfig/capabilities";
//        xml.lpRequestUrl = url.getBytes();
//        NativeLong lAlarmHandle = hCNetSDK.NET_DVR_STDXML(lUserID, null,dwOutBuff);
//
//    }

    /**
     * 设备注册
     * @param device
     * @return
     */
    public  NativeLong login(Device device){
        HCNetSDK.NET_DVR_DEVICEINFO lpDeviceInfo = new HCNetSDK.NET_DVR_DEVICEINFO();
        NativeLong lUserID = hCNetSDK.NET_DVR_Login(device.getDip(),device.getPort(),device.getDuser(),device.getDpassWord(),lpDeviceInfo);
        MyUtil.printfInfo( lUserID.intValue()> -1 ? device.getDip()+" 注册成功":device.getDip()+" 注册失败 "+hCNetSDK.NET_DVR_GetLastError());
        if(lUserID.intValue() > -1){
            MyUtil.printfInfo(device.toString());
            HkStaticInfo.g_loginDevInfoList.add(new LoginDevInfo(device.getDeviceId(),device.getDip(),/*device.getDepartmentId(),*/lUserID));
            MyUtil.printfInfo("当前注册成功设备数量:"+HkStaticInfo.g_loginDevInfoList.size());
        }
        return  lUserID;
    }

    /**
     * 注销设备
     * @param lUserID
     * @return
     */
    public  boolean logout(int lUserID){

        boolean bRet = hCNetSDK.NET_DVR_Logout(new NativeLong(lUserID));
        MyUtil.printfInfo(bRet?"注销成功":"注销失败"+hCNetSDK.NET_DVR_GetLastError());//1924 布防超过最大连接数
        return bRet;
    }
    public static NativeLong lAlarmHandleData;
    public static List<Device> list = new ArrayList<>();
    public static int num=0;
    /**
     * 设备布防
     * @param lUserID
     * @return
     */
    public  NativeLong setUpAlarmChan(NativeLong lUserID,Device device){

        HCNetSDK.NET_DVR_SETUPALARM_PARAM m_strAlarmInfo = new HCNetSDK.NET_DVR_SETUPALARM_PARAM();
        m_strAlarmInfo.dwSize=m_strAlarmInfo.size();
        m_strAlarmInfo.byLevel=1;
        m_strAlarmInfo.byAlarmInfoType=1;
        m_strAlarmInfo.write();
        NativeLong lAlarmHandle = hCNetSDK.NET_DVR_SetupAlarmChan_V41(lUserID, m_strAlarmInfo);
        if(lAlarmHandle.intValue()>-1){
            MyUtil.printfInfo("布防成功");
            deviceService.updateDevOnLine(device);
            Device alarmDev = new Device();
            alarmDev.setDeviceId(device.getDeviceId());
            alarmDev.setLAlarmHandleData(lAlarmHandle);
            list.add(device);
        }else{
            MyUtil.printfInfo("布防失败"+hCNetSDK.NET_DVR_GetLastError());
        }
//        MyUtil.printfInfo(lAlarmHandle.intValue()>-1?"布防成功":"布防失败"+hCNetSDK.NET_DVR_GetLastError());
        return  lAlarmHandle;
    }

    /**
     * 设备撤防
     */
    public  void closeAlarmChan(NativeLong lAlarmHandle) {
        //报警撤防
//        if (lAlarmHandle.intValue() > -1)
//        {
            boolean bRet = hCNetSDK.NET_DVR_CloseAlarmChan_V30(lAlarmHandle);
            MyUtil.printfInfo(bRet?"撤防成功":"撤防失败 "+hCNetSDK.NET_DVR_GetLastError());
//        }
    }



    /**
     * 设置卡和人脸参数
     * @param faceInfo
     * @throws UnsupportedEncodingException
     * @throws ParseException
     */
    public  void setCardAndFaceInfo(FaceCardInfo faceInfo) throws UnsupportedEncodingException, ParseException {

        MyUtil.printfInfo("=========准备下发卡参数==========");
        setCardInfo(faceInfo);
        MyUtil.printfInfo("=========准备下发人脸参数==========");
        setFaceInfo(faceInfo);
    }
    /**
     * 获取卡和人脸参数
     * @param faceInfo
     * @throws UnsupportedEncodingException
     * @throws ParseException
     */
    public  void getCardAndFaceInfo(FaceCardInfo faceInfo) throws UnsupportedEncodingException, ParseException {

        MyUtil.printfInfo("=========准备获取卡参数==========");
        //getCardInfo(faceInfo);
        MyUtil.printfInfo("=========准备获取人脸参数==========");
        //getFaceInfo(faceInfo);
    }

//    /**
//     * 获取门禁设备的人员信息
//     * @param faceCardInfo
//     * @throws UnsupportedEncodingException
//     * @throws ParseException
//     */
//    public void getDevPersonInfo(FaceCardInfo faceCardInfo) throws UnsupportedEncodingException, ParseException {
//        MyUtil.printfInfo("=========准备获取卡参数==========");
//        int iErr = 0;
//
//        //设置卡参数
//        HCNetSDK.getPerson getPerson = new HCNetSDK.getPerson();
//        getPerson.lpInBuffer = "POST /ISAPI/AccessControl/UserInfo/Search?format=json";
//        Pointer lpInBuffer = getPerson.getPointer();
//        getPerson.write();
//
//        Pointer pUserData = null;
//        FRemoteCfgCallBackPersonGet fRemoteCfgCallBackPersonGet = new FRemoteCfgCallBackPersonGet();
//
//        NativeLong lHandle = hCNetSDK.NET_DVR_StartRemoteConfig(faceCardInfo.getLUserID(), HCNetSDK.NET_DVR_JSON_CONFIG, lpInBuffer, getPerson.size(), fRemoteCfgCallBackPersonGet, pUserData);
//        if (lHandle.intValue() < 0)
//        {
//            iErr = hCNetSDK.NET_DVR_GetLastError();
//            MyUtil.printfInfo("建立卡参数长连接失败，错误号：" + iErr);
//            return;
//        }
//        HCNetSDK.UserInfoSearchCode userInfoSearchCode = new HCNetSDK.UserInfoSearchCode();
//        String code = "{" +
//                "    \"UserInfoSearchCond\": {\n" +
//                "        \"searchID\": 1,    " +
//                "        \"searchResultPosition\": 0,   " +
//                "        \"maxResults\": 30, " +
//                "    }" +
//                "}";
//        userInfoSearchCode.code.getString(code);
//        Pointer pSendBufSet = userInfoSearchCode.getPointer();
//        userInfoSearchCode.write();
//        if(!hCNetSDK.NET_DVR_SendRemoteConfig(lHandle, 0x3, pSendBufSet, userInfoSearchCode.size()))
//        {
//            iErr = hCNetSDK.NET_DVR_GetLastError();
//            MyUtil.printfInfo("ENUM_ACS_SEND_DATA失败，错误号：" + iErr);
//            return;
//        }
//
//        try {
//            Thread.sleep(1000);
//        } catch (InterruptedException e) {
//            // TODO Auto-generated catch block
//            e.printStackTrace();
//        }
//
//        if(!hCNetSDK.NET_DVR_StopRemoteConfig(lHandle))
//        {
//            iErr = hCNetSDK.NET_DVR_GetLastError();
//            MyUtil.printfInfo("断开长连接失败，错误号：" + iErr);
//            return;
//        }
//        MyUtil.printfInfo("断开长连接成功!");
//    }
    /**
     * 卡参数设置回调
     */
    public  class FRemoteCfgCallBackPersonGet implements HCNetSDK.FRemoteConfigCallback
    {
        public void invoke(int dwType, Pointer lpBuffer, int dwBufLen, Pointer pUserData)
        {
            MyUtil.printfInfo("长连接回调获取数据,NET_SDK_CALLBACK_TYPE_STATUS:" + dwType);
            switch (dwType){
                case 0:// NET_SDK_CALLBACK_TYPE_STATUS
                    HCNetSDK.REMOTECONFIGSTATUS_CARD struCardStatus = new HCNetSDK.REMOTECONFIGSTATUS_CARD();
                    struCardStatus.write();
                    Pointer pInfoV30 = struCardStatus.getPointer();
                    pInfoV30.write(0, lpBuffer.getByteArray(0, struCardStatus.size()), 0,struCardStatus.size());
                    struCardStatus.read();

                    int iStatus = 0;
                    for(int i=0;i<4;i++)
                    {
                        int ioffset = i*8;
                        int iByte = struCardStatus.byStatus[i]&0xff;
                        iStatus = iStatus + (iByte << ioffset);
                    }

                    switch (iStatus){
                        case 1000:// NET_SDK_CALLBACK_STATUS_SUCCESS
                            MyUtil.printfInfo("下发卡参数成功,dwStatus:" + iStatus);
                            break;
                        case 1001:
                            MyUtil.printfInfo("正在下发卡参数中,dwStatus:" + iStatus);
                            break;
                        case 1002:
                            int iErrorCode = 0;
                            for(int i=0;i<4;i++)
                            {
                                int ioffset = i*8;
                                int iByte = struCardStatus.byErrorCode[i]&0xff;
                                iErrorCode = iErrorCode + (iByte << ioffset);
                            }
                            MyUtil.printfInfo("下发卡参数失败, dwStatus:" + iStatus + "错误号:" + iErrorCode);//NET_DVR_GetLastError ：  1920：不支持一人多卡
                            break;
                    }
                    break;
                default:
                    break;
            }
        }
    }


    /**
     * 设置卡参数
     * @param faceCardInfo
     * @throws UnsupportedEncodingException
     * @throws ParseException
     */
    public  void setCardInfo(FaceCardInfo faceCardInfo) throws UnsupportedEncodingException, ParseException {
        int iErr = 0;
        System.out.println(faceCardInfo);
        //设置卡参数
        HCNetSDK.NET_DVR_CARD_CFG_COND m_struCardInputParamSet = new HCNetSDK.NET_DVR_CARD_CFG_COND();
        m_struCardInputParamSet.read();
        m_struCardInputParamSet.dwSize = m_struCardInputParamSet.size();
        m_struCardInputParamSet.dwCardNum = 1;
        m_struCardInputParamSet.byCheckCardNo = 1;


        Pointer lpInBuffer = m_struCardInputParamSet.getPointer();
        m_struCardInputParamSet.write();

        Pointer pUserData = null;
        FRemoteCfgCallBackCardSet fRemoteCfgCallBackCardSet = new FRemoteCfgCallBackCardSet();

        NativeLong lHandle = hCNetSDK.NET_DVR_StartRemoteConfig(faceCardInfo.getLUserID(), HCNetSDK.NET_DVR_SET_CARD_CFG_V50, lpInBuffer, m_struCardInputParamSet.size(), fRemoteCfgCallBackCardSet, pUserData);
        if (lHandle.intValue() < 0)
        {
            iErr = hCNetSDK.NET_DVR_GetLastError();
            MyUtil.printfInfo("建立卡参数长连接失败，错误号：" + iErr);
            return;
        }
        MyUtil.printfInfo("建立设置卡参数长连接成功!");

        HCNetSDK.NET_DVR_CARD_CFG_V50 struCardInfo = new HCNetSDK.NET_DVR_CARD_CFG_V50(); //卡参数
        struCardInfo.read();
        struCardInfo.dwSize = struCardInfo.size();
        struCardInfo.dwModifyParamType = 0x00000001 + 0x00000002 + 0x00000004 + 0x00000008 +
                0x00000010 + 0x00000020 + 0x00000080 + 0x00000100 + 0x00000200 + 0x00000400 + 0x00000800;
        /***
         * #define CARD_PARAM_CARD_VALID       0x00000001  //卡是否有效参数
         * #define CARD_PARAM_VALID            0x00000002  //有效期参数
         * #define CARD_PARAM_CARD_TYPE        0x00000004  //卡类型参数
         * #define CARD_PARAM_DOOR_RIGHT       0x00000008  //门权限参数
         * #define CARD_PARAM_LEADER_CARD      0x00000010  //首卡参数
         * #define CARD_PARAM_SWIPE_NUM        0x00000020  //最大刷卡次数参数
         * #define CARD_PARAM_GROUP            0x00000040  //所属群组参数
         * #define CARD_PARAM_PASSWORD         0x00000080  //卡密码参数
         * #define CARD_PARAM_RIGHT_PLAN       0x00000100  //卡权限计划参数
         * #define CARD_PARAM_SWIPED_NUM       0x00000200  //已刷卡次数
         * #define CARD_PARAM_EMPLOYEE_NO      0x00000400  //工号
         * #define CARD_PARAM_NAME             0x00000800  //姓名
         */

        //卡号
        String strCardNo = faceCardInfo.getStrCardNo();
        for (int i = 0; i < HCNetSDK.ACS_CARD_NO_LEN; i++)
        {
            struCardInfo.byCardNo[i] = 0;
        }
        for (int i = 0; i <  strCardNo.length(); i++)
        {
            struCardInfo.byCardNo[i] = strCardNo.getBytes()[i];
        }

        if(faceCardInfo.getType()=="ADD"){
            struCardInfo.byCardValid = 1;//卡是否有效：0-无效，1-有效
        }else if(faceCardInfo.getType()=="DEL"){
            struCardInfo.byCardValid = 0;//卡是否有效：0-无效，1-有效   ---删除设备人员
        }

        struCardInfo.byCardType =1;//卡类型：1-普通卡（默认）
        struCardInfo.byLeaderCard = 0;//是否为首卡：1-是，0-否
        struCardInfo.byDoorRight[0]  = 1; //门1有权限
        struCardInfo.wCardRightPlan[0].wRightPlan[0] = 1; //门1关联卡参数计划模板1

        String[] sStartTime  =  faceCardInfo.getStrStartTime().replace(" ","-").replace(":","-").split("-");
        String[] sEndTime    =  faceCardInfo.getStrEndTime().replace(" ","-").replace(":","-").split("-");

        //MyUtil.printfInfo("时间分割数组len : "+sStartTime.length+" "+sEndTime.length);

        //卡有效期
        struCardInfo.struValid.byEnable = 1;//使能有效期
        struCardInfo.struValid.struBeginTime.wYear   = Short.parseShort(sStartTime[0]);//开始时间：2019-01-01 00:00:00
        struCardInfo.struValid.struBeginTime.byMonth = Byte.parseByte(sStartTime[1]);
        struCardInfo.struValid.struBeginTime.byDay   = Byte.parseByte(sStartTime[2]);
        struCardInfo.struValid.struBeginTime.byHour  = Byte.parseByte(sStartTime[3]);
        struCardInfo.struValid.struBeginTime.byMinute = Byte.parseByte(sStartTime[4]);
        struCardInfo.struValid.struBeginTime.bySecond = Byte.parseByte(sStartTime[5]);

        struCardInfo.struValid.struEndTime.wYear    = Short.parseShort(sEndTime[0]);//结束时间：2030-01-01 00:00:00
        struCardInfo.struValid.struEndTime.byMonth  = Byte.parseByte(sEndTime[1]);
        struCardInfo.struValid.struEndTime.byDay    = Byte.parseByte(sEndTime[2]);
        struCardInfo.struValid.struEndTime.byHour   = Byte.parseByte(sEndTime[3]);
        struCardInfo.struValid.struEndTime.byMinute = Byte.parseByte(sEndTime[4]);
        struCardInfo.struValid.struEndTime.bySecond = Byte.parseByte(sEndTime[5]);

        struCardInfo.dwMaxSwipeTime = 0; //无次数限制
        struCardInfo.dwSwipeTime = 0;
        struCardInfo.byCardPassword = faceCardInfo.getStrCardPSW().getBytes();
        struCardInfo.dwEmployeeNo = faceCardInfo.getIEmployeeNo();

        //卡用户名
        byte[] strCardName = faceCardInfo.getStrCardUserName().getBytes("GBK");
        for (int i = 0; i < HCNetSDK.NAME_LEN; i++)
        {
            struCardInfo.byName[i] = 0;
        }
        for (int i = 0; i <  strCardName.length; i++)
        {
            struCardInfo.byName[i] = strCardName[i];
        }

        struCardInfo.write();
        Pointer pSendBufSet = struCardInfo.getPointer();

        if(!hCNetSDK.NET_DVR_SendRemoteConfig(lHandle, 0x3, pSendBufSet, struCardInfo.size()))
        {
            iErr = hCNetSDK.NET_DVR_GetLastError();
            MyUtil.printfInfo("ENUM_ACS_SEND_DATA失败，错误号：" + iErr);
            return;
        }

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        if(!hCNetSDK.NET_DVR_StopRemoteConfig(lHandle))
        {
            iErr = hCNetSDK.NET_DVR_GetLastError();
            MyUtil.printfInfo("断开长连接失败，错误号：" + iErr);
            return;
        }
        MyUtil.printfInfo("断开长连接成功!");
    }

    /**
     * 设置人脸参数
     * @param faceInfo
     */
    public  void setFaceInfo(FaceCardInfo faceInfo) {

        MyUtil.printfInfo("开始设置人脸参数");
        int iErr = 0;
        //设置人脸参数
        HCNetSDK.NET_DVR_FACE_PARAM_COND m_struFaceSetParam = new HCNetSDK.NET_DVR_FACE_PARAM_COND();
        m_struFaceSetParam.dwSize = m_struFaceSetParam.size();
        m_struFaceSetParam.byCardNo = faceInfo.getStrCardNo().getBytes(); //人脸关联的卡号
        m_struFaceSetParam.byEnableCardReader[0]  = 1;
        m_struFaceSetParam.dwFaceNum = 1;
        m_struFaceSetParam.byFaceID = 1;
        m_struFaceSetParam.write();

        Pointer lpInBuffer = m_struFaceSetParam.getPointer();

        Pointer pUserData = null;
        FRemoteCfgCallBackFaceSet fRemoteCfgCallBackFaceSet = new FRemoteCfgCallBackFaceSet();

        //建立长连接
        NativeLong lHandle = hCNetSDK.NET_DVR_StartRemoteConfig(faceInfo.getLUserID(), HCNetSDK.NET_DVR_SET_FACE_PARAM_CFG, lpInBuffer, m_struFaceSetParam.size(), fRemoteCfgCallBackFaceSet, pUserData);
        if (lHandle.intValue() < 0)
        {
            iErr = hCNetSDK.NET_DVR_GetLastError();
            MyUtil.printfInfo("建立长连接失败，错误号：" + iErr);
            return;
        }
        MyUtil.printfInfo("建立设置人脸参数长连接成功");

        HCNetSDK.NET_DVR_FACE_PARAM_CFG struFaceInfo = new HCNetSDK.NET_DVR_FACE_PARAM_CFG(); //卡参数
        struFaceInfo.read();
        struFaceInfo.dwSize = struFaceInfo.size();
        struFaceInfo.byCardNo = faceInfo.getStrCardNo().getBytes();
        struFaceInfo.byEnableCardReader[0] = 1; //需要下发人脸的读卡器，按数组表示，每位数组表示一个读卡器，数组取值：0-不下发该读卡器，1-下发到该读卡器
        struFaceInfo.byFaceID  =1; //人脸ID编号，有效取值范围：1~2
        struFaceInfo.byFaceDataType  = 1; //人脸数据类型：0- 模板（默认），1- 图片

        /*****************************************
         * 从本地文件里面读取JPEG图片二进制数据
         *****************************************/

        MyUtil.printfInfo("读取本地图片");
        FileInputStream picfile = null;
        int picdataLength = 0;
        try{
            picfile = new FileInputStream(new File(faceInfo.getStrPicPath()));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        try{
            picdataLength = picfile.available();
        } catch(IOException e1) {
            e1.printStackTrace();
        }
        MyUtil.printfInfo("图片长度"+picdataLength);
        if(picdataLength < 0)
        {
            MyUtil.printfInfo("input file dataSize < 0");
            return;
        }

        HCNetSDK.BYTE_ARRAY ptrpicByte = new HCNetSDK.BYTE_ARRAY(picdataLength);
        try {
            picfile.read(ptrpicByte.byValue);
        } catch (IOException e2) {
            e2.printStackTrace();
        }
        ptrpicByte.write();
        /**************************/

        struFaceInfo.dwFaceLen  = picdataLength;
        struFaceInfo.pFaceBuffer  = ptrpicByte.getPointer();

        struFaceInfo.write();
        Pointer pSendBufSet = struFaceInfo.getPointer();

        //ENUM_ACS_INTELLIGENT_IDENTITY_DATA = 9,  //智能身份识别终端数据类型，下发人脸图片数据
        if(!hCNetSDK.NET_DVR_SendRemoteConfig(lHandle, 0x9, pSendBufSet, struFaceInfo.size()))
        {
            iErr = hCNetSDK.NET_DVR_GetLastError();
            MyUtil.printfInfo("NET_DVR_SendRemoteConfig失败，错误号：" + iErr);
            return;
        }else{
            MyUtil.printfInfo("下发成功!");
        }

        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

        if(!hCNetSDK.NET_DVR_StopRemoteConfig(lHandle))
        {
            iErr = hCNetSDK.NET_DVR_GetLastError();
            MyUtil.printfInfo("断开长连接失败，错误号：" + iErr);
            return;
        }
        MyUtil.printfInfo("断开长连接成功!");

//        NativeLong lUserId = faceInfo.getLUserID();
//        logout(lUserId.intValue());
//        cleanUp();
//        System.out.println("结束");
    }
    /**
     * 获取卡参数
     * @param faceCardInfo
     * @throws UnsupportedEncodingException
     * @throws ParseException
     */
    public  void getCardInfo(FaceCardInfo faceCardInfo) throws UnsupportedEncodingException, ParseException {
        int iErr = 0;

        //设置卡参数
        HCNetSDK.NET_DVR_CARD_CFG_COND m_struCardInputParamSet = new HCNetSDK.NET_DVR_CARD_CFG_COND();
        m_struCardInputParamSet.read();
        m_struCardInputParamSet.dwSize = m_struCardInputParamSet.size();
        m_struCardInputParamSet.dwCardNum = 0xffffffff;
        m_struCardInputParamSet.byCheckCardNo = 1;


        Pointer lpInBuffer = m_struCardInputParamSet.getPointer();
        m_struCardInputParamSet.write();

        Pointer pUserData = null;
        FRemoteCfgCallBackCardSet fRemoteCfgCallBackCardSet = new FRemoteCfgCallBackCardSet();

        NativeLong lHandle = hCNetSDK.NET_DVR_StartRemoteConfig(faceCardInfo.getLUserID(), HCNetSDK.NET_DVR_GET_CARD_CFG_V50, lpInBuffer, m_struCardInputParamSet.size(), fRemoteCfgCallBackCardSet, pUserData);
        if (lHandle.intValue() < 0)
        {
            iErr = hCNetSDK.NET_DVR_GetLastError();
            MyUtil.printfInfo("建立卡参数长连接失败，错误号：" + iErr);
            return;
        }
        MyUtil.printfInfo("建立设置卡参数长连接成功!");

//        HCNetSDK.NET_DVR_CARD_CFG_V50 struCardInfo = new HCNetSDK.NET_DVR_CARD_CFG_V50(); //卡参数
//        struCardInfo.read();
//        struCardInfo.dwSize = struCardInfo.size();
//        struCardInfo.dwModifyParamType = 0x00000001 + 0x00000002 + 0x00000004 + 0x00000008 +
//                0x00000010 + 0x00000020 + 0x00000080 + 0x00000100 + 0x00000200 + 0x00000400 + 0x00000800;
//        /***
//         * #define CARD_PARAM_CARD_VALID       0x00000001  //卡是否有效参数
//         * #define CARD_PARAM_VALID            0x00000002  //有效期参数
//         * #define CARD_PARAM_CARD_TYPE        0x00000004  //卡类型参数
//         * #define CARD_PARAM_DOOR_RIGHT       0x00000008  //门权限参数
//         * #define CARD_PARAM_LEADER_CARD      0x00000010  //首卡参数
//         * #define CARD_PARAM_SWIPE_NUM        0x00000020  //最大刷卡次数参数
//         * #define CARD_PARAM_GROUP            0x00000040  //所属群组参数
//         * #define CARD_PARAM_PASSWORD         0x00000080  //卡密码参数
//         * #define CARD_PARAM_RIGHT_PLAN       0x00000100  //卡权限计划参数
//         * #define CARD_PARAM_SWIPED_NUM       0x00000200  //已刷卡次数
//         * #define CARD_PARAM_EMPLOYEE_NO      0x00000400  //工号
//         * #define CARD_PARAM_NAME             0x00000800  //姓名
//         */
//
//        //卡号
//        String strCardNo = faceCardInfo.getStrCardNo();
//        for (int i = 0; i < HCNetSDK.ACS_CARD_NO_LEN; i++)
//        {
//            struCardInfo.byCardNo[i] = 0;
//        }
//        for (int i = 0; i <  strCardNo.length(); i++)
//        {
//            struCardInfo.byCardNo[i] = strCardNo.getBytes()[i];
//        }
//
//
//        struCardInfo.byCardValid = 1;//卡是否有效：0-无效，1-有效
//        struCardInfo.byCardType =1;//卡类型：1-普通卡（默认）
//        struCardInfo.byLeaderCard = 0;//是否为首卡：1-是，0-否
//        struCardInfo.byDoorRight[0]  = 1; //门1有权限
//        struCardInfo.wCardRightPlan[0].wRightPlan[0] = 1; //门1关联卡参数计划模板1
//
//        String [] sStartTime  =  faceCardInfo.getStrStartTime().replace(" ","-").replace(":","-").split("-");
//        String [] sEndTime    =  faceCardInfo.getStrEndTime().replace(" ","-").replace(":","-").split("-");
//
//        //MyUtil.printfInfo("时间分割数组len : "+sStartTime.length+" "+sEndTime.length);
//
//        //卡有效期
//        struCardInfo.struValid.byEnable = 1;//使能有效期
//        struCardInfo.struValid.struBeginTime.wYear   = Short.parseShort(sStartTime[0]);//开始时间：2019-01-01 00:00:00
//        struCardInfo.struValid.struBeginTime.byMonth = Byte.parseByte(sStartTime[1]);
//        struCardInfo.struValid.struBeginTime.byDay   = Byte.parseByte(sStartTime[2]);
//        struCardInfo.struValid.struBeginTime.byHour  = Byte.parseByte(sStartTime[3]);
//        struCardInfo.struValid.struBeginTime.byMinute = Byte.parseByte(sStartTime[4]);
//        struCardInfo.struValid.struBeginTime.bySecond = Byte.parseByte(sStartTime[5]);
//
//        struCardInfo.struValid.struEndTime.wYear    = Short.parseShort(sEndTime[0]);//结束时间：2030-01-01 00:00:00
//        struCardInfo.struValid.struEndTime.byMonth  = Byte.parseByte(sEndTime[1]);
//        struCardInfo.struValid.struEndTime.byDay    = Byte.parseByte(sEndTime[2]);
//        struCardInfo.struValid.struEndTime.byHour   = Byte.parseByte(sEndTime[3]);
//        struCardInfo.struValid.struEndTime.byMinute = Byte.parseByte(sEndTime[4]);
//        struCardInfo.struValid.struEndTime.bySecond = Byte.parseByte(sEndTime[5]);
//
//        struCardInfo.dwMaxSwipeTime = 0; //无次数限制
//        struCardInfo.dwSwipeTime = 0;
//        struCardInfo.byCardPassword = faceCardInfo.getStrCardPSW().getBytes();
//        struCardInfo.dwEmployeeNo = faceCardInfo.getIEmployeeNo();
//
//        //卡用户名
//        byte[] strCardName = faceCardInfo.getStrCardUserName().getBytes("GBK");
//        for (int i = 0; i < HCNetSDK.NAME_LEN; i++)
//        {
//            struCardInfo.byName[i] = 0;
//        }
//        for (int i = 0; i <  strCardName.length; i++)
//        {
//            struCardInfo.byName[i] = strCardName[i];
//        }
//
//        struCardInfo.write();
//        Pointer pSendBufSet = struCardInfo.getPointer();
//
//        if(!hCNetSDK.NET_DVR_SendRemoteConfig(lHandle, 0x3, pSendBufSet, struCardInfo.size()))
//        {
//            iErr = hCNetSDK.NET_DVR_GetLastError();
//            MyUtil.printfInfo("ENUM_ACS_SEND_DATA失败，错误号：" + iErr);
//            return;
//        }
//
//        try {
//            Thread.sleep(1000);
//        } catch (InterruptedException e) {
//            // TODO Auto-generated catch block
//            e.printStackTrace();
//        }
//
//        if(!hCNetSDK.NET_DVR_StopRemoteConfig(lHandle))
//        {
//            iErr = hCNetSDK.NET_DVR_GetLastError();
//            MyUtil.printfInfo("断开长连接失败，错误号：" + iErr);
//            return;
//        }
        MyUtil.printfInfo("断开长连接成功!");
    }

    /**
     * 设置报警回调函数
     * @return
     */
    public   boolean setCallBack(){
        fMSFCallBack_V31 = new FMSGCallBack_V31();
        Pointer pUser = null;
        boolean bRet = hCNetSDK.NET_DVR_SetDVRMessageCallBack_V31(fMSFCallBack_V31, pUser);
        MyUtil.printfInfo(bRet?"设置回调函数成功":"设置回调函数失败 "+hCNetSDK.NET_DVR_GetLastError());
        return  bRet;
    }

    /**
     * 报警回调函数
     */
    public  class FMSGCallBack_V31 implements HCNetSDK.FMSGCallBack_V31 {
        public boolean invoke(NativeLong lCommand, HCNetSDK.NET_DVR_ALARMER pAlarmer, Pointer pAlarmInfo, int dwBufLen, Pointer pUser) {
            MyUtil.printfInfo("-------------------------------------");
            AlarmDataHandle(lCommand, pAlarmer, pAlarmInfo, dwBufLen, pUser);
            return true;
        }
    }

    /**
     * 报警回调处理函数
     * @param lCommand
     * @param pAlarmer
     * @param pAlarmInfo
     * @param dwBufLen
     * @param pUser
     */
    public   void AlarmDataHandle(NativeLong lCommand, HCNetSDK.NET_DVR_ALARMER pAlarmer, Pointer pAlarmInfo, int dwBufLen, Pointer pUser) {
        String sAlarmType = new String();
        String[] newRow = new String[3];
        //报警时间
        Date today = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String[] sIP = new String[2];

        sAlarmType = new String("lCommand=") + lCommand.intValue();
        //lCommand是传的报警类型
        switch (lCommand.intValue()) {

            case HCNetSDK.COMM_ALARM_ACS: //门禁主机报警信息
                HCNetSDK.NET_DVR_ACS_ALARM_INFO strACSInfo = new HCNetSDK.NET_DVR_ACS_ALARM_INFO();
                strACSInfo.write();
                Pointer pACSInfo = strACSInfo.getPointer();
                pACSInfo.write(0, pAlarmInfo.getByteArray(0, strACSInfo.size()), 0, strACSInfo.size());
                strACSInfo.read();
                newRow[0] = dateFormat.format(today);
                //报警类型
                newRow[1] = sAlarmType;
                //报警设备IP地址
                sIP = new String(pAlarmer.sDeviceIP).split("\0", 2);
                newRow[2] = sIP[0];
                switch (strACSInfo.dwMajor) {
                    case 0x5:
                        switch (strACSInfo.dwMinor) {
                            case 0x15:
                                //System.out.println(newRow[0] + "报警主类型:0x5,报警次类型0x15-门锁打开" + "-" + newRow[2]);
                                break;
                            case 0x16:
                                //System.out.println(newRow[0] + "报警主类型:0x5,报警次类型0x16-门锁关闭" + "-" + newRow[2]);
                                break;
                            case 0x4b:
                                MyUtil.printfInfo("人脸认证成功");
                                break;
                            case 0x4c:
                                MyUtil.printfInfo("人脸认证失败");
                                //System.out.println(newRow[0] + "报警主类型:0x5,报警次类型0x4b-人脸认证失败");
                                break;
                            default:
                                break;
                        }
                        break;
                    default:
                        break;
                }
                MyUtil.printfInfo("图片大小："+strACSInfo.dwPicDataLen);
                //抓拍图片
                if (strACSInfo.dwPicDataLen > 0) {

                    HCNetSDK.NET_DVR_ACS_EVENT_INFO tempInfo = strACSInfo.struAcsEventInfo;
                    //卡号
                    String strCardNo = new String(strACSInfo.struAcsEventInfo.byCardNo).trim();
                    MyUtil.printfInfo("报警时间:"+strACSInfo.struTime.toStringTime()+"  卡号"+strCardNo+"  设备IP "+sIP[0]
                            +" 工号 "+tempInfo.dwEmployeeNo);
                    String dip = sIP[0];
                    Map<String,Object> devMap = new HashMap<>();
                    devMap.put("dip",dip);
                    List<Device> deviceList = deviceService.queryConditionDev(devMap);
                    String devName = deviceList.get(0).getDname();


//                    SimpleDateFormat sf = new SimpleDateFormat("yyyyMMddHHmmss");
//                    String strDate = sf.format(new Date());
                    FileOutputStream fout;
                    try {

                        Date date = new Date();
                        String day = new SimpleDateFormat("yyyy-MM-dd").format(date);
                        String time = new SimpleDateFormat("HH:mm:ss").format(date);
//                        System.out.println("日期："+day+";"+time);
                        String dayTime = day.replaceAll("-","")+time.replaceAll(":","");
//                        System.out.println(dayTime);

                        //String filename = /*strDate*/ MyUtil.getUUID()+ "_ACS_card_" + new String(strACSInfo.struAcsEventInfo.byCardNo).trim() + ".jpg";
                        String filename =devName +"_" + dip + "_"+dayTime+ ".jpg";
                        String classPath = HkSetting.class.getResource("/").getPath();
                        String dirPath = classPath.substring(1,classPath.indexOf("WEB-INF/classes"))+"fileDir/faceImage/Capture/"+day+"/";
                        String cutPath = classPath.substring(1,classPath.indexOf("WEB-INF/classes"))+"fileDir/faceImage/Capture_cut/"+day+"/";
//                        String dirPath = classPath.substring(1,classPath.indexOf("classes"))+"fileDir/faceImage/Capture/"+day+"/";
//                        String cutPath = classPath.substring(1,classPath.indexOf("classes"))+"fileDir/faceImage/Capture_cut/"+day+"/";
                        MyUtil.mkDir(dirPath);  //创建人脸抓拍原图路径
                        MyUtil.mkDir(cutPath);  //创建人脸抓拍截图路径
                        fout = new FileOutputStream(dirPath+filename);
                        MyUtil.printfInfo("图片名称路径"+dirPath+filename);



                        //将字节写入文件
                        long offset = 0;
                        ByteBuffer buffers = strACSInfo.pPicData.getByteBuffer(offset, strACSInfo.dwPicDataLen);//pPicData:图片数据缓冲区
                        byte[] bytes = new byte[strACSInfo.dwPicDataLen]; //dwPicDataLen:图片数据大小
                        buffers.rewind();
                        buffers.get(bytes);
                        fout.write(bytes);
                        fout.close();

                        Map<String, String> map = hkMapper.getFaceAlarmInfo(strCardNo);

                        List<String> strList = new ArrayList<>();
                        String strImgPath = "fileDir/faceImage/Capture_cut/"+day+"/"+filename;

                        strList.add(strImgPath);
                        strList.add(strACSInfo.struTime.toStringTime());//时间

                        //抓拍图片裁剪
                        String str1 = dirPath+filename;
                        String str2 = cutPath+filename;
                        cutScaleSquare(str1, str2, 270, 41, 228,350);//原图URL,裁剪图URL,起始点X坐标,起始点Y坐标,裁剪图宽度,裁剪图高度

                        MyUtil.printfInfo("即将进入map!"+map);
                        if(map != null) {
                            MyUtil.printfInfo("map != null");
                            strList.add(tempInfo.dwEmployeeNo + "");//工号
                            strList.add(strCardNo);         //卡号
                            strList.add(map.get("name"));   //用户名
                            strList.add(map.get("dName"));  //部门门


                        } else {
                            MyUtil.printfInfo("map == null");
                            strList.add("0");
                            strList.add("0");
                            strList.add("认证失败");
                            strList.add("");
                        }
                        //获取实时表时间
                        List<HistoryFaceAlarm> historyFaceAlarmList = hkMapper.queryDate();
                        if(historyFaceAlarmList.size()>0){
                            String alarmTime = historyFaceAlarmList.get(0).getAlarmTime().substring(0,10);
                            SimpleDateFormat tempDate = new SimpleDateFormat("yyyy-MM-dd");
                            String datetime = tempDate.format(new java.util.Date());
                            System.out.println(alarmTime+ " ;"+datetime);
                            //判断数据表中时间与当前日期是否一致
                            if(!alarmTime.equals(datetime)){
                                //不一致，删除实时表中的所有记录
                                hkMapper.deleteRealRecord();
                            }
                        }
                        //将刷卡记录保存到实时信息表中和历史信息表中
                        Map<String,Object> mapRecord = new HashMap<>();
                        mapRecord.put("alarmTime",strACSInfo.struTime.toStringTime());
                        mapRecord.put("staffId",String.valueOf(tempInfo.dwEmployeeNo));
                        mapRecord.put("imagePath",strImgPath);
                        mapRecord.put("cardNo",strCardNo);
                        mapRecord.put("devIP",sIP[0]);
                        if(map != null) {
                            mapRecord.put("staffName",map.get("name"));
                        }else{
                            mapRecord.put("staffName","陌生人");
                        }

                        mapRecord.put("schoolId",deviceList.get(0).getSchoolId());
                        mapRecord.put("houseId",deviceList.get(0).getHouseId());
                        mapRecord.put("floorId",deviceList.get(0).getFloorId());
                        mapRecord.put("roomId",deviceList.get(0).getRoomId());
                        hkMapper.insertFaceAlarm(mapRecord);
                        hkMapper.insertHistoryFaceAlarm(mapRecord);

                        MyUtil.printfInfo("strList:" + strList);
                        JSONObject jsonWS = new JSONObject();
                        JSONObject json = new JSONObject();
                        List<HistoryFaceAlarm> list = staffService.queryRecord(json);
                        System.out.println("WebSocketSession："+MyWebSocketHander.webSocketList);
                        for(WebSocketSession use : MyWebSocketHander.webSocketList){
                            System.out.println("use:"+use);
                            jsonWS.put("id",list.get(0).getId());
                            jsonWS.put("staffId",list.get(0).getStaffId());
                            jsonWS.put("staffName",list.get(0).getStaffName());
                            jsonWS.put("cardNo",list.get(0).getCardNo());
                            jsonWS.put("alarmTime",list.get(0).getAlarmTime());
                            jsonWS.put("devIP",list.get(0).getDevIP());
                            jsonWS.put("dname",list.get(0).getDname());
                            jsonWS.put("imagePath",list.get(0).getImagePath());

                            //WebSocketUtil.sendMsgToCattleWS(jsonWS);

                            //String strMsg = strList.toString();
                            //use.sendMessage(new TextMessage(strMsg));
                            //MyUtil.printfInfo("webSocket 发送数据:"+strMsg);
                            WebSocketUtil.getInstance().sendJsonMsgToWeb(jsonWS,"/recordWSL");
                            MyUtil.printfInfo("webSocket 发送数据:"+jsonWS.toString());
                        }

                    } catch (FileNotFoundException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    } catch (IOException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                }
                break;
            case HCNetSDK.COMM_ID_INFO_ALARM: //身份证信息
                HCNetSDK.NET_DVR_ID_CARD_INFO_ALARM strIDCardInfo = new HCNetSDK.NET_DVR_ID_CARD_INFO_ALARM();
                strIDCardInfo.write();
                Pointer pIDCardInfo = strIDCardInfo.getPointer();
                pIDCardInfo.write(0, pAlarmInfo.getByteArray(0, strIDCardInfo.size()), 0, strIDCardInfo.size());
                strIDCardInfo.read();

                sAlarmType = sAlarmType + "：门禁身份证刷卡信息，身份证号码：" + new String(strIDCardInfo.struIDCardCfg.byIDNum).trim() + "，姓名：" +
                        new String(strIDCardInfo.struIDCardCfg.byName).trim() + "，报警主类型：" + strIDCardInfo.dwMajor + "，报警次类型：" + strIDCardInfo.dwMinor;

                newRow[0] = dateFormat.format(today);
                //报警类型
                newRow[1] = sAlarmType;
                //报警设备IP地址
                sIP = new String(pAlarmer.sDeviceIP).split("\0", 2);
                newRow[2] = sIP[0];
                System.out.println("8:" + newRow[0] + "/" + newRow[1] + "/" + newRow[2]);
                break;
            default:
                newRow[0] = dateFormat.format(today);
                //报警类型
                newRow[1] = sAlarmType;
                //报警设备IP地址
                sIP = new String(pAlarmer.sDeviceIP).split("\0", 2);
                newRow[2] = sIP[0];
                System.out.println("9:" + newRow[0] + "/" + newRow[1] + "/" + newRow[2]);
                break;
        }
    }
    public static final void cutScaleSquare(String srcImageFile, String result, int x, int y, int scaleWidth,int scaleHeight)
    {
        System.out.println("原图路径："+srcImageFile);
        System.out.println("结果图路径："+result);
        try
        {
            Image imageSrc = Toolkit.getDefaultToolkit().getImage(srcImageFile);
            BufferedImage bi = toBufferedImage(imageSrc);

            String imgType = srcImageFile
                    .substring(srcImageFile
                            .lastIndexOf(".") +
                            1);
            int srcWidth = bi.getHeight();//原图高
            int srcHeight = bi.getWidth();//原图宽
            MyUtil.printfInfo("原图高："+srcWidth);
            MyUtil.printfInfo("原图宽："+srcHeight);
            if ((srcWidth > 0) || (srcHeight > 0))
            {


                bi = bi.getSubimage(x, y, 228, 350);
                System.out.println(bi);


                double w = 0.0D;
                double h = 0.0D;
                BufferedImage tempImg = null;
                w = new Integer(scaleWidth).doubleValue() / bi
                        .getWidth();
                h = new Integer(scaleHeight).doubleValue() / bi
                        .getHeight();
                AffineTransformOp op = new AffineTransformOp(AffineTransform.getScaleInstance(w, h),
                        null);

                tempImg = op.filter(bi, null);
                ImageIO.write(tempImg, imgType, new File(result));
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }


    public static final BufferedImage toBufferedImage(Image image)
    {
        if ((image instanceof BufferedImage)) {
            return (BufferedImage)image;
        }

        image = new ImageIcon(image).getImage();
        BufferedImage bimage = null;

        GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
        try {
            int transparency = 1;
            GraphicsDevice gs = ge.getDefaultScreenDevice();
            GraphicsConfiguration gc = gs.getDefaultConfiguration();
            bimage = gc.createCompatibleImage(image.getWidth(null), image
                            .getHeight(null),
                    transparency);
        }
        catch (HeadlessException localHeadlessException) {
        }
        if (bimage == null)
        {
            int type = 1;

            bimage = new BufferedImage(image.getWidth(null), image
                    .getHeight(null),
                    type);
        }

        Graphics g = bimage.createGraphics();

        g.drawImage(image, 0, 0, null);
        g.dispose();
        return bimage;
    }


    /**
     * 人脸参数设置回调
     */
    public  class FRemoteCfgCallBackFaceSet implements HCNetSDK.FRemoteConfigCallback
    {
        public void invoke(int dwType, Pointer lpBuffer, int dwBufLen, Pointer pUserData)
        {
            MyUtil.printfInfo("长连接回调获取数据,NET_SDK_CALLBACK_TYPE_STATUS:" + dwType);
            switch (dwType){
                case 0:// NET_SDK_CALLBACK_TYPE_STATUS
                    HCNetSDK.REMOTECONFIGSTATUS_CARD struCfgStatus  = new HCNetSDK.REMOTECONFIGSTATUS_CARD();
                    struCfgStatus.write();
                    Pointer pCfgStatus = struCfgStatus.getPointer();
                    pCfgStatus.write(0, lpBuffer.getByteArray(0, struCfgStatus.size()), 0,struCfgStatus.size());
                    struCfgStatus.read();

                    int iStatus = 0;
                    for(int i=0;i<4;i++)
                    {
                        int ioffset = i*8;
                        int iByte = struCfgStatus.byStatus[i]&0xff;
                        iStatus = iStatus + (iByte << ioffset);
                    }

                    switch (iStatus){
                        case 1000:// NET_SDK_CALLBACK_STATUS_SUCCESS
                            MyUtil.printfInfo("下发人脸参数成功,dwStatus:" + iStatus);
                            break;
                        case 1001:
                            MyUtil.printfInfo("正在下发人脸参数中,dwStatus:" + iStatus);
                            break;
                        case 1002:
                            int iErrorCode = 0;
                            for(int i=0;i<4;i++)
                            {
                                int ioffset = i*8;
                                int iByte = struCfgStatus.byErrorCode[i]&0xff;
                                iErrorCode = iErrorCode + (iByte << ioffset);
                            }
                            MyUtil.printfInfo("下发人脸参数失败, dwStatus:" + iStatus + "错误号:" + iErrorCode);
                            break;
                    }
                    break;
                case 2:// 获取状态数据
                    HCNetSDK.NET_DVR_FACE_PARAM_STATUS  m_struFaceStatus = new HCNetSDK.NET_DVR_FACE_PARAM_STATUS();
                    m_struFaceStatus.write();
                    Pointer pStatusInfo = m_struFaceStatus.getPointer();
                    pStatusInfo.write(0, lpBuffer.getByteArray(0, m_struFaceStatus.size()), 0,m_struFaceStatus.size());
                    m_struFaceStatus.read();
                    String str = new String(m_struFaceStatus.byCardNo).trim();
                    MyUtil.printfInfo("下发人脸数据关联的卡号:" + str + ",人脸读卡器状态:" +
                            m_struFaceStatus.byCardReaderRecvStatus[0] + ",错误描述:" + new String(m_struFaceStatus.byErrorMsg).trim());
                default:
                    break;
            }
        }
    }

    /**
     * 卡参数设置回调
     */
    public  class FRemoteCfgCallBackCardSet implements HCNetSDK.FRemoteConfigCallback
    {
        public void invoke(int dwType, Pointer lpBuffer, int dwBufLen, Pointer pUserData)
        {
            MyUtil.printfInfo("长连接回调获取数据,NET_SDK_CALLBACK_TYPE_STATUS:" + dwType);
            switch (dwType){
                case 0:// NET_SDK_CALLBACK_TYPE_STATUS
                    HCNetSDK.REMOTECONFIGSTATUS_CARD struCardStatus = new HCNetSDK.REMOTECONFIGSTATUS_CARD();
                    struCardStatus.write();
                    Pointer pInfoV30 = struCardStatus.getPointer();
                    pInfoV30.write(0, lpBuffer.getByteArray(0, struCardStatus.size()), 0,struCardStatus.size());
                    struCardStatus.read();

                    int iStatus = 0;
                    for(int i=0;i<4;i++)
                    {
                        int ioffset = i*8;
                        int iByte = struCardStatus.byStatus[i]&0xff;
                        iStatus = iStatus + (iByte << ioffset);
                    }

                    switch (iStatus){
                        case 1000:// NET_SDK_CALLBACK_STATUS_SUCCESS
                            MyUtil.printfInfo("下发卡参数成功,dwStatus:" + iStatus);
                            break;
                        case 1001:
                            MyUtil.printfInfo("正在下发卡参数中,dwStatus:" + iStatus);
                            break;
                        case 1002:
                            int iErrorCode = 0;
                            for(int i=0;i<4;i++)
                            {
                                int ioffset = i*8;
                                int iByte = struCardStatus.byErrorCode[i]&0xff;
                                iErrorCode = iErrorCode + (iByte << ioffset);
                            }
                            MyUtil.printfInfo("下发卡参数失败, dwStatus:" + iStatus + "错误号:" + iErrorCode);//NET_DVR_GetLastError ：  1920：不支持一人多卡
                            break;
                    }
                    break;
                default:
                    break;
            }
        }
    }

}