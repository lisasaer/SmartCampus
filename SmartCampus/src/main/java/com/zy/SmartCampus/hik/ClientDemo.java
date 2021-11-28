package com.zy.SmartCampus.hik;

import java.io.UnsupportedEncodingException;

public class ClientDemo {

    public static String DLL_PATH;

    static {
        String classPath = ClientDemo.class.getResource("/").getPath();
        String path = classPath.replaceAll("%20", " ").substring(1,classPath.indexOf("classes")).replace("/", "\\");
        try {
            DLL_PATH = java.net.URLDecoder.decode(path, "utf-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

    }
}