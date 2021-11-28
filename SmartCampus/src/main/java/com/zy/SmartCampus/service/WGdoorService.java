package com.zy.SmartCampus.service;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.WGAccessDoorInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.zy.SmartCampus.mapper.WGdoorMapper;

import java.util.List;


@Service
public class WGdoorService {

    @Autowired
    public WGdoorMapper wGdoorMapper;

    public int addDoor(WGAccessDoorInfo wgAccessDoorInfo){
        return wGdoorMapper.addDoor(wgAccessDoorInfo);
    }
    public int updateDoor(WGAccessDoorInfo wgAccessDoorInfo){ return wGdoorMapper.updateDoor(wgAccessDoorInfo); }
    public List<WGAccessDoorInfo> queryDoor(JSONObject jsonObject){
        return wGdoorMapper.queryDoor(jsonObject);
    }
    public int delDoor (String ctrlerSN){
        return wGdoorMapper.delDoor(ctrlerSN);
    }

    public List<WGAccessDoorInfo> queryWGDoor (JSONObject jsonObject){
        return wGdoorMapper.queryWGDoor(jsonObject);
    }
}
