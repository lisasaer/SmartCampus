package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.service.*;
import com.zy.SmartCampus.util.MyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.net.UnknownHostException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ManageCardController {
    @Autowired
    public ManageCardService manageCardService;

    @Autowired
    public WgPermissionService wgPermissionService;
    @Autowired
    private StaffService staffService;
    @Autowired
    private DeviceService deviceService;
    @Autowired
    private OrganizeService organizeService;
    @RequestMapping("goManageCard")
    public String goManageCard() {
        return "doorDevHK/manageCard";
    }

    //绑定表中查询personId，表连接查询到对应的userInfo
    @RequestMapping("getAllCheck")
    @ResponseBody
    public Layui getAllCheck(int page ,int limit,String id){
        //System.out.println("当前页码："+page+"  每页数量："+limit);
        int offset = (page-1)*limit;
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("limit",limit);
        jsonObject.put("offset",offset);
        jsonObject.put("id",0);
        List<StaffDetail> list = new ArrayList<>();
        int count = list.size();

        return Layui.data(count,list);
    }

    @RequestMapping("getAllValue")
    @ResponseBody
    public Layui getAllStaff() {
        JSONObject jsonObject = new JSONObject();
        List<StaffDetail> list = staffService.queryStaff(jsonObject);
        int count = list.size();
        return Layui.data(count, list);
    }
    public static List<StaffDetail> resList = new ArrayList<>();
    @RequestMapping("getDataByTree")
    @ResponseBody
    public Layui getDataByTree(String iconCls,String id) {
        resList.clear();
        List<StaffDetail> list =queryChildrenTree(iconCls,id);
        int count = list.size();
        return Layui.data(count, list);
    }

    public List<StaffDetail> queryChildrenTree(String iconCls,String id){
        JSONObject jsonObject = new JSONObject();
        List<StaffDetail> list = new ArrayList<>();
        if(iconCls==null){
            list = staffService.queryStaff(jsonObject);
        }else {
            if(iconCls.equals("my-tree-icon-1")){
                list = staffService.queryStaff(jsonObject);
            }else if(iconCls.equals("my-tree-icon-2")){
                String schoolId = id;
                jsonObject.put("schoolId",schoolId);
                list = staffService.queryStaff(jsonObject);
            }else if(iconCls.equals("my-tree-icon-3")){
                String houseId = id;
                jsonObject.put("houseId",houseId);
                list = staffService.queryStaff(jsonObject);
            }else if(iconCls.equals("my-tree-icon-4")){
                String floorId = id;
                jsonObject.put("floorId",floorId);
                list = staffService.queryStaff(jsonObject);
            }else if(iconCls.equals("my-tree-icon-5")){
                String roomId = id;
                jsonObject.put("roomId",roomId);
                list = staffService.queryStaff(jsonObject);
            }
        }

        for(int i = 0;i<list.size();i++){
            if(list.get(i).getPersonType().equals("student")){
                list.get(i).setPersonTypeName("学生");
            }else if(list.get(i).getPersonType().equals("teacher")){
                list.get(i).setPersonTypeName("教师");
            }else if(list.get(i).getPersonType().equals("other")){
                list.get(i).setPersonTypeName("其他");
            }
            String value = list.get(i).getStaffId();
            list.get(i).setValue(value);
            String title = list.get(i).getName();
            list.get(i).setTitle(title);
            String cardId = list.get(i).getCardNo();
            list.get(i).setCardId(cardId);
        }
        resList.addAll(list);
        return resList;
    }

    //根据条件查询人员信息
    @RequestMapping("queryStaffTree")
    @ResponseBody
    public Layui queryStaffTree( HttpServletRequest request){
        int page = Integer.valueOf(request.getParameter("page")) ;
        int limit = Integer.valueOf(request.getParameter("limit"));
        int offset = (page-1)*limit;
        String name = request.getParameter("name");
        String staffId = request.getParameter("staffId");
        String cardNo = request.getParameter("cardNo");
        String staffTreeIconCls = request.getParameter("staffTreeIconCls");
        String personType = request.getParameter("personType");
        String staffTreeId = request.getParameter("staffTreeId");
        JSONObject json = new JSONObject();
        json.put("offset", String.valueOf(offset));
        json.put("limit", String.valueOf(limit));
        json.put("name",name);
        json.put("staffId",staffId);
        json.put("cardNo",cardNo);
        json.put("personType",personType);
        System.out.println("json"+json);
        List<StaffDetail> list = new ArrayList<>();
        System.out.println(staffTreeIconCls);
        if (staffTreeIconCls==null) {
            list = staffService.queryStaff(json);

        }else{
            if(staffTreeIconCls.equals("my-tree-icon-1")){
                list = staffService.queryStaff(json);
            }else if(staffTreeIconCls.equals("my-tree-icon-2")){
                String schoolId = staffTreeId;
                json.put("schoolId",schoolId);
                list = staffService.queryStaff(json);
            }else if(staffTreeIconCls.equals("my-tree-icon-3")){
                String houseId = staffTreeId;
                json.put("houseId",houseId);
                list = staffService.queryStaff(json);
            }else if(staffTreeIconCls.equals("my-tree-icon-4")){
                String floorId = staffTreeId;
                json.put("floorId",floorId);
                list = staffService.queryStaff(json);
            }else if(staffTreeIconCls.equals("my-tree-icon-5")){
                String roomId = staffTreeId;
                json.put("roomId",roomId);
                list = staffService.queryStaff(json);
            }
        }
        for(int i =0;i<list.size();i++){
            if(list.get(i).getPersonType()!=null){
                if(list.get(i).getPersonType().equals("student")){
                    list.get(i).setPersonTypeName("学生");
                }else if(list.get(i).getPersonType().equals("teacher")){
                    list.get(i).setPersonTypeName("教师");
                }else if(list.get(i).getPersonType().equals("other")){
                    list.get(i).setPersonTypeName("其他");
                }
            }
            String value = list.get(i).getStaffId();
            list.get(i).setValue(value);
            String title = list.get(i).getName();
            list.get(i).setTitle(title);
            String cardId = list.get(i).getCardNo();
            list.get(i).setCardId(cardId);
        }
        System.out.println("88"+list);
        int count =list.size();
        return Layui.data(count,list);
    }



    public static List<Device> devList = new ArrayList<>();
    @RequestMapping("getDevByTree")
    @ResponseBody
    public Layui getDevByTree(String iconCls,String id) {
        devList.clear();
        List<Device> list =queryDevChildrenTree(iconCls,id);
        int count = list.size();
        return Layui.data(count, list);
    }

    public List<Device> queryDevChildrenTree(String iconCls,String id){
        JSONObject jsonObject = new JSONObject();
        List<Device> list = new ArrayList<>();
        if(iconCls==null){
            list = deviceService.queryConditionDev(jsonObject);
        }else{
            if(iconCls.equals("my-tree-icon-1")){
                list = deviceService.queryConditionDev(jsonObject);
            }else if(iconCls.equals("my-tree-icon-2")){
                String schoolId = id;
                jsonObject.put("schoolId",schoolId);
                list = deviceService.queryConditionDev(jsonObject);
            }else if(iconCls.equals("my-tree-icon-3")){
                String houseId = id;
                jsonObject.put("houseId",houseId);
                list = deviceService.queryConditionDev(jsonObject);
            }else if(iconCls.equals("my-tree-icon-4")){
                String floorId = id;
                jsonObject.put("floorId",floorId);
                list = deviceService.queryConditionDev(jsonObject);
            }else if(iconCls.equals("my-tree-icon-5")){
                String roomId = id;
                jsonObject.put("roomId",roomId);
                list = deviceService.queryConditionDev(jsonObject);
            }
        }

        for(int i = 0;i<list.size();i++){

            String value = String.valueOf(list.get(i).getDeviceId());
            list.get(i).setValue(value);
            String title = list.get(i).getDname();
            list.get(i).setTitle(title);

        }
        devList.addAll(list);
        return devList;
    }

    //根据条件查询设备信息
    @RequestMapping("queryDoorTree")
    @ResponseBody
    public Layui queryDoorTree( HttpServletRequest request){
        int page = Integer.valueOf(request.getParameter("page")) ;
        int limit = Integer.valueOf(request.getParameter("limit"));
        int offset = (page-1)*limit;
        String dname = request.getParameter("dname");
        String dip = request.getParameter("dip");
        String doorTreeIconCls = request.getParameter("doorTreeIconCls");
        String doorTreeId = request.getParameter("doorTreeId");
        JSONObject json = new JSONObject();
        json.put("dname",dname);
        json.put("dip",dip);

        System.out.println("json"+json);
        List<Device> list = new ArrayList<>();
        if(doorTreeIconCls==null){
            list = deviceService.queryConditionDev(json);
        }else{
            if(doorTreeIconCls.equals("my-tree-icon-1")){
                list = deviceService.queryConditionDev(json);
            }else if(doorTreeIconCls.equals("my-tree-icon-2")){
                String schoolId = doorTreeId;
                json.put("schoolId",schoolId);
                list = deviceService.queryConditionDev(json);
            }else if(doorTreeIconCls.equals("my-tree-icon-3")){
                String houseId = doorTreeId;
                json.put("houseId",houseId);
                list = deviceService.queryConditionDev(json);
            }else if(doorTreeIconCls.equals("my-tree-icon-4")){
                String floorId = doorTreeId;
                json.put("floorId",floorId);
                list = deviceService.queryConditionDev(json);
            }else if(doorTreeIconCls.equals("my-tree-icon-5")){
                String roomId = doorTreeId;
                json.put("roomId",roomId);
                list = deviceService.queryConditionDev(json);
            }
        }
        for(int i = 0;i<list.size();i++){

            String value = String.valueOf(list.get(i).getDeviceId());
            list.get(i).setValue(value);
            String title = list.get(i).getDname();
            list.get(i).setTitle(title);

        }

        int count =list.size();
        return Layui.data(count,list);
    }

    //权限下发 卡和人脸参数
    @RequestMapping("addCardDevice")
    @ResponseBody
    public String addCardDevice(@RequestBody CardDeviceBean cardDeviceBean) throws UnsupportedEncodingException, ParseException, InterruptedException {
        System.out.println("cardDeviceBean  "+cardDeviceBean);
        manageCardService.addCardDevice(cardDeviceBean);
        return "success";
    }


    //微耕门禁权限增加
    @RequestMapping("addCardWgDev")
    @ResponseBody
    public String addCardWgDev(@RequestBody CardDeviceBean cardDeviceBean) throws UnknownHostException, ParseException, InterruptedException {
        System.out.println("cardDeviceBean  "+cardDeviceBean);
        manageCardService.addCardWgDev(cardDeviceBean);
        return "success";
    }

    //微耕门禁权限删除
    @RequestMapping("delCardWgDev")
    @ResponseBody
    public String delCardWgDev(@RequestBody CardDeviceBean cardDeviceBean) throws UnknownHostException, ParseException, InterruptedException {
        System.out.println("cardDeviceBean  "+cardDeviceBean);
        manageCardService.delCardWgDev(cardDeviceBean);
        return "success";
    }
}
