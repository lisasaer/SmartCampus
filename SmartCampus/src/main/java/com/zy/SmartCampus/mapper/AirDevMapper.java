package com.zy.SmartCampus.mapper;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.AirInfo;
import com.zy.SmartCampus.polo.DevInfo;
import com.zy.SmartCampus.polo.SwitchDevInfo;
import com.zy.SmartCampus.polo.SwitchInfo;

import java.util.List;

public interface AirDevMapper {


    //查询全部空调设备
    List<AirInfo> queryAllAirDev(JSONObject json);

    //根据区域查询空调设备
    List<AirInfo> queryAirDevInfo(JSONObject json);

    //添加开关
    int addAirDev(AirInfo airInfo);
    //查找设备byUUid
    AirInfo queryAirDevInfoByUuid(String uuid);
    int updateAirDev(AirInfo airInfo);
    int delAirDev(AirInfo airInfo);
    void delAirDevByLoraSN(JSONObject json);

    //查询设备数量
    int queryAirDevCount(JSONObject json);

}
