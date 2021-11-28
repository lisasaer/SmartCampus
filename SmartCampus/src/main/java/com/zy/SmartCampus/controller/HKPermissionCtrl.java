package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.HistoryFaceAlarm;
import com.zy.SmartCampus.polo.Layui;
import com.zy.SmartCampus.polo.HKPermisson;
import com.zy.SmartCampus.service.HKPermissionService;
import com.zy.SmartCampus.util.MyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Controller
public class HKPermissionCtrl {

    @Autowired
    private HKPermissionService permissionService;

    @RequestMapping("getAllPermission")
    @ResponseBody
    public Layui getAllPermission(HttpServletRequest request){

        int page = Integer.valueOf(request.getParameter("page")) ;
        int limit = Integer.valueOf(request.getParameter("limit"));
        int offset = (page-1)*limit;
        String name = request.getParameter("name");

        String cardNo = request.getParameter("cardNo");
        String dname = request.getParameter("dname");
        String dip = request.getParameter("dip");
//        String workState = request.getParameter("workState");

        JSONObject json = new JSONObject();

        json.put("offset", String.valueOf(offset));
        json.put("limit", String.valueOf(limit));
        json.put("name",name);
//        json.put("staffId",staffId);
        json.put("cardNo",cardNo);
        json.put("dname",dname);
        json.put("dip",dip);
//        System.out.println("456"+json);
//        json.put("workState",workState);
        List<HKPermisson> HKPermissonList = permissionService.queryPermissionAll(json);
        //MyUtil.printfInfo(HKPermissonList.size()+"\n"+HKPermissonList);
        return Layui.data(HKPermissonList.size(), HKPermissonList);
    }

    @RequestMapping("getCount")
    @ResponseBody
    public void getCount(){
        MyUtil.printfInfo(permissionService.getCount()+"");
    }

    @RequestMapping("getHistoryFaceAlarm")
    @ResponseBody
    public  Layui getHistoryFaceAlarm(){
        List<HistoryFaceAlarm> list = permissionService.getHistoryFaceAlarm();
        return Layui.data(list.size(),list);
    }
}
