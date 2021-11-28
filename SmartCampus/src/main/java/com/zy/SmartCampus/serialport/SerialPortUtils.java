package com.zy.SmartCampus.serialport;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.AirInfo;
import com.zy.SmartCampus.polo.DevInfo;
import com.zy.SmartCampus.polo.SwitchInfo;
import com.zy.SmartCampus.service.DevService;
import com.zy.SmartCampus.util.CRC16Util;
import com.zy.SmartCampus.util.MyUtil;
import com.zy.SmartCampus.webSocket.WebSocketUtil;
import gnu.io.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.*;
import java.util.concurrent.ConcurrentLinkedQueue;

/**
 * 串口参数的配置 串口一般有如下参数可以在该串口打开以前进行配置： 包括串口号，波特率，输入/输出流控制，数据位数，停止位和奇偶校验。
 */
// 注：串口操作类一定要继承SerialPortEventListener
@Component
public class SerialPortUtils implements SerialPortEventListener {
    // 检测系统中可用的通讯端口类
    private CommPortIdentifier commPortId;
    // 枚举类型
    private Enumeration<CommPortIdentifier> portList;
    // RS232串口
    private SerialPort serialPort;
    // 输入流
    private InputStream inputStream;
    // 输出流
    private OutputStream outputStream;
    // 保存串口返回信息
    private String data;
    // 保存串口返回信息十六进制
    private String dataHex;

    //错误信息码
    private String errorStr ;

    //打开关闭flag
    private boolean bOpen = false;

    //获取当前连接串口名称
    public String getCurrSerialPortName(){
        if(!bOpen){
            return "";
        }
        return serialPort.getName()== null ? "" : serialPort.getName().replace("/","").replace(".","");
    }

    public boolean isbOpen() {
        return bOpen;
    }

    private static ConcurrentLinkedQueue<String> queue = new ConcurrentLinkedQueue<>();

    @Autowired
    private DevService devService ;

    @PostConstruct
    private void init(){
        serialPortUtils = this;
        SwitchMsgUtil.setAllDevInfoList(devService.queryDev(null));
    }

    private static SerialPortUtils serialPortUtils  = null;

    public static SerialPortUtils getInstance(){
//        if(serialPortUtils == null){
//
//            serialPortUtils = new SerialPortUtils();
//        }
        return serialPortUtils;
}

    private static Thread threadSendMsg = null;
    /**
     * 初始化串口
     * @author LinWenLi
     * @date 2018年7月21日下午3:44:16
     * @Description: TODO
     * @param: paramConfig  存放串口连接必要参数的对象（会在下方给出类代码）
     * @return: void
     * @throws
     */
    @SuppressWarnings("unchecked")
    public void init(ParamConfig paramConfig) {
        // 获取系统中所有的通讯端口
        portList = CommPortIdentifier.getPortIdentifiers();
        // 记录是否含有指定串口
        boolean isExsist = false;
        // 循环通讯端口
        while (portList.hasMoreElements()) {
            commPortId = portList.nextElement();
            // 判断是否是串口
            if (commPortId.getPortType() == CommPortIdentifier.PORT_SERIAL) {
                // 比较串口名称是否是指定串口
                if (paramConfig.getSerialNumber().equals(commPortId.getName())) {
                    // 串口存在
                    isExsist = true;
                    // 打开串口
                    try {
                        // open:（应用程序名【随意命名】，阻塞时等待的毫秒数）
                        serialPort = (SerialPort) commPortId.open(Object.class.getSimpleName(), 2000);
                        // 设置串口监听
                        serialPort.addEventListener(this);
                        // 设置串口数据时间有效(可监听)
                        serialPort.notifyOnDataAvailable(true);
                        // 设置串口通讯参数:波特率，数据位，停止位,校验方式
                        serialPort.setSerialPortParams(paramConfig.getBaudRate(), paramConfig.getDataBit(),
                                paramConfig.getStopBit(), paramConfig.getCheckoutBit());
                        bOpen = true;
                        System.out.println("串口打开成功");

                        //初始化线程发送指令
                        //initThreadForSendMsg();

                    } catch (PortInUseException e) {
                        System.out.println("端口被占用");
                        errorStr = "端口被占用";
                    } catch (TooManyListenersException e) {
                        System.out.println("监听器过多");
                    } catch (UnsupportedCommOperationException e) {
                        System.out.println("不支持的COMM端口操作异常");
                    }
                    // 结束循环
                    break;
                }
            }
        }
        // 若不存在该串口则抛出异常
        if (!isExsist) {
            System.out.println("不存在该串口！");
            errorStr = "不存在该串口！";
        }
    }

    private void initThreadForSendMsg(){
        if(threadSendMsg == null){
            threadSendMsg = new Thread(new Runnable() {
                @Override
                public void run() {
                    while (bOpen){
                        for(DevInfo devInfo : SwitchMsgUtil.getAllDevInfoList()){
                            if(!bOpen){
                                return;
                            }
                            if(devInfo.getDevType().equals("1")){
                                String msg = SwitchMsgUtil.readSwitchOpenClose(Integer.parseInt(devInfo.getDevId())
                                                                                ,Integer.parseInt(devInfo.getLineCount()));
                                //sendComm(msg);
                            }else if (devInfo.getDevType().equals("2")){
                                String msg = MyUtil.getHexStringByInt(Integer.parseInt(devInfo.getDevId())) + "03 00 01 00 01";
                                msg = msg + CRC16Util.getCRC(msg);
                                System.out.println("============msg:"+msg);
                                sendComm(msg);
                            }

                            try {
                                Thread.sleep(SwitchMsgUtil.getSendInterval());
                            } catch (InterruptedException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }
            });
        }
        threadSendMsg.start();
    }

    /**
     * 实现接口SerialPortEventListener中的方法 读取从串口中接收的数据
     */
    @Override
    public void serialEvent(SerialPortEvent event) {
        switch (event.getEventType()) {
            case SerialPortEvent.BI: // 通讯中断
                System.out.println("通讯中断");
                break;
            case SerialPortEvent.OE: // 溢位错误
                System.out.println("溢位错误");
                break;
            case SerialPortEvent.FE: // 帧错误
                System.out.println("帧错误");
                break;
            case SerialPortEvent.PE: // 奇偶校验错误
                System.out.println("奇偶校验错误");
                break;
            case SerialPortEvent.CD: // 载波检测
                System.out.println("载波检测");
                break;
            case SerialPortEvent.CTS: // 清除发送
                System.out.println("清除发送");
                break;
            case SerialPortEvent.DSR: // 数据设备准备好
                System.out.println("数据设备准备好");
                break;
            case SerialPortEvent.RI: // 响铃侦测
                System.out.println("响铃侦测");
                break;
            case SerialPortEvent.OUTPUT_BUFFER_EMPTY: // 输出缓冲区已清空
                System.out.println("输出缓冲区已清空");
                break;
            case SerialPortEvent.DATA_AVAILABLE: // 有数据到达
                // 调用读取数据的方法
                readComm();
                break;
            default:
                break;
        }
    }

    private static String readData = "";
    /**
     * 读取串口返回信息
     * @author LinWenLi
     * @date 2018年7月21日下午3:43:04
     * @return: void
     */
//    public void readComm(String uuid) {
//        try {
//            inputStream = serialPort.getInputStream();
//            // 通过输入流对象的available方法获取数组字节长度
//            byte[] readBuffer = new byte[inputStream.available()];
//            // 从线路上读取数据流
//            int len = 0;
//            while ((len = inputStream.read(readBuffer)) != -1) {
//               // System.out.println("===="+uuid + "===== 当前线程ID:"+ Thread.currentThread().getId());
//                // 直接获取到的数据
//                data = new String(readBuffer, 0, len).trim();
//                // 转为十六进制数据
//                dataHex = bytesToHexString(readBuffer);
//                //System.out.println("数据长度:"+len+"  "+dataHex.length()+"    "+dataHex);
//                boolean bCheck = CRC16Util.checkCRC(dataHex);
//                //System.out.println("check:"+bCheck);
//                if(!bCheck){
//                    readData += dataHex;
//                    //System.out.println("拼接数据:"+readData);
//                    if(CRC16Util.checkCRC(readData)){
//                        System.out.println("===============数据接收完整22222==============="+readData);
//                        dealData(readData);
//                        readData = "";
//                    }
//                }else {
//                    System.out.println("===============数据接收完整11111==============="+dataHex);
//                    dealData(dataHex);
//                    readData = "";
//                }
//                inputStream.close();
//                inputStream = null;
//                break;
//            }
//        } catch (IOException e) {
//            System.out.println("读取串口数据时发生IO异常");
//        }
//    }

    public void readComm()
    {
        try {
            //System.out.println("===readComm====当前线程ID："+Thread.currentThread().getId());
            inputStream = serialPort.getInputStream();
            // 通过输入流对象的available方法获取数组字节长度
            byte[] readBuffer = new byte[inputStream.available()];
            // 从线路上读取数据流
            int len = 0;
            len = inputStream.read(readBuffer);
            System.out.println("串口读出来的数据长度：" + len);

            while (len != -1)
            {
                // 直接获取到的数据
                data = new String(readBuffer, 0, len).trim();
                // 转为十六进制数据
                dataHex = bytesToHexString(readBuffer);
                System.out.println("数据长度:"+len+"  "+ dataHex.length()+"    "+dataHex);
                boolean bCheck = CRC16Util.checkCRC(dataHex);
                System.out.println("check:" + bCheck);
                if(!bCheck)
                {
                    readData += dataHex;
                    System.out.println("拼接数据:" + readData);
                    if(CRC16Util.checkCRC(readData))
                    {
                        System.out.println("===============数据接收完整22222==============="+readData);
                        dealData(readData);
                        readData = "";
                        System.out.println("===============readData 2222222222222==============="+readData);
                    }
                }
                else
                {
                    System.out.println("===============数据接收完整11111==============="+dataHex);
                    dealData(dataHex);
                    readData = "";
                    System.out.println("===============readData 11111111111111==============="+readData);


                }
                inputStream.close();
                inputStream = null;

                len = inputStream.read(readBuffer);
                //break;
            }
        } catch (IOException e) {
            System.out.println("读取串口数据时发生IO异常");
            closeSerialPort();
        }
    }


    //01：读取开关合/分闸状态；
    private final int READ_OPEN_CLOSE_STATE = 1;
    //02：读取是否能被远程控制
    private final int READ_REMOTE_CONTRALL_ENABLE = 2;
    //03：读从机实时数据；
    private final int READ_SLAVE_REALTIME_DATA = 3;
    //04：读从机参数；
    private final int READ_SLAVE_PARAMETERS = 4;
    //05：控制开关合/分闸；
    private final int WRITE_CONTRALL_OPEN_CLOSE = 5;
    //06：写单个从机参数；
    private final int WRITE_SINGLE_SLAVE_PARAMETER = 6;
    //15：批量写控制开关合/分闸；
    private final int BATCH_WRITE_CONTRALL_OPEN_CLOSE = 15;
    //16：批量写从机参数；
    private final int BATCH_WRITE_SLAVE_PARAMETERS = 16;


    //设备类型
    private final int DEV_SWITCH    =  1;   //空开设备
    private final int DEV_AIR       =  2;   //空调控制设备

    //接收数据处理
    private void dealData(String data)
    {
        int  devId = Integer.parseInt(data.substring(0,2),16);
        int  iCmd = Integer.parseInt(data.substring(2,4),16);
        System.out.println("从机设备地址: "+devId+"  CMD:"+iCmd);

        //确保 队列地址CMD 与 当前接收数据中的地址CMD都相同
        int queueCmd ;
        int queueDevId;
        String queueString ;
        do{
            queueString = queue.poll();
            System.out.println("queue:"+(queueString==null?"null":queueString));

            if(queueString == null){
                return; //队列为空跳出循环
            }
            queueDevId = Integer.parseInt(queueString.substring(0,2),16);
            queueCmd = Integer.parseInt(queueString.substring(2,4),16);

            System.out.println("队列设备地址:"+queueDevId+"  CMD:"+queueCmd);
        }while (queueDevId != devId || queueCmd != iCmd);
        //数据库查找设备类型
        DevInfo devInfo = devService.queryDevByDevId(devId+"");
        if(devInfo == null){
            System.out.println("数据库中无该设备添加记录");
            return;
        }

        for(DevInfo temp : SwitchMsgUtil.getAllDevInfoList()){
            if(temp.getDevId().equals(String.valueOf(devId))){
                temp.setRecordTime(System.currentTimeMillis());
                break;
            }
        }

        int devType = Integer.parseInt(devInfo.getDevType());
        System.out.println("设备类型码(1,空开 2,空调):"+devType);

        //根据设备类型进行对应设备数据处理
        if(devType == DEV_AIR){
            dealAir(data,queueString);
        }else if(devType == DEV_SWITCH){
            dealSwitch(data,queueString);
        }
    }
    //接收空调处理好的信息
    private static String temperature = "";
    private static String humidity = "";
    private static String infraredInduction = "";

    private void dealAir(String data,String queue){
        byte[] dataArray = MyUtil.hexToByteArray(data);
        System.out.println("============开始处理空调控制设备返回数据============");
        int iCmd = Integer.parseInt(data.substring(2,4),16);
        //队列保存指令中提取对应功能指令
        int iMsg = Integer.parseInt(queue.substring(4,8),16);
        System.out.println("队列提取指令 MSG : "+iMsg);

        int  devId = Integer.parseInt(data.substring(0,2),16);

        switch (iCmd){
            case 0x03:
                System.out.println("03：读从机数据；"+data);
                //返回数据中提取值(16进制转10)
                int value = Integer.parseInt(data.substring(6,10),16);
                System.out.println("value："+value);
                switch (iMsg){
                    case 0x01:
                        System.out.println("读取温度:"+(value/10));
                        for(DevInfo temp : SwitchMsgUtil.getAllDevInfoList()){
                            if(Integer.parseInt(temp.getDevId()) == devId){
                                temp.setTemperature(String.valueOf(value/10));
                                //读取温度发送给wstest页面(HHP)
                                JSONObject json = new JSONObject();
                                String t = temp.getTemperature();
                                String type = "温度";
                                json.put("value",t);
                                json.put("type",type);
                                WebSocketUtil.getInstance().sendMsgToWeb(json, WebSocketUtil.PATH_SEND_WS);

                                temperature = t;

                                break;
                            }
                        }
                        break;
                    case 0x06:
                        System.out.println("读取湿度:"+(value));
                        for(DevInfo temp : SwitchMsgUtil.getAllDevInfoList()){
                            if(Integer.parseInt(temp.getDevId()) == devId){
                                temp.setHumidity(String.valueOf(value));
                                //读取湿度发送给wstest页面(HHP)
                                JSONObject json = new JSONObject();
                                String t = temp.getHumidity();
                                String type = "湿度";
                                json.put("value",t);
                                json.put("type",type);
                                WebSocketUtil.getInstance().sendMsgToWeb(json, WebSocketUtil.PATH_SEND_WS);

                                humidity = t;
                                break;
                            }
                        }
                        break;
                    case 0x07:
                        System.out.println("读取人体红外状态:"+(value == 1?"有人":"无人"));
                        for(DevInfo temp : SwitchMsgUtil.getAllDevInfoList()){
                            if(Integer.parseInt(temp.getDevId()) == devId){
                                temp.setInfrared(value == 1?"有人":"无人");
                                //读取人体红外状态发送给wstest页面(HHP)
                                JSONObject json = new JSONObject();
                                String t = temp.getInfrared();
                                String type = "红外";
                                json.put("value",t);
                                json.put("type",type);
                                WebSocketUtil.getInstance().sendMsgToWeb(json, WebSocketUtil.PATH_SEND_WS);

                                infraredInduction = t;
                                break;
                            }
                        }
                        break;
                    case 0x08:
                        System.out.println("读取当前光照强度百分比");

                        break;
                    case 0x0D:
                        System.out.println("读取电压");

                        break;
                    case 0x10:
                        System.out.println("读取电流");

                        break;
                    case 0x13:
                        System.out.println("读取总有功率");

                        break;
                    case 0x15:
                        System.out.println("读取总无功率");

                        break;
                    case 0x19:
                        System.out.println("读取空调启停状态（1-启动；0-停止）");

                        break;
                    case 0x1A:
                        System.out.println("读取软件版本");

                        break;
                    case 0x1B:
                        System.out.println("读取故障报警信息");

                        break;
                    case 0x0155:
                        System.out.println("读取设备地址（广播）");

                        break;
                    case 0x012C:
                        System.out.println("读取控制方式（1-智控；0-手控）");

                        break;
                    case 0x012D:
                        System.out.println("读取冬夏季模式（1-冬季；0-夏季）");

                        break;
                    case 0x012F:
                        System.out.println("读取开机自启动状态（1-开启；0关闭）");

                        break;
                    case 0x0130:
                        System.out.println("读取蜂鸣器的状态（1-开启；0关闭）");

                        break;
                    case 0x0158:
                        System.out.println("读取光敏功能使能（1-开启；0关闭）");

                        break;
                    case 0x0159:
                        System.out.println("读取光敏的灭动作阈值");

                        break;
                    case 0x015A:
                        System.out.println("读取光敏的亮动作阈值");

                        break;
                    case 0x0131:
                        System.out.println("读取空调启停判断阈值（单位：mA）");

                        break;
                    case 0x013A:
                        System.out.println("环境温度补偿值");

                        break;
                }
                break;
            case 0x06:
                System.out.println("06：写从机数据；");
                switch (iMsg){
                    case 0x014B:
                        System.out.println("开关继电器 : "+data.substring(8,12));
                        break;
                }
                break;
            case 0x10:
                System.out.println("04：批量写从机数据；");

                break;
            default:
                break;
        }
        if(temperature.isEmpty() || humidity.isEmpty() || infraredInduction.isEmpty()){
            System.out.println("参数为空！！！！");
            System.out.println(devId + "号空调温度：" + temperature);
            System.out.println(devId + "号空调湿度：" + humidity);
            System.out.println(devId + "号红外感应：" + infraredInduction);
        }else {
            //保存从串口中获取的实时信息
            AirInfo airInfoData = new AirInfo();

            System.out.println("串口中的实时信息获取成功:");
            airInfoData.setTemperature(temperature);
            airInfoData.setHumidity(humidity);
            airInfoData.setInfraredInduction(infraredInduction);

            System.out.println(devId + "号空调温度：" + temperature);
            System.out.println(devId + "号空调湿度：" + humidity);
            System.out.println(devId + "号红外感应：" + infraredInduction);

            airInfoData.setDevId(String.valueOf(devId));

            devService.updateAirNewData(airInfoData);

            JSONObject sJson = new JSONObject();
            sJson.put("devId",devId);

            List<AirInfo> airInfoList = devService.queryAirDetailByDevId(sJson);
            if(airInfoList.size()> 0){
                System.out.println("detail:"+airInfoList);
                airInfoData.setDevId(airInfoList.get(0).getDevId());
                airInfoData.setDevName(airInfoList.get(0).getDevName());
                airInfoData.setDevPostion(airInfoList.get(0).getDevPostion());
                airInfoData.setDevType(airInfoList.get(0).getDevType());
                airInfoData.setDevStatus(airInfoList.get(0).getDevStatus());
                airInfoData.setDevSN(airInfoList.get(0).getDevSN());
                airInfoData.setRelayStatus("在线");
            }
            System.out.println(devId + "号空调airInfoData：" + airInfoData);
            devService.insertAirToHistory(airInfoData);
            temperature = "";
            humidity = "";
            infraredInduction = "";
        }
    }

    //接收空调处理好的信息
    private static String lineVoltage = "";
    private static String leakageCurrent = "";
    private static String linePower = "";
    private static String moduleTemperature = "";
    private static String lineCurrent = "";

    private JSONObject dealSwitch(String data , String queue){
        byte[] dataArray = MyUtil.hexToByteArray(data);
        System.out.println("============开始处理开关闸设备返回数据============");
        System.out.println("处理返回数据 data : "+data);
        System.out.println("处理返回数据 queue : "+queue);
        //队列保存指令中提取对应功能指令
        int iMsg = Integer.parseInt(queue.substring(4,6),16);
        System.out.println("队列提取指令 MSG : "+iMsg);

        //获取空开线路地址和空开设备ID,查询出这条线路的信息，为插入数据做准备(2020-5-11,HHP)
        Map<String,Object> map = new HashMap<>();
        JSONObject json = new JSONObject();
        int  devId = Integer.parseInt(data.substring(0,2),16);
        String sAdd = String.valueOf(Integer.valueOf(queue.substring(6,8),16)+1);
        System.out.println("TTTTTTTTTTTTTTTTTTTTTTTTT----sAdd " + sAdd);

        int iCmd = MyUtil.getUnsignedByte(dataArray[1]);
        switch (iCmd){
            case READ_OPEN_CLOSE_STATE:
                System.out.println("01：读取开关合/分闸状态；");
                int byteCount = dataArray[2];//字节个数
                System.out.println("字节个数: "+byteCount);
                for(int i=0;i<byteCount;i++){
                    //十进制转二进制
                    String str2 = Integer.toBinaryString(dataArray[i+3]&0x0FF);
                    System.out.println("数据字节"+(i+1)+": "+(dataArray[i+3]&0x0FF)+"   二进制："+str2);

                    String address = getAddress(i,str2);
                    if(address.length() > 0){
                        System.out.println("合闸地址:"+address);
                        String type = "开关";
                        json.put("value",getAddress(i,str2));
                        json.put("type",type);
                        WebSocketUtil.getInstance().sendMsgToWeb(json, WebSocketUtil.PATH_SEND_WS);
                    }
                }
                break;
            case READ_REMOTE_CONTRALL_ENABLE:
                System.out.println("02：读取是否能被远程控制");

                break;
            case READ_SLAVE_REALTIME_DATA:
                System.out.println("03：读从机实时数据；");
                String devId2 = String.valueOf(Integer.valueOf(queue.substring(0,2),16));
                SwitchInfo switchInfo2 = new SwitchInfo();
                switchInfo2.setDevId(String.valueOf(devId2));
                switchInfo2.setSwitchAddress(sAdd);
                System.out.println("第一个map:"+switchInfo2);
                int value = Integer.parseInt(data.substring(6,10),16);
                System.out.println("value："+value);
                switch (iMsg){
                    case 0x00:
                        System.out.println("读取线路电压:"+(value));
                        for(DevInfo temp : SwitchMsgUtil.getAllDevInfoList())
                        {
                            if(Integer.parseInt(temp.getDevId()) == devId)
                            {
                                temp.setLineVoltage(String.valueOf(value));
                                //读取线路电压发送给wstest页面(HHP)
                                String t = temp.getLineVoltage();
                                String type = "线路电压";
                                json.put("value",t);

                                lineVoltage = t;
                                map.put("lineVoltage",t);
                                System.out.println(sAdd+"号线路电压:"+t);
                                json.put("type",type);
                                WebSocketUtil.getInstance().sendMsgToWeb(json, WebSocketUtil.PATH_SEND_WS);
                                //将数据保存到list集合中返回
                                break;
                            }
                        }
                        break;
                    case 0x01:
                        System.out.println("读取漏电电流:"+(value*0.1));
                        for(DevInfo temp : SwitchMsgUtil.getAllDevInfoList()){
                            if(Integer.parseInt(temp.getDevId()) == devId){
                                temp.setLeakageCurrent(String.valueOf(value*0.1));
                                //读取漏电电流发送给wstest页面(HHP)
                                String t = temp.getLeakageCurrent();
                                String type = "漏电电流";
                                json.put("value",t);

                                leakageCurrent = t;
                                map.put("leakageCurrent",t);
                                System.err.println("漏电电流:"+t);
                                json.put("type",type);
                                WebSocketUtil.getInstance().sendMsgToWeb(json, WebSocketUtil.PATH_SEND_WS);
                                break;
                            }
                        }
                        break;
                    case 0x02:
                        System.out.println("读取线路功率:"+(value));
                        for(DevInfo temp : SwitchMsgUtil.getAllDevInfoList()){
                            if(Integer.parseInt(temp.getDevId()) == devId){
                                temp.setLinePower(String.valueOf(value));
                                //读取线路功率发送给wstest页面(HHP)
                                String t = temp.getLinePower();
                                String type = "线路功率";
                                json.put("value",t);

                                linePower = t;
                                map.put("linePower",t);
                                System.err.println("线路功率:"+t);
                                json.put("type",type);
                                WebSocketUtil.getInstance().sendMsgToWeb(json, WebSocketUtil.PATH_SEND_WS);
                                break;
                            }
                        }
                        break;
                    case 0x03:
                        System.out.println("读取模块温度:"+(value*0.1));
                        for(DevInfo temp : SwitchMsgUtil.getAllDevInfoList()){
                            if(Integer.parseInt(temp.getDevId()) == devId){
                                temp.setModuleTemperature(String.valueOf(value*0.1).substring(0,4));
                                //读取模块温度发送给wstest页面(HHP)
                                String t = temp.getModuleTemperature();
                                String type = "模块温度";
                                json.put("value",t);

                                moduleTemperature = t;
                                map.put("moduleTemperature",t);
                                System.err.println("模块温度:"+t);
                                json.put("type",type);
                                WebSocketUtil.getInstance().sendMsgToWeb(json, WebSocketUtil.PATH_SEND_WS);
                                break;
                            }
                        }
                        break;
                    case 0x04:
                        System.out.println("读取线路电流:"+(value*0.01));
                        for(DevInfo temp : SwitchMsgUtil.getAllDevInfoList()){
                            if(Integer.parseInt(temp.getDevId()) == devId){
                                temp.setLineCurrent(String.valueOf(value*0.01));
                                //读取线路电流发送给wstest页面(HHP)

                                String t = temp.getLineCurrent();
                                String type = "线路电流";
                                json.put("value",t);

                                lineCurrent = t;
                                map.put("lineCurrent",t);
                                System.out.println(sAdd+"号线路电流:"+t);
                                json.put("type",type);
                                WebSocketUtil.getInstance().sendMsgToWeb(json, WebSocketUtil.PATH_SEND_WS);
                                break;
                            }
                        }
                        break;
                }
                break;
            case READ_SLAVE_PARAMETERS:
                System.out.println("04：读从机参数；");

                break;
            default:
                break;
        }

        if (lineVoltage.isEmpty() || lineCurrent.isEmpty()|| leakageCurrent.isEmpty()|| linePower.isEmpty()|| moduleTemperature.isEmpty())
        {
            //有一为空，不操作
            System.out.println("44444444444444444444444444:");
            System.out.println("lineVoltage:"+ lineVoltage);
            System.out.println("leakageCurrent:"+ leakageCurrent);
            System.out.println("linePower:"+ linePower);
            System.out.println("moduleTemperature:"+ moduleTemperature);
            System.out.println("lineCurrent:"+ lineCurrent);
        }
        else
        {
            //保存从串口中获取的实时信息
            SwitchInfo switchInfoData = new SwitchInfo();

            System.out.println("88888888888888888888888888:");
            switchInfoData.setLineVoltage(lineVoltage);
            switchInfoData.setLeakageCurrent(leakageCurrent);
            switchInfoData.setLinePower(linePower);
            switchInfoData.setModuleTemperature(moduleTemperature);
            switchInfoData.setLineCurrent(lineCurrent);

            System.out.println(sAdd+"号线路电压:" + lineVoltage);
            System.out.println(sAdd+"号线路漏电电流" + leakageCurrent);
            System.out.println(sAdd+"号线路功率:" + linePower);
            System.out.println(sAdd+"号线路模块温度:" + moduleTemperature);
            System.out.println(sAdd+"号线路电流:" + lineCurrent);
            switchInfoData.setDevId(String.valueOf(devId));
            switchInfoData.setSwitchAddress(sAdd);
            devService.updateNewData(switchInfoData);

            JSONObject sJson = new JSONObject();
            sJson.put("devId",devId);
            sJson.put("switchAddress",sAdd);
            List<SwitchInfo> switchInfoList = devService.queryDetailByDevId(sJson);
            if(switchInfoList.size()> 0){
                System.out.println("detail:"+switchInfoList);
                switchInfoData.setDevId(switchInfoList.get(0).getDevId());
                switchInfoData.setSwitchAddress(switchInfoList.get(0).getSwitchAddress());
                switchInfoData.setSwitchStatus(switchInfoList.get(0).getSwitchStatus());
                switchInfoData.setRecordTime(switchInfoList.get(0).getRecordTime());
                switchInfoData.setSwitchName(switchInfoList.get(0).getSwitchName());
                switchInfoData.setLoraSN(switchInfoList.get(0).getLoraSN());
            }
            System.out.println(sAdd+"号线路的switchInfoData：" + switchInfoData);
            devService.insertToHistory(switchInfoData);

            lineVoltage="";
            lineCurrent="";
            leakageCurrent="";
            linePower="";
            moduleTemperature="";
        }

        return null;
    }

    private String getAddress(int byteNum ,String str2)
    {
        if(str2.equals("0"))
        {
            return "";
        }

        String strAddress ="";
        //System.out.println("==================获取合闸开关地址============");
        for(int i=0; i < str2.length();i++)
        {
            //System.out.println(str2.charAt(str2.length()-1-i) + "和 " + str2.length());
            System.out.println(str2.length()-1-i + "和 " + str2.length());
            int iAddress = Integer.parseInt(String.valueOf(str2.charAt(str2.length()-1-i)));
            //System.out.println("iAddress:"+iAddress);
            if(iAddress == 1)
            {
                System.out.println("合闸开关地址: "+ (i+1+8*byteNum));
                strAddress += (i+1+8*byteNum) + ",";

                System.out.println("-------------------------------地址：" + strAddress);
            }
        }
        return strAddress.substring(0,strAddress.length()-1);
    }


    /**
     * 发送信息到串口
     * @author LinWenLi
     * @date 2018年7月21日下午3:45:22
     * @param: data
     * @return: void
     * @throws
     */
    public void sendComm(String data)
    {
        data = data.replace(" ","");
        byte[] writerBuffer = null;
        try {
            writerBuffer = hexToByteArray(data);  //hex字符串转byte数组  dd
        } catch (NumberFormatException e) {
            System.out.println("命令格式错误！");
        }

        //wstest页面修改从机地址后将地址保存到数据库中(2020-5-13,HHP)
        String devId = Integer.valueOf(data.substring(0,2),16).toString();
        String devIdNew = Integer.valueOf(data.substring(10,12),16).toString();
        //开关闸修改地址
        if(data.substring(2,10).equals("0602F0BA")){
            DevInfo devInfo = new DevInfo();
            devInfo.setDevId(devId);
            devInfo.setDevIdNew(devIdNew);
            System.out.println(devInfo);
            devService.updateDevId(devInfo);
            devService.updateSwitchDevId(devInfo);
            devService.updateHistoryDevId(devInfo);
        }else if(data.substring(2,10).equals("06015500")){//空调修改地址
            AirInfo airInfo = new AirInfo();
            airInfo.setDevId(devId);
            airInfo.setDevIdNew(devIdNew);
            devService.updateAirDevId(airInfo);
            devService.updateAirInfoDevId(airInfo);
            devService.updateAirHistoryDevId(airInfo);
        }
        try {
            outputStream = serialPort.getOutputStream();
            //加入队列
            queue.offer(data);
            System.out.println("发送数据:"+data);
            outputStream.write(writerBuffer);
            outputStream.flush();
            Thread.sleep(200);

        } catch (NullPointerException e) {
            System.out.println("找不到串口。");
        } catch (IOException e) {
            System.out.println("发送信息到串口时发生IO异常");
        }catch (InterruptedException e)
        {
            System.out.println("111111111");
        }

    }

    /**
     * 关闭串口
     * @author LinWenLi
     * @date 2018年7月21日下午3:45:43
     * @Description: 关闭串口
     * @param:
     * @return: void
     * @throws
     */
    public void closeSerialPort() {
        if (serialPort != null) {
            serialPort.notifyOnDataAvailable(false);
            serialPort.removeEventListener();
            if (inputStream != null) {
                try {
                    inputStream.close();
                    inputStream = null;
                } catch (IOException e) {
                    System.out.println("关闭输入流时发生IO异常");
                }
            }
            if (outputStream != null) {
                try {
                    outputStream.close();
                    outputStream = null;
                } catch (IOException e) {
                    System.out.println("关闭输出流时发生IO异常");
                }
            }
            serialPort.close();
            serialPort = null;
            bOpen = false;
            System.out.println("串口关闭成功");
            threadSendMsg = null;
        }
    }

    /**
     * 十六进制串口返回值获取
     */
    public String getDataHex() {
        String result = dataHex;
        // 置空执行结果
        dataHex = null;
        // 返回执行结果
        return result;
    }

    /**
     * 串口返回值获取
     */
    public String getData() {
        String result = data;
        // 置空执行结果
        data = null;
        // 返回执行结果
        return result;
    }

    /**
     * Hex字符串转byte
     * @param inHex 待转换的Hex字符串
     * @return 转换后的byte
     */
    public static byte hexToByte(String inHex) {
        return (byte) Integer.parseInt(inHex, 16);
    }

    /**
     * hex字符串转byte数组
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
     * 数组转换成十六进制字符串
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

    public static String getCOMNameString(){
        String names = "";
        Enumeration<CommPortIdentifier> portList = CommPortIdentifier.getPortIdentifiers();
        while (portList.hasMoreElements()){
            names += portList.nextElement().getName() + ",";
        }
        return names.substring(0,names.length()-1);
    }

    public static List<String> getCOMNameStringList(){
        List<String> list = new ArrayList();
        Enumeration<CommPortIdentifier> portList = CommPortIdentifier.getPortIdentifiers();
        while (portList.hasMoreElements()){
            list.add(portList.nextElement().getName());
            //System.out.println(portList.nextElement().getName());
        }
        return list;
    }



}