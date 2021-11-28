package com.zy.SmartCampus.service;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.mapper.UserMapper;
import com.zy.SmartCampus.polo.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    //查找用户
    public List<UserInfo> queryUser(JSONObject json){
        return userMapper.queryUser(json);
    }

    //更新用户
    public int updateUser(JSONObject json){
        return userMapper.updateUser(json);
    }

    //增加用户
    public int insertUser(UserInfo userInfo){ return userMapper.insertUser(userInfo);}

    //删除用户
    public int delUser(String userid){return userMapper.delUser(userid);}

    //跟新用户权限
    public int updateUserInfo(UserInfo userInfo){return userMapper.updateUserInfo(userInfo);}
}
