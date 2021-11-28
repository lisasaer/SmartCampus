package com.zy.SmartCampus.service;

import com.alibaba.fastjson.JSONObject;
import com.google.gson.JsonObject;
import com.zy.SmartCampus.mapper.DevMapper;
import com.zy.SmartCampus.polo.AirInfo;
import com.zy.SmartCampus.polo.DevInfo;
import com.zy.SmartCampus.polo.SwitchInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DevService {

    @Autowired
    private DevMapper devMapper;

    //查找设备
    public List<DevInfo> queryDev(JSONObject json){
        return devMapper.queryDev(json);
    }

    //查找设备数量
    public int queryDevCount(JSONObject json){
        return devMapper.queryDevCount(json);
    }

    //添加设备
    public int insertDev(DevInfo devInfo){
        return devMapper.insertDev(devInfo);
    }

    public DevInfo queryOneDev(String id){
        return devMapper.queryOneDev(id);
    }

    //删除设备
    public int delDev(String id){
        return devMapper.delDev(id);
    }


    public DevInfo queryDevByDevId(String devId){
        return devMapper.queryDevByDevId(devId);
    }

    //更新设备
    public int updateDev(DevInfo devInfo){
        return devMapper.updateDev(devInfo);
    }

    //========================== dev switch line ===========================

    //查询开关
    public List<SwitchInfo> querySwitch(JSONObject json){
        return devMapper.querySwitch(json);
    }

    //添加开关
    public int insertSwitch(SwitchInfo switchInfo){
        return devMapper.insertSwitch(switchInfo);
    }

    //删除开关
    public int delSwitch(String devSN){
        return devMapper.delSwitch(devSN);
    }

    //更新开关
    public int updateSwitch(SwitchInfo switchInfo){
        return devMapper.updateSwitch(switchInfo);
    }

    //更新开关状态(HHP)
    public int updateSwitchStatus(SwitchInfo switchInfo){
        return devMapper.updateSwitchStatus(switchInfo);
    }
    //更新合关闸时间(HHP)
    public int updateRecordTime(SwitchInfo switchInfo){
        return devMapper.updateRecordTime(switchInfo);
    }
    //更新从机地址(HHP)
    public int updateDevId(DevInfo devInfo){
        return devMapper.updateDevId(devInfo);
    }
    public int updateSwitchDevId(DevInfo devInfo){
        return devMapper.updateSwitchDevId(devInfo);
    }
    public int updateHistoryDevId(DevInfo devInfo){
        return devMapper.updateHistoryDevId(devInfo);
    }

    //根据空开线路地址和空开设备ID查询空开线路详细信息(2020-5-11,HHP)
    public List<SwitchInfo> queryDetailByDevId(JSONObject json){
        return devMapper.queryDetailByDevId(json);
    }

    // 更新实时信息表信息(2020-5-11，HHP)
    public int updateNewData(SwitchInfo switchInfo){
        return devMapper.updateNewData(switchInfo);
    }

    // 在历史信息表中插入信息 (2020-5-11，HHP)
    public int insertToHistory(SwitchInfo switchInfo){
        return devMapper.insertToHistory(switchInfo);
    }

    public List<DevInfo> queryDevByTree(JSONObject json){ return devMapper.queryDevByTree(json);}

    //========================== dev air line ===========================(2020-5-14，HHP)
    //查询air_info信息
    public List<AirInfo> queryAir(JSONObject json){
        return devMapper.queryAir(json);
    }

    //更新继电器状态和时间
    public int updateAirStatus(AirInfo airInfo){return devMapper.updateAirStatus(airInfo); }


    // 更新实时信息表信息(2020-5-14，HHP)
    public int updateAirNewData(AirInfo airInfo){
        return devMapper.updateAirNewData(airInfo);
    }

    //根据空调设备ID查询空调详细信息(2020-5-14,HHP)
    public List<AirInfo> queryAirDetailByDevId(JSONObject json){
        return devMapper.queryAirDetailByDevId(json);
    }


    // 在历史信息表中插入信息 (2020-5-14，HHP))
    public int insertAirToHistory(AirInfo airInfo){
        return devMapper.insertAirToHistory(airInfo);
    }
    //更新空调从机地址
    public int updateAirInfoDevId(AirInfo airInfo){
        return devMapper.updateAirInfoDevId(airInfo);
    }
    public int updateAirDevId(AirInfo airInfo){
        return devMapper.updateAirDevId(airInfo);
    }
    public int updateAirHistoryDevId(AirInfo airInfo){
        return devMapper.updateAirHistoryDevId(airInfo);
    }


}
