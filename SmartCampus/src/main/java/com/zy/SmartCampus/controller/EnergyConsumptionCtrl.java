package com.zy.SmartCampus.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

//能耗统计
@Controller
public class EnergyConsumptionCtrl {
    @RequestMapping("energyConsumption")
    public String energyConsumption(){return "energyConsumption/energyConsumption";}
}
