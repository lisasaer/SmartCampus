package com.zy.SmartCampus.polo;

import lombok.Data;

import java.util.List;

@Data
public class CardDeviceBean {
    public List<CardVo> cards;
    public List<DeviceVo> devices;

    @Data
    public static class CardVo {
        private String photo;//图片地址
        private String cardId;//卡号
        private String value;//人员编号
        private String title;//人员名称
        private String departmentName;//部门名称
        private String id;
        private String cardNumber;//暂时没有用了
    }

    @Data
    public static class DeviceVo {
        private String value;   //设备ID
        private String title;   //设备名称
        private String departmentName;//部门名称
    }
}
