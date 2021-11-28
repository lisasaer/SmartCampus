
//import com.sun.media.jfxmedia.track.Track;
import lombok.SneakyThrows;
//import org.omg.IOP.Encoding;

import javax.sound.sampled.AudioFormat;
import java.io.*;
import java.net.*;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;

public class TestMain {

    public static void main(String[] args) throws Exception{


        new Thread(new Runnable() {

            private final int PORT = 60001;
            private DatagramSocket datagramSocket;

            @SneakyThrows
            @Override
            public void run() {

                try {
                    datagramSocket = new DatagramSocket(PORT);
                    System.out.println("udp服务端已经启动！");
                } catch (Exception e) {
                    datagramSocket = null;
                    System.out.println("udp服务端启动失败！");
                    e.printStackTrace();
                }
//
                byte[] bt = new byte[64];
//                bt[0] = 0x17;
//                bt[1] =(byte) 0x94;
//                bt[2] = 0x00;
//                bt[3] = 0x00;
//                //控制器id
//                bt[4] = (byte) 0x85;
//                bt[6] = (byte) 0xE5;
//                bt[5] = 0x07;
//                bt[7] = 0x0D;


                bt[0] = 0x17;
                bt[1] =(byte) 0x90;
                bt[2] = 0x00;
                bt[3] = 0x00;
                //控制器id
                bt[4] = (byte) 0x85;
                bt[5] = 0x07;
                bt[6] = (byte) 0xE5;
                bt[7] = 0x0D;

//                bt[4] = (byte) 0xc8;
//                bt[6] = (byte) 0x26;
//                bt[5] = (byte)0xef;
//                bt[7] = 0x07;
                bt[4] = (byte) 0x2E;
                bt[6] = (byte) 0xA6;
                bt[5] = (byte)0xD0;
                bt[7] = 0x19;
                //ip
                bt[8] = (byte) 0xC0;
                bt[9] = (byte) 0xA8;
                bt[10] = (byte) 0x00;
                bt[11] = (byte) 0x24;
                //通信端口号
                bt[12] = (byte) 0x61;
                bt[13] = (byte) 0xEA;

//                bt[0] = 0x17;
//                bt[1] =(byte) 0x94;
//                bt[2] = 0x00;
//                bt[3] = 0x00;
//                bt[4] = 0x00;
//                bt[6] = 0x00;
//                bt[5] = 0x00;
//                bt[7] = 0x00;

                DatagramPacket sendPacket = new DatagramPacket(bt, bt.length,InetAddress.getByName("192.168.0.84"),60000);

                try {
                    datagramSocket.send(sendPacket);
                    //datagramSocket.close();

                } catch (IOException ex) {
                    ex.printStackTrace();
                }
                System.out.println("发送完毕");

                byte[] receBuf = new byte[1024];
                DatagramPacket recePacket = new DatagramPacket(receBuf, receBuf.length);

                while (true){

                    datagramSocket.receive(recePacket);//阻塞
                    String receStr = new String(recePacket.getData(), 0 , recePacket.getLength(),"utf-8");
                    System.out.println("接收:"+receStr.length());
                    //System.out.println(receStr);

                    byte[] recvBuf = new byte[1024];
                    recvBuf = recePacket.getData();
                    int[] dataFormat=new int[1024];
                    for(int i=0;i<recvBuf.length;i++){//对byte数组中的数据进行判断，当为负数时，与0xff相与，并存放在Int数组中，可以保证数据正常
                        if(recvBuf[i]<0){
                            dataFormat[i]=recvBuf[i]&0xff;
                        }else{
                            dataFormat[i]=recvBuf[i];
                        }
                    }

                    int a = dataFormat[8];
                    int a1 = dataFormat[9];
                    int a2 = dataFormat[10];
                    int a3 = dataFormat[11];

                    System.out.println("IP："+a+" "+a1+" "+a2+" "+a3);
                }
            }
        }).start();

    }

    /**	 * 16进制直接转换成为字符串(无需Unicode解码)
     * *
     * * @param hexStr
     * * @return	 */
    public static String hexStr2Str(String hexStr) {
        String str = "0123456789ABCDEF";
        char[] hexs = hexStr.toCharArray();
        byte[] bytes = new byte[hexStr.length() / 2];
        int n;
        for (int i = 0; i < bytes.length; i++) {
            n = str.indexOf(hexs[2 * i]) * 16;
            n += str.indexOf(hexs[2 * i + 1]);
            bytes[i] = (byte) (n & 0xff);
        }
        return new String(bytes);
    }

    public static void server(){

    }

    public static void client(){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        DatagramSocket client = null;

        try {
            client = new DatagramSocket();

            BufferedReader brIn = new BufferedReader(new InputStreamReader(System.in));
            // 从系统标准输入读入一字符串
            String readline = brIn.readLine();
            // 若从标准输入读入的字符串为 "bye"则停止循环
            while (!readline.equals("bye")) {
                byte[] sendBuf = readline.getBytes();
                InetAddress addr = InetAddress.getByName("127.0.0.1");
                int port = 9000;
                DatagramPacket sendPacket = new DatagramPacket(sendBuf, sendBuf.length, addr, port);
                client.send(sendPacket);
                System.out.println(sdf.format(new Date()) + " 向UDP服务端发送消息:" + readline);
                System.out.println();
                System.out.print("请输入需要发送给UDP服务端的消息:");
                readline = brIn.readLine();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            client.close();
        }
    }

    /**
     * Hex字符串转byte
     * @param inHex 待转换的Hex字符串
     * @return 转换后的byte
     */
    public static byte hexToByte(String inHex) {
        return (byte) Integer.parseInt(inHex, 16);
    }

    /**
     * hex字符串转byte数组
     * @param inHex 待转换的Hex字符串
     * @return 转换后的byte数组结果
     */
    public static byte[] hexToByteArray(String inHex) {
        int hexlen = inHex.length();
        byte[] result;
        if (hexlen % 2 == 1) {
            // 奇数
            hexlen++;
            result = new byte[(hexlen / 2)];
            inHex = "0" + inHex;
        } else {
            // 偶数
            result = new byte[(hexlen / 2)];
        }
        int j = 0;
        for (int i = 0; i < hexlen; i += 2) {
            result[j] = hexToByte(inHex.substring(i, i + 2));
            j++;
        }
        return result;
    }



}
