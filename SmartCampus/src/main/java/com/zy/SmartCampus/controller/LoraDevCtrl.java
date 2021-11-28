package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSONObject;

import com.zy.SmartCampus.lorasearch.LoraMsgUtil;
import com.zy.SmartCampus.lorasearch.LoraPortUtil;

import com.zy.SmartCampus.polo.*;

import com.zy.SmartCampus.controller.SwitchDevCtrl;
import com.zy.SmartCampus.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

import java.net.ServerSocket;
import java.text.SimpleDateFormat;
import java.util.*;

//Lora网关设备
@Controller
public class LoraDevCtrl {

    @Autowired
    private SwitchDevService switchDevservice;
    @Autowired
    private LoraDevService loraDevService;
    @Autowired
    private DevService devService;
    @Autowired
    private OrganizeService organizeService;
    @Autowired
    private AirDevService airDevService;
    public static List<LoraDevInfo> list;
    public static int count = 0;
    public static String devSN;
    public static int[] address;
    private LoraDevInfo loraDevInfo;
    private static int thisTarget;

    //从数据库中获取所有Lora网关设备(页面初次加载)
    @RequestMapping("getLoraDev")
    @ResponseBody
    public Layui getLoraDev(HttpServletRequest request)throws Exception {
        int page = Integer.valueOf(request.getParameter("page"));
        int limit = Integer.valueOf(request.getParameter("limit"));
        int offset = (page-1)*limit;
        if(count == 0) {
            //初次加载，所有网关状态为"离线"
            LoraDevInfo loraDevInfo = new LoraDevInfo();
            loraDevInfo.setOnLine("离线");
            loraDevService.updateOnLoadStatus(loraDevInfo);
            //UdpMsgInHandler.connectLora();
            Thread.sleep(200);
            count=1;
        }
        if(count>0){
            //获取搜索到的网关信息
            List<LoraDevInfo> searchList = LoraPortUtil.getLoraDevInfo();
            //System.out.println("++__++__++" + searchList);
            Thread.sleep(200);
            for (int j=0 ; j<searchList.size() ;j++){
                LoraDevInfo loraDevInfo = new LoraDevInfo();
                loraDevInfo.setLoraSN(searchList.get(j).getLoraSN());

                //根据设备序列号devSN更新空开组的数量
                List<SwitchDevInfo> switchDevInfoList=switchDevservice.queryDevByloraSN(searchList.get(j).getLoraSN());
                loraDevInfo.setSwitchGroupNum(String.valueOf(switchDevInfoList.size()));
                loraDevService.updateRestartStatus(loraDevInfo);

                String devSN = searchList.get(j).getLoraSN();
                //判断当前设备在数据库中是否已经存在 ,搜索到的网关已被添加则状态改为："在线"
                List<LoraDevInfo> loraList = loraDevService.queryLoraByDevSN(devSN);
                if(loraList.size()>0){
                    LoraDevInfo updateDevStatus = new LoraDevInfo();
                    updateDevStatus.setLoraSN(searchList.get(j).getLoraSN());
                    updateDevStatus.setOnLine("在线");
                    loraDevService.updateRestartStatus(updateDevStatus);
                }
            }
        }
        JSONObject json = new JSONObject();
        json.put("offset",offset);
        json.put("limit",limit);
        List<LoraDevInfo> list = loraDevService.queryLoraDevInfo(json);
        list = setAreaText(list);
        int count = loraDevService.selectLoraDevInfoCount(json);
        return Layui.data(count,list);
    }

    //LORA网关设备搜索
    @RequestMapping("loraDevSearch")
    public String slaveView(Model model)  throws Exception {
        List<EasyTree> schoolList = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        List<LoraDevInfo> searchList = LoraPortUtil.getLoraDevInfo();
        Boolean connectionStatus = false;//连接异常状态
        Boolean searchStatus =false;   //搜索新设备状态
        System.out.println("searchList"+searchList.size());
        int i = 0 ;
        while(searchList.size()==0){
            //搜索时长超过30秒, 提示搜索不到设备
            if(i<30){
                Thread.sleep(1000);
                i++;
                System.out.println(i);
            }else {
                connectionStatus =true;
                System.out.println("LORA设备搜索时长超过30秒, 请检查是否连接正确");
                break;
            }
        }
//        System.out.println("搜索lora设备结束");
        Thread.sleep(5000);
        List<LoraDevInfo> newLoraDev = new ArrayList<>();
        List<LoraDevInfo> list =  new LinkedList<>();
        list.addAll(searchList);
        for (int j=0 ; j<searchList.size() ;j++){
            LoraDevInfo loraDevInfo = new LoraDevInfo();
            loraDevInfo.setLoraSN(searchList.get(j).getLoraSN());
            String loraSN = searchList.get(j).getLoraSN();
            //判断当前设备在数据库中是否已经存在
            List<LoraDevInfo> loraList = loraDevService.queryLoraByDevSN(loraSN);
            if(loraList.size()==0){
                newLoraDev.add(list.get(j));
            }else{
                LoraDevInfo updateDevStatus = new LoraDevInfo();
                updateDevStatus.setLoraSN(searchList.get(j).getLoraSN());
                updateDevStatus.setOnLine("在线");
                loraDevService.updateOnLoadStatus(updateDevStatus);
            }
        }
        System.out.println("newLoraDev.size()"+newLoraDev.size());
        if(newLoraDev.size()==0){
            searchStatus = true;
        }
        System.out.println("newDevList：" + newLoraDev);
        model.addAttribute("list",JSONObject.toJSONString(newLoraDev));
        model.addAttribute("connectionStatus",connectionStatus);
        model.addAttribute("searchStatus",searchStatus);
//        System.out.println("2156789213"+schoolList);
        model.addAttribute("schoolList",schoolList);
        return "devManager/loraDevSearchView";
    }

    @RequestMapping("loraView")
    public String loraView(Model model){
        List<EasyTree> list = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        model.addAttribute("schoolList",list);
        return "./devManager/loraView";
    }
    //搜索后添加设备
    @RequestMapping("addLoraDev")
    @ResponseBody
    public JSONObject addLoraDev(HttpServletRequest request) throws IOException,InterruptedException {
        String list  = request.getParameter("list");
        JSONObject json = new JSONObject();
        List<LoraDevInfo> devList =null;
        devList = (List<LoraDevInfo>) JSONObject.parseArray(list,LoraDevInfo.class);
        //System.out.println(devList.size());
        int code = 0;

        for(int i=0;i<devList.size();i++){
            System.out.println(devList.get(i).toString());
            LoraDevInfo info = devList.get(i);
            String devSN = info.getLoraSN();
            List<LoraDevInfo> loraDevList = loraDevService.queryLoraByDevSN(devSN);

            if(loraDevList.size() == 0){
                List<SwitchDevInfo> switchDevInfoList=switchDevservice.queryDevByloraSN(info.getLoraSN());
                info.setSwitchGroupNum(String.valueOf(switchDevInfoList.size()));
                loraDevService.addLoraDev(info);
                loraDevService.updateLora(info);
                //删除Lora网关下的空开设备
                Boolean iRet=SwitchDevCtrl.setSwitchDev(info.getLoraSN());
                //设置噪声传感器设备
                NoiseDevController.setNoiseDev(info.getLoraSN());
                if(iRet==true){
                    code = 1;
                }else {
                    code = 0;
                }
                //System.out.println(code);
                json.put("code",code);
                json.put("msg",(code>0)?"添加成功":"添加失败");
            }
        }
        return json;
    }
    //编辑添加空开组数量
    @RequestMapping("editLora")
    @ResponseBody
    public JSONObject editLora(LoraDevInfo loraDevInfo){
        JSONObject json = new JSONObject();
        int iRet = loraDevService.updateLora(loraDevInfo);

        json.put("code",iRet);
        json.put("msg",(iRet > 0 ? "修改成功":"修改失败"));
        String devSN = loraDevInfo.getLoraSN();

        List<LoraDevInfo> list = loraDevService.queryLoraByDevSN(devSN);
        json.put("data",list);
        return json;
    }

    //跳转至空开网信测试页面
    @RequestMapping("SwitchDevManager")
    public String SwitchDevManager() {
        return "switchtest";
    }
    //编辑Lora网关所在区域
    @RequestMapping("editLoraDev")
    public String editLoraDev(Model model,String loraSN){
        List<EasyTree> schoolList = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");

        System.out.println("loraDevSN"+loraSN);
        List<LoraDevInfo> loraDevInfoList = loraDevService.queryLoraByDevSN(loraSN);
        System.out.println("loraDevInfoList"+loraDevInfoList);

        String schoolName = loraDevInfoList.get(0).getSchool();
        String houseName = loraDevInfoList.get(0).getHouse();
        String floorName = loraDevInfoList.get(0).getFloor();

        String schoolId = "";
        String houseId = "";
        String floorId = "";
        if(schoolName.equals("无")){
            schoolId = "0";
            houseId = "0";
            floorId = "0";
        }else {
            schoolId = organizeService.queryByName(schoolName).getId();
            houseId = "";
            floorId = "";
            List<EasyTree> schoolChildList = organizeService.queryChildenOrganize(schoolId,"");
            if(houseName.equals("无")){
                houseId = "0";
                floorId = "0";
            }else{
                for(int i = 0 ;i < schoolChildList.size();i++){
                    if(schoolChildList.get(i).getText().equals(houseName)){
                        houseId = schoolChildList.get(i).getId();
                    }
                }
                List<EasyTree> houseChildList = organizeService.queryChildenOrganize(houseId,"");
                if(floorName.equals("无")){
                    floorId = "0";
                }else{
                    for(int i = 0 ;i < houseChildList.size();i++){
                        if(houseChildList.get(i).getText().equals(floorName)){
                            floorId = houseChildList.get(i).getId();
                        }
                    }
                }
            }
        }
        EasyTree easyTree = new EasyTree();
        easyTree.setId("0");
        easyTree.setText("无");
        List<EasyTree> houseList = new ArrayList<>();
        List<EasyTree> floorList = new ArrayList<>();
        if(schoolId!="0"){
            houseList = organizeService.queryChildenOrganize(schoolId,"");
        }
        if(houseId!="0"){
            floorList = organizeService.queryChildenOrganize(houseId,"");
        }
        System.out.println("houseList1"+houseList);
        schoolList.add(0,easyTree);
        houseList.add(0,easyTree);
        floorList.add(0,easyTree);
        List<Device> organizeList = new ArrayList<>();
        Device device = new Device();
        device.setSchoolId(schoolId);
        device.setHouseId(houseId);
        device.setFloorId(floorId);
        organizeList.add(device);
        model.addAttribute("schoolList",schoolList);
        model.addAttribute("houseList",houseList);
        model.addAttribute("floorList",floorList);
        model.addAttribute("organizeList",organizeList);
        System.out.println("schoolList"+schoolList);
        System.out.println("houseList"+houseList);
        System.out.println("floorList"+floorList);
        System.out.println("organizeList"+organizeList);

        return "./devManager/editLoraView";
    }
    //编辑Lora网关所在区域
    @RequestMapping("updateLoraDev")
    @ResponseBody
    public JSONObject updateLoraDev(Model model,String schoolId,String houseId,String floorId,String loraSN){
        JSONObject json=new JSONObject();
        List<LoraDevInfo> loraDevList=loraDevService.queryLoraByDevSN(loraSN);
        String newSchool = "";
        String newHouse = "";
        String newFloor = "";
        if(!schoolId.equals("0")){
            newSchool = organizeService.queryCurrId(schoolId).getText();
        }else{
            newSchool = "无";
        }
        if(!houseId.equals("0")){
            newHouse=organizeService.queryCurrId(houseId).getText();
        }else{
            newHouse = "无";
        }
        if(!floorId.equals("0")){
            newFloor=organizeService.queryCurrId(floorId).getText();
        }else{
            newFloor = "无";
        }
        loraDevList.get(0).setSchool(newSchool);
        loraDevList.get(0).setHouse(newHouse);
        loraDevList.get(0).setFloor(newFloor);
        System.out.println("123:"+loraDevList.get(0));
        int code=loraDevService.updateLora(loraDevList.get(0));
        System.out.println("loraDevList.get(0)"+loraDevList.get(0));
        int code1 = switchDevservice.updateSwitchDevByLoraSN(loraDevList.get(0));
        json.put("code",code);
        json.put("msg",(code > 0)?"编辑成功":"编辑失败");
        return json;
    }
    //删除选中Lora网关设备
    @RequestMapping("delLoraDev")
    @ResponseBody
    public Map<String,Object> delDev(String id,HttpServletRequest request) throws InterruptedException {
        int code = 0;
        Map<String,Object> map = new HashMap<>();
        if(id != null){
            List<LoraDevInfo> loraDevInfoList=loraDevService.queryLoraDevByID(id);
            JSONObject jsonDelSwitch=new JSONObject();
            jsonDelSwitch.put("loraSN",loraDevInfoList.get(0).getLoraSN());
            /*Boolean orNo=LoraMsgUtil.SendLoraData(loraDevInfoList.get(0).getLoraSN(),"40","");
            if(orNo==true){//通过发送查询设备命令来辨别网关设备是否正常连接（心跳间隔为一分钟，间隔时间较长）*/
                //先删除该网关下的所有设备和各个设备下的开关
                switchDevservice.deleteSwitch(jsonDelSwitch);
                switchDevservice.delSwitchDev(jsonDelSwitch);
                //删除空调
                airDevService.delAirDevByLoraSN(jsonDelSwitch);
                code = loraDevService.delLoraDev(id);
                /*for(int i = 0 ; i < LoraPortUtil.ipAndDevSNList.size() ; i++) {
                    if (LoraPortUtil.ipAndDevSNList.get(i).getLoraSN().equals(devSN)) {
                        for (int j = 0; j < LoraPortUtil.socketList.size(); j++) {
                            if (LoraPortUtil.socketList.get(j).getInetAddress().getHostAddress().equals(LoraPortUtil.ipAndDevSNList.get(i).getIp())) {
                                LoraPortUtil.socketList.remove(LoraPortUtil.socketList.get(j));
                                LoraPortUtil.ipAndDevSNList.remove(LoraPortUtil.ipAndDevSNList.get(i));
                                System.out.println(LoraPortUtil.socketList);
                                System.out.println(LoraPortUtil.ipAndDevSNList);
                            }
                        }
                    }
                }*/
                //发送设置命令
                //Boolean iRet=SwitchDevCtrl.setSwitchDev(loraDevInfoList.get(0).getLoraSN());
                /*map.put("code", iRet);
                map.put("msg", (iRet > 0 ? "删除成功" : "删除失败"));*/
            map.put("code", code);
            map.put("msg", (code > 0 ? "删除成功" : "删除失败"));
           /* }else {
                map.put("msg", "当前网关设备已与服务器断开连接!");
            }*/
        }
        return map;
    }

    @RequestMapping("delSomeLora")
    @ResponseBody
    public JSONObject delSomeLora(@RequestBody List<LoraDevInfo> loraDevInfos){
        JSONObject json = new JSONObject();
        int code=0;
        for (LoraDevInfo loraDevInfo : loraDevInfos) {
            String id = loraDevInfo.getId();
            //设备表删除
            code = loraDevService.delLoraDev(id);
        }

        json.put("code",code);
        json.put("msg",(code > 0)?"删除成功":"删除失败");
        return json;
    }

    //重启选中Lora网关设备
    @RequestMapping("restartLoraDev")
    @ResponseBody
    public JSONObject restartDev(String id,HttpServletRequest request)throws InterruptedException{
        //code 判断按钮点击后的返回情况
        int code = 0;
        //sendStatus 判断发送请求是否成功，默认false
        Boolean sendStatus = false;
        List<LoraDevInfo> loraDevList = loraDevService.queryLoraDevByID(id);
        if(id != null && loraDevList.get(0).getOnLine().equals("在线"))
        {
            while(code==0||code==2){
                String devSN = loraDevList.get(0).getLoraSN();
                sendStatus = LoraMsgUtil.SendLoraData(devSN,"23",id);
                code = receiveStatus(sendStatus);
                if(code ==5){
                    LoraDevInfo loraDevInfo = new LoraDevInfo();
                    loraDevInfo.setLoraSN(devSN);
                    loraDevInfo.setOnLine("离线");
                    loraDevService.updateRestartStatus(loraDevInfo);
                    for(int i = 0 ; i < LoraPortUtil.ipAndDevSNList.size() ; i++) {
                        if (LoraPortUtil.ipAndDevSNList.get(i).getLoraSN().equals(devSN)) {
                            for (int j = 0; j < LoraPortUtil.socketList.size(); j++) {
                                if (LoraPortUtil.socketList.get(j).getInetAddress().getHostAddress().equals(LoraPortUtil.ipAndDevSNList.get(i).getIp())) {
                                    LoraPortUtil.socketList.remove(LoraPortUtil.socketList.get(j));
                                    LoraPortUtil.ipAndDevSNList.remove(LoraPortUtil.ipAndDevSNList.get(i));
                                }
                            }
                        }
                    }

                }
            }
        }else{
            code = 1 ;//请先连接网关
        }
        JSONObject json = new JSONObject();
        json.put("code",code);
        json.put("msg",(code == 5)?"重启成功":"重启失败");
        return json;
    }

    //升级选中Lora网关设备
    @RequestMapping("upgradeLoraDev")
    @ResponseBody
    public JSONObject upgradeDev(String id,HttpServletRequest request) throws Exception {
        int code = 0;
        Boolean sendStatus = false;
        List<LoraDevInfo> loraDevList = loraDevService.queryLoraDevByID(id);
        if(id != null && loraDevList.get(0).getOnLine().equals("在线")){
            while(code==0||code==2){
                String devSN = loraDevList.get(0).getLoraSN();
                sendStatus = LoraMsgUtil.SendLoraData(devSN,"24",id);
                code = receiveStatus(sendStatus);
            }
        }else{
            code = 1 ;//请先连接网关
        }
        JSONObject json = new JSONObject();
        json.put("code",code);
        json.put("msg",(code > 0)?"升级成功":"升级失败");
        return json;
    }

    //按钮点击后返回提示消息的处理
    public static int receiveStatus(Boolean sendStatus)throws InterruptedException{
        int code = 0;
        if(sendStatus)
        {
            System.out.println("控制层 ： 服务器发送成功");
            Thread.sleep(600);
            List<Map<String,Object>> receiveList = LoraPortUtil.getReceiveStatus();
            Boolean receiveBol = (Boolean) receiveList.get(0).get("receive");

            if(receiveBol)
            {
                System.out.println("控制层 ： 网关成功返回消息");
                Boolean receiveStatus = (Boolean) receiveList.get(0).get("receiveStatus");
                if(receiveStatus)
                {
                    code = 5;//网关返回消息内容显示操作成功
                    System.out.println("控制层 ： 网关返回内容显示操作成功");
                }else{
                    code = 4;//网关返回消息内容显示操作失败
                    System.out.println("控制层 ： 网关返回内容显示操作失败");
                }
            }else{
                code = 3;//网关没有返回消息
                System.out.println("控制层 ： 网关没有返回消息");
            }
        }else{
            code = 2;//服务器发送请求数据失败
            System.out.println("控制层 ： 服务器发送请求失败");
        }
        return code;
    }

    public static Boolean realTimeStatus = false;
    public static String uuid="";
    public static String loraDevSN="";
    @RequestMapping("reloadSwitch")
    @ResponseBody
    public List<Map<String,List<SwitchInfo>>>  reloadSwitch(SwitchCtrlInfo switchCtrl)throws InterruptedException{
        realTimeStatus = false;
        uuid="";
        loraDevSN="";
        System.out.println("刷新");
        String devId = String.valueOf(switchCtrl.getDevId());
        System.out.println("devId :"+devId);
        //String uuid ="";
        for(int i = 0;i<6-devId.length();i++){
            uuid=uuid.concat("0");
        }
        uuid=uuid.concat(devId);
        System.out.println("uuid:" +uuid);
        List<SwitchDevInfo> switchDevList = switchDevservice.queryDevByUuid(uuid);
        //网关设备序列号
        loraDevSN = switchDevList.get(0).getLoraSN();

        System.out.println("获取实时数据");

        List<SwitchInfo> switchList = LoraPortUtil.TcpServer.switchInfoList;

        if(switchList.size()>0){
            for(int i = 0;i<switchList.size();i++){

                SwitchInfo switchInfo = switchList.get(i);
                if(switchInfo.getLoraSN().equals(loraDevSN)&&switchInfo.getDevId().equals(uuid)){
                    System.out.println("devId: " + devId +"\n"+"switchInfo: "+switchInfo);
                    switchInfo.setDevId(devId);
                    System.out.println("========================"+switchInfo);
                    switchDevservice.updateNewData(switchInfo);

                    JSONObject sJson = new JSONObject();
                    sJson.put("devId",devId);
                    sJson.put("switchAddress",switchInfo.getSwitchAddress());
                    List<SwitchInfo> switchInfoList = switchDevservice.queryDetailByDevId(sJson);
                    if(switchInfoList.size()> 0){
                        System.out.println("detail:"+switchInfoList);
                        switchInfo.setDevId(switchInfoList.get(0).getDevId());
                        switchInfo.setSwitchAddress(switchInfoList.get(0).getSwitchAddress());
                        switchInfo.setSwitchStatus(switchInfoList.get(0).getSwitchStatus());
                        switchInfo.setRecordTime(switchInfoList.get(0).getRecordTime());
                        switchInfo.setSwitchName(switchInfoList.get(0).getSwitchName());
                        switchInfo.setLoraSN(switchInfoList.get(0).getLoraSN());
                    }
                    System.out.println(switchInfo.getSwitchAddress()+"号线路的switchInfo：" + switchInfo);
                    devService.insertToHistory(switchInfo);
                    System.out.println("更新成功");
                }
            }
        }

        return null;
    }

    @RequestMapping("queryLoraDevByFloor")
    @ResponseBody
    public List<LoraDevInfo> queryLoraDevByFloor(String school, String house, String floor) {
        JSONObject jsonObject=new JSONObject();
        jsonObject.put("school",school);
        jsonObject.put("house",house);
        jsonObject.put("floor",floor);
        List<LoraDevInfo> loraDevInfos=loraDevService.queryLoraDevByFloor(jsonObject);

        return loraDevInfos;
    }
    @RequestMapping("getLoraByArea")
    @ResponseBody
    public Layui getArea(Model model,String school,String house,String floor,String onLine)throws InterruptedException{

        if(school.equals("")){
            school="";
        }
        if(house.equals("")){
            house="";
        }
        if(floor.equals("")){
            floor="";
        }
        if(onLine.equals("全部")){
            onLine="";
        }
        JSONObject json = new JSONObject();
        json.put("school",school);
        json.put("house",house);
        json.put("floor",floor);
        json.put("onLine",onLine);
        List<LoraDevInfo> list = loraDevService.queryLoraDevByArea(json);
        list = setAreaText(list);
        model.addAttribute("LoraDevList",list);
        return Layui.data(list.size(),list);
    }

    //根据区域地点的ID设置地点文字
    public List<LoraDevInfo> setAreaText(List<LoraDevInfo> list){
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
        }
        return list;
    }
    //    @RequestMapping("loraCtrlDev")
//    @ResponseBody
//    public JSONObject loraCtrlDev(SwitchCtrlInfo switchCtrl, int dd){
//
//        System.out.println("switchdata="+switchCtrl.toString());
//        String[] strings = switchCtrl.getAddress().split(",");
//
//        String type = switchCtrl.getType();
//        int devId = switchCtrl.getDevId();
//        //添加计数器，保证每次能够读取实时数据
//        if(type.equals("close")){
//            count++;
//        }else if(type.equals("open")){
//            count=0;
//        }
//        if(type.equals("close") ){
//            System.out.println("合闸");
//            for(String temp : strings){
//                String msg = SwitchMsgUtil.singleSwitchOpenClose(devId,Integer.parseInt(temp)-1,false,count);
//                SwitchInfo switchInfo = new SwitchInfo();
//                switchInfo.setDevId(Integer.toString(switchCtrl.getDevId()));
//                switchInfo.setSwitchAddress(temp);
//                switchInfo.setSwitchStatus("在线");
//                devService.updateRecordTime(switchInfo);
//                try {
//                    Thread.sleep(dd);
//                } catch (InterruptedException e) {
//                    e.printStackTrace();
//                }
//            }
//
//            if (count == 1) {
//                try {
//                    Thread.sleep(200);
//                    System.out.println("Thread");
//                    count++;
//                    for(String temp : strings) {
//                        SwitchMsgUtil.singleSwitchOpenClose(devId, Integer.parseInt(temp) - 1, false, count);
//                    }
//                } catch (InterruptedException e) {
//                    System.out.println("111111111");
//                }
//            }
//
//        }else if(type.equals("open")){
//            System.out.println("开闸");
//            String s;
//            for(int i = 0;i<strings.length/2;i++){
//                s = strings[i];
//                strings[i] = strings[strings.length-1-i];
//                strings[strings.length-1-i] = s;
//            }
//            for(String temp : strings){
//                String msg = SwitchMsgUtil.singleSwitchOpenClose(devId,Integer.parseInt(temp)-1,true,count);
//                SwitchInfo switchInfo = new SwitchInfo();
//                switchInfo.setDevId(Integer.toString(switchCtrl.getDevId()));
//                switchInfo.setSwitchAddress(temp);
//                switchInfo.setSwitchStatus("离线");
//                devService.updateRecordTime(switchInfo);
//                try {
//                    Thread.sleep(dd);
//                } catch (InterruptedException e) {
//                    e.printStackTrace();
//                }
//            }
//        }
//
//        JSONObject json = new JSONObject();
//        json.put("msg","succ");
//        return  json;
    @RequestMapping("switchCtrlOpen")
    @ResponseBody
    public JSONObject openSwitchDev(String getAddress) throws InterruptedException {
        System.out.println("现在进行的是送电操作");
        thisTarget=1;
        String loraSN=SwitchDevCtrl.loraSN;
        //System.out.println("loraSN:"+loraSN);
        address=this.switchAddress(getAddress);

        for(int i=0;i<address.length;i++){
            System.out.println("-------------------------勾选的开关序号:"+address[i]);
        }

        JSONObject jsonObject = new JSONObject();
        jsonObject.put("1","成功");

        int code = 0;
        Boolean sendStatus = false;
        while(code==0||code==2) {
            System.out.println("/////////////////:"+loraSN);
            sendStatus =LoraMsgUtil.SendLoraData(loraSN, "4a", "");
            code = receiveStatus(sendStatus);
        }
        LoraPortUtil.allDataList.clear();
        System.out.println("111111111111111111111111111111111111111111111111111");
        //LoraPortUtil.dataList.clear();

        //Boolean orNo=LoraMsgUtil.SendLoraData(loraSN, "40", "");

        //while (orNo) {
        if(LoraPortUtil.HBStatus==true){
            for (int i = 0; i < address.length; i++) {
                SwitchInfo switchInfo;
                JSONObject json=new JSONObject();
                json.put("switchAddress",String.valueOf(address[i]));
                json.put("devId",SwitchDevCtrl.devID);
                switchInfo = switchDevservice.querySwitchByAddress(json);
                switchInfo.setSwitchStatus("通电");
                switchDevservice.updateSwitch(switchInfo);
            }
        }else {
            jsonObject.put("msg","通电失败,服务器与网关已断开连接！");
        }
        //break;
        //}
        return jsonObject;
    }
    @RequestMapping("switchCtrlClose")
    @ResponseBody
    public JSONObject closeSwitchDev(String getAddress) throws InterruptedException {
        System.out.println("现在进行的是断电操作");
        thisTarget=0;
        String loraSN=SwitchDevCtrl.loraSN;
        System.out.println("loraSN:"+loraSN);
        address=this.switchAddress(getAddress);
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("1","成功");
        int code = 0;
        Boolean sendStatus = false;
        while(code==0||code==2) {
            sendStatus =LoraMsgUtil.SendLoraData(loraSN, "4a", "");
            code = receiveStatus(sendStatus);
        }
        LoraPortUtil.allDataList.clear();
//        Boolean orNo=LoraMsgUtil.SendLoraData(loraSN, "40", "");
//        while (orNo) {
        if(LoraPortUtil.HBStatus==true){
            for (int i = 0; i < address.length; i++) {
                SwitchInfo switchInfo;
                JSONObject json=new JSONObject();
                json.put("switchAddress",String.valueOf(address[i]));
                json.put("devId",SwitchDevCtrl.devID);
                switchInfo = switchDevservice.querySwitchByAddress(json);
                switchInfo.setSwitchStatus("断电");
                switchDevservice.updateSwitch(switchInfo);
            }
        }else {
            jsonObject.put("msg","断电失败,服务器与网关已断开连接！");
        }
//            break;
//        }
        /*Map<String,Object> map = new HashMap<>();
        map.put("status","在线");
        String str = map.get("status").toString();
        System.out.println("str :" +str);*/
        return jsonObject;
    }
    public int getData(int count,int chncnt,int [] data,int [] Address){
        data=changeArray(data);//逆置data数组

        String switchData="";

        for(int i=0;i<Address.length;i++){
            System.out.println("address:"+Address[i]);
            if(thisTarget==1) {
                if (data[Address[i] - 1] == 0) {
                    data[Address[i] - 1] = 1;
                }
            }else {
                if (data[Address[i] - 1] == 1) {
                    data[Address[i] - 1] = 0;
                }
            }
        }
        data=changeArray(data);//再次逆置data数组
        for(int i=0;i<data.length;i++){
            //System.out.println(data[i]);
            switchData=switchData.concat(String.valueOf(data[i]));
        }
        int sendData= Integer.parseInt(switchData,2);
        System.out.println("sendData:"+sendData);
        return sendData;
    }

    //数组逆置方法
    public static int[] changeArray(int[] array) {
        int i = 0;
        int j = array.length-1;
        int temp = 0;
        while (i <= j) {
            temp = array[i];
            array[i] = array[j];
            array[j] = temp;
            i++;
            j--;
        }
        return array;
    }
    //处理字符串方法
    public int [] switchAddress(String Address){
        int adr[];
        String a= Address.replaceAll("[^0-9a-zA-Z\u4e00-\u9fa5.，,。？“”]+","");
        String s=",";
        String[] ch=a.split(s);
        adr=new int[ch.length];
        //可以声明你想转为相应类型的数组
        for (int i = 0; i < ch.length;i++) {
            adr[i]=Integer.parseInt(ch[i]);//进行强转
        }
        return adr;
    }
//    }
}
