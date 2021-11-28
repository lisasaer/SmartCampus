package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.HistoryFaceAlarm;
import com.zy.SmartCampus.polo.Staff;
import com.zy.SmartCampus.polo.WGAccessDevInfo;
import com.zy.SmartCampus.polo.WGAccessOpenDoor;
import com.zy.SmartCampus.service.StaffService;
import com.zy.SmartCampus.service.WGAccessDevService;
import com.zy.SmartCampus.service.WGOpenDoorService;
import com.zy.SmartCampus.util.MyUtil;
import com.zy.SmartCampus.util.WGAccessUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.List;

@Controller
public class MainCtrl {
//    @Autowired
//     WGOpenDoorService wgOpenDoorService;
    @Autowired
    private StaffService staffService;

    @RequestMapping("mainPage")
    public ModelAndView mainPage() throws Exception {

//        JSONObject json =new JSONObject();
//        WGAccessOpenDoor wgAccessOpenDoor = new WGAccessOpenDoor();
//        wgAccessOpenDoor.setId("123");
//        wgOpenDoorService.addWGAccessDoorOpen(wgAccessOpenDoor);
        ModelAndView modelAndView = new ModelAndView("mainPage/mainPage");
        JSONObject json = new JSONObject();
        List<HistoryFaceAlarm> list = staffService.selectPicture(json);
        modelAndView.addObject("list",list);
        return modelAndView;
    }
}
