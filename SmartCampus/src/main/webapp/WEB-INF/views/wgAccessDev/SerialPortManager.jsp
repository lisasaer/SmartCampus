
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>串口控制</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <%--  layui  --%>
    <link rel="stylesheet" type="text/css" href="/res/layui/css/layui.css">

    <script type="text/javascript" src="/res/layui/layui.js"></script>

    <script src="res/js/jquery.min.js"></script>

    <script src="res/js/myjs.js" ></script>

    <%--  自定义开关样式和js  --%>
    <link rel="stylesheet" type="text/css" href="../../res/css/switch.css">
    <script src="../../res/js/switch.js" ></script>
    <style>
        label{
            margin: 0 10px;
        }
        .div-marginTopBottom{
            margin:15px 0;
        }
        .div-center-body{
            width: 50%;
            text-align: left;
            position: relative;
            left: 50%;
            transform: translate(-50%,0)
        }
    </style>
</head>
<body style="padding: 30px">

<div style="padding: 50px;border: 1px solid #ccc;width: 80%;margin: auto">

    <div style="text-align: center">
        <h1>串口设置</h1>

        <label>串口</label>
        <select id="comName">
            <c:forEach items="${comNameList}" var="vvv">
                <option value="${vvv}">${vvv}</option>
            </c:forEach>
        </select>
        <label>波特率</label>
        <select id="btlConnect">
            <option value="9600">9600</option>
            <option value="19200">19200</option>
        </select>
        <button id="btnOpenSerialPort" onclick="serialPortSetting('open')" >打开串口</button>
        <button id="btnCloseSerialPort" onclick="serialPortSetting('close')">关闭串口</button>
        <script>
            var openState = ${openState};

            function serialPortSetting(msg) {
                var data = {};
                data.comName = $('#comName').val();
                data.btl = $('#btlConnect').val();
                data.msg = msg;
                console.log(data);
                $.post('serialportSetting',{data:JSON.stringify(data)},function (res) {
                    if(Number(res.code) > 0) {
                        openState = !openState;
                        if (openState) {
                            $('#btnCloseSerialPort').removeAttr('disabled');
                            $('#btnOpenSerialPort').attr('disabled','');

                            $('#comName').attr('disabled','');
                            $('#btlConnect').attr('disabled','');
                        }else {
                            $('#btnOpenSerialPort').removeAttr('disabled');
                            $('#btnCloseSerialPort').attr('disabled','');

                            $('#comName').removeAttr('disabled');
                            $('#btlConnect').removeAttr('disabled');
                        }
                    }else {
                        alert(res.msg);
                    }
                })
            }
        </script>
    </div>

    <%--  ////////////////////////////////////////////////////////////////////////////////////////////////////////////      --%>

    <div id="divSwitch" class="div-marginTopBottom" style="text-align: center;margin:0 auto;width: calc(100% - 20px)"></div>



</div>




</body>

<script>
    var ws = null;
    $(function () {
        initSerialPortBtn();

        initSwitch();

        WebSocketTest();
    });

    /*function initSwitch() {
        addSingleSwitch('#divSwitch','分路1');
        addSingleSwitch('#divSwitch','分路2');
        addSingleSwitch('#divSwitch','分路3');
        addSingleSwitch('#divSwitch','分路4');
        addSingleSwitch('#divSwitch','分路5');
        addSingleSwitch('#divSwitch','分路6');
    }*/

    function initSerialPortBtn() {
        var bOpen = ${openState};
        console.log('串口是否打开',bOpen);
        if(!bOpen){
            $('#btnCloseSerialPort').attr('disabled','');
        }else {
            $('#btnOpenSerialPort').attr('disabled','');
            console.log('${serialPortName}');
            $('#comName').val('${serialPortName}');
            $('#comName').attr('disabled','');
            $('#btlConnect').attr('disabled','');
        }
    }

    //webscoket
    function WebSocketTest()
    {
        if ("WebSocket" in window)
        {
            //alert("您的浏览器支持 WebSocket!");
            var host = window.location.host ;
            // 打开一个 web socket
            console.log("ws://"+host+"/sendWs");
            ws = new WebSocket("ws://"+host+"/sendWs");
            ws.onopen = function()
            {
                // Web Socket 已连接上，使用 send() 方法发送数据
                //ws.send("发送数据");


                alert("数据发送中...");
                console.log('ws open');
            };

            /*ws.onmessage = function (evt)
            {
                console.log(evt);
                var received_msg = evt.data;
                console.log('ws message');
                console.log(received_msg);
                console.log(received_msg.substring(22,received_msg.length-2=="1"));
                console.log(received_msg.substring(21,received_msg.length-1));
                console.log(received_msg.substring(9,11));
                if(received_msg.substring(9,11).valueOf()=="温度"){
                    $('#airTemperatureId').val(received_msg.substring(22,received_msg.length-2));
                }else if(received_msg.substring(9,11).valueOf()=="开关"){
                    $('#allSwitch').val(received_msg.substring(21,received_msg.length-1));
                }else if(received_msg.substring(9,11).valueOf()=="湿度"){
                    $('#airHumidityId').val(received_msg.substring(22,received_msg.length-2));
                }else if(received_msg.substring(9,11).valueOf()=="红外"){
                    $('#airStatusId').val(received_msg.substring(22,received_msg.length-2));
                }
                //alert("数据已接收...");
            };*/

            ws.onclose = function()
            {
                // 关闭 websocket
                //alert("连接已关闭...");
                console.log('ws close');

                alert('断开连接,请刷新页面');
            };
        }
        else
        {
            // 浏览器不支持 WebSocket
            alert("您的浏览器不支持 WebSocket!");
        }
    }
    //关闭ws
    function wsClose() {
        if(ws != null){
            ws.close();
            ws = null;
        }
    }
</script>


</html>
