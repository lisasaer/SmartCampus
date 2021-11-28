package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSONObject;
import com.sun.jna.NativeLong;
import com.zy.SmartCampus.hik.HkSetting;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.service.*;
import com.zy.SmartCampus.util.MyUtil;
import com.zy.SmartCampus.util.WGAccessUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

@Controller
public class OrganizeCtrl {

    private final String pathHead = "organizeManager/";

    @Autowired
    private HkSetting hkSetting;
    @Autowired
    private HkService hkService;
    @Autowired
    private VideoService videoService;
    @Autowired
    private StaffService staffService;
    @Autowired
    private DeviceService deviceService;
    @Autowired
    private WGdoorService wGdoorService;
    @Autowired
    private AirDevService airDevService;
    @Autowired
    private LoraDevService loraDevService;
    @Autowired
    private OrganizeService organizeService;
    @Autowired
    private SwitchDevService switchDevservice;
    @Autowired
    private WGAccessDevService wgAccessDevService;
    @Autowired
    private WgPermissionService wgPermissionService;
    @Autowired
    private HKPermissionService hkPermissionService;
    @RequestMapping("organizeM")
    public String organizeM(){
        return pathHead+"organizeManager";
    }

    @RequestMapping("getTreeData")
    @ResponseBody
    public List<EasyTree> getTreeData(HttpServletRequest request){
        //System.out.println("获取节点数据");
        String iconCls = request.getParameter("iconCls");
        List<EasyTree> list = organizeService.queryChildenOrganize("0",iconCls);
        for(EasyTree easyTree : list){
            easyTree.setChildren(getChildrenTree(easyTree,iconCls));
        }
        return list;
    }

    //递归查找子节点
    private List<EasyTree> getChildrenTree(EasyTree easyTree,String iconCls){
        List<EasyTree> list = organizeService.queryChildenOrganize(easyTree.getId(),iconCls);
        for(EasyTree temp : list){
            temp.setChildren(getChildrenTree(temp,iconCls));
        }
        easyTree.setState(list.size() == 0 ? "open":"closed");
        return list;
    }

    @RequestMapping("delTree")
    @ResponseBody
    public JSONObject delTreeData(String id,String iconCls)throws UnsupportedEncodingException, ParseException ,InterruptedException{        //iconCls:my-tree-icon-2--校区,  my-tree-icon-3--楼栋, my-tree-icon-4--楼层, my-tree-icon-5--房号,
        System.out.println("删除节点"+iconCls );
        JSONObject json = new JSONObject();
        EasyTree easyTree = new EasyTree();
        easyTree.setId(id);
        easyTree.setIconCls(iconCls);
        delDevFromSpace(id,iconCls);
        delChildrenTree(easyTree);
        return json;
    }
    //选中准备删除的设备
    private void delDevFromSpace(String id,String iconCls)throws UnsupportedEncodingException, ParseException ,InterruptedException{
        System.out.println("选中准备删除的设备");
        JSONObject jsonObject = new JSONObject();

        if(iconCls.equals("my-tree-icon-1")){
        }else if(iconCls.equals("my-tree-icon-2")){
            String schoolId = id;
            jsonObject.put("schoolId",schoolId);
            EasyTree easyTree = organizeService.queryCurrId(schoolId);
            jsonObject.put("school",easyTree.getText());
        }else if(iconCls.equals("my-tree-icon-3")){
            String houseId = id;
            jsonObject.put("houseId",houseId);
            EasyTree easyTree = organizeService.queryCurrId(houseId);
            jsonObject.put("house",easyTree.getText());
        }else if(iconCls.equals("my-tree-icon-4")){
            String floorId = id;
            jsonObject.put("floorId",floorId);
            EasyTree easyTree = organizeService.queryCurrId(floorId);
            jsonObject.put("floor",easyTree.getText());
        }else if(iconCls.equals("my-tree-icon-5")){
            String roomId = id;
            jsonObject.put("roomId",roomId);
            EasyTree easyTree = organizeService.queryCurrId(roomId);
            jsonObject.put("room",easyTree.getText());
        }
        //人脸门禁设备
        List<Device> deviceList = deviceService.queryHKDevByArea(jsonObject);
        System.out.println("选中准备删除的设备"+deviceList);
        for (Device device : deviceList) {
            String devStatus = device.getDevStatus();
            int devId = device.getDeviceId();
            delHKDev(devId,devStatus);
        }
        //监控设备
        List<VideoInfo>  videoInfoList =  videoService.queryVideo(jsonObject);
        for (VideoInfo videoInfo : videoInfoList) {
            String videoInfoId = videoInfo.getId();
            videoService.delVideo(videoInfoId);
        }
        //普通门禁设备
        List<WGAccessDevInfo> WGList = wgAccessDevService.queryWGDevByArea(jsonObject);
        for (WGAccessDevInfo wgAccessDevInfo : WGList) {
            String WGDevId = wgAccessDevInfo.getId();
            //发送删除设备所有权限命令
            WGAccessUtil.sendDelDevAllPermission(wgAccessDevInfo.getCtrlerSN());
            //删除数据表相关信息
            wgPermissionService.delWgAllPermission(wgAccessDevInfo.getCtrlerSN());
            wGdoorService.delDoor(wgAccessDevInfo.getCtrlerSN());
            wgAccessDevService.delWGAccessDev(WGDevId);
        }
        if(!iconCls.equals("my-tree-icon-5")){
            List<LoraDevInfo> loraList = loraDevService.queryLoraDevByArea(jsonObject);
            for (LoraDevInfo loraDevInfo : loraList) {
                String loraId = loraDevInfo.getId();
                JSONObject jsonDelSwitch=new JSONObject();
                jsonDelSwitch.put("loraSN",loraDevInfo.getLoraSN());
                //先删除该网关下的所有设备和各个设备下的开关
                switchDevservice.deleteSwitch(jsonDelSwitch);
                switchDevservice.delSwitchDev(jsonDelSwitch);
                //删除空调
                airDevService.delAirDevByLoraSN(jsonDelSwitch);
                int code = loraDevService.delLoraDev(loraId);
            }
        }else{

        }
//
//        jsonDelSwitch.put("loraSN",loraDevInfoList.get(0).getLoraSN());
//            /*Boolean orNo=LoraMsgUtil.SendLoraData(loraDevInfoList.get(0).getLoraSN(),"40","");
//            if(orNo==true){//通过发送查询设备命令来辨别网关设备是否正常连接（心跳间隔为一分钟，间隔时间较长）*/
//        //先删除该网关下的所有设备和各个设备下的开关
//        switchDevservice.deleteSwitch(jsonDelSwitch);
//        switchDevservice.delSwitchDev(jsonDelSwitch);
//        //删除空调
//        airDevService.delAirDevByLoraSN(jsonDelSwitch);
//        code = loraDevService.delLoraDev(id);
    }
    //删除人脸门禁设备
    public void delHKDev(int devId,String devStatus)throws UnsupportedEncodingException, ParseException {
        List<HKPermisson> hkPermissonList = hkPermissionService.getPermissionByDevId(devId);
        System.out.println("相关权限信息"+hkPermissonList);
        if(devStatus.equals("1")){//1--在线，0--离线
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
                    System.out.println("删除人员权限成功");
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
        System.out.println("删除人脸设备成功");
    }
    //递归删除子节点-- 删除区域
    private List<EasyTree> delChildrenTree(EasyTree easyTree){
        organizeService.delOrganize(easyTree.getId());
        System.out.println("删除节点成功");
        List<EasyTree> list = organizeService.queryChildenOrganize(easyTree.getId(),null);
        for(EasyTree temp : list){
            delChildrenTree(temp);
        }
        return list;
    }

    @RequestMapping("addTree")
    @ResponseBody
    public int addTree(EasyTree easyTree){
        //System.out.println("添加节点");
        System.out.println(easyTree.toString());
        return  organizeService.insertOrganize(easyTree);
    }

    @RequestMapping("modifyTree")
    @ResponseBody
    public int modifyTree(EasyTree easyTree){
        return  organizeService.updateOrganize(easyTree);
    }

    @RequestMapping("getSchool")
    @ResponseBody
    public List<EasyTree> getSchool(){
        return organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
    }

    @RequestMapping("getChildrenOrganize")
    @ResponseBody
    public List<EasyTree> getChildrenOrganize(String id){
        return organizeService.queryChildenOrganize(id,"");
    }

    private String getAllParentOrganize(String id){
        EasyTree easyTree = organizeService.queryParent(id);
        EasyTree thisEasyTree  = organizeService.queryCurrId(id);
        String str = thisEasyTree.getText()+","+easyTree.getText()+",";
        while (!easyTree.getPId().equals("0")){
            easyTree = organizeService.queryParent(easyTree.getId());
            str += easyTree.getText()+",";
        }
        return str.substring(0,str.length()-1);
    }


}
