package com.zy.SmartCampus.util;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.RequestResult;
import com.zy.SmartCampus.polo.YSRequest;
import org.apache.commons.httpclient.NameValuePair;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
  *@日期 2019/12/20
  *@作者 YDY
  *@描述 萤石工具类
  */
public class YSUtil {

    /**
     * 检测当前token是否过期并且获取token
     * @return
     */
    public static String checkYSAccessToken(){
        String atTime = MyIniUtil.getValue("YS", "atTime");

        if (atTime.length() > 1) {
            //System.out.println(Long.parseLong(atTime));
            Date nowDate = new Date();
            Date atDate = new Date(Long.parseLong(atTime));
            int i2DayTime = 60*60*24*2;    //2天的秒数
            System.out.println("萤石AccessToken到期日期:"+new SimpleDateFormat("yyyy-MM-dd").format(atDate));
            if( (atDate.getTime() - nowDate.getTime()) < i2DayTime) {
                //间隔小于2天就重新获取token , 官方token 有限期7天
                getYSAccessToken();
            }
        } else {
            getYSAccessToken();
        }
        String accessToken = MyIniUtil.getValue("YS","accessToken");
        System.out.println("accessToken:"+accessToken);
        return accessToken;
    }

    /**
     * 获取token
     */
    private static void getYSAccessToken(){
        System.out.println("开始获取accessToken");
        //RequestResult(code=200,
        // reqStr={"data":{"accessToken":"at.0o0wq596bd4sstq0dclrbueg2zgraega-3r9a8q81r9-1k3wewa-b26ulrkxp","expireTime":1577410581733},"code":"200","msg":"操作成功!"}, errorStr=)

        String url = MyIniUtil.getValue("YS","atURL");

        NameValuePair[] data = new NameValuePair[]{
                new NameValuePair("appKey", MyIniUtil.getValue("YS","appKey"))
                , new NameValuePair("appSecret", MyIniUtil.getValue("YS","appSecret"))
        };

        RequestResult result =MyHttpRequestUtil.postXWWWFormUrlencoded(url,data);
        System.out.println(result.toString());
        if(result.getCode() == 200){
            YSRequest ysRequest = JSONObject.parseObject(result.getReqStr(), YSRequest.class);
            System.out.println(ysRequest.toString());
            if(ysRequest.getCode() == 200){
                MyIniUtil.setValue("YS","atTime",ysRequest.getData().getExpireTime()+"");
                MyIniUtil.setValue("YS","accessToken",ysRequest.getData().getAccessToken());
            }
        }
    }
}
