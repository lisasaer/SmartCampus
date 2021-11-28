package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class StatementDetail {
    private int staffId;
    private String name;
    private String sex;
    private String department;
    private String position;
    private int lateCount;
    private int leaveCount;
    private int overtime;
    private int absenteeism;
    private int unswiped;
    private String dName;
    private String pName;
}
