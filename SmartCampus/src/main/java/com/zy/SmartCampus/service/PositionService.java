package com.zy.SmartCampus.service;

import com.zy.SmartCampus.mapper.PositionMapper;
import com.zy.SmartCampus.polo.Position;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PositionService {
    @Autowired
    private PositionMapper positionMapper;

    public List<Position> selectPosition(int id) {
        return positionMapper.selectPosition(id);
    }

    public List<Position> selectPositionId() {
        return positionMapper.selectPositionId();
    }
}
