package com.zy.SmartCampus.controller;

import ch.qos.logback.classic.pattern.SyslogStartConverter;
import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.mapper.PermissionMapper;
import com.zy.SmartCampus.polo.Layui;
import com.zy.SmartCampus.polo.PermissionInfo;
import com.zy.SmartCampus.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

//权限设置
@Controller
public class permissionCtrl {

   @Autowired
   private  PermissionService permissionService;

    @RequestMapping("permissionManage")
    public String permissionManage(){return "permissionManager/permissionManager";}

    @RequestMapping("getPermission")
    @ResponseBody
    public Layui getPermission(int page, int limit, HttpServletRequest request){
        JSONObject json = new JSONObject();
        int offset = (page-1)*limit;
        json.put("offset",offset);
        json.put("limit",limit);
        List<PermissionInfo> permissionList = permissionService.queryPermission();
        int count = permissionList.size();
        return  Layui.data(count,permissionList);
    }

    //跳转到添加界面
    @RequestMapping("addPermission")
    public String addPermission(){return "permissionManager/addPermissionName";}

    //添加权限功能
    @RequestMapping("addPermissionName")
    @ResponseBody
    public JSONObject addPermissionName(PermissionInfo permissionInfo,HttpServletRequest request){
        String permissionNum = request.getParameter("permission");
        String name = request.getParameter("name");

        permissionInfo.setName(name);
        permissionInfo.setPermissionNum(permissionNum);

        System.out.println(permissionInfo.toString());
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        permissionInfo.setCreatDate(formatter.format(date));

        System.out.println(permissionInfo.toString());
        JSONObject json = new JSONObject();
        int code = permissionService.addPermissionInfo(permissionInfo);
        json.put("code",code);
        json.put("msg",(code>0)?"添加成功":"添加失败");
        return json;
    }

    //删除权限
    @RequestMapping("delPermission")
    @ResponseBody
    public JSONObject delPermission(HttpServletRequest request){
        String id = request.getParameter("id");
        JSONObject json = new JSONObject();
        int code = permissionService.delPermission(id);
        json.put("code",code);
        json.put("msg",(code > 0)?"删除成功":"删除失败");
        return json;
    }
}
