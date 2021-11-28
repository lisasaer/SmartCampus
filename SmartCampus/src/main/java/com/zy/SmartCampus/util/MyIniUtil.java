package com.zy.SmartCampus.util;

import org.ini4j.Ini;

import java.io.File;
import java.io.IOException;

/**
  *@日期 2019/11/23
  *@作者 YDY
  *@描述 ini配置文件工具类
  */
public class MyIniUtil {

    private static String inipath = MyUtil.getRootPath()+"config.ini";

    /**
     * 获取值 name为节点[name]  key为要获取的键
     * @param name
     * @param key
     * @return
     */
    public static String getValue(String name , String key){
        File file = new File(inipath);
        if(!file.exists()){
            System.out.println("无 ini 文件");
            return "";
        }
        Ini ini = new Ini();
        try {
            ini.load(file);
            if(ini.containsKey(name)){
                Ini.Section section = ini.get(name);
                return section.containsKey(key)?section.get(key):"";
            }
            return "";
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("获取ini值IO exception");
            return "";
        }
    }

    /**
     * 修改  name为节点[] key - value 要修改的键值
     * @param name
     * @param key
     * @param value
     */
    public static synchronized void setValue(String name , String key, String value){
        File file = new File(inipath);
        if(!file.exists()){
            System.out.println("无 ini 文件");
            return;
        }
        Ini ini = new Ini();
        try {
            ini.load(file);
            Ini.Section section = ini.get(name);
            section.put(key,value);
            ini.store(file);
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("修改ini值 IO exception");
        }
    }



}
