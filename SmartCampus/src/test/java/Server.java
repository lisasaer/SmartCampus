import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Server {
    public static void main(String[] args) throws Exception{
//        InetAddress iAddress;
//        InetAddress iAddress2;
//        try {
//             //获取本机的地址
//             iAddress = InetAddress.getLocalHost();
//             System.out.println("主机名：" + iAddress.getHostName());
//             System.out.println("字符串ip：" + iAddress.getHostAddress());
//             iAddress2 = InetAddress.getByName("www.baidu.com");
//             //注意事项：有可能返回的主机ip有很多,只是显示了中的一个
//             System.out.println(iAddress2.getHostAddress());
//             } catch (UnknownHostException e) {
//             e.printStackTrace();
//             }
//        String cmd = "arp -a";
//        try {
//            Process process = Runtime.getRuntime().exec(cmd);
//            InputStream is = process.getInputStream();
//            InputStreamReader isr = new InputStreamReader(is);
//            BufferedReader br = new BufferedReader(isr);
//            String content = br.readLine();
//            while (content != null) {
//                System.out.println(content);
//                content = br.readLine();
//            }
//        }
//        catch (IOException e) {
//            e.printStackTrace();
//        }
//        String aa = "c0";
//        byte a =  (byte)Integer.parseInt(aa,16);
//        System.out.println(a);

//        byte[] cc = new byte[4];
//        int bb = 233113477;
//        String ss = Integer.toHexString(bb);
//        if(ss.length()==7){
//            ss = "0"+ss;
//        }
//
//        System.out.println(ss);
//        for(int i = 0;i<4;i++){
//           String dd = ss.substring(i*2,i*2+2);
//            System.out.println(dd);
//            byte a =  (byte)Integer.parseInt(dd,16);
//            cc[3-i] = a ;
//            //System.out.println(ss);
//        }
// test
        String timeSecond = "7";
        if(timeSecond.length()==0){
            timeSecond = "0"+timeSecond;
        }
        System.out.println(timeSecond);


    }
}
