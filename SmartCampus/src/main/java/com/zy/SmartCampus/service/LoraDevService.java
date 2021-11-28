package com.zy.SmartCampus.service;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.mapper.LoraDevMapper;
import com.zy.SmartCampus.polo.LoraDevInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LoraDevService {

    @Autowired
    private LoraDevMapper loraDevMapper;

    //查询Lora网关设备信息（2020-5-18，hhp）
    public List<LoraDevInfo> queryLoraDevInfo(JSONObject json){return loraDevMapper.queryLoraDevInfo(json);}

    //添加Lora网关设备(2020-5-21，hhp)
    public int addLoraDev(LoraDevInfo loraDevInfo){
        return loraDevMapper.addLoraDev(loraDevInfo);
    }

    //查询Lora网关设备信息（2020-5-22，hhp）
    public List<LoraDevInfo> queryLoraByDevSN(String loraSN){return loraDevMapper.queryLoraByDevSN(loraSN);}

    //删除选中的Lora网关设备（2020-5-26，hhp）
    public int delLoraDev(String id){return loraDevMapper.delLoraDev(id);}

    //根据ID获取Lora网关信息（2020-5-23，hhp）-->
    public List<LoraDevInfo> queryLoraDevByID(String id){return loraDevMapper.queryLoraDevByID(id);}
    //获取服务器向网关发送信息的流水号（2020-5-23，hhp）
    public List<LoraDevInfo> querySEQByDevSN (String loraSN){return loraDevMapper.querySEQByDevSN(loraSN);}
    //更新服务器向网关发送信息的流水号（2020-5-23，hhp）
    public int updateSEQ (LoraDevInfo loraDevInfo){return loraDevMapper.updateSEQ(loraDevInfo);}
    //初次加载更新lora网关状态为离线(2020-5-27，hhp)
    public int updateOnLoadStatus(LoraDevInfo loraDevInfo){return loraDevMapper.updateOnLoadStatus(loraDevInfo);}
    //重启后更新lora网关状态为离线(2020-6-1，hhp)
    public int updateRestartStatus(LoraDevInfo loraDevInfo){return loraDevMapper.updateRestartStatus(loraDevInfo);}
    //更新网关对应的空开组数量(2020-6-1，hhp)
    public int updateLora(LoraDevInfo loraDevInfo){return loraDevMapper.updateLora(loraDevInfo);}
    //根据Lora序列号查询终端通道数量（2020-5-28，zyw）
    public List<LoraDevInfo> querySwitchGroupNum(String loraSN){
        return loraDevMapper.querySwitchGroupNum(loraSN);
    }
    //根据校区楼栋、楼层查询空开设备
    public List<LoraDevInfo> queryLoraDevByFloor(JSONObject json){return loraDevMapper.queryLoraDevByFloor(json);}
    public List<LoraDevInfo> queryLoraDevByArea (JSONObject json){return loraDevMapper.queryLoraDevByArea(json);}
    public int selectLoraDevInfoCount(JSONObject json){return loraDevMapper.selectLoraDevInfoCount(json);}
}
