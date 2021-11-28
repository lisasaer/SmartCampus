package com.zy.SmartCampus.service;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.mapper.ZigBeeGatewayDevInfoMapper;
import com.zy.SmartCampus.mapper.ZigBeeGatewayInfoMapper;
import com.zy.SmartCampus.polo.ZigBeeGatewayDevInfo;
import com.zy.SmartCampus.polo.ZigBeeGatewayInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author: duzhibin
 * @description:
 * @date: create in 16:21 2021/7/28
 */
@Service
public class ZigBeeGatewayService {
    @Autowired
    private ZigBeeGatewayInfoMapper zigBeeGatewayInfoMapper;
    @Autowired
    private ZigBeeGatewayDevInfoMapper zigBeeGatewayDevInfoMapper;

    /**
     * @description 添加网关信息
     * @params record
     * @author dzb
     * @date 2021/7/29 10:54
     */
    public int insertZigBeeGatewayInfo(ZigBeeGatewayInfo record) {
        return zigBeeGatewayInfoMapper.insertSelective(record);
    }

    /**
     * @description 根据zigbeeId查询网关信息
     * @params zigbeeId
     * @author dzb
     * @date 2021/7/29 11:03
     */
    public ZigBeeGatewayInfo selectZigBeeInfoByZigbeeId(String zigbeeId) {
        return zigBeeGatewayInfoMapper.selectByPrimaryKey(zigbeeId);
    }

    /**
     * @description 根据JsonObject查询网关信息
     * @params jsonObject
     * @author dzb
     * @date 2021/7/29 19:46
     */
    public List<ZigBeeGatewayInfo> selectZigBeeInfoByJsonObject(JSONObject jsonObject) {

        return zigBeeGatewayInfoMapper.selectZigBeeInfoByJsonObject(jsonObject);
    }


    /**
     * @description 修改网关信息
     * @params record
     * @author dzb
     * @date 2021/7/29 10:53
     */
    public int updateZigBeeGatewayInfo(ZigBeeGatewayInfo record) {
        return zigBeeGatewayInfoMapper.updateByPrimaryKeySelective(record);
    }

    /**
     * @return code
     * @description 删除网关信息
     * @params zigbeeId
     * @author dzb
     * @date 2021/8/5 14:55
     */
    public int delZigBeeGatewayInfo(String zigbeeId) {
        return zigBeeGatewayInfoMapper.deleteByPrimaryKey(zigbeeId);
    }

    /**
     * @description 添加设备信息
     * @params record
     * @author dzb
     * @date 2021/7/29 10:53
     */
    public int insertZigBeeGatewayDevInfo(ZigBeeGatewayDevInfo record) {
        return zigBeeGatewayDevInfoMapper.insertSelective(record);
    }

    /**
     * @description 查询设备信息
     * @params zigBeeGatewayDevInfo
     * @author dzb
     * @date 2021/7/29 11:03
     */
    public List<ZigBeeGatewayDevInfo> selectZigBeeDevInfo(ZigBeeGatewayDevInfo zigBeeGatewayDevInfo) {
        return zigBeeGatewayDevInfoMapper.selectByPrimaryKey(zigBeeGatewayDevInfo);
    }

    /**
     * @return List<ZigBeeGatewayDevInfo>
     * @description 用于查询分页的设备信息
     * @params jsonObject
     * @author dzb
     * @date 2021/8/2 10:45
     */
    public List<ZigBeeGatewayDevInfo> selectZigBeeDevInfoByJSON(JSONObject jsonObject) {
        return zigBeeGatewayDevInfoMapper.selectZigBeeDevInfoByJSON(jsonObject);
    }


    /**
     * @return
     * @description 更新设备信息
     * @params
     * @author dzb
     * @date 2021/7/29 14:51
     */
    public int updateZigBeeGatewayDevInfo(ZigBeeGatewayDevInfo record) {
        return zigBeeGatewayDevInfoMapper.updateByPrimaryKeySelective(record);
    }

    /**
     * @return
     * @description 根据zigbeeId删除网关下的所有设备
     * @params
     * @author dzb
     * @date 2021/8/5 15:05
     */
    public int delZigBeeGatewayDevInfo(String zigbeeId) {
        return zigBeeGatewayDevInfoMapper.deleteByPrimaryKey(zigbeeId);
    }
}
