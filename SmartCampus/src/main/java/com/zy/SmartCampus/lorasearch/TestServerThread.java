//package com.zy.SmartCampus.lorasearch;
//
//import com.zy.SmartCampus.service.LoraDevService;
//
//import java.io.*;
//import java.net.ServerSocket;
//import java.net.Socket;
//
//public class TestServerThread extends Thread implements Runnable{
//
//
//    @Override
//    public void run() {
//        try {
//            //创建端口8825的服务器socket
//            ServerSocket ss = new ServerSocket(8825);
//            //在返回客户端socket之前，accept将会一直阻塞
//            Socket s = ss.accept();
//            InputStream inputStream = s.getInputStream();
//            OutputStream outputStream = s.getOutputStream();
//            // 通过输入流接收客户端信息
//            byte[] buf = new byte[2048];
//            int length = 0;
//            length = inputStream.read(buf);
//            int i = 0;
//            /*while(true) {*/
//
//                //OutputStream outputStream = socket.getOutputStream();
//                String msg = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
//                        "<SRV_RESTART_REQ>" +
//                        "<id>7542005130002</id>" +
//                        "</SRV_RESTART_REQ>";
//                byte[] bytes = msg.getBytes();
//                //回复报文的数据长度(4字节)
//                String strLen = getReturnDataLen(bytes.length);
//                //得到返回报文
//                String strReturnData ="FAF5F6"+"0000"+"230000".concat(strLen).concat(bytesToHexString(bytes).concat("FAF6F5"));
//                System.out.println("----------发送重启设备报文-------------：" + strReturnData);
//                System.out.println("发送重启设备报文字符串长度："+strReturnData.length());
//
//                byte[] sendData = hexToByteArray(strReturnData);
//                System.out.println("发送重启设备报文二进制长度：" + sendData.length +";"+sendData);
//                outputStream.write(sendData);
//                //Thread.sleep(200);
//                /*//将接收到的数据在控制台输出 byte转为16进制字符串
//                String string =bytesToHexString(buf);
//                System.out.println("接收到的数据 ： " + string);
//                String header = string.substring(0,16);
//                int length1 = Integer.parseInt(string.substring(16,24),16);
//                String tail = string.substring(length1*2+24,length1*2+30);
//                //服务器给客户端回复注册成功消息
//                String msg ="<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
//                        "<REGISTE_RES>" +
//                        "<id>7542005130002</id>" +
//                        "<ret>0</ret>" +
//                        "</REGISTE_RES>";
//
//                byte[] bytes = msg.getBytes();
//                int length2 = bytesToHexString(bytes).length();
//
//                String strLen = getReturnDataLen(bytes.length);
//                //得到返回报文
//                String strReturnData =header.concat(strLen).concat(bytesToHexString(bytes).concat(tail));
//                System.out.println("777777777788888888888HHHHHHHHHHHHHHHHH-------------：" + strReturnData);
//                byte[] backData = hexToByteArray(strReturnData);
//                System.out.println("返回报文二进制长度：" + backData.length +";"+backData);
//
//                outputStream.write(backData);
//                outputStream.flush();
//
//                System.out.println("返回结束");
//
//                outputStream.close();
//                inputStream.close();*/
//                //s.close();
//            /*}*/
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
//    }
//    /**
//     * 数组转换成十六进制字符串
//     * @param
//     * @return HexString
//     */
//    public static final String bytesToHexString(byte[] bArray)
//    {
//        StringBuffer sb = new StringBuffer(bArray.length);
//        String sTemp;
//        for (int i = 0; i < bArray.length; i++) {
//            sTemp = Integer.toHexString(0xFF & bArray[i]);
//            if (sTemp.length() < 2)
//                sb.append(0);
//            sb.append(sTemp.toUpperCase());
//        }
//        return sb.toString();
//    }
//    /**
//     * 获取hex字符串 并且 奇数位补0
//     * @param i
//     * @return
//     */
//    public static String getReturnDataLen(int i){
//        String hex = Integer.toHexString(i);
//
//        for(int j = 0 ; j <8-Integer.toHexString(i).length() ; j++){
//            hex="0"+hex;
//        }
//        return hex.toUpperCase();
//    }
//    /**
//     * hex字符串转byte数组
//     * @param inHex 待转换的Hex字符串
//     * @return 转换后的byte数组结果
//     */
//    public static byte[] hexToByteArray(String inHex) {
//        int hexlen = inHex.length();
//        byte[] result;
//        if (hexlen % 2 == 1) {
//            // 奇数
//            hexlen++;
//            result = new byte[(hexlen / 2)];
//            inHex = "0" + inHex;
//        } else {
//            // 偶数
//            result = new byte[(hexlen / 2)];
//        }
//        int j = 0;
//        for (int i = 0; i < hexlen; i += 2) {
//            result[j] = hexToByte(inHex.substring(i, i + 2));
//            j++;
//        }
//        return result;
//    }
//    /**
//     * Hex字符串转byte
//     * @param inHex 待转换的Hex字符串
//     * @return 转换后的byte
//     */
//    public static byte hexToByte(String inHex) {
//        return (byte) Integer.parseInt(inHex, 16);
//    }
//}
