package com.zy.SmartCampus.mapper;

import com.zy.SmartCampus.polo.CardBean;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository
public interface CardMapper {
    public List<CardBean> selectAllCard(HashMap<String, Object> map);

    public int selectCount();

    public String queryStaffIdByCardNumber(String staffId);

    public String queryCardNumberByCardId(String cardId);
}