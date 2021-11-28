package com.zy.SmartCampus.polo;

import lombok.Data;

@Data
public class RequestResult {
    private int code;
    private String reqStr;
    private String errorStr;
}
