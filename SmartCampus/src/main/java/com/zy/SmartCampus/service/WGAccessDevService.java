package com.zy.SmartCampus.service;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.mapper.WGAccessDevMapper;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.util.MyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.util.List;

@Service
public class WGAccessDevService {

    @Autowired
    private WGAccessDevMapper wgAccessDevMapper;

    public int addWGAccessDev(WGAccessDevInfo wgAccessDevInfo){return  wgAccessDevMapper.addWGAccessDev(wgAccessDevInfo);}

    public List<WGAccessDevInfo> queryWGAccessDevInfo(JSONObject json){return wgAccessDevMapper.queryWGAccessDevInfo(json);}

    public int queryWGDevCount(JSONObject json){return  wgAccessDevMapper.queryWGDevCount(json);}

    public int delWGAccessDev(String id){return wgAccessDevMapper.delWGAccessDev(id);}

    public WGAccessDevInfo queryWGAccessDevInfoByID(String id){return wgAccessDevMapper.queryWGAccessDevInfoByID(id);}

    public List<manageDeviceBean> queryWGAccessDevInfoByDepartmentId(JSONObject jsonObject){return wgAccessDevMapper.queryWGAccessDevInfoByDepartmentId(jsonObject);}

    public List<manageDeviceBean> selectDeviceByDepartmentId(int departmentId) {
        return wgAccessDevMapper.selectDeviceByDepartmentId(departmentId);
    }

    public List<WGAccessDevInfo> queryWGAccessDevInfoByJSON (JSONObject json){
        return wgAccessDevMapper.queryWGAccessDevInfoByJSON(json);}

    public int updateWGAccessDev (WGAccessDevInfo wgAccessDevInfo){return  wgAccessDevMapper.updateWGAccessDev(wgAccessDevInfo);}

    public List<WGAccessDevInfo> queryWGDevByArea (JSONObject json){
        return wgAccessDevMapper.queryWGDevByArea(json);
    }

    public List<WGAccessDevInfo> queryWGDevBySNorIP (JSONObject json){ return wgAccessDevMapper.queryWGDevBySNorIP(json);}
}
