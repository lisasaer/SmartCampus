package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class SignInDetail {
    private Integer signInId;
    private String name;
    private String sex;
    private String dName;
    private String pName;
    private String email;
    private Integer positionId;
    private Integer telphone;
    private Integer staffId;
    private String date;
    private String birth;
    private Integer state;
    private String stateName;

    public void setDate(String date) {
        this.date = date.substring(0, 19);
    }
}
