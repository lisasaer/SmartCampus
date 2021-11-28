<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <!-- layui -->
    <link rel="stylesheet" type="text/css" href="/res/layui/css/layui.css">
    <script type="text/javascript" src="/res/layui/layui.js"></script>
    <script src="res/js/jquery.min.js"></script>
    <script src="res/js/myjs.js" ></script>

    <title>网关管理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <%--<jsp:include page="header/res.jsp"></jsp:include>--%>
    <title>Title</title>
<%--    <jsp:include page="../header/res.jsp"></jsp:include>--%>
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
            width: 50%;
            height: 50%;
            transform: translate(-50%,-50%);
            padding: 30px;
            z-index: 9999;
            background-color: rgba(0,0,0,0.1);
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
<ul class="layui-nav">
    <li class="layui-nav-item"><a href="/LoraDevManager">Lora网关管理</a></li>
    <li class="layui-nav-item"><a href="/SwitchDevManager">空开设备管理</a></li>
</ul>
<div class="layui-layout layui-layout-admin">
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <%--<jsp:include page="header/topHead.jsp"></jsp:include>--%>

    <div class="layui-body" style="padding: 15px;width: 70%;">
        <!-- 内容主体区域 -->
        <%--<div class="my-tree-div">
            <ul id="tt"></ul>
        </div>--%>

        <div class="my-tree-body-div">
            <button id="btnSearchDev" class="layui-btn">搜索设备</button>
            <button id="btnUpdateDev" class="layui-btn">刷新</button>

            <table id="demo" lay-filter="test"></table>
        </div>
    </div>
    <%--<jsp:include page="header/footer.jsp"></jsp:include>--%>
</div>
<div  class="div-modify layui-hide">
    <div class="div-modify-view" >

        <div style="margin-left: 65px;margin-top: 40px;">
            <div class="layui-form-item">
                <label class="layui-form-label">lora序列号</label>
                <div class="layui-input-inline">
                    <input disabled  class="layui-input" id="devSN">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">原空开组数量</label>
                <div class="layui-input-inline">
                    <input disabled  class="layui-input" id="oldNum">
                </div>
            </div>


            <div class="layui-form-item">
                <label class="layui-form-label">新空开组数量</label>
                <div class="layui-input-inline">
                    <input id="newNum" placeholder="请输入新的空开组数量" class="layui-input">
                </div>
            </div>
        </div>

        <div style="text-align: center;margin-top: 20px">
            <button class="layui-btn" id="btnSure">确认</button>
            <button class="layui-btn" id="btnCancel">取消</button>
        </div>
        <div class="layui-hide">
            <input  id="inputId">
            <input id="inputDevSN">
        </div>


        <script>
            $('#btnCancel').click(function () {
                $('.div-modify').addClass('layui-hide');
            });
            $('#btnSure').click(function () {
                var newNum = $('#newNum').val();
                if(newNum.length < 1){
                    MyUtil.msg('请输入空开组数量');
                    return;
                }
                var temp = {
                    id:$('#inputId').val()
                    ,switchGroupNum:newNum
                    ,devSN:$('#inputDevSN').val()
                };

                $.post('editSwitchGroupNum',temp,function (res) {
                    console.log("res: "+res);
                    table.reload('demo',{
                        data:res.data
                    });
                    $('.div-modify').addClass('layui-hide');
                });
            })
        </script>
    </div>
</div>

</body>

<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">删除</a>
<%--    <a class="layui-btn layui-btn-xs " lay-event="edit">编辑</a>--%>
    <a id = "restartId" class="layui-btn layui-btn-xs layui-btn-warm" lay-event="restart">重启</a>
    <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="upgrade">升级</a>
</script>

<script>
    var table;
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
            , height: 'full-220'
            //, cellMinWidth: 120
            , url: 'getLoraDev' //数据接口
            , page: true //开启分页
            , cols: [[ //表头
                //{type: 'checkbox', fixed: 'left'}
                {type: 'numbers', title: '序号', fixed: 'left',event:'row'}
                //, {field: 'id', title: 'ID',width:50,align : 'center'}
                , {field: 'devSN', title: '设备序列号SN' , width : 170,align : 'center',event:'row'}
                //, {field: 'ip', title: '设备IP' , width:150,align : 'center',event:'row'}
                , {field: 'onLine', title: '状态检测' , width : 150,align : 'center',event:'row'}
                , {field: 'switchGroupNum', title: '空开组数量',width:130,align : 'center',event:'row'}
                , {field: 'macAddress', title: 'MAC地址' , width:200,align : 'center',event:'row'}
                , {field: 'port', title: '端口号' , width:114,align : 'center',event:'row'}
                //, {field: 'netmask', title: '子网掩码' , width:150,align : 'center',event:'row'}
                //, {field: 'defaultGateway', title: '默认网关' , width:150,align : 'center',event:'row'}
                , {field: 'fwVer', title: '设备固件版本',width:150,align : 'center',event:'row'}
                , {field: 'sub1gNum', title: 'sub1g接口数量',width:150,align : 'center',event:'row'}
                , {fixed: 'right',   title: '操作', toolbar: '#barDemo', width: 200,align : 'center'}
            ]]
            , done: function (res, curr, count) {
                res.data.forEach(function (item,index) {
                    //如果是在线，修改这行单元格背景和文字颜色
                    if(item.onLine == "在线"){
                        $(".layui-table-body tbody tr[data-index='"+index+"']").css({'background-color': "#009688"});
                        $(".layui-table-body tbody tr[data-index='"+index+"']").css({'color': "#fff" });
                    }
                });
            }
            ,limit:15
            ,limits:[15,20,30,50]
            ,where:{
                //devType:'1'
            }
        });

        //监听行工具事件
        table.on('tool(test)', function(obj){
            var data = obj.data;

            if(obj.event === 'del'){
                layer.confirm('确定删除该设备？', function(index){
                    var loading = layer.load(1, {shade: [0.1,'#fff']});
                    var temp = {
                        id:data.id
                        // ,devSN:data.devSN
                    };
                    $.post('delLoraDev',temp,function (res) {
                        obj.del();
                        layer.close(index);
                        layer.msg('删除成功');
                        reloadTB();
                    }).fail(function (xhr) {
                        layer.msg('删除失败 '+xhr.status);
                        console.log(xhr.status);
                    }).always(function () {
                        layer.close(loading);
                    });
                });
            }
            else if(obj.event === 'edit'){
                console.log(data[0]);
                console.log(data);
                var temp = {
                    id:data.id
                    ,devSN:data.devSN
                };
                console.log(temp);
                $('#devSN').val(data.devSN);
                $('#oldNum').val(data.switchGroupNum);
                $('#inputId').val(data.id);
                $('#inputDevSN').val(data.devSN);
                $('#newNum').val('');
                $('.div-modify').removeClass('layui-hide');
            }
            else if(obj.event === 'row'){
                console.log("data.devSN:"+data.devSN);
                layer.open({
                    type: 2,
                    title: false,
                    area: ['1000px', '623px'],
                    shade: 0.8,
                    closeBtn: 0,
                    shadeClose: true,
                    content: 'switchDevtest?loraSN='+data.devSN
                    ,success: function(layero, index) {
                        layer.iframeAuto(index);
                    }
                });
            }
            else if(obj.event === 'restart'){
                layer.confirm('确定重启该设备？', function(index){
                    var loading = layer.load(1, {shade: [0.1,'#fff']});
                    var temp = {
                        id:data.id
                        // ,devSN:data.devSN
                    };
                    $.post('restartLoraDev',temp,function (res) {
                        console.log(res.code);
                        if(res.code == 1){
                            layer.msg("请检查是否连接网关!");
                            reloadTB();
                        }
                        else if(res.code == 2){
                            layer.msg("服务器发送请求数据失败！");
                            reloadTB();
                        }
                        else if(res.code == 3){
                            layer.msg("网关没有返回消息！");
                            reloadTB();
                        }
                        else if(res.code == 4){
                            layer.msg("网关返回内容显示操作失败！");
                            reloadTB();
                        }
                        else if(res.code == 5){


                            layer.msg("重启成功！");
                            reloadTB();
                            click = false;
                            console.log("+++++++++++++++++++++++++++++++++");
                            $(this).css("background-color","#4e5465");
                            setTimeout(function () {
                                console.log("等待时间结束......");
                                click = true;
                                $('#restartId').css("background-color","#009688");
                            },60000);
                        }
                    }).always(function () {
                         layer.close(loading);
                    });

                });
            }
            else if(obj.event === 'upgrade'){
                layer.confirm('确定升级该设备？', function(index){
                    var loading = layer.load(1, {shade: [0.1,'#fff']});
                    var temp = {
                        id:data.id
                        // ,devSN:data.devSN
                    };
                    $.post('upgradeLoraDev',temp,function (res) {
                        console.log(res.code);
                        if(res.code == 1){
                            layer.msg("请检查是否连接网关!");
                            reloadTB();
                        }
                        else if(res.code == 2){
                            layer.msg("服务器发送请求数据失败！");
                            reloadTB();
                        }
                        else if(res.code == 3){
                            layer.msg("网关没有返回消息！");
                            reloadTB();
                        }
                        else if(res.code == 4){
                            layer.msg("网关返回内容显示操作失败！");
                            reloadTB();
                        }
                        else if(res.code == 5){
                            layer.msg("升级成功！");
                            reloadTB();
                        }
                    }).always(function () {
                        layer.close(loading);
                    });
                });
            }
            /*else if(obj.event === 'row'){
                console.log("data : " +data);
                console.log("data.devSN:"+data.devSN);
                layer.open({
                    type: 2,
                    title: false,
                    area: ['1000px', '623px'],
                    shade: 0.8,
                    closeBtn: 0,
                    shadeClose: true,
                    content: 'loraSwitchTest?loraDevSN='+data.devSN
                    ,success: function(layero, index) {
                        layer.iframeAuto(index);
                    }
                });
            }*/
        });
    });



    //搜索设备
    $('#btnSearchDev').click(function () {
        layer.open({
            type: 2,
            title: false,
            area: ['1000px', '623px'],
            shade: 0.8,
            closeBtn: 0,
            shadeClose: true,
            content: 'loraDevSearch'
            ,success: function(layero, index) {
                layer.iframeAuto(index);
            }
        });
    });

    //刷新设备
    $('#btnUpdateDev').click(function () {
        var loading = MyLayUIUtil.loading();
        console.log("主页刷新");
        reloadTB();
        MyLayUIUtil.closeLoading(loading);

    });


</script>

</html>