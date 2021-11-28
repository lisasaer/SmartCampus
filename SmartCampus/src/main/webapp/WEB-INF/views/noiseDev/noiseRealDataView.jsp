<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 2020-12-14
  Time: 16:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>实时噪声数据</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <jsp:include page="../header/res.jsp" ></jsp:include>
    <style>
        /*去掉table顶部栏标签*/
        .layui-table-tool-self {
            display: none;
        }
        /*去除table表单外边距*/
        .layui-table, .layui-table-view {
            margin: 0;
        }
        /*table表单主体*/
        .layui-table-box{
            background-color: white;
            top: 12px;
            padding-left: 20px;
            padding-right: 20px;
        }
        /* 处理勾选框上移*/
        .layui-table-cell .layui-form-checkbox[lay-skin=primary] {
            top: 0;
            bottom: 0;
        }
        .layui-table-view .layui-form-checkbox[lay-skin=primary] i {
            width: 15px;
            height: 15px;
            border-color:#d2d2d2;
        }
        /*勾选框中被选中*/
        .layui-form-checked[lay-skin=primary] i {
            border-color: #1666f9!important;
            background-color: #1666f9;
            color: #fff;
            /*background: url('../../res/layui/images/dev_icon/checked.png');*/
        }
        /*勾选框中未被选中*/
        .layui-form-checkbox[lay-skin=primary] i {
            /*border-color: #1666f9!important;
            background-color: #1666f9;*/
            color: #fff;
            width: 12px;
            height: 12px;
            /*background: url('../../res/layui/images/dev_icon/checkbox.png');*/
        }
        /*条件查询-下拉框*/
        .layui-form-select{
            width: 120px;
        }
        .layui-select-title input{
            height: 32px;
            width: 120px;
        }
        /*下拉框中被选中的颜色*/
        .layui-form-select dl dd.layui-this {
            background-color: #1666f9;
        }
        /*去除下拉框中layui的自带箭头*/
        .layui-form-select .layui-edge {
            display: none;
        }
        /*下拉框箭头图片*/
        .layui-select-title input {
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 100px center transparent;
        }
        /*点击后的下拉框箭头图片*/
        .layui-form-selected  .layui-select-title input{
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 100px center transparent;
        }
        /*去除条件查询内边距*/
        .layui-table-tool-temp {
            padding:0;
        }
        /*条件查询框*/
        .layui-table-tool{
            background-color: white;
            height: 55px;
            border-width:0;
            padding-left: 20px;
            padding-right: 20px;
        }
        /* table 表头背景色*/
        .layui-table thead tr , .layui-table-header{
            background-color: white;
            border-width:0;
            color: #999999;
        }
        /*table 表头字体大小*/
        .layui-table thead tr th{
            font-size: 16px;
        }
        .layui-table td,.layui-table th{
            border-width: 0px;
        }
        /*table 每行数据顶部线*/
        .layui-table tr{
            /*border-width: 1px;*/
            border-style: solid;
            border-color: #e6e6e6;
            border-top-width: 1px;
            border-right-width: 0px;
            border-bottom-width: 0px;
            border-left-width: 0px;
            height: 40px;
        }
        /*按钮样式*/
        .layui-btn {
            font-family: "Microsoft Ya Hei";
            font-size: 14px;
            color: #feffff;
            width: 80px;
            line-height: 32px;
            background-color: #1666f9;
            height: 32px;
            border-radius: 5px;
            border: none;
        }
        /*table表单序号靠左显示*/
        .laytable-cell-numbers{
            text-align: left;
            height: 16px;
            line-height: 16px;
            padding: 0 15px;
        }
        /*table表头字体div高度*/
        .layui-table-cell {
            height: 16px;
            line-height: 16px;
        }
        /*分页栏页数背景色*/
        .layui-laypage .layui-laypage-curr .layui-laypage-em {
            background-color: #1666f9;
        }
        /*分页栏背景色*/
        .layui-table-page {
            background-color: white;
            border-width:0;
            text-align: center;
        }
        /*去除分页*/
        .layui-laypage .layui-laypage-limits, .layui-laypage .layui-laypage-refresh {
            display: none;
        }
    </style>
</head>
<body class="layui-layout-body">
    <div class="layui-layout layui-layout-admin">
        <jsp:include page="../header/topHead.jsp"></jsp:include>
        <div class="layui-body" style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;background-color: #e8ebee">
            <div style="margin: 200px 700px">
                <label style="font-size: 24px">报警阈值(分贝):</label>
                <label id="alarmValue" style="font-size: 24px"></label><br>
                <label style="font-size: 24px">环境噪音(分贝):</label>
                <label id="realData" style="color: red;font-size: 24px"></label>
            </div>
        </div>
    </div>
</body>

<script>
    layui.use(['element','table'], function() {
        var element = layui.element,
            table = layui.table,
            $ = layui.jquery

        $(function () {
            WebSocketTest('noiseRealData');
        });

        //webscoket
        function WebSocketTest(wsPath)
        {
            if ("WebSocket" in window)
            {
                //alert("您的浏览器支持 WebSocket!");
                var hostName = window.location.hostname;
                var port = window.location.port;
                // 打开一个 web socket
                var ws = new WebSocket("ws://" + hostName + ":" + port + "/" + wsPath);
                console.log("ws://"+hostName+":"+port+"/"+wsPath);
                ws.onopen = function(){
                    // Web Socket 已连接上，使用 send() 方法发送数据
                    console.log('ws open');
                };

                ws.onmessage = function (evt) {
                    var received_msg = evt.data;
                    console.log(received_msg);
                    var data = JSON.parse(received_msg);

                    $("#alarmValue").text(data.noiseThr);
                    $("#realData").text(data.noiseData);

                    /*$.ajax({
                            url: "getWgAccessRealTime",
                            type: "POST",
                            // data: {"page": 1,"limit":10, startDate:dateTime, chooseList:JSON.stringify(chooseList),
                            data: {startDate:dateTime, chooseList:JSON.stringify(chooseList),
                            },
                            dataType: "json",
                            success: function (res) {
                                // console.log("res.data:::"+res.data)
                                console.log(res.data)
                                $.each(res.data,function (index,item) {
                                    console.log(index+item);
                                })
                                tablezx = table.render({
                                    id : 'demo',
                                    elem: '#demo'
                                    , height: 'full-470'
                                    , cellMinWidth: 120
                                    , data: res.data //数据接口
                                    , page: true //开启分页
                                    , cols: [[ //表头
                                        {type: 'numbers', title: '序号',width: 65}
                                        , {field: 'id', title: 'ID',style:'display:none',width:1}
                                        , {field: 'schoolName', title: '校区', width: 95}
                                        , {field: 'houseName', title: '楼栋', width: 95}
                                        , {field: 'floorName', title: '楼层', width: 95}
                                        , {field: 'roomName', title: '房号', width: 95}
                                        , {field: 'doorDateTime', title: '刷卡时间',width: 170}
                                        , {field: 'ctrlerID', title: '控制器ID',width: 100}
                                        , {field: 'doorID', title: '门ID',width: 80}
                                        , {field: 'cardID', title: '卡号',width: 140}
                                        , {field: 'username', title: '姓名',width: 90}
                                        , {field: 'openDoorWay', title: '开门方式',width: 100,templet:function (d) {
                                                if(d.openDoorWay==1){return "刷卡"}else{return d}
                                            }}
                                        , {field: 'isPass', title: '是否通过',width: 100,templet: function(d){if(d.isPass==1){return "通过"}else{return "不通过"}}}
                                        , {field: 'direction', title: '方向',width: 80,templet: function(d){if(d.direction==1){return "进"}else{return "出"}}}
                                        // , {fixed: 'right',   title: '操作', toolbar: '#barDemo', width: 150}
                                    ]]
                                    ,limit:10
                                    ,done: function(res, curr, limit ,count){
                                        _cur_page =curr;
                                        _cur_limit = limit;
                                        $('[data-field="id"]').addClass('layui-hide');
                                    }

                                });

                                //导出按钮
                                $("#export").click(function(){
                                    table.exportFile(tablezx.config.id,exportData, 'xls');
                                })

                            }
                        });*/
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
    })
</script>
</html>
