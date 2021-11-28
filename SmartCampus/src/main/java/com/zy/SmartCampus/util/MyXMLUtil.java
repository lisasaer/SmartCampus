package com.zy.SmartCampus.util;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

/**
  *@日期 2019/10/20
  *@作者 YDY
  *@描述 XML工具类
  */
public class MyXMLUtil {

    /**
     * 设置 config.xml 路径
     */
    private static String configXMLPath = MyUtil.getRootPath()+"config.xml";

    /**
     * 获取xml 子节点的值  PS：限于根节点下的子节点
     *      * @param strName
     * @return
     * @throws DocumentException
     * @throws IOException
     */
    public static String  getConfigXMLValue(String strName) throws DocumentException, IOException {
        //System.out.println(configXMLPath);

        String strPath = configXMLPath;
        // 创建saxReader对象
        SAXReader reader = new SAXReader();
        // 通过read方法读取一个文件 转换成Document对象
        Document doc = reader.read(new File(strPath));
        // 获取根节点元素对象
        Element rootElement = doc.getRootElement();
        //获取 查找节点
        Element node = rootElement.element(strName);

        return  node.getText();
    }

    /**
     * 根据节点名称修改该节点的值 PS：限于根节点下的子节点
     * @param strName
     * @param strValue
     * @throws DocumentException
     * @throws IOException
     */
    public static void modifyConfigXml(String strName , String strValue) throws DocumentException, IOException {

        String strPath = configXMLPath;
        // 创建saxReader对象
        SAXReader reader = new SAXReader();
        // 通过read方法读取一个文件 转换成Document对象
        Document doc = reader.read(new File(strPath));

        // 获取根节点元素对象
        Element rootElement = doc.getRootElement();
        //获取 节点
        Element node = rootElement.element(strName);
        //修改 节点值
        node.setText(strValue);

        //保存xml
        OutputFormat format = OutputFormat.createPrettyPrint();
        format.setEncoding("UTF-8");

        XMLWriter xmlWriter =new XMLWriter(new FileOutputStream(strPath),format);
        xmlWriter.write(doc);
        xmlWriter.close();
    }
}
