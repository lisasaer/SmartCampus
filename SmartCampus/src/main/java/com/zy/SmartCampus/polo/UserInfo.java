package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class UserInfo {
    private String id;          //主键自增
    private String username;    //用户名
    private String password;    //密码
    private int type;           //类型
    private String typename;    //类型所对应的名称
//    private String limitname;   //权限
}
