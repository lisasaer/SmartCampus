<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2019/11/22
  Time: 19:56
  To change this template use File | Settings | File Templates.
--%>
<%
    boolean bComOpen = Boolean.valueOf(request.getSession().getAttribute("comOpen").toString());
%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<html>
<head>
    <title>实时监控</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        /*去除table表单外边距*/
        .layui-table, .layui-table-view {
            margin-bottom: 0;
        }
        /* 处理勾选框上移*/
        .layui-table-cell .layui-form-checkbox[lay-skin=primary] {
            top: 4px;
            padding: 0;
        }
        /*table表单主体*/
        .layui-table-box{
            background-color: white;
            top: 12px;
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
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <jsp:include page="../header/topHead.jsp"></jsp:include>

    <div class="layui-body" style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;">
        <!-- 内容主体区域 -->
        <div class="my-tree-div">
            <ul id="tt"></ul>
        </div>

        <div class="my-tree-body-div" style="bottom: 15px;margin-left: 25px;margin-top: 4px;padding:15px;">
                <button id="chooseAll" class="layui-btn" style="margin-bottom: 10px;" onclick="chooseAll()">全选</button>
                <button id="removeChoose" class="layui-btn" style="margin-bottom: 10px;" onclick="removeChoose()">取消选择</button>
                <button id="btnStartRealTime" class="layui-btn" style="margin-bottom: 10px;" onclick="startRealTime()">实时监控</button>
                <button id="btnStopRealTime" class="layui-btn" style="margin-bottom: 10px;" onclick="stopRealTime()">停止</button>
                <div id="wgDoorDiv" style="border: 1px solid #00438a;height: 220px ;overflow-y:scroll" >
                    <c:forEach items="${WGDoorDevList}" var="item">
                        <div class="layui-col-md1">
                            <div class="layui-row" style="width: 150px; padding-left: 70px;padding-right: 20px;padding-top: 20px;padding-bottom: 10px">
                                <img id="${item.doorID}" src="res/image/closedoor.png" title="1901一号门" style="cursor: pointer;background-color:#FFFFFF " >
                            </div>
                            <div class="layui-row" style="width: 160px;padding-left: 45px">
                                <label style="font-size: small">${item.ctrlerSN}-${item.doorName}</label>
                            </div>
                        </div>
                        <%--<div  style="width: 150px; padding-left: 60px;padding-right: 20px;padding-top: 20px;padding-bottom: 10px" >
                            <img id="${item.doorID}" src="res/image/closedoor.png" title="1901一号门" style="cursor: pointer;background-color:#009688 " >
                            <label style="font-size: small">${item.ctrlerSN}-${item.doorName}</label>
                        </div>--%>
                    </c:forEach>
                </div>
            <table id="demo" lay-filter="test"></table>
        </div>
    </div>

</div>
</body>

<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs " lay-event="del">删除</a>
</script>

<script>
    //区域按钮筛选门设备
    $('#tt').tree({
        onClick: function(node){
            doorTreeIconCls=node.iconCls;
            doorTreeId=node.id;
            $.post('wgAccessDevInRealTime', {iconCls:node.iconCls,id:node.id}, function(res) {
                var items=eval(res);
                var str="";
                console.log(res)
                $.each(items,function (index,item) {
                    str+='<div class="layui-col-md1">';
                    str+='<div class="layui-row" style="width: 150px; padding-left: 70px;padding-right: 20px;padding-top: 20px;padding-bottom: 10px">';
                    str+='<img id="'+item.doorID+'" src="res/image/closedoor.png" style="cursor: pointer;background-color:#FFFFFF" >';
                    str+='</div>';
                    str+='<div class="layui-row" style="width: 160px;padding-left: 45px">';
                    str+='<label style="font-size: small">'+item.ctrlerSN+'-'+item.doorName+'</label>';
                    str+='</div>';
                    str+='</div>';
                    /*str+='<td  style="width: 150px; padding-left: 60px;padding-right: 20px;padding-top: 20px;padding-bottom: 10px">';
                    str+='<img id='+item.doorID+' src="res/image/closedoor.png" style="cursor: pointer;background-color:#009688">';
                    str+='<label style="font-size: small">'+item.ctrlerSN+'-'+item.doorName+'</label>';
                    str+='</td>';*/
                })
                $('#wgDoorDiv').html(str);
                doorClick();
            })
            // window.location.reload();
        }
    });

    var table;
    var dateTime; //实时监控获取当前时间
    var realTime = false;//是否开始实时监控
    var chooseList=[];//存储选中的门ID

    window.onload = doorClick();
        function doorClick() {

        var arr = document.getElementsByTagName('img');
            $.each(arr,function (index,item) {
                console.log("arr"+index+","+item)
                $.each(arr[index],function (index1,item1) {
                    console.log("arr1--------"+index1+","+item1)
                })
            })

        for (var i = 0; i < arr.length; i++) {
            arr[i].onclick = function () {
                document.getElementById(this.id).style.backgroundColor = "#009688";
                if(chooseList.indexOf(this.id) == -1) {
                    chooseList.push(this.id);
                }else {
                    document.getElementById(this.id).style.backgroundColor = "#FFFFFF";
                    chooseList.splice(chooseList.indexOf(this.id),1);
                }
                console.log(chooseList);
            }
        }

    }
    //全选
    function chooseAll() {
        <c:forEach items="${WGDoorDevList}" var="item">
        <%--$.each(document.getElementById("${item.doorID}"),function (index,item) {--%>
        <%--    console.log("第一层"+index+","+item )--%>
        <%--    if(index=='style'){--%>
        <%--        $.each(item,function (index2,item2) {--%>
        <%--            console.log("---------------------"+index2+","+item2 )--%>
        <%--            if(item2=="background-color"){--%>
        <%--                console.log(item[1].value())--%>
        <%--            }--%>

        <%--        })--%>
        <%--    }--%>

        <%--})--%>

        document.getElementById("${item.doorID}").style.backgroundColor = "#009688";
        if(chooseList.indexOf("${item.doorID}") == -1){
            chooseList.push("${item.doorID}");
        }
        </c:forEach>
        console.log(chooseList);
    }

    //取消全选
    function removeChoose() {
        <c:forEach items="${WGDoorDevList}" var="item">
        document.getElementById("${item.doorID}").style.backgroundColor = "#FFFFFF";
        chooseList = [];
        </c:forEach>
        console.log(chooseList);
    }

    //开始实时监控
    function startRealTime() {
        if(chooseList.length > 0){
            realTime= true;
            document.getElementById("btnStartRealTime").style.backgroundColor = "red";//控件颜色变下
            var date = new Date();
            var y = date.getFullYear();
            var m = date.getMonth() + 1;
            m = m < 10 ? ('0' + m) : m;
            var d = date.getDate();
            d = d < 10 ? ('0' + d) : d;
            var h = date.getHours();
            h = h < 10 ? ('0' + h) : h;
            var minute = date.getMinutes();
            var second = date.getSeconds();
            minute = minute < 10 ? ('0' + minute) : minute;
            second = second < 10 ? ('0' + second) : second;
            dateTime = y + '-' + m + '-' + d+' '+h+':'+minute+':'+second;
            //alert(dateTime);
            console.log("+++++++:"+chooseList);
        }else {
            alert("请选择要监控的门！")
        }

    }

    //结束实时监控
    function stopRealTime(){
        realTime = false;
        document.getElementById("btnStartRealTime").style.backgroundColor = "#1666f9";
    }

    var ws = null;

    //重载表格数据
    function reloadTB(){
        table.reload('demo');
    }

    layui.use(['element','table'], function() {
        var element = layui.element;
        table = layui.table;
        //第一个实例
        table.render({
            id : 'demo',
            elem: '#demo'
            , height: 'full-470'
            , cellMinWidth: 120
            , url: 'getWgAccessRealTime' //数据接口
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
    });

    $('#tt').tree({
        url:'getTreeData?iconCls=1'
    });

    layui.use('laydate', function(){
        var laydate = layui.laydate;
        var layendDate = layui.laydate;

        //执行一个laydate实例
        laydate.render({
            elem: '#startDate' //指定元素
        });

        //执行一个laydate实例
        layendDate.render({
            elem: '#endDate' //指定元素
        });
    });

</script>

<script>
    layui.use(['element','table'], function() {
        var element = layui.element,
            table = layui.table,
            $ = layui.jquery

        $(function () {
            WebSocketTest('WgAccessOpenDoor');
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
                ws.onopen = function(){
                    // Web Socket 已连接上，使用 send() 方法发送数据
                    console.log('ws open');
                };

                ws.onmessage = function (evt)
                {
                    if(realTime) { //开始时间监控
                        $.ajax({
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
                        });
                    }
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