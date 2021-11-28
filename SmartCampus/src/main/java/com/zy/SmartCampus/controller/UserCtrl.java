package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.Layui;
import com.zy.SmartCampus.polo.PermissionInfo;
import com.zy.SmartCampus.polo.UserInfo;
import com.zy.SmartCampus.service.PermissionService;
import com.zy.SmartCampus.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
public class UserCtrl {

    @Autowired
    private UserService userService;

    @Autowired
    private PermissionService permissionService;

    @RequestMapping("checkLogin")
    @ResponseBody
    public JSONObject checkLogin(String username , String password , HttpSession session){
        System.out.println("用户名密码："+username+" "+password);

        session.setAttribute("comOpen", false );//SerialPortUtils.getInstance().isbOpen()

        JSONObject json = new JSONObject();

        if(username == null || password == null){
            json.put("error","paramter not complete");
            return json;
        }

        json.put("username",username);
        json.put("password",password);
        List<UserInfo> list = userService.queryUser(json);

        json.clear();
        int size = list.size();
        if(size > 0){
            session.setAttribute("userinfo",list.get(0));
        }
        json.put("code",size);
        json.put("msg",size > 0 ? "mainPage":"用户名密码错误");
        return json;
    }

    @RequestMapping("loginOut")
    @ResponseBody
    public JSONObject loginOut(HttpSession session){
        System.out.println("退出");
        JSONObject json = new JSONObject();
        session.removeAttribute("userinfo");
        json.put("code",1);
        return json;
    }


    @RequestMapping("modifyPsw")
    @ResponseBody
    public JSONObject modifyPsw(String psw0,String psw1,String psw2,HttpSession session){
        JSONObject json = new JSONObject();
        UserInfo userInfo = (UserInfo)session.getAttribute("userinfo");
        //System.out.println(userInfo.getPassword());
        if(!userInfo.getPassword().equals(psw0)){
            json.put("code",-1);
            json.put("msg","旧密码错误");
            return json;
        }
        //System.out.println(psw0+"  "+psw1+"  "+psw2);

        JSONObject queryJson = new JSONObject();
        queryJson.put("id",userInfo.getId());
        queryJson.put("password",psw1);

        int iRet = userService.updateUser(queryJson);
        json.put("code",iRet);
        json.put("msg",(iRet>0?"修改成功":"修改失败"));

        return json;
    }

    //添加用户
    @RequestMapping("userManage")
    public String userManage(){
        return "userManager/userManager";
    }

    @RequestMapping("getAllUser")
    @ResponseBody
    public Layui getAllUser(int page, int limit, HttpServletRequest request){
        int offset = (page-1)*limit;
        JSONObject json = new JSONObject();
        json.put("offset",offset);
        json.put("limit",limit);
        List<UserInfo> userInfoList = userService.queryUser(json);
        List<PermissionInfo> permissionList = permissionService.queryPermission();
        for(int i = 0;i<userInfoList.size();i++){
            UserInfo userInfo = userInfoList.get(i);

            for(int j= 0;j<permissionList.size();j++){
                PermissionInfo permissionInfo = permissionList.get(j);
                if(userInfo.getType() == permissionInfo.getId()){
                    userInfo.setTypename(permissionInfo.getName());
                }
            }
        }
        int count = userInfoList.size();
        return Layui.data(count,userInfoList);
    }

    //添加用户页面
    @RequestMapping("AddUserForm")
    public String AddUserForm(Model model){
        //权限选择
        List<PermissionInfo> permissionList = permissionService.queryPermission();
        System.out.println(permissionList.size());
        model.addAttribute("permissionList",permissionList);
        return "userManager/userForm";
    }

    //添加用户功能
    @RequestMapping("addUser")
    @ResponseBody
    public JSONObject addUser(UserInfo userInfo){
        //userInfo.setType(1);
        System.out.println(userInfo.toString());
        int code = userService.insertUser(userInfo);
        JSONObject json = new JSONObject();
        json.put("code",code);
        json.put("msg",(code>0)?"添加成功":"添加失败");
        return json;
    }

    //删除用户
    @RequestMapping("delUser")
    @ResponseBody
    public JSONObject delUser(String id,HttpServletRequest request){
        String userId = request.getParameter("userid");

        JSONObject json = new JSONObject();
        int code = userService.delUser(userId);
        json.put("code",code);
        json.put("msg",(code > 0)?"删除成功":"删除失败");
        return json;
    }

    @RequestMapping("modifyUser")
    @ResponseBody
    public JSONObject modifyUser(UserInfo userInfo){
        System.out.println(userInfo.toString());
        JSONObject json = new JSONObject();
        int iRet = userService.updateUserInfo(userInfo);
        json.put("code",iRet);
        json.put("msg",(iRet > 0?"修改成功":"修改失败"));
        return json;
    }
}
