package com.zy.SmartCampus.service;

import com.zy.SmartCampus.mapper.TestMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TestService {

    @Autowired
    private TestMapper testMapper;

    //测试数据库  获取当前数据库版本
    public String getMysqlVersion(){
        return testMapper.getMysqlVersion();
    }
}
