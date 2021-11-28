package com.zy.SmartCampus.service;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.mapper.HKPermissionMapper;
import com.zy.SmartCampus.polo.HKPermisson;
import com.zy.SmartCampus.polo.HistoryFaceAlarm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class HKPermissionService {

    @Autowired
    private HKPermissionMapper permissionMapper;

    public List<HKPermisson> getAllPermission(){
        return  permissionMapper.getAllPermission();
    }
    public List<HKPermisson> queryPermissionAll(JSONObject json){
        return  permissionMapper.queryPermissionAll(json);
    }

    public void insertPermission(HKPermisson hkPermisson){
        permissionMapper.insertPermission(hkPermisson);
    }

    public int getCount(){
        return permissionMapper.getCount();
    }

    public List<HistoryFaceAlarm> getHistoryFaceAlarm(){
        return permissionMapper.getHistoryFaceAlarm();
    }

    public void deletePermission(String cardId){
        permissionMapper.deletePermission(cardId);
    }

    public List<HKPermisson>  getPermissionByCardNo(String cardId){
        return permissionMapper.getPermissionByCardNo(cardId);
    }

    public List<HKPermisson>  getPermissionByDevId(int devId){
        return permissionMapper.getPermissionByDevId(devId);
    }

    public List<HKPermisson>  getPermissionByDevIP(String devIP){
        return permissionMapper.getPermissionByDevIP(devIP);
    }
 }
