package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.ZigBeeConnect.TCPMsgUtil;
import com.zy.SmartCampus.ZigBeeConnect.TCPServer;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.service.OrganizeService;
import com.zy.SmartCampus.service.ZigBeeGatewayService;
import com.zy.SmartCampus.webSocket.WebSocketUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.*;

import static com.zy.SmartCampus.ZigBeeConnect.TCPServer.isNewDev;
import static com.zy.SmartCampus.ZigBeeConnect.TCPServer.onLine;


/**
 * @author: duzhibin
 * @description:
 * @date: create in 14:12 2021/7/22
 */

@Controller
public class ZigBeeGatewayCtrl {

    @Autowired
    ZigBeeGatewayService zigBeeGatewayService;
    @Autowired
    OrganizeService organizeService;

    /**
     * @return
     * @description ZigBee网关跳转
     * @params
     * @author dzb
     * @date 2021/7/22 14:09
     */
    @RequestMapping("goZigBeeGateway")
    public String goZigBeeGateway(Model model) {
        //查找学校的组织信息
        List<EasyTree> list = organizeService.queryChildenOrganize(organizeService.queryChildenOrganize("0", "").get(0).getId(), "");
        model.addAttribute("schoolList", list);
        return "devManager/zigBeeView";
    }

    //ZigBee网关设备搜索
    @RequestMapping("zigBeeDevSearchView")
    public String slaveView(Model model) throws InterruptedException {
        //开始加网
        TCPMsgUtil.sendTCPMsg(TCPMsgUtil.startJoinNetwork, new ZigBeeGatewayDevInfo());
        model.addAttribute("did", TCPServer.strNewDevId);
        Boolean connectionStatus = false;//连接异常状态
        Boolean searchStatus = false;   //搜索新设备状态
        int i = 0;
        //搜索倒计时，有新设备则跳出循环
        while (!isNewDev) {
            if (i < 30) {
                Thread.sleep(1000);
                i++;
                System.out.println(i);
            } else {
                connectionStatus = true;
                System.out.println("ZigBee设备搜索时长超过30秒, 请检查是否连接正确");
                break;
            }
        }

        Thread.sleep(5000);
        List<ZigBeeGatewayDevInfoTest> newZigBeeDev = new ArrayList<>();
//        for (int j=0 ; j<zigBeeNewDevInfoList.size() ;j++){
//            ZigBeeGatewayDevInfoTest zigBeeGatewayDevInfo=new ZigBeeGatewayDevInfoTest();
//            zigBeeGatewayDevInfo.setId(zigBeeNewDevInfoList.get(j).getId());
//            //判断当前设备在数据库中是否已经存在 待完成
////            List<ZigBeeGatewayDevInfoTest> ZigBeeOldList = loraDevService.queryLoraByDevSN(loraSN);
//            if(ZigBeeOldList.size()==0){
//                newZigBeeDev.add(zigBeeNewDevInfoList.get(j));
//            }else{
//                LoraDevInfo updateDevStatus = new LoraDevInfo();
//                updateDevStatus.setLoraSN(searchList.get(j).getLoraSN());
//                updateDevStatus.setOnLine("在线");
//                loraDevService.updateOnLoadStatus(updateDevStatus);
//            }
//        }
//        System.out.println("newLoraDev.size()"+newLoraDev.size());
//        if(newLoraDev.size()==0){
//            searchStatus = true;
//        }
//        System.out.println("newDevList：" + newLoraDev);
//        model.addAttribute("list",JSONObject.toJSONString(newLoraDev));
        model.addAttribute("connectionStatus", connectionStatus);
        model.addAttribute("searchStatus", searchStatus);

        return "devManager/zigBeeDevSearchView";
    }


    /**
     * @return
     * @description 查询ZigBee网关信息
     * @params
     * @author dzb
     * @date 2021/7/29 19:24
     */
    @RequestMapping("getZigBeeInfo")
    @ResponseBody
    public Layui getZigBeeInfo(HttpServletRequest request) throws Exception {
        int page = Integer.valueOf(request.getParameter("page"));
        int limit = Integer.valueOf(request.getParameter("limit"));
        int offset = (page - 1) * limit;
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("offset", offset);
        jsonObject.put("limit", limit);
        jsonObject.put("state", "在使用");
        int devCount = 0; //设备总数
        int devOnlineCount = 0; //设备在线数
        int devOfflineCount = 0; //设备离线数

        List<ZigBeeGatewayInfo> zigBeeGatewayInfoList = zigBeeGatewayService.selectZigBeeInfoByJsonObject(jsonObject);
        for (int i = 0; i < zigBeeGatewayInfoList.size(); i++) {
            ZigBeeGatewayDevInfo zigBeeGatewayDevInfo = new ZigBeeGatewayDevInfo();
            zigBeeGatewayDevInfo.setZigbeeId(zigBeeGatewayInfoList.get(i).getZigbeeId());
            zigBeeGatewayDevInfo.setEp("1");  //防止多开关重复算入
            List<ZigBeeGatewayDevInfo> zigBeeGatewayDevInfoList = zigBeeGatewayService.selectZigBeeDevInfo(zigBeeGatewayDevInfo);
            if (zigBeeGatewayDevInfoList.size() != 0) {
                devCount = zigBeeGatewayDevInfoList.size();
                for (int j = 0; j < zigBeeGatewayDevInfoList.size(); j++) {
                    if ("true".equals(zigBeeGatewayDevInfoList.get(j).getOl())) {
                        devOnlineCount++;
                    }
                }
                devOfflineCount = devCount - devOnlineCount;
            }
            //设置总数 在线数 离线数
            zigBeeGatewayInfoList.get(i).setDevCount(devCount);
            zigBeeGatewayInfoList.get(i).setDevOnlineCount(devOnlineCount);
            zigBeeGatewayInfoList.get(i).setDevOfflineCount(devOfflineCount);
            //清空计数
            devCount = 0;
            devOnlineCount = 0;
            devOfflineCount = 0;

            //根据区域地点的ID设置地点文字
            if (!"".equals(zigBeeGatewayInfoList.get(i).getSchool()) && null != zigBeeGatewayInfoList.get(i).getSchool()) {
                zigBeeGatewayInfoList.get(i).setSchool(organizeService.queryCurrId(zigBeeGatewayInfoList.get(i).getSchool()).getText());
            }
            if (!"".equals(zigBeeGatewayInfoList.get(i).getHouse()) && null != zigBeeGatewayInfoList.get(i).getHouse()) {
                zigBeeGatewayInfoList.get(i).setHouse(organizeService.queryCurrId(zigBeeGatewayInfoList.get(i).getHouse()).getText());
            }
            if (!"".equals(zigBeeGatewayInfoList.get(i).getFloor()) && null != zigBeeGatewayInfoList.get(i).getFloor()) {
                zigBeeGatewayInfoList.get(i).setFloor(organizeService.queryCurrId(zigBeeGatewayInfoList.get(i).getFloor()).getText());
            }
            if (!"".equals(zigBeeGatewayInfoList.get(i).getRoom()) && null != zigBeeGatewayInfoList.get(i).getRoom()) {
                zigBeeGatewayInfoList.get(i).setRoom(organizeService.queryCurrId(zigBeeGatewayInfoList.get(i).getRoom()).getText());
            }
        }

        //测试TCP通讯效果
        System.out.println("TCP是否连接：" + onLine);


        return Layui.data(zigBeeGatewayInfoList.size(), zigBeeGatewayInfoList);
    }

    /**
     * @return
     * @description 按条件查询网关信息
     * @params school house floor onLine keyword
     * @author dzb
     * @date 2021/8/2 18:43
     */
    @RequestMapping("getZigBeeInfoByCondition")
    @ResponseBody
    public Layui getZigBeeInfoByCondition(String school, String house, String floor, String room, String ol, String keyword) {
        if ("".equals(school)) {
            school = "";
        }
        if ("".equals(house)) {
            house = "";
        }
        if ("".equals(floor)) {
            floor = "";
        }
        if ("".equals(room)) {
            room = "";
        }
        if ("全部".equals(ol)) {
            ol = "";
        }
        if ("".equals(keyword)) {
            keyword = "";
        } else {
            keyword = "%" + keyword + "%";
        }
        JSONObject json = new JSONObject();
        json.put("school", school);
        json.put("house", house);
        json.put("floor", floor);
        json.put("room", room);
        json.put("ol", ol);
        json.put("keyword", keyword);
        json.put("state", "在使用");
        List<ZigBeeGatewayInfo> zigBeeGatewayInfoList = zigBeeGatewayService.selectZigBeeInfoByJsonObject(json);
        int devCount = 0; //设备总数
        int devOnlineCount = 0; //设备在线数
        int devOfflineCount = 0; //设备离线数
        for (int i = 0; i < zigBeeGatewayInfoList.size(); i++) {
            ZigBeeGatewayDevInfo zigBeeGatewayDevInfo = new ZigBeeGatewayDevInfo();
            zigBeeGatewayDevInfo.setZigbeeId(zigBeeGatewayInfoList.get(i).getZigbeeId());
            zigBeeGatewayDevInfo.setEp("1");  //防止多开关重复算入
            List<ZigBeeGatewayDevInfo> zigBeeGatewayDevInfoList = zigBeeGatewayService.selectZigBeeDevInfo(zigBeeGatewayDevInfo);
            if (zigBeeGatewayDevInfoList.size() != 0) {
                devCount = zigBeeGatewayDevInfoList.size();
                for (int j = 0; j < zigBeeGatewayDevInfoList.size(); j++) {
                    if ("true".equals(zigBeeGatewayDevInfoList.get(j).getOl())) {
                        devOnlineCount++;
                    }
                }
                devOfflineCount = devCount - devOnlineCount;
            }
            //设置总数 在线数 离线数
            zigBeeGatewayInfoList.get(i).setDevCount(devCount);
            zigBeeGatewayInfoList.get(i).setDevOnlineCount(devOnlineCount);
            zigBeeGatewayInfoList.get(i).setDevOfflineCount(devOfflineCount);
            //清空计数
            devCount = 0;
            devOnlineCount = 0;
            devOfflineCount = 0;
            //根据区域地点的ID设置地点文字
            if (!"".equals(zigBeeGatewayInfoList.get(i).getSchool()) && null != zigBeeGatewayInfoList.get(i).getSchool()) {
                zigBeeGatewayInfoList.get(i).setSchool(organizeService.queryCurrId(zigBeeGatewayInfoList.get(i).getSchool()).getText());
            }
            if (!"".equals(zigBeeGatewayInfoList.get(i).getHouse()) && null != zigBeeGatewayInfoList.get(i).getHouse()) {
                zigBeeGatewayInfoList.get(i).setHouse(organizeService.queryCurrId(zigBeeGatewayInfoList.get(i).getHouse()).getText());
            }
            if (!"".equals(zigBeeGatewayInfoList.get(i).getFloor()) && null != zigBeeGatewayInfoList.get(i).getFloor()) {
                zigBeeGatewayInfoList.get(i).setFloor(organizeService.queryCurrId(zigBeeGatewayInfoList.get(i).getFloor()).getText());
            }
            if (!"".equals(zigBeeGatewayInfoList.get(i).getRoom()) && null != zigBeeGatewayInfoList.get(i).getRoom()) {
                zigBeeGatewayInfoList.get(i).setRoom(organizeService.queryCurrId(zigBeeGatewayInfoList.get(i).getRoom()).getText());
            }
        }
        return Layui.data(zigBeeGatewayInfoList.size(), zigBeeGatewayInfoList);
    }


    /**
     * @return String
     * @description 详情页的跳转
     * @author dzb
     * @date 2021/7/30 14:59
     */
    @RequestMapping("goZigBeeDevDetail")
    public String goZigBeeDevDetail(HttpServletRequest request, Model model) {
        String zigbeeId = request.getParameter("zigbeeId"); //网关Id
        String devCount = request.getParameter("devCount"); //设备总数
        String devOnlineCount = request.getParameter("devOnlineCount"); //设备在线数
        String devOfflineCount = request.getParameter("devOfflineCount"); //设备离线数

        model.addAttribute("devCount", devCount);
        model.addAttribute("devOnlineCount", devOnlineCount);
        model.addAttribute("devOfflineCount", devOfflineCount);
        model.addAttribute("zigbeeId", zigbeeId);

        return "devManager/zigBeeDevDetailView";
    }

    /**
     * @return
     * @description 详情页中遍历设备，分页查询
     * @params
     * @author dzb
     * @date 2021/8/2 11:47
     */
    @RequestMapping("selectZigBeeDev")
    @ResponseBody
    public List<ZigBeeGatewayDevInfo> selectZigBeeDev(HttpServletRequest request) {
        String zigbeeId = request.getParameter("zigbeeId"); //网关Id
        int page = Integer.valueOf(request.getParameter("page"));
        int limit = Integer.valueOf(request.getParameter("limit"));
        int offset = (page - 1) * limit;
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("zigbeeId", zigbeeId);
        jsonObject.put("ep", "1");
        jsonObject.put("limit", limit);
        jsonObject.put("offset", offset);


        //遍历设备
        List<ZigBeeGatewayDevInfo> zigBeeGatewayDevInfoList = zigBeeGatewayService.selectZigBeeDevInfoByJSON(jsonObject);


        for (int j = 0; j < zigBeeGatewayDevInfoList.size(); j++) {
            //将多路开关信息存入实体类属性DevInfoEps中
            if ("双开关面板".equals(zigBeeGatewayDevInfoList.get(j).getNote())) {
                ZigBeeGatewayDevInfo zigBeeGatewayDevInfo = new ZigBeeGatewayDevInfo();
                zigBeeGatewayDevInfo.setDevId(zigBeeGatewayDevInfoList.get(j).getDevId());
                List<ZigBeeGatewayDevInfo> zigBeeGatewayDevInfos = zigBeeGatewayService.selectZigBeeDevInfo(zigBeeGatewayDevInfo);
                Collections.sort(zigBeeGatewayDevInfos, new Comparator<ZigBeeGatewayDevInfo>() {
                    @Override
                    public int compare(ZigBeeGatewayDevInfo o1, ZigBeeGatewayDevInfo o2) {
                        int a = Integer.parseInt(o1.getEp());
                        int b = Integer.parseInt(o2.getEp());
                        return a - b;
                    }
                });
                zigBeeGatewayDevInfoList.get(j).setDevInfoEps(zigBeeGatewayDevInfos);
            }
            if ("三开关面板".equals(zigBeeGatewayDevInfoList.get(j).getNote())) {
                ZigBeeGatewayDevInfo zigBeeGatewayDevInfo = new ZigBeeGatewayDevInfo();
                zigBeeGatewayDevInfo.setDevId(zigBeeGatewayDevInfoList.get(j).getDevId());
                List<ZigBeeGatewayDevInfo> zigBeeGatewayDevInfos = zigBeeGatewayService.selectZigBeeDevInfo(zigBeeGatewayDevInfo);
                Collections.sort(zigBeeGatewayDevInfos, new Comparator<ZigBeeGatewayDevInfo>() {
                    @Override
                    public int compare(ZigBeeGatewayDevInfo o1, ZigBeeGatewayDevInfo o2) {
                        int a = Integer.parseInt(o1.getEp());
                        int b = Integer.parseInt(o2.getEp());
                        return a - b;
                    }
                });
                zigBeeGatewayDevInfoList.get(j).setDevInfoEps(zigBeeGatewayDevInfos);
            }
            //根据区域地点的ID设置地点文字
            if (!"".equals(zigBeeGatewayDevInfoList.get(j).getSchool()) && null != zigBeeGatewayDevInfoList.get(j).getSchool()) {
                zigBeeGatewayDevInfoList.get(j).setSchool(organizeService.queryCurrId(zigBeeGatewayDevInfoList.get(j).getSchool()).getText());
            } else {
                zigBeeGatewayDevInfoList.get(j).setSchool("");
            }
            if (!"".equals(zigBeeGatewayDevInfoList.get(j).getHouse()) && null != zigBeeGatewayDevInfoList.get(j).getHouse()) {
                zigBeeGatewayDevInfoList.get(j).setHouse(organizeService.queryCurrId(zigBeeGatewayDevInfoList.get(j).getHouse()).getText());
            } else {
                zigBeeGatewayDevInfoList.get(j).setHouse("");
            }
            if (!"".equals(zigBeeGatewayDevInfoList.get(j).getFloor()) && null != zigBeeGatewayDevInfoList.get(j).getFloor()) {
                zigBeeGatewayDevInfoList.get(j).setFloor(organizeService.queryCurrId(zigBeeGatewayDevInfoList.get(j).getFloor()).getText());
            } else {
                zigBeeGatewayDevInfoList.get(j).setFloor("");
            }
            if (!"".equals(zigBeeGatewayDevInfoList.get(j).getRoom()) && null != zigBeeGatewayDevInfoList.get(j).getRoom()) {
                zigBeeGatewayDevInfoList.get(j).setRoom(organizeService.queryCurrId(zigBeeGatewayDevInfoList.get(j).getRoom()).getText());
            } else {
                zigBeeGatewayDevInfoList.get(j).setRoom("");
            }
        }

        return zigBeeGatewayDevInfoList;
    }

    @RequestMapping("goZigBeeEdit")
    public String goZigBeeEdit(String zigbeeId, Model model) {
        //将查出的大学Id作为参数传入 查出校区
        List<EasyTree> schoolList = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0", "").get(0).getId(), "");
        ZigBeeGatewayInfo zigBeeGatewayInfo = zigBeeGatewayService.selectZigBeeInfoByZigbeeId(zigbeeId);

        String school = zigBeeGatewayInfo.getSchool();
        String house = zigBeeGatewayInfo.getHouse();
        String floor = zigBeeGatewayInfo.getFloor();
        String room = zigBeeGatewayInfo.getRoom();
        System.out.println("school:" + school + "   house:" + house + "     floor:" + floor + "    room:" + room);
        if (school == null) {
            house = "";
            floor = "";
            room = "";
        } else {
            if (house == null) {
                floor = "";
                room = "";
            } else {
                if (floor == null) {
                    room = "";
                }
            }
        }
        List<EasyTree> houseList = new ArrayList<>();
        List<EasyTree> floorList = new ArrayList<>();
        List<EasyTree> roomList = new ArrayList<>();
        if (school != "") {
            houseList = organizeService.queryChildenOrganize(school, "");
        }
        if (house != "") {
            floorList = organizeService.queryChildenOrganize(house, "");
        }
        if (floor != "") {
            roomList = organizeService.queryChildenOrganize(floor, "");
        }

        model.addAttribute("schoolList", schoolList);
        model.addAttribute("houseList", houseList);
        model.addAttribute("floorList", floorList);
        model.addAttribute("roomList", roomList);
        model.addAttribute("zigBeeGatewayInfo", zigBeeGatewayInfo);
        return "devManager/zigBeeEditView";
    }

    /**
     * @return JSONObject
     * @description 网关编辑
     * @author dzb
     **/
    @RequestMapping("editZigBee")
    @ResponseBody
    public JSONObject editZigBee(ZigBeeGatewayInfo zigBeeGatewayInfo) {
        System.out.println("将要修改的网关消息：" + zigBeeGatewayInfo.toString());
        int code = zigBeeGatewayService.updateZigBeeGatewayInfo(zigBeeGatewayInfo);
        //修改设备的所在区域
        if (code > 0) {
            ZigBeeGatewayDevInfo zigBeeGatewayDevInfo = new ZigBeeGatewayDevInfo();
            zigBeeGatewayDevInfo.setZigbeeId(zigBeeGatewayInfo.getZigbeeId());
            List<ZigBeeGatewayDevInfo> zigBeeGatewayDevInfoList = zigBeeGatewayService.selectZigBeeDevInfo(zigBeeGatewayDevInfo);
            //注意：不能用zigBeeGatewayDevInfoList.get(i)赋值再更新，因为这是取出所有设备根据devId进行更新，多开开关是相同的devId，所以会更新掉其ep数据，最后TCPService中导致添加重复数据
            for (int i = 0; i < zigBeeGatewayDevInfoList.size(); i++) {
                zigBeeGatewayDevInfo.setDevId(zigBeeGatewayDevInfoList.get(i).getDevId());
                zigBeeGatewayDevInfo.setSchool(zigBeeGatewayInfo.getSchool());
                zigBeeGatewayDevInfo.setHouse(zigBeeGatewayInfo.getHouse());
                zigBeeGatewayDevInfo.setFloor(zigBeeGatewayInfo.getFloor());
                zigBeeGatewayDevInfo.setRoom(zigBeeGatewayInfo.getRoom());
                zigBeeGatewayService.updateZigBeeGatewayDevInfo(zigBeeGatewayDevInfo);
            }
        }


        JSONObject jsonObject = new JSONObject();
        jsonObject.put("code", code);
        jsonObject.put("msg", (code > 0 ? "修改成功" : "修改失败"));
        return jsonObject;
    }

    /**
     * @return jsonObject
     * @description zigbeeId
     * @params 网关删除
     * @author dzb
     * @date 2021/8/5 14:53
     */
    @RequestMapping("delZigBeeGateway")
    @ResponseBody
    public JSONObject delZigBeeGateway(String zigbeeId) {
        //删除网关 ---> 伪删除，改变state状态，加入到回收站
        ZigBeeGatewayInfo zigBeeGatewayInfo = new ZigBeeGatewayInfo();
        zigBeeGatewayInfo.setZigbeeId(zigbeeId);
        zigBeeGatewayInfo.setState("已删除");
        int code = zigBeeGatewayService.updateZigBeeGatewayInfo(zigBeeGatewayInfo);
        //删除设备
        if (code > 0) {
            code = zigBeeGatewayService.delZigBeeGatewayDevInfo(zigbeeId);
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("code", code);
        jsonObject.put("msg", (code > 0 ? "删除成功" : "删除失败"));
        return jsonObject;
    }

    /**
     * @return jsonObject
     * @description zigBeeGatewayInfoList
     * @params 网关批量删除
     * @author dzb
     * @date 2021/8/5 14:53
     */
    @RequestMapping("delSomeZigBee")
    @ResponseBody
    public JSONObject delSomeZigBee(@RequestBody List<ZigBeeGatewayInfo> zigBeeGatewayInfoList) {
        System.out.println("删除的设备集合:" + zigBeeGatewayInfoList.toString());
        int code = 0;
        for (ZigBeeGatewayInfo zigBeeGatewayInfo : zigBeeGatewayInfoList) {
            zigBeeGatewayInfo.setState("已删除");
            code = zigBeeGatewayService.updateZigBeeGatewayInfo(zigBeeGatewayInfo);
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("code", code);
        jsonObject.put("msg", (code > 0 ? "删除成功" : "删除失败"));
        return jsonObject;
    }

    /**
     * @return
     * @description
     * @params
     * @author dzb
     * @date 2021/8/11 14:28
     */
    @RequestMapping("recoverZigBeeGateway")
    @ResponseBody
    public JSONObject recoverZigBeeGateway(String zigbeeId) {
        //恢复网关数据 --->移出回收站
        ZigBeeGatewayInfo zigBeeGatewayInfo = new ZigBeeGatewayInfo();
        zigBeeGatewayInfo.setZigbeeId(zigbeeId);
        zigBeeGatewayInfo.setState("在使用");
        int code = zigBeeGatewayService.updateZigBeeGatewayInfo(zigBeeGatewayInfo);
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("code", code);
        jsonObject.put("msg", (code > 0 ? "恢复成功" : "恢复失败"));
        return jsonObject;
    }


    /**
     * @return devManager/zigBeeDevEditView
     * @description 跳转设备编辑页
     * @author dzb
     * @date 2021/8/3 14:39
     */
    @RequestMapping("goZigBeeDevEdit")
    public String goZigBeeDevEdit(HttpServletRequest request, Model model) {
        String devId = request.getParameter("devId");
        ZigBeeGatewayDevInfo zigBeeGatewayDevInfo = new ZigBeeGatewayDevInfo();
        zigBeeGatewayDevInfo.setDevId(devId);
//        zigBeeGatewayDevInfo.setEp("1");
        //根据devId查出设备信息，传给zigBeeDevEditView页面用于展示数据
        List<ZigBeeGatewayDevInfo> zigBeeGatewayDevInfoList = zigBeeGatewayService.selectZigBeeDevInfo(zigBeeGatewayDevInfo);
        //进行排序
        Collections.sort(zigBeeGatewayDevInfoList, new Comparator<ZigBeeGatewayDevInfo>() {
            @Override
            public int compare(ZigBeeGatewayDevInfo o1, ZigBeeGatewayDevInfo o2) {
                int a = Integer.parseInt(o1.getEp());
                int b = Integer.parseInt(o2.getEp());
                return a - b;
            }
        });

        JSONArray jsonArray = JSONArray.parseArray(JSONArray.toJSONString(zigBeeGatewayDevInfoList));
        model.addAttribute("jsonArray", jsonArray);
        model.addAttribute("zigBeeGatewayDevInfoList", zigBeeGatewayDevInfoList);
        return "devManager/zigBeeDevEditView";
    }

    /**
     * @return JSONObject
     * @description 设备编辑
     * @author dzb
     **/
    @RequestMapping("editZigBeeDev")
    @ResponseBody
    public JSONObject editZigBeeDev(@RequestBody JSONObject jsonZigBeeInfo) {
        String devId = jsonZigBeeInfo.getString("devId");

        JSONArray ep = jsonZigBeeInfo.containsKey("ep") ? jsonZigBeeInfo.getJSONArray("ep") : null;

        JSONArray dn = jsonZigBeeInfo.getJSONArray("dn");
        int code = 0;
        if (ep!=null) {
            for (int i = 0; i < ep.size(); i++) {
                String strEp = (String) ep.get(i);
                String strDn = (String) dn.get(i);
                ZigBeeGatewayDevInfo zigBeeGatewayDevInfo = new ZigBeeGatewayDevInfo();
                zigBeeGatewayDevInfo.setDevId(devId);
                zigBeeGatewayDevInfo.setEp(strEp);
                zigBeeGatewayDevInfo.setDn(strDn);
                System.out.println("需要修改的设备信息：" + zigBeeGatewayDevInfo);
                code = zigBeeGatewayService.updateZigBeeGatewayDevInfo(zigBeeGatewayDevInfo);
            }
        }else {
            ZigBeeGatewayDevInfo zigBeeGatewayDevInfo = new ZigBeeGatewayDevInfo();
            zigBeeGatewayDevInfo.setDevId(devId);
            zigBeeGatewayDevInfo.setDn(dn.toJSONString());
            System.out.println("需要修改的设备信息：" + zigBeeGatewayDevInfo);
            code = zigBeeGatewayService.updateZigBeeGatewayDevInfo(zigBeeGatewayDevInfo);
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("code", code);
        jsonObject.put("msg", (code > 0 ? "修改成功" : "修改失败"));
        return jsonObject;
    }


    /**
     * @description 跳转回收站页面
     * @author dzb
     * @date 2021/8/11 10:12
     */
    @RequestMapping("goZigBeeRecycleBin")
    public String goZigBeeRecycleBin() {
        return "devManager/zigBeeRecycleBinView";
    }

    /**
     * @return Layui.data
     * @description 查询伪删除网关信息
     * @author dzb
     * @date 2021/8/11 9:47
     */
    @RequestMapping("getFalseDelZigBeeInfo")
    @ResponseBody
    public Layui getFalseDelZigBeeInfo(HttpServletRequest request) {

        String keyword = request.getParameter("keyword");

        int page = Integer.valueOf(request.getParameter("page"));
        int limit = Integer.valueOf(request.getParameter("limit"));
        int offset = (page - 1) * limit;

        System.out.println("page:" + page + "   limit：" + limit + "   keyword：" + keyword);
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("offset", offset);
        jsonObject.put("limit", limit);
        if (!"".equals(keyword) && null != keyword) {
            keyword = "%" + keyword + "%";
            jsonObject.put("keyword", keyword);
        }
        jsonObject.put("state", "已删除");
        List<ZigBeeGatewayInfo> zigBeeGatewayInfoList = zigBeeGatewayService.selectZigBeeInfoByJsonObject(jsonObject);
        for (int i = 0; i < zigBeeGatewayInfoList.size(); i++) {
            //根据区域地点的ID设置地点文字
            if (!"".equals(zigBeeGatewayInfoList.get(i).getSchool()) && null != zigBeeGatewayInfoList.get(i).getSchool()) {
                zigBeeGatewayInfoList.get(i).setSchool(organizeService.queryCurrId(zigBeeGatewayInfoList.get(i).getSchool()).getText());
            }
            if (!"".equals(zigBeeGatewayInfoList.get(i).getHouse()) && null != zigBeeGatewayInfoList.get(i).getHouse()) {
                zigBeeGatewayInfoList.get(i).setHouse(organizeService.queryCurrId(zigBeeGatewayInfoList.get(i).getHouse()).getText());
            }
            if (!"".equals(zigBeeGatewayInfoList.get(i).getFloor()) && null != zigBeeGatewayInfoList.get(i).getFloor()) {
                zigBeeGatewayInfoList.get(i).setFloor(organizeService.queryCurrId(zigBeeGatewayInfoList.get(i).getFloor()).getText());
            }
            if (!"".equals(zigBeeGatewayInfoList.get(i).getRoom()) && null != zigBeeGatewayInfoList.get(i).getRoom()) {
                zigBeeGatewayInfoList.get(i).setRoom(organizeService.queryCurrId(zigBeeGatewayInfoList.get(i).getRoom()).getText());
            }
        }
        System.out.println("查出已删除的网关信息：" + zigBeeGatewayInfoList);
        return Layui.data(zigBeeGatewayInfoList.size(), zigBeeGatewayInfoList);
    }
}