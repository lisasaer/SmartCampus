package com.zy.SmartCampus.service;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.mapper.switchDevMapper;
import com.zy.SmartCampus.polo.LoraDevInfo;
import com.zy.SmartCampus.polo.SwitchDevInfo;
import com.zy.SmartCampus.polo.SwitchInfo;
import com.zy.SmartCampus.util.MyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class SwitchDevService {
    @Autowired
    private switchDevMapper switchDevmapper;

    //添加空开设备（2020-5-28，zyw）
    public int addSwitchDev(SwitchDevInfo switchDevinfo){return switchDevmapper.addSwitchDev(switchDevinfo);}

    //修改空开设备（2020-5-28，zyw）
    public int updateSwitchDev(SwitchDevInfo switchDevinfo){return switchDevmapper.updateSwitchDev(switchDevinfo);}

    //查询空开设备信息（2020-5-28，zyw）
    public List<SwitchDevInfo> queryswitchDevInfo(JSONObject json){return switchDevmapper.queryswitchDevInfo(json);}

    //查询空开设备的设备数量
    public int queryswitchDevCount(JSONObject json){return switchDevmapper.queryswitchDevCount(json);}

    //根据通讯地址查询空开设备
    public List<SwitchDevInfo> queryDevByUuid(String uuid){return switchDevmapper.queryDevByUuid(uuid);}

    //根据设备序列号查询空开设备
    public List<SwitchDevInfo> queryDevByloraSN(String loraSN){
        return switchDevmapper.queryDevByloraSN(loraSN);}

    //根据区域查询空开设备
    public List<SwitchDevInfo> queryswitchDevByArea(JSONObject json){return switchDevmapper.queryswitchDevByArea(json);}


    //查询空开设备Lora序列号（2020-5-28，zyw）
    public List<LoraDevInfo> queryswitchLoraSN(JSONObject json){return switchDevmapper.queryswitchLoraSN(json);}

    //根据Lora序列号查询终端通道数量（2020-5-28，zyw）
    public List<SwitchDevInfo> querySwitchGroupNum(String loraSN){return switchDevmapper.querySwitchGroupNum(loraSN);}

    //删除设备
    public int delSwitchDev(JSONObject json){return switchDevmapper.delSwitchDev(json);}

    public SwitchDevInfo queryDevByDevId(int devId){
        return switchDevmapper.queryDevByDevId(devId);
    }
    public SwitchDevInfo queryDevInfoByUuid(String uuId){
        return switchDevmapper.queryDevInfoByUuid(uuId);
    }

    //添加开关（2020-6-22，zyw）
    public int addSwitch(SwitchInfo switchInfo){
        return switchDevmapper.addSwitch(switchInfo);}
    //查询开关
    public List<SwitchInfo> querySwitch(JSONObject json){
        return switchDevmapper.querySwitch(json);
    }
    //查询开关数量
    public int querySwitchCount(JSONObject json){
        return switchDevmapper.querySwitchCount(json);
    }

    //更新开关
    public int updateSwitch(SwitchInfo switchInfo){
        return switchDevmapper.updateSwitch(switchInfo);
    }
    public int updateSwitchInfo(SwitchInfo switchInfo){
        return switchDevmapper.updateSwitchInfo(switchInfo);
    }
    //删除开关
    public int deleteSwitch(JSONObject json){return switchDevmapper.deleteSwitch(json);}
    //根据开关地址（switchAddress）查询开关
    public SwitchInfo querySwitchByAddress(JSONObject json){ return switchDevmapper.querySwitchByAddress(json);}
    //根据空开线路地址和空开设备ID查询空开线路详细信息(2020-5-11,HHP)
    public List<SwitchInfo> queryDetailByDevId(JSONObject json){
        return switchDevmapper.queryDetailByDevId(json);
    }
    // 更新实时信息表信息(2020-5-11，HHP)
    public int updateNewData(SwitchInfo switchInfo){
        //System.out.println("已刷新"+switchInfo);
        return switchDevmapper.updateNewData(switchInfo);
    }
    // 在历史信息表中插入信息
    public int addSwitchDataToHistory(SwitchInfo switchInfo){
        //System.out.println("已存入"+switchInfo);
        return switchDevmapper.addSwitchDataToHistory(switchInfo);
    }
    //查询当日的空开总功耗
    public List<SwitchInfo> querySwitchPower(JSONObject json){
        return switchDevmapper.querySwitchPower(json);
    }
    public int updateSwitchDevByLoraSN(LoraDevInfo loraDevInfo){return switchDevmapper.updateSwitchDevByLoraSN(loraDevInfo);}
}
