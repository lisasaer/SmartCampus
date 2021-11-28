package com.zy.SmartCampus.util;

import com.zy.SmartCampus.polo.RequestResult;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.PostMethod;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;

/**
  *@日期 2019/10/20
  *@作者 YDY
  *@描述 http Request 请求
  */
public class MyHttpRequestUtil {

    /**
     * post 请求
     * @param url
     * @param content
     * @return
     */
    public static String httpPostRequest(String url, String content){
        String errorStr = "";
        String status = "";
        String response = "";
        PrintWriter out = null;
        BufferedReader in = null;
        try {
            URL realUrl = new URL(url);
            // 打开和URL之间的连接
            URLConnection conn = realUrl.openConnection();
            HttpURLConnection httpUrlConnection = (HttpURLConnection) conn;
            // 设置请求属性 application/x-www-form-urlencoded;application/json
            httpUrlConnection.setRequestProperty("Content-Type", "application/json");
            // 发送POST请求必须设置如下两行
            httpUrlConnection.setDoOutput(true);
            httpUrlConnection.setDoInput(true);
            // 获取URLConnection对象对应的输出流

            OutputStreamWriter outWriter = new OutputStreamWriter(conn.getOutputStream(), "utf-8");
            out =new PrintWriter(outWriter);
            //out = new PrintWriter(httpUrlConnection.getOutputStream());

            // 发送请求参数
            out.write(content);
            // flush输出流的缓冲
            out.flush();
            httpUrlConnection.connect();
            // 定义BufferedReader输入流来读取URL的响应
            in = new BufferedReader(new InputStreamReader(httpUrlConnection.getInputStream(),"utf-8"));
            String line;
            while ((line = in.readLine()) != null) {
                response += line;
            }
            status = httpUrlConnection.getResponseCode()+"";
        } catch (Exception e) {
            System.out.println("发送 POST 请求出现异常！" + e);
            errorStr = e.getMessage();
        }

        // 使用finally块来关闭输出流、输入流
        finally {
            try {
                if (out != null) { out.close();}
                if (in != null) {in.close();}
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        System.out.println("status:"+status+"   errorStr:"+errorStr);
        System.out.println("response:"+response);
        return response;
    }

    /**
     * get 请求
     * @param url
     * @return
     */
    public static String httpGetRequest(String url){
        String errorStr = "";
        String status = "";
        String response = "";
        BufferedReader in = null;
        try {
            URL realUrl = new URL(url);
            // 打开和URL之间的连接
            URLConnection conn = realUrl.openConnection();
            HttpURLConnection httpUrlConnection = (HttpURLConnection) conn;
            httpUrlConnection.setRequestProperty("Charset", "utf-8");
            // 设置请求属性
            httpUrlConnection.setRequestProperty("Content-Type", "application/json");
            // 发送POST请求必须设置如下两行
            //httpUrlConnection.setDoOutput(true);
            //httpUrlConnection.setDoInput(true);

            httpUrlConnection.connect();
            // 定义BufferedReader输入流来读取URL的响应
            in = new BufferedReader(new InputStreamReader(httpUrlConnection.getInputStream(),"utf-8"));
            String line;
            while ((line = in.readLine()) != null) {
                response += line;
            }
            status = httpUrlConnection.getResponseCode()+"";
        } catch (Exception e) {
            System.out.println("发送 Get 请求出现异常！" + e.toString());
            errorStr = e.getMessage();
        }
        // 使用finally块来关闭输出流、输入流
        finally {
            try {
                if (in != null) {in.close();}
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        System.out.println("status:"+status+"   errorStr:"+errorStr);
        System.out.println("response:"+response);
        return response;
    }


    public static RequestResult postXWWWFormUrlencoded(String url, NameValuePair[] data){

        PostMethod postMethod = new PostMethod(url);
        postMethod.setRequestHeader("Content-type","application/x-www-form-urlencoded;charset=utf-8");
        postMethod.setRequestBody(data);

        HttpClient httpClient = new HttpClient();
        RequestResult result = new RequestResult();
        try {
            httpClient.setConnectionTimeout(2000);  //连接超时
            httpClient.setTimeout(2000);		    //请求超时

            int responseCode = httpClient.executeMethod(postMethod);
            String resultStr = postMethod.getResponseBodyAsString();
            result.setCode(responseCode);
            result.setReqStr(resultStr);
            result.setErrorStr("");
            return  result;
        } catch (IOException e) {
            result.setCode(-1);
            result.setReqStr("");
            result.setErrorStr(e.toString());
            return result;
        }
    }


}
