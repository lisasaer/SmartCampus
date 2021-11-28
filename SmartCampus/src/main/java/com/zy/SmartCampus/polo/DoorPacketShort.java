package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class DoorPacketShort {
    char 	 type;				  //类型
    char 	 functionID;		  //功能号
    short	 reserved;            //保留
    int	 iDevSn;                  //设备序列号 4字节
    char[]  data;                 //32字节的数据
    int   sequenceId;            //数据包流水号
    char[]  extern_data;         //第二版本 扩展20字节
}
