package com.zy.SmartCampus.service;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.hik.HkSetting;
import com.zy.SmartCampus.mapper.StaffMapper;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.util.MyUtil;
import com.zy.SmartCampus.util.PageUtill;
import com.zy.SmartCampus.util.WGAccessUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;

@Service
public class StaffService {
    @Autowired
    private StaffMapper staffMapper;
    @Autowired
    private StaffService staffService;

    @Autowired
    private HKPermissionService hkPermissionService;
    @Autowired
    private WgPermissionService wgPermissionService;
    @Autowired
    private DeviceService deviceService;
    @Autowired
    private OrganizeService organizeService;
    @Autowired
    private HkSetting hkSetting;
    @Autowired
    private HkService hkService;

    public List<StaffDetail> selectStaffDetail(String id) {
        return staffMapper.selectStaffDetail(id);
    }
    public PageBean<StaffDetail> selectStaffDetailAll(String page, String limit) {
        //创建分页对象
        PageBean<StaffDetail> pageBean = new PageBean();
        HashMap<String, Object> map = PageUtill.PageMap(page, limit, null);
        pageBean.setLists(staffMapper.selectStaffDetailAll(map));

        for(int i =0;i<pageBean.getLists().size();i++){
            if(pageBean.getLists().get(i).getSchoolId()!=null){
                if(!pageBean.getLists().get(i).getSchoolId().equals("")){
                    EasyTree schoolName = organizeService.queryCurrId(pageBean.getLists().get(i).getSchoolId());
                    pageBean.getLists().get(i).setSchoolName(schoolName.getText());
                }else{
                    pageBean.getLists().get(i).setSchoolName("无");
                }
            }
            if(pageBean.getLists().get(i).getHouseId()!=null){
                if(!pageBean.getLists().get(i).getHouseId().equals("")){
                    EasyTree houseName = organizeService.queryCurrId(pageBean.getLists().get(i).getHouseId());
                    pageBean.getLists().get(i).setHouseName(houseName.getText());
                }else{
                    pageBean.getLists().get(i).setHouseName("无");
                }
            }
            if(pageBean.getLists().get(i).getFloorId()!=null){
                if(!pageBean.getLists().get(i).getFloorId().equals("")){
                    EasyTree floorName = organizeService.queryCurrId(pageBean.getLists().get(i).getFloorId());
                    pageBean.getLists().get(i).setFloorName(floorName.getText());
                }else{
                    pageBean.getLists().get(i).setFloorName("无");
                }
            }
            if(pageBean.getLists().get(i).getRoomId()!=null){
                if(!pageBean.getLists().get(i).getRoomId().equals("")){
                    EasyTree roomName = organizeService.queryCurrId(pageBean.getLists().get(i).getRoomId());
                    pageBean.getLists().get(i).setRoomName(roomName.getText());
                }else{
                    pageBean.getLists().get(i).setRoomName("无");
                }
            }
            if(pageBean.getLists().get(i).getPersonType()!=null){
                if(pageBean.getLists().get(i).getPersonType().equals("student")){
                    pageBean.getLists().get(i).setPersonTypeName("学生");
                }else if(pageBean.getLists().get(i).getPersonType().equals("teacher")){
                    pageBean.getLists().get(i).setPersonTypeName("教师");
                }else if(pageBean.getLists().get(i).getPersonType().equals("other")){
                    pageBean.getLists().get(i).setPersonTypeName("其他");
                }
            }
        }
        pageBean.setTotalCount(staffMapper.selectCount(null));
        return pageBean;
    }
    public PageBean<HistoryFaceAlarm> selectRecordAll(String page, String limit) {
        //创建分页对象
        PageBean<HistoryFaceAlarm> pageBean = new PageBean();
        HashMap<String, Object> map = PageUtill.PageMap(page, limit, null);
        pageBean.setLists(staffMapper.selectRecordAll(map));
        pageBean.setTotalCount(staffMapper.queryRecordCount(null));
        return pageBean;
    }

    public List<Staff> queryRecordDetail(int id){return staffMapper.queryRecordDetail(id);}
    public List<Staff> queryRecordHistoryDetail(int id){return staffMapper.queryRecordHistoryDetail(id);}

    public int addStaff(Staff staff) {
        return staffMapper.addStaff(staff);
    }

    public List<String> selectStaffNameByDepartmentId(int departmentId) {
        return staffMapper.selectStaffNameByDepartmentId(departmentId);
    }

    public List<StatementDetail> getStaffSome(StatementBean statementBean) {
        return staffMapper.getStaffSome(statementBean);
    }

    public List<ManageCardBean> selectStaffNameByDepartmentIdCard(int departmentId) {
        return staffMapper.selectStaffNameByDepartmentIdCard(departmentId);
    }
    //删除员工
    public void deleteByPrimaryKey(String id){
        staffMapper.deleteByPrimaryKey(id);
    }
    public void deleteRecord(Integer id){
        staffMapper.deleteRecord(id);
    }

    //同时删除多名员工
//    public void delSomeStaff(List<Staff> staffs) throws UnsupportedEncodingException, ParseException , InterruptedException{
//        for (Staff staff : staffs) {
//            //staffMapper.deleteByPrimaryKey(staff.getStaffId());
//            String id =staff.getStaffId();
//            List<StaffDetail> staffDetailList= staffService.selectStaffDetail(id);
//            String cardId = staffDetailList.get(0).getCardNo();
//            List<HKPermisson> hkPermissonList = hkPermissionService.getPermissionByCardNo(cardId);
//            //System.out.println(id);
//            if(hkPermissonList.size()>0){
//                for(HKPermisson hkPermisson:hkPermissonList){
//                    LoginDevInfo loginDevInfo = hkSetting.getLoginDevInfoByDevID(deviceService.getDevIPByID(String.valueOf(hkPermisson.getDevId())));//hkPermisson.getDevId():设备ID
//                    FaceCardInfo faceCardInfo = new FaceCardInfo(loginDevInfo.getLUserID(),staffDetailList.get(0).getCardNo(),      //staffDetailList.get(0).getCardNo()卡号
//                            "2019-01-01 00:00:00","2030-01-01 00:00:00","888888",
//                             Integer.valueOf(staffDetailList.get(0).getStaffId()),staffDetailList.get(0).getName(),MyUtil.getWEBINFPath()+staffDetailList.get(0).getPhoto(),"DEL");   //工号    持卡人姓名   图片地址    类型：DEL--删除设备人员信息
//                    //重新下发卡权限  --删除设备人员信息
//                    hkService.setCardAndFaceInfo(faceCardInfo);
//                    //删除人员权限表对应的信息
//                    hkPermissionService.deletePermission(cardId);
//                }
//
//            }
//            //删除该人员微耕权限
//            //System.out.println(cardId);
//            JSONObject jsonObject=new JSONObject();
//            jsonObject.put("cardNo",cardId);
//            List<PermissionInfo> listWGPms=wgPermissionService.getWGPermissionByCardNo(jsonObject);
//            //System.out.println(listWGPms);
//            if(listWGPms.size()!=0){//如果该人员所持卡拥有微耕门禁权限
//                for (int j=0;j<listWGPms.size();j++){
//                    //删除普通门禁权限
//                    //System.out.println(listWGPms.get(j).getWgSNAndDoorID());
//                    WGAccessUtil.sendDelOnePerssion(cardId,listWGPms.get(j).getWgSNAndDoorID());
//                    //System.out.println(listPms.get(j));
//                }
//            }
//            //删除人员信息表对应的信息
//            staffService.deleteByPrimaryKey(id);
//        }
//    }
    public void delSomeRecord( List<HistoryFaceAlarm> historyFaceAlarms) {
        for (HistoryFaceAlarm historyFaceAlarm : historyFaceAlarms) {
            System.out.println("---++"+historyFaceAlarm);
            staffMapper.deleteRecord(historyFaceAlarm.getId());
        }
    }
    //修改员工
    public void updateStaff(Staff staff){
        staffMapper.updateStaff(staff);

    }
    public List<StaffDetail> queryStaff(JSONObject json){
        return staffMapper.queryStaff(json);
    }
    public int queryStaffCount(JSONObject json){
        return staffMapper.queryStaffCount(json);
    }
    //根据条件查询刷卡记录
    public List<HistoryFaceAlarm> queryRecord(JSONObject json){
        return staffMapper.queryRecord(json);
    }
    public List<HistoryFaceAlarm> queryHistoryRecord(JSONObject json){
        return staffMapper.queryHistoryRecord(json);
    }

    //查找刷卡记录条数
    public int queryRecordCount(JSONObject json){
        return staffMapper.queryRecordCount(json);
    }
    public int queryHistoryRecordCount(JSONObject json){
        return staffMapper.queryHistoryRecordCount(json);
    }
    public List<StaffDetail> queryCardNo(String cardNo){
        return staffMapper.queryCardNo(cardNo);
    }
    public List<StaffDetail> queryByStaffId(String staffId){
        return staffMapper.queryByStaffId(staffId);
    }

    public List<StaffDetail> queryStaffName(String name){
        return staffMapper.queryStaffName(name);
    }

    //根据部门ID查询人员信息
    public List<StaffDetail> queryStaffByDepartmentId(int departmentId){
        return staffMapper.queryStaffByDepartmentId(departmentId);
    }

    public List<HistoryFaceAlarm> selectRecord(JSONObject json){
        return staffMapper.selectRecord(json);
    }
    public List<HistoryFaceAlarm> selectPicture(JSONObject json){
        return staffMapper.selectPicture(json);
    }

}
