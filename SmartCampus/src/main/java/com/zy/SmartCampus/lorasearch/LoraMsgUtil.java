package com.zy.SmartCampus.lorasearch;

import com.zy.SmartCampus.controller.LoraDevCtrl;
import com.zy.SmartCampus.controller.NoiseDevController;
import com.zy.SmartCampus.controller.SwitchDevCtrl;


import java.text.SimpleDateFormat;
import java.util.*;

import com.zy.SmartCampus.controller.LoraDevCtrl;
import com.zy.SmartCampus.polo.SwitchDevInfo;
import com.zy.SmartCampus.service.SwitchDevService;

public class LoraMsgUtil {
    /**
     * 服务器主动向网关发送命令
     * @param devSN 网关设备序列号
     * @param type  命令类型
     * @param id    网关ID(数据库)
     * @return
     */
    public static int interval;
    public static int chncnt;
    public static int dataLength;
    public static int data[];
    public static String uuid;
    private static SwitchDevInfo switchDevInfo;
    private static SwitchDevService switchDevService;
    //public static String devSN;

    public static Boolean SendLoraData(String devSN,String type,String id)throws InterruptedException{
        //判断发送命令是否成功
        Boolean sendDataStatus = false;

        String msg = "";
        LoraDevCtrl loraDevCtrl=new LoraDevCtrl();
        int sendType = Integer.parseInt(type,16);
        if(sendType == 0x23){
            System.out.println("发送请求----命令23：Lora网关重启设备");
            msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                    "<SRV_RESTART_REQ>" +
                    "<id>"+devSN+"</id>" +
                    "</SRV_RESTART_REQ>";
            byte[] bytes = msg.getBytes();
            //回复报文的数据长度(4字节)
            String strLen = getReturnDataLen(bytes.length);
            //得到返回报文
            String strReturnData ="FAF5F6"+"0000"+"230000".concat(strLen).concat(bytesToHexString(bytes).concat("FAF6F5"));
            //sendDataStatus = LoraPortUtil.ServerThread.sendRestart(strReturnData,devSN);
            sendDataStatus = LoraPortUtil.TcpServer.sendRestart(strReturnData,devSN);
        }
        else if(sendType == 0x24){
            System.out.println("发送请求----命令24：Lora网关升级设备");
            msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                    "<UPGRADE_FW_REQ>" +
                    "<id>"+devSN+"</id>" +
                    "<type>0<type>" +
                    "<ip>192.168.1.1</ip>" +
                    "<port>11111</port>" +
                    "</UPGRADE_FW_REQ>";
            byte[] bytes = msg.getBytes();
            //回复报文的数据长度(4字节)
            String strLen = getReturnDataLen(bytes.length);
            //得到要发送的报文
            String strReturnData ="FAF5F6"+"0000"+"240000".concat(strLen).concat(bytesToHexString(bytes).concat("FAF6F5"));
            //sendDataStatus = LoraPortUtil.ServerThread.sendUpgrade(strReturnData,devSN);
            sendDataStatus = LoraPortUtil.TcpServer.sendUpgrade(strReturnData,devSN);
        }
        else if (sendType==0x40){
            System.out.println("发送请求----命令40：查询终端设备");

            msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                    "<GET_SENSOR_REQ>" +
                    "<id>"+devSN+"</id>" +
                    "</GET_SENSOR_REQ>";
            byte[] bytes=msg.getBytes();
            String strLen =getReturnDataLen(bytes.length);//请求长度
            //封装发送的报文
            String strReturnData="FAF5F6"+"0000"+"400000".concat(strLen).concat(bytesToHexString(bytes).concat("FAF6F5"));
            //sendDataStatus=LoraPortUtil.ServerThread.sendswitchDevSelect(strReturnData,devSN);
            sendDataStatus=LoraPortUtil.TcpServer.sendswitchDevSelect(strReturnData,devSN);
        }
        else if (sendType==0x41){
            System.out.println("发送请求----命令41：设置终端设备");
            byte[] bytes = null;

            if (id.equals("17")){
                bytes=SwitchDevCtrl.msg.getBytes();
            }else if (id.equals("18")){
                bytes= NoiseDevController.msg.getBytes();
            }

            String strLen =getReturnDataLen(bytes.length);//请求长度
            //封装发送的报文
            String strReturnData="FAF5F6"+"0000"+"410000".concat(strLen).concat(bytesToHexString(bytes).concat("FAF6F5"));
            sendDataStatus=LoraPortUtil.TcpServer.sendswitchDevAdd(strReturnData,devSN);
        }
        else if (sendType==0x4a){
            System.out.println("发送请求----命令4a：批量控制终端设备开关");
            //计算并保存开关的data数组
            List<List> list=new ArrayList();
            list=LoraPortUtil.allDataList;//存放存有开关状态和uuid的list
            System.out.println("list:"+list);
//            LoraPortUtil.switchCount = "100";
            System.out.println(Integer.valueOf(LoraPortUtil.switchCount));
            here:
            for(int i=0;i<Integer.valueOf(LoraPortUtil.switchCount);i++) {

                //计算出开关状态data的长度以定义data数组的大小
                data = new int[list.get(i).size()-1];//若内循环里的判断是否，则会跳出内循环，这时需要将data数组初始化，以重新保存下一个list内的开关状态
                //dataLength=list.get(i).size();
                for(int j=0;j<list.get(i).size();j++) {

                    System.out.println(SwitchDevCtrl.uuid.toString()+list.get(i).get(j).toString());
                    if(SwitchDevCtrl.uuid.toString().equals(list.get(i).get(j).toString())){//判断是否到达目标设备list

                        break here;//如果到达目标list则跳出外层循环
                    }else if(j == list.get(i).size()-1){
                        break ;//如果不是目标list，为防止data数组越界，跳出内层循环
                    }
                    data[j] = Integer.valueOf(list.get(i).get(list.get(i).size()-j-2).toString());//循环保存开关状态至数组data
                    System.out.println("data:"+data[j]);
                }
            }
            System.out.println("进入msg");
            msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                    "<SRV_SET_AIRSWI_MUTI_STAT_REQ>" +
                    "<id>"+devSN+"</id>" +
                    "<uuid>"+SwitchDevCtrl.uuid+"</uuid>"+
                    "<start>"+0+"</start>"+
                    "<num>"+SwitchDevCtrl.chncnt+"</num>"+
                    "<stat>"+loraDevCtrl.getData(1,1,data,loraDevCtrl.address) +"</stat>"+
                    "</SRV_SET_AIRSWI_MUTI_STAT_REQ>";
            byte[] bytes=msg.getBytes();
            System.out.println(msg);
            String strLen =getReturnDataLen(bytes.length);//请求长度
            //封装发送的报文
            String strReturnData="FAF5F6"+"0000"+"4a0000".concat(strLen).concat(bytesToHexString(bytes).concat("FAF6F5"));
            System.out.println("发送的请求："+strReturnData);
            //sendDataStatus=LoraPortUtil.ServerThread.sendswitchDevCtrl(strReturnData,devSN);
            sendDataStatus=LoraPortUtil.TcpServer.sendswitchDevCtrl(strReturnData,devSN);
        }
        else if(sendType==0x4b){
            byte[] bytes=NoiseDevController.msg.getBytes();
            String strLen =getReturnDataLen(bytes.length);//请求长度
            //封装发送的报文
            String strReturnData="FAF5F6"+"0000"+"4b0000".concat(strLen).concat(bytesToHexString(bytes).concat("FAF6F5"));
            sendDataStatus=LoraPortUtil.TcpServer.sendNoiseDevCtrl(strReturnData,devSN);
        }
        return sendDataStatus;

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
}
