package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.serialport.SerialPortUtils;
import com.zy.SmartCampus.serialport.SwitchMsgUtil;
import com.zy.SmartCampus.service.*;
import com.zy.SmartCampus.util.CRC16Util;
import com.zy.SmartCampus.util.MyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
public class DevCtrl {

    private final String pathHead = "devManager/";

    @Autowired
    private DevService devService;
    @Autowired
    private SwitchDevService switchDevservice;
    @Autowired
    private LoraDevService loraDevService;
    @Autowired
    private OrganizeService organizeService;
    @Autowired
    private AirDevService airDevService;
    public static String devSN;
    //=================================== dao line ======================================




    @RequestMapping("devAir")
    public String devAir(Model model){
//        updateDevOnLineStatus("2");
        List<EasyTree> list = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        model.addAttribute("schoolList",list);
        return pathHead+"devAirManager";
    }




    @RequestMapping("airView")
    public String airView(Model model,String devId){
        JSONObject jsonDevId = new JSONObject();
        jsonDevId.put("devId",devId);
        List<AirInfo> airInfoList = airDevService.queryAirDevInfo(jsonDevId);
//        String devSN = airInfoList.get(0).getDevSN();
//        System.out.println("devSN:"+devSN);
//
//        JSONObject jsonDevSN = new JSONObject();
//        jsonDevSN.put("devSN",devSN);
//        List<AirInfo> airViewList = devService.queryAir(jsonDevSN);

        model.addAttribute("airInfo",JSONObject.toJSONString(airInfoList));
        return pathHead+"airView";
    }


    @RequestMapping("addDevView")
    public String addDevView(Model model){
        List<EasyTree> list = organizeService.queryChildenOrganize(
                                        organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        model.addAttribute("schoolList",list);
        return "devManager/addDevView";
    }
    @RequestMapping("editAirDev")
    public String editAirDev(Model model){
//        List<EasyTree> list = organizeService.queryChildenOrganize(
//                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
//        model.addAttribute("schoolList",list);
        return "devManager/editAirDev";
    }
    //======================================   view data line  ======================================



    @RequestMapping("getRealStatus")
    @ResponseBody
    public int getRealStatus(String devType){
        updateDevOnLineStatus(devType);
        return 1;
    }



    @RequestMapping("getSwitch")
    @ResponseBody
    public List<SwitchInfo> getSwitch(String devSN){
        JSONObject json = new JSONObject();
        json.put("devSN",devSN);
        List<SwitchInfo> switchInfo = devService.querySwitch(json);
        return switchInfo;
    }

    private void updateDevOnLineStatus(String devType){
//        boolean bOpen = SerialPortUtils.getInstance().isbOpen();
//        if(!bOpen){
//            return;
//        }
        for(DevInfo temp :SwitchMsgUtil.getAllDevInfoList()){
            if(temp.getDevType().equals(devType)){
                if(devType.equals("1")){
                    //发送查询开关闸指令 判断设备是否在线
                    String msg = MyUtil.getSlaveId(temp.getDevId())+"01 00 00 00 01";
                    msg = msg + CRC16Util.getCRC(msg);
                    SerialPortUtils.getInstance().sendComm(msg);
                }else if (devType.equals("2")){
                    //发送读取温度指令  判断设备是否在线
                    String msg = MyUtil.getSlaveId(temp.getDevId())+"03 00 01 00 01";
                    msg = msg + CRC16Util.getCRC(msg);
                    SerialPortUtils.getInstance().sendComm(msg);
                }
                try {
                    Thread.sleep(200);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }

        try {
            Thread.sleep(500);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        long currTime  = System.currentTimeMillis();
        int interval = SwitchMsgUtil.getSendInterval() * SwitchMsgUtil.getAllDevInfoList().size() + 1000;
        for(DevInfo temp : SwitchMsgUtil.getAllDevInfoList()){
            if(temp.getDevType().equals(devType)){
                DevInfo tt = new DevInfo();
                tt.setDevSN(temp.getDevSN());
                if(currTime - temp.getRecordTime() < interval){
                    tt.setDevStatus("在线");
                }else {
                    tt.setDevStatus("离线");
                }
                devService.updateDev(tt);
            }
        }
    }

    @RequestMapping("modifyDev")
    @ResponseBody
    public JSONObject modifyDev(AirInfo airInfo){
        JSONObject json = new JSONObject();
        System.out.println(airInfo);
        String uuid = airInfo.getUuid();
        String zero = "";
        int devId = Integer.parseInt(uuid);//根据UUID设置设备ID
        for(int i = 0;i < 6 -String.valueOf(devId).length();i++){
            zero = zero+"0";
        }
        uuid = zero + uuid;
        airInfo.setUuid(uuid);
        int iRet = airDevService.updateAirDev(airInfo);
        json.put("code",iRet);
        json.put("msg",(iRet > 0?"修改成功":"修改失败"));
        return json;
    }

    @RequestMapping("delAirDev")
    @ResponseBody
    public JSONObject delAirDev(AirInfo airInfo,HttpServletRequest request){
//        String devSN = request.getParameter("devSN");
//        if(devSN != null){
//            //System.out.println("devSN:"+devSN);
//            devService.delSwitch(devSN);
//            DevInfo devInfo = new DevInfo();
//            devInfo.setDevSN(devSN);
//            SwitchMsgUtil.delDevInfoFromList(devInfo);
//        }
        System.out.println("delAirDev:"+airInfo);
        JSONObject json = new JSONObject();
        int code = airDevService.delAirDev(airInfo);
        //System.out.println("delDev code:"+code);
        json.put("code",code);
        json.put("msg",(code > 0)?"删除成功":"删除失败");
        return json;
    }

    @RequestMapping("getDev")
    @ResponseBody
    public Layui getDev(int page, int limit, HttpServletRequest request){
        int offset = (page-1)*limit;
        JSONObject json = new JSONObject();
        json.put("offset",offset);
        json.put("limit",limit);
        List<AirInfo> list = airDevService.queryAllAirDev(json);
        for(int i=0;i<list.size();i++){
            list.get(i).setUuid(Integer.valueOf(list.get(i).getUuid()).toString());
        }
        list = setAreaText(list);
        int count = airDevService.queryAirDevCount(json);
        return Layui.data(count,list);
    }

    //根据区域地点的ID设置地点文字
    public List<AirInfo> setAreaText(List<AirInfo> list){
        for(int i = 0;i<list.size();i++){
            if(!list.get(i).getSchool().equals("")){
                list.get(i).setSchool(organizeService.queryCurrId(list.get(i).getSchool()).getText());
            }
            if(!list.get(i).getHouse().equals("")) {
                list.get(i).setHouse(organizeService.queryCurrId(list.get(i).getHouse()).getText());
            }
            if(!list.get(i).getFloor().equals("")) {
                list.get(i).setFloor(organizeService.queryCurrId(list.get(i).getFloor()).getText());
            }
            if(!list.get(i).getRoom().equals("")) {
                list.get(i).setRoom(organizeService.queryCurrId(list.get(i).getRoom()).getText());
            }
        }
        return list;
    }

    @RequestMapping("addDev")
    @ResponseBody
    public JSONObject addDev(DevInfo devInfo){
        //System.out.println(devInfo.toString());
        String devSN = MyUtil.getUUID();
        devInfo.setDevSN(devSN);

        int devType  = Integer.parseInt(devInfo.getDevType());
        System.out.println("devType:"+devType);

        if(devType == 1){
            //空开设备
            int devId = Integer.parseInt(devInfo.getDevId());
            int lineCount = Integer.parseInt(devInfo.getLineCount());
            for(int i=0;i<lineCount;i++){
                SwitchInfo switchInfo = new SwitchInfo();
                switchInfo.setLoraSN(devSN);
                switchInfo.setDevId(devInfo.getDevId());
                switchInfo.setSwitchName("分路"+(i+1));
                switchInfo.setSwitchAddress(String.valueOf(i+1));
                devService.insertSwitch(switchInfo);
            }
        }

        JSONObject json = new JSONObject();
        int code = devService.insertDev(devInfo);
        if(code > 0){
            SwitchMsgUtil.addDevInfoToList(devInfo);
        }
        json.put("code",code);
        json.put("msg",(code>0)?"添加成功":"添加失败");
        return json;
    }
    @RequestMapping("addAirDev")
    @ResponseBody
    public JSONObject addAirDev(AirInfo airInfo){
        System.out.println("++++++++++++++"+airInfo.toString());
//        String devSN = MyUtil.getUUID();
//        airInfo.setDevSN(devSN);

        Map<String,Object> map = new HashMap<>();

        String uuid = airInfo.getUuid();
        String zero = "";
        int devId = Integer.parseInt(uuid);//根据UUID设置设备ID
        for(int i = 0;i < 6 -String.valueOf(devId).length();i++){
            zero = zero+"0";
        }
        uuid = zero + uuid;
//        String interval=airInfo.getIntervaltime();//获取上传时间间隔
//        int chncnt = airInfo.getChncnt();//获取通道数量
        String school = "";
        String house = "";
        String floor = "";
        String room = "";
        if(!airInfo.getSchool().equals("")){
            if(airInfo.getSchool().equals("0")){
                school = "无";
            }else{
                school = organizeService.queryCurrId(airInfo.getSchool()).getText();//获取校区
            }
        }
        if(!airInfo.getHouse().equals("")){
            if(airInfo.getHouse().equals("0")){
                house = "无";
            }else{
                house = organizeService.queryCurrId(airInfo.getHouse()).getText();
            }
        }
        if(!airInfo.getFloor().equals("")){
            if(airInfo.getFloor().equals("0")){
                floor = "无";
            }else{
                floor = organizeService.queryCurrId(airInfo.getFloor()).getText();
            }
        }
        if(!airInfo.getRoom().equals("")){
            if(airInfo.getRoom().equals("0")){
                room = "无";
            }else{
                room = organizeService.queryCurrId(airInfo.getRoom()).getText();
            }
        }

        airInfo.setDevStatus("离线");
        airInfo.setUuid(uuid);
        airInfo.setDevId(String.valueOf(devId));
        airInfo.setSchool(school);
        airInfo.setHouse(house);
        airInfo.setFloor(floor);
        airInfo.setRoom(room);
        System.out.println("2airInfo--------:"+airInfo);

        JSONObject json = new JSONObject();
        int code = airDevService.addAirDev(airInfo);

        json.put("code",code);
        json.put("msg",(code>0)?"添加成功":"添加失败");
        return json;
    }
    //新增时空开组通讯地址验证
    @RequestMapping("selectAirDevUUID")
    @ResponseBody
    public JSONObject selectAirDevUUID(String uuid){
        System.out.println("空调通讯地址校验"+uuid);

        String zero = "";
        int devId = Integer.parseInt(uuid);//根据UUID设置设备ID
        for(int i = 0;i < 6 -String.valueOf(devId).length();i++){
            zero = zero+"0";
        }
        uuid = zero + uuid;
        AirInfo airInfo = airDevService.queryAirDevInfoByUuid(uuid);
        System.out.println("AirInfo"+airInfo);
        int code=0;
        if(airInfo!=null){
            code=1;
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("code",code);
        MyUtil.printfInfo(jsonObject.toString());
        return jsonObject;
    }
    @RequestMapping("getOneDev")
    @ResponseBody
    public DevInfo getOneDev(String id){
        return devService.queryOneDev(id);
    }

    private static int count = 0;
    @RequestMapping("ctrlDev")
    @ResponseBody
    public JSONObject ctrlDev(SwitchCtrlInfo switchCtrl,int dd){
        //System.out.println("dddddd :"+dd);
        System.out.println("switchdata="+switchCtrl.toString());
        String[] strings = switchCtrl.getAddress().split(",");
       /* String[] strings1 = {""};
        for(int i=strings.length-1;i>=0;i--){
            Object o = i;
            strings1 = strings[i].split(",");
        }*/
        //System.out.println("和哈哈哈哈哈哈哈哈哈哈或或或或 ：" + strings);
        String type = switchCtrl.getType();
        int devId = switchCtrl.getDevId();
        //添加计数器，保证每次能够读取实时数据
        if(type.equals("close")){
            count++;
        }else if(type.equals("open")){
            count=0;
        }
        if(type.equals("close") ){
            System.out.println("合闸");
            for(String temp : strings){
                String msg = SwitchMsgUtil.singleSwitchOpenClose(devId,Integer.parseInt(temp)-1,false,count);
                SwitchInfo switchInfo = new SwitchInfo();
                switchInfo.setDevId(Integer.toString(switchCtrl.getDevId()));
                switchInfo.setSwitchAddress(temp);
                switchInfo.setSwitchStatus("在线");
                devService.updateRecordTime(switchInfo);
                try {
                    Thread.sleep(dd);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }

            if (count == 1) {
                try {
                    Thread.sleep(200);
                    System.out.println("Thread");
                    count++;
                    for(String temp : strings) {
                        SwitchMsgUtil.singleSwitchOpenClose(devId, Integer.parseInt(temp) - 1, false, count);
                    }
                } catch (InterruptedException e) {
                    System.out.println("111111111");
                }
            }

        }else if(type.equals("open")){
            System.out.println("开闸");
            String s;
            for(int i = 0;i<strings.length/2;i++){
                s = strings[i];
                strings[i] = strings[strings.length-1-i];
                strings[strings.length-1-i] = s;
            }
            for(String temp : strings){
                String msg = SwitchMsgUtil.singleSwitchOpenClose(devId,Integer.parseInt(temp)-1,true,count);
                SwitchInfo switchInfo = new SwitchInfo();
                switchInfo.setDevId(Integer.toString(switchCtrl.getDevId()));
                switchInfo.setSwitchAddress(temp);
                switchInfo.setSwitchStatus("离线");
                devService.updateRecordTime(switchInfo);
                try {
                    Thread.sleep(dd);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }

        JSONObject json = new JSONObject();
        json.put("msg","succ");
        return  json;
    }

    @RequestMapping("ctrlAir")
    @ResponseBody
    public JSONObject ctrlAir(AirInfo airInfo,int dd){

        System.out.println("airdata="+airInfo.toString());
//        String[] strings = airInfo.getAddress().split(",");
        String type = airInfo.getType();
        String devId = airInfo.getDevId();
        //添加计数器，保证每次能够读取实时数据
        if(type.equals("open")){
            count++;
        }else if(type.equals("close")){
            count=0;
        }
        if(type.equals("close") ) {
            System.out.println("关闭继电器");
            String msg = SwitchMsgUtil.singleAirOpenClose(devId,false,count);
            AirInfo airStatus = new AirInfo();
            airStatus.setDevId(airInfo.getDevId());
            airStatus.setRelayStatus("离线");
            devService.updateAirStatus(airStatus);
            try {
                Thread.sleep(dd);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }else if(type.equals("open")){
            System.out.println("打开继电器");
            String msg = SwitchMsgUtil.singleAirOpenClose(devId,true,count);
            AirInfo airStatus = new AirInfo();
            airStatus.setDevId(airInfo.getDevId());
            airStatus.setRelayStatus("在线");
            devService.updateAirStatus(airStatus);
            try {
                Thread.sleep(dd);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            if (count == 1) {
                try {
                    Thread.sleep(200);
                    System.out.println("Thread");
                    count++;
                    SwitchMsgUtil.singleAirOpenClose(devId,true, count);
                } catch (InterruptedException e) {
                    System.out.println("线程延迟异常");
                }
            }
        }

        JSONObject json = new JSONObject();
        json.put("msg","succ");
        return json;
    }

    //================================== function line ==================================

    private String getAllParentOrganize(String id){
        EasyTree easyTree = organizeService.queryParent(id);
        EasyTree thisEasyTree  = organizeService.queryCurrId(id);
        String str = thisEasyTree.getText()+","+easyTree.getText()+",";
        while (!easyTree.getPId().equals("0")){
            easyTree = organizeService.queryParent(easyTree.getId());
            str += easyTree.getText()+",";
        }
        //System.out.println(str);
        return str.substring(0,str.length()-1);
    }

    //空调状态
    @RequestMapping("airConditionStatus")
    private String airConditionStatus(){return "devStatusManager/airConditionStatus";}

    //空调状态-查看按钮
    @RequestMapping("airConditionLineStatus")
    public String airConditionLineStatus(){
        return "devStatusManager/airConditionLineStatus";
    }


    //空开状态
    @RequestMapping("airSwitchStatus")
    private String airSwitchStatus(){return "devStatusManager/airSwitchStatus";}

    //使用时长
    @RequestMapping("durationUse")
    private String durationUse(){return "durationUse/durationUse";}

    //空开状态-查看按钮-线路状态
    @RequestMapping("airSwitchLineStatus")
    public String airSwitchLineStatus(Model model,String devSN){
        System.out.println("devSN:"+devSN);
        JSONObject json = new JSONObject();
        json.put("devSN",devSN);
        List<SwitchInfo> switchInfo = devService.querySwitch(json);
        model.addAttribute("switchInfo",JSONObject.toJSONString(switchInfo));
        return "devStatusManager/airSwitchLineStatus";
    }

    //批量设置
    @RequestMapping("batchSetting")
    public String batchSetting(){return "batchSetting/airSwitchBatchSetting";}

    //wpp 2020-3-5根据设备id,设备名称搜索设备
    @RequestMapping("searchDev")
    @ResponseBody
    public Layui searchDev(int page, int limit, HttpServletRequest request){
        int offset = (page-1)*limit;
        String onLine = request.getParameter("onLine");
        String school = request.getParameter("school");
        String house = request.getParameter("house");
        String floor = request.getParameter("floor");
        String room = request.getParameter("room");
        if(school.equals("全部")){
            school="";
        }
        if(house.equals("全部")){
            house="";
        }
        if(floor.equals("全部")){
            floor="";
        }
        if(room.equals("全部")){
            room="";
        }
        if(onLine.equals("全部")){
            onLine="";
        }
        JSONObject json = new JSONObject();
        json.put("offset",offset);
        json.put("limit",limit);
        json.put("devStatus",onLine);
        json.put("school",school);
        json.put("house",house);
        json.put("floor",floor);
        json.put("room",room);
        System.out.println("查询json"+json);
        List<AirInfo> list = airDevService.queryAirDevInfo(json);
        list = setAreaText(list);
        int count = list.size();
        return Layui.data(count,list);
    }
}

