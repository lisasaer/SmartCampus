package com.zy.SmartCampus.util;

import org.dom4j.DocumentException;

import java.io.*;
import java.net.Socket;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.UUID;

/**
  *@日期 2019/9/20
  *@作者 YDY
  *@描述 综合工具类
  */
public class MyUtil {

    public static String getSlaveId(int id){
        return getHexStringByInt(id);
    }

    public static String getSlaveId(String id){
        return getHexStringByInt(Integer.parseInt(id));
    }

    public static short byte2short(byte[] b){
        short l = 0;
        for (int i = 0; i < 2; i++) {
            l<<=8;
            l |= (b[i] & 0xff);
        }
        return l;
    }

    /**
     * 获取hex字符串 并且 奇数位补0
     * @param i
     * @return
     */
    public static String getHexStringByInt(int i){
        String hex = Integer.toHexString(i);
        if(hex.length() % 2 != 0){
            hex = "0"+hex;
        }
        return hex;
    }

    public static int getUnsignedByte (byte data){      //将data字节型数据转换为0~255 (0xFF 即BYTE)。
        return data&0x0FF ;
    }

    /**
     * "{1}{2,3}{4,5,6}"  json字符串分割
     * @param strJsonArray
     * @return
     */
    public static ArrayList<String> splitStrJsonArray (String strJsonArray)
    {
//        System.out.println("字符串长"+strJsonArray.length());
        int index = 0;
        ArrayList<String> strArray = new ArrayList<String>();
        String str;
        while ( index < strJsonArray.length()){
            int tempIndex = strJsonArray.indexOf("}",index);
            str = strJsonArray.substring(index,tempIndex+1);
            strArray.add(str);
            index = tempIndex + 1;
            //System.out.println("index"+index+"   length"+strJsonArray.length());
        }
//        System.out.println("===============");
//        System.out.println("index "+index);
//        for(String s : strArray) {
//            System.out.println("s "+s);
//        }
        return  strArray;
    }

    /**
     * 数字经纬度转 度分秒
     * @param geoNum 经度或者纬度
     * @param isLonOrLat 输入的经度为true 纬度为false
     * @return String类型的度分
     */
    public static String getLonLatByNum(int geoNum, boolean isLonOrLat) {
        DecimalFormat df   = new DecimalFormat("######0.000");//double取3位小数
        double dLonOrLat = (double) geoNum / 10000000;
        double duPointPart = dLonOrLat - (long) dLonOrLat;
        double fen = duPointPart * 60;
        double fenPointPart = fen - (long) fen;
        double miao = fenPointPart * 60;
        int idu = (int) dLonOrLat;
        int ifen = (int) fen;
        int imiao = (int) miao;

        String ESWN = "";
        if(isLonOrLat){
            if(geoNum>=0){
                ESWN = "E";
            }else{
                ESWN = "W";
            }
        }else {
            if(geoNum>=0){
                ESWN = "N";
            }else{
                ESWN = "S";
            }
        }
//        return zeroFill(Math.abs(idu)) + "°" + df.format(Math.abs(fen)) + "′" + ESWN;
//        return zeroFill(idu) + "°" + zeroFill(ifen) + "′" + zeroFill(imiao) + "″"+ESWN;
        return zeroFill(idu) + "," + zeroFill(ifen) + "," + zeroFill(imiao)+ ","+ESWN;    //127,50,10;
    }

    /**
     * 经纬度补零
     * @param value
     * @return
     */
    public static String zeroFill(int value){
        String strValue = String.valueOf(Math.abs(value));
        if(strValue.length()==1){
            return "0"+strValue;
        }
        else {
            return strValue;
        }
    }

    /**
     * 将控制台的信息写入到文件中
     */
    public static void writeDiskInfo()  {
        //0 不输出打印到txt , 1 输出打印到txt ;
        try {
                if(!MyXMLUtil.getConfigXMLValue("printfOut").equals("1")){
                return;
            }
        } catch (DocumentException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");//设置日期格式

        String dirName = MyUtil.getRootPath()+"log/";

        String fileName = df.format(new Date())+".txt";
        File file = new File(dirName + fileName);

        // 当文件目录不存在时
        if (!file.getParentFile().exists()) {
            file.getParentFile().mkdirs();// 创建文件目录
        }
        try {
            file.createNewFile();// 创建文件
            FileOutputStream fileOutputStream = new FileOutputStream(file,true);
            PrintStream printStream = new PrintStream(fileOutputStream);
            System.setOut(printStream);// 重新分配标准输出流
            //System.out.println("world");
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 根据文件名称路径 称创建文件所在的路径
     * @param path
     * @return
     */
    public static boolean mkDir(String path){
        boolean bRet = false;
        File file = new File(path);
        if(!file.exists()){
            bRet = file.mkdirs();// 创建文件目录
        }
        return bRet;
    }
    /**
     * 日期格式
     */
    public static SimpleDateFormat g_SimpledataFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//设置日期格式 HH 24小时，hh 12小时

    /**
     * 保存文件名的日期格式 （不能带 空格 和 : ）
     */
    public static SimpleDateFormat g_saveFormat = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");

    /**
     * 获取当前时间
     * @return
     */
    public static String getNowDateTime (){
        return  g_saveFormat.format(new Date());
    }

    /**
     * 日期时间输入打印信息
     * @param string
     */
    public static void printfInfo(String string){
        System.out.println(">>>>>>>"+g_SimpledataFormat.format(new Date())+" [INFO] "+string);
    }

    /**
     * 换行输出信息  便于打印信息查看
     */
    public static  void printflnInfo(String str){
        System.out.println(">>>>>>>"+g_SimpledataFormat.format(new Date())+" [INFO] "+str);
    }

    /**
     * 打印错误信息
     * @param string
     */
    public static void printfError(String string){
        System.out.println(">>>>>>>"+g_SimpledataFormat.format(new Date())+" [ERROR] "+string);
    }

    /**
     * 打印错误信息
     * @param string
     */
//    public static void printfOther(String string) throws IOException, DocumentException {
//        if(MyXMLUtil.getConfigXMLValue("otherLog").equals("1")){
//            System.out.println(">>>>>>>"+g_SimpledataFormat.format(new Date())+" [OTHER] "+string);
//        }
//    }

    /**
     * 10 进制 转 16
     * @param wDec
     * @return
     */
    public static short DecToHex(short wDec){

        int i = (wDec / 1000) * 4096 + ((wDec % 1000) / 100) * 256 + ((wDec % 100) / 10) * 16 + (wDec % 10);
        //MyUtil.printfInfo("Dec "+ wDec +" Hex "+(short)i);
        return (short)i;
    }

    /**
     *  16 进制 转 10
     * @param wHex
     * @return
     */
    public static short  HexToDec(short wHex)
    {
        int i = (wHex / 4096) * 1000 + ((wHex % 4096) / 256) * 100 + ((wHex % 256) / 16) * 10 + (wHex % 16);
        return (short)i;
    }

    /**
     * 获取 随机 UUID
     * @return
     */
    public static String getUUID(){
        String strUUID = UUID.randomUUID().toString().replace("-","");
        //MyUtil.printfInfo("UUID "+strUUID);
        return strUUID;
    }

    /**
     * 根据session 获取 areaIds
     * @param session
     * @return
     */
//    public static String[] getAreaIds(HttpSession session){
//        String[] ids = null;
//        User user = (User)session.getAttribute("user");
//        if(user != null){
//            if(user.getAreaId().length() > 3){
//                ids = user.getAreaId().split(",");
//            }
//        }
//        return  ids;
//    }

    /**
     * 获取 WEB-INF 文件夹所在的上一级文件夹路径 自带/
     * @return
     */
    public static String getRootPath(){
        String  classPath = MyUtil.class.getResource("/").getPath();
        String  bRetPath = classPath.substring(1,classPath.indexOf("WEB-INF"));

        return  bRetPath;
    }

    /**
     * 获取 WEB-INF 目录 自带/
     * @return
     */
    public static String getWEBINFPath(){
        String  classPath = MyUtil.class.getResource("/").getPath();
        String  bRetPath = classPath.substring(1,classPath.indexOf("WEB-INF/classes"));

        return  bRetPath;
    }

    /**
     * 去除时间的空格和:  如 2019-11-11 11：11：11 变成 2019-11-11-11-11-11
     * @param strTime
     * @return
     */
    public static String getTimeCanSave(String strTime) throws ParseException {
        Date dateFromStr = g_SimpledataFormat.parse(strTime.replace("/","-").replace("\\","-"));
        String strRet = g_saveFormat.format(dateFromStr);
        //MyUtil.printfInfo(strRet);
        return  strRet;
    }

    /**
     * 指定tcp socket 发送数据
     * @param socket
     * @param msg
     * @throws IOException
     */
    public static void sendMsgToTcpClient(Socket socket,byte[] msg) throws IOException {

        if(socket != null ){
//            if(socket.isClosed()){
//                MyListener.g_socketList.remove(socket);
//                MyUtil.printflnInfo("socket 已关闭");
//                return;
//            }
            OutputStream out = socket.getOutputStream();
            out.write(msg);
            out.flush();
        }
    }


    /**
     * 字符串数组是否包含
     * @param strs
     * @param s
     * @return
     */
    public static boolean isHaveString(String[] strs,String s){
        /*此方法有两个参数，第一个是要查找的字符串数组，第二个是要查找的字符或字符串
         * */
        for(int i=0;i<strs.length;i++){
            if(strs[i].indexOf(s)!=-1){//循环查找字符串数组中的每个字符串中是否包含所有查找的内容
                return true;//查找到了就返回真，不在继续查询
            }
        }
        return false;//没找到返回false
    }


    /**
     * hex转byte数组
     * @param hex
     * @return
     */
    public static byte[] hexToByteArray(String hex){
        int m = 0, n = 0;
        int byteLen = hex.length() / 2; // 每两个字符描述一个字节
        byte[] ret = new byte[byteLen];
        for (int i = 0; i < byteLen; i++) {
            m = i * 2 + 1;
            n = m + 1;
            int intVal = Integer.decode("0x" + hex.substring(i * 2, m) + hex.substring(m, n));
            ret[i] = Byte.valueOf((byte)intVal);
        }
        return ret;
    }

    /**
    * 图片转字符串
    * @param filePath
    * @return
    */
    public static String getImageStr(String filePath) {
        InputStream inputStream = null;
        byte[] data = null;
        try {
            inputStream = new FileInputStream(filePath);
            data = new byte[inputStream.available()];
            inputStream.read(data);
            inputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        // 加密
        return HexStringUtil.encodeHexStr(data);
    }

    /**
     * int 转 byte
     * @param i
     * @return
     */
    public static byte[] int2ByteArray(int i){
        byte[] result=new byte[4];
        result[0]=(byte)((i >> 24)& 0xFF);
        result[1]=(byte)((i >> 16)& 0xFF);
        result[2]=(byte)((i >> 8)& 0xFF);
        result[3]=(byte)(i & 0xFF);
        return result;
    }


    /**
     * 图片上传路径相关function
     */
    private static final String UP_LOAD_IMG = "fileDir/uploadImg/";

    public static String getFileDirUploadImgName(){
        return UP_LOAD_IMG;
    }

    public static String getFileDirUploadImgPath(){
        String path = getRootPath()+UP_LOAD_IMG;
        mkDir(path);
        return path;
    }



    private static final String ANDSERVER_IMG = "fileDir/andServerImg/";

    public static String getFileDirAndServerImgName(){
        return ANDSERVER_IMG;
    }

    public static String getFileDirAndServerImgPath(){
        String path = getRootPath()+ANDSERVER_IMG;
        mkDir(path);
        return path;
    }


}
