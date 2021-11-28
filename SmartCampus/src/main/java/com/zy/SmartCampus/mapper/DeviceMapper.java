package com.zy.SmartCampus.mapper;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.Device;
import com.zy.SmartCampus.polo.SwitchDevInfo;
import com.zy.SmartCampus.polo.manageDeviceBean;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public interface DeviceMapper {

    List<Device> selectDeviceAll(HashMap<String, Object> map);

    int selectCount();

    void addDevice(Device device);

    void delDevice(Integer id);

    List<manageDeviceBean> selectDeviceByDepartmentIdCard(int departmentId);

    Integer queryDeviceIdByDip(String Dip);

    String queryDeviceIpById(String id);

    //ID查找设备IP
    String getDevIPByID(String id);

    //ID查找微耕设备IP
    String getWgDevIPByID(String id);


    //IP查找ID
    String getDevIDByIP(String ip);
    //更新设备
    void updateDevice(Device device);
    //条件查询
    List<Device> queryConditionDev(Map<String, Object> map);

//    int queryConditionDevCount();

    List<Device> queryDevByDepartmentId(int departmentId);
    void updateDevOnLine(Device device);
    void updateDevOffLine();
    List<Device> queryNewDev();

    List<Device> queryHKDevByArea(JSONObject json);

    List<Device> queryByDevIP(String dip);
}