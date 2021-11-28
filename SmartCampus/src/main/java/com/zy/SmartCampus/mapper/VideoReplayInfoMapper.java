package com.zy.SmartCampus.mapper;

import com.zy.SmartCampus.polo.VideoReplayInfo;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public interface VideoReplayInfoMapper {

    //添加录像回放实时视频
    int insertVideoReplayInfo(VideoReplayInfo videoReplayInfo);

    //删除录像回放实时视频
    int delVideoReplayInfo();

    //查询录像回放实时视频
    List<VideoReplayInfo> queryVideoReplayInfo(Map<String,Object> map);

    int queryVideoReplayInfoCount(Map<String,Object> map);


}
