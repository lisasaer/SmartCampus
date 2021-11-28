package com.zy.SmartCampus.polo;

import lombok.Data;

import java.util.List;

/**
 * @author: duzhibin
 * @description:
 * @date: create in 19:22 2021/7/22
 */
@Data
public class ZigBeeGatewayDevInfoTest {


    private String id;//设备Id
    private String ep;//设备端口
    private String pid;//协议
    private String did;//设备类型ID
    private String ol;//在线状态（true：在线，false：掉线）
    private String dn;//设备名称
    private String dtype;//当前端口的设备类型
    private String fac;//厂家名
    private String ztype;//zone 设备类型
    private String dsp;//厂商对设备的描述
    private String swid;//软件ID，软件版本号
    private List<ZigBeeGatewayDevStatus> st;


    private String didName;//设备类型Name


    @Data
    public static class ZigBeeGatewayDevStatus {
        private String on;//开关状态:true：开false：关
        private String eplist;//设备所有端口的列表，例如设备有 1、2、3 端 口 ， eplist 为“0010002003”，端口列表没有顺序，也可以 为“002001003”
        private String dsp;////厂商对设备的描述
        private String ztype;////zone 设备类型
        private String ps;//电源类型
        private String wmode;//空调模式
        private String pt;//窗帘开度
        private String swid;//软件ID，软件版本号
        private String mlux;//测量光照度
        private String zsta;//zone 设备状态
        private String mhumi;//测量湿度
        private String mtemp;//测量温度
        private String inle;//红外码
        private String indsp;//红外码库信息
        private String inct;//红外控制命令
        private String cts;//电机操作---0：关，向下，反转等；1：开，向上，正转等；2：停止//工作模式---3：正转；4：反转//  9：设置边界  ；10：取消边界
        @Override
        public String toString() {
            return "{" +
                    "\"on\":\"" + on + '\"' +
                    ", \"eplist\":\"" + eplist + '\"' +
                    ", \"dsp\":\"" + dsp + '\"' +
                    ", \"ztype\":\"" + ztype + '\"' +
                    ", \"ps\":\"" + ps + '\"' +
                    ", \"wmode\":\"" + wmode + '\"' +
                    ", \"pt\":\"" + pt + '\"' +
                    ", \"swid\":\"" + swid + '\"' +
                    ", \"mlux\":\"" + mlux + '\"' +
                    ", \"zsta\":\"" + zsta + '\"' +
                    ", \"mhumi\":\"" + mhumi + '\"' +
                    ", \"mtemp\":\"" + mtemp + '\"' +
                    ", \"inle\":\"" + inle + '\"' +
                    ", \"indsp\":\"" + indsp + '\"' +
                    ", \"inct\":\"" + inct + '\"' +
                    ", \"cts\":\"" + cts + '\"' +
                    '}';
        }
    }


    @Override
    public String toString() {
        return "{" +
                "\"id\":\"" + id + '\"' +
                ", \"ep\":\"" + ep + '\"' +
                ", \"pid\":\"" + pid + '\"' +
                ", \"did\":\"" + did + '\"' +
                ", \"ol\":\"" + ol + '\"' +
                ", \"dn\":\"" + dn + '\"' +
                ", \"dtype\":\"" + dtype + '\"' +
                ", \"fac\":\"" + fac + '\"' +
                ", \"ztype\":\"" + ztype + '\"' +
                ", \"dsp\":\"" + dsp + '\"' +
                ", \"swid\":\"" + swid + '\"' +
                ", \"st\":" + st +
                ", \"didName\":\"" + didName + '\"' +
                '}';
    }
}
