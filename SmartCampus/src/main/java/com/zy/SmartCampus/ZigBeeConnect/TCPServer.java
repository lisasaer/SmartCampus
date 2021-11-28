package com.zy.SmartCampus.ZigBeeConnect;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.ZigBeeGatewayDevInfo;
import com.zy.SmartCampus.polo.ZigBeeGatewayDevInfoTest;
import com.zy.SmartCampus.polo.ZigBeeGatewayInfo;
import com.zy.SmartCampus.service.ZigBeeGatewayService;
import com.zy.SmartCampus.util.SpringContextUtil;
import com.zy.SmartCampus.util.YSUtil;
import com.zy.SmartCampus.webSocket.WebSocketUtil;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Controller;


import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.text.SimpleDateFormat;
import java.util.*;


/**
 * @author: duzhibin
 * @description: TCP服务器端
 * @date: create in 16:01 2021/7/23
 */
@Slf4j
public class TCPServer {
    static Logger logger = LoggerFactory.getLogger(TCPServer.class);
    private int port;
    private boolean isFinished;
    private ServerSocket serverSocket;
    private ArrayList<SocketThread> socketThreads;
    public static Socket socket;

    private String gatewayMac;
    private static boolean isComplete = false;
    public static String strNewDevId = "";
    public static String strNewDevDid = "";
    public static String strNewDevDtype = "";
    public static Boolean isNewDev = false;
    public static JSONObject jsonEnvironmentData = new JSONObject();
    public static List<ZigBeeGatewayDevInfo> zigBeeGatewayDevInfoList = new ArrayList<>();//所有设备
    public static List<ZigBeeGatewayDevInfo> zigBeeNewDevInfoList = new ArrayList<>();//新设备集合
    public static boolean isDealSuccess = true;

    Timer timer = new Timer(); //定时器
    public static String onLine = "false"; //用于判断设备是否在线
    //手动获取zigBeeGatewayService对象
    public ZigBeeGatewayService zigBeeGatewayService = (ZigBeeGatewayService) SpringContextUtil.getBean("zigBeeGatewayService");

    public TCPServer(int port) {
        this.port = port;
        socketThreads = new ArrayList<>();
    }


    public void start() {
        isFinished = false;
        try {
            System.out.println("TCP开始连接");
            //创建服务器套接字，绑定到指定的端口
            serverSocket = new ServerSocket(port);
            //等待客户端连接
            while (!isFinished) {
                socket = serverSocket.accept();//接受连接
                //创建线程处理连接
                SocketThread socketThread = new SocketThread(socket);
                socketThreads.add(socketThread);
                socketThread.start();
            }
        } catch (IOException e) {
            isFinished = true;
            System.out.println("TCP连接失败");

        }
    }


    public void stop() {

        isFinished = true;
        for (SocketThread socketThread : socketThreads) {
            socketThread.interrupt();
            socketThread.close();
        }
        try {
            if (serverSocket != null) {
                serverSocket.close();
                serverSocket = null;
            }
            System.out.println("TCP通讯关闭");
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("TCP线程关闭的错误" + e.toString());
        }
    }

    private class SocketThread extends Thread {

        private Socket socket;
        private InputStream in;
        private OutputStream out;

        SocketThread(Socket socket) {
            System.out.println("TCP连接成功");
            this.socket = socket;
            try {
                in = socket.getInputStream();
                out = socket.getOutputStream();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        @Override
        public void run() {

            while (!isInterrupted()) {
                if (in == null) {
                    return;
                }
                JSONObject jsonReceiveData = new JSONObject();
                String newData = null;
                int len = 0;
                byte[] buf;
                buf = new byte[10240];
                try {
//                    int available = in.available();
//                    if (available > 0) {
//                        byte[] buffer = new byte[available];
//                        int size = in.read(buffer);
//                        if (size > 0) {
//                            newData = new String(buffer, 0, size);
//                            System.out.println("TCP接收来自客户端的消息:" + newData);
//                            jsonReceiveData = new JSONObject(newData);
//
//                            System.out.println("TCP接收消息完整");
//                            //返回结果给TcpClient
//                            String response = "TCPServer response:" + newData;
//                            out.write(response.getBytes());
//                            out.flush();
//                            isComplete = true;
//                        }
//                    }
//                    ByteArrayOutputStream baos=new ByteArrayOutputStream();//转换流
                    while ((len = in.read(buf)) != -1) {
//                        baos.write(buf, 0, len);
                        newData = new String(buf, 0, len);
                        try {
                            jsonReceiveData = JSON.parseObject(newData);
                        } catch (Exception e) {   //该异常为连包现象，进行截取处理
                            int index = newData.indexOf("}");
                            String authenticationData = newData.substring(0, index + 1);  //认证数据包
                            System.out.println("认证数据包：" + authenticationData);
                            newData = newData.substring(index + 1);
                            System.out.println("心跳包：" + newData);
                            try {
                                jsonReceiveData = JSON.parseObject(newData);
                            } catch (Exception ex) {
                                System.out.println("传入JSON的数据出错" + ex.toString());
                                jsonReceiveData = null;
                            }
                        }
                        System.out.println("TCP接收来自客户端的消息:" + newData);
                        System.out.println("TCP接收消息完整");
                        isComplete = true;
                        break;
                    }

                    //因为服务器接收到网关的信息就会响应状态码，理论走不到这方法
                    if ("".equals(newData) || null == newData) {
                        System.out.println("TCP接收的消息为空");
//                        try {
//                            socket.sendUrgentData(0xff);
//                        } catch (IOException e) {
//                            e.printStackTrace();
//                        }

                        System.out.println("服务器未响应网关心跳，导致网关断开通讯");
                        System.out.println("进行重连");

                        sleep(10000);

                    }
                } catch (IOException | InterruptedException e) {
                    e.printStackTrace();
                    System.out.println("TCP接收消息不完整");
                    isComplete = false;
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            while (!isComplete) {
                                TCPMsgUtil.sendTCPMsg(TCPMsgUtil.queryAllDevInfo, new ZigBeeGatewayDevInfo());
                                try {
                                    Thread.sleep(1000);
                                } catch (InterruptedException interruptedException) {
                                    interruptedException.printStackTrace();
                                }
                            }
                        }
                    }).start();
                }
                String strCode = "";
                String strResult = "";
                String strControl = "";
                String strId = "";
                String strDid = "";
                String strDtype = "";
                String strDevice = "";
                String strDevSt = "";
                String strEp = "";
                String strGw = "";


                if (null != jsonReceiveData && !"".equals(jsonReceiveData.toJSONString())) {
                    strCode = !jsonReceiveData.containsKey("code") ? "" : jsonReceiveData.getString("code") + "";             //命令类型    --根据设备固定数值
                    strResult = !jsonReceiveData.containsKey("result") ? "" : jsonReceiveData.getString("result");       //返回状态  0:成功    1:内存分配失败    2:参数错误  3:执行失败  4:对象/资源不存在
                    strControl = !jsonReceiveData.containsKey("control") ? "" : jsonReceiveData.getString("control");   //命令类型下的控制类型     --根据设备固定数值
                    strId = !jsonReceiveData.containsKey("id") ? "" : jsonReceiveData.getString("id");     //设备ID
                    strDid = !jsonReceiveData.containsKey("did") ? "" : jsonReceiveData.getString("did");   //设备类型ID
                    strDtype = !jsonReceiveData.containsKey("dtype") ? "" : jsonReceiveData.getString("dtype");   //设备类型ID
                    strDevice = !jsonReceiveData.containsKey("device") ? "" : jsonReceiveData.getString("device");  //获取设备信息的设备集合
                    strDevSt = !jsonReceiveData.containsKey("st") ? "" : jsonReceiveData.getString("st");  //获取设备上传的状态信息
                    strGw = !jsonReceiveData.containsKey("gw") ? "" : jsonReceiveData.getString("gw");
                    strEp = !jsonReceiveData.containsKey("ep") ? "" : jsonReceiveData.getString("ep");  //开关位
                }
                if ("109".equals(strCode) && "9".equals(strControl)) {
                    //上报网关状态消息 回复       --与网关维持TCP连接
                    try {
                        out.write("{\"code\":1009,\"control\":9,\"serial\": 11111,\"result\" :0}".getBytes());
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    System.out.println("上报网关状态消息成功");
                } else if ("101".equals(strCode)) {  //心跳检测---当网关与服务器建立连接后，网关应立刻上报一次心跳，之后每隔 1 分钟（设备 5 分钟离线）上报一次心跳。
                    if (isDealSuccess) {
                        receiverHeartBeatInfo(strGw, strDevice);
                    }

                } else if ("102".equals(strCode)) {
                    // 控制设备命令 这是服务器发命令控制设备时（开关...）网关响应的消息--->相当于服务器接执行命令后响应的消息
                    if (!strControl.equals("")) {
                        JSONObject jsonControl = JSON.parseObject(strControl);
                        String inle = jsonReceiveData.containsKey("inle") ? "" : jsonReceiveData.getString("inle");
                        String indsp = jsonReceiveData.containsKey("indsp") ? "" : jsonReceiveData.getString("indsp");

                        if (!"".equals(inle) && !"".equals(indsp) && "0".equals(strResult)) {
//                                    List<FurnitureDevInfo> furnitureDevInfoList = DBHelp.instance.selectFurnitureDev(ControlPanelInfraredTransponderDialog.furnitureDevButtonInfo.getDevName());
//                                    ControlPanelInfraredTransponderDialog.furnitureDevButtonInfo.setDevId(furnitureDevInfoList.get(0).getDevId());
//                                    ControlPanelInfraredTransponderDialog.furnitureDevButtonInfo.setInfraredTransponderDevId(strId);
//                                    DBHelp.instance.insertFurnitureDevButton(ControlPanelInfraredTransponderDialog.furnitureDevButtonInfo);
                        }
                    }
                } else if ("103".equals(strCode)) {
                    //删除设备
                    try {
                        Thread.sleep(300);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
//                            DBHelp.getInstance().delZigBeeDev(strId);
//                            DBHelp.getInstance().delClassBeginsSelectedDevAndCommand(strId,"","","");
                } else if ("104".equals(strCode) && "2".equals(strControl)) {
                    //与code：102的区别：104是状态改变服务器响应的消息，例子：通过服务器发开关设备命令给网关，回复102和104，通过徒手开关设备只会回复104
                    //接收网关下的子设备状态（开关状态、离线在线状态、亮度等等）消息，更新到数据库
                    ZigBeeGatewayDevInfo zigBeeGatewayDev = new ZigBeeGatewayDevInfo();
                    zigBeeGatewayDev.setDevId(strId);
                    List<ZigBeeGatewayDevInfo> zigBeeGatewayDevInfoList = zigBeeGatewayService.selectZigBeeDevInfo(zigBeeGatewayDev);
                    if (zigBeeGatewayDevInfoList.size() != 0) {
                        ZigBeeGatewayInfo zigBeeGatewayInfo = zigBeeGatewayService.selectZigBeeInfoByZigbeeId(zigBeeGatewayDevInfoList.get(0).getZigbeeId());
                        //2021-0809 新增对不同状态网关的处理
                        if (!"已删除".equals(zigBeeGatewayInfo.getState())) {

                            ZigBeeGatewayDevInfo zigBeeGatewayDevInfo = JSON.toJavaObject(jsonReceiveData, ZigBeeGatewayDevInfo.class);
                            zigBeeGatewayDevInfo.setDevId(strId);
                            if ("环境盒子".equals(zigBeeGatewayDevInfo.getNote())
                                    || "红外转发器".equals(zigBeeGatewayDev.getNote()) || "人体红外".equals(zigBeeGatewayDev.getNote())) {
                                if ("true".equals(zigBeeGatewayDevInfo.getOl())) {
                                    zigBeeGatewayDevInfo.getSt().setOn("true");
                                } else {
                                    zigBeeGatewayDevInfo.getSt().setOn("false");
                                }

                            }
                            zigBeeGatewayService.updateZigBeeGatewayDevInfo(zigBeeGatewayDevInfo);
                            //发给前端更新数据
                            WebSocketUtil.getInstance().sendMsgToWeb("StateChange", WebSocketUtil.PATH_SEND_WS_REFRESH_ZIGBEEVIEW);

                        }
                    }

                    // 上报设备状态改变 回复
                    String strMsg = "{ \"code\" :1004,\"id\" : \"" + strId + "\", \"ep\" : 1, \"pid\" : 260, \"did\" : " + strDid + ", \"control\" :2,\"result\" :0}";
                    try {
                        out.write(strMsg.getBytes());
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    System.out.println("设备状态改变 回复成功");
                    jsonEnvironmentData = JSON.parseObject(strDevSt);

                    //目前没用到
                } else if ("105".equals(strCode)) {
                    //搜索到新设备
                    isNewDev = true;
                    strNewDevId = strId;
                    strNewDevDid = strDid;
                    strNewDevDtype = strDtype;
                    System.out.println("run:搜索到新设备");
                    ZigBeeGatewayDevInfo zigBeeGatewayDevInfo = new ZigBeeGatewayDevInfo();
                    zigBeeGatewayDevInfo.setId(strId);
                    zigBeeGatewayDevInfo.setDid(strDid);
                    zigBeeGatewayDevInfo.setDtype(strDtype);
                    zigBeeNewDevInfoList.add(zigBeeGatewayDevInfo);

                }

            }
        }

        public void close() {

            try {
                if (in != null) {
                    in.close();
                }

                if (out != null) {
                    out.close();
                }

                if (socket != null) {
                    socket.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


        public synchronized void receiverHeartBeatInfo(String strGw, String strDevice) {
            isDealSuccess = false;
            onLine = "true";
            //保存网关信息到数据库
            String zigbeeId = "";
            if (!"".equals(strGw) && null != strGw) {
                zigbeeId = JSON.parseObject(strGw).getString("id");
                ZigBeeGatewayInfo zigBeeGatewayInfo = JSON.toJavaObject(JSON.parseObject(strGw), ZigBeeGatewayInfo.class);
                zigBeeGatewayInfo.setZigbeeId(zigbeeId);
                zigBeeGatewayInfo.setState("在使用");
                zigBeeGatewayInfo.setOl(onLine);
                ZigBeeGatewayInfo zigBeeGatewayInfoExist = zigBeeGatewayService.selectZigBeeInfoByZigbeeId(zigbeeId);  //存在的网关信息
                if (null == zigBeeGatewayInfoExist) {
                    zigBeeGatewayService.insertZigBeeGatewayInfo(zigBeeGatewayInfo);
                    System.out.println("添加网关信息成功");
                } else {
                    //2021-0809 新增对不同状态网关的处理
                    if (!"已删除".equals(zigBeeGatewayInfoExist.getState())) {
                        zigBeeGatewayService.updateZigBeeGatewayInfo(zigBeeGatewayInfo);
                        System.out.println("更新网关信息成功");
                    }
                }

                //保存网关离线状态,创建2分钟定时器，若有心跳消息则取消定时任务
                String finalZigbeeId = zigbeeId;
                timer.cancel();
                timer = new Timer();
                timer.schedule(new TimerTask() {
                    @Override
                    public void run() {
                        onLine = "false";
                        ZigBeeGatewayInfo zigBeeGatewayInfoNew = new ZigBeeGatewayInfo();
                        zigBeeGatewayInfoNew.setZigbeeId(finalZigbeeId);
                        zigBeeGatewayInfoNew.setOl(onLine);
                        zigBeeGatewayService.updateZigBeeGatewayInfo(zigBeeGatewayInfoNew);
                        //网关离线，网关下设备全设为离线
                        ZigBeeGatewayDevInfo zigBeeGatewayDevInfo = new ZigBeeGatewayDevInfo();
                        zigBeeGatewayDevInfo.setZigbeeId(finalZigbeeId);
                        List<ZigBeeGatewayDevInfo> zigBeeGatewayDevInfos = zigBeeGatewayService.selectZigBeeDevInfo(zigBeeGatewayDevInfo);
                        for (int i = 0; i < zigBeeGatewayDevInfos.size(); i++) {
                            zigBeeGatewayDevInfos.get(i).setOl(onLine);
                            zigBeeGatewayService.updateZigBeeGatewayDevInfo(zigBeeGatewayDevInfos.get(i));
                        }
                        System.out.println("网关离线状态保存成功");
                        //发送离线信息给前端，使其刷新页面
                        WebSocketUtil.getInstance().sendMsgToWeb("ZigBeeGatewayOffline", WebSocketUtil.PATH_SEND_WS_REFRESH_ZIGBEEVIEW);

                    }
                }, 2 * 60 * 1000);

            }


            //保存设备信息到数据库
            if (!"".equals(strDevice) && null != strDevice) {
                zigBeeGatewayDevInfoList = JSON.parseArray(strDevice, ZigBeeGatewayDevInfo.class);
                ZigBeeGatewayInfo zigBeeGatewayInfo = zigBeeGatewayService.selectZigBeeInfoByZigbeeId(zigbeeId);
                //2021-0809 新增对不同状态网关的处理
                if (!"已删除".equals(zigBeeGatewayInfo.getState())) {

                    for (int i = 0; i < zigBeeGatewayDevInfoList.size(); i++) {
                        String devId = zigBeeGatewayDevInfoList.get(i).getId();
                        ZigBeeGatewayDevInfo zigBeeGatewayDevInfo = new ZigBeeGatewayDevInfo();
                        zigBeeGatewayDevInfoList.get(i).setZigbeeId(zigbeeId);
                        zigBeeGatewayDevInfoList.get(i).setDevId(devId);
                        //zigBeeGatewayDevInfo用于查看该数据是否重复
                        zigBeeGatewayDevInfo.setDevId(devId);
                        zigBeeGatewayDevInfo.setEp(zigBeeGatewayDevInfoList.get(i).getEp());
                        //数据表中查出的相同设备信息
                        List<ZigBeeGatewayDevInfo> zigBeeGatewayDevInfos = zigBeeGatewayService.selectZigBeeDevInfo(zigBeeGatewayDevInfo);
                        if (0 == zigBeeGatewayDevInfos.size()) {
                            //若设备不在线则开关全设为false
                            if ("false".equals(zigBeeGatewayDevInfoList.get(i).getOl())) {
                                zigBeeGatewayDevInfoList.get(i).getSt().setOn("false");
                            }
                            if ("ShuncomDevice".equals(zigBeeGatewayDevInfoList.get(i).getDn())) {
                                zigBeeGatewayDevInfoList.get(i).setDn("Shuncom");
                            }
                            //设置设备别名
                            if (zigBeeGatewayDevInfoList.get(i).getDid().equals("0") && zigBeeGatewayDevInfoList.get(i).getDtype().equals("163")) {
                                zigBeeGatewayDevInfoList.get(i).setNote("开关面板");
                            } else if (zigBeeGatewayDevInfoList.get(i).getDtype().equals("164")) {
                                zigBeeGatewayDevInfoList.get(i).setNote("双开关面板");
                            } else if (zigBeeGatewayDevInfoList.get(i).getDtype().equals("165")) {
                                zigBeeGatewayDevInfoList.get(i).setNote("三开关面板");
                            } else if (zigBeeGatewayDevInfoList.get(i).getDid().equals("9")) {
                                zigBeeGatewayDevInfoList.get(i).setNote("智能插座-圆");
                            } else if (zigBeeGatewayDevInfoList.get(i).getDid().equals("81")) {
                                zigBeeGatewayDevInfoList.get(i).setNote("智能插座-方");
                            } else if (zigBeeGatewayDevInfoList.get(i).getDid().equals("82")) {
                                zigBeeGatewayDevInfoList.get(i).setNote("红外转发器");
                                if ("true".equals(zigBeeGatewayDevInfoList.get(i).getOl())) {
                                    zigBeeGatewayDevInfoList.get(i).getSt().setOn("true");     //开关状态默认在线则为开
                                }
                            } else if (zigBeeGatewayDevInfoList.get(i).getDid().equals("514")) {
                                zigBeeGatewayDevInfoList.get(i).setNote("窗帘电机");
                            } else if (zigBeeGatewayDevInfoList.get(i).getDid().equals("770")) {
                                zigBeeGatewayDevInfoList.get(i).setNote("环境盒子");
                                if ("true".equals(zigBeeGatewayDevInfoList.get(i).getOl())) {
                                    zigBeeGatewayDevInfoList.get(i).getSt().setOn("true");     //开关状态默认在线则为开
                                }
                            } else if (zigBeeGatewayDevInfoList.get(i).getDid().equals("1026")) {
                                zigBeeGatewayDevInfoList.get(i).setNote("人体红外");
                                if ("true".equals(zigBeeGatewayDevInfoList.get(i).getOl())) {
                                    zigBeeGatewayDevInfoList.get(i).getSt().setOn("true");     //开关状态默认在线则为开
                                }
                            } else if (zigBeeGatewayDevInfoList.get(i).getDid().equals("515")) {
                                zigBeeGatewayDevInfoList.get(i).setNote("窗帘电机面板");

                            }
                            System.out.println("两次zigbeeId是否相同:" + (zigbeeId.equals(zigBeeGatewayDevInfoList.get(i).getZigbeeId())));
                            synchronized (YSUtil.class) {
                                int code = zigBeeGatewayService.insertZigBeeGatewayDevInfo(zigBeeGatewayDevInfoList.get(i));
                                if (code > 0) {
                                    System.out.println(devId + "：设备添加成功    添加的网关是:" + zigbeeId);
                                }
                            }
                        } else {
                            //实时更新，这里是为了防止设备离线未能改变其状态。
                            if (!zigBeeGatewayDevInfos.get(0).getOl().equals(zigBeeGatewayDevInfoList.get(i).getOl())) {
                                if ("环境盒子".equals(zigBeeGatewayDevInfoList.get(i).getNote())
                                        || "红外转发器".equals(zigBeeGatewayDevInfoList.get(i).getNote()) || "人体红外".equals(zigBeeGatewayDevInfoList.get(i).getNote())) {
                                    if ("true".equals(zigBeeGatewayDevInfoList.get(i).getOl())) {
                                        zigBeeGatewayDevInfoList.get(i).getSt().setOn("true");
                                    } else {
                                        zigBeeGatewayDevInfoList.get(i).getSt().setOn("false");
                                    }

                                }
                                //不更新设备名,否则会覆盖自己的备注名
                                zigBeeGatewayDevInfoList.get(i).setDn(null);
                                int code = zigBeeGatewayService.updateZigBeeGatewayDevInfo(zigBeeGatewayDevInfoList.get(i));
                                if (code > 0) {
                                    //发给前端更新数据
                                    WebSocketUtil.getInstance().sendMsgToWeb("StateChange", WebSocketUtil.PATH_SEND_WS_REFRESH_ZIGBEEVIEW);
                                }
                            }
                        }
                    }

                }


            }

            try {
                JSONObject response = new JSONObject();
                response.put("code", 1001);
                response.put("result", 0);
                response.put("timestamp", System.currentTimeMillis());
                out.write(response.toJSONString().getBytes());
            } catch (IOException e) {
                isDealSuccess = true;
                e.printStackTrace();
            }
            isDealSuccess = true;
        }
    }

}

