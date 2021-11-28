package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSONObject;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.zy.SmartCampus.listener.MyListener;
import com.zy.SmartCampus.lorasearch.BeanContext;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.service.*;
import com.zy.SmartCampus.util.MyUtil;
import com.zy.SmartCampus.util.WGAccessUtil;
import lombok.SneakyThrows;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

//微耕门禁设备
@Controller
public class WGAccessDevCtrl {

    @Autowired
    private WGAccessDevService wgAccessDevService;
    @Autowired
    private WgPermissionService wgPermissionService;
    @Autowired
    private StaffService staffService;
    private WGAccessUtil wgAccessUtil;
    public static List<WGAccessDevInfo> list;
    @Autowired
    private WGdoorService wGdoorService;
    @Autowired
    private DepartmentService departmentService;
    @Autowired
    private OrganizeService organizeService;

    final int intDoorCtrlWay=3;
    final int intDoorDelay=3;
    final int intDoorOnUse=1;

    @RequestMapping("wgAccessDev")
    public String WGAccessDev(Model model){

        List<EasyTree> list = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        model.addAttribute("schoolList",list);
        return "wgAccessDev/wgAccessDev";
    }
    //根据区域选择控制器
    @RequestMapping("getWGDevByArea")
    @ResponseBody
    public Layui getWGDevByArea(Model model,String school,String house,String floor,String room,String status)throws InterruptedException{

        JSONObject json = new JSONObject();
        json.put("school",school);
        json.put("house",house);
        json.put("floor",floor);
        json.put("room",room);
        json.put("status",status);
        List<WGAccessDevInfo> list = wgAccessDevService.queryWGDevByArea(json);

        model.addAttribute("switchDevList",list);
        //System.out.println("空开设备list123:"+list);
        return Layui.data(list.size(),list);
    }
    //根据SN或IP选择控制器
    @RequestMapping("queryWGDevBySNorIP")
    @ResponseBody
    public Layui queryWGDevBySNorIP(Model model,HttpServletRequest request)throws InterruptedException{

        String SNorIP=request.getParameter("SNorIP");
        String school=request.getParameter("school");
        String house=request.getParameter("house");
        String floor=request.getParameter("floor");
        String room=request.getParameter("room");
        String status=request.getParameter("status");

        JSONObject json = new JSONObject();
        json.put("SNorIP",SNorIP);
        json.put("school",school);
        json.put("house",house);
        json.put("floor",floor);
        json.put("room",room);
        json.put("status",status);
        List<WGAccessDevInfo> list = wgAccessDevService.queryWGDevBySNorIP(json);

        //将地点ID换成地点文字信息
        list = setAreaText(list);
        model.addAttribute("switchDevList",list);

        return Layui.data(list.size(),list);
    }



    //微耕门禁设备搜索
    @RequestMapping("wgAccessDevSearch")
    public String slaveView(Model model, String devSN) throws Exception {
       // List<WGAccessDevInfo> list;
        JSONObject json = new JSONObject();
        MyListener.wgAccessUDPSearch();//搜索在线设备
        System.out.println("WG搜索在线设备结束");
        Thread.sleep(300);

        list =  MyListener.getWGAccessDevInfoList();
        List<WGAccessDevInfo> onlist = wgAccessDevService.queryWGAccessDevInfo(json); //已在存在系统里的设备不再显示
        for(int i = 0;i<onlist.size();i++){
            WGAccessDevInfo devinfo = onlist.get(i);
            for(int j=0;j<list.size();j++){
                WGAccessDevInfo devinfoj = list.get(j);
                if(devinfo.getCtrlerSN().equals(devinfoj.getCtrlerSN())){
                    list.remove(devinfoj);
                    j--;
                    break;
                }
            }

        }
        model.addAttribute("list",JSONObject.toJSONString(list));
        return "wgAccessDev/wgAccessDevSearch";
    }

    //微耕门禁设备状态检测
    @RequestMapping("WGDevStatusTest")
    @ResponseBody
    public  Layui WGDevStatusTest() throws Exception {

        List<WGAccessDevInfo> listOnLineDev;//获取到的在线设备
        List<WGAccessDevInfo> listExistDev;//已有的设备
        JSONObject json = new JSONObject();
        MyListener.wgAccessUDPSearch();//搜索在线设备
        System.out.println("设备状态检测结束");
        Thread.sleep(300);

        listOnLineDev =  MyListener.getWGAccessDevInfoList();
        listExistDev = wgAccessDevService.queryWGAccessDevInfo(json);
        listExistDev = setAreaText(listExistDev);

        for(int i=0;i<listExistDev.size();i++){
            for(int j=0;j<listOnLineDev.size();j++){
                if(listExistDev.get(i).getCtrlerSN().equals(listOnLineDev.get(j).getCtrlerSN())){
                    listExistDev.get(i).setStatus("在线");
                    break;
                }else {
                    listExistDev.get(i).setStatus("离线");
                }
            }
            if(listOnLineDev.size()==0){
                listExistDev.get(i).setStatus("离线");
            }
        }

        listOnLineDev.clear();
        //model.addAttribute("list",JSONObject.toJSONString(listExistDev));
        return Layui.data(listExistDev.size(),listExistDev);
    }


    //搜索后添加设备
    @RequestMapping("addwgAccessDev")
    @ResponseBody
    public JSONObject addwgAccessDev(HttpServletRequest request) throws IOException {
        String list  = request.getParameter("list");
        //System.out.println("搜索的设备： "+list);
        List<WGAccessDevInfo> devList =null;
        devList = JSONObject.parseArray(list,WGAccessDevInfo.class);
        //System.out.println(devList.size());
        int code = 0;
        for(int i=0;i<devList.size();i++){

            WGAccessDevInfo wgAccessDevInfo = devList.get(i);
            wgAccessDevInfo.setId(MyUtil.getUUID());
            wgAccessDevInfo.setOnUse(1);//默认启用
            //info.setStatus("在线");//默认在线
            System.out.println(wgAccessDevInfo);
            code = wgAccessDevService.addWGAccessDev(wgAccessDevInfo);

            int length=Integer.valueOf(String.valueOf(devList.get(i).getCtrlerSN()).substring(0,1));
            for(int j=0;j<length;j++){
                WGAccessDoorInfo wgAccessDoorInfo=new WGAccessDoorInfo();
                wgAccessDoorInfo.setDoorID(String.valueOf(String.valueOf(devList.get(i).getCtrlerSN()))+(j+1));
                wgAccessDoorInfo.setCtrlerSN(String.valueOf(String.valueOf(devList.get(i).getCtrlerSN())));
                wgAccessDoorInfo.setDoorCtrlWay(String.valueOf(intDoorCtrlWay));
                wgAccessDoorInfo.setDoorDelay(String.valueOf(intDoorDelay));
                //wgAccessDoorInfo.setReaderID(String.valueOf(i+1));
                wgAccessDoorInfo.setDoorName(String.valueOf(j+1)+"号门");
                wgAccessDoorInfo.setOnUse(intDoorOnUse);
                wgAccessDoorInfo.setInType(String.valueOf(j+1)+"号门-"+"进门");
                wgAccessDoorInfo.setOutType(String.valueOf(j+1)+"号门-"+"出门");
                wGdoorService.addDoor(wgAccessDoorInfo);

            }
        }
        JSONObject json = new JSONObject();
        json.put("code",code);
        json.put("msg",(code>0)?"添加成功":"添加失败");
        return json;
    }

    //获取所有微耕设备
    @RequestMapping("getWGAcessDev")
    @ResponseBody
    public Layui getWGAcessDev(int page, int limit, HttpServletRequest request){
        int offset = (page-1)*limit;
        JSONObject json = new JSONObject();
        json.put("offset",offset);
        json.put("limit",limit);
        List<WGAccessDevInfo> list = wgAccessDevService.queryWGAccessDevInfo(json);
        //System.out.println("list:"+list.size());
        //通过schoolId将地点名称换为地点文字
        list = setAreaText(list);
        int count = wgAccessDevService.queryWGDevCount(json);
        return Layui.data(count,list);
    }
    //根据区域地点的ID设置地点文字
    public List<WGAccessDevInfo> setAreaText(List<WGAccessDevInfo> list){
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


    private static List<manageDeviceBean> manageDeviceBeans = new ArrayList<>();

    @RequestMapping("editWGAccessDev")
    public String editLoraDev(Model model,String ctrlerSN){
        List<EasyTree> listSchool = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        JSONObject jsonObject=new JSONObject();
        jsonObject.put("ctrlerSN",ctrlerSN);
        List<WGAccessDevInfo> listWGDev = wgAccessDevService.queryWGAccessDevInfoByJSON(jsonObject);
        //System.out.println("listWGDev"+listWGDev);

        String schoolId = listWGDev.get(0).getSchool();
        String houseId = listWGDev.get(0).getHouse();
        String floorId = listWGDev.get(0).getFloor();
        String roomId = listWGDev.get(0).getRoom();

        if(schoolId == null){
//            schoolId = "0";
            houseId = "";
            floorId = "";
            roomId = "";
        }
        else {
//            schoolId = organizeService.queryByName(schoolName).getId();
//            houseId = "";
            floorId = "";
            roomId = "";
//            List<EasyTree> schoolChildList = organizeService.queryChildenOrganize(schoolId,"");
            if(houseId == null){
//                houseId = "0";
                floorId = "";
                roomId = "";
            }else{
//                for(int i = 0 ;i < schoolChildList.size();i++){
//                    if(schoolChildList.get(i).getText().equals(houseName)){
//                        houseId = schoolChildList.get(i).getId();
//                    }
//                }
//                List<EasyTree> houseChildList = organizeService.queryChildenOrganize(houseId,"");
                if(floorId == null){
//                    floorId = "0";
                    roomId = "0";
                }else{
//                    for(int i = 0 ;i < houseChildList.size();i++){
//                        if(houseChildList.get(i).getText().equals(floorName)){
//                            floorId = houseChildList.get(i).getId();
//                        }
//                    }
//                    List<EasyTree> floorChildList = organizeService.queryChildenOrganize(floorId,"");
//                    if(roomId.equals("无")){
//                        roomId = "0";
//                    }else{
//                        for(int i = 0 ;i < floorChildList.size();i++){
//                            if(floorChildList.get(i).getText().equals(roomName)){
//                                roomId = floorChildList.get(i).getId();
//                            }
//                        }
//                    }
                }
            }
        }
        EasyTree easyTree = new EasyTree();
        easyTree.setId("");
        easyTree.setText("");
        List<EasyTree> houseList = new ArrayList<>();
        List<EasyTree> floorList = new ArrayList<>();
        List<EasyTree> roomList = new ArrayList<>();
        if(schoolId!=""){
            houseList = organizeService.queryChildenOrganize(schoolId,"");
        }
        if(houseId!=""){
            floorList = organizeService.queryChildenOrganize(houseId,"");
        }
        if(floorId!=""){
            roomList = organizeService.queryChildenOrganize(floorId,"");
        }
        listSchool.add(0,easyTree);
        houseList.add(0,easyTree);
        floorList.add(0,easyTree);
        roomList.add(0,easyTree);
        List<Device> organizeList = new ArrayList<>();
        Device device = new Device();
        device.setSchoolId(schoolId);
        device.setHouseId(houseId);
        device.setFloorId(floorId);
        device.setRoomId(roomId);
        organizeList.add(device);
        model.addAttribute("schoolList",listSchool);
        model.addAttribute("houseList",houseList);
        model.addAttribute("floorList",floorList);
        model.addAttribute("roomList",roomList);
        model.addAttribute("organizeList",organizeList);
        /*System.out.println("schoolList"+listSchool);
        System.out.println("houseList"+houseList);
        System.out.println("floorList"+floorList);
        System.out.println("roomList"+roomList);
        System.out.println("organizeList"+organizeList);*/
        //model.addAttribute("schoolList",list);
        return "./wgAccessDev/editWGAccessDev";
    }

    //编辑WG所在区域
    @RequestMapping("updateWGAccessDev")
    @ResponseBody
    public JSONObject updateWGAccessDev(Model model,String school,String house,String floor,String room,String ctrlerSN,String devName){
        JSONObject json=new JSONObject();
        json.put("ctrlerSN",ctrlerSN);
        List<WGAccessDevInfo> WGAccessDevList=wgAccessDevService.queryWGAccessDevInfoByJSON(json);
        System.out.println(WGAccessDevList);
        //List<WGAccessDoorInfo> listWGAccessDoor=wGdoorService.queryDoor(json);
        school = school!=null?school:"";
        house = house!=null?house:"";
        floor = floor!=null?floor:"";
        room = room!=null?room:"";
        if(school.equals("0")==false){
            /*String newSchool=organizeService.queryCurrId(school).getText();
            String newHouse=organizeService.queryCurrId(house).getText();
            String newFloor=organizeService.queryCurrId(floor).getText();
            String newRoom=organizeService.queryCurrId(room).getText();*/
            WGAccessDevList.get(0).setSchool(school);
            WGAccessDevList.get(0).setHouse(house);
            WGAccessDevList.get(0).setFloor(floor);
            WGAccessDevList.get(0).setRoom(room);
            //WGAccessDevList.get(0).setDevName(devName);
        }else {
            WGAccessDevList.get(0).setSchool("无");
            WGAccessDevList.get(0).setHouse("无");
            WGAccessDevList.get(0).setFloor("无");
            WGAccessDevList.get(0).setRoom("无");
            //WGAccessDevList.get(0).setDevName(devName);
        }
        System.out.println(WGAccessDevList.get(0));
        int code=wgAccessDevService.updateWGAccessDev(WGAccessDevList.get(0));

        json.put("code",code);
        json.put("msg",(code > 0)?"编辑成功":"编辑失败");
        return json;
    }
    //根据部门ID筛选微耕门禁设备
    @RequestMapping("selectWgByDepartmentId")
    @ResponseBody
    public List<manageDeviceBean> selectWgByDepartmentId(int departmentId) {
        manageDeviceBeans.clear();
        Department department = new Department();
        department.setDepartmentid(departmentId);
        List<manageDeviceBean> listWg =  selectDev(department);
        return listWg;
    }

    private List<manageDeviceBean> selectDev(Department department){
        int departmentId = department.getDepartmentid();
        List<Department> departments = departmentService.queryDepartmentByParentId(departmentId);
        //System.out.println(departments);
        //List<Device> devices = deviceService.queryDevByDepartmentId(departmentId);
        JSONObject jsonObject=new JSONObject();
        jsonObject.put("departmentId",departmentId);
        List<manageDeviceBean> manageCardBeanList =  wgAccessDevService.selectDeviceByDepartmentId(departmentId);
        //System.out.println("每次查到的信息："+manageCardBeanList);
        manageDeviceBeans.addAll(manageCardBeanList);
        MyUtil.printfInfo(manageDeviceBeans.toString());
        for(Department child : departments){
            selectDev(child);
        }
        return manageDeviceBeans;
    }


    @RequestMapping("delWGAccessDev")
    @ResponseBody
    public JSONObject delDev(String id,HttpServletRequest request) throws InterruptedException{
        int code = 0;
        if(id != null){
            WGAccessDevInfo wgAccessDevInfo=wgAccessDevService.queryWGAccessDevInfoByID(id);

            //发送删除设备所有权限命令
            WGAccessUtil.sendDelDevAllPermission(wgAccessDevInfo.getCtrlerSN());
            //删除数据表相关信息
            wgPermissionService.delWgAllPermission(wgAccessDevInfo.getCtrlerSN());

            wGdoorService.delDoor(wgAccessDevInfo.getCtrlerSN());
            code =wgAccessDevService.delWGAccessDev(id);

        }
        JSONObject json = new JSONObject();
        json.put("code",code);
        json.put("msg",(code > 0)?"删除成功":"删除失败");
        return json;
    }
    //批量删除设备
    @RequestMapping("delSomeWG")
    @ResponseBody
    public JSONObject delSomeWG(@RequestBody List<WGAccessDevInfo> wgAccessDevInfos)throws InterruptedException{
        JSONObject json = new JSONObject();
        int code=0;
        for (WGAccessDevInfo wgAccessDevInfo : wgAccessDevInfos) {
            String id = wgAccessDevInfo.getId();

            //WGAccessDevInfo wgAccessDevInfo=wgAccessDevService.queryWGAccessDevInfoByID(id);

            //发送删除设备所有权限命令
            WGAccessUtil.sendDelDevAllPermission(wgAccessDevInfo.getCtrlerSN());
            //删除数据表相关信息
            wgPermissionService.delWgAllPermission(wgAccessDevInfo.getCtrlerSN());
            //设备表删除
            code = wgAccessDevService.delWGAccessDev(id);
        }

        json.put("code",code);
        json.put("msg",(code > 0)?"删除成功":"删除失败");
        return json;
    }

    //按条件查询权限信息
    @RequestMapping("getAllWGPermission")
    @ResponseBody
    public Layui getAllWGPermission(HttpServletRequest request) throws InterruptedException{
        int page = Integer.valueOf(request.getParameter("page")) ;
        int limit = Integer.valueOf(request.getParameter("limit"));
        int offset = (page-1)*limit;
        String name = request.getParameter("name");
        String cardNo = request.getParameter("cardNo");
        String staffId = request.getParameter("staffId");
        String doorName = request.getParameter("doorName");
        String ctrlerSN = request.getParameter("ctrlerSN");

        JSONObject json = new JSONObject();

        json.put("offset", String.valueOf(offset));
        json.put("limit", String.valueOf(limit));
        json.put("name",name);
        json.put("staffId",staffId);
        json.put("cardNo",cardNo);
        json.put("doorName",doorName);
        json.put("ctrlerSN",ctrlerSN);

        List<PermissionInfo> listWGPermisson = wgPermissionService.getWGPermissionByJSON(json);
        return Layui.data(listWGPermisson.size(), listWGPermisson);
    }

    //删除设备的所有权限数据
    @RequestMapping("delDevAllPerssion")
    @ResponseBody
    public void delDevAllPerssion(String ctrlerSN) throws InterruptedException{
        //发送删除设备所有权限命令
        WGAccessUtil.sendDelDevAllPermission(ctrlerSN);
        //删除数据表相关信息
        wgPermissionService.delWgAllPermission(ctrlerSN);
    }

    //门禁刷卡实时监控
    @RequestMapping("wgAccessDevRealTime")
    public String wgAccessDevRealTime(Model model){
        JSONObject jsonObject = new JSONObject();
        List<WGAccessDoorInfo> listWGdoorDev = new ArrayList<>();
        listWGdoorDev = wGdoorService.queryWGDoor(jsonObject);
        model.addAttribute("WGDoorDevList",listWGdoorDev);
        return "wgAccessDev/wgAccessDevRealTime";
    }

    //筛选普通门禁设备
    @RequestMapping("wgAccessDevInRealTime")
    @ResponseBody
    public List<WGAccessDoorInfo> wgAccessDevInRealTime(Model model,String iconCls,String id){
        //System.out.println(iconCls+" "+id);
        JSONObject jsonObject = new JSONObject();
        List<WGAccessDoorInfo> listWGdoorDev = new ArrayList<>();
        if(iconCls==null){
            listWGdoorDev = wGdoorService.queryWGDoor(jsonObject);
        }else {
            if(iconCls.equals("my-tree-icon-1")){
                listWGdoorDev = wGdoorService.queryWGDoor(jsonObject);
            }else if(iconCls.equals("my-tree-icon-2")){
                String schoolId = id;
                jsonObject.put("schoolId",schoolId);
                listWGdoorDev = wGdoorService.queryWGDoor(jsonObject);
            }else if(iconCls.equals("my-tree-icon-3")){
                String houseId = id;
                String schoolId = organizeService.queryCurrId(houseId).getPId();
                jsonObject.put("houseId",houseId);
                jsonObject.put("schoolId",schoolId);
                //System.out.println(houseId+"-"+schoolId);
                listWGdoorDev = wGdoorService.queryWGDoor(jsonObject);
            }else if(iconCls.equals("my-tree-icon-4")){
                String floorId = id;
                String houseId = organizeService.queryCurrId(floorId).getPId();
                String schoolId = organizeService.queryCurrId(houseId).getPId();
                jsonObject.put("floorId",floorId);
                jsonObject.put("houseId",houseId);
                jsonObject.put("schoolId",schoolId);
                listWGdoorDev = wGdoorService.queryWGDoor(jsonObject);
            }else if(iconCls.equals("my-tree-icon-5")){
                String roomId = id;
                String floorId = organizeService.queryCurrId(roomId).getPId();
                String houseId = organizeService.queryCurrId(floorId).getPId();
                String schoolId = organizeService.queryCurrId(houseId).getPId();
                jsonObject.put("roomId",roomId);
                jsonObject.put("floorId",floorId);
                jsonObject.put("houseId",houseId);
                jsonObject.put("schoolId",schoolId);
                listWGdoorDev = wGdoorService.queryWGDoor(jsonObject);
            }
        }
        System.out.println("listWGDoorDEv: "+listWGdoorDev);
        model.addAttribute("WGDoorDevList",listWGdoorDev);
        return listWGdoorDev;
    }

    //微耕门设置
    @RequestMapping("wgAccessDevDoorSetting")
    public String wgAccessDevDoorSetting(Model model, String ctrlerSN) throws Exception {
        List<WGAccessDoorInfo> WGDoordevList = new ArrayList<>();
        //System.out.println("devid:"+ctrlerSN);
        JSONObject jsonWGDoor=new JSONObject();
        jsonWGDoor.put("ctrlerSN",ctrlerSN);
        WGDoordevList= wGdoorService.queryDoor(jsonWGDoor);

        List<WGAccessDevInfo> wGAccessDevInfo = wgAccessDevService.queryWGAccessDevInfoByJSON(jsonWGDoor);
        //System.out.println(wGAccessDevInfo.toString());
        model.addAttribute("WGDoordevList",WGDoordevList);
        //System.out.println(WGDoordevList);
        model.addAttribute("wGAccessDevInfo",wGAccessDevInfo.get(0));
        return "wgAccessDev/wgAccessDoorSetting";
    }

    //门禁设备校时
    @RequestMapping("wgAccessDevSetTime")
    @ResponseBody
    public JSONObject wgAccessDevSetTime(String ctrlerSN) throws InterruptedException {
        //System.out.println(ctrlerSN);
        JSONObject jsonRet=new JSONObject();

        int yes=wgAccessUtil.sendDevSetTime(ctrlerSN);
        jsonRet.put("msg",yes);
        jsonRet.put("msg",(yes>0)?"校时成功":"校时失败");
        return jsonRet;
    }
}
