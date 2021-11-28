package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.serialport.SerialPortUtils;
import com.zy.SmartCampus.service.TestService;
import com.zy.SmartCampus.util.CRC16Util;
import com.zy.SmartCampus.util.MyHttpRequestUtil;
import com.zy.SmartCampus.util.YSUtil;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class TestCtrl {

    @Autowired
    private TestService testService;

    @RequestMapping("test")
    public String test(Model model){
        model.addAttribute("accessToken",YSUtil.checkYSAccessToken());
        return  "test";
    }

    @RequestMapping("wstest")
    public String wstest(Model model){
        model.addAttribute("openState",SerialPortUtils.getInstance().isbOpen());
        model.addAttribute("comNameList", SerialPortUtils.getCOMNameStringList());

        if(SerialPortUtils.getInstance().isbOpen()){
            model.addAttribute("serialPortName",SerialPortUtils.getInstance().getCurrSerialPortName());
            System.out.println(SerialPortUtils.getInstance().getCurrSerialPortName());
        }
        return "wstest";
    }

    @RequestMapping("loratest")
    public String loratest(){
        return "loratest";
    }

    @RequestMapping("testduankou")
    @ResponseBody
    public String testduankou(String data){
        //System.out.printf("testduankou");
        data += CRC16Util.getCRC(data);
        //System.out.println("当前线程ID:"+Thread.currentThread().getId());
        SerialPortUtils.getInstance().sendComm(data);
        //SerialPortUtils.getInstance().readComm(MyUtil.getUUID());
        return "succ";
    }

    @RequestMapping("setTTS")
    @ResponseBody
    public String setTTS(String tts){
        JSONObject json = new JSONObject();
        json.put("msgType","setTTS");
        json.put("tts",tts);
        return  MyHttpRequestUtil.httpPostRequest("http://192.168.0.123:8083/test",json.toJSONString());
    }

    @RequestMapping("testAndServer")
    @ResponseBody
    public String testAndServer(@RequestBody String strBody){
        System.out.println(strBody);
        JSONObject json = new JSONObject();
        json.put("msgType","test");
        return MyHttpRequestUtil.httpPostRequest("http://192.168.0.123:8083/test",json.toJSONString());
    }

    @RequestMapping("testys")
    public String testys(Model model){
        model.addAttribute("accessToken",YSUtil.checkYSAccessToken());
        return  "testys";
    }

    @RequestMapping("testGetToken")
    @ResponseBody
    public String testGetToken() {
        return YSUtil.checkYSAccessToken();
    }

    @RequestMapping("testGetMysqlVersion")
    @ResponseBody
    public String testGetMysqlVersion() {
        return testService.getMysqlVersion();
    }


    //wpp-2020-3-10 websdk
    @RequestMapping("websdk")
    public String websdk(){return "websdk";}

}
