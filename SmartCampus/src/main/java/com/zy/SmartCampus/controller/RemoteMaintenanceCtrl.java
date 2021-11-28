package com.zy.SmartCampus.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

//远程维护
@Controller
public class RemoteMaintenanceCtrl {
    //空调远程维护
    @RequestMapping("airConditionRemote")
    public String airCondionRemote(){return "remoteMaintenance/airConditionRemote";}

    //空开远程维护
    @RequestMapping("airSwitchRemote")
    public String airSwitchRemote(){return "remoteMaintenance/airSwitchRemote";}
}
