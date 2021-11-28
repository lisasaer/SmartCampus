package com.zy.SmartCampus.service;

import com.sun.jna.NativeLong;
import com.zy.SmartCampus.hik.HkSetting;
import com.zy.SmartCampus.mapper.DeviceMapper;
import com.zy.SmartCampus.mapper.HkMapper;
import com.zy.SmartCampus.polo.Device;
import com.zy.SmartCampus.polo.FaceCardInfo;
import com.zy.SmartCampus.polo.HistoryFaceAlarm;
import com.zy.SmartCampus.polo.LoginDevInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

@Service
public class HkService {

    @Autowired
    private HkSetting hkSetting;

    @Autowired
    private HkMapper hkMapper;

    @Autowired
    private DeviceMapper deviceMapper;

    /**
     * 初始化+回调
     */
    public void initAndSetCallBack (){
        hkSetting.init();
        hkSetting.setCallBack();
    }

    /**
     * 设备注册 布防
     * @param device
     */
    public NativeLong loginAndSetAlarmUp(Device device) {
        NativeLong lUserID = hkSetting.login(device);
        if(lUserID.intValue() > -1){
            hkSetting.setUpAlarmChan(lUserID,device);
        }
        hkSetting.setPictureData(lUserID);
        return  lUserID;
    }

    /**
     * 获取所有设备信息
     * @return
     */
    public List<Device> getAllDev(){
        return deviceMapper.selectDeviceAll(null);
    }

    /**
     * 下发卡参数和人脸参数
     * @param faceCardInfo
     * @throws UnsupportedEncodingException
     * @throws ParseException
     */
    public void setCardAndFaceInfo(FaceCardInfo faceCardInfo) throws UnsupportedEncodingException, ParseException {
        hkSetting.setCardAndFaceInfo(faceCardInfo);
    }
    /**
     * 获取卡参数和人脸参数 2020-6-12-hhp
     * @param faceCardInfo
     * @throws UnsupportedEncodingException
     * @throws ParseException
     */
    public void getCardAndFaceInfo(FaceCardInfo faceCardInfo) throws UnsupportedEncodingException, ParseException {
        hkSetting.getCardAndFaceInfo(faceCardInfo);
    }
    public LoginDevInfo getLoginDevInfoByDevID(String strIP){
        return  hkSetting.getLoginDevInfoByDevID(strIP);
    }

    public  void insertFaceAlarm(Map<String,Object> map){
        hkMapper.insertFaceAlarm(map);
    }
    public  void insertHistoryFaceAlarm(Map<String,Object> map){
        hkMapper.insertHistoryFaceAlarm(map);
    }
    public List<HistoryFaceAlarm> queryDate(){
        return hkMapper.queryDate();
    }
    public void deleteRealRecord(){
        hkMapper.deleteRealRecord();
    }
}
