package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSONObject;
import com.sun.jna.NativeLong;
import com.zy.SmartCampus.hik.HkSetting;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.service.*;
import com.zy.SmartCampus.util.MyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.sound.midi.Soundbank;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class DeviceController {
    @Autowired
    private HkSetting hkSetting;
    @Autowired
    private HkService hkService;
    @Autowired
    private StaffService staffService;
    @Autowired
    private DeviceService deviceService;
    @Autowired
    private OrganizeService organizeService;
    @Autowired
    private DepartmentService departmentService;
    @Autowired
    private HKPermissionService hkPermissionService;

    /**
     * 人脸门禁  页面初始化
     * @return
     */
    @RequestMapping("goMachine")
    public ModelAndView goMachine() {
        ModelAndView modelAndView = new ModelAndView("doorDevHK/device");
        List<EasyTree> schoolList = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        modelAndView.addObject("schoolList",schoolList);
        return modelAndView;
    }
    /**
     * 设备管理，2020-6-10-hhp
     * @return
     */
    @RequestMapping("toDevManager")
    public String devManager() {
        return "devManager";
    }

    @RequestMapping("goAddDevice")
    public ModelAndView goAddMachine() {
        ModelAndView modelAndView = new ModelAndView("doorDevHK/addDevice");
        List<EasyTree> list = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        modelAndView.addObject("schoolList",list);
        return modelAndView;
    }


    @RequestMapping("addDevice")
    @ResponseBody
    public String addDevice(@RequestBody Device device) throws UnsupportedEncodingException, ParseException{
        NativeLong lUserID =hkSetting.login(device);
        if(lUserID.intValue() > -1){
            Date date = new Date();
            String createdTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
            device.setCreatedTime(createdTime);
            deviceService.addDevice(device);
            List<Device> list = deviceService.queryNewDev();
            device.setDeviceId(list.get(0).getDeviceId());
            hkSetting.setUpAlarmChan(lUserID,device);
            hkSetting.setPictureData(lUserID);
            //根据设备IP判断权限表中是否存在相关信息
            String devIP = device.getDip();
            int devId = device.getDeviceId();
            List<HKPermisson> hkPermissonList = hkPermissionService.getPermissionByDevIP(devIP);
            if(hkPermissonList.size()>0){
                for(HKPermisson hkPermisson:hkPermissonList){
                    MyUtil.printfInfo(hkPermisson.toString());
                    JSONObject json = new JSONObject();
                    String cardNo = hkPermisson.getCardNo();
                    json.put("cardNo",cardNo);
                    List<StaffDetail> staffDetailList = staffService.queryStaff(json);
                    MyUtil.printfInfo(staffDetailList.toString());
                    LoginDevInfo loginDevInfo = hkSetting.getLoginDevInfoByDevID(deviceService.getDevIPByID(String.valueOf(devId)));//hkPermisson.getDevId():设备ID
                    FaceCardInfo faceCardInfo = new FaceCardInfo(loginDevInfo.getLUserID(),staffDetailList.get(0).getCardNo(),      //staffDetailList.get(0).getCardNo()卡号
                            "2019-01-01 00:00:00","2030-01-01 00:00:00","888888",
                            Integer.valueOf(staffDetailList.get(0).getStaffId()),staffDetailList.get(0).getName(),MyUtil.getWEBINFPath()+staffDetailList.get(0).getPhoto(),"DEL");   //工号    持卡人姓名   图片地址    类型：DEL--删除设备人员信息
                    //重新下发卡权限  --删除设备中的人员信息
                    hkService.setCardAndFaceInfo(faceCardInfo);
                    //删除人员权限表对应的信息
                    hkPermissionService.deletePermission(cardNo);
                }
            }
            return "succ";
        }else{
            return "error";
        }
    }

    @RequestMapping("selectDeviceAll")
    @ResponseBody
    public Layui selectDeviceAll(HttpServletRequest request) {
        //获取分页数据
        String page = request.getParameter("page");
        String limit = request.getParameter("limit");
        PageBean<Device> pageBean = deviceService.selectDeviceAll(page, limit);
        //int count = deviceService.selectCount(json);
        return Layui.data(pageBean.getTotalCount(), pageBean.getLists());
    }

    @RequestMapping("delDevice")
    @ResponseBody
    public String delDevice(/*Integer id*/Device device)throws UnsupportedEncodingException, ParseException{
        String devStatus = device.getDevStatus();
        int devId = device.getDeviceId();
        delHKDev(devId,devStatus);
        return "success";
    }

    @RequestMapping("delSomeDevice")
    @ResponseBody
    public String delSomeDevice(@RequestBody List<Device> devices) throws UnsupportedEncodingException, ParseException{
        for (Device device : devices) {
            String devStatus = device.getDevStatus();
            int devId = device.getDeviceId();
            delHKDev(devId,devStatus);
        }
        return "success";
    }

    public void delHKDev(int devId,String devStatus)throws UnsupportedEncodingException, ParseException{
        List<HKPermisson> hkPermissonList = hkPermissionService.getPermissionByDevId(devId);
        if(devStatus.equals("在线")){
            if(hkPermissonList.size()>0){
                for(HKPermisson hkPermisson:hkPermissonList){
                    MyUtil.printfInfo(hkPermisson.toString());
                    JSONObject json = new JSONObject();
                    String cardNo = hkPermisson.getCardNo();
                    json.put("cardNo",cardNo);
                    List<StaffDetail> staffDetailList = staffService.queryStaff(json);
                    MyUtil.printfInfo(staffDetailList.toString());
                    LoginDevInfo loginDevInfo = hkSetting.getLoginDevInfoByDevID(deviceService.getDevIPByID(String.valueOf(devId)));//hkPermisson.getDevId():设备ID
                    FaceCardInfo faceCardInfo = new FaceCardInfo(loginDevInfo.getLUserID(),staffDetailList.get(0).getCardNo(),      //staffDetailList.get(0).getCardNo()卡号
                            "2019-01-01 00:00:00","2030-01-01 00:00:00","888888",
                            Integer.valueOf(staffDetailList.get(0).getStaffId()),staffDetailList.get(0).getName(),MyUtil.getWEBINFPath()+staffDetailList.get(0).getPhoto(),"DEL");   //工号    持卡人姓名   图片地址    类型：DEL--删除设备人员信息
                    //重新下发卡权限  --删除设备中的人员信息
                    hkService.setCardAndFaceInfo(faceCardInfo);

                    //删除人员权限表对应的信息
                    hkPermissionService.deletePermission(cardNo);
                }
            }
            //删除的设备撤销布防
            for(int i=0;i<hkSetting.list.size();i++){
                if(hkSetting.list.get(i).getDeviceId()==devId){
                    NativeLong lAlarmHandle = hkSetting.list.get(i).getLAlarmHandleData();
                    hkSetting.closeAlarmChan(lAlarmHandle);
                }
            }
        }
        //删除设备信息表对应的信息
        deviceService.delDevice(devId);
    }

    private static List<manageDeviceBean> manageDeviceBeans = new ArrayList<>();
    @RequestMapping("selectDeviceByDepartmentIdCard")
    @ResponseBody
    public List<manageDeviceBean> selectDeviceByDepartmentIdCard(int departmentId) {
        manageDeviceBeans.clear();
        Department department = new Department();
        department.setDepartmentid(departmentId);
        List<manageDeviceBean> deviceBeans =  selectDev(department);
        return deviceBeans;
    }

    private List<manageDeviceBean> selectDev(Department department){
        int departmentId = department.getDepartmentid();
        List<Department> departments = departmentService.queryDepartmentByParentId(departmentId);
        List<manageDeviceBean> manageCardBeanList =  deviceService.selectDeviceByDepartmentIdCard(departmentId);
        manageDeviceBeans.addAll(manageCardBeanList);
        for(Department child : departments){
            selectDev(child);
        }
        return manageDeviceBeans;
    }
    @RequestMapping("getHKDevByArea")
    @ResponseBody
    public Layui getArea(Model model, String schoolId, String houseId, String floorId, String roomId)throws InterruptedException{

        JSONObject json = new JSONObject();
        json.put("schoolId",schoolId);
        json.put("houseId",houseId);
        json.put("floorId",floorId);
        json.put("roomId",roomId);
        List<Device> deviceList = deviceService.queryHKDevByArea(json);
        for(int i = 0;i<deviceList.size();i++){
            if(deviceList.get(i).getDevStatus().equals("0")){
                deviceList.get(i).setDevStatus("离线");
            }else if(deviceList.get(i).getDevStatus().equals("1")){
                deviceList.get(i).setDevStatus("在线");
            }
            /*if(deviceList.get(i).getSchoolId()!=null){
                if(!deviceList.get(i).getSchoolId().equals("")){
                    EasyTree schoolName = organizeService.queryCurrId(deviceList.get(i).getSchoolId());
                    deviceList.get(i).setSchoolName(schoolName.getText());
                }else{
                    deviceList.get(i).setSchoolName("");
                }
            }
            if(deviceList.get(i).getHouseId()!=null){
                if(!deviceList.get(i).getHouseId().equals("")){
                    EasyTree houseName = organizeService.queryCurrId(deviceList.get(i).getHouseId());
                    deviceList.get(i).setHouseName(houseName.getText());
                }else{
                    deviceList.get(i).setHouseName("");
                }
            }
            if(deviceList.get(i).getFloorId()!=null){
                if(!deviceList.get(i).getFloorId().equals("")){
                    EasyTree floorName = organizeService.queryCurrId(deviceList.get(i).getFloorId());
                    deviceList.get(i).setFloorName(floorName.getText());
                }else{
                    deviceList.get(i).setFloorName("");
                }
            }
            if(deviceList.get(i).getRoomId()!=null){
                if(!deviceList.get(i).getRoomId().equals("")){
                    EasyTree roomName = organizeService.queryCurrId(deviceList.get(i).getRoomId());
                    deviceList.get(i).setRoomName(roomName.getText());
                }else{
                    deviceList.get(i).setRoomName("");
                }
            }*/
        }
        model.addAttribute("HKDevList",deviceList);
        return Layui.data(deviceList.size(),deviceList);
    }
    //编辑设备
    @RequestMapping("editDeviceView")
    public ModelAndView editDeviceView (String deviceId){
        ModelAndView modelAndView = new ModelAndView("doorDevHK/editDevice");
        Map<String,Object> map = new HashMap<>();
        map.put("deviceId",deviceId);
        List<Device> deviceList = deviceService.queryConditionDev(map);
        for(int i = 0;i<deviceList.size();i++){
            if(deviceList.get(i).getDevStatus().equals("0")){
                deviceList.get(i).setDevStatus("离线");
            }else if(deviceList.get(i).getDevStatus().equals("1")){
                deviceList.get(i).setDevStatus("在线");
            }
            /*if(deviceList.get(i).getSchoolId()!=null){
                if(!deviceList.get(i).getSchoolId().equals("")){
                    EasyTree schoolName = organizeService.queryCurrId(deviceList.get(i).getSchoolId());
                    deviceList.get(i).setSchoolName(schoolName.getText());
                }else{
                    deviceList.get(i).setSchoolName("");
                }
            }
            if(deviceList.get(i).getHouseId()!=null){
                if(!deviceList.get(i).getHouseId().equals("")){
                    EasyTree houseName = organizeService.queryCurrId(deviceList.get(i).getHouseId());
                    deviceList.get(i).setHouseName(houseName.getText());
                }else{
                    deviceList.get(i).setHouseName("");
                }
            }
            if(deviceList.get(i).getFloorId()!=null){
                if(!deviceList.get(i).getFloorId().equals("")){
                    EasyTree floorName = organizeService.queryCurrId(deviceList.get(i).getFloorId());
                    deviceList.get(i).setFloorName(floorName.getText());
                }else{
                    deviceList.get(i).setFloorName("");
                }
            }
            if(deviceList.get(i).getRoomId()!=null){
                if(!deviceList.get(i).getRoomId().equals("")){
                    EasyTree roomName = organizeService.queryCurrId(deviceList.get(i).getRoomId());
                    deviceList.get(i).setRoomName(roomName.getText());
                }else{
                    deviceList.get(i).setRoomName("");
                }
            }*/
        }
        modelAndView.addObject("deviceList", deviceList);

        EasyTree easyTree = new EasyTree();
        easyTree.setId("");
        easyTree.setText("");

        List<EasyTree> schoolList = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        schoolList.add(0,easyTree);
        modelAndView.addObject("schoolList",schoolList);

        String schoolId = deviceList.get(0).getSchoolId();
        String houseId = deviceList.get(0).getHouseId();
        String floorId = deviceList.get(0).getFloorId();
        List<EasyTree> houseList = new ArrayList<>();
        List<EasyTree> floorList = new ArrayList<>();
        List<EasyTree> roomList = new ArrayList<>();
        if(!schoolId.equals("")){
            houseList = organizeService.queryChildenOrganize(schoolId,"");
        }
        if(!houseId.equals("")){
            floorList = organizeService.queryChildenOrganize(houseId,"");
        }
        if(!floorId.equals("")){
            roomList = organizeService.queryChildenOrganize(floorId,"");
        }
        houseList.add(0,easyTree);
        floorList.add(0,easyTree);
        roomList.add(0,easyTree);
        modelAndView.addObject("houseList",houseList);
        modelAndView.addObject("floorList",floorList);
        modelAndView.addObject("roomList",roomList);

        return modelAndView;
    }



    //更新设备
    @RequestMapping("updateDevice")
    public String updateDevice(@RequestBody Device device){
        System.out.println("This is updateDevice");
        deviceService.updateDevice(device);
        return "doorDevHK/device";

    }
    //按钮条件查询
    @RequestMapping("queryConditionDev")
    @ResponseBody
    public Layui queryConditionDev(HttpServletRequest request) {
        //获取分页数据
        String page = request.getParameter("page");
        String limit = request.getParameter("limit");
        String dip = request.getParameter("dip");
        String dname = request.getParameter("dname");
        String schoolId=request.getParameter("schoolId");
        String houseId=request.getParameter("houseId");
        String floorId=request.getParameter("floorId");
        String roomId=request.getParameter("roomId");
        String devStatus=request.getParameter("devStatus");
        Map<String, Object> map = new HashMap<>();
        map.put("dip",dip);
        map.put("dname",dname);
        map.put("schoolId",schoolId);
        map.put("houseId",houseId);
        map.put("floorId",floorId);
        map.put("roomId",roomId);
        map.put("devStatus",devStatus);
        PageBean<Device> pageBean = deviceService.queryConditionDev(page, limit,map);
        return Layui.data(pageBean.getTotalCount(), pageBean.getLists());
    }

    @RequestMapping("selectDevIP")
    @ResponseBody
    public JSONObject selectDevIP(String dip){
        List<Device> list = deviceService.queryByDevIP(dip);
        int code=0;
        if(list.size()>0){
            code=1;
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("code",code);
        MyUtil.printfInfo(jsonObject.toString());
        return jsonObject;
    }
}

