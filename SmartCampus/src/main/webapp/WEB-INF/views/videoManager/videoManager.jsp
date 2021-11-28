<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2019/11/22
  Time: 19:56
  To change this template use File | Settings | File Templates.
--%>
<%--<% boolean bComOpen = Boolean.valueOf(request.getSession().getAttribute("comOpen").toString());%>--%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>监控设备</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <%--    wpp - 2020-3-10 websdk--%>
<%--    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />--%>
<%--    <meta http-equiv="Pragma" content="no-cache" />--%>
<%--    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate" />--%>
<%--    <meta http-equiv="Expires" content="0" />--%>
    <%--    <script>--%>
    <%--        document.write("<link type='text/css' href='../res/websdk/demo.css?version=" + new Date().getTime() + "' rel='stylesheet' />");--%>
    <%--    </script>--%>
    <%--    wpp--%>
    <jsp:include page="../header/res.jsp"></jsp:include>

    <%--<style>
        /*去掉table顶部栏标签*/
        .layui-table-tool-self {
            display: none;
        }
        /* 处理勾选框上移*/
        .layui-table-cell .layui-form-checkbox[lay-skin=primary] {
            top: 4px;
            padding: 0;
        }
        /*条件查询-下拉框*/
        .layui-form-select{
            width: 140px;
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
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 117px center transparent;
        }
        /*点击后的下拉框箭头图片*/
        .layui-form-selected  .layui-select-title input{
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 117px center transparent;
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
        /* table 表头背景色*/
        .layui-table thead tr , .layui-table-header{
            background-color: white;
            border-width:0;
            color: #999999;
        }
        /*table 表头字体大小*/
        .layui-table thead tr th{
            font-size: 16px;
        }.layui-table td,.layui-table th{
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
        /*分页栏背景色*/
        .layui-table-page {
            background-color: white;
        }
        /*条件查询框*/
        .layui-table-tool{
            background-color: white;
            height: 55px;
            border-width:0;
            padding-left: 20px;
            padding-right: 20px;
        }
        /*去除条件查询内边距*/
        .layui-table-tool-temp {
            padding: 0;
        }
        /*条件查询-下拉框*/
        .layui-form-select{
            width: 100px;
        }
        .layui-select-title input{
            height: 32px;
            width: 100px;
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

    </style>--%>
    <style>
        /*去除table顶部栏标签*/
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
            width: 140px;
        }
        .layui-select-title input{
            height: 32px;
            width: 140px;
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
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 117px center transparent;
        }
        /*点击后的下拉框箭头图片*/
        .layui-form-selected  .layui-select-title input{
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 117px center transparent;
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
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <jsp:include page="../header/topHead.jsp"></jsp:include>

    <div class="layui-body" style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;background-color: #e8ebee">
        <table id="demo" lay-filter="test"></table>
    </div>
</div>
</body>

<script type="text/html" id="toolbarDemo">
    <div class="layui-inline">
        <button id="btnAddDev" class="layui-btn layui-btn-sm" lay-event="add">添加设备</button>
        <button class="layui-btn layui-btn-sm" lay-event="delete">批量删除</button>

        <div class="layui-input-inline" style="padding-left: 10px">
            <label >校区</label>
            <div class="layui-input-inline" >
                <select id="school" name="school" lay-filter="selectSchool" title="校区选择" >
                    <option value="">全部</option>
                    <%--<option value="0">无</option>--%>
                    <c:forEach items="${schoolList}" var="item">
                        <option value="${item.id}">${item.text}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="layui-input-inline"style="padding-left: 10px">
            <label >楼栋</label>
            <div class="layui-input-inline" >
                <select id="house" name="house" lay-filter="selectHouse" title="楼栋选择">
                    <option value="">全部</option>
                </select>
            </div>

        </div>

        <div class="layui-input-inline"style="padding-left: 10px">
            <label >楼层</label>
            <div class="layui-input-inline" >
                <select id="floor" name="floor" lay-filter="selectFloor" title="楼层选择">
                    <option value="">全部</option>
                </select>
            </div>

        </div>

        <div class="layui-input-inline"style="padding-left: 10px">
            <label >房号</label>
            <div class="layui-input-inline" >
                <select id="room" name="room" lay-filter="selectRoom" title="房号选择">
                    <option value="">全部</option>
                </select>
            </div>

        </div>

        <div class="layui-input-inline"style="padding-left: 10px">
            <label >设备状态</label>
            <div class="layui-input-inline" >
                <select id="devStatus" name="devStatus" lay-filter="selectRoom" title="设备状态">
                    <option value="">全部</option>
                    <option value="0">离线</option>
                    <option value="1">在线</option>
                </select>
            </div>

        </div>
        <div class="layui-inline"style="padding-left: 10px">
            <input class="layui-input" name="id" id="dev" placeholder="请输入设备名称/IP"
                   autocomplete="off"  style="width: 190px;height: 32px;">
            <span style=" position: absolute; top: 8%; right: 6%; display: table-cell;/*background-color: #0d8ddb*/;white-space: nowrap">
                <img src="../../res/layui/images/dev_icon/input_query_icon.png" style="padding-right: 0px;margin-bottom: 4px;">
            </span>
        </div>

    </div>
    <div style="float: right;">
        <button id="btnQuery" class="layui-btn layui-btn-sm" onclick="searchDev()" ><img src="../../res/layui/images/dev_icon/query_icon.png" style="margin-right: 8px;margin-bottom: 4px;">查询</button>
        <button id="btnClear" class="layui-btn layui-btn-sm" ><img src="../../res/layui/images/dev_icon/reset_icon.png" style="margin-right: 8px;margin-bottom: 4px;">重置</button>
        <button id="export" class="layui-btn layui-btn-sm"><img src="../../res/layui/images/dev_icon/export_icon.png" style="margin-right: 8px;margin-bottom: 4px;">导出</button>
    </div>
</script>

<script type="text/html" id="barDemo">
    <%--<a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>--%>
    <%--<a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>--%>
    <a lay-event="edit"><img src="../../res/layui/images/dev_icon/edit_icon.png"></a>
    <a lay-event="del" style="margin-left: 20px"><img src="../../res/layui/images/dev_icon/delete_icon.png"></a>
</script>

<script>
    leftThis('监控设备');
    var table;
    var tablezx;
    //重载表格  刷新表格数据
    function reloadTb() {
        table.reload('demo');
    }

    layui.use(['element','table'], function() {
        table = layui.table;
        var element = layui.element;
        tablezx=table.render({
            id: 'demo',
            elem: '#demo'
            , toolbar: '#toolbarDemo'
            , height: 'full-94'
            // , cellMinWidth: 90
            , url: 'getAllVideo' //数据接口
            , page: true //开启分页
            , cols: [[ //表头
                {type: 'checkbox'}
                ,{type: 'numbers', title: '序号',width:65}
                , {field: 'schoolName', title: '校区', width: 100,align: 'center'}
                , {field: 'houseName', title: '楼栋', width: 100,align: 'center'}
                , {field: 'floorName', title: '楼层', width: 100,align: 'center'}
                , {field: 'roomName', title: '房号', width: 100,align: 'center'}
                , {field: 'devName', title: '监控设备名称', width: 130,align: 'center'}
                , {field: 'devType', title: '监控设备类型', width: 130,align: 'center'}
                , {field: 'ip', title: '监控设备IP', width: 120,align: 'center'}
                , {field: 'netMask', title: '子网掩码', width: 120,align: 'center'}
                , {field: 'gateWay', title: '默认网关', width: 120,align: 'center'}
                , {field: 'port', title: '端口号', width: 80,align: 'center'}
                , {field: 'username', title: '用户名', width: 100,align: 'center'}
                , {field: 'encryptedPassword', title: '密码', width: 100,align: 'center'}
                , {field: 'devStatus', title: '设备状态', width: 100,align: 'center'}
                // , {field: 'strCreateDate', title: '创建时间', width: 160,align: 'center'}
                , {field: 'right', title: '操作', toolbar: '#barDemo', width: 110}
            ]]
            , done: function (res, curr, count) {
                exportData=res.data;
                res.data.forEach(function (item, index) {
                    //如果是在线，修改这行单元格背景和文字颜色
                    // if (item.onLine == "在线") {
                    //     $(".layui-table-body tbody tr[data-index='" + index + "']").css({'background-color': "#009688"});
                    //     $(".layui-table-body tbody tr[data-index='" + index + "']").css({'color': "#fff"});
                    // }
                    if (item.devStatus == "离线") {
                        $(".layui-table-body tbody tr td[data-field=\"devStatus\"]").css({'color': "#b74531"});
                    }
                    if (item.devStatus == "在线") {
                        $(".layui-table-body tbody tr td[data-field=\"devStatus\"]").css({'color': "#1666f9"});
                    }
                });
            }
            , limit: 20
            /* , limits: [15, 20, 30, 50]*/
        });

        //导出按钮
        $("#export").click(function(){
            table.exportFile(tablezx.config.id,exportData, 'xls');
        })

        //监听行事件
        table.on('tool(test)',function (obj) {
            var data = obj.data;
            if(obj.event =='del'){
                layer.confirm('请再次确认是否删除？', function(index){
                    var loading = layer.load(1, {shade: [0.1,'#fff']});
                    $.post('delVideo',{id:data.id},function (res) {
                        obj.del();
                        layer.close(index);
                        layer.msg('删除成功');
                        reloadTb();
                    }).fail(function (xhr) {
                        layer.msg('删除失败 '+xhr.status);
                        console.log(xhr.status);
                    }).always(function () {
                        layer.close(loading);
                    });
                });
            }
            else if(obj.event == 'edit'){
                layer.open({
                    type:2
                    ,zIndex:999
                    ,title:'监控修改'
                    ,area: ['660px', '390px']
                    ,content: 'videoDevView?id='+data.id
                    ,btn:['确认','取消']
                    ,success:function (layero, index) {
                        // var body = layer.getChildFrame('body', index);
                        // var form1 = body.find('#form1');
                        // console.log(data);
                        // formUtilEL.fillFormData(form1,data);
                        //
                        // var childWindow = $(layero.find('iframe'))[0].contentWindow;
                        // childWindow.init(data);
                        // body.find('#username').attr('readonly','readonly');
                        // body.find('#password').val('******');
                        // body.find('#password').attr('readonly','readonly');
                        var obj = $(layero).find("iframe")[0].contentWindow;   //obj可以调用子页面的任何方法
                        var body = layer.getChildFrame('body', index);
                        body.find('input[name="id"]').val(data.id);
                        body.find('input[name="schoolId"]').val(data.schoolId);
                        body.find('input[name="houseId"]').val(data.houseId);
                        body.find('input[name="floorId"]').val(data.floorId);
                        body.find('input[name="roomId"]').val(data.roomId);
                        // body.find('input[name="dnetMask"]').val(data.dnetMask);
                        body.find('input[name="devName"]').val(data.devName);
                        body.find('input[name="ip"]').val(data.ip);
                        body.find('input[name="port"]').val(data.port);
                        body.find('input[name="netMask"]').val(data.netMask);
                        body.find('input[name="gateWay"]').val(data.gateWay);
                        body.find('input[name="username"]').val(data.username);
                        body.find('input[name="password"]').val(data.password);
                    },yes:function (index,layero) {
                        layer.confirm('确认修改？',function () {
                            var body = layer.getChildFrame('body', index);
                            body.find('#submitBtn').click();
                            layer.close(layer.index);
                        
                        });
                    },end:function () {
                        reloadTb();
                    }
                })
            }
        })
        //监听事件
        table.on('toolbar(test)', function (obj) {
            checkStatus = table.checkStatus(obj.config.id);
            switch (obj.event) {
                case 'add':
                    layer.open({
                        type:2
                        ,zIndex:999
                        ,title:'添加视频设备'
                        ,area: ['660px', '390px']
                        ,content: 'videoDevAdd'
                        ,btn:['确认','取消']
                        ,yes:function (index,layero) {
                            layer.confirm('确认新增？',function () {
                                var body = layer.getChildFrame('body', index);
                                body.find('#submitBtn').click();
                                layer.close(layer.index);
                            });
                        },end:function () {
                            reloadTb();
                        }
                    })
                    break;
                case 'delete':
                    var data = checkStatus.data;
                    layer.confirm('请再次确认是否删除？',{
                        yes : function (index,layero) {
                            var loading = layer.msg("删除中，请等待！");
                            $.ajax({
                                url: "/delSomeVideo",
                                type: "POST",
                                contentType: "application/json;charset=UTF-8",//指定消息请求类型
                                data: JSON.stringify(data),
                                success: function () {
                                    layer.close(loading);
                                    tablezx.reload({
                                        method: 'post'
                                        , page: {
                                            curr: 1
                                        }
                                    });
                                    layer.msg("删除成功", {icon: 6});
                                },
                                error: function () {
                                    layer.alert("删除失败");
                                },
                            });
                        }
                    });
                    break;
            };
        });
    });

    // $('#tt').tree({
    //     url:'getTreeData?iconCls=1'
    // });

    //添加设备按钮点击
    // $('#btnAddDev').click(function () {
    //     layer.open({
    //         type:2
    //         ,zIndex:999
    //         ,title:'添加视频设备'
    //         ,area: ['660px', '390px']
    //         ,content: 'videoDevView'
    //         ,btn:['确认','取消']
    //         ,success:function (layero, index) {
    //             // var childWindow = $(layero.find('iframe'))[0].contentWindow;
    //             // var temp = {};
    //             // temp.type = 'switch';
    //             // childWindow.init(temp);
    //         },yes:function (index, layero) {
    //             var body = layer.getChildFrame('body', index);
    //             var form1 = body.find('#form1');
    //             var data = formUtilEL.serializeObject(form1);
    //             //删除无用信息
    //             delete data.school;
    //             delete data.house;
    //             delete data.floor;
    //
    //             var area = 'school house floor treeID';
    //             for(var key in data) {
    //                 console.log(key,data[key]);
    //                 if (data[key] == '' ) {
    //                     if(area.indexOf(key) > -1){
    //                         layer.msg('请选择区域');
    //                     }else {
    //                         layer.msg(body.find('[name="' + key + '"]').attr('placeholder'));
    //                     }
    //                     return;
    //                 }
    //             }
    //
    //             // data.devPostion = data.room;
    //             // data.devType = '1';
    //             // console.log(data);
    //             var loading = layer.load(1, {shade: [0.1,'#fff']});
    //
    //             $.post('addVideo',data,function (res) {
    //                 if(res.code > 0){
    //                     layer.close(index);
    //                     reloadTb();//重载表格
    //                 }
    //                 layer.msg(res.msg);
    //             }).fail(function (xhr) {
    //                 layer.msg('添加失败' + xhr.status);
    //             }).always(function () {
    //                 layer.close(loading);
    //             })
    //         }
    //     })
    // });
    //重置按钮
    $('body').on('click','#btnClear',function(){
        //清空条件查询框中的值
        console.log("重置");
        $('#dev').val('');
        $('#school').val('');
        $('#house').val('');
        $('#floor').val('');
        $('#room').val('');
        $('#devStatus').val('');

        searchDev() ;
        return false;
    })
    //设备搜索
    function searchDev(){
        var devIP = $('#dev').val();
        var devName = $('#dev').val();
        var schoolId = $('#school').val();
        var houseId = $('#house').val();
        var floorId = $('#floor').val();
        var roomId = $('#room').val();
        var devStatus = $('#devStatus').val();
        tablezx = table.reloadExt('demo', {
            url: '/searchVideo'
            ,where: {
                devIP:devIP,
                devName:devName,
                schoolId:schoolId,
                houseId:houseId,
                floorId:floorId,
                roomId:roomId,
                devStatus:devStatus
            } //设定异步数据接口的额外参数
            ,page: {
                curr: 1 //重新从第 1 页开始
            }
        });
        //导出按钮实现
        $("#export").click(function(){
            table.exportFile(tablezx.config.id,exportData, 'xls');
        })
    }

    function OpenDev() {
        //先注册下设备，注册成功再添加数据库
        var bLogin = true;
        bLogin = ZyVideoclickLogin('192.168.0.20',80,'admin','abcd1234');//1.登录摄像机
        alert(bLogin);
    }

</script>
<script>
    var form ;
    layui.use('form', function(){
        form = layui.form;

        $(function () {
            //监听下拉框选中事件
            var school;
            var house;
            var floor;
            var room;
            var devStatus;
            form.on('select(selectSchool)', function (data) {
                var select = $(data.elem);
                var id =select.val();
                /*if(id==0){
                    $('[name="house"]').html('<option value="0">无</option>');
                    $('[name="floor"]').html('<option value="0">无</option>');
                    $('[name="room"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if(id==""){
                    $('[name="house"]').html('<option value="">全部</option>');
                    $('[name="floor"]').html('<option  value="">全部</option>');
                    $('[name="room"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="house"]').html('<option value="">全部</option>');
                        /*$('[name="house"]').append('<option value="0">无</option>');*/
                        res.forEach(function (value,index) {
                            $('[name="house"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="floor"]').html('<option value="">全部</option>');
                        $('[name="room"]').html('<option value="">全部</option>');
                        form.render('select');
                    })
                }
                school = data.elem[data.elem.selectedIndex].text
                console.log("school : " + school)
            });
            form.on('select(selectHouse)', function (data) {
                var select = $(data.elem);
                var id =select.val();
                /*if(id==0){
                    $('[name="floor"]').html('<option value="0">无</option>');
                    $('[name="room"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if(id==""){
                    $('[name="floor"]').html('<option  value="">全部</option>');
                    $('[name="room"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="floor"]').html('<option value="">全部</option>');
                        /*$('[name="floor"]').append('<option value="0">无</option>');*/
                        res.forEach(function (value,index) {
                            $('[name="floor"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="room"]').html('<option value="">全部</option>');
                        form.render('select');
                    })
                }
                house = data.elem[data.elem.selectedIndex].text
                console.log("house : " + house)
            });
            form.on('select(selectFloor)', function (data) {

                var select = $(data.elem);
                var id =select.val();
                /*if(id==0){
                    $('[name="room"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if(id==""){
                    $('[name="room"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if(id!=0) {
                    $.post('getChildrenOrganize', {id: select.val()}, function (res) {
                        console.log(res);
                        $('[name="room"]').html('<option value="">全部</option>');
                        /*$('[name="room"]').append('<option value="0">无</option>');*/
                        res.forEach(function (value, index) {
                            $('[name="room"]').append('<option value="' + value.id + '">' + value.text + '</option>');
                        });
                        form.render('select');
                    })
                }

                floor = data.elem[data.elem.selectedIndex].text
                console.log("floor : " + floor)
            });
            form.on('select(selectRoom)', function (data) {

                room = data.elem[data.elem.selectedIndex].text
                console.log("room : " + room)
            });
            form.on('select(selectStatus)', function (data) {

                devStatus = data.elem[data.elem.selectedIndex].text
                console.log("status : " + onLine)
            });
        });
    });

</script>
<%--<script src="../res/websdk/jquery-1.7.1.min.js"></script>--%>
<%--<script src="../res/websdk/codebase/encryption/AES.js"></script>--%>
<%--<script src="../res/websdk/codebase/encryption/cryptico.min.js"></script>--%>
<%--<!-- <script src="../codebase/encryption/encryption.js"></script> -->--%>
<%--<script src="../res/websdk/codebase/encryption/crypto-3.1.2.min.js"></script>--%>
<%--<script id="videonode" src="../res/websdk/codebase/webVideoCtrl.js"></script>--%>
<%--<script src="../res/websdk/cn/demo.js"></script>--%>
</html>
