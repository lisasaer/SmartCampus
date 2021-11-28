package com.zy.SmartCampus.webSocket;

import com.zy.SmartCampus.util.MyUtil;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;

import java.net.URI;
import java.util.ArrayList;
import java.util.List;

@Component
public class MyWebSocketHander implements WebSocketHandler {

    public static List<WebSocketSession> webSocketList = new ArrayList<>();
    public static List<WebSocketSession> getWebSocketList() {
        return webSocketList;
    }
    @Override
    public void afterConnectionEstablished(WebSocketSession webSocketSession) throws Exception {
        URI uri = webSocketSession.getUri();
//        MyUtil.printfInfo(uri.getPath());   //  /path 带/

        MyUtil.printfInfo("新建连接:"+uri.getPath());
        webSocketList.add(webSocketSession);
        //System.out.println("2222222222222");
        //MyUtil.printfInfo("当前webSocket数量:"+webSocketList.size());

//        String str = webSocketSession.getAttributes().get("ws_user").toString();
//        MyUtil.printfInfo("ws_user"+str);
    }

    @Override
    public void handleMessage(WebSocketSession webSocketSession, WebSocketMessage<?> webSocketMessage) throws Exception {
//        String msgContent = webSocketMessage.getPayload()+"";
//        MyUtil.printfInfo("webSocket msgContent:"+msgContent);
//        TextMessage toMsg = new TextMessage("你好");
//        webSocketSession.sendMessage(toMsg);
    }

    @Override
    public void handleTransportError(WebSocketSession webSocketSession, Throwable throwable) throws Exception {
        webSocketList.remove(webSocketSession);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession webSocketSession, CloseStatus closeStatus) throws Exception {
        MyUtil.printfInfo("失去连接:"+webSocketSession.getUri());
        webSocketList.remove(webSocketSession);
    }

    @Override
    public boolean supportsPartialMessages() {
        return false;
    }
}
