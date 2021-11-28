package com.zy.SmartCampus.service;

import com.zy.SmartCampus.mapper.CrewMapper;
import com.zy.SmartCampus.polo.Crew;
import com.zy.SmartCampus.polo.PageBean;
import com.zy.SmartCampus.util.PageUtill;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CrewService {
    @Autowired
    private CrewMapper crewMapper;

    public PageBean<Crew> selectCrew(String page, String limit) {
        PageBean<Crew> pageBean = new PageBean();
        pageBean.setLists(crewMapper.selectCrew(PageUtill.PageMap(page, limit, null)));
        pageBean.setTotalCount(crewMapper.selectCount());
        return pageBean;
    }

    public void delCrewByCid(Integer id){
        crewMapper.delCrewByCid(id);
    }

    public List<Crew> selectCrewAll() {
        return crewMapper.selectCrewAll();
    }
    public void addCrew(Crew crew){
        crewMapper.addCrew(crew);
    }
    public void delSomeCrew(List<Crew> crews) {
        for(Crew crew:crews) {
            crewMapper.delCrewByCid(crew.getCid());
        }
    }
    //更新排班计划
    public void updateCrew(Crew crew){
        System.out.println(crew);
        crewMapper.updateCrew(crew);
    }
}
