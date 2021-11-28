<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>test</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <!-- layui -->
    <link rel="stylesheet" type="text/css" href="/res/layui/css/layui.css">

    <script type="text/javascript" src="/res/layui/layui.js"></script>

    <script src="res/js/jquery.min.js"></script>

    <script src="res/js/myjs.js" ></script>

    <%--  自定义开关样式和js  --%>
    <link rel="stylesheet" type="text/css" href="../res/css/switch.css">
    <script src="../res/js/switch.js" ></script>
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
<body style="padding: 30px;">

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
                        if(Number(res.code) > 0){
                            openState = !openState;
                            if(openState){
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

<%--  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////      --%>

        <div id="divSwitch" class="div-marginTopBottom" style="text-align: center;margin:0 auto;width: calc(100% - 20px)"></div>

        <div style="text-align: center " class="div-marginTopBottom">
            <h1>曼顿开关闸</h1>

            <div  class="div-marginTopBottom div-center-body">
                <div class="div-marginTopBottom">
                    <label>当前发送指令（不含CRC）：</label><input readonly id="msgInput">
                </div>
                <div class="div-marginTopBottom">
                    <label>从机地址:</label>
                    <input id="slaveId" min="1" max="254" type="number" value="1" style="width: 50px;">

                    <label>开关地址:</label>
                    <input id="address" min="1" max="254" type="number" value="1" style="width: 50px;">

                    <button onclick="btnSetting('open')">开闸</button>
                    <button onclick="btnSetting('close')">合闸</button>
                    <button onclick="btnSetting('openAll')">全开</button>
                    <button onclick="btnSetting('closeAll')">全合</button>
                </div>
                <div class="div-marginTopBottom">
                    <button onclick="btnSetting('readSwitchAll')">读取所有存在的开关</button>
                    <input type="text" id="allSwitch" readonly>
                </div>
                <div class="div-marginTopBottom">
                    <button onclick="btnSetting('readLineVoltage')">读取线路电压(V)</button>
                    <input type="text" id="lineVoltage" readonly>
                </div>
                <div class="div-marginTopBottom">
                    <button onclick="btnSetting('readLineCurrent')">读取线路电流(A)</button>
                    <input type="text" id="lineCurrent" readonly>
                </div>
                <div class="div-marginTopBottom">
                    <button onclick="btnSetting('readLinePower')">读取线路功率(W)</button>
                    <input type="text" id="linePower" readonly>
                </div>
                <div class="div-marginTopBottom">
                    <button onclick="btnSetting('readLeakageCurrent')">读取漏电电流(A)</button>
                    <input type="text" id="leakageCurrent" readonly>
                </div>
                <div class="div-marginTopBottom">
                    <button onclick="btnSetting('readModuleTemperature')">读取模块温度(度)</button>
                    <input type="text" id="moduleTemperature" readonly>
                </div>
                <div class="div-marginTopBottom">
                    <label>底层开关 自动地址触发</label>
                    <button onclick="btnSetting('startAutoAddress')">开始</button>
                    <button onclick="btnSetting('endAutoAddress')">  结束</button>
                </div>
                <div class="div-marginTopBottom">
                    <label>修改从机地址:</label>
                    <input type="number" min="1" id="modifyAddressInput" style="width: 50px;">
                    <button onclick="btnSetting('modifySlaveId')">修改</button>
                </div>
                <div class="div-marginTopBottom">
                    <label>修改波特率(默认19200):</label>
                    <select id="selectBtl">
                        <option value="3">9600</option>
                        <option value="5">19200</option>
                    </select>
                    <button  onclick="btnSetting('modifyBtl')">修改</button>
                </div>
            </div>

            <script>
                function btnSetting(msg) {
                    var slaveId = MyUtil.getHexUpperString($('#slaveId').val());
                    var address = MyUtil.getHexUpperString((Number($('#address').val())-1));

                    var data = '';
                    console.log('slaveId',slaveId,'address',address);

                    if(msg == 'open'){
                        if(address.length < 1){
                            alert('请输入开关地址');
                            return;
                        }
                        data = slaveId+'0500'+address+'0000';
                    }else if(msg == 'close'){
                        if(address.length < 1){
                            alert('请输入开关地址');
                            return;
                        }
                        data = slaveId+'0500'+address+'FF00';
                    }else if(msg == 'openAll'){
                        data = slaveId+'0500FF0000';
                    }else if(msg == 'closeAll'){
                        data = slaveId+'0500FFFF00';
                    }else if(msg == 'readSwitchAll'){
                        $('#allSwitch').val('');
                        data = slaveId+'01000000FF';
                    }else if(msg == 'readLineVoltage'){//2020-5-9 hhp
                        $('#lineVoltage').val('');
                        data = slaveId+'0300'+address+'0002';
                    }else if(msg == 'readLeakageCurrent'){
                        $('#leakageCurrent').val('');
                        data = slaveId+'0301'+address+'0002';
                    }else if(msg == 'readLinePower'){
                        $('#linePower').val('');
                        data = slaveId+'0302'+address+'0002';
                    }else if(msg == 'readModuleTemperature'){
                        $('#moduleTemperature').val('');
                        data = slaveId+'0303'+address+'0002';
                    }else if(msg == 'readLineCurrent'){
                        $('#lineCurrent').val('');
                        data = slaveId+'0304'+address+'0002';
                    }else if(msg == 'startAutoAddress'){
                        data = slaveId + '0601F0FF00';
                    }else if(msg == 'endAutoAddress'){
                        data = slaveId + '0601F00000';
                    }else if(msg == 'modifySlaveId'){
                        var newAddress = $('#modifyAddressInput').val();
                        if(newAddress.length < 1){
                            alert('请输入从机地址');
                            return;
                        }
                        data = slaveId + '0602F0BA'+MyUtil.getHexUpperString(newAddress);
                    }else if(msg == 'modifyBtl'){
                        var btl = $('#selectBtl').val();
                        data = slaveId + '0603F0BA'+MyUtil.getHexUpperString(btl);
                    }
                    console.log('data',data);
                    $('#msgInput').val(data);
                    $.post('testduankou',{data:data},function (res) {
                        console.log(res);
                    })
                }
            </script>
        </div>
<%--  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////      --%>
        <div style="text-align: center;">
            <h1>空调控制</h1>
            <div class="div-center-body">
                <div class="div-marginTopBottom">
                    <label>从机地址</label>
                    <input id="airSlaveId" value="1" style="width: 50px;" type="number" min="1" max="247">
                    <select name="airSelect" class="layui-hide">
                        <option value="0300010001">读取温度</option>
                        <option value="0300060001">读取湿度</option>
                        <option value="0300070001">读取人体红外状态</option>
                        <option value="06014B0000">关闭继电器</option>
                        <option value="06014B0001">开启继电器</option>
                    </select>
                    <button class="layui-hide" onclick="airSend('send')">发送</button>

                    <button onclick="airSend('0300010001')">读取温度(摄氏度)</button>
                    <input id="airTemperatureId" style="width: 50px;" type="number" min="1" max="247" readonly="readonly">
                    <button onclick="airSend('0300060001')">读取湿度(%)</button>
                    <input id="airHumidityId" style="width: 50px;" type="number" min="1" max="247" readonly="readonly">
                    <button onclick="airSend('0300070001')">读取人体红外状态</button>
                    <input id="airStatusId" style="width: 50px;" type="text" min="1" max="247" readonly="readonly">
                    <button onclick="airSend('06014B0000')">关闭继电器</button>
                    <button onclick="airSend('06014B0001')">开启继电器</button>

                </div>
                <div class="div-marginTopBottom">
                    <label>修改地址</label>
                    <input id="modifyAirAddressInput" style="width: 50px;" type="number" max="247" min="1">
                    <button onclick="airSend('modify')">修改</button>
                </div>
                <script>
                    function airSend(str) {
                        var airSlaveId = MyUtil.getHexUpperString($('#airSlaveId').val());
                        var data = '';
                        data = airSlaveId+str;

                        //空调控制--修改地址()
                        console.log('airSlaveId',airSlaveId)
                        if(str == 'send'){
                            data = airSlaveId +$('[name="airSelect"]').val();
                        }else if(str == 'modify'){
                            var airAddress = $('#airSlaveId').val();
                            if(airAddress.length < 1){
                                alert('请输入从机地址');
                                return;
                            }
                            var newSlaveId = MyUtil.getHexUpperString($('#modifyAirAddressInput').val());
                            data = airSlaveId + '06015500'+newSlaveId;
                        }
                        console.log(data);

                        $.post('testduankou',{data:data},function (res) {
                            console.log("res="+res);
                        })
                    }
                </script>

                <div style="display:none;">
                    <label>直接指令下发</label>
                    <select id="select">
                        <option value="01060155000219E7">修改地址为2</option>
                        <option value="0206014B0000">关闭继电器</option>
                        <option value="0206014B0001">开启继电器</option>

                        <option value="010300010001">读取温度</option>
                        <option value="010300060001">读取湿度</option>
                    </select>
                    <button onclick="sendSP()">发送串口指令</button>
                    <script>
                        function sendSP() {
                            console.log('sendSP');
                            var data = $('#select').val();
                            data = data.replace(/\s*/g,"");
                            console.log("data:"+data);
                            $.post('testduankou',{data:data},function (res) {
                                console.log("res="+res);
                            })
                        }
                    </script>
                </div>
            </div>
        </div>
    </div>
</body>

<script>
    var ws = null;
    $(function () {
        initSerialPortBtn();

        initSwitch();

        WebSocketTest();
    });

    function initSwitch() {
        addSingleSwitch('#divSwitch','分路1');
        addSingleSwitch('#divSwitch','分路2');
        addSingleSwitch('#divSwitch','分路3');
        addSingleSwitch('#divSwitch','分路4');
        addSingleSwitch('#divSwitch','分路5');
        addSingleSwitch('#divSwitch','分路6');
    }

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
                //alert("数据发送中...");
                console.log('ws open');
            };

            ws.onmessage = function (evt)
            {
                console.log(evt);
                var received_msg = evt.data;
                console.log('ws message');
                console.log(received_msg);
                console.log(received_msg.substring(21,received_msg.length-1));
                console.log(received_msg.substring(9,11));
                console.log(received_msg.substring(9,13));
                if(received_msg.substring(9,11).valueOf()=="温度"){
                    $('#airTemperatureId').val(received_msg.substring(22,received_msg.length-2));
                }else if(received_msg.substring(9,11).valueOf()=="开关"){
                    $('#allSwitch').val(received_msg.substring(21,received_msg.length-1));
                }else if(received_msg.substring(9,11).valueOf()=="湿度"){
                    $('#airHumidityId').val(received_msg.substring(22,received_msg.length-2));
                }else if(received_msg.substring(9,11).valueOf()=="红外"){
                    $('#airStatusId').val(received_msg.substring(22,received_msg.length-2));
                }else if(received_msg.substring(9,13).valueOf()=="线路电压"){
                    $('#lineVoltage').val(received_msg.substring(24,received_msg.length-2));
                }else if(received_msg.substring(9,13).valueOf()=="线路电流"){
                    $('#lineCurrent').val(received_msg.substring(24,received_msg.length-2));
                }else if(received_msg.substring(9,13).valueOf()=="线路功率"){
                    $('#linePower').val(received_msg.substring(24,received_msg.length-2));
                }else if(received_msg.substring(9,13).valueOf()=="漏电电流"){
                    $('#leakageCurrent').val(received_msg.substring(24,received_msg.length-2));
                }else if(received_msg.substring(9,13).valueOf()=="模块温度"){
                    $('#moduleTemperature').val(received_msg.substring(24,received_msg.length-2));
                }


                //alert("数据已接收...");
            };

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



