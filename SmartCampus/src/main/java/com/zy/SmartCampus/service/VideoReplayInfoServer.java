package com.zy.SmartCampus.service;

import com.zy.SmartCampus.mapper.VideoReplayInfoMapper;
import com.zy.SmartCampus.polo.VideoReplayInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class VideoReplayInfoServer {
    @Autowired
    private VideoReplayInfoMapper videoReplayInfoMapper;

    //添加录像回放实时视频
    public int insertVideoReplayInfo(VideoReplayInfo videoReplayInfo){
        return videoReplayInfoMapper.insertVideoReplayInfo(videoReplayInfo);
    }

    //删除录像回放实时视频
    public int delVideoReplayInfo(){
        return videoReplayInfoMapper.delVideoReplayInfo();
    };

    //查询录像回放实时视频
    public List<VideoReplayInfo> queryVideoReplayInfo(Map<String,Object> map){
        return videoReplayInfoMapper.queryVideoReplayInfo(map);
    };

    public int queryVideoReplayInfoCount(Map<String,Object> map){
        return videoReplayInfoMapper.queryVideoReplayInfoCount(map);
    };

}
