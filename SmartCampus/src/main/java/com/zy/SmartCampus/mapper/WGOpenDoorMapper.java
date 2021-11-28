package com.zy.SmartCampus.mapper;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.Staff;
import com.zy.SmartCampus.polo.WGAccessOpenDoor;

import java.util.List;

public interface WGOpenDoorMapper {
    int addWGAccessDoorOpen(WGAccessOpenDoor wgAccessOpenDoor);

    int addTodayWGAccessDoorOpen(WGAccessOpenDoor wgAccessOpenDoor);
    List<WGAccessOpenDoor> queryWGOpenDoor(JSONObject jsonObject);

    int queryWGOpenDoorCount(JSONObject jsonObject);
    //实时监控用到
    List<WGAccessOpenDoor> queryRealTimeOpenDoor(JSONObject jsonObject);

    int getwgAccessDevRealCount(JSONObject jsonObject);
    Staff queryUserNameByCardId(JSONObject jsonObject);

}
