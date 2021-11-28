package com.zy.SmartCampus.ZigBeeConnect;


import com.zy.SmartCampus.polo.ZigBeeGatewayDevInfo;
import com.zy.SmartCampus.polo.ZigBeeGatewayDevInfoTest;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;

import static com.alibaba.fastjson.JSON.parseArray;

/**
 * TCP客户端，与ZigBee网关建立连接，控制顺舟设备
 *
 * @author huanghaiping
 */
@Slf4j
public class TCPClient {
    public static String TAG = "TCPClient";
    public static Boolean isSocketOpen = false;  //判断socket打开还是关闭(false：关闭 ; true：打开)
    public static Socket socket;
    public static Boolean isNewDev = false;
    public static Boolean isFirstTime = true;
    private static boolean isComplete = false;
    public static String strNewDevId = "";
    public static String strNewDevDid = "";
    public static String strNewDevDtype = "";
    public static List<ZigBeeGatewayDevInfoTest> zigBeeGatewayDevInfoTestList = new ArrayList<>();
    static int intZigBeeGatewayPort = 13579;
    static String intZigBeeGatewayIP = "192.168.0.105";
    static Boolean isReceiveComplete = false;//消息是否接受完整
    static String strReceiveData = "";//消息内容
    static Logger logger = LoggerFactory.getLogger(TCPClient.class);

    static JSONObject jsonEnvironmentData = new JSONObject();

    public static void TCPLink() {

        new Thread(new Runnable() {
            @Override
            public void run() {
                System.out.println("开始TCP通讯");
                InputStream inputStream = null;
                OutputStream outStream = null;
                try {
                    byte[] buf;
                    JSONObject jsonReceiveData = new JSONObject();

                    while (true) {
                        socket = new Socket(intZigBeeGatewayIP, intZigBeeGatewayPort);//申请连接
                        inputStream = socket.getInputStream(); //3,获取socket流中的输入流,将服务端 反馈的数据 获取到,并打印.
                        outStream = socket.getOutputStream();//2,获取socket流中的输出流.将数据写到该流中.通过网络发送给 服务端.

                        isSocketOpen = true;
                        isReceiveComplete = false;
                        String newData;
                        int len = 0;
                        buf = new byte[10240];
                        outStream.flush();

                        try {
                            while ((len = inputStream.read(buf)) != -1) {
                                //String newData = new String(buf, 0, len);
                                newData = new String(buf, 0, len);
                                logger.info("TCP接收消息：");
                                logger.info(newData);
                                jsonReceiveData = new JSONObject(newData);
                                System.out.println("run: ---2---TCP接收消息完整");
                                isComplete = true;
                                break;
                            }
                        } catch (IOException | JSONException e) {
                            System.out.println("run: ---2---TCP接收消息不完整");
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
                        //当TCPsocket关闭时 UDP重连  一分钟一次
                        if (!isSocketOpen) {
                            while (!isSocketOpen) {
                                System.out.println("UDP重连");
//                                new UDPClient.UDPThread().start();
                                try {
                                    Thread.sleep(60000);
                                } catch (InterruptedException e) {
                                    e.printStackTrace();
                                }
                            }
                            return;
                        }

                        String strCode = jsonReceiveData.isNull("code") ? "" : jsonReceiveData.getInt("code")+"";             //命令类型    --根据设备固定数值
                        System.out.println("code:"+strCode);
                        String strResult = jsonReceiveData.isNull("result") ? "" : jsonReceiveData.getString("result");       //返回状态  0:成功    1:内存分配失败    2:参数错误  3:执行失败  4:对象/资源不存在
                        String strControl = jsonReceiveData.isNull("control") ? "" : jsonReceiveData.getInt("control")+"";   //命令类型下的控制类型     --根据设备固定数值
                        String strId = jsonReceiveData.isNull("id") ? "" : jsonReceiveData.getString("id");     //设备ID
                        String strDid = jsonReceiveData.isNull("did") ? "" : jsonReceiveData.getInt("did")+"";   //设备类型ID
                        String strDtype = jsonReceiveData.isNull("dtype") ? "" : jsonReceiveData.getString("dtype");   //设备类型ID
                        String strDevice = jsonReceiveData.isNull("device") ? "" : jsonReceiveData.getString("device");  //获取设备信息的设备集合
                        System.out.println("strDevice"+strDevice);
                        JSONObject strDevSt = jsonReceiveData.isNull("st") ? null : jsonReceiveData.getJSONObject("st");  //获取设备上传的状态信息

                        if (strCode.equals("109") && strControl.equals("9")) {
                            //上报网关状态消息 回复       --与网关维持TCP连接
                            outStream.write("{\"code\":1009,\"control\":9,\"serial\": 11111,\"result\" :0}".getBytes());
                            System.out.println("run:上报网关状态消息回复 回复成功");
                        } else if (strCode.equals("102")) {
                            // 控制设备命令 回复
                            if (!strControl.equals("")) {
                                JSONObject jsonControl = new JSONObject(strControl);
                                String inle = jsonControl.isNull("inle") ? "" : jsonControl.getString("inle");
                                String indsp = jsonControl.isNull("indsp") ? "" : jsonControl.getString("indsp");
                                if (!inle.equals("") && !indsp.equals("") && strResult.equals("0")) {
//                                    List<FurnitureDevInfo> furnitureDevInfoList = DBHelp.instance.selectFurnitureDev(ControlPanelInfraredTransponderDialog.furnitureDevButtonInfo.getDevName());
//                                    ControlPanelInfraredTransponderDialog.furnitureDevButtonInfo.setDevId(furnitureDevInfoList.get(0).getDevId());
//                                    ControlPanelInfraredTransponderDialog.furnitureDevButtonInfo.setInfraredTransponderDevId(strId);
//                                    DBHelp.instance.insertFurnitureDevButton(ControlPanelInfraredTransponderDialog.furnitureDevButtonInfo);
                                }
                            }
                        } else if (strCode.equals("103")) {
                            //删除设备
                            Thread.sleep(300);
//                            Message message = new Message();
//                            message.what = 5;
//                            message.obj = strId;
//                            ConfigurationActivity.devListHandler.sendMessage(message);
//                            DBHelp.getInstance().delZigBeeDev(strId);
//                            DBHelp.getInstance().delClassBeginsSelectedDevAndCommand(strId,"","","");
                        } else if (strCode.equals("104") && strControl.equals("2")) {
                            // 上报设备状态改变 回复
                            String strMsg = "{ \"code\" :1004,\"id\" : \"" + strId + "\", \"ep\" : 1, \"pid\" : 260, \"did\" : " + strDid + ", \"control\" :2,\"result\" :0}";
//                            String msg = "{ \"code\" :1004,\"id\" : \"010100124b001b6d0784\", \"ep\" : 1, \"pid\" : 260, \"did\" : 9, \"control\" :2,\"result\" :0}";
                            outStream.write(strMsg.getBytes());
                            System.out.println("run:上报设备状态改变 回复成功:" + strId);
                            jsonEnvironmentData = new JSONObject(strDevSt);

//                            if (HomePageActivity.isCreated) {
//                                Message msgEnvironment = new Message();
//                                msgEnvironment.what = 2;
//                                msgEnvironment.obj = jsonEnvironmentData;
//                                HomePageActivity.environmentHandler.sendMessage(msgEnvironment);
//                            }
//                            if (ControlPanelInfraredDialog.isShow) {
//                                Message msgPeople = new Message();
//                                msgPeople.what = 2;
//                                msgPeople.obj = jsonEnvironmentData;
//                                ControlPanelInfraredDialog.alarmHandler.sendMessage(msgPeople);
//                            }
                        } else if (strCode.equals("105")) {
                            //搜索到新设备
                            isNewDev = true;
                            strNewDevId = strId;
                            strNewDevDid = strDid;
                            strNewDevDtype = strDtype;

                            log.info("TAG", "run:搜索到新设备");
//                            Message msg = new Message();
//                            msg.what = 1;
//                            AddDevActivity.devIdHandler.sendMessage(msg);
                        } else if (!strDevice.equals("")) {
                            //获取所有设备信息
                            //Log.d(TAG, "run: 所有设备信息+"+strDevice);
                            zigBeeGatewayDevInfoTestList = parseArray(strDevice, ZigBeeGatewayDevInfoTest.class);
                            System.out.println("run: 所有设备信息+" + zigBeeGatewayDevInfoTestList.size());
                            List<ZigBeeGatewayDevInfoTest> retList = new ArrayList<>();
                            for (int i = 0; i < zigBeeGatewayDevInfoTestList.size(); i++) {
//                                retList = DBHelp.instance.selectZigBeeDevInfo("", zigBeeGatewayDevInfoTestList.get(i).getId());
                                if (retList.size() != 0) {
                                    zigBeeGatewayDevInfoTestList.get(i).setDn(retList.get(0).getDn());
                                    if (retList.get(0).getOl() == null) {//设备状态发生改变则更新数据库
//                                        DBHelp.instance.updateZigBeeDev(zigBeeGatewayDevInfoTestList.get(i));
                                    } else if (!retList.get(0).getOl().equals(zigBeeGatewayDevInfoTestList.get(i).getOl())) {//设备状态发生改变则更新数据库
//                                        DBHelp.instance.updateZigBeeDev(zigBeeGatewayDevInfoTestList.get(i));
                                    }
                                }

                                if (retList.size() == 0) {
//                                    int ret = DBHelp.instance.insertZigBeeDev(zigBeeGatewayDevInfoTestList.get(i));
//                                    if (ret == -1) {
//                                        log.info(TAG, "getView: 插入ZigBee网关设备失败");
//                                    }
                                }
                                retList.clear();
                            }

//                            Message msgDev = new Message();
//                            msgDev.what = 1;
                            //传给首页消息  显示首页温度湿度
                            //HomePageActivity.environmentHandler.sendMessage(msgEnvironment);
//                            if (HomePageActivity.isCreated) {
//                                Message msgEnvironment = new Message();
//                                msgEnvironment.what = 3;
//                                HomePageActivity.environmentHandler.sendMessage(msgEnvironment);
//                            }
//                            if (ConfigurationActivity.isCreated) {
//                                //传到设备配置页面  获取设备信息
//                                ConfigurationActivity.devListHandler.sendMessage(msgDev);
//                            }
                        }
                        /*inputStream.close();
                        outStream.close();
                        socket.close();*/

                    }
                } catch (IOException | JSONException | InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }
}


