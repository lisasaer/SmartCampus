package com.zy.SmartCampus.mapper;


import com.alibaba.fastjson.JSONObject;
import com.google.gson.JsonObject;
import com.zy.SmartCampus.polo.AirInfo;
import com.zy.SmartCampus.polo.DevInfo;
import com.zy.SmartCampus.polo.EasyTree;
import com.zy.SmartCampus.polo.SwitchInfo;

import java.util.List;

public interface DevMapper {

    //删除设备
    int delDev(String id);
    //查找设备
    List<DevInfo> queryDev(JSONObject json);
    //查找设备数量
    int queryDevCount(JSONObject json);
    //添加设备
    int insertDev(DevInfo devInfo);
    //查找设备
    DevInfo queryOneDev(String id);
    //查找设备by 设备id
    DevInfo queryDevByDevId(String devId);
    //更新设备
    int updateDev(DevInfo devInfo);



    //========================== dev switch line ===========================

    //查询开关
    List<SwitchInfo> querySwitch(JSONObject json);
    //添加开关
    int insertSwitch(SwitchInfo switchInfo);
    //删除开关
    int delSwitch(String devSN);
    //更新开关
    int updateSwitch(SwitchInfo switchInfo);

    //更新开关状态(HHP)
    int updateSwitchStatus(SwitchInfo switchInfo);
    //更新合关闸时间(HHP)
    int updateRecordTime(SwitchInfo switchInfo);

    //  更新从机地址dev_info,switch_info,switch_info_history表(2020-5-13,HHP)
    int updateDevId(DevInfo devInfo);
    int updateSwitchDevId(DevInfo devInfo);
    int updateHistoryDevId(DevInfo devInfo);


    //根据空开线路地址和空开设备ID查询空开线路详细信息(2020-5-11,HHP)
    List<SwitchInfo> queryDetailByDevId(JSONObject json);

    // 更新实时信息表信息(2020-5-11，HHP)
    int updateNewData(SwitchInfo switchInfo);
    // 在历史信息表中插入信息 (2020-5-11，HHP)
    int insertToHistory(SwitchInfo switchInfo);

    List<DevInfo> queryDevByTree(JSONObject json);

    //========================== dev air line ===========================(2020-5-14，HHP)
    //查询air_info信息
    List<AirInfo> queryAir(JSONObject json);
    //更新继电器状态和时间(HHP)
    int updateAirStatus(AirInfo airInfo);
    // 更新实时信息表信息(2020-5-14，HHP)
    int updateAirNewData(AirInfo airInfo);
    //根据空调设备ID查询空调详细信息(2020-5-14,HHP)
    List<AirInfo> queryAirDetailByDevId(JSONObject json);

    // 在历史信息表中插入信息 (2020-5-14，HHP)
    int insertAirToHistory(AirInfo airInfo);
    //更新空调从机地址
    int updateAirInfoDevId(AirInfo airInfo);
    int updateAirDevId(AirInfo airInfo);
    int updateAirHistoryDevId(AirInfo airInfo);

}
