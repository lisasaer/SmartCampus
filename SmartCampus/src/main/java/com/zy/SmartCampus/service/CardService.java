package com.zy.SmartCampus.service;

import com.zy.SmartCampus.mapper.CardMapper;
import com.zy.SmartCampus.polo.CardBean;
import com.zy.SmartCampus.polo.Layui;
import com.zy.SmartCampus.polo.PageBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
public class CardService {
    @Autowired
    private CardMapper cardMapper;

    public Layui selectAllCard(Map map) {
        PageBean<CardBean> pageBean = new PageBean();
//        pageBean.setLists(cardMapper.selectAllCard(PageUtill.PageMap((String) map.get("page"), (String) map.get("limit"), null)));
//        pageBean.setTotalCount(cardMapper.selectCount());
        return Layui.data(pageBean.getTotalCount(), pageBean.getLists());
    }

}
