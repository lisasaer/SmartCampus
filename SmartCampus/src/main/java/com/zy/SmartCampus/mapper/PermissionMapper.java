package com.zy.SmartCampus.mapper;

import com.zy.SmartCampus.polo.PermissionInfo;

import java.util.List;

//权限
public interface PermissionMapper {

    //获取所有的权限列表
    List<PermissionInfo> queryPermission();

    //增加权限
    int addPermissionInfo(PermissionInfo permissionInfo);

    //删除权限
    int delPermission(String id);
}
