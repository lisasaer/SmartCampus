package com.zy.SmartCampus.ZigBeeConnect;


import com.zy.SmartCampus.polo.ZigBeeGatewayDevInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.OutputStream;
import java.net.Socket;


public class TCPMsgUtil {
    public static Logger logger = LoggerFactory.getLogger(TCPMsgUtil.class);

    public static String startJoinNetwork = "开始加网";
    public static String stopJoinNetwork = "停止加网";
    public static String queryAllDevInfo = "查询所有设备信息";
    public static String queryOneDevInfo = "查询指定设备信息";
    public static String addDev = "设备新增";//新设备注册回复
    public static String delDev = "设备删除";//设备退网
    public static String ctrlDevOpen = "控制设备打开";//1.控制智能插座(上电)2.控制开关面板(打开)
    public static String ctrlDevClose = "控制设备关闭";//1.控制智能插座(断电)2.控制开关面板(关闭)
    public static String ctrlCurtainMotor = "控制窗帘电机";
    public static String ctrlCurtainMotorModel = "控制窗帘电机面板";
    public static String setCurtainMotorPercentage = "设置窗帘电机百分比";
    public static String ctrlInfraredRelayLearn = "控制红外转发器学习";
    public static String ctrlInfraredRelayCtrl = "控制红外转发器控制";
    public static String updDevName = "修改设备名称";
    public static String sendPassThroughMsg = "发送透传设备命令";
    public static String passThroughMsg = "";


    /**
     * 服务器主动向网关发送命令
     *
     * @param type                 命令类型
     * @param zigBeeGatewayDevInfo 设备信息
     * @return
     */

    public static void sendTCPMsg(String type, ZigBeeGatewayDevInfo zigBeeGatewayDevInfo) {
        Boolean isSendSuccess = false;

        String strDevId = zigBeeGatewayDevInfo.getDevId();
        String strDid = zigBeeGatewayDevInfo.getDid();
        String strDn = zigBeeGatewayDevInfo.getDn();
        String strMsg = "";

        if (type.equals(startJoinNetwork)) {
            //开始加网
            strMsg = "{\"code\":1002,\"id\":\"00ffffffffffffffffff\",\"ep\":1,\"serial\":1,\"control\":{\"pmtjn\":120}}";
        }
        if (type.equals(stopJoinNetwork)) {
            //停止加网
            strMsg = "{\"code\":1002,\"id\":\"00ffffffffffffffffff\",\"ep\":1,\"serial\":1,\"control\":{\"pmtjn\":0}}";
        }
        if (type.equals(queryAllDevInfo)) {
            //查询所有设备信息
            strMsg = "{\"code\" :1007,\"serial\": 11111}";
        }
        if (type.equals(queryOneDevInfo)) {
            //查询指定设备信息
            String strEp = zigBeeGatewayDevInfo.getEp();
            strMsg = "{\"code\" :1007,\"serial\": 11111,\"device\": [{\"id\": \"" + strDevId + "\",\"ep\": \"" + strEp + "\"}]}";
        }
        if (type.equals(addDev)) {
            //设备新增
            strMsg = "{\"code\" :1005,\"check_list\" :[{\"id\" : \"" + strDevId + "\",\"control\" : 0}],\"result\" :0}";
        }
        if (type.equals(delDev)) {
            //设备删除
            strMsg = "{\"code\":1003,\"id\":\"" + strDevId + "\",\"serial\":1}";
        }
        if (type.equals(ctrlDevOpen)) {
            //控制设备打开
            String strEp = zigBeeGatewayDevInfo.getEp();
            strMsg = "{\"code\":1002,\"id\":\"" + strDevId + "\", \"ep\": " + strEp + ",\"pid\": 260,\"did\": " + strDid + ",\"serial\": 12004, \"control\":{\"on\":true}}";
        }
        if (type.equals(ctrlDevClose)) {
            //控制设备关闭
            String strEp = zigBeeGatewayDevInfo.getEp();
            strMsg = "{\"code\":1002,\"id\":\"" + strDevId + "\", \"ep\": " + strEp + ",\"pid\": 260,\"did\": " + strDid + ",\"serial\": 12004, \"control\":{\"on\":false}}";
        }
        if (type.equals(ctrlCurtainMotor)) {
            //控制窗帘电机
            String strCts = zigBeeGatewayDevInfo.getSt().getCts();
            strMsg = "{\"code\":1002,\"id\":\"" + strDevId + "\",\"ep\":1,\"serial\":1,\"control\":{\"cts\":" + strCts + "}}";
        }
        if (type.equals(setCurtainMotorPercentage)) {
            //设置窗帘电机百分比
            String strPt = zigBeeGatewayDevInfo.getSt().getPt();
            if (strPt.equals("")) return;//pt为空，不发送命令
            strMsg = "{\"code\":1002,\"id\":\"" + strDevId + "\",\"ep\":1,\"serial\":1,\"control\":{\"pt\":" + strPt + "}}";
        }
        if (type.equals(ctrlInfraredRelayLearn)) {
            //控制红外转发器学习
            String strInle = zigBeeGatewayDevInfo.getSt().getInle();
            String strIndsp = zigBeeGatewayDevInfo.getSt().getIndsp();
            strMsg = "{\"code\":1002,\"id\":\"" + strDevId + "\",\"ep\":1,\"serial\":1,\"control\":{\"inle\":" + strInle + ",\"indsp\":\"" + strIndsp + "\"}}";
        }
        if (type.equals(ctrlInfraredRelayCtrl)) {
            //控制红外转发器控制
            String strInct = zigBeeGatewayDevInfo.getSt().getInct();
            strMsg = "{\"code\":1002,\"id\":\"" + strDevId + "\",\"ep\":1,\"serial\":1,\"control\":{\"inct\":" + strInct + "}}";
        }
        if (type.equals(updDevName)) {
            //修改设备名称
            strMsg = "{\"code\":1002,\"id\":\"" + strDevId + "\", \"ep\": 11,\"pid\": 49246,\"did\": " + strDid + ",\"serial\": 12004,\"control\":{\"dn\":\"" + strDn + "\" } }";
        }
        if (type.equals(sendPassThroughMsg)) {
            //发送透传设备命令  ep:1  pid:260 serial:1
            strMsg = "{\"code\":1002,\"id\":\"" + strDevId + "\", \"ep\": 1,\"pid\": 260,\"did\": " + strDid + ",\"serial\": 1,\"control\":{\"kyraw\":\"" + passThroughMsg + "\" } }";
        }

        //服务器向网关发送消息   2021-0726-dzb 改
//        OutputStream outputStream = null;
//        try {
//
//            if (TCPServer.socket != null) {
//                Socket socket = TCPServer.socket;
//                outputStream = socket.getOutputStream();
//                outputStream.write(strMsg.getBytes());
//                isSendSuccess = true;
//            } else {
////                Toast.makeText(MyApplication.getContext(),"网络错误！",Toast.LENGTH_SHORT).show();
//                System.out.println("网络错误！");
//            }
//        } catch (IOException e) {
//            e.printStackTrace();
//
//        }

        if (isSendSuccess) {
            logger.info(type + "---命令发送成功");
        } else {
            logger.info(type + "---命令发送失败");
//            Toast.makeText(MyApplication.getContext(),"网络错误！",Toast.LENGTH_SHORT).show();
        }
    }
}
