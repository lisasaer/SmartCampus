package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class Department {
    private Integer departmentid;

    private String dname;

    private String positionId;
    private Integer parentId;
}