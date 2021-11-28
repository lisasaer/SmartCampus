package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class VideoReplayInfo {

    private String id;
    private String szDeviceIdentify; //设备名称
    private String szStartTime;  //开始时间
    private String szEndTime; //结束时间
    private String fileSize; //文件大小

}
