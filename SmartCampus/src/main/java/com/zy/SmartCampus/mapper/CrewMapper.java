package com.zy.SmartCampus.mapper;

import com.zy.SmartCampus.polo.Crew;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository
public interface CrewMapper {
    List<Crew> selectCrew(HashMap<String, Object> map);

    List<Crew> selectCrewAll();

    int selectCount();
    void delCrewByCid(Integer id);
    void addCrew(Crew crew);
    void updateCrew(Crew crew);

}