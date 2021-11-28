package com.zy.SmartCampus.mapper;


import com.zy.SmartCampus.polo.EasyTree;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OrganizeMapper {

    //查找子组织
    List<EasyTree> queryChildenOrganize(@Param("pId") String pId,@Param("iconCls") String iconCls);
    List<EasyTree> queryVideoChildrenOrganize(@Param("pId") String pId);

    //删除组织
    int delOrganize(String id);
    //添加组织
    int insertOrganize(EasyTree easyTree);
    //修改组织
    int updateOrganize(EasyTree easyTree);

    //查找父组织
    EasyTree queryParent(String id);

    //查找当前组织
    EasyTree queryCurrId(String id);

    EasyTree queryByName(String text);
}
