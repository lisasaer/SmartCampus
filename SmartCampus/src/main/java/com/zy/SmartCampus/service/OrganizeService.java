package com.zy.SmartCampus.service;

import com.zy.SmartCampus.mapper.OrganizeMapper;
import com.zy.SmartCampus.polo.EasyTree;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrganizeService {
    @Autowired
    private OrganizeMapper organizeMapper;

    //查找子组织
    public List<EasyTree> queryChildenOrganize(String pId,String iconCls){
        return organizeMapper.queryChildenOrganize(pId,iconCls);
    }
    public List<EasyTree> queryVideoChildrenOrganize(String pId){
        return organizeMapper.queryVideoChildrenOrganize(pId);
    }
    //删除组织
    public int delOrganize(String id){
        return organizeMapper.delOrganize(id);
    }

    //添加组织
    public int insertOrganize(EasyTree easyTree){
        return organizeMapper.insertOrganize(easyTree);
    }

    //修改组织
    public int updateOrganize(EasyTree easyTree){
        return organizeMapper.updateOrganize(easyTree);
    }

    //查找父组织
    public EasyTree queryParent(String id){
        return organizeMapper.queryParent(id);
    }

    //查找当前组织
    public EasyTree queryCurrId(String id){
        return organizeMapper.queryCurrId(id);
    }

    public EasyTree queryByName(String text){
        return organizeMapper.queryByName(text);
    }
}
