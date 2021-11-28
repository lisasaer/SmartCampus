package com.zy.SmartCampus.service;

import com.zy.SmartCampus.WGSet.WgSetting;
import com.zy.SmartCampus.hik.HkSetting;
import com.zy.SmartCampus.listener.MyListener;
import com.zy.SmartCampus.polo.*;
import com.zy.SmartCampus.util.MyUtil;
import com.zy.SmartCampus.util.WGAccessUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.text.ParseException;


@Service
public class ManageCardService {

    @Autowired
    private DeviceService deviceService;

    @Autowired
    private HkSetting hkSetting;

    @Autowired
    private HkService hkService;

    @Autowired
    private HKPermissionService hkpermissionService;

    @Autowired
    public WgPermissionService wgPermissionService;

    public void addCardDevice(CardDeviceBean cardDeviceBean) throws UnsupportedEncodingException, ParseException, InterruptedException {

        MyUtil.printfInfo("开始下发权限");

        MyUtil.printfInfo("卡数量:"+cardDeviceBean.getCards().size()+" 设备数量:"+cardDeviceBean.getDevices().size());

        for(CardDeviceBean.DeviceVo deviceVo : cardDeviceBean.getDevices()){
            for(CardDeviceBean.CardVo cardVo : cardDeviceBean.getCards()){

                int iDevID = Integer.parseInt(deviceVo.getValue());
                //根据设备的ID获取到设备IP，并获取到当前设备
                String dip = deviceService.getDevIPByID(String.valueOf(iDevID));
                LoginDevInfo loginDevInfo = hkSetting.getLoginDevInfoByDevID(dip);//hkService.getLoginDevInfoByDevID(iDevID);
                if(loginDevInfo != null){//如果设备存在

                    FaceCardInfo faceCardInfo = new FaceCardInfo(loginDevInfo.getLUserID(),cardVo.getCardId(),
                            "2019-01-01 00:00:00","2030-01-01 00:00:00","888888",
                            Integer.parseInt(cardVo.getValue()),cardVo.getTitle(),MyUtil.getWEBINFPath()+cardVo.getPhoto(),"ADD");   //工号    持卡人姓名   图片地址


                    hkService.setCardAndFaceInfo(faceCardInfo);
                    HKPermisson hkPermisson = new HKPermisson();
                    hkPermisson.setCardNo(cardVo.getCardId());
                    hkPermisson.setDevId(deviceVo.getValue());
                    hkPermisson.setDip(dip);
                    hkpermissionService.insertPermission(hkPermisson);

                    Thread.sleep(500);
                }else {
                    MyUtil.printfInfo("无该注册成功信息");
                }
            }
        }
    }

    public void addCardWgDev(CardDeviceBean cardDeviceBean) throws UnknownHostException, InterruptedException {
        WGAccessUtil.sendAddPerssion(cardDeviceBean);
    }

    public void delCardWgDev(CardDeviceBean cardDeviceBean) throws UnknownHostException, InterruptedException {
        WGAccessUtil.sendDelPerssion(cardDeviceBean);
    }
}
