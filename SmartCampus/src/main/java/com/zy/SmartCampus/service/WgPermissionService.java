package com.zy.SmartCampus.service;

import com.alibaba.fastjson.JSONObject;
import com.google.gson.JsonObject;
import com.zy.SmartCampus.mapper.HKPermissionMapper;
import com.zy.SmartCampus.mapper.WgPermissionMapper;
import com.zy.SmartCampus.polo.CardDeviceBean;
import com.zy.SmartCampus.polo.PermissionInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WgPermissionService {

    @Autowired
    private WgPermissionMapper wgPermissionMapper;

    //增加权限
    public void addWgPermission(String cardNo, String wgSNAndDoorID){

        wgPermissionMapper.addWgPermission(cardNo,wgSNAndDoorID);
    }
    //删除权限
    public void delWgPermission(String cardNo, String wgSNAndDoorID){
        wgPermissionMapper.delWgPermission(cardNo,wgSNAndDoorID);
    }
    //删除全部权限
    public void delWgAllPermission(String ctrlerSN){
        wgPermissionMapper.delWgAllPermission(ctrlerSN);
    }
    public List<PermissionInfo> getWGPermission(JSONObject jsonObject){
        return wgPermissionMapper.getWGPermission(jsonObject);
    }
    public List<PermissionInfo> getWGPermissionByCardNo(JSONObject jsonObject){
        return wgPermissionMapper.getWGPermissionByCardNo(jsonObject);
    }
    public List<PermissionInfo> getWGPermissionByJSON(JSONObject jsonObject){
        return wgPermissionMapper.getWGPermissionByJSON(jsonObject);
    }
    public PermissionInfo getWGPermissionforExist(JSONObject jsonObject){
        return wgPermissionMapper.getWGPermissionforExist(jsonObject);
    }
}
