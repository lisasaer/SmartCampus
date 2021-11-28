package com.zy.SmartCampus.polo;

import lombok.Data;

import java.util.List;

@Data
public class DepartmentTree {
    private Integer parentId;
    private Integer rootId;
    private String title;
    private List<DepartmentTree> children;
    private Boolean spread;

}