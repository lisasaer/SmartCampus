package com.zy.SmartCampus.mapper;


import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.UserInfo;

import java.util.List;

public interface UserMapper {

    //查找用户
    List<UserInfo>  queryUser(JSONObject json);

    //更新用户
    int updateUser(JSONObject json);

    //增加用户
    int insertUser(UserInfo userInfo);

    //删除用户
    int delUser(String userid);

    int updateUserInfo(UserInfo userInfo);
}
