package com.zy.SmartCampus.controller;

import com.zy.SmartCampus.polo.Layui;
import com.zy.SmartCampus.service.CardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

@Controller
public class CardController {
    @Autowired
    public CardService cardService;

    @RequestMapping("goCard")
    public String goCard() {
        return "doorDevHK/card";
    }

    @RequestMapping("selectAllCard")
    @ResponseBody
    public Layui selectAllCard(@RequestParam Map map) {
        return cardService.selectAllCard(map);
    }
}
