package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class StatementBean {
    private String name;
    private Integer departmentId;
    private String time;
    private String mTime;
    private String eTime;
    private String page;
    private String limit;
    private int state;
    private int start;
    private int size;
    private int staffId;
}
