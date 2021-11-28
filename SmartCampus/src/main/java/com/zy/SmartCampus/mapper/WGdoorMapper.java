package com.zy.SmartCampus.mapper;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.WGAccessDoorInfo;

import java.util.List;

public interface WGdoorMapper {

    int addDoor(WGAccessDoorInfo wgAccessDoorInfo);
    int delDoor(String ctrlerSN);
    int updateDoor(WGAccessDoorInfo wgAccessDoorInfo);
    List<WGAccessDoorInfo> queryDoor(JSONObject jsonObject);

    List<WGAccessDoorInfo> queryWGDoor (JSONObject jsonObject);
}
