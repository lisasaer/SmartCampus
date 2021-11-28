package com.zy.SmartCampus.serialport;

import com.zy.SmartCampus.polo.DevInfo;
import com.zy.SmartCampus.util.CRC16Util;

import java.util.ArrayList;
import java.util.List;

public class SwitchMsgUtil {
    
    private static List<DevInfo> allDevInfoList = new ArrayList<>();

    public static List<DevInfo> getAllDevInfoList() {
        return allDevInfoList;
    }

    public static void setAllDevInfoList(List<DevInfo> allDevInfoList) {
        SwitchMsgUtil.allDevInfoList = allDevInfoList;
    }

    public static void addDevInfoToList(DevInfo devInfo){
        allDevInfoList.add(devInfo);
    }

    public static void delDevInfoFromList(DevInfo devInfo){
        for(DevInfo temp : allDevInfoList){
            if(temp.getDevSN().equals(devInfo.getDevSN())){
                allDevInfoList.remove(temp);
                break;
            }
        }
    }

    //发送间隔
    private static int sendInterval = 100 ;

    public static int getSendInterval() {
        return sendInterval;
    }

    /**
     *  单设备单地址开关闸 数据指令
     * @param devId 从机设备ID
     * @param slaveId   开关地址ID
     * @param bOpen 合闸 /开闸
     * @return
     */
    public static String singleSwitchOpenClose(int devId,int slaveId,boolean bOpen,int count){
        String msg = getHexStringByInt(devId)+"0500"+ getHexStringByInt(slaveId)+(bOpen?"00":"FF")+"00";
        msg = msg+ CRC16Util.getCRC(msg);
        System.out.println("指令:"+msg);
        SerialPortUtils.getInstance().sendComm(msg);
        //合闸时读取线路实时信息(2020-5-12,HHP)
        if(!bOpen && count > 1){
            //线路电压(2020-5-11,HHP)
            String lineVoltage =getHexStringByInt(devId)+"0300"+getHexStringByInt(slaveId)+"0002";
            lineVoltage = lineVoltage+ CRC16Util.getCRC(lineVoltage);
            System.out.println("线路电压指令:"+lineVoltage);
            SerialPortUtils.getInstance().sendComm(lineVoltage);
            //漏电电流(2020-5-11,HHP)
            String leakageCurrent =getHexStringByInt(devId)+"0301"+getHexStringByInt(slaveId)+"0002";
            leakageCurrent = leakageCurrent+ CRC16Util.getCRC(leakageCurrent);
            System.out.println("漏电电流指令:"+leakageCurrent);
            SerialPortUtils.getInstance().sendComm(leakageCurrent);
            //线路功率(2020-5-11,HHP)
            String linePower =getHexStringByInt(devId)+"0302"+getHexStringByInt(slaveId)+"0002";
            linePower = linePower+ CRC16Util.getCRC(linePower);
            System.out.println("线路功率指令:"+linePower);
            SerialPortUtils.getInstance().sendComm(linePower);
            //模块温度(2020-5-11,HHP)
            String moduleTemperature =getHexStringByInt(devId)+"0303"+getHexStringByInt(slaveId)+"0002";
            moduleTemperature = moduleTemperature+ CRC16Util.getCRC(moduleTemperature);
            System.out.println("模块温度指令:"+moduleTemperature);
            SerialPortUtils.getInstance().sendComm(moduleTemperature);
            //线路电流(2020-5-11,HHP)
            String lineCurrent =getHexStringByInt(devId)+"0304"+getHexStringByInt(slaveId)+"0002";
            lineCurrent = lineCurrent+ CRC16Util.getCRC(lineCurrent);
            System.out.println("线路电流指令:"+lineCurrent);
            SerialPortUtils.getInstance().sendComm(lineCurrent);
        }

        return msg;
    }

    public static String singleAirOpenClose(String devId,boolean bOpen,int count) {
        String msg = getHexStringByInt(Integer.valueOf(devId)) + "06014B00" + (bOpen ? "01" : "00");
        msg = msg + CRC16Util.getCRC(msg);
        System.out.println("指令:" + msg);
        SerialPortUtils.getInstance().sendComm(msg);
        //打开继电器读取空调实时信息(2020-5-14,HHP)
        if(bOpen && count > 1){
            //温度temperature
            String temperature =getHexStringByInt(Integer.valueOf(devId))+"0300010001";
            temperature = temperature+ CRC16Util.getCRC(temperature);
            System.out.println("空调温度指令:"+temperature);
            SerialPortUtils.getInstance().sendComm(temperature);
            //湿度 humidity
            String humidity =getHexStringByInt(Integer.valueOf(devId))+"0300060001";
            humidity = humidity+ CRC16Util.getCRC(humidity);
            System.out.println("空调湿度指令:"+humidity);
            SerialPortUtils.getInstance().sendComm(humidity);
            //人体红外感应 infraredInduction
            String infraredInduction =getHexStringByInt(Integer.valueOf(devId))+"0300070001";
            infraredInduction = infraredInduction+ CRC16Util.getCRC(infraredInduction);
            System.out.println("红外感应指令:"+infraredInduction);
            SerialPortUtils.getInstance().sendComm(infraredInduction);
        }
        return msg;
    }


    public static String readSwitchOpenClose(int devId,int lineCount){
        String msg = getHexStringByInt(devId)+"01000000"+getHexStringByInt(lineCount);
        msg = msg+CRC16Util.getCRC(msg);
        System.out.println("指令:"+msg);
        return msg;
    }

    /**
     * 获取hex字符串 并且 奇数位补0
     * @param i
     * @return
     */
    public static String getHexStringByInt(int i){
        String hex = Integer.toHexString(i);
        if(hex.length() % 2 != 0){
            hex = "0"+hex;
        }
        return hex;
    }

}
