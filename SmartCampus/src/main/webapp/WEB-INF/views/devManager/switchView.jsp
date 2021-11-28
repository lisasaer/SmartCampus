<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 2020-07-07
  Time: 13:08
  To change this template use File | Settings | File Templates.
--%>
<%
    boolean bComOpen = Boolean.valueOf(request.getSession().getAttribute("comOpen").toString());
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>控制开关</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        .div-title{
            display: inline-block;
            vertical-align: top;
        }
        .div-btn-close{
            float: right;
            vertical-align: top;
            display: inline-block;
            text-align: right
        }
        .div-query-btn{
            margin: 10px;
        }
        .layui-table-tool-self{
            display: none;
        }
        .div-modify{
            position: absolute;
            top: 50%;
            left: 50%;
            width: 100%;
            height: 100%;
            transform: translate(-50%,-50%);
            padding: 30px;
            z-index: 9999;
            background-color: rgba(0,0,0,0.2);
        }
        .div-modify-view{
            border-radius: 10px;
            padding: 30px;
            opacity: 1;
            background-color: rgb(255,255,255);
            z-index: 99999;
            width: 50%;
            height:50%;
            position: relative;
            left: 50%;
            top: 50%;
            transform: translate(-50%,-50%);
        }
        .layui-form-label{
            width: 100px;
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
<body class="layui-layout-body"style="padding: 10px;">

<div class="div-title" style="margin-top: 5px;">
    <h1 style="font-family: 'Microsoft Ya Hei'; font-size: 18px; color: #2c394a;margin-left: 5px">控制开关</h1>
</div>
<div class="div-btn-close">
    <button style="margin-top: 5px;border-width: 0;background-color: white;margin-right: 5px;" onclick="closeFrame()">
        <img src="../../res/layui/images/dev_icon/close_icon.png">
    </button>
</div>

<table id="test" lay-filter="test"></table>
<div  class="div-modify layui-hide">
    <div class="div-modify-view"style="width: 500px;height: 250px" >
        <h1 style="font-family: 'Microsoft Ya Hei'; font-size: 18px; color: #2c394a;margin-left: 5px">线路名称修改</h1>
        <div style="margin-left: 65px;margin-top: 40px;" >
            <div class="layui-form-item">
                <label class="layui-form-label">线路原名称</label>
                <div class="layui-input-inline">
                    <input disabled  class="layui-input" id="oldName">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">线路新名称</label>
                <div class="layui-input-inline">
                    <input id="newName" placeholder="请输入新线路名" class="layui-input">
                </div>
            </div>
        </div>

        <div style="text-align: center;margin-top: 20px">
            <button class="layui-btn" id="btnSure">确认</button>
            <button class="layui-btn" id="btnCancel">取消</button>
        </div>
        <div class="layui-hide">
            <input  id="inputId">
            <input id="inputDevId">
            <input id="switchAddress">
        </div>


        <script>
            $('#btnCancel').click(function () {
                $('.div-modify').addClass('layui-hide');
            });
            $('#btnSure').click(function () {
                var newName = $('#newName').val();
                if(newName.length < 1){
                    MyUtil.msg('请输入新线路名称');
                    return;
                }
                var temp = {
                    id:$('#inputId').val()
                    ,switchName:newName
                    ,devId:$('#inputDevId').val()
                    ,switchAddress:$('#switchAddress').val()
                };

                $.post('modifySwitch',temp,function (res) {
                    console.log("res: "+res);
                    table.reload('test',{
                        data:res.data
                    });
                    layer.msg(res.msg);
                    $('.div-modify').addClass('layui-hide');
                });
            })
        </script>
    </div>
</div>
</body>

<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container" id ="button" style="height: 50px">
        <button class="layui-btn layui-btn-sm" lay-event="openSwitch">送电</button>
        <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="closeSwitch">断电</button>
        <button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="editSwitch">编辑</button>
        <button class="layui-btn layui-btn-sm layui-btn-normal" id="btnUpdateDev" lay-event="reLoad" style="border: 0px;padding-left: 10px;background-color: #ffff0000"><img src="../../res/layui/images/dev_icon/refresh_icon.png"></button>
    </div>
</script>
<script>

    /*$(function(){
        WebSocketTest('switchData');
    });
    function WebSocketTest(wsPath) {
        if("WebSocket" in window){
            var hostName=window.location.hostname;
            var port =window.location.port;

            //打开一个web socket
            var ws=new WebSocket("ws://"+hostName+":"+port+"/"+wsPath);

            ws.onopen=function () {
                console.log('ws 已连接');
            };

            ws.onmessage=function (newData) {
                var getData=newData.data;
                console.log(getData);

                var data=JSON.parse(getData);
                if(!MyUtil.isEmptyObj(data)){
                    reloadTB();
                }
            };

            ws.onclose=function () {
                console.log("连接已关闭！")
            }
        }else{
            console.log("浏览器不支持 WebSocket！")
        }
    }*/

    var table;
    var list;
    $(function () {
        list = '${switchInfo}' ;
        console.log("list"+list);
    });

    layui.use(['element'], function() {});

    function closeFrame(){
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        parent.layer.close(index);
    }
    var bOpen = false;
    var click=true;

    layui.use('table', function() {
        table = layui.table;
        //表格渲染
        table.render({
            elem: '#test'
            ,id:'test'
            ,url:'getSwitchData'
            , title: '空开线路数据表'
            , height: '550'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            , cols: [[
                {type: 'checkbox'}
                , {field: 'id', title: 'ID',style:'display:none',width:80}
                , {field: 'devId', title: '空开地址',width:100}
                , {field: 'switchAddress', title: '线路地址',width:100}
                , {field: 'switchName', title: '线路名称',width:100}
                , {field: 'switchStatus', title: '状态1',width:80}
                , {field: 'recordTime', title: '分闸/合闸时间',width:170}
                , {field: 'lineVoltage', title: '线路电压(V)',width:120}
                , {field: 'lineCurrent', title: '线路电流(A)',width:120}
                , {field: 'linePower', title: '线路功率(W)',width:120}
                , {field: 'leakageCurrent', title: '漏电电流(mA)',width:130}
                , {field: 'moduleTemperature', title: '模块温度(度)',width:125}
            ]]
            <%--,data:${switchInfo}--%>
            ,done: function(res, curr, count){
                $('[data-field="id"]').addClass('layui-hide');
                res.data.forEach(function (item,index) {
                    console.log("0"+item.switchStatus)
                    //如果是通电，修改这行文字颜色
                    if (item.switchStatus == "通电") {
                        $(".layui-table-body tbody tr[data-index='"+index+"'] td[data-field=\"switchStatus\"]").css({'color': "#1666f9"});

                    }
                    if (item.switchStatus == "断电") {
                        $(".layui-table-body tbody tr[data-index='"+index+"'] td[data-field=\"switchStatus\"]").css({'color': "#b74531"});

                    }
                });
                // delete this.where;
            }
            ,page:true
            // ,limits:[10,15]
            ,limit:10
        });



        table.on('toolbar(test)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            var data = checkStatus.data;


            //console.log(data.length);
            //console.log(data);
            var addressList = '';
            for(var i = 0;i<data.length;i++){
                addressList += data[i].switchAddress+",";
            }
            addressList = addressList.substring(0,addressList.length-1);
            console.log("addressList: "+addressList);

            var ctrlData = {};
            if(data.length >0){
                ctrlData.devId = data[0].devId;
            }

            ctrlData.address = addressList;
            ctrlData.dd = 100;
            switch(obj.event){
                case 'openSwitch':
                    var address=[];
                    var data = checkStatus.data;
                    var loading = MyLayUIUtil.loading();
                    if(data.length < 1){
                        MyUtil.msg('请选择线路');
                        layer.close(loading);
                        return;
                    }
                    if(data.length!=0){
                        for(var i=0;i<data.length;i++){
                            address.push(data[i].switchAddress);
                            console.log("data:"+data);
                        }
                    }
                    console.log("ctrlData"+ctrlData);
                    //layer.alert(JSON.stringify(data));
                    console.log("address"+address);
                    $.post('switchCtrlOpen',{'getAddress':JSON.stringify(address)},function (res)
                    {
                        loading;
                        //layer.msg(res.msg);
                    }).fail(function (res) {
                        layer.msg("送电失败")
                    }).always(function (res) {
                        window.location.reload();
                        //layer.close(loading);
                        var v;
                        var f = function(v){
                            return function(){
                                if(v == 5){//延迟10秒 
                                    //这里填加时间到后执行的主体函数;
                                    var ctrlDevId = {};
                                    ctrlDevId.devId = listStr.substring(listStr.indexOf("\"devId\":\""),listStr.indexOf("\",")).substring(9);
                                    $.post('reloadSwitch', ctrlDevId, function (res) {
                                        console.log("v: " + v);
                                        window.location.reload();
                                    }).always(function () {
                                        layer.close(loading);
                                    });
                                }else{
                                    console.log("v: " + v);
                                }
                            };
                        };
                        for(var i = 1; i < 6; i++){
                            setTimeout(f(i), i*1000);
                            console.log("v: " + v);
                            //该函数是核心,同时利用循环执行,1秒一次,直到i=10 
                        }
                    })



                    break;
                case 'closeSwitch':
                    var loading = MyLayUIUtil.loading();
                    var address=[];
                    var data = checkStatus.data;
                    if(data.length < 1){
                        MyUtil.msg('请选择线路');
                        layer.close(loading);
                        return;
                    }
                    if(data.length!=0){
                        for(var i=0;i<data.length;i++){
                            address.push(data[i].switchAddress);
                            console.log("data:"+data);
                        }
                    }
                    console.log("ctrlData"+ctrlData);
                    //layer.alert(JSON.stringify(data));
                    console.log("address"+address);
                    $.post('switchCtrlClose',{'getAddress':JSON.stringify(address)},function (res)
                    {
                        loading;
                        //layer.msg(res.msg);
                    }).fail(function () {
                        layer.msg("断电失败")
                    }).always(function(){
                        window.location.reload();
                    });

                    break;
                case 'editSwitch':
                    if(data.length < 1){
                        MyUtil.msg('请选择线路');
                        return;
                    }
                    if(data.length > 1){
                        MyUtil.msg('请选择单个设备');
                        return;
                    }

                    $('#oldName').val(data[0].switchName);
                    $('#inputId').val(data[0].id);
                    $('#inputDevId').val(data[0].devId);
                    $('#switchAddress').val(data[0].switchAddress);
                    $('#newName').val('');
                    $('.div-modify').removeClass('layui-hide');

                    break;
                case 'reLoad':
                    var loading = MyLayUIUtil.loading();
                    var listStr = list.toString();
                    //var a =listStr.substring(listStr.indexOf("devId"),listStr.indexOf(","));

                    console.log(list.length);
                    console.log("biu~~~"+listStr.substring(listStr.indexOf("\"devId\":\""),listStr.indexOf("\",")).substring(9));

                    var ctrlDevId = {};
                    ctrlDevId.devId = listStr.substring(listStr.indexOf("\"devId\":\""),listStr.indexOf("\",")).substring(9);
                    console.log("ctrlDevId" + ctrlDevId);
                    $.post('reloadSwitch', ctrlDevId, function (res) {
                        console.log("res: " + res);
                        //reloadTB();
                        window.location.reload();
                    }).always(function () {
                        layer.close(loading);
                    });
                    break;
            }
        })

    })
    //重载表格数据
    function reloadTB(){
        table.reload('test');
    }
    $(function () {//页面完全加载完后执行

        /*防止重复提交  10秒后恢复*/
        var isSubmitClick = true;
        $('.layui-btn-sm').click(function () {
            if (isSubmitClick) {
                isSubmitClick = false;
                $('.layui-btn-sm').css("background-color", "red");
                // $("form:first").submit();//提交第一个表单
                $("form[name='form_month']").submit();
                setTimeout(function () {
                    $('.layui-btn-sm').css("background-color", "#3CBAFF");
                    isSubmitClick = true;
                }, 10000);
            }
        });
    })

    $('#local').append("${devInfo.school}"+"--"+"${devInfo.house}"+"--"+"${devInfo.floor}"+"--"+"${devInfo.room}");
</script>
</html>
