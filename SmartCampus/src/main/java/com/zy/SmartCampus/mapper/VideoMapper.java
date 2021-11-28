package com.zy.SmartCampus.mapper;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.VideoInfo;

import java.util.List;

public interface VideoMapper {
    int insertVideo(VideoInfo videoInfo);

    List<VideoInfo> queryVideo(JSONObject json);

    List<VideoInfo> queryAllVideoDev(JSONObject json);

    int delVideo(String id);

    int updateVideo(VideoInfo videoInfo);

    int queryVideoDevCount(JSONObject json);
}
