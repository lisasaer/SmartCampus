package com.zy.SmartCampus.controller;
import com.alibaba.fastjson.JSONObject;
import com.google.gson.JsonObject;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.service.OrganizeService;
import com.zy.SmartCampus.service.VideoService;
import com.zy.SmartCampus.util.MyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
public class VideoCtrl {
    @Autowired
    private OrganizeService organizeService;

    @Autowired
    private VideoService videoService;
    public static List<VideoInfo> resList = new ArrayList<>();
    final static String strNoOrganize = "0";
    /**
     * 监控设备 页面初始化
     * @return
     */
    @RequestMapping("videoManager")
    public ModelAndView videoManager(){
        ModelAndView modelAndView = new ModelAndView("videoManager/videoManager");
        List<EasyTree> schoolList = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        modelAndView.addObject("schoolList",schoolList);
        return modelAndView;
    }

    @RequestMapping("videoDevView")
    public ModelAndView editVideoDevView(String id){
//        List<EasyTree> list = organizeService.queryChildenOrganize(
//                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
//        model.addAttribute("schoolList",list);

        ModelAndView modelAndView = new ModelAndView("videoManager/videoDevView");
        JSONObject json = new JSONObject();
        json.put("id",id);
        List<VideoInfo> deviceList = videoService.queryVideo(json);
        System.out.println(deviceList);
        for(int i = 0;i<deviceList.size();i++)
        {
            if(deviceList.get(i).getDevStatus().equals("0"))
            {
                deviceList.get(i).setDevStatus("离线");
            }
            else if(deviceList.get(i).getDevStatus().equals("1"))
            {
                deviceList.get(i).setDevStatus("在线");
            }
//            if(deviceList.get(i).getSchoolId()!=null){
//                if(!deviceList.get(i).getSchoolId().equals("0")){
//                    EasyTree schoolName = organizeService.queryCurrId(deviceList.get(i).getSchoolId());
//                    deviceList.get(i).setSchoolName(schoolName.getText());
//                }else{
//                    deviceList.get(i).setSchoolName("无");
//                }
//            }
//            if(deviceList.get(i).getHouseId()!=null){
//                if(!deviceList.get(i).getHouseId().equals("0")){
//                    EasyTree houseName = organizeService.queryCurrId(deviceList.get(i).getHouseId());
//                    deviceList.get(i).setHouseName(houseName.getText());
//                }else{
//                    deviceList.get(i).setHouseName("无");
//                }
//            }
//            if(deviceList.get(i).getFloorId()!=null){
//                if(!deviceList.get(i).getFloorId().equals("0")){
//                    EasyTree floorName = organizeService.queryCurrId(deviceList.get(i).getFloorId());
//                    deviceList.get(i).setFloorName(floorName.getText());
//                }else{
//                    deviceList.get(i).setFloorName("无");
//                }
//            }
//            if(deviceList.get(i).getRoomId()!=null){
//                if(!deviceList.get(i).getRoomId().equals("0")){
//                    EasyTree roomName = organizeService.queryCurrId(deviceList.get(i).getRoomId());
//                    deviceList.get(i).setRoomName(roomName.getText());
//                }else{
//                    deviceList.get(i).setRoomName("无");
//                }
//            }
        }
        modelAndView.addObject("deviceList",deviceList);
        System.out.println("deviceList"+deviceList);
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

    @RequestMapping("videoDevAdd")
    public String addVideoDevView(Model model){
        List<EasyTree> list = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        model.addAttribute("schoolList",list);
        return "videoManager/videoDevAdd";
    }

    @RequestMapping("addVideo")
    @ResponseBody
    public JSONObject addVideo(@RequestBody VideoInfo videoInfo){
        //1.加入设备表
        String vid = MyUtil.getUUID();
        videoInfo.setId(vid);
//        videoInfo.setTreeID(videoInfo.getRoom());
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        videoInfo.setCreateDate(formatter.format(date));
        System.out.println(videoInfo.toString());
        /*if(videoInfo.getSchoolId().equals(null)){videoInfo.setSchoolId("");}
        if(videoInfo.getHouseId().equals(null)){videoInfo.setHouseId("");}
        if(videoInfo.getFloorId().equals(null)){videoInfo.setFloorId("");}
        if(videoInfo.getRoomId().equals(null)){videoInfo.setRoomId("");}*/


        //2.加入组织表-监控视频预览用到
        List<EasyTree> list = organizeService.queryChildenOrganize("0","");
        System.out.println(list);
//        EasyTree easyTree = new EasyTree();
//        easyTree.setId(vid);
//        easyTree.setText(videoInfo.getDevName());
        if(videoInfo.getSchoolId().equals("")){
            System.out.println("1");
            videoInfo.setIconCls("my-tree-icon-2");
            videoInfo.setPId(list.get(0).getId());
        }
        else if(videoInfo.getHouseId().equals("")){
            System.out.println("2");
            videoInfo.setIconCls("my-tree-icon-3");
            videoInfo.setPId(videoInfo.getSchoolId());
        }
        else if(videoInfo.getFloorId().equals("")){
            System.out.println("3");
            videoInfo.setIconCls("my-tree-icon-4");
            videoInfo.setPId(videoInfo.getHouseId());
        }
        else if(videoInfo.getRoomId().equals("")){
            System.out.println("4");
            videoInfo.setIconCls("my-tree-icon-5");
            videoInfo.setPId(videoInfo.getFloorId());
        }
        if(!videoInfo.getSchoolId().equals("")&&!videoInfo.getHouseId().equals("")&&!videoInfo.getFloorId().equals("")&&!videoInfo.getRoomId().equals("")){
            videoInfo.setIconCls("my-tree-icon-6");
            videoInfo.setPId(videoInfo.getRoomId());
        }
        System.out.println(videoInfo);
//        easyTree.setIconCls("my-tree-icon-6");
//        easyTree.setPId(videoInfo.getRoom());
//        organizeService.insertOrganize(easyTree);
        int iCode = videoService.insertVideo(videoInfo);

        JSONObject jsonRet = new JSONObject();
        jsonRet.put("code",iCode);
        jsonRet.put("msg",(iCode>0)?"添加成功":"添加失败");

        System.out.println(jsonRet);

        return jsonRet;
    }
    @RequestMapping("selectVideoDevIP")
    @ResponseBody
    public JSONObject selectVideoDevIP(String ip){
        JSONObject json = new JSONObject();
        json.put("ip",ip);
        List<VideoInfo> list = videoService.queryVideo(json);
        int iCode = 0;
        if(list.size()>0){
            iCode = 1;
        }
        JSONObject jsonRet = new JSONObject();
        jsonRet.put("code", iCode);
        MyUtil.printfInfo(jsonRet.toString());
        return jsonRet;
    }

    @RequestMapping("getAllVideo")
    @ResponseBody
    public Layui getAllVideo(HttpServletRequest request){
        int page = Integer.valueOf(request.getParameter("page"));
        int limit = Integer.valueOf(request.getParameter("limit"));
        int offset = (page-1)*limit;
        JSONObject json = new JSONObject();
        json.put("offset",offset);
        json.put("limit",limit);

        List<VideoInfo>  videoInfoList =  videoService.queryAllVideoDev(json);
        videoInfoList = selectOrganize(videoInfoList);

        for(int i = 0; i<videoInfoList.size();i++){
            String encryptedPassword = "";
            String password = videoInfoList.get(i).getPassword();
            for(int j = 0 ;j<password.length();j++){
                encryptedPassword=encryptedPassword.concat("*");
            }
            videoInfoList.get(i).setEncryptedPassword(encryptedPassword);
        }
        int count = videoService.queryVideoDevCount(json);
        return Layui.data(count,videoInfoList);
    }

    @RequestMapping("getVideoByTree")
    @ResponseBody
    public Layui getVideoByTree(String iconCls,String id) {
        resList.clear();
        List<VideoInfo> list =queryChildrenTree(iconCls,id);
        int count = list.size();
        return Layui.data(count, list);
    }

    public List<VideoInfo> queryChildrenTree(String iconCls,String id){
        JSONObject jsonObject = new JSONObject();
        List<VideoInfo> list = new ArrayList<>();
        if(iconCls==null){
            list =  videoService.queryVideo(jsonObject);
        }else {
            if(iconCls.equals("my-tree-icon-1")){
                list = videoService.queryVideo(jsonObject);
            }else if(iconCls.equals("my-tree-icon-2")){
                String schoolId = id;
                jsonObject.put("schoolId",schoolId);
                list = videoService.queryVideo(jsonObject);
            }else if(iconCls.equals("my-tree-icon-3")){
                String houseId = id;
                jsonObject.put("houseId",houseId);
                list = videoService.queryVideo(jsonObject);
            }else if(iconCls.equals("my-tree-icon-4")){
                String floorId = id;
                jsonObject.put("floorId",floorId);
                list = videoService.queryVideo(jsonObject);
            }else if(iconCls.equals("my-tree-icon-5")){
                String roomId = id;
                jsonObject.put("roomId",roomId);
                list = videoService.queryVideo(jsonObject);
            }
        }
        list = selectOrganize(list);
//        for(int i =0;i<list.size();i++) {
//            if (list.get(i).getDevStatus().equals("0")) {
//                list.get(i).setDevStatus("离线");
//            } else if (list.get(i).getDevStatus().equals("1")) {
//                list.get(i).setDevStatus("在线");
//            }
//            if (list.get(i).getSchoolId() != null) {
//                if (!list.get(i).getSchoolId().equals("0")) {
//                    EasyTree schoolName = organizeService.queryCurrId(list.get(i).getSchoolId());
//                    list.get(i).setSchoolName(schoolName.getText());
//                } else {
//                    list.get(i).setSchoolName("无");
//                }
//            }
//            if (list.get(i).getHouseId() != null) {
//                if (!list.get(i).getHouseId().equals("0")) {
//                    EasyTree houseName = organizeService.queryCurrId(list.get(i).getHouseId());
//                    list.get(i).setHouseName(houseName.getText());
//                } else {
//                    list.get(i).setHouseName("无");
//                }
//            }
//            if (list.get(i).getFloorId() != null) {
//                if (!list.get(i).getFloorId().equals("0")) {
//                    EasyTree floorName = organizeService.queryCurrId(list.get(i).getFloorId());
//                    list.get(i).setFloorName(floorName.getText());
//                } else {
//                    list.get(i).setFloorName("无");
//                }
//            }
//            if (list.get(i).getRoomId() != null) {
//                if (!list.get(i).getRoomId().equals("0")) {
//                    EasyTree roomName = organizeService.queryCurrId(list.get(i).getRoomId());
//                    list.get(i).setRoomName(roomName.getText());
//                } else {
//                    list.get(i).setRoomName("无");
//                }
//            }
//        }
        resList.addAll(list);
        return resList;
    }

    //监控搜索
    @RequestMapping("searchVideo")
    @ResponseBody
    public Layui searchDev(int page, int limit, HttpServletRequest request){
        int offset = (page-1)*limit;
        String devIP = request.getParameter("devIP");
        String devName = request.getParameter("devName");
        String schoolId=request.getParameter("schoolId");
        String houseId=request.getParameter("houseId");
        String floorId=request.getParameter("floorId");
        String roomId=request.getParameter("roomId");
        String devStatus=request.getParameter("devStatus");

        JSONObject json = new JSONObject();
        json.put("offset",offset);
        json.put("limit",limit);
        json.put("ip",devIP);
        json.put("devName",devName);
        json.put("schoolId",schoolId);
        json.put("houseId",houseId);
        json.put("floorId",floorId);
        json.put("roomId",roomId);
        json.put("devStatus",devStatus);
        List<VideoInfo> list = videoService.queryVideo(json);

        list = selectOrganize(list);
//        for(int i =0;i<list.size();i++) {
//            if (list.get(i).getDevStatus().equals("0")) {
//                list.get(i).setDevStatus("离线");
//            } else if (list.get(i).getDevStatus().equals("1")) {
//                list.get(i).setDevStatus("在线");
//            }
//            if (list.get(i).getSchoolId() != null) {
//                if (!list.get(i).getSchoolId().equals("0")) {
//                    EasyTree schoolName = organizeService.queryCurrId(list.get(i).getSchoolId());
//                    list.get(i).setSchoolName(schoolName.getText());
//                } else {
//                    list.get(i).setSchoolName("无");
//                }
//            }
//            if (list.get(i).getHouseId() != null) {
//                if (!list.get(i).getHouseId().equals("0")) {
//                    EasyTree houseName = organizeService.queryCurrId(list.get(i).getHouseId());
//                    list.get(i).setHouseName(houseName.getText());
//                } else {
//                    list.get(i).setHouseName("无");
//                }
//            }
//            if (list.get(i).getFloorId() != null) {
//                if (!list.get(i).getFloorId().equals("0")) {
//                    EasyTree floorName = organizeService.queryCurrId(list.get(i).getFloorId());
//                    list.get(i).setFloorName(floorName.getText());
//                } else {
//                    list.get(i).setFloorName("无");
//                }
//            }
//            if (list.get(i).getRoomId() != null) {
//                if (!list.get(i).getRoomId().equals("0")) {
//                    EasyTree roomName = organizeService.queryCurrId(list.get(i).getRoomId());
//                    list.get(i).setRoomName(roomName.getText());
//                } else {
//                    list.get(i).setRoomName("无");
//                }
//            }
//        }

        return Layui.data(list.size(),list);
    }

    @RequestMapping("delVideo")
    @ResponseBody
    public JSONObject delVideo(String id){
        JSONObject json = new JSONObject();

        //设备表删除
        int code = videoService.delVideo(id);
        //区域表删除
        //organizeService.delOrganize(id);
        json.put("code",code);
        json.put("msg",(code > 0)?"删除成功":"删除失败");
        return json;
    }

    @RequestMapping("delSomeVideo")
    @ResponseBody
    public JSONObject delSomeVideo(@RequestBody List<VideoInfo> videoInfos){
        JSONObject json = new JSONObject();
        int code=0;
        for (VideoInfo videoInfo : videoInfos) {
            String id = videoInfo.getId();
            //设备表删除
            code = videoService.delVideo(id);
        }
        //区域表删除
        //organizeService.delOrganize(id);

        json.put("code",code);
        json.put("msg",(code > 0)?"删除成功":"删除失败");
        return json;
    }


    @RequestMapping("modifyVideo")
    @ResponseBody
    public JSONObject modifyVideo(@RequestBody VideoInfo videoInfo){
        JSONObject json = new JSONObject();
        int iRet = videoService.updateVideo(videoInfo);
        json.put("code",iRet);
        json.put("msg",(iRet > 0?"修改成功":"修改失败"));
        return json;
    }

    private String getAllParentOrganize(String id){
        EasyTree easyTree = organizeService.queryParent(id);
        EasyTree thisEasyTree  = organizeService.queryCurrId(id);
        String str = thisEasyTree.getText()+","+easyTree.getText()+",";
        while (!easyTree.getPId().equals("0")){
            easyTree = organizeService.queryParent(easyTree.getId());
            str += easyTree.getText()+",";
        }
        //System.out.println(str);
        return str.substring(0,str.length()-1);
    }

    //实时监控
    @RequestMapping("realtimeMonitoring")
    public String realtimeMonitoring(){
        return "videoManager/realtimeMonitoring";
    }

    //wpp-2020-3-10 监控-实时预览会用到-查询区域下的设备
    @RequestMapping("getTreeVideoData")
    @ResponseBody
    public List<EasyTree> getTreeVideoData(HttpServletRequest request){
        String iconCls = request.getParameter("iconCls");   //iconCls 图片样式
        List<EasyTree> list = organizeService.queryChildenOrganize("0",iconCls);
        for(EasyTree easyTree : list){
            easyTree.setChildren(getVideoChildrenTree(easyTree,iconCls));
        }
        return list;
    }

    //wpp-2020-3-10 监控-实时预览会用到-查询区域下的设备
    //递归查找子节点
    private List<EasyTree> getVideoChildrenTree(EasyTree easyTree,String iconCls){
        List<EasyTree> list = organizeService.queryChildenOrganize(easyTree.getId(),iconCls);
        for(EasyTree temp : list){
            temp.setChildren(getVideoChildrenTree(temp,iconCls));
        }
        easyTree.setState(list.size() == 0 ? "open":"closed");
        return list;
    }
    //hhp-2020-3-10 监控-实时预览会用到-查询区域下的设备
    @RequestMapping("getTreeVideoDevData")
    @ResponseBody
    public List<EasyTree> getTreeVideoDevData(HttpServletRequest request){
        String iconCls = request.getParameter("iconCls");   //iconCls 图片样式
        List<EasyTree> list = organizeService.queryChildenOrganize("0",iconCls);
      /*  JSONObject jsonVideo = new JSONObject();
        List<VideoInfo> videoInfos = videoService.queryVideo(jsonVideo);
        System.out.println("监控设备信息"+videoInfos);
        System.out.println("父节点信息"+list);*/
        for(EasyTree easyTree : list){
          /*  for(VideoInfo videoInfo :videoInfos){
                if(easyTree.getId().equals(videoInfo.getPId())){
                    EasyTree easyTreeVideo = new EasyTree();
                    easyTreeVideo.setId(videoInfo.getId());
                    easyTreeVideo.setText(videoInfo.getDevName());
                    easyTreeVideo.setIconCls(videoInfo.getIconCls());
                    easyTreeVideo.setPId(videoInfo.getPId());
                    List<EasyTree> easyTreeList = new ArrayList<>();
                    easyTreeList.add(easyTreeVideo);
                    System.out.println("easyTreeList"+easyTreeList);
                    easyTree.setChildren(easyTreeList);
                }
            }*/
            easyTree.setChildren(getVideoDevChildrenTree(easyTree,iconCls));
        }
        return list;
    }
    private static int treeLevelId = 1;
    //hhp-2020-3-10 监控-实时预览会用到-查询区域下的设备
    //递归查找子节点
    private List<EasyTree> getVideoDevChildrenTree(EasyTree easyTree,String iconCls){
        List<EasyTree> list = organizeService.queryVideoChildrenOrganize(easyTree.getId());
     /*   JSONObject jsonVideo = new JSONObject();
        List<VideoInfo> videoInfos = videoService.queryVideo(jsonVideo);*/
        for(EasyTree temp : list){

            temp.setChildren(getVideoDevChildrenTree(temp,iconCls));
            /*for(VideoInfo videoInfo :videoInfos){
                if(easyTree.getId().equals(videoInfo.getPId())){
                    EasyTree easyTreeVideo = new EasyTree();
                    easyTreeVideo.setId(videoInfo.getId());
                    easyTreeVideo.setText(videoInfo.getDevName());
                    easyTreeVideo.setIconCls(videoInfo.getIconCls());
                    easyTreeVideo.setPId(videoInfo.getPId());
                    List<EasyTree> easyTreeList = new ArrayList<>();
                    easyTreeList.add(easyTreeVideo);
                    temp.setChildren(easyTreeList);
                }
            }*/
        }
        easyTree.setState(list.size() == 0 ? "open":"closed");
        System.out.println("list"+list);
        return list;
    }
    //得到设备的基本信息
    @RequestMapping("getVideoInfo")
    @ResponseBody
    public VideoInfo getVideoInfo(String id){
        JSONObject json = new JSONObject();
        json.put("id",id);
        List<VideoInfo>  videoInfoList = videoService.queryVideo(json);
        VideoInfo videoInfo = videoInfoList.get(0);

        System.out.println("videoInfo" + videoInfo);

        return videoInfo;
    }

    public List<VideoInfo> selectOrganize(List<VideoInfo> videoInfoList){
        for(int i =0;i<videoInfoList.size();i++) {
            if (videoInfoList.get(i).getDevStatus().equals("0")) {
                videoInfoList.get(i).setDevStatus("离线");
            } else if (videoInfoList.get(i).getDevStatus().equals("1")) {
                videoInfoList.get(i).setDevStatus("在线");
            }
            /*if (videoInfoList.get(i).getSchoolId() != null) {
                if (!videoInfoList.get(i).getSchoolId().equals("0")) {
                    EasyTree schoolName = organizeService.queryCurrId(videoInfoList.get(i).getSchoolId());
                    videoInfoList.get(i).setSchoolName(schoolName.getText());
                } else {
                    videoInfoList.get(i).setSchoolName("无");
                }
            }
            if (videoInfoList.get(i).getHouseId() != null) {
                if (!videoInfoList.get(i).getHouseId().equals("0")) {
                    EasyTree houseName = organizeService.queryCurrId(videoInfoList.get(i).getHouseId());
                    videoInfoList.get(i).setHouseName(houseName.getText());
                } else {
                    videoInfoList.get(i).setHouseName("无");
                }
            }
            if (videoInfoList.get(i).getFloorId() != null) {
                if (!videoInfoList.get(i).getFloorId().equals("0")) {
                    EasyTree floorName = organizeService.queryCurrId(videoInfoList.get(i).getFloorId());
                    videoInfoList.get(i).setFloorName(floorName.getText());
                } else {
                    videoInfoList.get(i).setFloorName("无");
                }
            }
            if (videoInfoList.get(i).getRoomId() != null) {
                if (!videoInfoList.get(i).getRoomId().equals("0")) {
                    EasyTree roomName = organizeService.queryCurrId(videoInfoList.get(i).getRoomId());
                    videoInfoList.get(i).setRoomName(roomName.getText());
                } else {
                    videoInfoList.get(i).setRoomName("无");
                }
            }*/
        }
        videoInfoList = setAreaText(videoInfoList);
        return videoInfoList;
    }

    //根据区域地点的ID设置地点文字
    public List<VideoInfo> setAreaText(List<VideoInfo> list){
        for(int i = 0;i<list.size();i++){
            if(!list.get(i).getSchoolId().equals("")){
                list.get(i).setSchoolName(organizeService.queryCurrId(list.get(i).getSchoolId()).getText());
            }
            if(!list.get(i).getHouseId().equals("")) {
                list.get(i).setHouseName(organizeService.queryCurrId(list.get(i).getHouseId()).getText());
            }
            if(!list.get(i).getFloorId().equals("")) {
                list.get(i).setFloorName(organizeService.queryCurrId(list.get(i).getFloorId()).getText());
            }
            if(!list.get(i).getRoomId().equals("")) {
                list.get(i).setRoomName(organizeService.queryCurrId(list.get(i).getRoomId()).getText());
            }
        }
        return list;
    }
    //抓拍路径设置   setVideoPath
    @RequestMapping("videoPathSetting")
    public String videoPathSetting(){
        return "videoManager/pathSetting";
    }

    //录像回放
    @RequestMapping("videoReplay")
    public String videoReplay() { return "videoManager/videoReplay"; }
}
