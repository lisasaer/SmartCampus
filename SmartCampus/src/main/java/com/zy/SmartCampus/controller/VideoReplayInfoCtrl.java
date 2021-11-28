package com.zy.SmartCampus.controller;

import com.zy.SmartCampus.polo.Layui;
import com.zy.SmartCampus.polo.VideoReplayInfo;
import com.zy.SmartCampus.service.VideoReplayInfoServer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VideoReplayInfoCtrl {
    @Autowired
    private VideoReplayInfoServer videoReplayInfoServer;


    //新增录像回放视频信息
    @RequestMapping("insertVideoReplayInfo")
    @ResponseBody
    public Map<String,Object> insertVideoReplayInfo(VideoReplayInfo videoReplayInfo) {
        Map<String,Object> map  = new HashMap<>();

        int iCode = videoReplayInfoServer.insertVideoReplayInfo(videoReplayInfo);
        map.put("code",iCode);
        map.put("msg",(iCode>0?"添加成功":"添加失败"));

        return  map;
    }

    //删除录像回放视频信息
    @RequestMapping("delVideoReplayInfo")
    public Map<String,Object> delVideoReplayInfo() {
        Map<String,Object> map = new HashMap<>();

        int iCode = videoReplayInfoServer.delVideoReplayInfo();
        map.put("code",iCode);
        map.put("msg",(iCode>0?"删除成功":"删除失败"));

        return map;
    }

    //查询录像回放实时视频
    @RequestMapping("getVideoReplayInfo")
    @ResponseBody
    public Layui getVideoReplayInfo(int page, int limit) {

        /*int offset = (page-1)*limit;
        JSONObject json = new JSONObject();
        json.put("offset",offset);
        json.put("limit",limit);*/

        System.out.println("aaaaaaaaa");

        Map<String, Object> map = new HashMap<>();
        int offset =(page-1)*limit;
        map.put("offset",offset);
        map.put("limit",limit);

        System.out.println("aaaaaaaaaaaaaaasdad");
        List<VideoReplayInfo> list = videoReplayInfoServer.queryVideoReplayInfo(map);
        int count = videoReplayInfoServer.queryVideoReplayInfoCount(map);

        System.out.println(list);
        System.out.println(count);


        return  Layui.data(count,list);
    }



}
