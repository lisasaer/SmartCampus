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
    </style>
</head>
<body class="layui-layout-body">

<div class="layui-layout layui-layout-admin">
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <jsp:include page="../header/topHead.jsp"></jsp:include>
    <div class="layui-body"style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;">
            <div class="layui-row" style="background: #eee;/*width: 1600px;padding-top: 0px;margin-left: 25px*/">
                <button class="layui-icon layui-btn layui-btn-normal" id="window-comeback">&#xe65c;</button>
                <div id="local" style="padding-left: 5px">设备所在位置:</div>
                <table id="test" lay-filter="test"style="padding-left: 10px"></table>
            </div>
    </div>
<%--    <jsp:include page="../header/footer.jsp"></jsp:include>--%>
</div>
<div  class="div-modify layui-hide">
    <div class="div-modify-view"style="width: 500px;height: 250px" >

        <div style="margin-left: 65px;margin-top: 40px;" >
            <div class="layui-form-item">
                <label class="layui-form-label">原线路名</label>
                <div class="layui-input-inline">
                    <input disabled  class="layui-input" id="oldName">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">新线路名</label>
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
            //返回上一级
            var windowComeback = document.getElementById('window-comeback');
            windowComeback.addEventListener('click', function () {
                window.history.back(-1);
            });


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
    <div class="layui-btn-container" id ="button" style="height: 40px">
            <button class="layui-btn layui-btn-sm" lay-event="openSwitch">送电</button>
            <button class="layui-btn layui-btn-sm layui-btn-danger" lay-event="closeSwitch">断电</button>
            <button class="layui-btn layui-btn-sm layui-btn-normal" lay-event="editSwitch">编辑</button>
            <button class="layui-btn layui-btn-sm layui-btn-warm" lay-event="reLoad">刷新</button>
    </div>
</script>
<script>

    // $(function(){
    //     WebSocketTest('switchData');
    // });
    /*function WebSocketTest(wsPath) {
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
                    //reloadTB();
                    /!*table.reload('test',{
                        moduleTemperature:data.moduleTemperature
                    });*!/
                    /!*$.ajax({
                        url: "/getSwitchData",
                        type: "POST",
                        // data: {"iconCls": node.iconCls,"id":node.id},
                        dataType: "json",
                        success: function (res) {
                            $.each(res.data,function (index,item) {
                                console.log(index+"---"+item);
                            })
                            res.data.forEach(function (item,index) {
                                //如果是通电，修改这行单元格背景和文字颜色
                                // if(item.switchStatus == "通电"){
                                //     $(".layui-table-body tbody tr[data-index='"+index+"']").css({'background-color': "#009688"});
                                //     $(".layui-table-body tbody tr[data-index='"+index+"']").css({'color': "#fff" });
                                // }
                                $(".layui-table-body tbody tr[data-index='lineVoltage'] div").css({'background-color': "#ff181c"},{'color':"#3cbfff"});
                                $(".layui-table-body tbody tr[data-index='lineCurrent']").css({'background-color': "#ff181c"},{'color':"#3cbfff"});
                                $(".layui-table-body tbody tr[data-index='lineVoltage'] div").html(item.lineVoltage);
                                console.log("电压lineVoltage"+item.lineVoltage)
                                $(".layui-table-body tbody tr[data-index='lineCurrent'] div").html(item.lineCurrent);
                                console.log("电流lineCurrent"+item.lineCurrent)
                                $(".layui-table-body tbody tr[data-index='linePower'] div").html(item.linePower);
                                console.log("功率linePower"+item.linePower)
                                $(".layui-table-body tbody tr[data-index='leakageCurrent'] div").html(item.leakageCurrent);
                                console.log("漏电电流leakageCurrent"+item.leakageCurrent)
                                $(".layui-table-body tbody tr[data-index='moduleTemperature'] div").html(item.moduleTemperature);
                                console.log("温度moduleTemperature"+item.moduleTemperature)
                            });

                        }
                    });*!/
                }
            };
            <%--ws.onmessage=function (newData) {--%>
            <%--    var getData=newData.data;--%>
            <%--    var data=JSON.parse(getData);--%>
            <%--    var devId="<%=session.getAttribute("devId")%>";--%>
            <%--    var dataList=[];--%>

            <%--    for(var item in data.switchInfo){--%>

            <%--        if(parseInt(data.switchInfo[item].devId, 10) == devId){--%>
            <%--            dataList.push(data.switchInfo[item]);--%>
            <%--            data.switchInfo[item].devId=devId;--%>
            <%--        }--%>
            <%--    }--%>
            <%--    console.log("datalist "+dataList);--%>
            <%--    /!*table.reload('test', {--%>
            <%--        elem: '#test'--%>
            <%--        , data: dataList--%>
            <%--    });*!/--%>
            <%--    dataList=[];--%>
            <%--    if(!data){--%>
            <%--        reloadTB();--%>
            <%--    }--%>
            <%--};--%>


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
            , height: 'full-190'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            , cols: [[
                {type: 'checkbox', fixed: 'left'}
                , {field: 'id', title: 'ID',style:'display:none',width:80,align : 'center'}
                , {field: 'devId', title: '空开地址ID',width:100,align : 'center'}
                , {field: 'switchAddress', title: '线路地址',width:100,align : 'center'}
                , {field: 'switchName', title: '线路名称',width:100,align : 'center'}
                , {field: 'switchStatus', title: '状态',width:80,align : 'center'}
                , {field: 'recordTime', title: '分闸/合闸时间',width:180,align : 'center'}
                , {field: 'lineVoltage', title: '线路电压(V)',width:130,align : 'center'}
                , {field: 'lineCurrent', title: '线路电流(A)',width:130,align : 'center'}
                , {field: 'linePower', title: '线路功率(W)',width:130,align : 'center'}
                , {field: 'leakageCurrent', title: '漏电电流(mA)',width:130,align : 'center'}
                , {field: 'moduleTemperature', title: '模块温度(度)',width:130,align : 'center'}
            ]]
            <%--,data:${switchInfo}--%>
            ,done: function(res, curr, count){
                $('[data-field="id"]').addClass('layui-hide');
                $('.layui-form-checkbox').css('margin-top','5px')
                res.data.forEach(function (item,index) {
                    //如果是通电，修改这行单元格背景和文字颜色
                    if(item.switchStatus == "通电"){
                        $(".layui-table-body tbody tr[data-index='"+index+"']").css({'background-color': "#009688"});
                        $(".layui-table-body tbody tr[data-index='"+index+"']").css({'color': "#fff" });
                    }
                });
            }
            ,page:true
            ,limits:[10,15]
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
                        layer.close(loading);
                        var v;
                        var f = function(v){
                            return function(){
                                if(v == 5){//延迟10秒 
                                    //这里填加时间到后执行的主体函数;
                                    var ctrlDevId = {};
                                    ctrlDevId.devId = listStr.substring(listStr.indexOf("\"devId\":\""),listStr.indexOf("\",")).substring(9);
                                    $.post('reloadSwitch', ctrlDevId, function (res) {
                                        console.log("v: " + v);
                                        setTimeout('window.location.reload()', 10);
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
    /*$(function(){
        test();
        setInterval(test, 10000);                //循环执行，定时10秒
        function test(){
            $.ajax({
                type: 'GET',
                //data: {carno:'1009'},             //请求参数
                dataType: 'model',
                success: function(data){
                    reloadTB()
                    console.log("10s更新一次！")
                }
            });
        }
    });*/
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
