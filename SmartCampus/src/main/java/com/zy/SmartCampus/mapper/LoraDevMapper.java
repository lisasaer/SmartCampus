package com.zy.SmartCampus.mapper;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.LoraDevInfo;

import java.util.List;

public interface LoraDevMapper {

    //查询Lora网关设备信息（2020-5-18，hhp）
    List<LoraDevInfo> queryLoraDevInfo(JSONObject json);

    //添加Lora网关设备(2020-5-21，hhp)
    int addLoraDev(LoraDevInfo loraDevInfo);

    //查询Lora网关设备信息（2020-5-22，hhp）
    List<LoraDevInfo> queryLoraByDevSN(String loraSN);
    //删除选中的Lora网关设备（2020-5-26，hhp）
    int delLoraDev(String id);

    //获取服务器向网关发送信息的流水号（2020-5-23，hhp）-->
    List<LoraDevInfo> querySEQByDevSN(String loraSN);

    //根据ID获取Lora网关信息（2020-5-23，hhp）-->
    List<LoraDevInfo> queryLoraDevByID(String id);
    //更新服务器向网关发送信息的流水号（2020-5-23，hhp）
    int updateSEQ(LoraDevInfo loraDevInfo);
    //初次加载更新lora网关状态为离线(2020-5-27，hhp)
    int updateOnLoadStatus(LoraDevInfo loraDevInfo);
    //重启后更新lora网关状态为离线(2020-6-1，hhp)
    int updateRestartStatus(LoraDevInfo loraDevInfo);

    //更新网关对应的空开组数量(2020-6-1，hhp)
    int updateLora(LoraDevInfo loraDevInfo);

    //根据Lora序列号查询终端通道数量（2020-5-28，zyw）
    List<LoraDevInfo> querySwitchGroupNum(String loraSN);
    //根据校区楼栋、楼层查询空开设备
    List<LoraDevInfo> queryLoraDevByFloor(JSONObject json);
    List<LoraDevInfo> queryLoraDevByArea(JSONObject json);
    int selectLoraDevInfoCount(JSONObject json);
}
