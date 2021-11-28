package com.zy.SmartCampus.listener;


import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.ZigBeeConnect.TCPServer;
import com.zy.SmartCampus.controller.WGAccessDevCtrl;
import com.zy.SmartCampus.hik.HkStaticInfo;
import com.zy.SmartCampus.lorasearch.LoraPortUtil;
import com.zy.SmartCampus.polo.Device;
import com.zy.SmartCampus.polo.WGAccessDevInfo;
import com.zy.SmartCampus.polo.WGAccessDoorInfo;
import com.zy.SmartCampus.polo.WGAccessOpenDoor;
import com.zy.SmartCampus.serialport.ParamConfig;
import com.zy.SmartCampus.serialport.SerialPortUtils;
import com.zy.SmartCampus.service.*;
import com.zy.SmartCampus.util.MyUtil;
import com.zy.SmartCampus.util.MyXMLUtil;
import com.zy.SmartCampus.util.WGAccessUtil;
import com.zy.SmartCampus.webSocket.WebSocketUtil;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class MyListener implements ServletContextListener {

    @Autowired
     WGOpenDoorService wgOpenDoorService;
    @Autowired
    private LoraDevService loraDevService;
    @Autowired
    WGAccessDevService wgAccessDevService;
    @Autowired
    OrganizeService organizeService;
    @Autowired
    private HkService hkService;
    TCPServer tcpServer=null;

    //启动
    @SneakyThrows
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, servletContextEvent.getServletContext());

        //initSerialPort();

        MyUtil.writeDiskInfo();//日志打印功能


        JSONObject json =new JSONObject();
        List<WGAccessDevInfo> list = wgAccessDevService.queryWGAccessDevInfo(json);
        System.out.println("MainCtrl获取微耕设备数量 "+list.size());
        wgAccessUDPOpen(list);

        //-----门禁设备初始化监听
        HkStaticInfo.g_loginDevInfoList = new ArrayList<>();

        MyUtil.mkDir(MyUtil.getWEBINFPath()+"fileDir");

        hkService.initAndSetCallBack(); //设备初始化 回调
        List<Device> deviceList = hkService.getAllDev();
        MyUtil.printfInfo("当前全部门禁设备数量:"+deviceList.size());
        for (Device device : deviceList){
            //MyUtil.printfInfo(device.toString());
            hkService.loginAndSetAlarmUp(device);
        }

        MyUtil.printfInfo("注册成功门禁设备信息数量"+ HkStaticInfo.g_loginDevInfoList.size());

        LoraPortUtil.LoraUDPOpen();
        LoraPortUtil.TCPLink();
        LoraPortUtil.orLink();

        //2021-0805-dzb 启动ZigBee网关的TCP通讯
        String tcpServerPort = MyXMLUtil.getConfigXMLValue("TCPServerPort");
        tcpServer = new TCPServer(Integer.parseInt(tcpServerPort));
        new Thread(() -> tcpServer.start()).start();
    }

    //销毁
    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        //2021-0805-dzb 关闭ZigBee网关的TCP通讯
        tcpServer.stop();


    }


    private void initSerialPort(){
        new Thread(new Runnable() {
            @Override
            public void run() {
                // 创建串口必要参数接收类并赋值，赋值串口号，波特率，校验位，数据位，停止位
                ParamConfig paramConfig = new ParamConfig("COM4", 9600, 0, 8, 1);
                // 初始化设置,打开串口，开始监听读取串口数据
                SerialPortUtils.getInstance().init(paramConfig);
            }
        }).start();
    }

    //功能号
    private static final int WG_SERVERIP_FUNCTIONID = 90; //设置接收服务器的IP和端口
    private static final int WG_SEARCH_FUNCTIONID   = 94; //搜索控制器
    private static final int WG_SEARCHCONTROLL_FUNCTIONID = 20; //查询控制器状态(实时监控用)
    private static final int WG_devSetTime_FUNCTIONID = 30; //查询控制器状态(实时监控用)
    private static final int WG_SETPERMISSION_FUNCTIONID = 50; //设置卡权限
    private static final int WG_DELPERMISSION_FUNCTIONID = 52; //删除卡权限
    private static final int WG_DELDEVALLPERMISSION_FUNCTIONID = 54; //清空设备权限
    private static final int WG_SETDOOR_FUNCTIONID=80;//门设置
    private static final int PORT = 60006;
    public static List<WGAccessDevInfo> devList = new ArrayList<>();//搜索出来的设置
    public static List<WGAccessDoorInfo> WGDoordevList = new ArrayList<>();//搜索出来的设置
    public static DatagramSocket datagramSocket;

    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式

    //线程开启和门禁的通讯
    public void wgAccessUDPOpen(List<WGAccessDevInfo> wgList) throws Exception{

        //SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String ip = InetAddress.getLocalHost().getHostAddress();

        byte[] ipArray = WGAccessUtil.getLocalAddressIP(ip);
        new Thread(new Runnable() {
            private final int PORT = 60001;
            //private DatagramSocket datagramSocket;
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String ip = InetAddress.getLocalHost().getHostAddress();
            byte[] ipArray = WGAccessUtil.getLocalAddressIP(ip);

            @SneakyThrows
            @Override
            public void run() {
//                datagramSocket = WGAccessUtil.getDatagramSocket();
                try {
                    datagramSocket = new DatagramSocket(PORT);
                    System.out.println("udp服务端已经启动！");
                } catch (Exception e) {
                    datagramSocket = null;
                    System.out.println("udp服务端启动失败！");
                    e.printStackTrace();
                }

                for(int i = 0;i<wgList.size();i++){
                    WGAccessDevInfo dev = wgList.get(i);
                    String devSN = dev.getCtrlerSN();
                    //转16进制
                    byte[] devSNByteArray =  WGAccessUtil.getDevSNToByteArray(devSN);
                    byte[] ipByteArray =  WGAccessUtil.getLocalAddressIP(dev.getIp());
                    byte[] sendByte = new byte[64];
//
                    sendByte[0] = 0x17;
                    sendByte[1] =(byte) 0x90;
                    sendByte[2] = 0x00;
                    sendByte[3] = 0x00;
                    //控制器id
                    sendByte[4] = devSNByteArray[0];
                    sendByte[5] = devSNByteArray[1];
                    sendByte[6] = devSNByteArray[2];
                    sendByte[7] = devSNByteArray[3];
                    //ip
                    sendByte[8] = ipArray[0];
                    sendByte[9] = ipArray[1];
                    sendByte[10] = ipArray[2];
                    sendByte[11] = ipArray[3];

//                    sendByte[8] = (byte) 0xC0;
//                    sendByte[9] = (byte) 0xA8;
//                    sendByte[10] = (byte) 0x00;
//                    sendByte[11] = (byte) 0x24;
                    //通信端口号
                    sendByte[12] = (byte) 0x61;
                    sendByte[13] = (byte) 0xEA;

                    DatagramPacket sendPacket = new DatagramPacket(sendByte, sendByte.length,InetAddress.getByName(dev.getIp()),60000);

                    try {
                        datagramSocket.send(sendPacket);
                        MyUtil.printfInfo("向"+dev.getIp()+"发送的请求数据"+sendByte);
                        System.out.println("微耕门禁连接数：     "+(i+1));
                        Thread.sleep(500);
                        //datagramSocket.close();
                    } catch (IOException ex) {
                        ex.printStackTrace();
                    }
                }
                System.out.println("发送完毕");

                byte[] receBuf = new byte[1024];
                DatagramPacket recePacket = new DatagramPacket(receBuf, receBuf.length);

                while (true){
                    datagramSocket.receive(recePacket);//阻塞
                    String receStr = new String(recePacket.getData(), 0 , recePacket.getLength(),"utf-8");
                    //System.out.println("接收:"+receStr.length());
                    //System.out.println(receStr);
                    //MyUtil.printfInfo("接收到的回复："+recePacket.getData());
                    byte[] recvBuf = new byte[1024];
                    recvBuf = recePacket.getData();
                    int[] dataFormat=new int[1024];
                    for(int i=0;i<recvBuf.length;i++){//对byte数组中的数据进行判断，当为负数时，与0xff相与，并存放在Int数组中，可以保证数据正常
                        if(recvBuf[i]<0){
                            dataFormat[i]=recvBuf[i]&0xff;
                        }else{
                            dataFormat[i]=recvBuf[i];
                        }
                    }

                    //功能号
                    int  FunctionNum = dataFormat[1];
                    String strFunctionNum = Integer.toHexString(FunctionNum);

                    switch (Integer.parseInt(strFunctionNum)){
                        case WG_SERVERIP_FUNCTIONID:
                            int a8 = dataFormat[8];
                            if(a8==1){
                                System.out.println("服务器设置成功,当前服务器ip："+ip);
                            }
                            else{
                                System.out.println("服务器设置失败");
                            }
                            break;
                        case WG_SEARCH_FUNCTIONID: //设备搜索
                            String IP = dataFormat[8]+"."+dataFormat[9]+"."+dataFormat[10]+"."+dataFormat[11];
                            long DevSN =  WGAccessUtil.getNumUtil(dataFormat[4],dataFormat[5],dataFormat[6],dataFormat[7]);

                            WGAccessDevInfo dev = new WGAccessDevInfo();
                            dev.setIp(IP);
                            dev.setCtrlerSN(DevSN+"");
                            dev.setNetmask(dataFormat[12]+"."+dataFormat[13]+"."+dataFormat[14]+"."+dataFormat[15]);
                            dev.setDefaultGateway(dataFormat[16]+"."+dataFormat[17]+"."+dataFormat[18]+"."+dataFormat[19]);
                            dev.setMacAddress(Integer.toHexString(dataFormat[20])+"-"+Integer.toHexString(dataFormat[21])+"-"+Integer.toHexString(dataFormat[22])+"-"+Integer.toHexString(dataFormat[23])+"-"+Integer.toHexString(dataFormat[24])+"-"+Integer.toHexString(dataFormat[25]));
                            dev.setDriverVerID(Integer.toHexString(dataFormat[26])+"."+Integer.toHexString(dataFormat[27]));
                            dev.setVerDate(Integer.toHexString(dataFormat[28])+""+Integer.toHexString(dataFormat[29])+"-"+Integer.toHexString(dataFormat[30])+"-"+Integer.toHexString(dataFormat[31]));
                            dev.setPort(60000);
                            dev.setOnLine(1);//默认在线
                            dev.setStatus("在线");
                            //给设备设置默认位置
                            dev.setSchool("");
                            dev.setHouse("");
                            dev.setFloor("");
                            dev.setRoom("");
                            System.out.println("设备搜索:"+dev.toString());
                            if(devList.contains(dev)){
                                break;
                            }
                            devList.add(dev);
                            break;

                        case WG_SEARCHCONTROLL_FUNCTIONID:
                            System.out.println(sdf.format(new Date())+"接收刷新信息----------------------");
                            //刷卡时间
                            String timeYear = Integer.toHexString(dataFormat[20])+""+Integer.toHexString(dataFormat[21]);
                            String timeMonth = Integer.toHexString(dataFormat[22]);
                            if(timeMonth.length()==1){
                                timeMonth = "0"+timeMonth;
                            }
                            String timeDay = Integer.toHexString(dataFormat[23]);
                            if(timeDay.length()==1){
                                timeDay = "0"+timeDay;
                            }
                            String timeHour = Integer.toHexString(dataFormat[24]);
                            if(timeHour.length()==1){
                                timeHour = "0"+timeHour;
                            }
                            String timeMinute =Integer.toHexString(dataFormat[25]);
                            if(timeMinute.length()==1){
                                timeMinute = "0"+timeMinute;
                            }
                            String timeSecond = Integer.toHexString(dataFormat[26]);
                            if(timeSecond.length()==1){
                                timeSecond = "0"+timeSecond;
                            }


                            //System.out.println(df.format(new Date()));
                            String cardNo =  String.valueOf(WGAccessUtil.getNumUtil(dataFormat[16],dataFormat[17],dataFormat[18],dataFormat[19]));
                            long DevSNC =  WGAccessUtil.getNumUtil(dataFormat[4],dataFormat[5],dataFormat[6],dataFormat[7]);
                            System.out.println("卡号:"+cardNo+"---"+"控制器SN:"+DevSNC+"---"+(dataFormat[13] == 0?"不通过":"通过")+" "+"---门号"+dataFormat[14]+"---方向："+(dataFormat[15] == 1?"进":"出"));

                            WGAccessOpenDoor wgAccessOpenDoor = new WGAccessOpenDoor();
                            wgAccessOpenDoor.setCardID(cardNo+"");  //卡号
                            wgAccessOpenDoor.setCtrlerID(DevSNC+"");//控制器id
                            JSONObject json = new JSONObject();
                            json.put("cardNo",cardNo);
                            wgAccessOpenDoor.setUsername(wgOpenDoorService.queryUserNameByCardId(json).getName());
                            String schoolId = wgOpenDoorService.queryUserNameByCardId(json).getSchoolId();
                            String houseId = wgOpenDoorService.queryUserNameByCardId(json).getHouseId();
                            String floorId = wgOpenDoorService.queryUserNameByCardId(json).getFloorId();
                            String roomId = wgOpenDoorService.queryUserNameByCardId(json).getRoomId();

                            wgAccessOpenDoor.setSchoolId(schoolId);
                            wgAccessOpenDoor.setHouseId(houseId);
                            wgAccessOpenDoor.setFloorId(floorId);
                            wgAccessOpenDoor.setRoomId(roomId);
                            wgAccessOpenDoor.setStaffId(wgOpenDoorService.queryUserNameByCardId(json).getStaffId());
                            wgAccessOpenDoor.setIsPass(dataFormat[13]);  //0 表示不通过, 1表示通过
                            wgAccessOpenDoor.setDoorID(dataFormat[14]);  //门号 1,2,3,4
                            wgAccessOpenDoor.setDirection(dataFormat[15]);//进门出门  1表示进门, 2表示出门
                            wgAccessOpenDoor.setOpenDoorWay(dataFormat[12]);//0=无记录  1=刷卡记录 2=门磁,按钮, 设备启动, 远程开门记录 3=报警记录
                            wgAccessOpenDoor.setId(MyUtil.getUUID());

                            //wgAccessOpenDoor.setDoorDateTime(timeYear+"-"+timeMonth+"-"+timeDay+" "+timeHour+":"+timeMinute+":"+timeSecond);
                            wgAccessOpenDoor.setDoorDateTime(df.format(new Date()));
                            saveOpenDoorRecord(wgAccessOpenDoor);

                            WebSocketUtil.getInstance().sendMsgToWeb(json,"/WgAccessOpenDoor");

                            break;
                        case WG_SETPERMISSION_FUNCTIONID:
                            System.out.println(sdf.format(new Date())+"接收设置权限回复信息----------------------");
                            MyUtil.printfInfo("功能代码："+String.format("%08x",dataFormat[1]));
                            MyUtil.printfInfo("设备序列号："+dataFormat[4]+" "+dataFormat[5]+" "+dataFormat[6]+" "+dataFormat[7]);
                            MyUtil.printfInfo("信息位："+dataFormat[8]);
                            break;
                        case WG_DELPERMISSION_FUNCTIONID:
                            System.out.println(sdf.format(new Date())+"接收删除权限回复信息----------------------");
                            MyUtil.printfInfo("功能代码："+String.format("%08x",dataFormat[1]));
                            MyUtil.printfInfo("设备序列号："+dataFormat[4]+" "+dataFormat[5]+" "+dataFormat[6]+" "+dataFormat[7]);
                            MyUtil.printfInfo("信息位："+dataFormat[8]);
                            break;
                        case WG_DELDEVALLPERMISSION_FUNCTIONID:
                            System.out.println(sdf.format(new Date())+"接收清空权限回复信息----------------------");
                            MyUtil.printfInfo("功能代码："+String.format("%08x",dataFormat[1]));
                            MyUtil.printfInfo("设备序列号："+dataFormat[4]+" "+dataFormat[5]+" "+dataFormat[6]+" "+dataFormat[7]);
                            MyUtil.printfInfo("信息位："+dataFormat[8]);
                            break;
                        case WG_SETDOOR_FUNCTIONID:
                            System.out.println(sdf.format(new Date())+"接收门设置回复信息----------------------");

                            MyUtil.printfInfo("功能代码："+String.format("%02x",dataFormat[1]));
                            MyUtil.printfInfo("设备序列号："+String.format("%02x",dataFormat[4])+" "+String.format("%02x",dataFormat[5])+" "+String.format("%02x",dataFormat[6])+" "+String.format("%02x",dataFormat[7]));
                            MyUtil.printfInfo("信息位："+String.format("%02x",dataFormat[8])+" "+String.format("%02x",dataFormat[9])+" "+String.format("%02x",dataFormat[10]));

                            break;
                        case WG_devSetTime_FUNCTIONID:
                            System.out.println(sdf.format(new Date())+"接收校时回复信息----------------------");

                            MyUtil.printfInfo("功能代码："+String.format("%02x",dataFormat[1]));
                            MyUtil.printfInfo("设备序列号："+String.format("%02x",dataFormat[4])+" "+String.format("%02x",dataFormat[5])+" "+String.format("%02x",dataFormat[6])+" "+String.format("%02x",dataFormat[7]));
                            MyUtil.printfInfo("信息位："+String.format("%02x",dataFormat[8])+" "+String.format("%02x",dataFormat[9])+" "+String.format("%02x",dataFormat[10])+String.format("%02x",dataFormat[11])+" "+String.format("%02x",dataFormat[12])+" "+String.format("%02x",dataFormat[13])+" "+String.format("%02x",dataFormat[14]));

                            break;
                        default:break;

                    }
                }
            }
        }).start();
    }

    public void saveOpenDoorRecord(WGAccessOpenDoor wgAccessOpenDoor){

        wgOpenDoorService.addWGAccessDoorOpen(wgAccessOpenDoor);

        wgOpenDoorService.addTodayWGAccessDoorOpen(wgAccessOpenDoor);
    }

    public static List<WGAccessDevInfo> getWGAccessDevInfoList() {
        return devList;
    }

    public static void clearWGAccessDevInfoList() {
        devList.clear();
    }

    //微耕门禁设备搜索-广播
    public static void wgAccessUDPSearch() throws Exception{

        String host = "255.255.255.255";//广播地址
        System.out.println("广播");
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
        System.out.println("准备发送");
        datagramSocket.send(sendPacket);
    }
}
