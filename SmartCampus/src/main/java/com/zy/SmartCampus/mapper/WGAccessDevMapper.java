package com.zy.SmartCampus.mapper;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.WGAccessDevInfo;
import com.zy.SmartCampus.polo.manageDeviceBean;

import java.util.List;

public interface WGAccessDevMapper {
    //添加门禁设备
    int addWGAccessDev(WGAccessDevInfo wgAccessDevInfo);

    List<WGAccessDevInfo> queryWGAccessDevInfo(JSONObject json);

    int queryWGDevCount(JSONObject json);


    int delWGAccessDev(String id);

    WGAccessDevInfo queryWGAccessDevInfoByID(String id);

    List<manageDeviceBean> queryWGAccessDevInfoByDepartmentId(JSONObject jsonObject);

    List<manageDeviceBean> selectDeviceByDepartmentId(int departmentId);

    List<WGAccessDevInfo> queryWGAccessDevInfoByJSON (JSONObject json);

    int updateWGAccessDev (WGAccessDevInfo wgAccessDevInfo);

    List<WGAccessDevInfo> queryWGDevByArea (JSONObject json);

    List<WGAccessDevInfo> queryWGDevBySNorIP (JSONObject json);
}
