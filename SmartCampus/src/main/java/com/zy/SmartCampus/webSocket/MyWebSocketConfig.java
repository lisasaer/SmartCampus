package com.zy.SmartCampus.webSocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@Component
@EnableWebSocket
public class MyWebSocketConfig implements WebSocketConfigurer {


    @Autowired
    private MyWebSocketHander myWebSocketHander;

    //添加websocket处理器，添加握手拦截器  拦截器先执行 然后到处理器

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry webSocketHandlerRegistry) {
        //webSocketHandlerRegistry.addHandler(myWebSocketHander,"realWs","sendWs","alarmWs","scWs","WgAccessOpenDoor").addInterceptors(new MyHandShakeInterceptor());

        webSocketHandlerRegistry.addHandler(myWebSocketHander,"recordWSL").addInterceptors(new MyHandShakeInterceptor());
        webSocketHandlerRegistry.addHandler(myWebSocketHander,"realEnergyConsumption").addInterceptors(new MyHandShakeInterceptor());
        webSocketHandlerRegistry.addHandler(myWebSocketHander,"switchData").addInterceptors(new MyHandShakeInterceptor());
        webSocketHandlerRegistry.addHandler(myWebSocketHander,"WgAccessOpenDoor").addInterceptors(new MyHandShakeInterceptor());
        webSocketHandlerRegistry.addHandler(myWebSocketHander,"noiseRealData").addInterceptors(new MyHandShakeInterceptor());
        //20210803-dzb add
        webSocketHandlerRegistry.addHandler(myWebSocketHander,"refreshZigBeeView").addInterceptors(new MyHandShakeInterceptor());
    }
}