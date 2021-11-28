package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.serialport.ParamConfig;
import com.zy.SmartCampus.serialport.SerialPortUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;

@Controller
public class SerialPortCtrl {


    @RequestMapping("serialPortSettingView")
    public ModelAndView serialPortSettingView(){
        ModelAndView modelAndView = new ModelAndView();

        modelAndView.addObject("test","tttt");
        modelAndView.addObject("openState", SerialPortUtils.getInstance().isbOpen());
        modelAndView.addObject("comNameList",SerialPortUtils.getCOMNameStringList());
        if(SerialPortUtils.getInstance().isbOpen()){
            modelAndView.addObject("comName",SerialPortUtils.getInstance().getCurrSerialPortName());
        }

        modelAndView.setViewName("devManager/serialPortSettingView");
        return modelAndView;
    }

    @RequestMapping("getSerialPortInfo")
    @ResponseBody
    public JSONObject getSerialPortInfo(){
        JSONObject json = new JSONObject();
        json.put("comName", SerialPortUtils.getCOMNameString());
        json.put("openState",SerialPortUtils.getInstance().isbOpen());
        return json;
    }

    @RequestMapping("serialportSetting")
    @ResponseBody
    public JSONObject serialportSetting(String data, HttpSession session){
        JSONObject jsonRet = new JSONObject();
        if(data == null || data.length() < 1){
            jsonRet.put("code",-1);
            jsonRet.put("msg","param not complete 1");
            return jsonRet;
        }

        System.out.println(data);
        JSONObject json = JSONObject.parseObject(data);
        //{"comName":"COM1","btl":"9600","msg":"open"}
        if(!json.containsKey("msg")) {
            jsonRet.put("code", -1);
            jsonRet.put("msg","param not complete 2");
            return jsonRet;
        }

        String msg = json.getString("msg");
        if(msg.equals("open")){
            ParamConfig paramConfig = new ParamConfig(json.getString("comName"),
                    Integer.parseInt(json.getString("btl")),
                    0, 8, 1);

            if(SerialPortUtils.getInstance().isbOpen()){
                jsonRet.put("code",-1);
                jsonRet.put("msg","串口已打开");
                return jsonRet;
            }

            // 初始化设置,打开串口，开始监听读取串口数据
            SerialPortUtils.getInstance().init(paramConfig);
            boolean bOpen = SerialPortUtils.getInstance().isbOpen();

            jsonRet.put("code",(bOpen?1:-1));
            jsonRet.put("msg",(bOpen?"串口打开成功":"串口打开失败"));
            session.setAttribute("comOpen",bOpen);
        }else if (msg.equals("close")){
            SerialPortUtils.getInstance().closeSerialPort();
            boolean bOpen = SerialPortUtils.getInstance().isbOpen();

            jsonRet.put("code",(bOpen?-1:1));
            jsonRet.put("msg",(!bOpen?"串口关闭成功":"串口关闭失败"));
            session.setAttribute("comOpen",bOpen);
        }


        return jsonRet;
    }

}
