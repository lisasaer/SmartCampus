package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.hik.HkSetting;
import com.zy.SmartCampus.mapper.StaffMapper;
import com.zy.SmartCampus.mapper.WGAccessDevMapper;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.service.*;
import com.zy.SmartCampus.util.MyUtil;
import com.zy.SmartCampus.util.WGAccessUtil;
import com.zy.SmartCampus.webSocket.WebSocketUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.UnknownHostException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class StaffController {
    @Autowired
    private StaffService staffService;
    @Autowired
    private DepartmentService departmentService;
    @Autowired
    private PositionService positionService;
    @Autowired
    private CrewService crewService;
    @Autowired
    private StaffMapper staffMapper;

    @Autowired
    private HKPermissionService hkPermissionService;
    @Autowired
    private WgPermissionService wgPermissionService;

    @Autowired
    private DeviceService deviceService;
    @Autowired
    private WGdoorService wGdoorService;

    @Autowired
    private HkSetting hkSetting;
    @Autowired
    private HkService hkService;
    @Autowired
    private OrganizeService organizeService;
    @Autowired
    private WGAccessDevService WGAccessDevService;
    @RequestMapping("selectStaffDetailAll")
    @ResponseBody
    public Layui selectStaffDetailAll(Model model , HttpServletRequest request) {
        //??????????????????
        String page = request.getParameter("page");
        String limit = request.getParameter("limit");
        PageBean<StaffDetail> pageBean = staffService.selectStaffDetailAll(page, limit);
        return Layui.data(pageBean.getTotalCount(), pageBean.getLists());
    }
    @RequestMapping("selectRecordAll")
    @ResponseBody
    public Layui selectRecordAll(Model model, HttpServletRequest request) {
        //??????????????????
        String page = request.getParameter("page");
        String limit = request.getParameter("limit");
        PageBean<HistoryFaceAlarm> pageBean = staffService.selectRecordAll(page, limit);
        MyUtil.printfInfo("=========:"+pageBean.getLists());
        return Layui.data(pageBean.getTotalCount(), pageBean.getLists());
    }
    @RequestMapping("selectStaffNameByDepartmentId")
    @ResponseBody
    public List<String> selectStaffNameByDepartmentId(int departmentId) {
        return staffService.selectStaffNameByDepartmentId(departmentId);
    }

    private static List<ManageCardBean> manageCardBeans = new ArrayList<>();

    @RequestMapping("selectStaffNameByDepartmentIdCard")
    @ResponseBody
    public List<ManageCardBean> selectStaffNameByDepartmentIdCard(int departmentId) {
        manageCardBeans.clear();
        Department department = new Department();
        department.setDepartmentid(departmentId);
        List<ManageCardBean> staff =  selectStaff(department);
        return staff;
    }

    private List<ManageCardBean> selectStaff(Department department){
        int departmentId = department.getDepartmentid();
        List<Department> departments = departmentService.queryDepartmentByParentId(departmentId);
        List<ManageCardBean> manageCardBeanList =  staffService.selectStaffNameByDepartmentIdCard(departmentId);
        manageCardBeans.addAll(manageCardBeanList);
        for(Department child : departments){
            selectStaff(child);
        }
        return manageCardBeans;
    }


    @RequestMapping("goStaff")
    public ModelAndView goStaff() {
        ModelAndView modelAndView = new ModelAndView("doorDevHK/staff");
        List<EasyTree> list = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        modelAndView.addObject("schoolList",list);
        return modelAndView;
    }

    @RequestMapping("addStaffView")
    public ModelAndView addStaffView() {
        System.out.println("???????????????");
        ModelAndView modelAndView = new ModelAndView("doorDevHK/addStaff");
        List<Crew> cdes = crewService.selectCrewAll();
        List<Position> positionList = positionService.selectPositionId();
        List<EasyTree> list = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        modelAndView.addObject("schoolList",list);
        modelAndView.addObject("crew", cdes);
        modelAndView.addObject("positionList",positionList);
        return modelAndView;
    }

    //????????????
    @RequestMapping("editStaffView")
    public ModelAndView editStaffView(String staffId) {
        ModelAndView modelAndView = new ModelAndView("doorDevHK/editStaff");
        List<StaffDetail> staffDetailList= staffService.selectStaffDetail(staffId);
        for(int i =0;i<staffDetailList.size();i++){
            if(staffDetailList.get(i).getSchoolId()!=null){
                if(!staffDetailList.get(i).getSchoolId().equals("")){
                    EasyTree schoolName = organizeService.queryCurrId(staffDetailList.get(i).getSchoolId());
                    staffDetailList.get(i).setSchoolName(schoolName.getText());
                }else{
                    staffDetailList.get(i).setSchoolName("???");
                }
            }
            if(staffDetailList.get(i).getHouseId()!=null){
                if(!staffDetailList.get(i).getHouseId().equals("")){
                    EasyTree houseName = organizeService.queryCurrId(staffDetailList.get(i).getHouseId());
                    staffDetailList.get(i).setHouseName(houseName.getText());
                }else{
                    staffDetailList.get(i).setHouseName("???");
                }
            }
            if(staffDetailList.get(i).getFloorId()!=null){
                if(!staffDetailList.get(i).getFloorId().equals("")){
                    EasyTree floorName = organizeService.queryCurrId(staffDetailList.get(i).getFloorId());
                    staffDetailList.get(i).setFloorName(floorName.getText());
                }else{
                    staffDetailList.get(i).setFloorName("???");
                }
            }
            if(staffDetailList.get(i).getRoomId()!=null){
                if(!staffDetailList.get(i).getRoomId().equals("")){
                    EasyTree roomName = organizeService.queryCurrId(staffDetailList.get(i).getRoomId());
                    staffDetailList.get(i).setRoomName(roomName.getText());
                }else{
                    staffDetailList.get(i).setRoomName("???");
                }
            }
            if(staffDetailList.get(i).getPersonType()!=null){
                if(staffDetailList.get(i).getPersonType().equals("student")){
                    staffDetailList.get(i).setPersonTypeName("??????");
                }else if(staffDetailList.get(i).getPersonType().equals("teacher")){
                    staffDetailList.get(i).setPersonTypeName("??????");
                }else if(staffDetailList.get(i).getPersonType().equals("other")){
                    staffDetailList.get(i).setPersonTypeName("??????");
                }
            }
        }
        MyUtil.printfInfo(staffDetailList.toString());
        modelAndView.addObject("staffDetailList", staffDetailList);
        EasyTree easyTree = new EasyTree();
        easyTree.setId("");
        easyTree.setText("???");

        List<EasyTree> schoolList = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        schoolList.add(0,easyTree);
        modelAndView.addObject("schoolList",schoolList);

        String schoolId = staffDetailList.get(0).getSchoolId();
        String houseId = staffDetailList.get(0).getHouseId();
        String floorId = staffDetailList.get(0).getFloorId();
        List<EasyTree> houseList = new ArrayList<>();
        List<EasyTree> floorList = new ArrayList<>();
        List<EasyTree> roomList = new ArrayList<>();
        if(!schoolId.equals("0")){
            houseList = organizeService.queryChildenOrganize(schoolId,"");
        }
        if(!houseId.equals("0")){
            floorList = organizeService.queryChildenOrganize(houseId,"");
        }
        if(!floorId.equals("0")){
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

    @RequestMapping("addStaff")
    @ResponseBody
    public JSONObject addStaff(@RequestBody Staff staff) {
        MyUtil.printfInfo(staff.toString());
        System.out.println("staff:"+staff);
        JSONObject json = new JSONObject();
        List<StaffDetail> listStaffCount = staffService.queryStaff(json);
        MyUtil.printfInfo(staff.toString());
        Date date = new Date();
        String createdTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(date);
        staff.setCreatedTime(createdTime);
        int code = staffService.addStaff(staff);
        //return "doorDevHK/staff";
        JSONObject jsonReturn = new JSONObject();
        jsonReturn.put("code",code);
        jsonReturn.put("msg",(code>0)?"????????????":"????????????");

        return jsonReturn;
    }

    //????????????
    @RequestMapping("updateStaff")
    @ResponseBody
    public String updateStaff(@RequestBody Staff staff){
        System.out.println("This is updateStaff part !");
        staffService.updateStaff(staff);
        return "staff";
    }
    @RequestMapping("recordView")
    public ModelAndView recordView(Model model, int id)throws InterruptedException {
        ModelAndView modelAndView = new ModelAndView("doorDevHK/recordStaffView");
        List<Staff> list = staffService.queryRecordDetail(id);

        for(int i = 0;i<list.size();i++){
            if(list.get(i).getSchoolId()!=null){
                if(!list.get(i).getSchoolId().equals("0")){
                    EasyTree schoolName = organizeService.queryCurrId(list.get(i).getSchoolId());
                    list.get(i).setSchoolName(schoolName.getText());
                }else{
                    list.get(i).setSchoolName("???");
                }
            }
            if(list.get(i).getHouseId()!=null){
                if(!list.get(i).getHouseId().equals("0")){
                    EasyTree houseName = organizeService.queryCurrId(list.get(i).getHouseId());
                    list.get(i).setHouseName(houseName.getText());
                }else{
                    list.get(i).setHouseName("???");
                }
            }
            if(list.get(i).getFloorId()!=null){
                if(!list.get(i).getFloorId().equals("0")){
                    EasyTree floorName = organizeService.queryCurrId(list.get(i).getFloorId());
                    list.get(i).setFloorName(floorName.getText());
                }else{
                    list.get(i).setFloorName("???");
                }
            }
            if(list.get(i).getRoomId()!=null){
                if(!list.get(i).getRoomId().equals("0")){
                    EasyTree roomName = organizeService.queryCurrId(list.get(i).getRoomId());
                    list.get(i).setRoomName(roomName.getText());
                }else{
                    list.get(i).setRoomName("???");
                }
            }
            if(list.get(i).getPersonType()!=null){
                if(list.get(i).getPersonType().equals("student")){
                    list.get(i).setPersonTypeName("??????");
                }else if(list.get(i).getPersonType().equals("teacher")){
                    list.get(i).setPersonTypeName("??????");
                }else if(list.get(i).getPersonType().equals("other")){
                    list.get(i).setPersonTypeName("??????");
                }
            }
        }
        MyUtil.printfInfo(list.toString());
        modelAndView.addObject("list",list);
        return modelAndView;
    }

    @RequestMapping("recordHistoryView")
    public ModelAndView recordHistoryView(Model model, int id)throws InterruptedException {
        ModelAndView modelAndView = new ModelAndView("doorDevHK/recordStaffView");
        List<Staff> list = staffService.queryRecordHistoryDetail(id);
        for(int i = 0;i<list.size();i++){
            if(list.get(i).getSchoolId()!=null){
                if(!list.get(i).getSchoolId().equals("0")){
                    EasyTree schoolName = organizeService.queryCurrId(list.get(i).getSchoolId());
                    list.get(i).setSchoolName(schoolName.getText());
                }else{
                    list.get(i).setSchoolName("???");
                }
            }
            if(list.get(i).getHouseId()!=null){
                if(!list.get(i).getHouseId().equals("0")){
                    EasyTree houseName = organizeService.queryCurrId(list.get(i).getHouseId());
                    list.get(i).setHouseName(houseName.getText());
                }else{
                    list.get(i).setHouseName("???");
                }
            }
            if(list.get(i).getFloorId()!=null){
                if(!list.get(i).getFloorId().equals("0")){
                    EasyTree floorName = organizeService.queryCurrId(list.get(i).getFloorId());
                    list.get(i).setFloorName(floorName.getText());
                }else{
                    list.get(i).setFloorName("???");
                }
            }
            if(list.get(i).getRoomId()!=null){
                if(!list.get(i).getRoomId().equals("0")){
                    EasyTree roomName = organizeService.queryCurrId(list.get(i).getRoomId());
                    list.get(i).setRoomName(roomName.getText());
                }else{
                    list.get(i).setRoomName("???");
                }
            }
            if(list.get(i).getPersonType()!=null){
                if(list.get(i).getPersonType().equals("student")){
                    list.get(i).setPersonTypeName("??????");
                }else if(list.get(i).getPersonType().equals("teacher")){
                    list.get(i).setPersonTypeName("??????");
                }else if(list.get(i).getPersonType().equals("other")){
                    list.get(i).setPersonTypeName("??????");
                }
            }
        }
        MyUtil.printfInfo(list.toString());
        modelAndView.addObject("list",list);
        return modelAndView;
    }

    //????????????
    @RequestMapping("showStaffView")
    public String showStaffView(){return "doorDevHK/showStaff";}
    //??????????????????
    @RequestMapping("go_on_job")
    public String go_on_job(){ return "onjob";}

    //??????????????????
    @RequestMapping("go_out_job")
    public String go_out_job() { return "outjob";}

    @RequestMapping("/upload")
    @ResponseBody
    public JSONObject upload(@RequestParam("file") MultipartFile multipartFile) {

        JSONObject resObj = new JSONObject();
        resObj.put("msg", "error");
        if (!StringUtils.isEmpty(multipartFile) && multipartFile.getSize() > 0) {
            String filename = multipartFile.getOriginalFilename();
            if (filename.endsWith("jpg") || filename.endsWith("png")) {
                String uuid = UUID.randomUUID().toString().replace("-", "").toLowerCase();
                String realPath = MyUtil.getWEBINFPath()+"fileDir/upload/" + uuid + ".jpg";
                String photoPath = "fileDir/upload/" + uuid + ".jpg";
                File newfile = new File(realPath);

                if(!newfile.getParentFile().exists()){
                    newfile.mkdirs();
                }
                resObj.put("msg", "ok");
                HashMap<String, String> src = new HashMap();
                src.put("src", photoPath);
                resObj.put("data", src);
                try {
                    multipartFile.transferTo(newfile);
                } catch (IOException e) {
                    resObj.put("msg", "error");
                    e.printStackTrace();
                }
                System.out.println(photoPath);
                return resObj;
            }
        }
        return resObj;
    }
    @RequestMapping("/delStaff")
    @ResponseBody
    public String deleteByPrimaryKey(StaffDetail staffDetail) throws UnknownHostException,UnsupportedEncodingException, ParseException, InterruptedException{
        //String id = request.getParameter("id");
        System.out.println("????????????staff"+staffDetail);
        String id = String.valueOf(staffDetail.getStaffId());
        List<StaffDetail> staffDetailList= staffService.selectStaffDetail(id);
        String cardId = staffDetailList.get(0).getCardNo();
        List<HKPermisson> hkPermissonList = hkPermissionService.getPermissionByCardNo(cardId);

        if(hkPermissonList.size()>0){
            for(HKPermisson hkPermisson:hkPermissonList){
                String HKDevId = hkPermisson.getDevId();
                Map<String, Object> map = new HashMap<>();
                map.put("deviceId",HKDevId);
                List<Device> HKDevList = deviceService.queryConditionDev(map);
                System.out.println("??????????????????????????????"+HKDevList);
                String HKDevStatus = HKDevList.get(0).getDevStatus();
                //??????????????????????????????????????????????????????
                if(HKDevStatus.equals("1")){
                    LoginDevInfo loginDevInfo = hkSetting.getLoginDevInfoByDevID(deviceService.getDevIPByID(String.valueOf(hkPermisson.getDevId())));//hkPermisson.getDevId():??????ID
                    FaceCardInfo faceCardInfo = new FaceCardInfo(loginDevInfo.getLUserID(),staffDetailList.get(0).getCardNo(),      //staffDetailList.get(0).getCardNo()??????
                            "2019-01-01 00:00:00","2030-01-01 00:00:00","888888",
                            Integer.valueOf(staffDetailList.get(0).getStaffId()),staffDetailList.get(0).getName(),MyUtil.getWEBINFPath()+staffDetailList.get(0).getPhoto(),"DEL");   //??????    ???????????????   ????????????    ?????????DEL--????????????????????????
                    //?????????????????????  --????????????????????????
                    hkService.setCardAndFaceInfo(faceCardInfo);
                    //????????????????????????????????????
                    hkPermissionService.deletePermission(cardId);
                }
            }
        }
        JSONObject jsonObject=new JSONObject();
        jsonObject.put("cardNo",cardId);
        List<PermissionInfo> listWGPms=wgPermissionService.getWGPermissionByCardNo(jsonObject);
        if(listWGPms.size()!=0){//????????????????????????????????????
            for (int j=0;j<listWGPms.size();j++){
                String WGDevSN = listWGPms.get(j).getWgSNAndDoorID().substring(0,9);
                System.out.println("??????????????????????????????"+WGDevSN);
                JSONObject json = new JSONObject();
                json.put("ctrlerSN",WGDevSN);
                List<WGAccessDevInfo> WGDevList = WGAccessDevService.queryWGAccessDevInfoByJSON(json);
                System.out.println("????????????????????????????????????"+WGDevList);
                String WGDevStatus = WGDevList.get(0).getStatus();
                if(WGDevStatus.equals("??????")){
                    System.out.println("kk3");
                    //????????????????????????
                    WGAccessUtil.sendDelOnePerssion(cardId,listWGPms.get(j).getWgSNAndDoorID());
                    //System.out.println(listPms.get(j));
                }
            }
        }

        //????????????????????????????????????
        staffService.deleteByPrimaryKey(id);
        return "success";
    }
    //??????????????????
    @RequestMapping("/deleteRecord")
    @ResponseBody
    public String deleteRecord(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        staffService.deleteRecord(id);
        return "success";
    }
    //??????????????????
    @RequestMapping("delSomeStaff")
    @ResponseBody
    public String delSomeStaff(@RequestBody List<Staff> staffs) throws UnsupportedEncodingException, ParseException, InterruptedException{
        for (Staff staff : staffs) {
            //staffMapper.deleteByPrimaryKey(staff.getStaffId());
            String id =staff.getStaffId();
            List<StaffDetail> staffDetailList= staffService.selectStaffDetail(id);
            String cardId = staffDetailList.get(0).getCardNo();
            List<HKPermisson> hkPermissonList = hkPermissionService.getPermissionByCardNo(cardId);
            //System.out.println(id);
            if(hkPermissonList.size()>0){
                for(HKPermisson hkPermisson:hkPermissonList){
                    LoginDevInfo loginDevInfo = hkSetting.getLoginDevInfoByDevID(deviceService.getDevIPByID(String.valueOf(hkPermisson.getDevId())));//hkPermisson.getDevId():??????ID
                    FaceCardInfo faceCardInfo = new FaceCardInfo(loginDevInfo.getLUserID(),staffDetailList.get(0).getCardNo(),      //staffDetailList.get(0).getCardNo()??????
                            "2019-01-01 00:00:00","2030-01-01 00:00:00","888888",
                            Integer.valueOf(staffDetailList.get(0).getStaffId()),staffDetailList.get(0).getName(),MyUtil.getWEBINFPath()+staffDetailList.get(0).getPhoto(),"DEL");   //??????    ???????????????   ????????????    ?????????DEL--????????????????????????
                    //?????????????????????  --????????????????????????
                    hkService.setCardAndFaceInfo(faceCardInfo);
                    //????????????????????????????????????
                    hkPermissionService.deletePermission(cardId);
                }

            }
            //???????????????????????????
            //System.out.println(cardId);
            JSONObject jsonObject=new JSONObject();
            jsonObject.put("cardNo",cardId);
            List<PermissionInfo> listWGPms=wgPermissionService.getWGPermissionByCardNo(jsonObject);
            //System.out.println(listWGPms);
            if(listWGPms.size()!=0){//????????????????????????????????????????????????
                for (int j=0;j<listWGPms.size();j++){
                    //????????????????????????
                    //System.out.println(listWGPms.get(j).getWgSNAndDoorID());
                    WGAccessUtil.sendDelOnePerssion(cardId,listWGPms.get(j).getWgSNAndDoorID());
                    //System.out.println(listPms.get(j));
                }
            }
            //????????????????????????????????????
            staffService.deleteByPrimaryKey(id);
        }
        //staffService.delSomeStaff(staffs);
        return "success";
    }

    //????????????????????????
    @RequestMapping("delSomeRecord")
    @ResponseBody
    public String delSomeRecord(@RequestBody List<HistoryFaceAlarm> historyFaceAlarms) {
        staffService.delSomeRecord(historyFaceAlarms);
        return "success";
    }
    //??????????????????????????????
    @RequestMapping("recordInfo")
    public String getRecordInfo(Model model) {
        List<HistoryFaceAlarm> listNewTenRecord = queryLatestSixRecords();
        model.addAttribute("listNewTenRecord",listNewTenRecord);
        List<EasyTree> schoolList = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        model.addAttribute("schoolList",schoolList);
        return "doorDevHK/recordInfo";
    }

    /**
     * ?????????????????????????????????????????????????????????????????????
     * @return
     */
    @RequestMapping("getLatestSixRecords")
    @ResponseBody
    public List<HistoryFaceAlarm> getLatestSixRecords(){
        List<HistoryFaceAlarm> listNewTenRecord = queryLatestSixRecords();
        return listNewTenRecord;
    }
    /**
     * ??????????????????????????????????????????
     * @return
     */
    public List<HistoryFaceAlarm> queryLatestSixRecords(){
        long current= System.currentTimeMillis();    //?????????????????????
        long zeroT=current/(1000*3600*24)*(1000*3600*24)- TimeZone.getDefault().getRawOffset();  //????????????????????????????????????
        String startTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(zeroT);//	2018-07-23 00:00:00
        long endT=zeroT+24*60*60*1000-1;  //??????23???59???59???????????????
        String endTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(endT);//	2018-07-23 23:59:59
        //??????????????????6???????????????
        JSONObject jsonNewTenRecord = new JSONObject();
        jsonNewTenRecord.put("startTime",startTime);
        jsonNewTenRecord.put("endTime",endTime);
        jsonNewTenRecord.put("offset","0");
        jsonNewTenRecord.put("limit","6");
        System.out.println(jsonNewTenRecord);
        List<HistoryFaceAlarm> listNewTenRecord = staffService.queryRecord(jsonNewTenRecord);
//        for(int i = 0;i<listNewTenRecord.size();i++){
//            MyUtil.printfInfo(i+1 + ": " +listNewTenRecord.get(i).toString());
//            if(listNewTenRecord.get(i).getSchoolId()!=null){
//                if(!listNewTenRecord.get(i).getSchoolId().equals("0")){
//                    EasyTree schoolName = organizeService.queryCurrId(listNewTenRecord.get(i).getSchoolId());
//                    listNewTenRecord.get(i).setSchoolName(schoolName.getText());
//                }else{
//                    listNewTenRecord.get(i).setSchoolName("???");
//                }
//            }
//            if(listNewTenRecord.get(i).getHouseId()!=null){
//                if(!listNewTenRecord.get(i).getHouseId().equals("0")){
//                    EasyTree houseName = organizeService.queryCurrId(listNewTenRecord.get(i).getHouseId());
//                    listNewTenRecord.get(i).setHouseName(houseName.getText());
//                }else{
//                    listNewTenRecord.get(i).setHouseName("???");
//                }
//            }
//            if(listNewTenRecord.get(i).getFloorId()!=null){
//                if(!listNewTenRecord.get(i).getFloorId().equals("0")){
//                    EasyTree floorName = organizeService.queryCurrId(listNewTenRecord.get(i).getFloorId());
//                    listNewTenRecord.get(i).setFloorName(floorName.getText());
//                }else{
//                    listNewTenRecord.get(i).setFloorName("???");
//                }
//            }
//            if(listNewTenRecord.get(i).getRoomId()!=null){
//                if(!listNewTenRecord.get(i).getRoomId().equals("0")){
//                    EasyTree roomName = organizeService.queryCurrId(listNewTenRecord.get(i).getRoomId());
//                    listNewTenRecord.get(i).setRoomName(roomName.getText());
//                }else{
//                    listNewTenRecord.get(i).setRoomName("???");
//                }
//            }
//        }
        return listNewTenRecord;
    }
    //??????????????????????????????
    @RequestMapping("historyRecordInfo")
    public ModelAndView getHistoryRecordInfo() {
        ModelAndView modelAndView = new ModelAndView("doorDevHK/historyRecordInfo");
        List<EasyTree> schoolList = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        modelAndView.addObject("schoolList",schoolList);
        return modelAndView;
    }
    //??????????????????????????????
    @RequestMapping("searchStaff")
    @ResponseBody
    public Layui searchStaff( HttpServletRequest request){
        int page = Integer.valueOf(request.getParameter("page")) ;
        int limit = Integer.valueOf(request.getParameter("limit"));
        int offset = (page-1)*limit;
        String schoolId = request.getParameter("schoolId");
        String houseId = request.getParameter("houseId");
        String floorId = request.getParameter("floorId");
        String roomId = request.getParameter("roomId");
        String personType = request.getParameter("personType");
        String staff = request.getParameter("staff");
        JSONObject json = new JSONObject();
        json.put("offset", String.valueOf(offset));
        json.put("limit", String.valueOf(limit));
        json.put("schoolId",schoolId);
        json.put("houseId",houseId);
        json.put("floorId",floorId);
        json.put("roomId",roomId);
        json.put("personType",personType);
        json.put("name",staff);
        json.put("staffId",staff);
        json.put("cardNo",staff);
        System.err.println(json);
        List<StaffDetail> staffDetailList = staffService.queryStaff(json);
        MyUtil.printfInfo("list"+staffDetailList);
//        for(int i =0;i<staffDetailList.size();i++){
//            if(staffDetailList.get(i).getSchoolId()!=null){
//                if(!staffDetailList.get(i).getSchoolId().equals("")){
//                    EasyTree schoolName = organizeService.queryCurrId(staffDetailList.get(i).getSchoolId());
//                    staffDetailList.get(i).setSchoolName(schoolName.getText());
//                }else{
//                    staffDetailList.get(i).setSchoolName("???");
//                }
//            }
//            if(staffDetailList.get(i).getHouseId()!=null){
//                if(!staffDetailList.get(i).getHouseId().equals("")){
//                    EasyTree houseName = organizeService.queryCurrId(staffDetailList.get(i).getHouseId());
//                    staffDetailList.get(i).setHouseName(houseName.getText());
//                }else{
//                    staffDetailList.get(i).setHouseName("???");
//                }
//            }
//            if(staffDetailList.get(i).getFloorId()!=null){
//                if(!staffDetailList.get(i).getFloorId().equals("")){
//                    EasyTree floorName = organizeService.queryCurrId(staffDetailList.get(i).getFloorId());
//                    staffDetailList.get(i).setFloorName(floorName.getText());
//                }else{
//                    staffDetailList.get(i).setFloorName("???");
//                }
//            }
//            if(staffDetailList.get(i).getRoomId()!=null){
//                if(!staffDetailList.get(i).getRoomId().equals("")){
//                    EasyTree roomName = organizeService.queryCurrId(staffDetailList.get(i).getRoomId());
//                    staffDetailList.get(i).setRoomName(roomName.getText());
//                }else{
//                    staffDetailList.get(i).setRoomName("???");
//                }
//            }
//            if(staffDetailList.get(i).getPersonType()!=null){
//                if(staffDetailList.get(i).getPersonType().equals("student")){
//                    staffDetailList.get(i).setPersonTypeName("??????");
//                }else if(staffDetailList.get(i).getPersonType().equals("teacher")){
//                    staffDetailList.get(i).setPersonTypeName("??????");
//                }else if(staffDetailList.get(i).getPersonType().equals("other")){
//                    staffDetailList.get(i).setPersonTypeName("??????");
//                }
//            }
//        }
        int count =staffDetailList.size();
        return Layui.data(count,staffDetailList);
    }

    @RequestMapping("getRealTimeData")
    @ResponseBody
    public Layui getRealTimeData( HttpServletRequest request){

        JSONObject json = new JSONObject();
        List<HistoryFaceAlarm> list = staffService.queryRecord(json);
        System.out.println("????????????1:"+list);
//        for(int i =0;i<list.size();i++){
//            if(list.get(i).getSchoolId()!=null){
//                if(!list.get(i).getSchoolId().equals("0")){
//                    EasyTree schoolName = organizeService.queryCurrId(list.get(i).getSchoolId());
//                    list.get(i).setSchoolName(schoolName.getText());
//                }else{
//                    list.get(i).setSchoolName("???");
//                }
//            }
//            if(list.get(i).getHouseId()!=null){
//                if(!list.get(i).getHouseId().equals("0")){
//                    EasyTree houseName = organizeService.queryCurrId(list.get(i).getHouseId());
//                    list.get(i).setHouseName(houseName.getText());
//                }else{
//                    list.get(i).setHouseName("???");
//                }
//            }
//            if(list.get(i).getFloorId()!=null){
//                if(!list.get(i).getFloorId().equals("0")){
//                    EasyTree floorName = organizeService.queryCurrId(list.get(i).getFloorId());
//                    list.get(i).setFloorName(floorName.getText());
//                }else{
//                    list.get(i).setFloorName("???");
//                }
//            }
//            if(list.get(i).getRoomId()!=null){
//                if(!list.get(i).getRoomId().equals("0")){
//                    EasyTree roomName = organizeService.queryCurrId(list.get(i).getRoomId());
//                    list.get(i).setRoomName(roomName.getText());
//                }else{
//                    list.get(i).setRoomName("???");
//                }
//            }
//        }
        //System.out.println("????????????2:"+list);
        int count = staffService.queryRecordCount(json);
        return Layui.data(count,list);
    }


    @RequestMapping("searchRealRecord")
    @ResponseBody
    public Layui searchRealRecord(Model model, HttpServletRequest request){
        int page = Integer.valueOf(request.getParameter("page")) ;
        int limit = Integer.valueOf(request.getParameter("limit"));
        int offset = (page-1)*limit;
        String startTime ="";
        String endTime ="";
        String schoolId=request.getParameter("schoolId");
        String houseId=request.getParameter("houseId");
        String floorId=request.getParameter("floorId");
        String roomId=request.getParameter("roomId");
        long current= System.currentTimeMillis();    //?????????????????????
        long zeroT=current/(1000*3600*24)*(1000*3600*24)- TimeZone.getDefault().getRawOffset();  //????????????????????????????????????
        startTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(zeroT);//	2018-07-23 00:00:00
        long endT=zeroT+24*60*60*1000-1;  //??????23???59???59???????????????
        endTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(endT);//	2018-07-23 23:59:59

        String staffName = request.getParameter("staffName");
//        String staffId = request.getParameter("staffId");
        String cardNo = request.getParameter("cardNo");
//        String dName = request.getParameter("dName");
        if(request.getParameter("startTime")!=null&&request.getParameter("startTime")!=""){
            startTime = request.getParameter("startTime");
        }
        if(request.getParameter("endTime")!=null&&request.getParameter("endTime")!=""){
            endTime = request.getParameter("endTime");
        }

        JSONObject json = new JSONObject();
        json.put("offset", String.valueOf(offset));
        json.put("limit", String.valueOf(limit));
        json.put("schoolId",schoolId);
        json.put("houseId",houseId);
        json.put("floorId",floorId);
        json.put("roomId",roomId);
        json.put("staffName",staffName);
//        json.put("staffId",staffId);
        json.put("cardNo",cardNo);
//        json.put("dName",dName);
        json.put("startTime",startTime);
        json.put("endTime",endTime);
        System.out.println("????????????????????????????????????:"+json);
        List<HistoryFaceAlarm> list = staffService.queryRecord(json);
//        for(int i =0;i<list.size();i++){
//            if(list.get(i).getSchoolId()!=null){
//                if(!list.get(i).getSchoolId().equals("0")){
//                    EasyTree schoolName = organizeService.queryCurrId(list.get(i).getSchoolId());
//                    list.get(i).setSchoolName(schoolName.getText());
//                }else{
//                    list.get(i).setSchoolName("???");
//                }
//            }
//            if(list.get(i).getHouseId()!=null){
//                if(!list.get(i).getHouseId().equals("0")){
//                    EasyTree houseName = organizeService.queryCurrId(list.get(i).getHouseId());
//                    list.get(i).setHouseName(houseName.getText());
//                }else{
//                    list.get(i).setHouseName("???");
//                }
//            }
//            if(list.get(i).getFloorId()!=null){
//                if(!list.get(i).getFloorId().equals("0")){
//                    EasyTree floorName = organizeService.queryCurrId(list.get(i).getFloorId());
//                    list.get(i).setFloorName(floorName.getText());
//                }else{
//                    list.get(i).setFloorName("???");
//                }
//            }
//            if(list.get(i).getRoomId()!=null){
//                if(!list.get(i).getRoomId().equals("0")){
//                    EasyTree roomName = organizeService.queryCurrId(list.get(i).getRoomId());
//                    list.get(i).setRoomName(roomName.getText());
//                }else{
//                    list.get(i).setRoomName("???");
//                }
//            }
//
//        }
        int count = staffService.queryRecordCount(json);
        System.out.println(count+",:"+list);
        return Layui.data(count,list);
    }
    //????????????????????????????????????
    @RequestMapping("searchHistoryRecord")
    @ResponseBody
    public Layui searchHistoryRecord( HttpServletRequest request){
        int page = Integer.valueOf(request.getParameter("page")) ;
        int limit = Integer.valueOf(request.getParameter("limit"));
        int offset = (page-1)*limit;
        String schoolId=request.getParameter("schoolId");
        String houseId=request.getParameter("houseId");
        String floorId=request.getParameter("floorId");
        String roomId=request.getParameter("roomId");
        String staffName = request.getParameter("staffName");
//        String staffId = request.getParameter("staffId");
        String cardNo = request.getParameter("cardNo");
//        String dName = request.getParameter("dName");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");

        JSONObject json = new JSONObject();
        json.put("offset", String.valueOf(offset));
        json.put("limit", String.valueOf(limit));
        json.put("schoolId",schoolId);
        json.put("houseId",houseId);
        json.put("floorId",floorId);
        json.put("roomId",roomId);
        json.put("staffName",staffName);
//        json.put("staffId",staffId);
        json.put("cardNo",cardNo);
//        json.put("dName",dName);
        json.put("startTime",startTime);
        json.put("endTime",endTime);

        List<HistoryFaceAlarm> list = staffService.queryHistoryRecord(json);
        for(int i =0;i<list.size();i++){
            if(!list.get(i).getSchoolId().equals("")){
                if(!list.get(i).getSchoolId().equals("0")){
                    EasyTree schoolName = organizeService.queryCurrId(list.get(i).getSchoolId());
                    list.get(i).setSchoolName(schoolName.getText());
                }else{
                    list.get(i).setSchoolName("???");
                }
            }
            if(list.get(i).getHouseId()!=null){
                if(!list.get(i).getHouseId().equals("0")){
                    EasyTree houseName = organizeService.queryCurrId(list.get(i).getHouseId());
                    list.get(i).setHouseName(houseName.getText());
                }else{
                    list.get(i).setHouseName("???");
                }
            }
            if(list.get(i).getFloorId()!=null){
                if(!list.get(i).getFloorId().equals("0")){
                    EasyTree floorName = organizeService.queryCurrId(list.get(i).getFloorId());
                    list.get(i).setFloorName(floorName.getText());
                }else{
                    list.get(i).setFloorName("???");
                }
            }
            if(list.get(i).getRoomId()!=null){
                if(!list.get(i).getRoomId().equals("0")){
                    EasyTree roomName = organizeService.queryCurrId(list.get(i).getRoomId());
                    list.get(i).setRoomName(roomName.getText());
                }else{
                    list.get(i).setRoomName("???");
                }
            }

        }
        int count =  staffService.queryHistoryRecordCount(json);
        return Layui.data(count,list);
    }
    //????????????
    @RequestMapping("getDepartmentName")
    @ResponseBody
    public List<Department> getDepartmentName(){
        List<Department> list = departmentService.selectDepartmentName();
        return list;
    }
    @RequestMapping("searchRealTimePicture")
    @ResponseBody
    public List<HistoryFaceAlarm> searchRealTimePicture(){
        JSONObject json = new JSONObject();
        List<HistoryFaceAlarm> list = staffService.queryHistoryRecord(json);
        return list;
    }
    @RequestMapping("selectCardNo")
    @ResponseBody
    public JSONObject selectCardNo(String cardNo){
        System.out.println("????????????"+cardNo);
        List<StaffDetail> list = staffService.queryCardNo(cardNo);
        int code=0;
        if(list.size()>0){
            code=1;
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("code",code);
        MyUtil.printfInfo(jsonObject.toString());
        return jsonObject;
    }
    @RequestMapping("queryByStaffId")
    @ResponseBody
    public JSONObject queryByStaffId(String staffId){
        System.out.println("??????????????????"+staffId);
        List<StaffDetail> list = staffService.queryByStaffId(staffId);
        int code=0;
        if(list.size()>0){
            code=1;
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("code",code);
        MyUtil.printfInfo(jsonObject.toString());
        return jsonObject;
    }
    @RequestMapping("selectStaffName")
    @ResponseBody
    public JSONObject selectStaffName(String name){
        System.out.println("????????????"+name);
        List<StaffDetail> list = staffService.queryStaffName(name);
        int code=0;
        if(list.size()>0){
            code=1;
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("code",code);
        MyUtil.printfInfo(jsonObject.toString());
        return jsonObject;
    }


    @RequestMapping("selectRecord")
    @ResponseBody
    public Layui selectRecord( HttpServletRequest request){

        JSONObject json = new JSONObject();
        List<HistoryFaceAlarm> list = staffService.selectRecord(json);
        for(HistoryFaceAlarm h : list){
            h.setStatus("???");
        }

        int count = list.size();
        return Layui.data(count,list);
    }
    @RequestMapping("realTimeRecord")
    public ModelAndView realTimeRecord(Model model, int type,HttpServletRequest request)throws InterruptedException {
        ModelAndView modelAndView = new ModelAndView("doorDevHK/realTimeRecord");
        Date date = new Date();
        String day = new SimpleDateFormat("yyyy-MM-dd").format(date);
        List<HistoryFaceAlarm> list = new ArrayList<>();
        if(type==1){
            String startTime = day.concat(" 00:00:00");
            String endTime = day.concat(" 23:59:59");

            JSONObject json = new JSONObject();
            json.put("startTime",startTime);
            json.put("endTime",endTime);
            list = staffService.queryHistoryRecord(json);
            int count = list.size();
//            MyUtil.printfInfo(list.toString());
//            modelAndView.addObject("list",JSONObject.toJSONString(list));
        }else if(type==2){
            Date firstDay = getDateBefore(date,6);
            String first = new SimpleDateFormat("yyyy-MM-dd").format(firstDay);
            String startTime = first.concat(" 00:00:00");
            String endTime = day.concat(" 23:59:59");
            JSONObject json = new JSONObject();
            json.put("startTime",startTime);
            json.put("endTime",endTime);
            list = staffService.queryHistoryRecord(json);
            int count = list.size();
//            MyUtil.printfInfo(list.toString());
//            modelAndView.addObject("list",JSONObject.toJSONString(list));
        }else if(type==3){
            Date firstDay = getDateBefore(date,29);
            String first = new SimpleDateFormat("yyyy-MM-dd").format(firstDay);
            String startTime = first.concat(" 00:00:00");
            String endTime = day.concat(" 23:59:59");
            JSONObject json = new JSONObject();
            json.put("startTime",startTime);
            json.put("endTime",endTime);
            list = staffService.queryHistoryRecord(json);
            int count = list.size();
//            MyUtil.printfInfo(list.toString());
//            modelAndView.addObject("list",JSONObject.toJSONString(list));
        }
        for(int i = 0;i<list.size();i++) {
            if (!list.get(i).getSchoolId().equals("")) {
                if (!list.get(i).getSchoolId().equals("0")) {
                    EasyTree schoolName = organizeService.queryCurrId(list.get(i).getSchoolId());
                    list.get(i).setSchoolName(schoolName.getText());
                } else {
                    list.get(i).setSchoolName("???");
                }
            }
            if (list.get(i).getHouseId() != null) {
                if (!list.get(i).getHouseId().equals("0")) {
                    EasyTree houseName = organizeService.queryCurrId(list.get(i).getHouseId());
                    list.get(i).setHouseName(houseName.getText());
                } else {
                    list.get(i).setHouseName("???");
                }
            }
            if (list.get(i).getFloorId() != null) {
                if (!list.get(i).getFloorId().equals("0")) {
                    EasyTree floorName = organizeService.queryCurrId(list.get(i).getFloorId());
                    list.get(i).setFloorName(floorName.getText());
                } else {
                    list.get(i).setFloorName("???");
                }
            }
            if (list.get(i).getRoomId() != null) {
                if (!list.get(i).getRoomId().equals("0")) {
                    EasyTree roomName = organizeService.queryCurrId(list.get(i).getRoomId());
                    list.get(i).setRoomName(roomName.getText());
                } else {
                    list.get(i).setRoomName("???");
                }
            }
        }
        modelAndView.addObject("list",JSONObject.toJSONString(list));
        return modelAndView;
    }

    public static Date getDateBefore(Date d,int day) {
        Calendar now = Calendar.getInstance();
        now.setTime(d);
        now.set(Calendar.DATE, now.get(Calendar.DATE) - day);
        return now.getTime();
    }
}