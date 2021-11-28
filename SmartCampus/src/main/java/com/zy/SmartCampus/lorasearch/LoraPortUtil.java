package com.zy.SmartCampus.lorasearch;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.controller.LoraDevCtrl;
import com.zy.SmartCampus.controller.NoiseDevController;
import com.zy.SmartCampus.controller.SwitchDevCtrl;
import com.zy.SmartCampus.polo.LoraDevInfo;
import com.zy.SmartCampus.polo.SwitchDevInfo;
import com.zy.SmartCampus.polo.SwitchInfo;
import com.zy.SmartCampus.service.SwitchDevService;
import com.zy.SmartCampus.service.LoraDevService;
import com.zy.SmartCampus.util.MyUtil;
import com.zy.SmartCampus.webSocket.MyWebSocketHander;
import com.zy.SmartCampus.webSocket.WebSocketUtil;
import lombok.SneakyThrows;
//import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;

import java.io.*;
import java.net.*;
import java.text.SimpleDateFormat;
import java.util.*;

//import static javafx.beans.binding.Bindings.select;
import com.zy.SmartCampus.util.SpringContextUtil;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.text.SimpleDateFormat;

/**
 *@日期 2020-5-29
 *@作者 HHP
 *@描述 服务器与网关的UDP广播与TCP连接
 */
public class LoraPortUtil /*extends ServerSocket*/ {

    public static SwitchDevInfo switchDevInfo;
    public static Boolean boolSet = true;
    public static Map<String, List> map = new HashMap<>();
    public static List<LoraDevInfo> devList = new ArrayList<>();//搜索出来的设置
    public static List<LoraDevInfo> newDevList = new ArrayList<>();//搜索出来的设置(无重复数据)
    public static List<SwitchDevInfo> newswitchDevList = new ArrayList<>();//搜索出来的空开设备(无重复数据)
    public static List uuidList = new ArrayList();//通过接受到的UUID更新设备的在线状态
    public static List dataList = new ArrayList();//保存开关状态（data）
    public static List<List> allDataList = new ArrayList();//保存全部的开关状态（data）
    public static List<Socket> socketList = new ArrayList();
    public static List<LoraDevInfo> ipAndDevSNList = new ArrayList<>();

    public static int port;//网关端口号
    public static String count;//获取返回数据中设备的数量
    public static String switchCount= "";//获取返回数据中设备的数量
    public static String uuid;//用来辨别空开设备
    public static String UDPDevSN = "";//UDP时的网关序列号
    public static String sendData;
    public static String sendDevSN = "";
    public static Boolean sendStatus = false; //判断服务器是否进入发送数据状态
    public static Boolean receive = false;  //判断是否收到网关的回复信息(false：没收到 ; true：收到)
    public static Boolean receiveStatus = false;    //判断网关回复信息内容是成功还是失败(false :失败 ；true：成功)
    public static Boolean ctrlStatus = false;//判断批量控制开关是否成功
    public static Boolean orno=false;
    public static Boolean HBStatus=false;//根据心跳判断网关是否处于正常连接状态


    public static void LoraUDPOpen() throws Exception {
        new Thread(new Runnable() {
            @SneakyThrows
            @Override
            public void run() {
                System.out.println("++++++++++++++++++++++++++++++++++++开始监听UDP广播+++++++++++++++++++++++++++++++++++");
                DatagramSocket datagramSocket = new DatagramSocket(8824);
                //ServerSocket serverSocket = new ServerSocket(8825);
                int numDev = 0;//网关数
                try {
                    while (true) {
                        byte[] data = new byte[2048];
                        DatagramPacket datagramPacket = new DatagramPacket(data, data.length);
                        // 接收网关请求的数据（在接收到数据之前一直处于阻塞状态）
                        datagramSocket.receive(datagramPacket);
                        System.out.println("----UDP");
                        byte[] arr = datagramPacket.getData();
                        int readDatalen = datagramPacket.getLength();
                        //接收到的网关发送的UDP报文
                        String dataHex = bytesToHexString(arr).substring(0, readDatalen * 2);
                        System.out.println("数据长度:" + readDatalen + "  广播报文 ：  " + dataHex);
                        String ip = datagramPacket.getAddress().getHostAddress();
                        //解析数据
                        //获取网关的IP和loraSN，还有回复网关的目的端口

                        String portData = dataHex.substring(14, 18);
                        port = Integer.parseInt(portData, 16);
                        String data2 = dataHex.substring(18);
                        byte[] b = hexStringToBytes(data2);
                        UDPDevSN = new String(b);
                        System.out.println("UDP的devSN：" + UDPDevSN + "-----ip：" + ip);
                        //如果再次出现相同的设备，清空之前保存的设备集合
                        for (int i = 0; i < newDevList.size(); i++) {
                            if (newDevList.get(i).getLoraSN().equals(UDPDevSN)) {
                                devList.clear();
                                newDevList.clear();
                            }
                        }
                        int dataLen = dataHex.substring(18).length() / 2;
                        String rLen = getHexLen(dataLen);
                        //  *** UDP： 对网关进行响应 ***
                        //获得回复报文
                        String rData = "F7FBF9A231".concat(rLen + dataHex.substring(18));
                        System.out.println("广播回复报文 ： " + rData);
                        byte[] backData = hexToByteArray(rData);
                        DatagramPacket backDatagramPacket = new DatagramPacket(backData, backData.length, InetAddress.getByName(ip), port);
                        datagramSocket.send(backDatagramPacket);

                        /* ===========================================================================================================================================*/
                        numDev++;
                        System.out.println("第" + numDev + "个网关");
                    }
                } catch (Exception e) {
                    System.out.println(e.getMessage());
                }
            }
        }).start();
    }
    public static void TCPLink() throws Exception {
        ServerSocket serverSocket = new ServerSocket(8825);
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    //String mip = datagramPacket.getAddress().getHostAddress();
                    while (true){
                        Socket socket = serverSocket.accept();
                        System.out.println("启动TCP线程");
                        new TcpServer(socket).start();
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }
    public static int num = 0;

    public static class TcpServer extends Thread {
        Socket socket;
        String udpip;
        public static Boolean OK = false;
        public static InputStream inputStream;

        public TcpServer(Socket socket) {
            this.socket = socket;
        }

        public void run() {
            String ip = socket.getInetAddress().getHostAddress();
            // System.out.println("tcpIP---"+ip+"----udpip----"+udpip);
            try {

                while (true) {
                    System.out.println("******:" + socketList);
                    System.out.println("******:" + ipAndDevSNList);
                    //OutputStream outputStream = socket.getOutputStream();

                    byte[] buf = new byte[2048];
                    InputStream inputStream = socket.getInputStream();

                    int a = inputStream.read(buf);
                    String strReceive = bytesToHexString(buf);
                    //接收到的数据长度的值
                    int lenReceive = Integer.parseInt(strReceive.substring(16, 24), 16);
                    //类型
                    int type = Integer.parseInt(strReceive.substring(10, 12), 16);
                    System.out.println("接收到消息的命令类型:" + type);
                    //数据内容
                    String receiveData = strReceive.substring(24, 24 + lenReceive * 2);
                    byte[] bytesReceive = hexStringToBytes(receiveData);
                    //xml格式的数据
                    String strDataXml = new String(bytesReceive);

                    //请求头，包括(起始字头3字节，流水号2字节，命令类型1字节，加密1字节，保留1字节)
                    String header = strReceive.substring(0, 16);
                    //结束字节
                    String tail = strReceive.substring(lenReceive * 2 + 24, lenReceive * 2 + 30);
                    String devSN = "";
                    if (!strDataXml.equals("")) {
                        devSN = strDataXml.substring(strDataXml.indexOf("<id>"), strDataXml.indexOf("</id>")).substring(4);
                    } else {
                        return;
                    }
                    //System.out.println("TCP的DevSN ： " + devSN);
                    if (type == 0x21) {
                        //处理设备注册消息
                        dealRegister(header, tail, strDataXml, socket);
                    }
                    //int total = selector(0,socket);

                    if (type == 0x22) {
                        //处理设备心跳消息
                        dealHB(header, tail, strDataXml, socket);
                    }
                    if (type == 0x23) {
                        //处理设备重启消息
                        dealRestart(strDataXml);
                    }
                    if (type == 0x24) {
                        //处理设备升级消息
                        dealUpgrade(strDataXml);
                    }
                    if (type == 0x40) {
                        //处理查询设备消息
                        dealsendswitchDevSelect(strDataXml);
                    }
                    if (type == 0x41) {
                        //处理设置终端设备消息
                        dealsendswitchDevAdd(strDataXml);
                    }
                    if (type == 0x42) {
                        //处理设备上传实时数据
                        dealRealTimeData(header, tail, strDataXml, socket,null);
                    }

                    if (type == 0x4a) {
                        //处理批量控制终端设备开关返回消息
                        dealsendManagerswitchDevCtrl(strDataXml);
                    }

                    if (type == 0x46) {
                        //处理噪音设备实时消息(报警信息)
                        dealsendManagerNoiseDevCtrl(header, tail, strDataXml, socket,null);
                    }

                    if (type == 0x4b) {
                        //处理噪音设备设置阈值返回消息
                        dealsendSetNoiseAlarmValue(strDataXml);
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        /**
         * 服务器发送重启请求报文
         *
         * @param data  重启请求报文
         * @param devSN 需要重启的设备序列号
         */
        public static Boolean sendRestart(String data, String devSN) throws InterruptedException {
            //判断发送命令是否成功
            Boolean restartStatus = false;
            //重置接收判断条件
            receive = false;
            receiveStatus = false;
            try {
                //遍历找到与devSN对应的socket
                for (int i = 0; i < ipAndDevSNList.size(); i++) {
                    System.out.println(">>>>>>>>>>>>>>>" + ipAndDevSNList.get(i).getLoraSN() + "  ---------" + devSN);
                    if (ipAndDevSNList.get(i).getLoraSN().equals(devSN)) {
                        for (int j = 0; j < socketList.size(); j++) {
                            System.out.println(">>>>>>>>>>>>>>>" + ipAndDevSNList.get(i).getIp() + "  ---------" + socketList.get(j).getInetAddress().getHostAddress());
                            if (socketList.get(j).getInetAddress().getHostAddress().equals(ipAndDevSNList.get(i).getIp())) {
//                                System.out.println("1");
                                OutputStream outputStream = socketList.get(j).getOutputStream();
//                                System.out.println("2");
                                byte[] sendData = hexToByteArray(data);
                                System.out.println("即将Write！");
                                outputStream.write(sendData);
                                System.out.println("发送重启" + devSN + "号网关设备的请求成功");
                                outputStream.flush();
                                //socketList.get(j).close();
                                //outputStream.close();
                                //new LoraPortUtil.ServerThread(socketList.get(i));
                                //Thread.sleep(1000);
                                //ipAndDevSNList.isEmpty();
                                //socketList.isEmpty();
                                restartStatus = true;
                                break;
                            }
                        }
                        break;
                    }

                }
            } catch (Exception e) {
                System.out.println("发送重启" + devSN + "号网关设备的请求失败");
                Thread.sleep(5000);
            }

            return restartStatus;
        }

        /**
         * 服务器发送升级请求报文
         *
         * @param data  升级请求报文
         * @param devSN 网关设备序列号
         */
        public static Boolean sendUpgrade(String data, String devSN) throws InterruptedException {
            //判断发送命令是否成功
            Boolean upgradeStatus = false;
            receive = false;
            receiveStatus = false;
            sendDevSN = devSN;
            try {

                //遍历找到与devSN对应的socket
                for (int i = 0; i < ipAndDevSNList.size(); i++) {
                    System.out.println(">>>>>>>>>>>>>>>" + ipAndDevSNList.get(i).getLoraSN() + "  -----1-----" + devSN);
                    if (ipAndDevSNList.get(i).getLoraSN().equals(devSN)) {
                        for (int j = 0; j < socketList.size(); j++) {
                            System.out.println(">>>>>>>>>>>>>>>" + ipAndDevSNList.get(i).getIp() + "  -----2-----" + socketList.get(j).getInetAddress().getHostAddress());
                            if (socketList.get(j).getInetAddress().getHostAddress().equals(ipAndDevSNList.get(i).getIp())) {

                                OutputStream outputStream = socketList.get(j).getOutputStream();
                                byte[] sendData = hexToByteArray(data);
                                outputStream.write(sendData);
                                System.out.println("发送升级" + devSN + "号网关设备的请求成功");
                                outputStream.flush();
                                //Thread.sleep(1000);
                                //ipAndDevSNList.isEmpty();
                                //socketList.isEmpty();
                                upgradeStatus = true;

                                break;
                            }
                        }
                        break;
                    }
                }
            } catch (Exception e) {
                System.out.println("发送升级" + devSN + "号网关设备的请求失败");
                Thread.sleep(3000);
            }
            return upgradeStatus;
        }

        public static Map<String, Object> chnMap = new HashMap<>();
        public static Map<String, Map<String, Object>> groupMap = new HashMap<>();
        public static Map<String, List<SwitchInfo>> mapMap = new HashMap<>();
        public static List<Map<String, Object>> list = new ArrayList<>();
        public static List<SwitchInfo> switchInfoList = new ArrayList<>();
        public static List<Map<String, List<SwitchInfo>>> mapList = new ArrayList<>();
        public static double energyConsumptionSum=0;
        public static double orTodayData;//验证数据是否为当天的数据
        public static double power;
        public static double yesterdayPower;
        public static SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        public static double getYesterdayPower(){
            double recordPower=0;
            SwitchDevService switchDevService = (SwitchDevService) SpringContextUtil.getBean("switchDevService");
            JSONObject json=new JSONObject();
            List<SwitchInfo> list=switchDevService.querySwitchPower(json);
            for(int i=0;i<list.size();i++){
                recordPower=recordPower+Double.valueOf(list.get(i).getLinePower());
            }
            return Math.round(recordPower*10)/10.0/120;
        }

        public static void dealRealTimeData(String header, String tail, String data, Socket socket,Model model) throws IOException {
            SwitchDevService switchDevService = (SwitchDevService) SpringContextUtil.getBean("switchDevService");
            System.out.println("回复请求----命令42：空开上报实时数据");
            String devSN = data.substring(data.indexOf("<id>"), data.indexOf("</id>")).substring(4);
            System.out.println("上报实时数据的设备序列号：" + devSN);
            String msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                    "<UP_SENSOR_REALDATA_RES>" +
                    "<id>" + devSN + "</id>" +
                    "<ret>0</ret>" +
                    "</UP_SENSOR_REALDATA_RES>\n";
            byte[] bytes = msg.getBytes();
            String strLen = getReturnDataLen(bytes.length);
            //得到返回报文
            String strReturnData = header.concat(strLen).concat(bytesToHexString(bytes).concat(tail));
            byte[] backData = hexToByteArray(strReturnData);
            for (int i = 0; i < ipAndDevSNList.size(); i++) {
                if (ipAndDevSNList.get(i).getLoraSN().equals(devSN)) {
                    for (int j = 0; j < socketList.size(); j++) {
                        if (socketList.get(j).getInetAddress().getHostAddress().equals(ipAndDevSNList.get(i).getIp())) {
                            socket = socketList.get(j);
                            OutputStream outputStream = socketList.get(j).getOutputStream();
                            outputStream.write(backData);
                            outputStream.flush();
                            System.out.println("实时数据回复结束。");
                        }
                    }
                }
            }

            //count 空开通道数量
            switchCount = data.substring(data.indexOf("<count>"), data.indexOf("</count>")).substring(7);
            String listStr = data.substring(data.indexOf("<list>"), data.indexOf("</list>")).substring(6);
            String uuid = data.substring(data.indexOf("<uuid>"), data.indexOf("</uuid>")).substring(6);
            if (!LoraDevCtrl.uuid.equals("") && !LoraDevCtrl.loraDevSN.equals("")) {
                if (LoraDevCtrl.uuid.equals(uuid) && LoraDevCtrl.loraDevSN.equals(devSN)) {
                    LoraDevCtrl.realTimeStatus = true;
                }
            }
            for (int i = 0; i < Integer.valueOf(switchCount); i++) {
                //chnId即通道地址 空开线路地址
                String chnId = String.valueOf(i + 1);
                if (switchInfoList.size() > 0) {
                    for (int j = 0; j < switchInfoList.size(); j++) {
                        if (switchInfoList.get(j).getLoraSN().equals(devSN)) {
                            if (switchInfoList.get(j).getDevId().equals(uuid)) {
                                if (switchInfoList.get(j).getSwitchAddress().equals(chnId)) {
                                    switchInfoList.remove(j);
                                    break;
                                }
                            }
                        }
                    }
                }
                String chndata = listStr.substring(listStr.indexOf("<chn>"), listStr.indexOf("</chn>")).substring(5);

                //解析接收的实时数据内容
                String switchStatus = chndata.substring(chndata.indexOf("<data>"), chndata.indexOf("</data>")).substring(6);
                String lineVol = chndata.substring(chndata.indexOf("<line_vol>"), chndata.indexOf("</line_vol>")).substring(10);
                String leakageCurrent = chndata.substring(chndata.indexOf("<leakage_current>"), chndata.indexOf("</leakage_current>")).substring(17);
                String linePower = chndata.substring(chndata.indexOf("<line_power>"), chndata.indexOf("</line_power>")).substring(12);
                String moduleTemp = chndata.substring(chndata.indexOf("<module_temp>"), chndata.indexOf("</module_temp>")).substring(13);
                String lineCurrent = chndata.substring(chndata.indexOf("<line_current>"), chndata.indexOf("</line_current>")).substring(14);

                JSONObject jsonObject=new JSONObject();
                jsonObject.put("devId",uuid);
                jsonObject.put("switchAddress",chnId);
                SwitchInfo switchInfo=switchDevService.querySwitchByAddress(jsonObject);
                //System.out.println("switchInfo    "+switchInfo);
                //switchInfo.setSwitchAddress(chnId); //设置通道Id
                /*if(switchStatus.equals("0")){
                    switchInfo.setSwitchStatus("断电");
                }else if(switchStatus.equals("1")){
                    switchInfo.setSwitchStatus("通电");
                }*/
                switchInfo.setLineVoltage(lineVol);
                switchInfo.setLeakageCurrent(leakageCurrent);
                switchInfo.setLinePower(linePower);
                switchInfo.setModuleTemperature(moduleTemp);
                switchInfo.setLineCurrent(lineCurrent);
                switchInfo.setLoraSN(devSN);
                switchInfo.setDevId(uuid);

                //将实时数据存入历史表
                switchDevService.addSwitchDataToHistory(switchInfo);
                //更新开关数据
                switchDevService.updateNewData(switchInfo);

                power=power+Integer.valueOf(linePower);
                energyConsumptionSum=power/120;
                switchInfoList.add(switchInfo);
                listStr = listStr.substring(listStr.indexOf("</chn>")).substring(6);
            }
            yesterdayPower=getYesterdayPower();
            if (yesterdayPower!=orTodayData){
                energyConsumptionSum=0;
            }
            orTodayData=yesterdayPower;
            //System.out.println("orToday:"+orTodayData);
            //System.out.println("switchInfoList:" + switchInfoList);
            //System.out.println("energyConsumptionSum:"+energyConsumptionSum);

            JSONObject jsonLight=new JSONObject();
            //System.out.println("yesterdayPower   "+yesterdayPower);
            //model.addAttribute("switchInfo",switchInfoList);
            //向前台发送实时数据
            for(WebSocketSession use : MyWebSocketHander.webSocketList){
                jsonLight.put("light",Math.round(energyConsumptionSum*10)/10.0);
                jsonLight.put("switchInfo",switchInfoList);
                if(yesterdayPower==0){
                    jsonLight.put("passAndNow","昨为0");
                }else {
                    if(energyConsumptionSum==0){
                        jsonLight.put("passAndNow","--");
                    }else {
                        jsonLight.put("passAndNow",Math.round((((energyConsumptionSum/yesterdayPower)-1)*1000)/10.0));
                    }
                }
                //jsonLight.put("switchInfo",switchInfoList);realEnergyConsumption
                //use.sendMessage(new TextMessage(jsonLight.toString()));
                WebSocketUtil.getInstance().sendJsonMsgToWeb(jsonLight,"/realEnergyConsumption");
                //use.sendMessage(new TextMessage(model.toString()));
                //MyUtil.printfInfo("webSocket 发送数据:"+jsonLight.toString());
            }
            switchInfoList.clear();
            /*model.addAttribute("switchInfo",switchInfoList);
            WebSocketUtil.getInstance().sendMsgToWeb(model,WebSocketUtil.PATH_SEND_WS);*/
        }

        public static void dealsendManagerNoiseDevCtrl(String header, String tail, String data, Socket socket,Model model) throws IOException {

            String loraId = data.substring(data.indexOf("<id>"), data.indexOf("</id>")).substring(4);
            String chnType = data.substring(data.indexOf("<chn_type>"), data.indexOf("</chn_type>")).substring(10);
            String uuid = data.substring(data.indexOf("<uuid>"), data.indexOf("</uuid>")).substring(6);
            String noiseData = data.substring(data.indexOf("<noise_data>"), data.indexOf("</noise_data>")).substring(12);
            String noiseThr = data.substring(data.indexOf("<noise_thr>"), data.indexOf("</noise_thr>")).substring(11);

            MyUtil.printfInfo("噪声报警器报警信息:"+loraId+" "+chnType+" "+uuid+" "+noiseData+" "+noiseThr);
            JSONObject jsonNoiseData = new JSONObject();
            jsonNoiseData.put("noiseData",noiseData);
            jsonNoiseData.put("noiseThr",noiseThr);
            WebSocketUtil.getInstance().sendJsonMsgToWeb(jsonNoiseData,"/noiseRealData");
            MyUtil.printfInfo("webSocket 发送数据:"+jsonNoiseData.toString());
        }
        /**
         * 服务器发送查询终端设备请求报文
         *
         * @param data  查询终端设备请求报文
         * @param devSN 需要查询终端设备的设备序列号
         */
        public static Boolean sendswitchDevSelect(String data, String devSN) throws InterruptedException {
            //判断发送命令是否成功
            Boolean AddStatus = false;
            //重置接收判断条件
            receive = false;
            receiveStatus = false;
            try {
                System.out.println("---------------------------");
                //System.out.println(ipAndDevSNList);
                //System.out.println(socketList);
                for (int i = 0; i < ipAndDevSNList.size(); i++) {
                    System.out.println(">>>>>>>>>>>>>>>" + ipAndDevSNList.get(i).getLoraSN() + "  -----1-----" + devSN);
                    if (ipAndDevSNList.get(i).getLoraSN().equals(devSN)) {
                        for (int j = 0; j < socketList.size(); j++) {
                            System.out.println(">>>>>>>>>>>>>>>" + ipAndDevSNList.get(i).getIp() + "  -----2-----" + socketList.get(j).getInetAddress().getHostAddress());
                            if (socketList.get(j).getInetAddress().getHostAddress().equals(ipAndDevSNList.get(i).getIp())) {

                                OutputStream outputStream = socketList.get(j).getOutputStream();
                                byte[] sendData = hexToByteArray(data);
                                outputStream.write(sendData);
                                System.out.println("发送查询终端设备的请求成功");
                                outputStream.flush();
                                Thread.sleep(1000);
                                //ipAndDevSNList.isEmpty();
                                //socketList.isEmpty();
                                AddStatus = true;
                                break;
                            }
                        }
                    }
                }

            } catch (Exception e) {
                System.out.println("发送查询终端设备的请求失败");
                Thread.sleep(3000);
            }
            return AddStatus;
        }

        /**
         * 服务器发送批量控制终端设备请求报文
         *
         * @param data  批量控制终端设备请求报文
         * @param devSN 需要批量控制终端设备的设备序列号
         */
        public static Boolean sendswitchDevCtrl(String data, String devSN) throws InterruptedException {
            //判断发送命令是否成功

            //重置接收判断条件
            receive = false;
            receiveStatus = false;
            try {
                System.out.println("---------------------------");
                System.out.println(ipAndDevSNList);
                System.out.println(socketList);
                for (int i = 0; i < ipAndDevSNList.size(); i++) {
                    System.out.println(">>>>>>>>>>>>>>>" + ipAndDevSNList.get(i).getLoraSN() + "  -----1-----" + devSN);
                    if (ipAndDevSNList.get(i).getLoraSN().equals(devSN)) {
                        for (int j = 0; j < socketList.size(); j++) {
                            System.out.println(">>>>>>>>>>>>>>>" + ipAndDevSNList.get(i).getIp() + "  -----2-----" + socketList.get(j).getInetAddress().getHostAddress());
                            if (socketList.get(j).getInetAddress().getHostAddress().equals(ipAndDevSNList.get(i).getIp())) {

                                System.out.println("》》》》》》》》》》》》》》");
                                OutputStream outputStream = socketList.get(j).getOutputStream();
                                byte[] sendData = hexToByteArray(data);
                                System.out.println("》》》》》》》》》》》》》》" + sendData);
                                outputStream.write(sendData);
                                System.out.println("发送批量控制终端设备的请求成功");
                                outputStream.flush();
                                Thread.sleep(1000);
                                //ipAndDevSNList.isEmpty();
                                //socketList.isEmpty();
                                ctrlStatus = true;
                                break;
                            }
                        }
                    }
                }


            } catch (Exception e) {
                System.out.println("发送批量控制终端设备的请求失败");
                Thread.sleep(3000);
            }
            return ctrlStatus;
        }

        /**
         * 服务器发送设置噪音设备终端设备报警阈值请求报文
         */
        public static Boolean sendNoiseDevCtrl(String data, String devSN) throws InterruptedException {
            //重置接收判断条件
            receive = false;
            receiveStatus = false;
            try {
                for (int i = 0; i < ipAndDevSNList.size(); i++) {
                    if (ipAndDevSNList.get(i).getLoraSN().equals(devSN)) {
                        for (int j = 0; j < socketList.size(); j++) {
                            if (socketList.get(j).getInetAddress().getHostAddress().equals(ipAndDevSNList.get(i).getIp())) {
                                OutputStream outputStream = socketList.get(j).getOutputStream();
                                byte[] sendData = hexToByteArray(data);

                                outputStream.write(sendData);

                                outputStream.flush();
                                Thread.sleep(1000);
                                ctrlStatus = true;
                                break;
                            }
                        }
                    }
                }

            } catch (Exception e) {
                System.out.println("发送设置噪音设备终端设备报警阈值请求失败");
                Thread.sleep(3000);
            }
            return ctrlStatus;
        }

        /**
         * 服务器发送设置终端设备请求报文
         *
         * @param data  设置终端设备请求报文
         * @param devSN 需要设置终端设备的设备序列号
         */
        public static Boolean sendswitchDevAdd(String data, String devSN) throws InterruptedException {
            //判断发送命令是否成功
            Boolean AddStatus = false;
            //重置接收判断条件
            receive = false;
            receiveStatus = false;
            try {
                System.out.println("---------------------------");
                System.out.println(ipAndDevSNList);
                System.out.println(socketList);
                for (int i = 0; i < ipAndDevSNList.size(); i++) {
                    System.out.println(">>>>>>>>>>>>>>>" + ipAndDevSNList.get(i).getLoraSN() + "  -----1-----" + devSN);
                    if (ipAndDevSNList.get(i).getLoraSN().equals(devSN)) {
                        for (int j = 0; j < socketList.size(); j++) {
                            System.out.println(">>>>>>>>>>>>>>>" + ipAndDevSNList.get(i).getIp() + "  -----2-----" + socketList.get(j).getInetAddress().getHostAddress());
                            if (socketList.get(j).getInetAddress().getHostAddress().equals(ipAndDevSNList.get(i).getIp())) {

                                System.out.println("》》》》》》》》》》》》》》");
                                OutputStream outputStream = socketList.get(j).getOutputStream();
                                byte[] sendData = hexToByteArray(data);
                                System.out.println("》》》》》》》》》》》》》》" + sendData);
                                outputStream.write(sendData);
                                System.out.println("发送设置终端设备的请求成功");
                                outputStream.flush();
                                Thread.sleep(1000);
                                //ipAndDevSNList.isEmpty();
                                //socketList.isEmpty();
                                AddStatus = true;
                                break;
                            }
                        }
                    }
                }

            } catch (Exception e) {
                System.out.println("发送设置终端设备的请求失败");
                boolSet = false;
                Thread.sleep(3000);
            }
            return AddStatus;
        }

        /**
         * 根据网关的返回XML判断是否重启成功
         *
         * @param data 服务器收到的网关回复重启消息的XML
         * @return
         */
        public static Boolean dealRestart(String data) {
            receive = true;
            System.out.println("收到回复----命令23：Lora网关重启设备");
            String ret = data.substring(data.indexOf("<ret>"), data.indexOf("</ret>")).substring(5);
            String RestartDevSN = data.substring(data.indexOf("<id>"), data.indexOf("</id>")).substring(4);
            if (Integer.valueOf(ret) == 0) {
                System.out.println("序列号为 " + RestartDevSN + "的网关重启成功");
                receiveStatus = true;
                for (int i = 0; i < newDevList.size(); i++) {
                    if (newDevList.get(i).getLoraSN().equals(RestartDevSN)) {
                        newDevList.remove(i);
                    }
                }
            } else {
                System.out.println("序列号为 " + RestartDevSN + "的网关重启失败");
            }
            return null;
        }


        /**
         * 根据网关的返回XML判断是否升级成功
         *
         * @param data 服务器收到的网关回复升级消息的XML
         * @return
         */
        public static String dealUpgrade(String data) {
            receive = true;
            System.out.println("收到回复----命令24：Lora网关升级设备");
            String ret = data.substring(data.indexOf("<ret>"), data.indexOf("</ret>")).substring(5);
            String RestartDevSN = data.substring(data.indexOf("<id>"), data.indexOf("</id>")).substring(4);
            if (Integer.valueOf(ret) == 0) {
                System.out.println("序列号为 " + RestartDevSN + "的网关升级成功");
                receiveStatus = true;
            } else {
                System.out.println("序列号为 " + RestartDevSN + "的网关升级失败");
            }
            return null;
        }

        /**
         * 心跳回复
         *
         * @param header 起始字节+流水号+命令类型+加密+保留
         * @param tail   结束字节
         * @param data   接收网关心跳请求的XML
         * @return
         * @throws IOException
         */
        public static String dealHB(String header, String tail, String data, Socket socket) throws IOException {
            System.out.println("回复请求----命令22：Lora网关设备心跳");
            String devSN = data.substring(data.indexOf("<id>"), data.indexOf("</id>")).substring(4);
            System.out.println("设备心跳时的设备序列号：" + devSN);
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
            String date = df.format(new Date()).replaceAll("[[\\s-:punct:]]", "");//获取当前系统时间并转为纯数字
            String msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                    "<HB_RES>" +
                    "<id>" + devSN + "</id>" +
                    "<ret>0</ret>" +
                    "<time>" + date + "</time>" +
                    "</HB_RES>";
            byte[] bytes = msg.getBytes();
            String strLen = getReturnDataLen(bytes.length);
            //得到返回报文
            String strReturnData = header.concat(strLen).concat(bytesToHexString(bytes).concat(tail));
            byte[] backData = hexToByteArray(strReturnData);
            for (int i = 0; i < ipAndDevSNList.size(); i++) {
                //int c = (int)((a - b) / 1000);
                if (ipAndDevSNList.get(i).getLoraSN().equals(devSN)) {
                    ipAndDevSNList.get(i).setData(new Date().getTime());
//                    System.out.println("现在时间："+new Date().getTime());
//                    System.out.println("查看心跳时间:"+ipAndDevSNList.get(i).getData());
                    for (int j = 0; j < socketList.size(); j++) {
                        if (socketList.get(j).getInetAddress().getHostAddress().equals(ipAndDevSNList.get(i).getIp())) {
                            OutputStream outputStream = socketList.get(j).getOutputStream();
                            outputStream.write(backData);
                            outputStream.flush();
                            System.out.println("心跳回复结束。");
                        }
                    }
                }
            }
            HBStatus=true;
            return null;
        }

        /**
         * 接收注册请求 注册数据解析 回复注册消息
         *
         * @param header 起始字节+流水号+命令类型+加密+保留
         * @param tail   结束字节
         * @param data   接收网关注册请求的XML
         * @return
         * @throws IOException
         */
        public static String dealRegister(String header, String tail, String data, Socket socket) throws IOException {
            List<LoraDevInfo> listLoraDev = new ArrayList();
            List<Socket> listSocket = new ArrayList();
            String devSN = data.substring(data.indexOf("<id>"), data.indexOf("</id>")).substring(4);
            String fwVer = data.substring(data.indexOf("<fw_ver>"), data.indexOf("</fw_ver>")).substring(8);
            String mac = data.substring(data.indexOf("<mac>"), data.indexOf("</mac>")).substring(5);
            String ip = data.substring(data.indexOf("<ip>"), data.indexOf("</ip>")).substring(4);
            System.out.println("TCP的DevSN" + devSN + "------ip:" + socket.getInetAddress().getHostAddress());
            String netmask = "";
            String defaultGateway = "";
            String macAddress = mac.substring(0, 2) + ":" + mac.substring(2, 4) + ":" + mac.substring(4, 6) + ":" +
                    mac.substring(6, 8) + ":" + mac.substring(8, 10) + ":" + mac.substring(10, 12);
            String sub1gNum = data.substring(data.indexOf("<sub1g>"), data.indexOf("</sub1g>")).substring(7);
            //给前端传送参数
            LoraDevInfo loraDevInfo = new LoraDevInfo();
            loraDevInfo.setIp(ip);
            loraDevInfo.setLoraSN(devSN);
            loraDevInfo.setPort(port);
            loraDevInfo.setNetmask(netmask);
            loraDevInfo.setDefaultGateway(defaultGateway);
            loraDevInfo.setMacAddress(macAddress.toUpperCase());
            loraDevInfo.setFwVer(fwVer);
            loraDevInfo.setSub1gNum(sub1gNum);
            devList.add(loraDevInfo);
            //System.out.println("<<<<<<<<<<<>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>devList :" +devList);
            for (int i = 0; i < devList.size(); i++) {
                List<LoraDevInfo> list = new LinkedList<>();
                list.addAll(devList);
                if (!newDevList.contains(list.get(i))) {
                    newDevList.add(list.get(i));
                }
            }
            System.out.println("通过注册消息成功获取网关信息！");
            System.out.println("回复请求----命令21：Lora网关设备注册");
            String msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                    "<REGISTE_RES>" +
                    "<id>" + devSN + "</id>" +
                    "<ret>0</ret>" +
                    "</REGISTE_RES>";
            byte[] bytes = msg.getBytes();
            //回复报文的数据长度(4字节)
            String strLen = getReturnDataLen(bytes.length);
            //得到返回报文
            String strReturnData = header.concat(strLen).concat(bytesToHexString(bytes).concat(tail));
            //System.out.println("注册回复报文：" + strReturnData);
            byte[] backData = hexToByteArray(strReturnData);
//
            //将每次注册设备的IP和DevSN保存到 ipAndDevSNList中
            //将每次注册设备的socket保存到socketList中，等到发送数据的时候调用。
            LoraDevInfo ipAndDevSN = new LoraDevInfo();
            ipAndDevSN.setIp(ip);
            ipAndDevSN.setLoraSN(devSN);
            ipAndDevSNList.add(ipAndDevSN);
            socketList.add(socket);
            System.out.println("请求注册的socket："+socket);
            for(int i=0;i<ipAndDevSNList.size()-1;i++){
                if(ipAndDevSNList.get(i).getIp().equals(ip)){
                    ipAndDevSNList.remove(i);
                }
            }
            for(int i=0;i<socketList.size()-1;i++){
                if(socketList.get(i).getInetAddress().getHostAddress().equals(socket.getInetAddress().getHostAddress())){
                    socketList.remove(i);
                }
            }
            /*if (!ipAndDevSNList.contains(listLoraDev.get(0))) {
                ipAndDevSNList.add(listLoraDev.get(0));
            }
            if (!socketList.contains(listSocket.get(0))) {
                //ipAndDevSNList.remove(i);
                //socketList.remove(j);
                socketList.add(listSocket.get(0));
            }*/

            System.out.println("******:" + socketList);
            System.out.println("******:" + ipAndDevSNList);

            for (int i = 0; i < ipAndDevSNList.size(); i++) {
                if (ipAndDevSNList.get(i).getLoraSN().equals(devSN)) {
                    for (int j = 0; j < socketList.size(); j++) {
                        if (socketList.get(j).getInetAddress().getHostAddress().equals(ipAndDevSNList.get(i).getIp())) {
                            socket = socketList.get(j);
                            OutputStream outputStream = socket.getOutputStream();
                            System.out.println("回复消息时选择的socket信息:" + socket);
                            outputStream.write(backData);
                            outputStream.flush();
                            System.out.println("注册回复结束。");
                        }
                    }
                }
            }
            return null;
        }
    }

    /**
     * 根据网关的返回XML判断是否发送成功
     *
     * @param data 服务器收到的网关回复设置消息的XML
     * @return
     */
    public static Boolean dealsendManagerswitchDevCtrl(String data) {
        receive = true;
        System.out.println("收到回复----命令4a：批量控制终端设备开关");
        String ret = data.substring(data.indexOf("<ret>"), data.indexOf("</ret>")).substring(5);
//        String count = data.substring(data.indexOf("<count>"), data.indexOf("</count>")).substring(5);
        //String uuid = data.substring(data.indexOf("<id>"), data.indexOf("</id>")).substring(4);
        if (Integer.valueOf(ret) == 0) {
            System.out.println("设置成功");
            receiveStatus = true;
            /*for(int i=0;i<Integer.valueOf(count);i++){
                System.out.println("循环打印的newswitchDevList:"+newswitchDevList);
                if(newswitchDevList.get(i).getUuid().equals(uuid)){
                    newswitchDevList.remove(i);
                }
            }*/
        } else {
            System.out.println("设置失败");
        }
        return receiveStatus;
    }

    /**
     * 根据网关的返回XML判断是否发送成功
     *
     * @param data 服务器收到的网关回复设置消息的XML
     * @return
     */
    public static Boolean dealsendswitchDevSelect(String data) {
        receive = true;
        orno=true;
        //List<Map<String,Object>> list=new ArrayList<>();


        System.out.println("收到回复----命令40：查询终端设备");
        String ret = data.substring(data.indexOf("<ret>"), data.indexOf("</ret>")).substring(5);
        count = data.substring(data.indexOf("<count>"), data.indexOf("</count>")).substring(7);
        String listStr = data.substring(data.indexOf("<list>"), data.indexOf("</list>")).substring(6);
        //System.out.println("******"+listStr+"++++++++++++");
        for (int i = 0; i < Integer.valueOf(count); i++) {
            dataList = new ArrayList();
            //dataList.clear();
            String start = listStr.substring(listStr.indexOf("<sensor>"));
            String end = listStr.substring(listStr.indexOf("<sensor>"), listStr.indexOf("</sensor>"));
            //System.out.println("---------========"+start +">>>>>>" + end +"<<<<<<<<<<<");
            String sensorStr = listStr.substring(listStr.indexOf("<sensor>"), listStr.indexOf("</sensor>")).substring(8);
            uuidList.add(i, sensorStr.substring(sensorStr.indexOf("<uuid>"), sensorStr.indexOf("</uuid>")).substring(6));
            String chncntStr = sensorStr.substring(sensorStr.indexOf("<chn_cnt>"), sensorStr.indexOf("</chn_cnt>")).substring(9);
            String chnlistStr = sensorStr.substring(sensorStr.indexOf("<chn_list>"), sensorStr.indexOf("</chn_list>")).substring(10);
            map.put("uuid", uuidList);

            for (int j = 0; j < Integer.valueOf(chncntStr); j++) {
                String chnId = String.valueOf(j + 1);
                String chnStr = chnlistStr.substring(chnlistStr.indexOf("<chn>"), chnlistStr.indexOf("</chn>")).substring(5);
                dataList.add(chnStr.substring(chnStr.indexOf("<data>"), chnStr.indexOf("</data>")).substring(6));
                chnlistStr = chnlistStr.substring(chnlistStr.indexOf("</chn>")).substring(6);
            }
            dataList.add(sensorStr.substring(sensorStr.indexOf("<uuid>"), sensorStr.indexOf("</uuid>")).substring(6));
            allDataList.add(dataList);

            //System.out.println("第"+i+"个dataList:"+dataList);
            System.out.println(allDataList);
            listStr = listStr.substring(listStr.indexOf("</sensor>")).substring(9);
            //map.put("uuid",uuidList);
        }
        //System.out.println("查询出终端设备的map:"+map.get("data"));
        //uuid=data.substring(data.indexOf("<uuid>"),data.indexOf("</uuid>")).substring(6);
        if (Integer.valueOf(ret) == 0) {
            receiveStatus = true;
        }
        return receiveStatus;
    }

    /**
     * 根据网关的返回XML判断是否发送成功
     *
     * @param data 服务器收到的网关回复设置消息的XML
     * @return
     */
    public static Boolean dealsendswitchDevAdd(String data) {
        receive = true;
        System.out.println("收到回复----命令41：设置终端设备");
        String ret = data.substring(data.indexOf("<ret>"), data.indexOf("</ret>")).substring(5);
//        String count = data.substring(data.indexOf("<count>"), data.indexOf("</count>")).substring(5);
        //String uuid = data.substring(data.indexOf("<id>"), data.indexOf("</id>")).substring(4);
        if (Integer.valueOf(ret) == 0) {
            System.out.println("设置成功");
            receiveStatus = true;
            /*for(int i=0;i<Integer.valueOf(count);i++){
                System.out.println("循环打印的newswitchDevList:"+newswitchDevList);
                if(newswitchDevList.get(i).getUuid().equals(uuid)){
                    newswitchDevList.remove(i);
                }
            }*/
        } else {
            System.out.println("设置失败");
        }
        return receiveStatus;
    }

    /**
     * 根据网关的返回XML判断是否发送成功
     * @param data 服务器收到的设置噪声阈值消息的XML
     * @return
     */
    public static Boolean dealsendSetNoiseAlarmValue(String data) {

        System.out.println("收到回复----命令4b：设置噪声阈值");
        String ret = data.substring(data.indexOf("<ret>"), data.indexOf("</ret>")).substring(5);

        if (Integer.valueOf(ret) == 0) {
            System.out.println("设置成功");
            receiveStatus = true;
        }
        return receiveStatus;
    }

    /**
     * 返回网关是否返回信息和信息中的状态是否成功
     *
     * @return
     */
    public static List getReceiveStatus() {
        Map<String, Object> receiveStatusMap = new HashMap<>();
        receiveStatusMap.put("receive", receive);
        receiveStatusMap.put("receiveStatus", receiveStatus);
        List<Map<String, Object>> receiveStatusList = new ArrayList<>();
        receiveStatusList.add(receiveStatusMap);
        System.out.println("返回信息的状态" + receiveStatusList);
        return receiveStatusList;
    }


    //将数据返回给Ctrl层
    public static List<LoraDevInfo> getLoraDevInfo() {
        return newDevList;
    }

    //将搜索终端设备的数据返回给Ctrl层
    public static List<SwitchDevInfo> getSwitchDevInfo() {
        return newswitchDevList;
    }

    /**
     * 获取hex字符串 并且 奇数位补0
     *
     * @param i
     * @return
     */
    public static String getReturnDataLen(int i) {
        String hex = Integer.toHexString(i);

        for (int j = 0; j < 8 - Integer.toHexString(i).length(); j++) {
            hex = "0" + hex;
        }
        return hex.toUpperCase();
    }

    /**
     * 数组转换成十六进制字符串
     *
     * @param
     * @return HexString
     */
    public static final String bytesToHexString(byte[] bArray) {
        StringBuffer sb = new StringBuffer(bArray.length);
        String sTemp;
        for (int i = 0; i < bArray.length; i++) {
            sTemp = Integer.toHexString(0xFF & bArray[i]);
            if (sTemp.length() < 2)
                sb.append(0);
            sb.append(sTemp.toUpperCase());
        }
        return sb.toString();
    }

    /**
     * 十六进制字符串转换成数组
     *
     * @param
     * @return byte
     */
    public static final byte[] hexStringToBytes(String str) {
        int len = str.length();
        byte[] arr = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            arr[i / 2] = (byte) ((
                    Character.digit(str.charAt(i), 16) << 4) +
                    Character.digit(str.charAt(i + 1), 16));
        }
        return arr;

    }

    /**
     * hex字符串转byte数组
     *
     * @param inHex 待转换的Hex字符串
     * @return 转换后的byte数组结果
     */
    public static byte[] hexToByteArray(String inHex) {
        int hexlen = inHex.length();
        byte[] result;
        if (hexlen % 2 == 1) {
            // 奇数
            hexlen++;
            result = new byte[(hexlen / 2)];
            inHex = "0" + inHex;
        } else {
            // 偶数
            result = new byte[(hexlen / 2)];
        }
        int j = 0;
        for (int i = 0; i < hexlen; i += 2) {
            result[j] = hexToByte(inHex.substring(i, i + 2));
            j++;
        }
        return result;
    }

    /**
     * Hex字符串转byte
     *
     * @param inHex 待转换的Hex字符串
     * @return 转换后的byte
     */
    public static byte hexToByte(String inHex) {
        return (byte) Integer.parseInt(inHex, 16);
    }

    /**
     * 获取hex字符串 并且 奇数位补0
     *
     * @param i
     * @return
     */
    public static String getHexLen(int i) {
        String hex = Integer.toHexString(i);
        if (hex.length() == 1) {
            hex = "000" + hex;
        } else if (hex.length() == 2) {
            hex = "00" + hex;
        } else if (hex.length() == 3) {
            hex = "0" + hex;
        }
        return hex.toUpperCase();
    }


    private static Integer cacheTime = 60000;
    @Autowired
    private LoraDevService loraDevService;
    public static void orLink() throws Exception {
        new Thread(new Runnable() {
            @SneakyThrows
            @Override
            public void run() {
                System.out.println(1);
                while (true){
                    Thread.sleep(10000);
                    //System.out.println(1.5);
                    if(socketList.size()>0){
                        //System.out.println(2);
                        //System.out.println("nowTime1:"+new Date().getTime());
                        for (int i=0;i<ipAndDevSNList.size();i++){
                            //System.out.println("nowTime2:"+new Date().getTime());
                            if((new Date().getTime()-ipAndDevSNList.get(i).getData())/1000>=70){
                                //System.out.println("nowTime3:"+new Date().getTime());
                                //System.out.println(ipAndDevSNList.get(i).getData());
                                for(int j=0;j<socketList.size();j++){
                                    //System.out.println(4);
                                    if(socketList.get(j).getInetAddress().getHostAddress().equals(ipAndDevSNList.get(i).getIp())){
                                        //更新lora网关设备的在线状态
                                        LoraDevService loraDevService=new LoraDevService();
                                        List<LoraDevInfo> loraDevInfos=loraDevService.queryLoraByDevSN(ipAndDevSNList.get(i).getLoraSN());
                                        loraDevInfos.get(0).setOnLine("离线");
                                        loraDevService.updateLora(loraDevInfos.get(0));
                                        ipAndDevSNList.remove(ipAndDevSNList.get(i));
                                        socketList.remove(socketList.get(j));
                                        //socketList.get(j).close();
                                        System.out.println(">>>>>>>>>>检查是否连接 "+ipAndDevSNList);
                                        System.out.println(">>>>>>>>>>检查是否连接 "+socketList);
                                    }
                                }
                            }
                        }
                    }
                }

                /*Thread.sleep(60000);
                Timer timer = new Timer();
                timer.schedule(new TimerTask() {
                    @Override
                    public void run() {
                        //你要执行的操作

                        int num=ipAndDevSNList.size();
                        System.out.println("开始执行巡视***********************************************"+num);
                        try {
                            for (int t = 0; t < num; t++) {
                                Boolean orNo = LoraMsgUtil.SendLoraData(ipAndDevSNList.get(t).getLoraSN(), "40", "");
                                System.out.println("00000000000000000000000000000000000000000000000:"+orNo);
                                if (orNo==false) {
                                    ipAndDevSNList.remove(ipAndDevSNList.get(t));
                                    for(int i=0;i<socketList.size();i++){
                                        if(socketList.get(i).getInetAddress().equals(ipAndDevSNList.get(t).getLoraSN())){
                                            socketList.remove(socketList.get(t));
                                        }
                                    }
                                    System.out.println("把"+ipAndDevSNList.get(t).getLoraSN()+"删完了");
                                }

                                Thread.sleep(1000);
                            }
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }
                }, 10, cacheTime);*/
            }
        }).start();
    }
}