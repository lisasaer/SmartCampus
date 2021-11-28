package com.zy.SmartCampus.controller;

import com.zy.SmartCampus.polo.*;
import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.util.MyUtil;
import java.net.InetAddress;
import com.zy.SmartCampus.util.WGAccessUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.List;

import com.zy.SmartCampus.service.*;

import static com.zy.SmartCampus.listener.MyListener.datagramSocket;

@Controller
public class WGdoorCtrl {

    @Autowired
    private WGdoorService wGdoorService;
    @Autowired
    private WGAccessDevService wgAccessDevService;

    @Autowired
    private StaffService staffService;
    @Autowired
    private OrganizeService organizeService;
    @Autowired
    private WgPermissionService wgPermissionService;
    private WGAccessUtil wgAccessUtil;

    //门设置
    /*@RequestMapping("addDoor")
    @ResponseBody
    public JSONObject addDoor(WGAccessDoorInfo wgAccessDoorInfo1,WGAccessDoorInfo wgAccessDoorInfo2) throws InterruptedException, UnknownHostException {


        //sendDoorSet(wgAccessDoorInfo2);
        JSONObject json =new JSONObject();
        int code = wGdoorService.addDoor(wgAccessDoorInfo1);
        //code += wGdoorService.addDoor(wgAccessDoorInfo2);
        json.put("code",code);
        json.put("msg",(code>0)?"设置成功":"设置失败");
        return json;
    }*/

    //门设置
    @RequestMapping("wgAccessDevDoorSet")
    @ResponseBody
    public JSONObject wgAccessDevDoorSet(@RequestBody List<WGAccessDoorInfo> listWGAccessDoorInfo) throws InterruptedException, UnknownHostException {
        JSONObject json =new JSONObject();
        int code;
        for(int i=0;i<listWGAccessDoorInfo.size();i++){
            //System.out.println(listWGAccessDoorInfo.get(i));
            wgAccessUtil.sendDoorSet(listWGAccessDoorInfo.get(i));
            code = wGdoorService.updateDoor(listWGAccessDoorInfo.get(i));
            json.put("code",code);
            json.put("msg",(code>0)?"设置成功":"设置失败");
        }
        return json;
    }

    //微耕门禁权限
    @RequestMapping("wgAccessDevPromise")
    public String wgAccessDevPromise(){
        return "wgAccessDev/wgAccessDevPromiseManager";
    }

    @RequestMapping("goWgPromiseMsg")
    public String goWgPromiseMsg(){
        return "wgAccessDev/wgPromiseMsg";
    }

    @RequestMapping("getWGPermission")
    @ResponseBody
    public Layui getWGPermission(){
        JSONObject jsonPermission=new JSONObject();
        List<PermissionInfo> listPermission=wgPermissionService.getWGPermission(jsonPermission);
        for (int i=0;i<listPermission.size();i++){
            String cardNo=listPermission.get(i).getCardNo();
            System.out.println("123333333333333333333333:"+cardNo);
            listPermission.get(i).setName(staffService.queryCardNo(cardNo).get(0).getName());
            listPermission.get(i).setStaffId(staffService.queryCardNo(cardNo).get(0).getStaffId());
        }
        //System.out.println(listPermission);

        return Layui.data(listPermission.size(),listPermission);
    }

    //根据条件查询设备信息
    @RequestMapping("queryWGDoor")
    @ResponseBody
    public Layui queryWGDoor(HttpServletRequest request){
        int page = Integer.valueOf(request.getParameter("page")) ;
        int limit = Integer.valueOf(request.getParameter("limit"));
        int offset = (page-1)*limit;
        String doorName = request.getParameter("doorName");
        String doorID = request.getParameter("doorID");
        String doorTreeIconCls = request.getParameter("doorTreeIconCls");
        String doorTreeId = request.getParameter("doorTreeId");
        JSONObject json = new JSONObject();
        json.put("doorName",doorName);
        json.put("doorID",doorID);

        List<WGAccessDoorInfo> list = new ArrayList<>();
        if(doorTreeIconCls==null){
            list = wGdoorService.queryWGDoor(json);
        }else{
            if(doorTreeIconCls.equals("my-tree-icon-1")){
                list = wGdoorService.queryWGDoor(json);
            }else if(doorTreeIconCls.equals("my-tree-icon-2")){
                String schoolId = doorTreeId;
                json.put("schoolId",schoolId);
                list = wGdoorService.queryWGDoor(json);
            }else if(doorTreeIconCls.equals("my-tree-icon-3")){
                String houseId = doorTreeId;
                json.put("houseId",houseId);
                list = wGdoorService.queryWGDoor(json);
            }else if(doorTreeIconCls.equals("my-tree-icon-4")){
                String floorId = doorTreeId;
                json.put("floorId",floorId);
                list = wGdoorService.queryWGDoor(json);
            }else if(doorTreeIconCls.equals("my-tree-icon-5")){
                String roomId = doorTreeId;
                json.put("roomId",roomId);
                list = wGdoorService.queryWGDoor(json);
            }
        }
        for(int i = 0;i<list.size();i++){
            String value = String.valueOf(list.get(i).getDoorID());
            list.get(i).setValue(value);
            String title = list.get(i).getDoorName();
            list.get(i).setTitle(title);
        }
        int count =list.size();
        return Layui.data(count,list);
    }

    public static List<WGAccessDoorInfo> devList = new ArrayList<>();
    @RequestMapping("getDoorByTree")
    @ResponseBody
    public Layui getDoorByTree(String iconCls,String id) {
        devList.clear();
        List<WGAccessDoorInfo> list =queryDoorChildrenTree(iconCls,id);
        int count = list.size();
        return Layui.data(count, list);
    }

    public List<WGAccessDoorInfo> queryDoorChildrenTree(String iconCls,String id){
        JSONObject jsonObject = new JSONObject();
        List<WGAccessDoorInfo> list = new ArrayList<>();
        if(iconCls==null){
            list = wGdoorService.queryWGDoor(jsonObject);
        }else{
            if(iconCls.equals("my-tree-icon-1")){
                list = wGdoorService.queryWGDoor(jsonObject);
            }else if(iconCls.equals("my-tree-icon-2")){
                String schoolId = id;
                jsonObject.put("schoolId",schoolId);
                list = wGdoorService.queryWGDoor(jsonObject);
            }else if(iconCls.equals("my-tree-icon-3")){
                String houseId = id;
                jsonObject.put("houseId",houseId);
                list = wGdoorService.queryWGDoor(jsonObject);
            }else if(iconCls.equals("my-tree-icon-4")){
                String floorId = id;
                jsonObject.put("floorId",floorId);
                list = wGdoorService.queryWGDoor(jsonObject);
            }else if(iconCls.equals("my-tree-icon-5")){
                String roomId = id;
                jsonObject.put("roomId",roomId);
                list = wGdoorService.queryWGDoor(jsonObject);
            }
        }
        for(int i = 0;i<list.size();i++){
            if(!list.get(i).getDoorID().equals("")) {
                String value = String.valueOf(list.get(i).getDoorID());
                list.get(i).setValue(value);
            }
            if(!list.get(i).getDoorName().equals("")) {
                String title = list.get(i).getDoorName();
                list.get(i).setTitle(title);
            }
        }
        devList.addAll(list);
        return devList;
    }
}
