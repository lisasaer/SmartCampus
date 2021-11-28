package com.zy.SmartCampus.service;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.mapper.AirDevMapper;
import com.zy.SmartCampus.mapper.CardMapper;
import com.zy.SmartCampus.polo.AirInfo;
import com.zy.SmartCampus.polo.DevInfo;
import com.zy.SmartCampus.polo.SwitchDevInfo;
import com.zy.SmartCampus.polo.SwitchInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AirDevService {
    @Autowired
    private AirDevMapper airDevMapper;


    //查询全部空调设备
    public List<AirInfo> queryAllAirDev(JSONObject json){return airDevMapper.queryAllAirDev(json);}

    //根据区域查询空调设备
    public List<AirInfo> queryAirDevInfo(JSONObject json){return airDevMapper.queryAirDevInfo(json);}
    //添加开关（2020-8-2,hhp）
    public int addAirDev(AirInfo airInfo){
        return airDevMapper.addAirDev(airInfo);
    }
    //空调uuid校验
    public AirInfo queryAirDevInfoByUuid(String uuId){
        return airDevMapper.queryAirDevInfoByUuid(uuId);
    }


    //更新设备
    public int updateAirDev(AirInfo airInfo){
        return airDevMapper.updateAirDev(airInfo);
    }
    public int delAirDev(AirInfo airInfo){
        return airDevMapper.delAirDev(airInfo);
    }
    public void delAirDevByLoraSN(JSONObject json){
        airDevMapper.delAirDevByLoraSN(json);
    }

    //查询设备数量
    public int queryAirDevCount(JSONObject json){
        return airDevMapper.queryAirDevCount(json);
    }

}
