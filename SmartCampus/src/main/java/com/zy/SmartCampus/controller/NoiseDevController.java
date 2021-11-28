package com.zy.SmartCampus.controller;

import com.zy.SmartCampus.lorasearch.BeanContext;
import com.zy.SmartCampus.lorasearch.LoraMsgUtil;
import com.zy.SmartCampus.lorasearch.LoraPortUtil;
import com.zy.SmartCampus.polo.EasyTree;
import com.zy.SmartCampus.polo.SwitchDevInfo;
import com.zy.SmartCampus.service.OrganizeService;
import com.zy.SmartCampus.service.SwitchDevService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
public class NoiseDevController {

    public static String msg;
    @Autowired
    private OrganizeService organizeService;

    /**
     * 噪声传感器 页面初始化
     * @return
     */
    @RequestMapping("goNoiseDev")
    public ModelAndView goNoiseDev() {
        ModelAndView modelAndView = new ModelAndView("noiseDev/noiseDevManagerView");
        List<EasyTree> schoolList = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        modelAndView.addObject("schoolList",schoolList);
        return modelAndView;
    }



    @RequestMapping("noiseRealDataView")
    public ModelAndView noiseRealDataView() {
        ModelAndView modelAndView = new ModelAndView("noiseDev/noiseRealDataView");
        List<EasyTree> schoolList = organizeService.queryChildenOrganize(
                organizeService.queryChildenOrganize("0","").get(0).getId(),"");
        modelAndView.addObject("schoolList",schoolList);
        return modelAndView;
    }

    //设置噪声传感器设备方法
    public  static Boolean   setNoiseDev (String thisLoraSN)throws InterruptedException{

        String sensor;
        String chnList;

        msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                "<SET_SENSOR_REQ>" +
                "<id>"+thisLoraSN+"</id>" +
                "<count>1"+"</count>" +
                "<list>";

        sensor="<sensor>";
        sensor=sensor+"<uuid>000006"+"</uuid>";
        sensor=sensor+"<sensor_type>18</sensor_type>"+"<port>0</port>";
        sensor=sensor+"<interval>0"+"</interval>";
        sensor=sensor+"<chn_cnt>1"+"</chn_cnt>";
        sensor=sensor+"<chn_list>";
        chnList="<chn>";
        chnList=chnList+"<chn_type>20</chn_type>"+"<thr>0</thr>";
        chnList=chnList+"</chn>";
        sensor=sensor+chnList;
        msg=msg+sensor+"</chn_list>" + "</sensor>";

        msg=msg+"</list>" +
                "</SET_SENSOR_REQ>";
        LoraMsgUtil.SendLoraData(thisLoraSN,"41","18");
        return LoraPortUtil.boolSet;
    }

    /**
     * 设置噪音传感器方法*/
    @RequestMapping("setNoiseAlarmValue")
    @ResponseBody
    public Boolean setNoiseAlarmValue(String noiseAlarmValue) throws InterruptedException {
        if (noiseAlarmValue != null){
            msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                    "<SRV_SET_NOISE_ALARM_THR_REQ>" +
                    "<id>7542012110002"+"</id>" +
                    "<uuid>000006</uuid>" +
                    "<thr>"+noiseAlarmValue+"</thr>" +
                    "</SRV_SET_NOISE_ALARM_THR_REQ>";

            LoraMsgUtil.SendLoraData("7542012110002","4b","");
        }

        return LoraPortUtil.receiveStatus;
    }
}
