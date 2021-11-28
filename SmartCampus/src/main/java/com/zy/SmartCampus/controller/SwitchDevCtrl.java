package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.lorasearch.BeanContext;
import com.zy.SmartCampus.lorasearch.LoraMsgUtil;
import com.zy.SmartCampus.lorasearch.LoraPortUtil;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.service.LoraDevService;
import com.zy.SmartCampus.service.OrganizeService;
import com.zy.SmartCampus.service.SwitchDevService;
import com.zy.SmartCampus.util.MyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class SwitchDevCtrl {

    private final String pathHead = "devManager/";

    @Autowired
    private SwitchDevService switchDevservice;
    /*@Autowired
    private switchDevMapper;*/
    @Autowired
    private LoraDevService loraDevService;
    @Autowired
    private OrganizeService organizeService;
    public static String selectedUuid;
    public static int devID;
    public static String uuid;
    public static int chncnt;
    public static String loraSN;
    public static String msg;
    public static String addSchool;
    public static String addHouse;
    public static String addFloor;
    public static String addRoom;

    public static List<SwitchDevInfo> list;

    //添加空开设备
    @RequestMapping("addSwitchDev")
    @ResponseBody
    public Map<String,Object> addSwitchDev(SwitchDevInfo switchDevInfo)throws InterruptedException {

        System.out.println("switchDevinfo:"+switchDevInfo.toString());

        Map<String,Object> map = new HashMap<>();

        String uuid = switchDevInfo.getUuid();
        String zero = "";
        int devId = Integer.parseInt(uuid);//根据UUID设置设备ID
        for(int i = 0;i < 6 -String.valueOf(devId).length();i++){
            zero = zero+"0";
        }
        uuid = zero + uuid;
        String interval=switchDevInfo.getIntervaltime();//获取上传时间间隔
        int chncnt = switchDevInfo.getChncnt();//获取通道数量
        String school = switchDevInfo.getSchool();
        String house = switchDevInfo.getHouse();
        String floor = switchDevInfo.getFloor();
        String room = switchDevInfo.getRoom();
        /*if(!switchDevInfo.getSchool().equals("")){
            if(switchDevInfo.getSchool().equals("0")){
                school = "无";
            }else{
                school = organizeService.queryCurrId(switchDevInfo.getSchool()).getText();//获取校区
            }
        }
        if(!switchDevInfo.getHouse().equals("")){
            if(switchDevInfo.getHouse().equals("0")){
                house = "无";
            }else{
                house = organizeService.queryCurrId(switchDevInfo.getHouse()).getText();
            }
        }
        if(!switchDevInfo.getFloor().equals("")){
            if(switchDevInfo.getFloor().equals("0")){
                floor = "无";
            }else{
                floor = organizeService.queryCurrId(switchDevInfo.getFloor()).getText();
            }
        }
        if(!switchDevInfo.getRoom().equals("")){
            if(switchDevInfo.getRoom().equals("0")){
                room = "无";
            }else{
                room = organizeService.queryCurrId(switchDevInfo.getRoom()).getText();
            }
        }*/

        addSchool = school;
        addHouse = house;
        addFloor = floor;
        addRoom = room;
        //根据位置信息获取当前网关的网关序列号LoraSN
        JSONObject json = new JSONObject();
        json.put("school",school);
        json.put("house",house);
        json.put("floor",floor);
        //json.put("room",room);
        //System.out.println("weizhiiiiiiiii:"+school+house+floor);
        List<LoraDevInfo> list = loraDevService.queryLoraDevByFloor(json);
        //System.out.println("listttttttttttttt:"+list);
        if(list.size()==0){
            map.put("code",-1);
            map.put("msg","该楼层未找到Lora网关设备！");
        }else {
            List<SwitchDevInfo> queryDevList = switchDevservice.queryDevByUuid(uuid);
            if(queryDevList.size() >0){
                map.put("code",-1);
                map.put("msg","已有该设备！");
            }else {
                //String thisloraSN=list.get(0).getLoraSN();
                String thisloraSN=switchDevInfo.getLoraSN();
                //Boolean orNo=LoraMsgUtil.SendLoraData(thisloraSN,"40","");
                if(LoraPortUtil.HBStatus==true) {//通过发送查询设备命令来辨别网关设备是否正常连接（心跳间隔为一分钟，间隔时间较长）
                    //将新增设备添加进数据库，并更新lora网关下的设备数量
                    SwitchDevInfo newSwitchDev=new SwitchDevInfo();
                    newSwitchDev.setSchool(school);
                    newSwitchDev.setHouse(house);
                    newSwitchDev.setFloor(floor);
                    newSwitchDev.setRoom(room);
                    newSwitchDev.setLoraSN(thisloraSN);
                    newSwitchDev.setUuid(uuid);
                    newSwitchDev.setDevId(devId);
                    newSwitchDev.setDevStatus("在线");//设置新添加设备在线状态为离线
                    newSwitchDev.setIntervaltime(interval);
                    newSwitchDev.setPort("0");
                    newSwitchDev.setChncnt(chncnt);
                    newSwitchDev.setSensortype("12");
                    newSwitchDev.setChntype("19");
                    switchDevservice.addSwitchDev(newSwitchDev);
                    //更新lora网关下的设备数量
                    List<LoraDevInfo> loraList=loraDevService.queryLoraByDevSN(thisloraSN);
                    //LoraDevInfo loraDevInfo=new LoraDevInfo();
                    int  switchGroupNum=Integer.valueOf(loraList.get(0).getSwitchGroupNum())+1;
                    loraList.get(0).setSwitchGroupNum(String.valueOf(switchGroupNum));
                    loraDevService.updateLora(loraList.get(0));
                    //添加开关信息
                    for(int i=0;i<chncnt;i++){
                        SwitchInfo switchInfo=new SwitchInfo();
                        switchInfo.setSwitchStatus("断电");
                        switchInfo.setDevId(String.valueOf(devId));
                        switchInfo.setSwitchAddress(String.valueOf(chncnt-(chncnt-i-1)));
                        switchInfo.setSwitchName("分路"+(chncnt-(chncnt-i)));
                        switchInfo.setLineCurrent(String.valueOf(0.0));
                        switchInfo.setLeakageCurrent(String.valueOf(0.0));
                        switchInfo.setLinePower(String.valueOf(0));
                        switchInfo.setLineVoltage(String.valueOf(0));
                        switchInfo.setModuleTemperature(String.valueOf(0));
                        //System.out.println("2:"+thisloraSN);
                        switchInfo.setLoraSN(thisloraSN);
                        //System.out.println(switchInfo);
                        switchDevservice.addSwitch(switchInfo);
                        System.out.println("添加数据到数据库");
                    }
                    //向网关发送设备设置命令
                    int code;
                    System.out.println("网关发送设备设置命令");
                    if(setSwitchDev(thisloraSN)==true){
                        System.out.println("设置命令成功");
                        code = 1;
                    }else {
                        System.out.println("设置命令成功");
                        code = 0;
                    }

                    map.put("code", code);
                    map.put("msg", (code > 0 ? "添加成功" : "添加失败"));
                }else {
                    map.put("msg", "当前网关设备已与服务器断开连接!");
                }
            }
        }
        return map;
    }

    //新增时空开组通讯地址验证
    @RequestMapping("selectUUID")
    @ResponseBody
    public JSONObject selectUUID(String uuid){
        System.out.println("空开组通讯地址校验"+uuid);

        String zero = "";
        int devId = Integer.parseInt(uuid);//根据UUID设置设备ID
        for(int i = 0;i < 6 -String.valueOf(devId).length();i++){
            zero = zero+"0";
        }
        uuid = zero + uuid;
        SwitchDevInfo switchDevInfo = switchDevservice.queryDevInfoByUuid(uuid);
        System.out.println("switchDevInfo"+switchDevInfo);
        int code=0;
        if(switchDevInfo!=null){
            code=1;
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("code",code);
        MyUtil.printfInfo(jsonObject.toString());
        return jsonObject;
    }
    //刷新页面信息
    @RequestMapping("updateDev")
    @ResponseBody
    public void updateDev(SwitchDevInfo switchDevInfo)throws InterruptedException{
        List<LoraDevInfo> list=getswitchDevLoraSN();
        int len=list.size();
        for(int i=0;i<len;i++){
            System.out.println("list.get(i).getDevSN()"+list.get(i).getLoraSN());
            LoraMsgUtil.SendLoraData(list.get(i).getLoraSN(),"40","");
            int code = 0;
            Boolean sendStatus = false;
            while(code==0||code==2) {
                sendStatus =LoraMsgUtil.SendLoraData(list.get(i).getLoraSN(),"40","");
                code = LoraDevCtrl.receiveStatus(sendStatus);
            }
            if(LoraPortUtil.receiveStatus=true){
                switchDevInfo.setDevStatus("在线");
                switchDevservice.updateSwitchDev(switchDevInfo);
            }
        }
    }
    /*//搜索空开设备信息
    @RequestMapping("switchDevSearch")
    @ResponseBody
    public String switchDevSearchView(Model model)  throws Exception {
        List<SwitchDevInfo> switchDevSearchList= LoraPortUtil.getSwitchDevInfo();
        int i = 0 ;
        while(switchDevSearchList.size()==0){
            //搜索时长超过两分钟, 提示搜索不到设备
            if(i<120){
                Thread.sleep(1000);
                i++;
                System.out.println(i);
            }else {
                System.out.println("搜索时长超过两分钟, 提示搜索不到设备");//后期在页面上提示-----搜索时长超过两分钟
                break;
            }

        }
        System.out.println("搜索lora设备结束");
        Thread.sleep(5000);
        List<SwitchDevInfo> newLoraDev = new ArrayList<>();
        List<SwitchDevInfo> list =  new LinkedList<>();
        list.addAll(switchDevSearchList);
        for (int j=0 ; j<switchDevSearchList.size() ;j++){
            LoraDevInfo loraDevInfo = new LoraDevInfo();
            loraDevInfo.setDevSN(switchDevSearchList.get(j).getDevSN());
            String uuid = switchDevSearchList.get(j).getUuid();
            //判断当前设备在数据库中是否已经存在
            List<SwitchDevInfo> loraList = switchDevservice.queryDevByUuid(uuid);
            if(loraList.size()==0){
                newLoraDev.add(list.get(j));
            }else{
                SwitchDevInfo updateDevStatus = new SwitchDevInfo();
                updateDevStatus.setDevSN(switchDevSearchList.get(j).getDevSN());
                updateDevStatus.setDevStatus("在线");
                switchDevservice.updateSwitchDev(updateDevStatus);
            }
        }

        System.out.println("newDevList：" + newLoraDev);
        model.addAttribute("list",JSONObject.toJSONString(newLoraDev));
        return "switchDevSearchView";
    }*/
    //修改空开设备信息
    @RequestMapping("updateswitchDev")
    @ResponseBody
    public Map<String,Object>  updateswitchDev(String newUuid,String oldUuid,String intervaltime,int chncnt)throws InterruptedException {
        Map<String,Object> map = new HashMap<>();
        int iRet;
        System.out.println("chncnt:"+chncnt);
        System.out.println("intervaltime:"+intervaltime);
        String zero1="";
        String zero2="";
       /* for(int i=0;i<6-String.valueOf(newUuid).length();i++){
            zero1=zero1+"0"; }
        newUuid=zero1+newUuid;*/
        for(int i=0;i<6-String.valueOf(oldUuid).length();i++){
            zero2=zero2+"0"; }
        oldUuid=zero2+oldUuid;
        List<SwitchDevInfo> listGetSwitch=switchDevservice.queryDevByUuid(oldUuid);
        //System.out.println(".......................:"+getLora.get(0).getLoraSN());
        SwitchDevInfo switchDevInfo=listGetSwitch.get(0);
        System.out.println("chncnt:"+switchDevInfo.getChncnt());
        System.out.println("intervaltime:"+switchDevInfo.getIntervaltime());
        //判断修改的设备线路数量是否更改
        //如果线路数量已经修改
        if(chncnt!=switchDevInfo.getChncnt()){
            /*if (newUuid.equals(oldUuid)==false) {//如果uuid已经修改
                List<SwitchDevInfo> orExist = switchDevservice.queryDevByUuid(newUuid);
                //判断修改的uuid是否已存在
                if (orExist.size() > 0) {//如果uuid存在
                    map.put("code", -1);
                    map.put("msg", "已有该设备！");
                }
                else {//如果uuid不存在
                    switchDevInfo.setUuid(newUuid);
                    switchDevInfo.setDevId(Integer.valueOf(newUuid));
                    //新建新的uuid下的开关
                    System.out.println("chncntttttttttttttttt:"+chncnt);
                    Boolean orNo=LoraMsgUtil.SendLoraData(switchDevservice.queryDevByDevId(Integer.valueOf(oldUuid)).getLoraSN(),"40","");
                    if(orNo==true) {//通过发送查询设备命令来辨别网关设备是否正常连接（心跳间隔为一分钟，间隔时间较长）
                        for(int i=0;i<chncnt;i++){
                            SwitchInfo switchInfo=new SwitchInfo();
                            switchInfo.setSwitchStatus("离线");
                            switchInfo.setDevId(Integer.valueOf(newUuid).toString());
                            switchInfo.setSwitchAddress(String.valueOf(chncnt-i));
                            switchInfo.setSwitchName("分路"+(chncnt-i-1));
                            switchInfo.setLineCurrent(String.valueOf(0.0));
                            switchInfo.setLeakageCurrent(String.valueOf(0.0));
                            switchInfo.setLinePower(String.valueOf(0));
                            switchInfo.setLineVoltage(String.valueOf(0));
                            switchInfo.setModuleTemperature(String.valueOf(0));
                            switchInfo.setLoraSN(switchDevInfo.getLoraSN());

                            switchDevservice.addSwitch(switchInfo);
                        }
                        //删除原本uuid下的开关数据
                        JSONObject jsonObject=new JSONObject();
                        jsonObject.put("devId",oldUuid);
                        switchDevservice.deleteSwitch(jsonObject);
                        switchDevInfo.setChncnt(chncnt);
                        switchDevservice.updateSwitchDev(switchDevInfo);

                        //向网关发送设备设置命令
                        iRet = setSwitchDev(switchDevInfo.getLoraSN());
                        map.put("code", iRet);
                        map.put("msg", (iRet > 0 ? "修改成功" : "修改失败"));
                    }else {
                        map.put("msg", "当前网关设备已与服务器断开连接！");
                    }

                }
            }*/
            //else {//如果uuid没有修改
            //Boolean orNo=LoraMsgUtil.SendLoraData(switchDevservice.queryDevByDevId(Integer.valueOf(oldUuid)).getLoraSN(),"40","");
            if(LoraPortUtil.HBStatus==true) {//通过发送查询设备命令来辨别网关设备是否正常连接（心跳间隔为一分钟，间隔时间较长）
                //删除uuid下的开关数据
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("devId", oldUuid);
                switchDevservice.deleteSwitch(jsonObject);
                switchDevInfo.setChncnt(chncnt);
                switchDevInfo.setIntervaltime(intervaltime);
                //新建uuid下的开关
                for (int i = 0; i < chncnt; i++) {
                    SwitchInfo switchInfo = new SwitchInfo();
                    switchInfo.setSwitchStatus("离线");
                    switchInfo.setDevId(Integer.valueOf(oldUuid).toString());
                    switchInfo.setSwitchAddress(String.valueOf(chncnt - i));
                    switchInfo.setSwitchName("分路" + (chncnt - i - 1));
                    switchInfo.setLineCurrent(String.valueOf(0.0));
                    switchInfo.setLeakageCurrent(String.valueOf(0.0));
                    switchInfo.setLinePower(String.valueOf(0));
                    switchInfo.setLineVoltage(String.valueOf(0));
                    switchInfo.setModuleTemperature(String.valueOf(0));
                    switchInfo.setLoraSN(switchDevInfo.getLoraSN());
                    switchDevservice.addSwitch(switchInfo);

                    //插入历史表



                }
                switchDevservice.updateSwitchDev(switchDevInfo);
                //向网关发送设备设置命令
                int code;
                if(setSwitchDev(switchDevInfo.getLoraSN())==true){
                    code = 1;
                }else {
                    code = 0;
                }
                map.put("code", code);
                map.put("msg", (code > 0 ? "修改成功" : "修改失败"));
            }else {
                map.put("msg", "当前网关设备已与服务器断开连接!");
            }
            //}
        }
        //如果线路数量没有修改
        else {
            /*if (newUuid.equals(oldUuid)==false) {//如果uuid已经修改
                List<SwitchDevInfo> orExist = switchDevservice.queryDevByUuid(newUuid);
                //判断修改的uuid是否已存在
                if (orExist.size() > 0) {//如果uuid存在
                    map.put("code", -1);
                    map.put("msg", "已有该设备！");
                } else {//如果uuid不存在
                    switchDevInfo.setUuid(newUuid);
                    switchDevInfo.setDevId(Integer.valueOf(newUuid));
                    Boolean orNo=LoraMsgUtil.SendLoraData(switchDevservice.queryDevByDevId(Integer.valueOf(oldUuid)).getLoraSN(),"40","");
                    if(orNo==true) {//通过发送查询设备命令来辨别网关设备是否正常连接（心跳间隔为一分钟，间隔时间较长）
                        //更新空开设备信息
                        switchDevservice.updateSwitchDev(switchDevInfo);
                        //更新设备下的开关信息
                        JSONObject jsonObject=new JSONObject();
                        jsonObject.put("devId",Integer.valueOf(oldUuid));
                        List<SwitchInfo> switchInfoList= switchDevservice.querySwitch(jsonObject);
                        for(int i=0;i<switchInfoList.size();i++){
                            switchInfoList.get(i).setDevId(Integer.valueOf(newUuid).toString());
                            System.out.println(switchInfoList.get(i));
                            switchDevservice.updateSwitchInfo(switchInfoList.get(i));
                        }

                        //向网关发送设备设置命令
                        iRet = setSwitchDev(switchDevInfo.getLoraSN());
                        map.put("code", iRet);
                        map.put("msg", (iRet > 0 ? "修改成功" : "修改失败"));
                    }else {
                        map.put("msg", "当前网关设备已与服务器断开连接!");
                    }
                }
            }*/
            //else {//如果uuid没有修改
            if(intervaltime.equals(switchDevInfo.getIntervaltime())==false){//如果时间间隔已经修改
                Boolean orNo=LoraMsgUtil.SendLoraData(switchDevservice.queryDevByDevId(Integer.valueOf(oldUuid)).getLoraSN(),"40","");
                if(orNo==true) {//通过发送查询设备命令来辨别网关设备是否正常连接（心跳间隔为一分钟，间隔时间较长）
                    switchDevInfo.setIntervaltime(intervaltime);
                    switchDevservice.updateSwitchDev(switchDevInfo);
                    //向网关发送设备设置命令
                    int code;
                    if(setSwitchDev(switchDevInfo.getLoraSN())==true){
                        code = 1;
                    }else {
                        code = 0;
                    }

                    map.put("code", code);
                    map.put("msg", (code > 0 ? "修改成功" : "修改失败"));
                }else {
                    map.put("msg", "当前网关设备已与服务器断开连接!");
                }
            }else {
                map.put("msg","没有数据更改！");
            }
            //}
        }
        return map;
    }

    //搜索空开设备全部信息
    @RequestMapping("getswitchDev")
    @ResponseBody
    public Layui getswitchDev(int page, int limit, HttpServletRequest request){
        int offset = (page-1)*limit;
        JSONObject json = new JSONObject();
        json.put("offset",offset);
        json.put("limit",limit);
        List<SwitchDevInfo> list = switchDevservice.queryswitchDevInfo(json);
        for(int i=0;i<list.size();i++){
            list.get(i).setUuid(Integer.valueOf(list.get(i).getUuid()).toString());
        }
        list = setAreaText(list);
        int count = switchDevservice.queryswitchDevCount(json);
        return Layui.data(count,list);
    }

    //根据区域地点的ID设置地点文字
    public List<SwitchDevInfo> setAreaText(List<SwitchDevInfo> list){
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

    //搜索空开设备Lora序列号
    @RequestMapping("getswitchDevLoraSN")
    @ResponseBody
    public List<LoraDevInfo> getswitchDevLoraSN(){
        JSONObject json = new JSONObject();
        List<LoraDevInfo> list = switchDevservice.queryswitchLoraSN(json);
        //System.out.println("空开设备Lora:"+list);
        for (int i= 0 ;i<list.size() ; i++){
            json.put(String.valueOf(i),list.get(i).getLoraSN());
        }
        //json.put("0",list);
        System.out.println("Json : " + json);
        System.out.println(list);
        return list;
    }
    //搜索空开设备Lora序列号
    @RequestMapping("getArea")
    @ResponseBody
    public JSONObject getarea() {
        JSONObject jsonPost = new JSONObject();

        jsonPost.put("school",addSchool);
        jsonPost.put("house",addHouse);
        jsonPost.put("floor",addFloor);
        jsonPost.put("room",addRoom);

        return jsonPost;
    }
    //根据Lora序列号查询空开组数量
    @RequestMapping("getSwitchGroupNum")
    @ResponseBody
    public List<LoraDevInfo> getSwitchGroupNum(String loraSN){
        List<LoraDevInfo> list=loraDevService.querySwitchGroupNum(loraSN);
        return list;
    }

    //跳转至Lora网关管理测试页面
    @RequestMapping("LoraDevManager")
    public String LoraDevManager() {
        return "loratest";
    }

    //跳转至添加空开设备页面
    @RequestMapping("toAddSwitchDevView")
    public String toAddSwitchDevView(Model model)   {
        List<EasyTree> list = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        model.addAttribute("schoolList",list);
        return pathHead+"addSwitchDev";
    }
    @RequestMapping("toSwitchDevAddView")
    public  String toSwitchDevAddView(String school,String house,String floor,String room){

        addSchool=school;
        addHouse=house;
        addFloor=floor;
        addRoom=room;
        //System.out.println("school1:"+house+" "+floor+" "+room);
        return pathHead+"switchDevAddView";
    }
    //跳转至修改空开设备页面
    @RequestMapping("toSwitchDevUpdateView")
    public String toSwitchDevUpdateView(Model model,String loraSN)throws InterruptedException{
        return pathHead+"switchDevUpdateView";
    }
    @RequestMapping("switchDevManager")
    public String devManager(Model model,String loraSN)throws InterruptedException{
        List<EasyTree> list = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        model.addAttribute("schoolList",list);
        return pathHead+"switchDevManager";
    }
    @RequestMapping("switchDevView")
    public String switchDevView(Model model,String school,String house,String floor,String room)throws InterruptedException{
        List<EasyTree> list = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        model.addAttribute("schoolList",list);

        /*JSONObject jsonArea=new JSONObject();
        List<SwitchDevInfo> switchDevList=switchDevservice.queryswitchDevInfo(jsonArea);
        model.addAttribute("switchDevList",switchDevList);*/
        //MyUtil.printfInfo(list.toString());
        //System.out.println("555:"+school);
        JSONObject json = new JSONObject();
        json.put("school",school);
        json.put("house",house);
        json.put("floor",floor);
        json.put("room",room);
        List<SwitchDevInfo> switchDevList = switchDevservice.queryswitchDevByArea(json);
        switchDevList = setAreaText(switchDevList);
        model.addAttribute("switchDevList",switchDevList);
        //System.out.println("空开设备list123:"+switchDevList);
        return pathHead+"switchDevView";
    }
    @RequestMapping("updataSwitchDevView")
    @ResponseBody
    public List<SwitchDevInfo> switchDevView2(Model model,String school,String house,String floor,String room)throws InterruptedException{
        JSONObject json = new JSONObject();
        json.put("school",school);
        json.put("house",house);
        json.put("floor",floor);
        json.put("room",room);
        List<SwitchDevInfo> switchDevList = switchDevservice.queryswitchDevByArea(json);
        model.addAttribute("switchDevList",switchDevList);
        //System.out.println("空开设备list123:"+switchDevList);
        return switchDevList;
    }
    //跳转至空开设备页面
    @RequestMapping("toSwitchDevManager")
    public String toSwitchDevManager(Model model,String loraSN)throws InterruptedException{
        return pathHead+"switchDevManager";
    }
    @RequestMapping("switchChnView")
    public String slaveView(HttpServletRequest request,Model model,int devId)throws InterruptedException{

        HttpSession session = request.getSession();
        session.setAttribute("devId",devId);
        SwitchDevInfo devInfo = switchDevservice.queryDevByDevId(devId);
        uuid=devInfo.getUuid();
        chncnt=devInfo.getChncnt();
        devID = devInfo.getDevId();
        loraSN=devInfo.getLoraSN();
        JSONObject json = new JSONObject();
        json.put("devId",devID);
        List<SwitchInfo> switchInfo = switchDevservice.querySwitch(json);
        devInfo.setSchool(organizeService.queryCurrId(devInfo.getSchool()).getText());
        devInfo.setHouse(organizeService.queryCurrId(devInfo.getHouse()).getText());
        devInfo.setFloor(organizeService.queryCurrId(devInfo.getFloor()).getText());
        devInfo.setRoom(organizeService.queryCurrId(devInfo.getRoom()).getText());

        //System.out.println("switchInfo:"+switchInfo);
        selectedUuid=uuid;
        //发送查询当前设备的请求命令
        LoraMsgUtil.SendLoraData(loraSN, "40", "");
        model.addAttribute("switchInfo",JSONObject.toJSONString(switchInfo));
        model.addAttribute("devInfo",devInfo);
        return "devManager/switchChnView";
    }
    @RequestMapping("switchView")
    public String switchView(Model model,int devId) throws InterruptedException{
        SwitchDevInfo devInfo = switchDevservice.queryDevByDevId(devId);
        uuid=devInfo.getUuid();
        chncnt=devInfo.getChncnt();
        devID = devInfo.getDevId();
        loraSN=devInfo.getLoraSN();
        JSONObject json = new JSONObject();
        json.put("devId",devID);
        List<SwitchInfo> switchInfo = switchDevservice.querySwitch(json);
        //System.out.println("switchInfo:"+switchInfo);
        selectedUuid=uuid;
        //发送查询当前设备的请求命令
        LoraMsgUtil.SendLoraData(loraSN, "40", "");
        model.addAttribute("switchInfo",JSONObject.toJSONString(switchInfo));
        model.addAttribute("devInfo",devInfo);

        return pathHead+"switchView";
    }
    @RequestMapping("sendDevId")
    @ResponseBody
    public JSONObject sendDevId(Model model,int devId)throws InterruptedException{

        JSONObject json = new JSONObject();
        json.put("devId",devId);
        return json;
    }
    //删除设备
    @RequestMapping("delSwitchDev")
    @ResponseBody
    public Map<String,Object> delSwitchDev(String Id,String thisLoraSN,HttpServletRequest request) throws InterruptedException{

        Map<String,Object> map = new HashMap<>();
        JSONObject jsonDelSwitchDev = new JSONObject();
        JSONObject jsonDelSwitch = new JSONObject();
        jsonDelSwitchDev.put("id",Id);
        jsonDelSwitch.put("loraSN",thisLoraSN);
        List<LoraDevInfo> loraList1=loraDevService.queryLoraByDevSN(thisLoraSN);
        System.out.println(">>>>>>>>>删除前剩余设备数量："+Integer.valueOf(loraList1.get(0).getSwitchGroupNum()));
        System.out.println(">>>>>>>>>要删除的设备ID："+Id);
        //Boolean orNo=LoraMsgUtil.SendLoraData(thisLoraSN,"40","");
        if(LoraPortUtil.HBStatus==true) {//通过发送查询设备命令来辨别网关设备是否正常连接（心跳间隔为一分钟，间隔时间较长）
            switchDevservice.delSwitchDev(jsonDelSwitchDev);
            switchDevservice.deleteSwitch(jsonDelSwitch);//删除相关设备的开关数据
            List<LoraDevInfo> loraList = loraDevService.queryLoraByDevSN(thisLoraSN);
            //System.out.println(">>>>>>>>>删除后剩余设备数量：" + Integer.valueOf(loraList.size()));
            //LoraDevInfo loraDevInfo=new LoraDevInfo();

            //更新lora网关设备包含的空开设备数量
            int switchGroupNum = Integer.valueOf(loraList.get(0).getSwitchGroupNum()) - 1;
            loraList.get(0).setSwitchGroupNum(String.valueOf(switchGroupNum));
            loraDevService.updateLora(loraList.get(0));

            //设置空开设备
            int code;
            if(setSwitchDev(thisLoraSN)==true){
                code = 1;
            }else {
                code = 0;
            }


            map.put("code", code);
            map.put("msg", (code > 0) ? "删除成功" : "删除失败");
        }else {
            map.put("msg", "当前网关设备已与服务器断开连接!");
        }
        return map;
    }
    @RequestMapping("getSwitchDevByArea")
    @ResponseBody
    public Layui getArea(Model model,String school,String house,String floor,String room,String devStatus,String loraSN)throws InterruptedException{
        System.out.println("1 "+school+house+floor+room+devStatus);
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
        if(devStatus.equals("全部")){
            devStatus="";
        }
        JSONObject json = new JSONObject();
        json.put("school",school);
        json.put("house",house);
        json.put("floor",floor);
        json.put("room",room);
        json.put("devStatus",devStatus);
        json.put("loraSN",loraSN);
        List<SwitchDevInfo> list = switchDevservice.queryswitchDevByArea(json);
        list = setAreaText(list);
        model.addAttribute("switchDevList",list);
        //System.out.println("空开设备list123:"+list);
        return Layui.data(list.size(),list);
    }
    @RequestMapping("switchDevBtn")
    @ResponseBody
    public JSONObject switchDevBtn(){

        JSONObject json = new JSONObject();
        JSONObject jsonSwitchOnline=new JSONObject();
        JSONObject jsonSwitchNum=new JSONObject();
        jsonSwitchOnline.put("devStatus","在线");

        List<SwitchDevInfo> listSwitchDevOnline=switchDevservice.queryswitchDevInfo(jsonSwitchOnline);
        int SwitchOnline=listSwitchDevOnline.size();

        List<SwitchDevInfo> listSwitchDevNum=switchDevservice.queryswitchDevInfo(jsonSwitchNum);
        int SwitchNum=listSwitchDevNum.size();

        json.put("switchNum",SwitchNum);
        json.put("switchOnline",SwitchOnline);
        return json;
    }

    private static SwitchDevService switchDevServiceStatic;
    //设置空开设备方法
    public  static Boolean   setSwitchDev (String thisLoraSN)throws InterruptedException{
        switchDevServiceStatic = BeanContext.getBean(SwitchDevService.class);
        msg="";
        System.out.println(">>>>>设置空开设备的目标网关为："+thisLoraSN);

        List<SwitchDevInfo> switchDevInfoList=switchDevServiceStatic.queryDevByloraSN(thisLoraSN);
        System.out.println(">>>>>>要设置的设备数量："+switchDevInfoList.size());
        String sensor;
        String chnList;
        msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                "<SET_SENSOR_REQ>" +
                "<id>"+thisLoraSN+"</id>" +
                "<count>"+switchDevInfoList.size()+"</count>" +
                "<list>";

        //System.out.println("switchDevInfoList:"+switchDevInfoList.size()+"/"+switchDevInfoList);
        for(int i=0;i<switchDevInfoList.size();i++){
            sensor="<sensor>";
            sensor=sensor+"<uuid>"+switchDevInfoList.get(i).getUuid()+"</uuid>";
            sensor=sensor+"<sensor_type>17</sensor_type>"+"<port>0</port>";
            sensor=sensor+"<interval>"+switchDevInfoList.get(i).getIntervaltime()+"</interval>";
            sensor=sensor+"<chn_cnt>"+switchDevInfoList.get(i).getChncnt()+"</chn_cnt>";
            sensor=sensor+"<chn_list>";
            for(int j=0;j<switchDevInfoList.get(i).getChncnt();j++){
                chnList="<chn>";
                chnList=chnList+"<chn_type>19</chn_type>"+"<thr>0</thr>";
                chnList=chnList+"</chn>";
                sensor=sensor+chnList;
            }
            msg=msg+sensor+"</chn_list>" + "</sensor>";
        }
        msg=msg+"</list>" +
                "</SET_SENSOR_REQ>";
        LoraMsgUtil.SendLoraData(thisLoraSN,"41","17");

        return LoraPortUtil.boolSet;
    }

    @RequestMapping("getSwitchDevList")
    @ResponseBody
    public String switchDevList(Model model,String school,String house,String floor,String room)throws InterruptedException{
        JSONObject jsonArea=new JSONObject();

        List<SwitchDevInfo> switchDevList=switchDevservice.queryswitchDevByArea(jsonArea);
        model.addAttribute("switchDevList",switchDevList);
        return "";
    }

    @RequestMapping("getSwitchData")
    @ResponseBody
    public Layui getSwitchData(HttpServletRequest request,Model model)throws InterruptedException{
        int page = Integer.valueOf(request.getParameter("page"));
        int limit = Integer.valueOf(request.getParameter("limit"));
        int offset = (page-1)*limit;
        JSONObject json = new JSONObject();
        json.put("offset",offset);
        json.put("limit",limit);
        json.put("devId",devID);
        List<SwitchInfo> switchInfo = switchDevservice.querySwitch(json);

        int count = switchDevservice.querySwitchCount(json);
        return Layui.data(count,switchInfo);
    }

    //更改开关线路名称
    @RequestMapping("modifySwitch")
    @ResponseBody
    public JSONObject modifySwitch(SwitchInfo switchInfo){
        System.out.println("修改开关:"+switchInfo.toString());
        int iRet = switchDevservice.updateSwitch(switchInfo);
        JSONObject json = new JSONObject();
        json.put("code",iRet);
        json.put("msg",(iRet > 0 ? "修改成功":"修改失败"));

        JSONObject queryJson = new JSONObject();
        queryJson.put("devId",switchInfo.getDevId());
        List<SwitchInfo> list = switchDevservice.querySwitch(queryJson);
        json.put("data",list);
        return json;
    }

    //获取照明能耗统计
    @RequestMapping("lightEnergyConsumption")
    @ResponseBody
    public JSONObject lightEnergyConsumption(){
        JSONObject json=new JSONObject();

        return json;
    }



}
