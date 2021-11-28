package com.zy.SmartCampus.mapper;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.LoraDevInfo;
import com.zy.SmartCampus.polo.SwitchDevInfo;
import com.zy.SmartCampus.polo.SwitchInfo;

import java.util.List;

public interface switchDevMapper {

    //添加空开设备（2020-5-28，zyw）
    int addSwitchDev(SwitchDevInfo switchDevinfo);

    //修改空开设备（2020-5-28，zyw）
    int updateSwitchDev(SwitchDevInfo switchDevinfo);

    //查询空开设备信息（2020-5-28，zyw）
    List<SwitchDevInfo> queryswitchDevInfo(JSONObject json);

    //查询空开设备数量
    int queryswitchDevCount(JSONObject json);

    //根据通讯地址查询空开设备
    List<SwitchDevInfo> queryDevByUuid(String uuid);

    //根据loraSN查询空开设备
    List<SwitchDevInfo> queryDevByloraSN(String loraSN);

    //根据loraSN查询空开设备
    List<SwitchDevInfo> queryswitchDevByloraSN(JSONObject json);

    //根据区域查询空开设备
    List<SwitchDevInfo> queryswitchDevByArea(JSONObject json);

    //查询空开设备Lora序列号（2020-5-28，zyw）
    List<LoraDevInfo> queryswitchLoraSN(JSONObject json);

    //根据Lora序列号查询终端通道数量（2020-5-28，zyw）
    List<SwitchDevInfo> querySwitchGroupNum(String loraSN);

    //删除设备
    int delSwitchDev(JSONObject json);

    //查找设备by 设备id
    SwitchDevInfo queryDevByDevId(int devId);

    //查找设备byUUid
    SwitchDevInfo queryDevInfoByUuid(String uuid);

    //添加开关
    int addSwitch(SwitchInfo switchInfo);

    //查询开关
    List<SwitchInfo> querySwitch(JSONObject json);

    //查询开关数量
    int querySwitchCount(JSONObject json);


    //更新开关
    int updateSwitch(SwitchInfo switchInfo);
    int updateSwitchInfo(SwitchInfo switchInfo);
    //删除开关
    int deleteSwitch(JSONObject json);
    //根据开关地址（switchAddress）查询开关
    SwitchInfo querySwitchByAddress(JSONObject json);
    //根据空开线路地址和空开设备ID查询空开线路详细信息(2020-5-11,HHP)
    List<SwitchInfo> queryDetailByDevId(JSONObject json);
    // 更新实时信息表信息(2020-5-11，HHP)
    int updateNewData(SwitchInfo switchInfo);
    // 在历史信息表中插入信息
    int addSwitchDataToHistory(SwitchInfo switchInfo);
    //查询当天的总功耗
    List<SwitchInfo> querySwitchPower(JSONObject json);
    int updateSwitchDevByLoraSN(LoraDevInfo loraDevInfo);
}
