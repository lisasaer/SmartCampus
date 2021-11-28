<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/5/29
  Time: 20:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>设备管理</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <%--    <link rel="stylesheet" href="css/layui.css" media="all">--%>
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
<body>
<div class="layui-layout layui-layout-admin">
    <jsp:include page="../header/topHead.jsp"></jsp:include>
    <div class="layui-body" style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;">
        <!-- 内容主体区域 -->
        <div>
            <div <%--style="padding: 15px;"--%>>
                <table id="demo" lay-filter="test" class="layui-hide"></table>
                <script type="text/html" id="toolbarDemo">
                    <div>
                        <button class="layui-btn layui-btn-sm" lay-event="add">添加设备</button>
                        <button class="layui-btn layui-btn-sm" lay-event="delete">批量删除</button>

                        <div class="layui-input-inline"style="padding-left: 10px">
                            <label >校区</label>
                            <div class="layui-input-inline" >
                                <select id="school" name="school" lay-filter="selectSchool" title="校区选择" >
                                    <option value="">全部</option>
<%--                                    <option value="0">无</option>--%>
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
                                   autocomplete="off"  style="width: 150px;height: 30px;">
                            <span style=" position: absolute; top: 8%; right: 6%; display: table-cell;/*background-color: #0d8ddb*/;white-space: nowrap">
                                <img src="../../res/layui/images/dev_icon/input_query_icon.png" style="padding-right: 0px;margin-bottom: 4px;">
                            </span>
                        </div>
                        <div style="float: right;">
                            <button id="btnQuery" class="layui-btn layui-btn-sm" onclick="query()" ><img src="../../res/layui/images/dev_icon/query_icon.png" style="margin-right: 8px;margin-bottom: 4px;">查询</button>
                            <button id="btnClear" class="layui-btn layui-btn-sm" ><img src="../../res/layui/images/dev_icon/reset_icon.png" style="margin-right: 8px;margin-bottom: 4px;">重置</button>
                            <button id="export" class="layui-btn layui-btn-sm"><img src="../../res/layui/images/dev_icon/export_icon.png" style="margin-right: 8px;margin-bottom: 4px;">导出</button>
                        </div>
                    </div>
                </script>
                <script type="text/html" id="barDemo">
                    <a lay-event="edit"><img src="../../res/layui/images/dev_icon/edit_icon.png"></a>
                    <a lay-event="del" style="margin-left: 20px"><img src="../../res/layui/images/dev_icon/delete_icon.png"></a>
                </script>
            </div>
        </div>

    </div>

    <script>

        var tablezx;
        var table;
        layui.use(['table', 'element', 'form', 'jquery', 'laydate','layer'], function () {
            table = layui.table
                , $ = layui.jquery
                , element = layui.element;

            $(document).ready(function () {
                $("#li4").addClass("layui-this");
                // $("#d1").addClass("layui-this");
            });
            tablezx = table.render({
                elem: '#demo'
                , toolbar: '#toolbarDemo'
                , height: 'full-95'
                , url: 'selectDeviceAll' //数据接口
                , cols: [[ //表头
                    {type: 'checkbox'}
                    ,{type: 'numbers', title: '序号', width: 65}
                    , {field: 'schoolName', title: '校区', width: 95,}
                    , {field: 'houseName', title: '楼栋', width: 95,align: 'center'}
                    , {field: 'floorName', title: '楼层', width: 95,align: 'center'}
                    , {field: 'roomName', title: '房号', width: 95,align: 'center'}
                    , {field: 'dname', title: '人脸设备名称', width: 130,align: 'center'}
                    , {field: 'dtype', title: '设备类型', width: 110,align: 'center'}
                    , {field: 'dip', title: '设备IP', width: 120,align: 'center'}
                    , {field: 'dnetMask', title: '子网掩码', width: 120,align: 'center'}
                    , {field: 'dgateWay', title: '默认网关', width: 110,align: 'center'}
                    , {field: 'port', title: '端口号', width: 100,align: 'center'}
                    , {field: 'duser', title: '用户名', width: 110,align: 'center'}
                    , {field: 'encryptedPassword', title: '密码', width: 110,align: 'center'}
                    , {field: 'devStatus', title: '设备状态', width: 110,align: 'center'}
                    // , {field: 'strCreatedTime', title: '创建时间', width: 110,align: 'center'}
                    , {field: 'right', title: '操作', toolbar: '#barDemo',width: 110}
                ]]
                ,done: function (res, curr, count) {
                    exportData=res.data;
                    res.data.forEach(function (item,index) {
                        //如果是在线，修改这行单元格背景和文字颜色
                        /*if(item.devStatus == "在线"){
                            $(".layui-table-body tbody tr[data-index='"+index+"']").css({'background-color': "#009688"});
                            $(".layui-table-body tbody tr[data-index='"+index+"']").css({'color': "#fff" });
                        }*/
                        if (item.devStatus == "离线") {
                            $(".layui-table-body tbody tr td[data-field=\"devStatus\"]").css({'color': "#b74531"});
                        }
                        if (item.devStatus == "在线") {
                            $(".layui-table-body tbody tr td[data-field=\"devStatus\"]").css({'color': "#1666f9"});
                        }
                    });
                }
                ,page:true
                // ,limits:[10,20,50,100]
                ,limit:1
            });

            $("#export").click(function(){
                table.exportFile(tablezx.config.id,exportData, 'xls');
            })

            //监听行工具事件
            table.on('tool(test)', function (obj) {
                var data = obj.data;//获取当前行的数据
                if (obj.event === 'del') {
                    layer.confirm('此操作会连带删除此门禁设备下关联的所有人员权限,请再次确认是否删除？',{
                        yes : function (index,layero) {
                            // var loading = layer.msg("删除中，请等待！");
                            var loading = layer.msg('<span style="font-size:20px">删除中...请等待</span>', {icon: 16, shade: 0.3, time:0,});
                            $.ajax({
                                url: "/delDevice",
                                type: "POST",
                                // data: {"id": data.deviceId},
                                data: data,
                                success: function () {
                                    layer.close(loading);
                                    $(".layui-laypage-btn").click();//刷新本页面（父页面） 的数据
                                    //关闭弹框
                                    layer.close(index);
                                    layer.msg("删除成功", {icon: 6});
                                },
                                error: function () {
                                    layer.alert("删除失败");
                                },
                            });
                        }
                    });
                } else if (obj.event === 'edit') {
                    layer.open({
                        type: 2,
                        zIndex:999,
                        title: '设备编辑',
                        area: ['511px', '610px'],
                        content: 'editDeviceView?deviceId='+data.deviceId,
                        btn: ['确认', '取消'],
                        success: function (layero, index) {
                            var obj = $(layero).find("iframe")[0].contentWindow;   //obj可以调用子页面的任何方法
                            var body = layer.getChildFrame('body', index);
                            body.find('input[name="deviceId"]').val(data.deviceId);
                            body.find('input[name="dname"]').val(data.dname);
                            body.find('input[name="port"]').val(data.port);
                            body.find('input[name="dip"]').val(data.dip);
                            body.find('input[name="dnetMask"]').val(data.dnetMask);
                            body.find('input[name="dgateWay"]').val(data.dgateWay);
                            body.find('input[name="duser"]').val(data.duser);
                            body.find('input[name="dpassWord"]').val(data.dpassWord);
                            // body.find('input[name="dposition"]').val(data.dposition);
                            // body.find('input[name="departmentName"]').val(data.departmentName);
                        }
                        ,yes:function (index,layero) {
                            layer.confirm('确认修改？',function () {
                                var body = layer.getChildFrame('body', index);
                                body.find('#submitBtn').click();
                                layer.close(layer.index);

                            });
                        },end:function () {
                            tablezx.reload();
                        }
                    });
                }
            });
            var checkStatus;
            //监听事件
            table.on('toolbar(test)', function (obj) {
                checkStatus = table.checkStatus(obj.config.id);
                switch (obj.event) {
                    case 'add':
                        layer.open({
                            type:2,
                            zIndex:999
                            ,title:'添加人脸门禁设备'
                            ,area: ['511px', '610px']
                            ,content: 'goAddDevice'
                            ,btn: ['确认', '取消']
                            ,yes:function (index,layero) {
                                layer.confirm('确认新增？',function () {
                                    var body = layer.getChildFrame('body', index);
                                    body.find('#submitBtn').click();
                                    layer.close(layer.index);
                                });
                            },end:function () {
                                tablezx.reload();
                            }
                        });
                        break;
                    case 'delete':
                        var data = checkStatus.data;
                        layer.confirm('是否删除所选设备？请谨慎操作！',{
                            yes : function (index,layero) {
                                var loading = layer.msg("删除中，请等待！");
                                $.ajax({
                                    url: "/delSomeDevice",
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

                query() ;
                return false;
            })
        });
        //查询按钮
        function query() {
            //获取条件查询输入框中的值
            var dev = $('#dev').val();
            var schoolId = $('#school').val();
            var houseId = $('#house').val();
            var floorId = $('#floor').val();
            var roomId = $('#room').val();
            var devStatus = $('#devStatus').val();

            tablezx = table.reload('demo', {
                url: 'queryConditionDev'
                ,where: {
                    schoolId:schoolId,
                    houseId:houseId,
                    floorId:floorId,
                    roomId:roomId,
                    devStatus:devStatus,
                    dname:dev,
                    dip:dev
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
    </script>
</body>
<script>
    var form ;
    layui.use('form', function(){
        form = layui.form;
        //监听下拉框选中事件
        $(function () {

            var school;
            var house;
            var floor;
            var room;
            //校区下拉框选中点击
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
                        $('[name="house"]').html('<option value="">全部</option>');
                        // $('[name="house"]').append('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="house"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="floor"]').html('<option value="">全部</option>');
                        $('[name="room"]').html('<option value="">全部</option>');
                        form.render('select');
                    })
                }
                school = $('[name="school"]').val();
                console.log("校区下拉框选中点击"+school)
            });
            //楼栋下拉框选中点击
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
                        $('[name="floor"]').html('<option value="">全部</option>');
                        // $('[name="floor"]').append('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="floor"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="room"]').html('<option value="">全部</option>');
                        form.render('select');
                    })
                }
                house = $('[name="house"]').val();
            });
            //楼层下拉框选中点击
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
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        $('[name="room"]').html('<option value="">全部</option>');
                        // $('[name="room"]').append('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="room"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        form.render('select');
                    })
                }
                floor =  $('[name="floor"]').val();
            });

            form.on('select(selectRoom)', function (data) {
                room =  $('[name="room"]').val();
            });
        });
    });

</script>
</html>