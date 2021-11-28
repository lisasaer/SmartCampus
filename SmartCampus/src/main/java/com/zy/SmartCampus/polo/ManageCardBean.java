package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class ManageCardBean {
    private String cardId;  //卡ID
    private String id;
    private String value;   //人员编号
    private String title;   //人员名称

    private String photo;
    private String departmentName;//部门名称
}
