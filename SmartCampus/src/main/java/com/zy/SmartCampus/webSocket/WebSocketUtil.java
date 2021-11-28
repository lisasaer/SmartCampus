package com.zy.SmartCampus.webSocket;

import com.alibaba.fastjson.JSONObject;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class WebSocketUtil {

    public static final String PATH_SEND_WS = "/sendWs";
    public static final String PATH_SEND_WS_REFRESH_ZIGBEEVIEW = "/refreshZigBeeView";

    private static  WebSocketUtil webSocketUtil = null;

    public static  WebSocketUtil  getInstance(){
        if(webSocketUtil == null){
            webSocketUtil = new WebSocketUtil();
        }
        return webSocketUtil;
    }


    public void sendMsgToWeb(String msg,String path){
        for(WebSocketSession webSocketSession:MyWebSocketHander.webSocketList){
            if(webSocketSession.getUri().getPath().equals(path)){
                try {
                    System.out.println("发送的消息："+msg);
                    webSocketSession.sendMessage(new TextMessage(msg));
                } catch (IOException e){
                    System.out.println("ws send exception : " +e.toString());
                }
            }
        }
    }

    public void sendMsgToWeb(JSONObject json, String path){
        for(WebSocketSession webSocketSession:MyWebSocketHander.webSocketList){
            if(webSocketSession.getUri().getPath().equals(path)){
                try {
                    webSocketSession.sendMessage(new TextMessage(json.toJSONString()));
                } catch (IOException e){
                    System.out.println("ws send exception : " +e.toString());
                }
            }
        }
    }

    public void sendJsonMsgToWeb(JSONObject json, String path){
        for(WebSocketSession webSocketSession:MyWebSocketHander.webSocketList){
            if(webSocketSession.getUri().getPath().equals(path)){
                try {
                    webSocketSession.sendMessage(new TextMessage(json.toJSONString()));
                } catch (IOException e){
                    System.out.println("ws send exception : " +e.toString());
                }
            }
        }
    }

    //public static void sendMsgToCattleWS(JSONObject json){ sendMsgToHtml(json,"/recordWS"); }

//    public static void sendMsgToHtml(String msg,String path){
//        for(WebSocketSession socketSession : MyWebSocketHander.getWebSocketList()){
//            if(socketSession.getUri().getPath().equals(path)){
//                try {
//                    socketSession.sendMessage(new TextMessage(msg));
//                } catch (IOException e) {
//                    e.printStackTrace();
//                }
//            }
//        }
//    }
//    public static void sendMsgToHtml(JSONObject msg, String path){
//        sendMsgToHtml(msg.toJSONString(),path);
//    }

}
