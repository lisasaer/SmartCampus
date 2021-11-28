package com.zy.SmartCampus.lorasearch;

import com.zy.SmartCampus.polo.LoraDevInfo;
import com.zy.SmartCampus.lorasearch.BeanContext;
import com.zy.SmartCampus.service.LoraDevService;
import lombok.SneakyThrows;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;

public class UdpMsgInHandler extends ServerSocket {


    public LoraDevService loraDevService;

    public static List<LoraDevInfo> devList = new ArrayList<>();//搜索出来的设置
    public static List<LoraDevInfo> newDevList =  new ArrayList<>();//搜索出来的设置(无重复数据)
    public static LoraDevInfo loraDevInfo  = new LoraDevInfo();

    public static String dataHex;
    private static DatagramSocket datagramSocket;
    public static int len;
    public static int port;
    public static String ip;
   // public static String seqNumber = "0000";
    public static String sendDevSN ;
    Boolean flag =true;
    //public static String devSN;
    private static final int PORT = 8824;
    public static void connectLora() throws Exception
    {
        new Thread(new Runnable() {
            @SneakyThrows
            @Override
            public void run() {
                /*try {
                    //数据报套接字并将其绑定到本地主机上的指定端口8824（对应发送端创建的端口）
                    datagramSocket = new DatagramSocket(PORT);
                    System.out.println("udp服务端已经启动！");
                } catch (Exception e) {
                    datagramSocket = null;
                    System.out.println("udp服务端启动失败！");
                    e.printStackTrace();
                }*/
                try {
                    // 创建服务器端的DatagramSocket，并指定端口
                    datagramSocket = new DatagramSocket(8824);
                    System.out.println("*****  启动服务器，等待客户端的连接请求  ******");
                    while(true) {

                        byte[] data = new byte[2048];
                        // 创建数据报，用于接受客户端请求的数据
                        DatagramPacket datagramPacket = new DatagramPacket(data, data.length);
                        // 接收客户端请求的数据（在接收到数据之前一直处于阻塞状态）
                        datagramSocket.receive(datagramPacket);
                        // 获取请求的数据，并转成String打印出来
                        String clientData = new String(data, 0, datagramPacket.getLength());
                        //System.out.println("我是服务端，客户端请求的数据为：" + clientData);
                        //再将数据报包转换成字节数组
                        byte[] arr = datagramPacket.getData();
                        //获取数据包的大小
                        len = datagramPacket.getLength();
                        //将数据由数组转化为16进制字符串
                        dataHex = bytesToHexString(arr).substring(0, len * 2);
                        System.out.println("获取到的数据长度:" + len + "  " + dataHex.length() + "    " + dataHex);
                        //获取Lora网关IP地址
                        ip = datagramPacket.getAddress().getHostAddress();
                        InetAddress address = datagramPacket.getAddress();
                        //获取Lora网关端口号
                        String portData = dataHex.substring(14, 18);
                        port = Integer.parseInt(portData, 16);

                        System.out.println("ip = " + ip + "; port : " + port + " ; address " + address);
                        //获取报文中的数据部分，并转化为数组
                        String data2 = dataHex.substring(18);
                        byte[] b = hexStringToBytes(data2);
                        String devSN = new String(b);
                        System.out.println("设备序列号 ： " + devSN);

                        //  *** 给客户端进行响应 ***
                        // 定义客户端的地址
                        InetAddress inetAddress = datagramPacket.getAddress();
                        //定义需返回的数据
                        int dataLen = dataHex.substring(18).length() / 2;

                        String rLen = getHexLen(dataLen);
                        String rData = "F7FBF9A231".concat(rLen + dataHex.substring(18));
                        byte[] backData = hexToByteArray(rData);
                        // 创建数据包，给客户端响应数据
                        DatagramPacket backDatagramPacket = new DatagramPacket(backData, backData.length, InetAddress.getByName(ip), port);
                        // 给客户端发送数据
                        datagramSocket.send(backDatagramPacket);
                        System.out.println("实际长度： backData.length " + backData.length + " rData " + rData + " backData " + backData + " port " + port);
                        //监听Lora网关TCP连接传输的数据
                        new UdpMsgInHandler(8825);
                        Thread.sleep(1000);
                        //datagramSocket.close();
                    }
                } catch (IOException e) {
                    System.out.println("Lora网关UDP广播时发生异常");
                }
            }
        }).start();
    }


    //向客户端发送查询空开请求
    class SendSelectMsgtoAir extends Thread{
        private Socket socket;
        private LoraDevService loraDevService;
        public SendSelectMsgtoAir(Socket s) throws IOException
        {
            this.socket = s;
            this.loraDevService = BeanContext.getBean(LoraDevService.class);
            start();                /*开始线程*/
        }
        public void run()
        {
            try{
                OutputStream outputStream = socket.getOutputStream();
                String msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                        "<GET_SENSOR_REQ>" +
                        "<id>"+sendDevSN+"</id>" +
                        "</GET_SENSOR_REQ>";
                byte[] bytes = msg.getBytes();
                //回复报文的数据长度(4字节)
                String strLen = getReturnDataLen(bytes.length);
                //得到返回报文
                String strReturnData ="FAF5F6"+"0000"+"400000".concat(strLen).concat(bytesToHexString(bytes).concat("FAF6F5"));
                System.out.println("----------发送查询空开设备报文-------------：" + strReturnData);
                System.out.println("发送查询空开设备报文字符串长度："+strReturnData.length());

                byte[] sendData = hexToByteArray(strReturnData);
                System.out.println("发送查询空开设备报文二进制长度：" + sendData.length +";"+sendData);
                outputStream.write(sendData);
                Thread.sleep(200);
                flag =false;
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
            catch (InterruptedException i)
            {
                i.printStackTrace();
            }
        }
    }
    //向客户端发送设置空开请求
    class SendSetMsgtoAir extends Thread{
        private Socket socket;
        private LoraDevService loraDevService;
        public SendSetMsgtoAir(Socket s) throws IOException
        {
            this.socket = s;
            this.loraDevService = BeanContext.getBean(LoraDevService.class);
            start();                /*开始线程*/
        }
        public void run()
        {
            try{
                OutputStream outputStream = socket.getOutputStream();
                String msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                        "<SET_SENSOR_REQ>" +
                        "<id>"+sendDevSN+"</id>" +
                        "<count>2</count>" +
                        "<list>" +
                        "<sensor>" +
                        "<uuid>000002</uuid>" +
                        "<sensor_type>16</sensor_type>" +
                        "<port>0</port>" +
                        "<interval>10</interval>" +
                        "<chn_cnt>6</chn_cnt>" +
                        "<chn_list>" +
                        "<chn>" +
                        "<chn_type>19</chn_type>" +
                        "<thr>0</thr>"+
                        "</chn>" +
                        "<chn>" +
                        "<chn_type>19</chn_type>" +
                        "<thr>0</thr>"+
                        "</chn>" +
                        "<chn>" +
                        "<chn_type>19</chn_type>" +
                        "<thr>0</thr>"+
                        "</chn>" +
                        "<chn>" +
                        "<chn_type>19</chn_type>" +
                        "<thr>0</thr>"+
                        "</chn>" +
                        "<chn>" +
                        "<chn_type>19</chn_type>" +
                        "<thr>0</thr>"+
                        "</chn>" +
                        "<chn>" +
                        "<chn_type>19</chn_type>" +
                        "<thr>0</thr>"+
                        "</chn>" +
                        "</chn_list>" +
                            "</sensor>" +
                        "<sensor>" +
                        "<uuid>000003</uuid>" +
                        "<sensor_type>12</sensor_type>" +
                        "<port>0</port>" +
                        "<interval>10</interval>" +
                        "<chn_cnt>6</chn_cnt>" +
                        "<chn_list>" +
                        "<chn>" +
                        "<chn_type>19</chn_type>" +
                        "<thr>0</thr>"+
                        "</chn>" +
                        "<chn>" +
                        "<chn_type>19</chn_type>" +
                        "<thr>0</thr>"+
                        "</chn>" +
                        "<chn>" +
                        "<chn_type>19</chn_type>" +
                        "<thr>0</thr>"+
                        "</chn>" +
                        "<chn>" +
                        "<chn_type>19</chn_type>" +
                        "<thr>0</thr>"+
                        "</chn>" +
                        "<chn>" +
                        "<chn_type>19</chn_type>" +
                        "<thr>0</thr>"+
                        "</chn>" +
                        "<chn>" +
                        "<chn_type>19</chn_type>" +
                        "<thr>0</thr>"+
                        "</chn>" +
                        "</chn_list>" +
                        "</sensor>" +
                        "</list>" +
                        "</SET_SENSOR_REQ>";
                byte[] bytes = msg.getBytes();
                //回复报文的数据长度(4字节)
                String strLen = getReturnDataLen(bytes.length);
                //得到返回报文
                String strReturnData ="FAF5F6"+"0000"+"410000".concat(strLen).concat(bytesToHexString(bytes).concat("FAF6F5"));
                System.out.println("----------发送设置空开设备报文-------------：" + strReturnData);
                System.out.println("发送设置空开设备报文字符串长度："+strReturnData.length());

                byte[] sendData = hexToByteArray(strReturnData);
                System.out.println("发送设置空开设备报文二进制长度：" + sendData.length +";"+sendData);
                outputStream.write(sendData);
                Thread.sleep(200);
                flag =false;
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
            catch (InterruptedException i)
            {
                i.printStackTrace();
            }
        }
    }

    //向客户端发送控制空开状态请求
    class SendMagStaMsgtoAir extends Thread{
        private Socket socket;
        private LoraDevService loraDevService;
        public SendMagStaMsgtoAir(Socket s) throws IOException
        {
            this.socket = s;
            this.loraDevService = BeanContext.getBean(LoraDevService.class);
            start();                /*开始线程*/
        }
        public void run()
        {
            try{
                OutputStream outputStream = socket.getOutputStream();
                String msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                        "<SRV_SET_AIRSWI_STAT_REQ>" +
                        "<id>"+sendDevSN+"</id>" +
                        "<uuid>000002</uuid>" +
                        "<chn>0</chn>"+
                        "<stat>0</stat>"+
                        "</SRV_SET_AIRSWI_STAT_REQ>";
                byte[] bytes = msg.getBytes();
                //回复报文的数据长度(4字节)
                String strLen = getReturnDataLen(bytes.length);
                //得到返回报文
                String strReturnData ="FAF5F6"+"0000"+"490000".concat(strLen).concat(bytesToHexString(bytes).concat("FAF6F5"));
                System.out.println("----------发送控制空开开关状态报文-------------：" + strReturnData);
                System.out.println("发送控制空开开关状态报文字符串长度："+strReturnData.length());

                byte[] sendData = hexToByteArray(strReturnData);
                System.out.println("发送控制空开开关状态报文二进制长度：" + sendData.length +";"+sendData);
                outputStream.write(sendData);
                Thread.sleep(200);
                flag =false;
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
            catch (InterruptedException i)
            {
                i.printStackTrace();
            }
        }
    }
    //向客户端发送批量控制空开状态请求
    class SendHandSometoAir extends Thread{
        private Socket socket;
        private LoraDevService loraDevService;
        public SendHandSometoAir(Socket s) throws IOException
        {
            this.socket = s;
            this.loraDevService = BeanContext.getBean(LoraDevService.class);
            start();                /*开始线程*/
        }
        public void run()
        {
            try{
                OutputStream outputStream = socket.getOutputStream();
                String msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                        "<SRV_SET_AIRSWI_MUTI_STAT_REQ>" +
                        "<id>"+sendDevSN+"</id>" +
                        "<uuid>000003</uuid>" +
                        "<start>0</start>"+
                        "<num>6</num>"+
                        "<stat>63</stat>"+
                        "</SRV_SET_AIRSWI_MUTI_STAT_REQ>";
                byte[] bytes = msg.getBytes();
                //回复报文的数据长度(4字节)
                String strLen = getReturnDataLen(bytes.length);
                //得到返回报文
                String strReturnData ="FAF5F6"+"0000"+"4a0000".concat(strLen).concat(bytesToHexString(bytes).concat("FAF6F5"));
                System.out.println("----------发送批量控制空开开关状态报文-------------：" + strReturnData);
                System.out.println("发送批量控制空开开关状态报文字符串长度："+strReturnData.length());

                byte[] sendData = hexToByteArray(strReturnData);
                System.out.println("发送批量控制空开开关状态报文二进制长度：" + sendData.length +";"+sendData);
                outputStream.write(sendData);
                Thread.sleep(200);
                flag =false;
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
            catch (InterruptedException i)
            {
                i.printStackTrace();
            }
        }
    }

    public UdpMsgInHandler(int serverPort) throws IOException
    {
        super(serverPort);
        try
        {
           /* while (true)
            {*/
                Socket socket = accept();
                new UdpMsgInHandler.ServerThread(socket);
            /*}*/
        } catch (IOException e) {
            e.printStackTrace();
        }
        finally {
            close();
        }
    }

    //查询终端传感器
    class QuerySensorThread extends Thread{
        private Socket socket;
        private LoraDevService loraDevService;
        public QuerySensorThread(Socket s) throws IOException
        {
            this.socket = s;
            this.loraDevService = BeanContext.getBean(LoraDevService.class);
            start();                /*开始线程*/
        }

        public void run()
        {
            try{
                OutputStream outputStream = socket.getOutputStream();
                String msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                        "<GET_SENSOR_REQ>" +
                        "<id>"+sendDevSN+"</id>" +
                        "</GET_SENSOR_REQ>";
                byte[] bytes = msg.getBytes();
                //回复报文的数据长度(4字节)
                String strLen = getReturnDataLen(bytes.length);

                String seqNumber = loraDevService.querySEQByDevSN(sendDevSN).get(0).getSeqNumber();
                System.out.println("获取流水号 ： " + seqNumber);
                //得到返回报文
                String strReturnData ="FAF5F6"+"0000"+"400000".concat(strLen).concat(bytesToHexString(bytes).concat("FAF6F5"));
                System.out.println("----------发送查询终端传感器报文-------------：" + strReturnData);
                System.out.println("发送查询终端传感器报文字符串长度："+strReturnData.length());

                byte[] sendData = hexToByteArray(strReturnData);
                System.out.println("发送查询终端传感器报文二进制长度：" + sendData.length +";"+sendData);
                outputStream.write(sendData);
                Thread.sleep(200);
                flag =false;
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
            catch (InterruptedException i)
            {
                i.printStackTrace();
            }
        }
    }

    //升级设备(lora网关)
    class UpgradeDevThread extends Thread{
        private Socket socket;
        private LoraDevService loraDevService;
        public UpgradeDevThread(Socket s) throws IOException
        {
            this.socket = s;
            this.loraDevService = BeanContext.getBean(LoraDevService.class);
            start();                /*开始线程*/
        }

        public void run()
        {
            try{
                OutputStream outputStream = socket.getOutputStream();
                String msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                        "<UPGRADE_FW_REQ>" +
                        "<id>"+sendDevSN+"</id>" +
                        "<type>0<type>" +
                        "<ip>192.168.1.1</ip>" +
                        "<port>11111</port>" +
                        "</UPGRADE_FW_REQ>";
                byte[] bytes = msg.getBytes();
                //回复报文的数据长度(4字节)
                String strLen = getReturnDataLen(bytes.length);
                //this.loraDevService= BeanContext.getApplicationContext().getBean(LoraDevService.class);
                String seqNumber = loraDevService.querySEQByDevSN(sendDevSN).get(0).getSeqNumber();
                System.out.println("获取流水号 ： " + seqNumber);
                //得到返回报文
                String strReturnData ="FAF5F6"+"0000"+"240000".concat(strLen).concat(bytesToHexString(bytes).concat("FAF6F5"));
                System.out.println("----------发送升级设备报文-------------：" + strReturnData);
                System.out.println("发送升级设备报文字符串长度："+strReturnData.length());

                byte[] sendData = hexToByteArray(strReturnData);
                System.out.println("发送升级设备报文二进制长度：" + sendData.length +";"+sendData);
                outputStream.write(sendData);
                Thread.sleep(200);
                flag =false;
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
            catch (InterruptedException i)
            {
                i.printStackTrace();
            }
        }
    }

    //重启lora网关设备
    class RestartDevThread extends Thread{
        private Socket socket;
        private LoraDevService loraDevService;
        public RestartDevThread(Socket s) throws IOException
        {
            this.socket = s;
            this.loraDevService = BeanContext.getBean(LoraDevService.class);
            start();                /*开始线程*/
        }

        public void run()
        {
            try{
                OutputStream outputStream = socket.getOutputStream();
                String msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                        "<SRV_RESTART_REQ>" +
                        "<id>"+sendDevSN+"</id>" +
                        "</SRV_RESTART_REQ>";
                byte[] bytes = msg.getBytes();
                //回复报文的数据长度(4字节)
                String strLen = getReturnDataLen(bytes.length);
                //得到返回报文
                String strReturnData ="FAF5F6"+"0000"+"230000".concat(strLen).concat(bytesToHexString(bytes).concat("FAF6F5"));
                System.out.println("----------发送重启设备报文-------------：" + strReturnData);
                System.out.println("发送重启设备报文字符串长度："+strReturnData.length());

                byte[] sendData = hexToByteArray(strReturnData);
                System.out.println("发送重启设备报文二进制长度：" + sendData.length +";"+sendData);
                outputStream.write(sendData);
                Thread.sleep(200);
                flag =false;
            }
            catch (IOException e)
            {
                e.printStackTrace();
            }
            catch (InterruptedException i)
            {
                i.printStackTrace();
            }
        }
    }

    //监听lora请求信息并返回消息
    class ServerThread extends Thread       /*建立服务端线程*/
    {
        private Socket socket;

        public ServerThread(Socket s) throws IOException
        {
            this.socket = s;

            start();                /*开始线程*/
        }

        public void run()
        {

                while (true)
                {
                    try
                    {
                    // 通过输入流接收客户端信息
                    byte[] buf = new byte[2048];
                    int length = 0;
                    InputStream inputStream = socket.getInputStream();
                    OutputStream outputStream = socket.getOutputStream();

                    length = inputStream.read(buf);
                    System.out.println("读取数据长度:" + length);
                    if (length < 1)
                    {
                        continue;
                    }

                    //如果用while，那在outputStream.write返回客户端信息时会报错
                    //没有使用while，可能存在一次读取的数据不完全问题
//                    while((length = inputStream.read(buf))!=-1)
//                    {
//                        //System.out.println(new String(buf,0,length,"utf-8"));
//                    }
                    //将接收到的数据在控制台输出 byte转为16进制字符串
                    String string =bytesToHexString(buf);
                    System.out.println("接收到的数据 ： " + string);

                    //dealData(string);
                    //----------------------------------------------------------------------------------------------
                    //网关发送的数据长度和类型
                    int length1 = Integer.parseInt(string.substring(16,24),16);
                    int type = Integer.parseInt(string.substring(10,12),16);
                    System.out.println("网关发送的数据长度length : " + length1 + " ; 网关发送的报文类型type : " + type);
                    //接收需要返回报文二进制
                    byte[] returnData = new byte[2048];
                    String strData =string.substring(24,24+length1*2);
                    System.out.println("报文的数据内容 : " + strData);
                    byte[] b = hexStringToBytes(strData);
                    //报文的数据内容----XML文件形式
                    String devRegister = new String(b);
                     sendDevSN = devRegister.substring(devRegister.indexOf("<id>"), devRegister.indexOf("</id>")).substring(4);

                    //服务器回复网关的报文头header和报文尾tail
                    String header = string.substring(0,16);
                    String tail = string.substring(length1*2+24,length1*2+30);

                    switch (type)
                    {
                        case 0x21:
                            System.out.println("命令21：Lora网关设备注册");
                            System.out.println("设备注册 ： " + devRegister);
                            String msg ="<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                                    "<REGISTE_RES>" +
                                    "<id>"+ sendDevSN +"</id>" +
                                    "<ret>0</ret>" +
                                    "</REGISTE_RES>";
                            byte[] bytes = msg.getBytes();
                            //回复报文的数据长度(4字节)
                            String strLen = getReturnDataLen(bytes.length);
                            //得到返回报文
                            String strReturnData =header.concat(strLen).concat(bytesToHexString(bytes).concat(tail));
                            System.out.println("----------返回注册报文-------------：" + strReturnData);
                            System.out.println("返回报文字符串长度："+strReturnData.length());

                            byte[] backData = hexToByteArray(strReturnData);
                            System.out.println("返回报文二进制长度：" + backData.length +";"+backData);
                            returnData=backData;
                            dealData(string);
                            break;
                        case 0x22:
                            System.out.println("命令22：Lora网关设备心跳");
                            System.out.println("设备心跳 ： " + devRegister);
                            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式
                            String date = df.format(new Date()).replaceAll("[[\\s-:punct:]]","");//获取当前系统时间并转为纯数字
                            String msg2 ="<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                                    "<HB_RES>" +
                                    "<id>"+ sendDevSN +"</id>" +
                                    "<ret>0</ret>" +
                                    "<time>"+ date +"</time>" +
                                    "</HB_RES>";

                            byte[] bytes2 = msg2.getBytes();
                            String strLen2 = getReturnDataLen(bytes2.length);
                            //得到返回报文
                            String strReturnData2 =header.concat(strLen2).concat(bytesToHexString(bytes2).concat(tail));
                            System.out.println("----------返回心跳报文-------------：" + strReturnData2);
                            System.out.println("返回报文字符串长度："+strReturnData2.length());

                            byte[] backData2 = hexToByteArray(strReturnData2);
                            System.out.println("返回报文二进制长度：" + backData2.length +";"+backData2);
                            returnData=backData2;
                            new UdpMsgInHandler.RestartDevThread(socket);
                            //new UdpMsgInHandler.UpgradeDevThread(socket);
                            //new UdpMsgInHandler.QuerySensorThread(socket);

                            //new UdpMsgInHandler.SendSetMsgtoAir(socket);//向客户端发送设置请求
                            new UdpMsgInHandler.SendHandSometoAir(socket);//向客户端发送批量控制开关状态请求
                            //new UdpMsgInHandler.SendMagStaMsgtoAir(socket);//向客户端发送控制开关状态请求
                            //new UdpMsgInHandler.SendSelectMsgtoAir(socket);//向客户端发送查询请求
                            break;
                        case 0x23:
                            System.out.println("命令23：Lora网关重启设备");
                            System.out.println("重启设备 ： " + devRegister);

                            break;
                        case 0x24:
                            System.out.println("命令24：Lora网关升级设备");
                            System.out.println("升级设备 ： " + devRegister);

                            break;
                        case 0x40:
                            System.out.println("命令40：查询终端传感器");
                            System.out.println("查询终端传感器 ： " + devRegister);

                            break;
                        case 0x41:
                            System.out.println("命令41：设置终端传感器");
                            System.out.println("设置终端传感器 ： " + devRegister);

                            break;
                        case 0x42:
                            System.out.println("命令42：终端设备上报传感器实时数据");
                            System.out.println("终端设备上报传感器实时数据 ： " + devRegister);

                            String msg42 ="<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                                    "<UP_SENSOR_REALDATA_RES>" +
                                    "<id>"+ sendDevSN +"</id>" +
                                    "<ret>0</ret>" +
                                    "</UP_SENSOR_REALDATA_RES>";

                            byte[] bytes42 = msg42.getBytes();
                            String strLen42 = getReturnDataLen(bytes42.length);
                            //得到返回报文
                            String strReturnData42 =header.concat(strLen42).concat(bytesToHexString(bytes42).concat(tail));
                            System.out.println("----------返回上报实时数据报文-------------：" + strReturnData42);
                            System.out.println("返回报文字符串长度："+strReturnData42.length());

                            byte[] backData42 = hexToByteArray(strReturnData42);
                            System.out.println("返回报文二进制长度：" + backData42.length +";"+backData42);
                            returnData=backData42;
                            break;
                        case 0x43:
                            System.out.println("命令43：终端设备上报传感器故障");
                            System.out.println("终端设备上报传感器故障 ： " + devRegister);

                            break;
                        case 0x44:
                            System.out.println("命令44：服务器控制终端上报温度矩阵全局数据开关");
                            System.out.println("服务器控制终端上报温度矩阵全局数据开关 ： " + devRegister);

                            break;
                        case 0x45:
                            System.out.println("命令45：终端设备上报温度矩阵数据");
                            System.out.println("终端设备上报温度矩阵数据 ： " + devRegister);

                            break;
                        case 0x46:
                            System.out.println("命令46：终端设备上报告警数据");
                            System.out.println("终端设备上报告警数据 ： " + devRegister);
                            String msg46 ="<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                                    "<UP_SENSOR_WARN_RES>" +
                                    "<id>"+ sendDevSN +"</id>" +
                                    "<ret>0</ret>" +
                                    "</UP_SENSOR_WARN_RES>";
                            byte[] bytes46 = msg46.getBytes();
                            String strLen46 = getReturnDataLen(bytes46.length);
                            //得到返回报文
                            String strReturnData46 =header.concat(strLen46).concat(bytesToHexString(bytes46).concat(tail));
                            System.out.println("----------返回上报告警数据报文-------------：" + strReturnData46);
                            System.out.println("返回报文字符串长度："+strReturnData46.length());

                            byte[] backData46= hexToByteArray(strReturnData46);
                            System.out.println("返回报文二进制长度：" + backData46.length +";"+backData46);
                            returnData=backData46;
                            break;
                        case 0x47:
                            System.out.println("命令47：终端设备上报状态改变");
                            System.out.println("终端设备上报状态改变 ： " + devRegister);

                            break;
                        case 0x48:
                            System.out.println("命令48：服务器控制终端状态");
                            System.out.println("服务器控制终端状态 ： " + devRegister);

                            break;

                    }
//                String header = string.substring(0,16);
//                //System.out.println("头  ： "  + header);
//                int length1 = Integer.parseInt(string.substring(16,24),16);
//                String tail = string.substring(length1*2+24,length1*2+30);
//                //System.out.println(" 尾  ： " + tail);
//                //服务器给客户端回复注册成功消息
//                String msg ="<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
//                        "<REGISTE_RES>" +
//                        "<id>"+ devSN +"</id>" +
//                        "<ret>0</ret>" +
//                        "</REGISTE_RES>";
//
//                //System.out.println("msg 长度:" + msg.length());
//                byte[] bytes = msg.getBytes();
//                //System.out.println("bytes 长度:" + bytes.length);
//                String strLen = getReturnDataLen(bytes.length);
//                //System.out.println(strLen);
//
//                //得到返回报文
//                String strReturnData =header.concat(strLen).concat(bytesToHexString(bytes).concat(tail));
//                System.out.println("----------注册返回报文-------------：" + strReturnData);
//                System.out.println("返回报文字符串长度："+strReturnData.length());
//
//                byte[] backData = hexToByteArray(strReturnData);
//                System.out.println("返回报文二进制长度：" + backData.length +";"+backData);
//                    Thread.sleep(1000);
                    outputStream.write(returnData);
                    outputStream.flush();
                    Thread.sleep(500);

                    //while中close运行报错，放while外编译报错 !!!
//                    outputStream.close();
//                    inputStream.close();
//                    socket.close();
                    System.out.println("*************返回结束*************");
                    }
                    catch (IOException e)
                    {
                        e.printStackTrace();
                    }
                    catch (InterruptedException i)
                    {
                        i.printStackTrace();
                    }
                }


        }
    }

    public String dealData(String string){
        int length = Integer.parseInt(string.substring(16,24),16);
        int type = Integer.parseInt(string.substring(10,12),16);
        System.out.println("length : " + length + " ; type : " + type);
        switch (type){
            case 0x21:
                System.out.println("命令21：Lora网关设备注册");
                String strData =string.substring(24,24+length*2);
                System.out.println("strData : " + strData);
                byte[] b = hexStringToBytes(strData);
                String devRegister = new String(b);
                System.out.println("设备注册 ： " + devRegister);
                String devSN = devRegister.substring(devRegister.indexOf("<id>"), devRegister.indexOf("</id>")).substring(4);
                String swVer = devRegister.substring(devRegister.indexOf("<sw_ver>"), devRegister.indexOf("</sw_ver>")).substring(8);
                String fwVer = devRegister.substring(devRegister.indexOf("<fw_ver>"), devRegister.indexOf("</fw_ver>")).substring(8);
                String mac = devRegister.substring(devRegister.indexOf("<mac>"), devRegister.indexOf("</mac>")).substring(5);
                String ip = devRegister.substring(devRegister.indexOf("<ip>"), devRegister.indexOf("</ip>")).substring(4);
                String imsi = devRegister.substring(devRegister.indexOf("<imsi>"), devRegister.indexOf("</imsi>")).substring(6);
                String iccid = devRegister.substring(devRegister.indexOf("<iccid>"), devRegister.indexOf("</iccid>")).substring(7);
                String io_output = devRegister.substring(devRegister.indexOf("<io_output>"), devRegister.indexOf("</io_output>")).substring(11);
                String io_input = devRegister.substring(devRegister.indexOf("<io_input>"), devRegister.indexOf("</io_input>")).substring(10);
                String rs485 = devRegister.substring(devRegister.indexOf("<rs485>"), devRegister.indexOf("</rs485>")).substring(7);
                String sub1g = devRegister.substring(devRegister.indexOf("<sub1g>"), devRegister.indexOf("</sub1g>")).substring(7);
                String desc = devRegister.substring(devRegister.indexOf("<desc>"), devRegister.indexOf("</desc>")).substring(6);

//                System.out.println("XML文中的内容\n" +
//                        "设备序列号 devSN : \n" + devSN + "\n" +
//                        "协议版本 sw_ver : \n" + swVer + "\n" +
//                        "设备固件版本 fw_ver : \n" + fwVer + "\n" +
//                        "硬件地址 mac : \n" + mac + "\n" +
//                        "设备IP地址 ip : \n" + ip + "\n" +
//                        "imsi : \n" + imsi + "\n" +
//                        "iccid : \n" + iccid + "\n" +
//                        "输出IO数量io_output : \n" + io_output + "\n" +
//                        "输入IO数量io_input : \n" + io_input + "\n" +
//                        "rs485接口数量 rs485 : \n" + rs485 + "\n" +
//                        "sublg接口数量 sub1g : \n" + sub1g + "\n" +
//                        "设备描述 desc : \n" + desc + "\n" );

                String netmask = "255.255.255.0";
                String defaultGateway = "192.168.0.1";
                String macAddress = mac.substring(0,2) + ":" + mac.substring(2,4) + ":" + mac.substring(4,6) + ":" +
                        mac.substring(6,8) + ":" + mac.substring(8,10) + ":" + mac.substring(10,12);
                //给前端传送参数
                LoraDevInfo loraDevInfo  = new LoraDevInfo();
                loraDevInfo.setIp(ip);
                loraDevInfo.setLoraSN(devSN);
                loraDevInfo.setPort(port);
                loraDevInfo.setNetmask(netmask);
                loraDevInfo.setDefaultGateway(defaultGateway);
                loraDevInfo.setMacAddress(macAddress.toUpperCase());
                devList.add(loraDevInfo);
                System.out.println("devList :" +devList);
                for(int i = 0; i < devList.size(); i ++){
                List<LoraDevInfo> list =  new LinkedList<>();
                list.addAll(devList);
                if(!newDevList.contains(list.get(i))){
                    newDevList.add(list.get(i));
                }
            }
                System.out.println("里面的"+devList);

                break;
        }


        return null;
    }



    public String SEQNumber(String str){
        this.loraDevService = BeanContext.getBean(LoraDevService.class);
        System.out.println(str);
        int i = Integer.parseInt(str,16);
        System.out.println("前面的i : " + i);
        String seqNumber ="";
        if(i < 65535 && i > 0 ){
            String seq = Integer.toHexString(i++);
            for(int j = 0 ;j < (4-seq.length()) ; j++){
                seqNumber = seqNumber+"0";
            }
            seqNumber = seqNumber + seq ;
        }else{
            seqNumber = "0000";
        }
        LoraDevInfo loraDevInfo = new LoraDevInfo();
        loraDevInfo.setLoraSN(sendDevSN);
        loraDevInfo.setSeqNumber(seqNumber);
        loraDevService.updateSEQ(loraDevInfo);
        System.out.println("后面的i : " + i);
        System.out.println("流水号 : " + seqNumber);
        return seqNumber;
    }


    /**
     * 获取hex字符串 并且 奇数位补0
     * @param i
     * @return
     */
    public static String getReturnDataLen(int i){
        String hex = Integer.toHexString(i);

        for(int j = 0 ; j <8-Integer.toHexString(i).length() ; j++){
            hex="0"+hex;
        }
        return hex.toUpperCase();
    }


    //将数据返回给Ctrl层
    public static List<LoraDevInfo> getLoraDevInfo() {
        System.out.println("实际返回的newDevList ： " + newDevList);
        return newDevList;
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
     * Hex字符串转byte
     * @param inHex 待转换的Hex字符串
     * @return 转换后的byte
     */
    public static byte hexToByte(String inHex) {
        return (byte) Integer.parseInt(inHex, 16);
    }

    /**
     * 数组转换成十六进制字符串
     * @param
     * @return HexString
     */
    public static final String bytesToHexString(byte[] bArray)
    {
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
     * @param
     * @return byte
     */
    public static final byte[] hexStringToBytes(String str) {
        int len = str.length();
        byte[] arr = new byte[len/2];
        for(int i = 0;i < len;i+=2) {
            arr[i/2] = (byte) ((
                    Character.digit(str.charAt(i), 16) << 4) +
                    Character.digit(str.charAt(i+1), 16));
        }
        return arr;

    }
    /**
     * 获取hex字符串 并且 奇数位补0
     * @param i
     * @return
     */
    public static String getHexLen(int i){
        String hex = Integer.toHexString(i);
        if(hex.length() == 1){
            hex = "000" + hex;
        }else if (hex.length() == 2){
            hex = "00" + hex;
        }else if (hex.length() == 3){
            hex = "0" +hex;
        }
        return hex.toUpperCase();
    }

}
