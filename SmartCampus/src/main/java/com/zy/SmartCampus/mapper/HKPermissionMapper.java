package com.zy.SmartCampus.mapper;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.HistoryFaceAlarm;
import com.zy.SmartCampus.polo.HKPermisson;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HKPermissionMapper {
    public List<HKPermisson> getAllPermission();
    public List<HKPermisson> queryPermissionAll(JSONObject json);

    public void insertPermission(HKPermisson hkPermisson);

    public int getCount();

    public List<HistoryFaceAlarm> getHistoryFaceAlarm();
    void deletePermission(String cardId);
    List<HKPermisson>  getPermissionByCardNo(String cardId);
    List<HKPermisson>  getPermissionByDevId(int devId);
    List<HKPermisson>  getPermissionByDevIP(String devIP);
}