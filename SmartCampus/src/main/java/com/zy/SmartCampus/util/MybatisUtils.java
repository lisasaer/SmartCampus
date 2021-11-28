package com.zy.SmartCampus.util;

import java.lang.reflect.Field;

/**@Auther  YDY
  *@Date 2020/3/9
  *@Description mybatis 帮助便捷类
  */
public class MybatisUtils {

    /**
     * 快速生成mybatis的插入sql语句
     * @param cls
     * @param tableName
     * @return
     */
    public static String getEntityInsertSql (Class cls ,String tableName){
        Field[] fields =  cls.getDeclaredFields();
        StringBuffer str = new StringBuffer();
        StringBuffer str2 = new StringBuffer();
        for(Field field : fields){
            str.append(field.getName()+",");
            str2.append("#{"+field.getName()+"},");
        }
        String strRet = "insert into "+tableName+"("+str.delete(str.length()-1,str.length())+") " +
                "values("+str2.delete(str2.length()-1,str2.length())+")";
        System.out.println(strRet);
        return strRet;
    }

    /**
     * 快速生成和实体类字段相同的sql创建表
     * @param cls
     * @param tableName
     * @return
     */
    public static  String getCreateTableSql(Class cls,String tableName){
        Field[] fields =  cls.getDeclaredFields();

        StringBuffer retSql = new StringBuffer();
        retSql.append("create table "+tableName+"(");

        for(Field field : fields){
            retSql.append( field.getName()+" "+changeMySqlType(field.getType())+",");
        }
        retSql.delete(retSql.length()-1,retSql.length()).append(")");

        System.out.println(retSql.toString());
        return retSql.toString();
    }

    /**
     * 转换java与mysql的数据类型
     * @param type
     * @return
     */
    private static String changeMySqlType(Class<?> type){
        if(type.toString().equals("int")){
            return "int(11)";
        }else {
            return "varchar(255)";
        }
    }
}
