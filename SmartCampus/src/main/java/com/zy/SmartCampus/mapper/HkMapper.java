package com.zy.SmartCampus.mapper;

import com.zy.SmartCampus.polo.HistoryFaceAlarm;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;


@Repository
public interface HkMapper {

    public void insertFaceAlarm(Map<String,Object> map);
    public void insertHistoryFaceAlarm(Map<String,Object> map);
    Map<String, String> getFaceAlarmInfo(String strCardNo);

    List<HistoryFaceAlarm> queryDate();
    void deleteRealRecord();
}