package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.hik.HkSetting;
import com.zy.SmartCampus.mapper.StaffMapper;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.service.*;
import com.zy.SmartCampus.util.MyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;

@Controller
public class DepartmentController {
    @Autowired
    private DepartmentService departmentService;
    @Autowired
    private StaffService staffService;
    @Autowired
    private DeviceService deviceService;
    @Autowired
    private HKPermissionService hkPermissionService;
    @Autowired
    private HkSetting hkSetting;
    @Autowired
    private HkService hkService;
    @RequestMapping("goDepartment")
    public String goDepartment() {
        return "doorDevHK/department";
    }

    @RequestMapping("selectDepartmentName")
    @ResponseBody
    public List<Department> selectDepartmentName() {
        return departmentService.selectDepartmentName();
    }

    @RequestMapping("selectCascadeDepartmentName")
    @ResponseBody
    public HashMap<Integer, DepartmentTree> selectCascadeDepartmentName() {
        return departmentService.selectCascadeDepartmentName();
    }

    @RequestMapping("DepartmentText")
    @ResponseBody
    public List<DepartmentTree> DepartmentText() {
        return departmentService.getDepartmetTree();
    }

    @RequestMapping("addDepartment")
    @ResponseBody
    public List<DepartmentTree> addDepartment(HttpServletRequest request) {
        Integer parentId = Integer.parseInt(request.getParameter("parentId"));
        String dname = request.getParameter("dname");
        Department department = new Department();
        department.setDname(dname);
        department.setParentId(parentId);
        departmentService.addDepartment(department);
        return departmentService.getDepartmetTree();
    }
    @RequestMapping("editDepartment")
    @ResponseBody
    public List<DepartmentTree> editDepartment(HttpServletRequest request) {
        Integer departmentid = Integer.parseInt(request.getParameter("rootId"));
        String dname = request.getParameter("dname");
        Department department = new Department();
        department.setDname(dname);
        department.setDepartmentid(departmentid);
        System.out.println(department);
        departmentService.editDepartment(department);

        return departmentService.getDepartmetTree();
    }
    @RequestMapping("deleteDepartment")
    @ResponseBody
    public List<DepartmentTree> deleteDepartment(HttpServletRequest request) throws UnsupportedEncodingException, ParseException {
        Integer departmentid = Integer.parseInt(request.getParameter("rootId"));
        Department department = new Department();
        department.setDepartmentid(departmentid);
        System.out.println(department);
        delChildrenTree(department);


//        //????????????ID?????????????????????
//        List<Department> departmentLists = departmentService.queryDepartmentByParentId(departmentId);
//        MyUtil.printfInfo(departmentLists.toString());
//        if(departmentLists.size()>0){
//            for(Department departmentList :departmentLists){
//
//            }
//        }
//        //????????????ID??????????????????
//        List<StaffDetail> staffDetailList = staffService.queryStaffByDepartmentId(departmentId);
//        MyUtil.printfInfo(staffDetailList.toString());
//        //????????????ID??????????????????
//        List<Device> deviceList = deviceService.queryDevByDepartmentId(departmentId);
//        MyUtil.printfInfo(deviceList.toString());

        //departmentService.deleteDepartment(department);//????????????????????????



        return departmentService.getDepartmetTree();
    }

    //?????????????????????
    private List<Department> delChildrenTree(Department department)throws UnsupportedEncodingException, ParseException {
//        organizeService.delOrganize(easyTree.getId());
//        List<EasyTree> list = organizeService.queryChildenOrganize(easyTree.getId(),null);

        int departmentId = department.getDepartmentid();
        //????????????ID??????????????????
        List<StaffDetail> staffDetails = staffService.queryStaffByDepartmentId(departmentId);
        MyUtil.printfInfo(staffDetails.toString());
        if(staffDetails.size()>0){
            for (StaffDetail staff : staffDetails) {
                //staffMapper.deleteByPrimaryKey(staff.getStaffId());
                String id =staff.getStaffId();
                //List<StaffDetail> staffDetailList= staffService.selectStaffDetail(id);
                String cardId = staff.getCardNo();
                List<HKPermisson> hkPermissonList = hkPermissionService.getPermissionByCardNo(cardId);
                System.out.println(id);
                if(hkPermissonList.size()>0){
                    for(HKPermisson hkPermisson:hkPermissonList){
                        LoginDevInfo loginDevInfo = hkSetting.getLoginDevInfoByDevID(deviceService.getDevIPByID(String.valueOf(hkPermisson.getDevId())));//hkPermisson.getDevId():??????ID
                        FaceCardInfo faceCardInfo = new FaceCardInfo(loginDevInfo.getLUserID(),staff.getCardNo(),      //staffDetailList.get(0).getCardNo()??????
                                "2019-01-01 00:00:00","2030-01-01 00:00:00","888888",
                                Integer.valueOf(staff.getStaffId()),staff.getName(),MyUtil.getWEBINFPath()+staff.getPhoto(),"DEL");   //??????    ???????????????   ????????????    ?????????DEL--????????????????????????
                        //?????????????????????  --????????????????????????
                        hkService.setCardAndFaceInfo(faceCardInfo);
                        //????????????????????????????????????
                        hkPermissionService.deletePermission(cardId);
                    }

                }
                //????????????????????????????????????
                staffService.deleteByPrimaryKey(id);
            }
        }
        //????????????ID??????????????????
        List<Device> deviceList = deviceService.queryDevByDepartmentId(departmentId);
        MyUtil.printfInfo(deviceList.toString());
        if(deviceList.size()>0){
            for (Device device : deviceList) {
                //deviceMapper.delDevice(device.getDeviceId());
                int devId = device.getDeviceId();
                List<HKPermisson> hkPermissonList = hkPermissionService.getPermissionByDevId(devId);
                if(hkPermissonList.size()>0){
                    for(HKPermisson hkPermisson:hkPermissonList){
                        MyUtil.printfInfo(hkPermisson.toString());
                        JSONObject json = new JSONObject();
                        String cardNo = hkPermisson.getCardNo();
                        json.put("cardNo",cardNo);
                        List<StaffDetail> staffDetailList = staffService.queryStaff(json);
                        MyUtil.printfInfo(staffDetailList.toString());
                        LoginDevInfo loginDevInfo = hkSetting.getLoginDevInfoByDevID(deviceService.getDevIPByID(String.valueOf(devId)));//hkPermisson.getDevId():??????ID
                        FaceCardInfo faceCardInfo = new FaceCardInfo(loginDevInfo.getLUserID(),staffDetailList.get(0).getCardNo(),      //staffDetailList.get(0).getCardNo()??????
                                "2019-01-01 00:00:00","2030-01-01 00:00:00","888888",
                                Integer.valueOf(staffDetailList.get(0).getStaffId()),staffDetailList.get(0).getName(),MyUtil.getWEBINFPath()+staffDetailList.get(0).getPhoto(),"DEL");   //??????    ???????????????   ????????????    ?????????DEL--????????????????????????
                        //?????????????????????  --????????????????????????
                        hkService.setCardAndFaceInfo(faceCardInfo);
                        //????????????????????????????????????
                        hkPermissionService.deletePermission(cardNo);
                    }
                }
                //????????????????????????????????????
                deviceService.delDevice(devId);
            }
        }

        departmentService.deleteDepartment(department);//????????????????????????

        //????????????ID?????????????????????
        List<Department> departmentLists = departmentService.queryDepartmentByParentId(departmentId);
        if(departmentLists.size()>0){
            for(Department temp : departmentLists){
                delChildrenTree(temp);
            }
        }

        return departmentLists;
    }
}
