package com.zy.SmartCampus.polo;


import lombok.Data;

@Data
public class StaffDetail {
    private String id;
    private String staffId;
    private String name;
    private String sex;
    private String departmentId;
    private String dName;
    private String telphone;
    private String pName;
    private String email;
    private String birth;
    private String qq;
    private String workState;
    private String cardNo;
    private String photo;

    private String limit;
    private String offset;

    private String schoolName;              //校区
    private String schoolId;
    private String houseName;               //楼栋
    private String houseId;
    private String floorName;               //楼层
    private String floorId;
    private String roomName;                //房号
    private String roomId;
    private String devStatus;               //设备状态
    private String createdTime;             //创建时间
    private String strCreatedTime;          //创建时间(string)
    private String updatedTime;             //补卡时间
    private String strUpdatedTime;          //补卡时间(string)

    private String remark;                  //备注
    private String personType;              //人员类型
    private String personTypeName;          //人员类型名字

    private String value;//人员编号
    private String title;//人员名称
    private String cardId;//卡号
}

