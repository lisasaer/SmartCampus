package com.zy.SmartCampus.mapper;


import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.CardDeviceBean;
import com.zy.SmartCampus.polo.PermissionInfo;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface WgPermissionMapper {
    void addWgPermission(@Param("cardNo") String cardNo,@Param("wgSNAndDoorID") String wgSNAndDoorID);
    void delWgPermission(@Param("cardNo") String cardNo,@Param("wgSNAndDoorID") String wgSNAndDoorID);

    List<PermissionInfo> getWGPermission(JSONObject jsonObject);

    List<PermissionInfo> getWGPermissionByCardNo(JSONObject jsonObject);

    List<PermissionInfo> getWGPermissionByJSON(JSONObject jsonObject);

    PermissionInfo getWGPermissionforExist(JSONObject jsonObject);


    void delWgAllPermission(String ctrlerSN);
}
