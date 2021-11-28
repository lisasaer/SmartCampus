import org.apache.commons.codec.binary.Base64;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.InputStream;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;

public class UDPTest {

    public static void main(String[] args) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        DatagramSocket server = null;
        try {
            // 通过5050端口建立UDP服务端
            server = new DatagramSocket(60001);
            System.out.println(sdf.format(new Date()) + " UDP服务监听启动！");
            // 设置接收数据的缓冲区大小
            byte[] recvBuf = new byte[1024];
            // 建立存放数据的数据报
            //DatagramPacket recvPacket = new DatagramPacket(recvBuf, recvBuf.length);
            while (true) {
                // 建立服务端数据监听，此处阻塞
                //server.receive(recvPacket);

                byte[] bs = new byte[1024];
                DatagramPacket packet = new DatagramPacket(bs, bs.length);
                server.receive(packet);
                recvBuf = packet.getData();
                int[] dataFormat=new int[1024];
                for(int i=0;i<recvBuf.length;i++){//对byte数组中的数据进行判断，当为负数时，与0xff相与，并存放在Int数组中，可以保证数据正常
                    if(recvBuf[i]<0){
                        dataFormat[i]=recvBuf[i]&0xff;
                    }else{
                        dataFormat[i]=recvBuf[i];
                    }
                }
                //System.out.println(Arrays.toString(dataFormat));
//                System.out.println(dataFormat.length);

                //卡号
                int s1 = dataFormat[16];
                int s2 = dataFormat[17];
                int s3 = dataFormat[18];
                int s4 = dataFormat[19];

                int a1=dataFormat[4];
                int a2=dataFormat[5];
                int a3=dataFormat[6];
                int a4=dataFormat[7];

                //刷卡类型 0.0=无记录 1=刷卡记录 2=门磁,按钮, 设备启动, 远程开门记录 3=报警记录
                int type = dataFormat[12];

                //0 表示不通过, 1表示通过
                int isPass = dataFormat[13];

                //门号 1,2,3,4
                int doorID = dataFormat[14];

                //进门出门  1表示进门, 2表示出门
                int doorDirection = dataFormat[15];

                //刷卡时间
                int b1 = dataFormat[20];
                int b2 = dataFormat[21];
                int b3 = dataFormat[22];
                int b4 = dataFormat[23];
                int b5 = dataFormat[24];
                int b6 = dataFormat[25];
                int b7 = dataFormat[26];


                long cardNo = getNumUtil(s1,s2,s3,s4);
                long DevSN = getNumUtil(a1,a2,a3,a4);
                System.out.println("卡号:"+cardNo+"---"+"控制器SN:"+DevSN+"---是否通过（0，不通过，1通过）"+isPass+" "+"---门号"+doorID+"---方向（1.进 2出）"+doorDirection);



            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            server.close();
        }
    }

    /**
     *
     * @param a,b,c,d 十进制数据
     * 解析微耕控制器传回来的报文所对应的数据，比如卡号，控制器序列号
     * @return
     */
    public static long getNumUtil(int a,int b,int c,int d){
        //System.out.println("接收数据："+a+" "+b+" "+c+" "+d);
        //第一步：十进制转十六进制
        String strHexS1 = Integer.toHexString(a);
        String strHexS2 = Integer.toHexString(b);
        String strHexS3 = Integer.toHexString(c);
        String strHexS4 = Integer.toHexString(d);

        //个位数的话前面多补上一个0
        if(strHexS1.length()==1){
            strHexS1 = "0"+strHexS1;
        }

        if(strHexS2.length()==1){
            strHexS2 = "0"+strHexS2;
        }

        if(strHexS3.length()==1){
            strHexS3 = "0"+strHexS3;
        }

        if(strHexS4.length()==1){
            strHexS4 = "0"+strHexS4;
        }

        //System.out.println("卡号转十六进制:"+strHexS1+" "+strHexS2+" "+strHexS3+" "+strHexS4);


        //第二步：换位置
        String cardHexID = strHexS4+strHexS3+strHexS2+strHexS1;
        //System.out.println("换位置:"+cardHexID);

        //第三步：转成十进制
//        int valueTen2 = Integer.parseInt(cardHexID,16);
//        System.out.println("最终解析数字"+ valueTen2);

        long valueTen2 = Long.parseLong(cardHexID,16);
        //System.out.println("最终解析数字"+ valueTen2);

        return valueTen2;
    }
}
