package com.zy.SmartCampus.service;

import com.zy.SmartCampus.mapper.PermissionMapper;
import com.zy.SmartCampus.polo.PermissionInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PermissionService {

    @Autowired
    private PermissionMapper permissionMapper;

    //获取所有的权限信息
    public List<PermissionInfo> queryPermission(){return permissionMapper.queryPermission();}

    //增加权限
    public int addPermissionInfo(PermissionInfo permissionInfo){return permissionMapper.addPermissionInfo(permissionInfo);}

    //删除
    public int delPermission(String id){return permissionMapper.delPermission(id);}

}
