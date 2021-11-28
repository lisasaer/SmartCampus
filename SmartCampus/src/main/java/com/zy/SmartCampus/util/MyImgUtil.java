package com.zy.SmartCampus.util;

import org.apache.commons.codec.binary.Base64;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;

/**
  *@日期 2019/11/27
  *@作者 YDY
  *@描述 base64图片工具类
  */
public class MyImgUtil {

    /**
     * 获取base64字符串图片
     * @param filePath
     * @return
     */
    public static String getBase64ImgString(String filePath){
        String base64 = "";
        File file = new File(filePath);
        try {
            FileInputStream fin = new FileInputStream(file);
            byte[] bytes = new byte[fin.available()];
            fin.read(bytes);
            base64 = Base64.encodeBase64String(bytes);
            fin.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return base64;
    }


    /**
     * base64图片字符串数据保存本地
     * @param imgBase64
     * @param imgPath
     */
    public static void saveBase64Img(String imgBase64,String imgPath){
        byte[] imgData = Base64.decodeBase64(imgBase64);
        try {
            FileOutputStream fout = new FileOutputStream(new File(imgPath));
            fout.write(imgData);
            fout.flush();
            fout.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    /**
     * 裁剪人脸采集图片
     * @param picPath
     * @return
     * @throws IOException
     */
    public static boolean cutPic(String picPath) throws IOException {
        BufferedImage bufferedImage = ImageIO.read(new File(picPath));
        int w = 295;
        int h = 413;
        int x = (bufferedImage.getWidth()-w)/2;
        int y = (bufferedImage.getHeight()-h)/2;
        BufferedImage saveBufferImage = bufferedImage.getSubimage(x,y,w,h);
        boolean bSave = ImageIO.write(saveBufferImage,"PNG",new File(picPath));
        //MyUtil.printfInfo("bSave  "+String.valueOf(bSave));
        return  bSave;
    }



}
