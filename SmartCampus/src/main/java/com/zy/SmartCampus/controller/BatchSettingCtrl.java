package com.zy.SmartCampus.controller;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.DevInfo;
import com.zy.SmartCampus.polo.EasyTree;
import com.zy.SmartCampus.polo.Layui;
import com.zy.SmartCampus.service.DevService;
import com.zy.SmartCampus.service.OrganizeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

//批量设置
@Controller
public class BatchSettingCtrl {
    @Autowired
    private DevService devService;

    @Autowired
    private OrganizeService organizeService;

    //空开批量设置
    @RequestMapping("bathSetting")
    public String BathSetting(){return "bathSetting/airSwitchBathSetting";}

    //添加空开批量设置时间
    @RequestMapping("addAirSwithBatchSetting")
    public String airSwithBatchSetting(){return "batchSetting/AddairSwitchBatchSetting";}

    //空调批量设置
    @RequestMapping("airConditionBatchSetting")
    public String airConditionBathSetting(){return "batchSetting/airConditionBatchSetting";}

    //添加空调批量设置时间
    @RequestMapping("addAirConditionBatchSetting")
    public String addAirConditionBatchSetting(){
        return "batchSetting/AddairConditionBatchSetting";
    }

    @RequestMapping("getDevByTreeID")
    @ResponseBody
    public Layui getDev(int page, int limit, HttpServletRequest request){
        List<DevInfo> list = new ArrayList<>();
        //判断下是第几级，如果是最下面一级就直接查询设备
        int offset = (page-1)*limit;
        String devType = request.getParameter("devType");
        String nodeId = request.getParameter("nodeId");
        String iconCls = request.getParameter("iconCls");

        JSONObject json = new JSONObject();
        json.put("offset",offset);
        json.put("limit",limit);
        json.put("devType",devType);

        if(iconCls.equals("my-tree-icon-5")){
            json.put("devPostion",nodeId);
            list = devService.queryDevByTree(json);
        }
        else{
            //根据区域树id查找该区域下的所有设备
            List<EasyTree> childenList =  queryChildenList(nodeId);
            System.out.println("有几个  "+childenList.size());
            for(int i =0;i<childenList.size();i++){
                List<DevInfo> devList = new ArrayList<>();
                json.put("devPostion",childenList.get(i).getId());
                devList = devService.queryDevByTree(json);
                for(int j=0;j<devList.size();j++){
                    list.add(devList.get(j));
                }
            }
        }

        for(int i=0;i<list.size();i++){
            String[] area = getAllParentOrganize(list.get(i).getDevPostion()).split(",");
            int j = 2;
            list.get(i).setSchool(area[area.length - (j++)]);
            list.get(i).setHouse(area[area.length - (j++)]);
            list.get(i).setFloor(area[area.length - (j++)]);
            list.get(i).setRoom(area[area.length - (j++)]);
        }

        System.out.println("设备一共"+list.size()+"条");
        int count = list.size();
        return Layui.data(count,list);
    }

    public List<EasyTree> queryChildenList(String nodeId){
        List<EasyTree> childenList = new ArrayList<>();
        List<EasyTree> list = organizeService.queryChildenOrganize(nodeId,"");
        for(int i = 0;i<list.size();i++){
            EasyTree easyTree = list.get(i);
            if(!easyTree.getIconCls().equals("my-tree-icon-5")){
                List<EasyTree> easyTreeList= queryChildenList(easyTree.getId());
                for(int j=0;j<easyTreeList.size();j++){
                    System.out.println(easyTree.getText());
                    childenList.add(easyTreeList.get(j));
                }
            }
            else{
                childenList.add(easyTree);
            }
        }
        return  childenList;
    }

    private String getAllParentOrganize(String id){
        EasyTree easyTree = organizeService.queryParent(id);
        EasyTree thisEasyTree  = organizeService.queryCurrId(id);
        String str = thisEasyTree.getText()+","+easyTree.getText()+",";
        while (!easyTree.getPId().equals("0")){
            easyTree = organizeService.queryParent(easyTree.getId());
            str += easyTree.getText()+",";
        }
        //System.out.println(str);
        return str.substring(0,str.length()-1);
    }
}
