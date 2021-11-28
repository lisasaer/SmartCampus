package com.zy.SmartCampus.service;

import com.alibaba.fastjson.JSONObject;
import com.sun.jna.NativeLong;
import com.zy.SmartCampus.hik.HkSetting;
import com.zy.SmartCampus.mapper.DeviceMapper;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.util.MyUtil;
import com.zy.SmartCampus.util.PageUtill;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DeviceService {
    @Autowired
    private DeviceMapper deviceMapper;
    @Autowired
    private StaffService staffService;
    @Autowired
    private DeviceService deviceService;
    @Autowired
    private HkService hkService;
    @Autowired
    private HKPermissionService hkPermissionService;
    @Autowired
    private OrganizeService organizeService;
    @Autowired
    private HkSetting hkSetting;
    public PageBean<Device> selectDeviceAll(String page, String limit) {
        PageBean<Device> pageBean = new PageBean();
        pageBean.setLists(deviceMapper.selectDeviceAll(PageUtill.PageMap(page, limit, null)));
        for(int i =0;i<pageBean.getLists().size();i++){
            if(pageBean.getLists().get(i).getDevStatus().equals("0")){
                pageBean.getLists().get(i).setDevStatus("离线");
            }else if(pageBean.getLists().get(i).getDevStatus().equals("1")){
                pageBean.getLists().get(i).setDevStatus("在线");
            }
            if(pageBean.getLists().get(i).getSchoolId()!=null&&!pageBean.getLists().get(i).getSchoolId().equals("0")){
                if(!pageBean.getLists().get(i).getSchoolId().equals("")){
                    EasyTree schoolName = organizeService.queryCurrId(pageBean.getLists().get(i).getSchoolId());
                    pageBean.getLists().get(i).setSchoolName(schoolName.getText());
                }else{
                    pageBean.getLists().get(i).setSchoolName("");
                }
            }
            if(pageBean.getLists().get(i).getHouseId()!=null&&!pageBean.getLists().get(i).getHouseId().equals("0")){
                if(!pageBean.getLists().get(i).getHouseId().equals("")){
                    EasyTree houseName = organizeService.queryCurrId(pageBean.getLists().get(i).getHouseId());
                    pageBean.getLists().get(i).setHouseName(houseName.getText());
                }else{
                    pageBean.getLists().get(i).setHouseName("");
                }
            }
            if(pageBean.getLists().get(i).getFloorId()!=null&&!pageBean.getLists().get(i).getFloorId().equals("0")){
                if(!pageBean.getLists().get(i).getFloorId().equals("")){
                    EasyTree floorName = organizeService.queryCurrId(pageBean.getLists().get(i).getFloorId());
                    pageBean.getLists().get(i).setFloorName(floorName.getText());
                }else{
                    pageBean.getLists().get(i).setFloorName("");
                }
            }
            if(pageBean.getLists().get(i).getRoomId()!=null&&!pageBean.getLists().get(i).getRoomId().equals("0")){
                if(!pageBean.getLists().get(i).getRoomId().equals("")){
                    EasyTree roomName = organizeService.queryCurrId(pageBean.getLists().get(i).getRoomId());
                    pageBean.getLists().get(i).setRoomName(roomName.getText());
                }else{
                    pageBean.getLists().get(i).setRoomName("");
                }
            }

            String encryptedPassword = "";
            String password =  pageBean.getLists().get(i).getDpassWord();
            for(int j = 0 ;j<password.length();j++){
                encryptedPassword=encryptedPassword.concat("*");
            }
            pageBean.getLists().get(i).setEncryptedPassword(encryptedPassword);

        }
        pageBean.setTotalCount(deviceMapper.selectCount());
        return pageBean;
    }

    public void addDevice(Device device) {
        deviceMapper.addDevice(device);
    }

    public void delDevice(Integer id) {
        deviceMapper.delDevice(id);
    }

    //同时删除多个设备
//    public void delSomeDevice(List<Device> devices) throws UnsupportedEncodingException, ParseException {
//        for (Device device : devices) {
//            //deviceMapper.delDevice(device.getDeviceId());
//            int devId = device.getDeviceId();
//            List<HKPermisson> hkPermissonList = hkPermissionService.getPermissionByDevId(devId);
//            if(hkPermissonList.size()>0){
//                for(HKPermisson hkPermisson:hkPermissonList){
//                    MyUtil.printfInfo(hkPermisson.toString());
//                    JSONObject json = new JSONObject();
//                    String cardNo = hkPermisson.getCardNo();
//                    json.put("cardNo",cardNo);
//                    List<StaffDetail> staffDetailList = staffService.queryStaff(json);
//                    MyUtil.printfInfo(staffDetailList.toString());
//                    LoginDevInfo loginDevInfo = hkSetting.getLoginDevInfoByDevID(deviceService.getDevIPByID(String.valueOf(devId)));//hkPermisson.getDevId():设备ID
//                    FaceCardInfo faceCardInfo = new FaceCardInfo(loginDevInfo.getLUserID(),staffDetailList.get(0).getCardNo(),      //staffDetailList.get(0).getCardNo()卡号
//                            "2019-01-01 00:00:00","2030-01-01 00:00:00","888888",
//                            Integer.valueOf(staffDetailList.get(0).getStaffId()),staffDetailList.get(0).getName(),MyUtil.getWEBINFPath()+staffDetailList.get(0).getPhoto(),"DEL");   //工号    持卡人姓名   图片地址    类型：DEL--删除设备人员信息
//                    //重新下发卡权限  --删除设备中的人员信息
//                    hkService.setCardAndFaceInfo(faceCardInfo);
//                    //删除人员权限表对应的信息
//                    hkPermissionService.deletePermission(cardNo);
//                }
//            }
//            //删除的设备撤销布防
//            for(int i=0;i<hkSetting.list.size();i++){
//                if(hkSetting.list.get(i).getDeviceId()==devId){
//                    NativeLong lAlarmHandle = hkSetting.list.get(i).getLAlarmHandleData();
//                    hkSetting.closeAlarmChan(lAlarmHandle);
//                }
//            }
//            //删除设备信息表对应的信息
//            deviceService.delDevice(devId);
//        }
//    }

    public List<manageDeviceBean> selectDeviceByDepartmentIdCard(int departmentId) {
        return deviceMapper.selectDeviceByDepartmentIdCard(departmentId);
    }

    //ID查找设备IP
    public String getDevIPByID(String id){
        return deviceMapper.getDevIPByID(id);
    }

    //ID查找微耕设备IP
    public String getWgDevIPByID(String id){
        return deviceMapper.getWgDevIPByID(id);
    }

    //IP查找ID
    public String getDevIDByIP(String ip){
        return deviceMapper.getDevIDByIP(ip);
    }
    //更新设备
    public void updateDevice(Device device){
        deviceMapper.updateDevice(device);
    }
    public List<Device> queryConditionDev(Map<String, Object> map){
        return deviceMapper.queryConditionDev(map);
    }


    //条件查询
    public PageBean<Device> queryConditionDev(String page, String limit,Map<String,Object> map) {
        PageBean<Device> pageBean = new PageBean();

        int offset = (Integer.valueOf(page)-1)* Integer.valueOf(limit);
        map.put("offset",offset);
        map.put("limit", Integer.valueOf(limit));
        List<Device> deviceList = deviceMapper.queryConditionDev(map);

        for(int i = 0;i<deviceList.size();i++){
            if(deviceList.get(i).getDevStatus().equals("0")){
                deviceList.get(i).setDevStatus("离线");
            }else if(deviceList.get(i).getDevStatus().equals("1")){
                deviceList.get(i).setDevStatus("在线");
            }
            if(deviceList.get(i).getSchoolId()!=null&&!deviceList.get(i).getSchoolId().equals("0")){
                if(!deviceList.get(i).getSchoolId().equals("")){
                    EasyTree schoolName = organizeService.queryCurrId(deviceList.get(i).getSchoolId());
                    deviceList.get(i).setSchoolName(schoolName.getText());
                }else{
                    deviceList.get(i).setSchoolName("");
                }
            }
            if(deviceList.get(i).getHouseId()!=null&&!deviceList.get(i).getHouseId().equals("0")){
                if(!deviceList.get(i).getHouseId().equals("")){
                    EasyTree houseName = organizeService.queryCurrId(deviceList.get(i).getHouseId());
                    deviceList.get(i).setHouseName(houseName.getText());
                }else{
                    deviceList.get(i).setHouseName("");
                }
            }
            if(deviceList.get(i).getFloorId()!=null&&!deviceList.get(i).getFloorId().equals("0")){
                if(!deviceList.get(i).getFloorId().equals("")){
                    EasyTree floorName = organizeService.queryCurrId(deviceList.get(i).getFloorId());
                    deviceList.get(i).setFloorName(floorName.getText());
                }else{
                    deviceList.get(i).setFloorName("");
                }
            }
            if(deviceList.get(i).getRoomId()!=null&&!deviceList.get(i).getRoomId().equals("0")){
                if(!deviceList.get(i).getRoomId().equals("")){
                    EasyTree roomName = organizeService.queryCurrId(deviceList.get(i).getRoomId());
                    deviceList.get(i).setRoomName(roomName.getText());
                }else{
                    deviceList.get(i).setRoomName("");
                }
            }
            String encryptedPassword = "";
            String password =  deviceList.get(i).getDpassWord();
            for(int j = 0 ;j<password.length();j++){
                encryptedPassword=encryptedPassword.concat("*");
            }
            deviceList.get(i).setEncryptedPassword(encryptedPassword);
        }
        pageBean.setLists(deviceList);
        pageBean.setTotalCount(deviceList.size());
        return pageBean;
    }

    //根据部门ID查询人员信息
    public List<Device> queryDevByDepartmentId(int departmentId){
        return deviceMapper.queryDevByDepartmentId(departmentId);
    }

    public void updateDevOnLine(Device device){
        deviceMapper.updateDevOnLine(device);
    }
    public void updateDevOffLine(){
        deviceMapper.updateDevOffLine();
    }

    public List<Device> queryNewDev(){
        return deviceMapper.queryNewDev();
    }
    public List<Device> queryHKDevByArea(JSONObject json){return deviceMapper.queryHKDevByArea(json);}

    public List<Device> queryByDevIP(String dip){return deviceMapper.queryByDevIP(dip);}
}
