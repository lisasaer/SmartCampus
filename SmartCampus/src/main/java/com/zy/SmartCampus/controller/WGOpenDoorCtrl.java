package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.service.OrganizeService;
import com.zy.SmartCampus.service.WGOpenDoorService;
import com.zy.SmartCampus.util.MyUtil;
import com.zy.SmartCampus.util.WGAccessUtil;
import lombok.SneakyThrows;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Controller
public class WGOpenDoorCtrl {
    @Autowired
    WGOpenDoorService wgOpenDoorService;
    @Autowired
    private OrganizeService organizeService;

    //微耕门禁历史记录
    @RequestMapping("goWgAccessOpenDoor")
    public ModelAndView getwWgAccessOpenDoor(){
        ModelAndView modelAndView = new ModelAndView("wgAccessDev/wgAccessOpenDoor");
        List<EasyTree> schoolList = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        modelAndView.addObject("schoolList",schoolList);
        return modelAndView;
    }

    //获取所有的刷卡记录
    @RequestMapping("getWgAccessOpenDoor")
    @ResponseBody
    public Layui getWgAccessOpenDoor(HttpServletRequest request){
        JSONObject json = new JSONObject();

        if (request.getParameter("page") != null){
            int page = Integer.valueOf(request.getParameter("page")) ;
            int limit = Integer.valueOf(request.getParameter("limit"));
            int offset = (page-1)*limit;
            json.put("offset",offset);
            json.put("limit",limit);
        }

        String schoolId=request.getParameter("schoolId");
        String houseId=request.getParameter("houseId");
        String floorId=request.getParameter("floorId");
        String roomId=request.getParameter("roomId");
        String staffName = request.getParameter("staffName");
        String staffId = request.getParameter("staffId");
        String cardNo = request.getParameter("cardNo");
//        String dName = request.getParameter("dName");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");

        json.put("schoolId",schoolId);
        json.put("houseId",houseId);
        json.put("floorId",floorId);
        json.put("roomId",roomId);
        json.put("staffName",staffName);
        json.put("staffId",staffId);
        json.put("cardNo",cardNo);
//        json.put("dName",dName);
        json.put("startTime",startTime);
        json.put("endTime",endTime);

        List<WGAccessOpenDoor> list = wgOpenDoorService.queryWGOpenDoor(json);

        for(int j =0;j<list.size();j++){
            list.get(j).setSchoolName(organizeService.queryCurrId(!list.get(j).getSchoolId().equals("")?list.get(j).getSchoolId():"")!=null?organizeService.queryCurrId(!list.get(j).getSchoolId().equals("")?list.get(j).getSchoolId():"").getText():"");
            list.get(j).setHouseName(organizeService.queryCurrId(!list.get(j).getHouseId().equals("")?list.get(j).getHouseId():"")!=null?organizeService.queryCurrId(!list.get(j).getHouseId().equals("")?list.get(j).getHouseId():"").getText():"");
            list.get(j).setFloorName(organizeService.queryCurrId(!list.get(j).getFloorId().equals("")?list.get(j).getFloorId():"")!=null?organizeService.queryCurrId(!list.get(j).getFloorId().equals("")?list.get(j).getFloorId():"").getText():"");
            list.get(j).setRoomName(organizeService.queryCurrId(!list.get(j).getRoomId().equals("")?list.get(j).getRoomId():"")!=null?organizeService.queryCurrId(!list.get(j).getRoomId().equals("")?list.get(j).getRoomId():"").getText():"");
//            if(list.get(i).getSchoolId()!=null){
//                if(!list.get(i).getSchoolId().equals("0")){
//                    EasyTree schoolName = organizeService.queryCurrId(list.get(i).getSchoolId());
//                    list.get(i).setSchoolName(schoolName.getText());
//                }else{
//                    list.get(i).setSchoolName("无");
//                }
//            }
//            if(list.get(i).getHouseId()!=null){
//                if(!list.get(i).getHouseId().equals("0")){
//                    EasyTree houseName = organizeService.queryCurrId(list.get(i).getHouseId());
//                    list.get(i).setHouseName(houseName.getText());
//                }else{
//                    list.get(i).setHouseName("无");
//                }
//            }
//            if(list.get(i).getFloorId()!=null){
//                if(!list.get(i).getFloorId().equals("0")){
//                    EasyTree floorName = organizeService.queryCurrId(list.get(i).getFloorId());
//                    list.get(i).setFloorName(floorName.getText());
//                }else{
//                    list.get(i).setFloorName("无");
//                }
//            }
//            if(list.get(i).getRoomId()!=null){
//                if(!list.get(i).getRoomId().equals("0")){
//                    EasyTree roomName = organizeService.queryCurrId(list.get(i).getRoomId());
//                    list.get(i).setRoomName(roomName.getText());
//                }else{
//                    list.get(i).setRoomName("无");
//                }
//            }

        }
        int count =  wgOpenDoorService.queryWGOpenDoorCount(json);

        return Layui.data(count,list);
    }

    @RequestMapping("getwgAccessDevSearch")
    @ResponseBody
    public Layui getwgAccessDevSearch(int page, int limit, HttpServletRequest request){
        int offset = (page-1)*limit;
        String cardID = request.getParameter("cardID");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        JSONObject json = new JSONObject();
        json.put("offset",offset);
        json.put("limit",limit);
        json.put("cardID",cardID);
        json.put("startDate",startDate);
        json.put("endDate",endDate);

        List<WGAccessOpenDoor> list = wgOpenDoorService.queryWGOpenDoor(json);

        return Layui.data(list.size(),list);
    }

    //实时监控
    @RequestMapping("getWgAccessRealTime")
    @ResponseBody
    public Layui getwgAccessDevRealTime(HttpServletRequest request){
//        int page = Integer.valueOf(request.getParameter("page")) ;
//        int limit = Integer.valueOf(request.getParameter("limit"));
//        int offset = (page-1)*limit;

        JSONObject json = new JSONObject();
        ArrayList<String> chooseList = new ArrayList<String>();
        List<WGAccessOpenDoor> listOpenDoor = new ArrayList<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String startDate = request.getParameter("startDate");

        String chooesDoorStr = request.getParameter("chooseList");
        System.out.println("chooesDoorStr"+chooesDoorStr);
        if(chooesDoorStr!=null){
            String chooesDoorArr[] = chooesDoorStr.split("\"");
            List<String> chooesDoorList = new ArrayList<>();
            for(int i=0;i<chooesDoorArr.length;i++){
                if(i!=0){
                    int redundant = i%2;
                    if(redundant!=0){
                        chooesDoorList.add(chooesDoorArr[i]);
                    }
                }
            }
            System.out.println("选中的门集合："+chooesDoorList);
            if(chooesDoorList.size()>0){

//                json.put("offset",offset);
//                json.put("limit",limit);
                json.put("startDate",startDate);
                listOpenDoor = wgOpenDoorService.queryRealTimeOpenDoor(json);

                for(int j=0;j<listOpenDoor.size();j++){
                    String  schoolId = !listOpenDoor.get(j).getSchoolId().equals("")?listOpenDoor.get(j).getSchoolId():"";
                    EasyTree easyTree = organizeService.queryCurrId(schoolId);
                    listOpenDoor.get(j).setSchoolName(easyTree!=null?easyTree.getText():"");
                    listOpenDoor.get(j).setHouseName(organizeService.queryCurrId(!listOpenDoor.get(j).getHouseId().equals("")?listOpenDoor.get(j).getHouseId():"")!=null?organizeService.queryCurrId(!listOpenDoor.get(j).getHouseId().equals("")?listOpenDoor.get(j).getHouseId():"").getText():"");
                    listOpenDoor.get(j).setFloorName(organizeService.queryCurrId(!listOpenDoor.get(j).getFloorId().equals("")?listOpenDoor.get(j).getFloorId():"")!=null?organizeService.queryCurrId(!listOpenDoor.get(j).getFloorId().equals("")?listOpenDoor.get(j).getFloorId():"").getText():"");
                    listOpenDoor.get(j).setRoomName(organizeService.queryCurrId(!listOpenDoor.get(j).getRoomId().equals("")?listOpenDoor.get(j).getRoomId():"")!=null?organizeService.queryCurrId(!listOpenDoor.get(j).getRoomId().equals("")?listOpenDoor.get(j).getRoomId():"").getText():"");


                    Boolean status = false;

                    for(int t=0;t<chooesDoorList.size();t++) {
                        if ((listOpenDoor.get(j).getCtrlerID() + listOpenDoor.get(j).getDoorID()).equals(chooesDoorList.get(t))){
                            System.out.println("true");
                            status = true;
                        }
                    }
                    if(!status){
                        System.out.println("remove");
                        listOpenDoor.remove(j);
                        j--;
                    }

                }
            }
        }
        int count = wgOpenDoorService.getwgAccessDevRealCount(json);
        return Layui.data(count,listOpenDoor);
    }

}
