package com.zy.SmartCampus.service;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.mapper.VideoMapper;
import com.zy.SmartCampus.polo.VideoInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class VideoService {

    @Autowired
    private VideoMapper videoMapper;

    public int insertVideo(VideoInfo videoInfo){return videoMapper.insertVideo(videoInfo);}

    public List<VideoInfo> queryVideo(JSONObject json){return videoMapper.queryVideo(json);}


    public List<VideoInfo> queryAllVideoDev(JSONObject json){return videoMapper.queryAllVideoDev(json);}

    public int delVideo(String id){return videoMapper.delVideo(id);}

    public int updateVideo(VideoInfo videoInfo){return videoMapper.updateVideo(videoInfo);}

    public int queryVideoDevCount(JSONObject json){return videoMapper.queryVideoDevCount(json);}

}
