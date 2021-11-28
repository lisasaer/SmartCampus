package com.zy.SmartCampus.service;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.mapper.WGOpenDoorMapper;
import com.zy.SmartCampus.polo.Staff;
import com.zy.SmartCampus.polo.WGAccessOpenDoor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WGOpenDoorService {
    @Autowired
    private WGOpenDoorMapper wgOpenDoorMapper;

    public int addWGAccessDoorOpen(WGAccessOpenDoor wgAccessOpenDoor){ return wgOpenDoorMapper.addWGAccessDoorOpen(wgAccessOpenDoor);}

    public int addTodayWGAccessDoorOpen(WGAccessOpenDoor wgAccessOpenDoor){ return wgOpenDoorMapper.addTodayWGAccessDoorOpen(wgAccessOpenDoor);}

    public Staff queryUserNameByCardId(JSONObject jsonObject){
        return wgOpenDoorMapper.queryUserNameByCardId(jsonObject);
    }

    public List<WGAccessOpenDoor> queryWGOpenDoor(JSONObject jsonObject){ return wgOpenDoorMapper.queryWGOpenDoor(jsonObject);}

    public int queryWGOpenDoorCount(JSONObject jsonObject){ return wgOpenDoorMapper.queryWGOpenDoorCount(jsonObject);}
    //实时监控用到
    public List<WGAccessOpenDoor> queryRealTimeOpenDoor(JSONObject jsonObject){ return wgOpenDoorMapper.queryRealTimeOpenDoor(jsonObject);}

    public int getwgAccessDevRealCount(JSONObject jsonObject){return wgOpenDoorMapper.getwgAccessDevRealCount(jsonObject);}
}
