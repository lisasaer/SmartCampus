package com.zy.SmartCampus.mapper;

import com.zy.SmartCampus.polo.Position;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PositionMapper {
    List<Position> selectPosition(int id);
    List<Position> selectPositionId();
}