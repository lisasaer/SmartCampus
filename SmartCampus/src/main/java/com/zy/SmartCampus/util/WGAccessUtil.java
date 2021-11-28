package com.zy.SmartCampus.util;

//import com.sun.xml.internal.xsom.impl.scd.Iterators;
import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.controller.WGAccessDevCtrl;
import com.zy.SmartCampus.listener.MyListener;
import com.zy.SmartCampus.lorasearch.BeanContext;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.service.*;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.IOException;
import java.math.BigInteger;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import static com.zy.SmartCampus.listener.MyListener.datagramSocket;

//微耕门禁通讯工具类 wpp 2020-3-26
public class WGAccessUtil{

    private static final int PORT = 60006;
    public static List<WGAccessDevInfo> devList = new ArrayList<>();//搜索出来的设置
    private static DatagramSocket datagramSocket;
    @Autowired
    private static WGAccessDevService wgAccessDevService;

    public static void wgAccessUDPOpen()throws Exception{
        String ip = InetAddress.getLocalHost().getHostAddress();
        byte[] ipArray = getLocalAddressIP(ip);
        try {
            datagramSocket = new DatagramSocket(PORT);
            System.out.println("udp服务端已经启动！");
        } catch (Exception e) {
            datagramSocket = null;
            System.out.println("udp服务端启动失败！");
            e.printStackTrace();
        }
    }

    public static DatagramSocket getDatagramSocket(){
        DatagramSocket socket = datagramSocket;
        return socket;
    }


    //线程开启和门禁的通讯
//    public static void wgAccessUDPOpen(List<WGAccessDevInfo> wgList) throws Exception{
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//        String ip = InetAddress.getLocalHost().getHostAddress();
//
//        byte[] ipArray = getLocalAddressIP(ip);
//        new Thread(new Runnable() {
//            private final int PORT = 60001;
//            //private DatagramSocket datagramSocket;
//            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//            String ip = InetAddress.getLocalHost().getHostAddress();
//            byte[] ipArray = getLocalAddressIP(ip);
//
//            @SneakyThrows
//            @Override
//            public void run() {
//
//                try {
//                    datagramSocket = new DatagramSocket(PORT);
//                    System.out.println("udp服务端已经启动！");
//                } catch (Exception e) {
//                    datagramSocket = null;
//                    System.out.println("udp服务端启动失败！");
//                    e.printStackTrace();
//                }
//
//                for(int i = 0;i<wgList.size();i++){
//                    WGAccessDevInfo dev = wgList.get(i);
//                    String devSN = dev.getDevSN();
//                    //转16进制
//                    byte[] devSNByteArray = getDevSNToByteArray(devSN);
//                    byte[] ipByteArray = getLocalAddressIP(dev.getIp());
//                    byte[] sendByte = new byte[64];
////
//                    sendByte[0] = 0x17;
//                    sendByte[1] =(byte) 0x90;
//                    sendByte[2] = 0x00;
//                    sendByte[3] = 0x00;
//                    //控制器id
//                    sendByte[4] = devSNByteArray[0];
//                    sendByte[5] = devSNByteArray[1];
//                    sendByte[6] = devSNByteArray[2];
//                    sendByte[7] = devSNByteArray[3];
//                    //ip
//                    sendByte[8] = ipArray[0];
//                    sendByte[9] = ipArray[1];
//                    sendByte[10] = ipArray[2];
//                    sendByte[11] = ipArray[3];
//
////                    sendByte[8] = (byte) 0xC0;
////                    sendByte[9] = (byte) 0xA8;
////                    sendByte[10] = (byte) 0x00;
////                    sendByte[11] = (byte) 0x24;
//                    //通信端口号
//                    sendByte[12] = (byte) 0x61;
//                    sendByte[13] = (byte) 0xEA;
//
//                    DatagramPacket sendPacket = new DatagramPacket(sendByte, sendByte.length,InetAddress.getByName(dev.getIp()),60000);
//
//                    try {
//                        datagramSocket.send(sendPacket);
//                        Thread.sleep(500);
//                        //datagramSocket.close();
//
//                    } catch (IOException ex) {
//                        ex.printStackTrace();
//                    }
//
//                }
//                System.out.println("发送完毕");
//
//                byte[] receBuf = new byte[1024];
//                DatagramPacket recePacket = new DatagramPacket(receBuf, receBuf.length);
//
//                while (true){
//                    datagramSocket.receive(recePacket);//阻塞
//                    String receStr = new String(recePacket.getData(), 0 , recePacket.getLength(),"utf-8");
//                    //System.out.println("接收:"+receStr.length());
//                    //System.out.println(receStr);
//
//                    byte[] recvBuf = new byte[1024];
//                    recvBuf = recePacket.getData();
//                    int[] dataFormat=new int[1024];
//                    for(int i=0;i<recvBuf.length;i++){//对byte数组中的数据进行判断，当为负数时，与0xff相与，并存放在Int数组中，可以保证数据正常
//                        if(recvBuf[i]<0){
//                            dataFormat[i]=recvBuf[i]&0xff;
//                        }else{
//                            dataFormat[i]=recvBuf[i];
//                        }
//                    }
//
//                    //功能号
//                    int  FunctionNum = dataFormat[1];
//                    String strFunctionNum = Integer.toHexString(FunctionNum);
//
//                    switch (Integer.parseInt(strFunctionNum)){
//                        case WG_SERVERIP_FUNCTIONID:
//                            int a8 = dataFormat[8];
//                            if(a8==1){
//                                System.out.println("服务器设置成功,当前服务器ip："+ip);
//                            }
//                            else{
//                                System.out.println("服务器设置失败");
//                            }
//                            break;
//                        case WG_SEARCH_FUNCTIONID:
//                            String IP = dataFormat[8]+"."+dataFormat[9]+"."+dataFormat[10]+"."+dataFormat[11];
//                            long DevSN = getNumUtil(dataFormat[4],dataFormat[5],dataFormat[6],dataFormat[7]);
//
//                            WGAccessDevInfo dev = new WGAccessDevInfo();
//                            dev.setIp(IP);
//                            dev.setDevSN(DevSN+"");
//                            dev.setNetmask(dataFormat[12]+"."+dataFormat[13]+"."+dataFormat[14]+"."+dataFormat[15]);
//                            dev.setDefaultGateway(dataFormat[16]+"."+dataFormat[17]+"."+dataFormat[18]+"."+dataFormat[19]);
//                            dev.setMACAddress(Integer.toHexString(dataFormat[20])+"-"+Integer.toHexString(dataFormat[21])+"-"+Integer.toHexString(dataFormat[22])+"-"+Integer.toHexString(dataFormat[23])+"-"+Integer.toHexString(dataFormat[24])+"-"+Integer.toHexString(dataFormat[25]));
//                            dev.setDriverVerID(Integer.toHexString(dataFormat[26])+"."+Integer.toHexString(dataFormat[27]));
//                            dev.setVerDate(Integer.toHexString(dataFormat[28])+""+Integer.toHexString(dataFormat[29])+"-"+Integer.toHexString(dataFormat[30])+"-"+Integer.toHexString(dataFormat[31]));
//                            dev.setPort(60000);
//                            dev.setOnLine(1);//默认在线
//
//                            System.out.println("设备搜索:"+dev.toString());
//                            if(devList.contains(dev)){
//                                break;
//                            }
//                            devList.add(dev);
//
//                        case WG_SEARCHCONTROLL_FUNCTIONID:
//                            System.out.println(sdf.format(new Date())+"接收刷新信息----------------------");
//                            //卡号
////                            int s1 = dataFormat[16];
////                            int s2 = dataFormat[17];
////                            int s3 = dataFormat[18];
////                            int s4 = dataFormat[19];
//
////                            int a1=dataFormat[4];
////                            int a2=dataFormat[5];
////                            int a3=dataFormat[6];
////                            int a4=dataFormat[7];
//
//                            //刷卡类型 0.0=无记录 1=刷卡记录 2=门磁,按钮, 设备启动, 远程开门记录 3=报警记录
////                            int type = dataFormat[12];
////
////                            //0 表示不通过, 1表示通过
////                            int isPass = dataFormat[13];
////
////                            //门号 1,2,3,4
////                            int doorID = dataFormat[14];
////
////                            //进门出门  1表示进门, 2表示出门
////                            int doorDirection = dataFormat[15];
//
//                            //刷卡时间
//                            String timeYear = dataFormat[20]+""+dataFormat[21];
//                            int timeMonth = dataFormat[22];
//                            int timeDay = dataFormat[23];
//                            int timeHour = dataFormat[24];
//                            int timeMinute = dataFormat[25];
//                            int timeSecond = dataFormat[26];
//
//
//                            long cardNo = getNumUtil(dataFormat[16],dataFormat[17],dataFormat[18],dataFormat[19]);
//                            long DevSNC = getNumUtil(dataFormat[4],dataFormat[5],dataFormat[6],dataFormat[7]);
//                            System.out.println("卡号:"+cardNo+"---"+"控制器SN:"+DevSNC+"---"+(dataFormat[13] == 0?"不通过":"通过")+" "+"---门号"+dataFormat[14]+"---方向："+(dataFormat[15] == 1?"进":"出"));
//
//                            WGAccessOpenDoor wgAccessOpenDoor = new WGAccessOpenDoor();
//                            wgAccessOpenDoor.setCardID(cardNo+"");  //卡号
//                            wgAccessOpenDoor.setCtrlerID(DevSNC+"");//控制器id
//                            wgAccessOpenDoor.setIsPass(dataFormat[13]);  //0 表示不通过, 1表示通过
//                            wgAccessOpenDoor.setDoorID(dataFormat[14]);  //门号 1,2,3,4
//                            wgAccessOpenDoor.setDirection(dataFormat[15]);//进门出门  1表示进门, 2表示出门
//                            //wgAccessOpenDoor.setDoorDateTime(timeYear+"-"+timeMonth+"-"+timeDay+" "+timeHour+":"+timeMinute+":"+timeSecond);
//                            saveOpenDoorRecord(wgAccessOpenDoor);
//                            break;
//                            default:break;
//
//                    }
//                }
//            }
//        }).start();
//    }

    //微耕门禁设备搜索-广播
    public static void wgAccessUDPSearch(DatagramSocket datagramSocket) throws Exception{

        String host = "255.255.255.255";//广播地址

        byte[] bt = new byte[64];
        bt[0] = 0x17;
        bt[1] =(byte) 0x94;
        bt[2] = 0x00;
        bt[3] = 0x00;
        //控制器id
        bt[4] = 0x00;
        bt[6] = 0x00;
        bt[5] = 0x00;
        bt[7] = 0x00;

        DatagramPacket sendPacket = new DatagramPacket(bt, bt.length, InetAddress.getByName(host),60000);
        datagramSocket.send(sendPacket);
    }

    //发送门设置命令方法
    public static void sendDoorSet(WGAccessDoorInfo wgAccessDoorInfo)throws InterruptedException, UnknownHostException {
        //System.out.println(wgAccessDoorInfo);
        wgAccessDevService= BeanContext.getBean(WGAccessDevService.class);
        JSONObject json =new JSONObject();
        json.put("ctrlerSN",wgAccessDoorInfo.getCtrlerSN());
        WGAccessDevInfo dev = wgAccessDevService.queryWGAccessDevInfoByJSON(json).get(0);
        String ctrlerSN = dev.getCtrlerSN();
        //转16进制
        byte[] devSNByteArray =  WGAccessUtil.getDevSNToByteArray(ctrlerSN);
        byte[] ipByteArray =  WGAccessUtil.getLocalAddressIP(dev.getIp());
        byte[] sendByte = new byte[64];
        byte[] doorNoArray = WGAccessUtil.getNumber(wgAccessDoorInfo.getDoorID().substring(9,10));
        //System.out.println(doorNoArray[0]);
        byte[] ctrlWayArray = WGAccessUtil.getNumber(wgAccessDoorInfo.getDoorCtrlWay());
        byte[] delayArray = WGAccessUtil.getNumber(wgAccessDoorInfo.getDoorDelay());
//
        sendByte[0] = 0x17;
        sendByte[1] =(byte) 0x80;
        sendByte[2] = 0x00;
        sendByte[3] = 0x00;
        //控制器SN
        sendByte[4] = devSNByteArray[0];
        sendByte[5] = devSNByteArray[1];
        sendByte[6] = devSNByteArray[2];
        sendByte[7] = devSNByteArray[3];

        sendByte[8] = doorNoArray[0];//设置的门号码
        sendByte[9] = ctrlWayArray[0];//控制方式（在线、常开、常关）
        sendByte[10] = delayArray[0];//开门延时

        System.out.println(String.format("发送目标序列号："+"%02x",sendByte[4])+" "+String.format("%02x",sendByte[5])+" "+String.format("%02x",sendByte[6])+" "+String.format("%02x",sendByte[7]));
        System.out.println(String.format("发送的主要信息："+"%02x",sendByte[8])+" "+String.format("%02x",sendByte[9])+" "+String.format("%02x",sendByte[10]));
        try {
            DatagramPacket sendPacket = new DatagramPacket(sendByte, sendByte.length, InetAddress.getByName(dev.getIp()),60000);
            datagramSocket=MyListener.datagramSocket;
            datagramSocket.send(sendPacket);
            MyUtil.printfInfo("向"+dev.getIp()+"发送的请求数据"+sendByte);
            Thread.sleep(500);
            //datagramSocket.close();

        } catch (IOException ex) {
            ex.printStackTrace();
        }
        System.out.println("发送完毕");
    }

    //发送权限下发命令方法
    @Autowired
    private static DeviceService deviceService;
    @Autowired
    public static WgPermissionService wgPermissionService;
    private static int count=0;
    public static void sendAddPerssion(CardDeviceBean cardDeviceBean)throws InterruptedException,UnknownHostException{
        deviceService=BeanContext.getBean(DeviceService.class);
        wgPermissionService=BeanContext.getBean(WgPermissionService.class);
        MyUtil.printfInfo("开始下发权限");
        MyUtil.printfInfo("卡数量:"+cardDeviceBean.getCards().size()+" 设备数量:"+cardDeviceBean.getDevices().size());
        for(CardDeviceBean.DeviceVo deviceVo : cardDeviceBean.getDevices()){
            for(CardDeviceBean.CardVo cardVo : cardDeviceBean.getCards()){
                int iDevID = Integer.parseInt(String.valueOf(deviceVo.getValue()).substring(0,9));
                System.out.println("微耕门禁设备序列号  "+iDevID);

                try{
                    datagramSocket = MyListener.datagramSocket;
                    String ip = deviceService.getWgDevIPByID(deviceVo.getValue());
                    byte[] CardIdArray = WGAccessUtil.getCardId(cardVo.getCardId());

                    String devSN =String.valueOf(deviceVo.getValue()).substring(0,9);
                    String door =String.valueOf(deviceVo.getValue()).substring(9,10);
                    //转16进制
                    byte[] devSNByteArray =  WGAccessUtil.getDevSNToByteArray(devSN);
                    byte[] sendByte = new byte[64];

                    sendByte[0] = 0x17;
                    sendByte[1] =(byte) 0x50;
                    sendByte[2] = 0x00;
                    sendByte[3] = 0x00;
                    //控制器SN
                    sendByte[4] = devSNByteArray[0];
                    sendByte[5] = devSNByteArray[1];
                    sendByte[6] = devSNByteArray[2];
                    sendByte[7] = devSNByteArray[3];
                    //卡号
                    sendByte[8] = CardIdArray[0];
                    sendByte[9] = CardIdArray[1];
                    sendByte[10] = CardIdArray[2];
                    sendByte[11] = CardIdArray[3];

                    //开始时间
                    sendByte[12] = 0x20;
                    sendByte[13] = 0x10;
                    sendByte[14] = 0x01;
                    sendByte[15] = 0x01;
                    //截止时间
                    sendByte[16] = 0x20;
                    sendByte[17] = 0x21;
                    sendByte[18] = 0x01;
                    sendByte[19] = 0x01;
                    //允许通过当前控制器的门
                    int index=19+Integer.valueOf(door);
                    sendByte[index] = 0x01;
                    //System.out.println("门 "+door);
                    DatagramPacket sendPacket = new DatagramPacket(sendByte, sendByte.length, InetAddress.getByName(ip),60000);
                    datagramSocket.send(sendPacket);

                    int[] dataFormat=new int[1024];

                    byte[] recvBuf = new byte[1024];
                    recvBuf = sendPacket.getData();
                    for(int i=0;i<recvBuf.length;i++){//对byte数组中的数据进行判断，当为负数时，与0xff相与，并存放在Int数组中，可以保证数据正常
                        if(recvBuf[i]<0){
                            dataFormat[i]=recvBuf[i]&0xff;
                        }else{
                            dataFormat[i]=recvBuf[i];
                        }
                    }
                    /*for (int i=0;i<sendByte.length;i++){
                        if (String.valueOf(sendByte[i]).length() == 1) {
                            System.out.println("0"+sendByte[i]);
                        }else {
                            System.out.println(sendByte[i]);
                        }
                    }*/
                    MyUtil.printfInfo("向"+ip+"发送的请求数据");
                    MyUtil.printfInfo("功能代码："+String.format("%02x",dataFormat[1]));
                    MyUtil.printfInfo("设备序列号："+devSN);
                    MyUtil.printfInfo("增加卡号："+cardVo.getCardId());
                    MyUtil.printfInfo("开始时间："+dataFormat[12]+" "+dataFormat[13]+" "+dataFormat[14]+" "+dataFormat[15]);
                    MyUtil.printfInfo("截止时间："+dataFormat[16]+" "+dataFormat[17]+" "+dataFormat[18]+" "+dataFormat[19]);
                    MyUtil.printfInfo("允许通过门："+dataFormat[20]+" "+dataFormat[21]+" "+dataFormat[22]+" "+dataFormat[23]);

                    Thread.sleep(500);
                    //datagramSocket.close();
                    //判断是否重复添加
                    JSONObject jsonPermission=new JSONObject();
                    jsonPermission.put("cardNo",cardVo.getCardId());
                    jsonPermission.put("wgSNAndDoorID",deviceVo.getValue());
                    PermissionInfo permissionInfo=wgPermissionService.getWGPermissionforExist(jsonPermission);
                    if(permissionInfo==null){
                        wgPermissionService.addWgPermission(cardVo.getCardId(),deviceVo.getValue());
                    }

                    count++;
                } catch (IOException ex) {
                    ex.printStackTrace();
                }
            }
            System.out.println("发送完毕");
            //根据设备的ID获取到设备IP，并获取到当前设备
                /*LoginDevInfo loginDevInfo = WgSetting.getLoginWgDevInfoByDevID(deviceService.getWgDevIPByID(String.valueOf(iDevID)));//hkService.getLoginDevInfoByDevID(iDevID);
                if(loginDevInfo != null){//如果设备存在
                    *//*FaceCardInfo faceCardInfo = new FaceCardInfo(loginDevInfo.getLUserID(),cardVo.getCardId(),
                            "2019-01-01 00:00:00","2030-01-01 00:00:00","888888",
                            Integer.parseInt(cardVo.getValue()),cardVo.getTitle(),MyUtil.getWEBINFPath()+cardVo.getPhoto(),"ADD");   //工号    持卡人姓名   图片地址
                    hkService.setCardAndFaceInfo(faceCardInfo);*//*
                    //wgPermissionService.addWgPermission(cardVo.getCardId(),deviceVo.getValue());
                    Thread.sleep(500);
                }else {
                    MyUtil.printfInfo("无该注册成功信息");
                }*/
        }
        System.out.println("下发权限数：     "+count);
        count=0;
    }

    //删除个人的全部普通门禁权限
    public static void sendDelOnePerssion(String cardNo,String wgSNAndDoorID)throws InterruptedException{
        deviceService=BeanContext.getBean(DeviceService.class);
        wgPermissionService=BeanContext.getBean(WgPermissionService.class);
        try{
            datagramSocket = MyListener.datagramSocket;
            String devSN = wgSNAndDoorID.substring(0,9);
            String ip = deviceService.getWgDevIPByID(wgSNAndDoorID);
            byte[] CardIdArray = WGAccessUtil.getCardId(cardNo);


            //转16进制
            byte[] devSNByteArray =  WGAccessUtil.getDevSNToByteArray(devSN);
            byte[] sendByte = new byte[64];
            //
            sendByte[0] = 0x17;
            sendByte[1] =(byte) 0x52;
            sendByte[2] = 0x00;
            sendByte[3] = 0x00;
            //控制器SN
            sendByte[4] = devSNByteArray[0];
            sendByte[5] = devSNByteArray[1];
            sendByte[6] = devSNByteArray[2];
            sendByte[7] = devSNByteArray[3];
            //卡号
            sendByte[8] = CardIdArray[0];
            sendByte[9] = CardIdArray[1];
            sendByte[10] = CardIdArray[2];
            sendByte[11] = CardIdArray[3];


            DatagramPacket sendPacket = new DatagramPacket(sendByte, sendByte.length, InetAddress.getByName(ip),60000);
            datagramSocket.send(sendPacket);

            int[] dataFormat=new int[1024];

            byte[] recvBuf = new byte[1024];
            recvBuf = sendPacket.getData();
            for(int i=0;i<recvBuf.length;i++){//对byte数组中的数据进行判断，当为负数时，与0xff相与，并存放在Int数组中，可以保证数据正常
                if(recvBuf[i]<0){
                    dataFormat[i]=recvBuf[i]&0xff;
                }else{
                    dataFormat[i]=recvBuf[i];
                }
            }
                    /*for (int i=0;i<sendByte.length;i++){
                        if (String.valueOf(sendByte[i]).length() == 1) {
                            System.out.println("0"+sendByte[i]);
                        }else {
                            System.out.println(sendByte[i]);
                        }
                    }*/
            MyUtil.printfInfo("向"+ip+"发送的请求数据");
            MyUtil.printfInfo("功能代码："+String.format("%02x",dataFormat[1]));
            MyUtil.printfInfo("设备序列号："+devSN);
            MyUtil.printfInfo("删除卡号："+cardNo);

            Thread.sleep(500);
            //datagramSocket.close();
            wgPermissionService.delWgPermission(cardNo,wgSNAndDoorID);
            count++;
        } catch (IOException ex) {
            ex.printStackTrace();
        }

    }

    //删除卡权限方法
    public static void sendDelPerssion(CardDeviceBean cardDeviceBean)throws InterruptedException,UnknownHostException{
        deviceService=BeanContext.getBean(DeviceService.class);
        wgPermissionService=BeanContext.getBean(WgPermissionService.class);
        MyUtil.printfInfo("开始删除权限");
        MyUtil.printfInfo("卡数量:"+cardDeviceBean.getCards().size()+" 设备数量:"+cardDeviceBean.getDevices().size());
        for(CardDeviceBean.DeviceVo deviceVo : cardDeviceBean.getDevices()){
            for(CardDeviceBean.CardVo cardVo : cardDeviceBean.getCards()){
                //int iDevID = Integer.parseInt(deviceVo.getValue());
                System.out.println("微耕门禁ID  "+deviceVo.getValue());
                try{
                    datagramSocket = MyListener.datagramSocket;
                    String ip = deviceService.getWgDevIPByID(deviceVo.getValue());
                    byte[] CardIdArray = WGAccessUtil.getCardId(cardVo.getCardId());

                    String devSN = deviceVo.getValue().substring(0,9);
                    //转16进制
                    byte[] devSNByteArray =  WGAccessUtil.getDevSNToByteArray(devSN);
                    byte[] sendByte = new byte[64];
                    //
                    sendByte[0] = 0x17;
                    sendByte[1] =(byte) 0x52;
                    sendByte[2] = 0x00;
                    sendByte[3] = 0x00;
                    //控制器SN
                    sendByte[4] = devSNByteArray[0];
                    sendByte[5] = devSNByteArray[1];
                    sendByte[6] = devSNByteArray[2];
                    sendByte[7] = devSNByteArray[3];
                    //卡号
                    sendByte[8] = CardIdArray[0];
                    sendByte[9] = CardIdArray[1];
                    sendByte[10] = CardIdArray[2];
                    sendByte[11] = CardIdArray[3];


                    DatagramPacket sendPacket = new DatagramPacket(sendByte, sendByte.length, InetAddress.getByName(ip),60000);
                    datagramSocket.send(sendPacket);

                    int[] dataFormat=new int[1024];

                    byte[] recvBuf = new byte[1024];
                    recvBuf = sendPacket.getData();
                    for(int i=0;i<recvBuf.length;i++){//对byte数组中的数据进行判断，当为负数时，与0xff相与，并存放在Int数组中，可以保证数据正常
                        if(recvBuf[i]<0){
                            dataFormat[i]=recvBuf[i]&0xff;
                        }else{
                            dataFormat[i]=recvBuf[i];
                        }
                    }
                    /*for (int i=0;i<sendByte.length;i++){
                        if (String.valueOf(sendByte[i]).length() == 1) {
                            System.out.println("0"+sendByte[i]);
                        }else {
                            System.out.println(sendByte[i]);
                        }
                    }*/
                    MyUtil.printfInfo("向"+ip+"发送的请求数据");
                    MyUtil.printfInfo("功能代码："+String.format("%02x",dataFormat[1]));
                    MyUtil.printfInfo("设备序列号："+devSN);
                    MyUtil.printfInfo("删除卡号："+cardVo.getCardId());

                    Thread.sleep(500);
                    //datagramSocket.close();
                    wgPermissionService.delWgPermission(cardVo.getCardId(),deviceVo.getValue());
                    count++;
                } catch (IOException ex) {
                    ex.printStackTrace();
                }

            }
            System.out.println("发送完毕");
        }
        System.out.println("删除权限数：     "+count);
    }

    //发送清空设备权限命令方法
    public static int sendDelDevAllPermission(String ctrlerSN)throws InterruptedException{
        wgAccessDevService= BeanContext.getBean(WGAccessDevService.class);
        JSONObject json =new JSONObject();
        json.put("ctrlerSN",ctrlerSN);
        WGAccessDevInfo dev = wgAccessDevService.queryWGAccessDevInfoByJSON(json).get(0);
        //转16进制
        byte[] devSNByteArray =  WGAccessUtil.getDevSNToByteArray(ctrlerSN);
        byte[] ipByteArray =  WGAccessUtil.getLocalAddressIP(dev.getIp());
        byte[] sendByte = new byte[64];
        sendByte[0] = 0x17;
        sendByte[1] =(byte) 0x54;
        sendByte[2] = 0x00;
        sendByte[3] = 0x00;
        //控制器SN
        sendByte[4] = devSNByteArray[0];
        sendByte[5] = devSNByteArray[1];
        sendByte[6] = devSNByteArray[2];
        sendByte[7] = devSNByteArray[3];

        sendByte[8] = 0x55;
        sendByte[9] = (byte) 0xAA;
        sendByte[10] = (byte) 0xAA;
        sendByte[11] = 0x55;

        System.out.println(String.format("发送目标序列号："+"%02x",sendByte[4])+" "+String.format("%02x",sendByte[5])+" "+String.format("%02x",sendByte[6])+" "+String.format("%02x",sendByte[7]));
        try {
            DatagramPacket sendPacket = new DatagramPacket(sendByte, sendByte.length, InetAddress.getByName(dev.getIp()),60000);
            datagramSocket=MyListener.datagramSocket;
            datagramSocket.send(sendPacket);
            MyUtil.printfInfo("向"+dev.getIp()+"发送的请求数据"+sendByte);
            Thread.sleep(500);
            //datagramSocket.close();

        } catch (IOException ex) {
            ex.printStackTrace();
        }
        System.out.println("发送完毕");
        return 1;
    }

    //发送校时命令方法
    public static int sendDevSetTime(String ctrlerSN)throws InterruptedException{
        wgAccessDevService= BeanContext.getBean(WGAccessDevService.class);
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        JSONObject json = new JSONObject();
        json.put("ctrlerSN",ctrlerSN);
        WGAccessDevInfo dev = wgAccessDevService.queryWGAccessDevInfoByJSON(json).get(0);
        //转16进制
        byte[] devSNByteArray =  WGAccessUtil.getDevSNToByteArray(ctrlerSN);
        byte[] ipByteArray =  WGAccessUtil.getLocalAddressIP(dev.getIp());
        byte[] sendByte = new byte[64];
        byte[] nowTime = WGAccessUtil.getNowData(sdf.format(new Date()));
        sendByte[0] = 0x17;
        sendByte[1] =(byte) 0x30;
        sendByte[2] = 0x00;
        sendByte[3] = 0x00;
        //控制器SN
        sendByte[4] = devSNByteArray[0];
        sendByte[5] = devSNByteArray[1];
        sendByte[6] = devSNByteArray[2];
        sendByte[7] = devSNByteArray[3];

        //校时时间
        sendByte[8] = nowTime[0];
        sendByte[9] = nowTime[1];
        sendByte[10] = nowTime[2];
        sendByte[11] = nowTime[3];
        sendByte[12] = nowTime[4];
        sendByte[13] = nowTime[5];
        sendByte[14] = nowTime[6];
        /*for(int i=0;i<nowTime.length;i++){
            System.out.println(nowTime[i]);
        }*/

        /*sendByte[8] = 0x20;
        sendByte[9] = 0x20;
        sendByte[10] = 0x07;
        sendByte[11] = 0x29;
        sendByte[12] = 0x15;
        sendByte[13] = 0x15;
        sendByte[14] = 0x15;*/

        System.out.println(String.format("发送目标序列号："+"%02x",sendByte[4])+" "+String.format("%02x",sendByte[5])+" "+String.format("%02x",sendByte[6])+" "+String.format("%02x",sendByte[7]));
        System.out.println(String.format("发送的设置时间："+"%02x",sendByte[8])+" "+String.format("%02x",sendByte[9])+" "+String.format("%02x",sendByte[10])+" "+String.format("%02x",sendByte[11])+" "+String.format("%02x",sendByte[12])+" "+String.format("%02x",sendByte[13])+" "+String.format("%02x",sendByte[14]));
        try {
            DatagramPacket sendPacket = new DatagramPacket(sendByte, sendByte.length, InetAddress.getByName(dev.getIp()),60000);
            datagramSocket=MyListener.datagramSocket;
            datagramSocket.send(sendPacket);
            MyUtil.printfInfo("向"+dev.getIp()+"发送的请求数据"+sendByte);
            Thread.sleep(500);
            //datagramSocket.close();

        } catch (IOException ex) {
            ex.printStackTrace();
        }
        System.out.println("发送完毕");
        return 1;
    }

//    //查询控制器状态[功能号: 0x20](实时监控用)
//    public static void wgAccessUDPSearchStatus() throws Exception{
//        String host = "192.168.0.85";//广播地址
//
//        byte[] bt = new byte[64];
//        bt[0] = 0x17;
//        bt[1] =(byte) 0x20;
//        bt[2] = 0x00;
//        bt[3] = 0x00;
//        //控制器id
//        bt[4] = (byte) 0x85;
//        bt[6] = (byte) 0xE5;
//        bt[5] = 0x07;
//        bt[7] = 0x0D;
//
//        DatagramPacket sendPacket = new DatagramPacket(bt, bt.length, InetAddress.getByName(host),60000);
//        datagramSocket.send(sendPacket);
//    }

    //命令整合方法
    public static void conformCommand(String ctrlerSN,String devIP,String cardNo){

    }


    /**
     *
     * @param a,b,c,d 十进制数据
     * 解析微耕控制器传回来的报文所对应的数据，比如卡号，控制器序列号
     * @return
     */
    public static long getNumUtil(int a,int b,int c,int d){
        //System.out.println("接收数据："+a+" "+b+" "+c+" "+d);
        //第一步：十进制转十六进制
        String strHexS1 = Integer.toHexString(a);
        String strHexS2 = Integer.toHexString(b);
        String strHexS3 = Integer.toHexString(c);
        String strHexS4 = Integer.toHexString(d);

        //个位数的话前面多补上一个0
        if(strHexS1.length()==1){
            strHexS1 = "0"+strHexS1;
        }

        if(strHexS2.length()==1){
            strHexS2 = "0"+strHexS2;
        }

        if(strHexS3.length()==1){
            strHexS3 = "0"+strHexS3;
        }

        if(strHexS4.length()==1){
            strHexS4 = "0"+strHexS4;
        }
        //第二步：换位置
        String cardHexID = strHexS4+strHexS3+strHexS2+strHexS1;
        //System.out.println("换位置:"+cardHexID);

        //第三步：转成十进制
        long valueTen2 = Long.parseLong(cardHexID,16);

        return valueTen2;
    }

    public static byte getHexString(String num){
        int intNum = Integer.parseInt(num);
        String hexNum = Integer.toHexString(intNum);
        //System.out.println("hexNum:"+hexNum);
        if(hexNum.length()== 1){
            hexNum = "0"+hexNum;
        }
        int a = Integer.parseInt(hexNum, 16);
        return (byte)a;
    }

    /**
     * Hex字符串转byte
     * @param inHex 待转换的Hex字符串
     * @return 转换后的byte
     */
    public static byte hexToByte(String inHex) {
        return (byte) Integer.parseInt(inHex, 16);
    }

    //根据ip解析成byte数组
    public static byte[] getLocalAddressIP(String ip){
        byte[] localHostIPArray = new byte[4];
        //System.out.println("ip:"+ip+"----------------");
        String[] ipSpliteList = ip.split("\\.");
        for(int i = 0;i<ipSpliteList.length;i++){
            localHostIPArray[i] = getHexString(ipSpliteList[i]);
            //System.out.println(localHostIPArray[i]);
        }
        return localHostIPArray;
    }

    //根据卡号解析成byte数组
    public static byte[] getCardId(String cardId){
        byte[] CardIdArray = new byte[4];
        long bb = Long.valueOf(cardId);
        String ss = Long.toHexString(bb);
        if(ss.length()==9){
            ss = "0"+ss;
        }
        for(int i = 0;i<4;i++){
            String dd = ss.substring(i*2,i*2+2);
            //System.out.println(dd);
            byte a =  (byte)Integer.parseInt(dd,16);
            CardIdArray[3-i] = a ;
            //System.out.println(CardIdArray[3-i]);
        }
        return CardIdArray;
    }

    //根据当前时间解析成byte数组
    public static byte[] getNowData(String nowData){
        //System.out.println("nowData "+nowData);
        byte[] nowDataArray = new byte[7];
        long bb = Long.parseLong(nowData);
        String ss = Long.toString(bb);
        //System.out.println(ss);
        for(int i = 0;i<7;i++){
            String dd = ss.substring(i*2,i*2+2);
            //System.out.println(dd);
            byte a =  (byte)Integer.parseInt(dd,16);
            nowDataArray[i] = a ;
            //System.out.println(DevSNArray[3-i]);
        }
        return nowDataArray;
    }

    //根据设备控制器SN序列号 解析成byte数组
    public static byte[] getDevSNToByteArray(String DevSN){
        byte[] DevSNArray = new byte[4];
        int bb = Integer.parseInt(DevSN);
        String ss = Integer.toHexString(bb);
        if(ss.length()==7){
            ss = "0"+ss;
        }
        //System.out.println(ss);
        for(int i = 0;i<4;i++){
            String dd = ss.substring(i*2,i*2+2);
            //System.out.println(dd);
            byte a =  (byte)Integer.parseInt(dd,16);
            DevSNArray[3-i] = a ;
            //System.out.println(DevSNArray[3-i]);
        }
        return DevSNArray;
    }

    public static byte[] getNumber(String number){
        byte[] numberArray = new byte[1];
        //System.out.println(number);
        int bb = Integer.valueOf(number);
        String ss = Long.toHexString(bb);
        if(ss.length()==1){
            ss = "0"+ss;
        }
        //System.out.println("*"+ss);
        byte a =  (byte)Integer.parseInt(ss,16);
        numberArray[0] = a ;
        //System.out.println("*"+numberArray[0]);
        //System.out.println(numberArray);
        return numberArray;
    }
}
