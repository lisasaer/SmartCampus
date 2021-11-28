<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2021/7/22
  Time: 14:22
  To change this template use File | Settings | File Templates.
  网关信息展示页
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <!-- layui -->
    <%--    <link rel="stylesheet" type="text/css" href="/res/layui/css/layui.css">--%>
    <%--    <script type="text/javascript" src="/res/layui/layui.js"></script>--%>
    <%--    <script src="res/js/jquery.min.js"></script>--%>
    <%--    <script src="res/js/myjs.js" ></script>--%>

    <title>ZigBee网关管理</title>
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes"/>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <link rel="stylesheet" type="text/css" href="/res/css/jquery.classycountdown.css"/>
    <%--    <link rel="stylesheet" type="text/css" href="/res/css/default.css">--%>
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
        .layui-table-box {
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
            border-color: #d2d2d2;
        }

        /*勾选框中被选中*/
        .layui-form-checked[lay-skin=primary] i {
            border-color: #1666f9 !important;
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
        .layui-form-select {
            width: 123px;
        }

        .layui-select-title input {
            height: 32px;
            width: 115px;
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
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 95px center transparent;
        }

        /*点击后的下拉框箭头图片*/
        .layui-form-selected .layui-select-title input {
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 95px center transparent;
        }

        /*去除条件查询内边距*/
        .layui-table-tool-temp {
            padding: 0;
        }

        /*条件查询框*/
        .layui-table-tool {
            background-color: white;
            height: 55px;
            border-width: 0;
            padding-left: 20px;
            padding-right: 20px;
        }

        /* table 表头背景色*/
        .layui-table thead tr, .layui-table-header {
            background-color: white;
            border-width: 0;
            color: #999999;
        }

        /*table 表头字体大小*/
        .layui-table thead tr th {
            font-size: 16px;
        }

        .layui-table td, .layui-table th {
            border-width: 0px;
        }

        /*table 每行数据顶部线*/
        .layui-table tr {
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
        .laytable-cell-numbers {
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
            border-width: 0;
            text-align: center;
        }

        /*去除分页*/
        .layui-laypage .layui-laypage-limits, .layui-laypage .layui-laypage-refresh {
            display: none;
        }

        .ClassyCountdown-seconds {
            width: 100%;
            line-height: 1em;
            position: absolute;
            text-align: center;
            left: 0;
            display: block;
        }

        .ClassyCountdown-value {
            width: 100%;
            line-height: 1em;
            position: absolute;
            top: 50%;
            text-align: center;
            left: 0;
            display: block;
            /*  color:#2c394a;
              font-size:14px;*/
        }
    </style>

</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <jsp:include page="../header/topHead.jsp"></jsp:include>
    <div class="layui-body"
         style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;background-color: #e8ebee">
        <table id="demo" lay-filter="test"></table>
    </div>
</div>


</body>

<script type="text/html" id="barDemo" style="margin-right: 10px">
    <a lay-event="detail">
        <img src="../../res/layui/images/dev_icon/detail_icon.png">
    </a>
    <a lay-event="edit" style="margin-left: 20px">
        <img src="../../res/layui/images/dev_icon/edit_icon.png">
    </a>
    <a lay-event="delete" style="margin-left: 20px">
        <img src="../../res/layui/images/dev_icon/delete_icon.png">
    </a>
    <%--    <a lay-event="upgrade" style="margin-left: 20px">--%>
    <%--        <img src="../../res/layui/images/dev_icon/upgrade_icon.png">--%>
    <%--    </a>--%>


</script>
<script type="text/html" id="toolbarDemo">
    <div <%--class="layui-form-item"--%><%--style="padding: 0px;height: 30px"--%>>
        <div class="layui-col-md1" style="width: 130px;">
            <%--            <button id="btnSearchDev" class="layui-btn" style="width: 150px; ">搜索设备<img--%>
            <%--                    src="../../res/layui/images/dev_icon/query_icon.png" style="margin-left: 10px;margin-bottom: 4px;"> </button>--%>

            <button id="checkedDel" class="layui-btn layui-btn-sm" lay-event="checkedDel">批量删除</button>
            <button id="btnRefreshDev" style="border: 0px;margin-left: 20px;background-color: #ffff0000;"><img
                    src="../../res/layui/images/dev_icon/refresh_icon.png"></button>
        </div>
        <div class="layui-col-md1" style="width: 1100px;">
            <%--                <form id="form1" class="layui-form" >--%>
            <div class="layui-input-inline" style="margin-left: 10px"><label>校区:</label></div>
            <div class="layui-input-inline">

                <select id="school" name="school" lay-filter="selectSchool" title="校区选择">
                    <option value="">全部</option>
                    <%--<option value="0">无</option>--%>
                    <c:forEach items="${schoolList}" var="item">
                        <option value="${item.id}">${item.text}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="layui-input-inline" style="margin-left:10px">
                <label>楼栋:</label>
            </div>
            <div class="layui-input-inline" style="height: 32px;">
                <select id="house" name="house" lay-filter="selectHouse" title="楼栋选择">
                    <option value="">全部</option>
                </select>
            </div>

            <div class="layui-input-inline" style="margin-left:10px">
                <label>楼层:</label>
            </div>
            <div class="layui-input-inline">
                <select id="floor" name="floor" lay-filter="selectFloor" title="楼层选择">
                    <option value="">全部</option>
                </select>
            </div>

            <div class="layui-input-inline" style="margin-left:10px">
                <label>房号:</label>
            </div>
            <div class="layui-input-inline">
                <select id="room" name="room" lay-filter="selectRoom" title="房号选择">
                    <option value="">全部</option>
                </select>
            </div>

            <div class="layui-input-inline " style="margin-left:10px">
                <label>网关状态:</label>
            </div>
            <div class="layui-input-inline ">
                <select id="onLine" name="onLine" lay-filter="selectStatus" title="网关状态">
                    <option value="">全部</option>
                    --%>
                    <option value="在线">在线</option>
                    <option value="离线">离线</option>
                </select>
            </div>

            <div class="layui-input-inline " style="margin-left: 10px">
                <input type="text" id="keyword" name="keyword" placeholder="请输入ZigBee网关ID" autocomplete="on"
                       class="layui-input" style="height: 32px;width: 170px;">
            </div>

        </div>
        <div style="float: right">
            <%--功能测试--%>
            <%--            <button id="testZigBee" class="layui-btn" style="padding-left: 7px;">测试</button>--%>
            <button id="selectZigBee" class="layui-btn" onclick="selectZigBee()" style="padding-left: 7px;"><img
                    src="../../res/layui/images/dev_icon/query_icon.png" style="margin-right: 8px;margin-bottom: 4px;">查询
            </button>
            <button id="reset" class="layui-btn" onclick="reset()" style="padding-left: 7px;"><img
                    src="../../res/layui/images/dev_icon/reset_icon.png" style="margin-right: 8px;margin-bottom: 4px;">重置
            </button>
            <button id="export" class="layui-btn layui-btn-sm" style="padding-left: 7px;"><img
                    src="../../res/layui/images/dev_icon/export_icon.png" style="margin-right: 8px;margin-bottom: 4px;">导出
            </button>
            <button id="recycle" class="layui-btn layui-btn-sm" style="padding-left: 7px;"><img
                    src="../../res/layui/images/zigBee_dev_icon/recycle.png"
                    style="margin-right: 8px;margin-bottom: 4px;">回收站
            </button>
        </div>

    </div>
</script>

<script>
    var table;
    var tablezx;

    //重载表格数据
    function reloadTB() {
        table.reload('demo');
    }

    //重置
    function reset() {
        window.location.reload();
    }

    //启动webScoket
    $(function () {
        WebSocketTest('refreshZigBeeView');
    });


    layui.use(['element', 'table'], function () {
        var element = layui.element;
        table = layui.table;
        tablezx = table.render({
            id: 'demo',
            elem: '#demo'
            , height: 'full-160'
            //, cellMinWidth: 120
            , url: 'getZigBeeInfo' //数据接口
            , toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            // ,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
            //     title: '提示'
            //     ,layEvent: 'LAYTABLE_TIPS'
            //     ,icon: 'layui-icon-tips'
            // }]
            , page: true //开启分页
            , cols: [[ //表头
                {type: 'checkbox'}
                , {type: 'numbers', title: '序号'/*, fixed: 'left'*/, event: 'row'/*,align : 'center'*/, width: 80}
                //, {field: 'id', title: 'ID',width:50,align : 'center'}
                , {field: 'school', title: '校区', width: 120, event: 'row', align: 'center'}
                , {field: 'house', title: '楼栋', width: 110, event: 'row', align: 'center'}
                , {field: 'floor', title: '楼层', width: 110, event: 'row', align: 'center'}
                , {field: 'room', title: '房号', width: 110, event: 'row', align: 'center'}
                , {field: 'zigbeeId', title: 'ZigBee网关ID', width: 200, event: 'row', align: 'center'}
                , {field: 'devCount', title: '设备数量', width: 110, event: 'row', align: 'center'}
                , {field: 'devOnlineCount', title: '在线数量', width: 110, event: 'row', align: 'center'}
                , {field: 'devOfflineCount', title: '离线数量', width: 110, event: 'row', align: 'center'}
                , {
                    field: 'ol', title: '网关状态', width: 110, event: 'row', align: 'center', templet: function (res) {
                        if (res.ol == "true") {
                            return '在线';
                        } else {
                            return '离线';
                        }
                    }
                }
                , {field: 'remark', title: '备注', event: 'row', width: 250}
                , {field: 'right', title: '操作', toolbar: '#barDemo', width: 150, align: 'center'}
            ]]
            , done: function (res, curr, count) {
                exportData = res.data;
                res.data.forEach(function (item, index) {
                    if (item.ol == "true") {
                        $(".layui-table-body tbody tr td[data-field=\"ol\"]").css({'color': "#15d900"});
                    }
                    if (item.ol == "false") {
                        $(".layui-table-body tbody tr td[data-field=\"ol\"]").css({'color': "#b74531"});
                    }
                });
            }
            , limit: 20
            /* , limits: [15, 20, 30, 50]*/
        });

        //监听头部事件
        var checkStatus;
        table.on('toolbar(test)', function (obj) {
            checkStatus = table.checkStatus(obj.config.id);
            switch (obj.event) {
                //批量删除设备
                case 'checkedDel':
                    var data = checkStatus.data;
                    layer.confirm('请再次确认是否删除？', {
                        yes: function (index, layero) {
                            var loading = layer.msg("删除中，请等待！");
                            $.ajax({
                                url: "/delSomeZigBee",
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
            }
        });


        //头部事件---刷新设备
        $('body').on('click', '#btnRefreshDev', function () {
            // $('#btnUpdateDev').click(function () {
            var loading = MyLayUIUtil.loading();
            console.log("主页刷新");
            reloadTB();
            MyLayUIUtil.closeLoading(loading);
        });
        //头部事件---回收站
        $('body').on('click', '#recycle', function () {
            layer.open({
                type: 2,
                title: "ZigBee网关回收站",
                area: ['1045px', '620px'],
                shade: 0.8,
                shadeClose: true,
                content: 'goZigBeeRecycleBin'
                , success: function (layero, index) {
                    layer.iframeAuto(index);
                }
            });
        });

        //监听行工具事件
        table.on('tool(test)', function (obj) {
            var data = obj.data;
            console.info("点击的数据为：");
            console.info(data);
            if (obj.event === 'delete') {
                layer.confirm('此操作会连带删除此网关下关联的所有设备，请再次确认是否删除？', function (index) {
                    var loading = layer.load(1, {shade: [0.1, '#fff']});
                    var temp = {
                        zigbeeId: data.zigbeeId
                        // ,devSN:data.devSN
                    };
                    $.post('delZigBeeGateway', temp, function (res) {
                        reloadTB();
                        layer.msg(res.msg);
                        obj.del();
                        layer.close(index);
                    }).fail(function (xhr) {
                        layer.msg('删除失败 ' + xhr.status);
                        console.log(xhr.status);
                    }).always(function () {
                        layer.close(loading);
                    });
                });
                //详情页
            } else if (obj.event == 'detail') {
                console.info(data.zigbeeId);
                layer.open({
                    type: 2,
                    title: "ZigBee网关设备详情",
                    area: ['1200px', '800px'],
                    shade: 0.8,
                    shadeClose: true,
                    //传入设备数量，在线离线数,zigbeeId
                    content: 'goZigBeeDevDetail?devCount=' + data.devCount + '&devOnlineCount=' + data.devOnlineCount
                        + '&devOfflineCount=' + data.devOfflineCount + '&zigbeeId=' + data.zigbeeId
                    , success: function (layero, index) {
                        layer.iframeAuto(index);
                    }
                });
                //编辑页
            } else if (obj.event == 'edit') {
                layer.open({
                    type: 2,
                    title: "编辑网关",
                    area: ['470px', '510px'],
                    shade: 0.8,
                    shadeClose: true,
                    btn: ['确认', '取消'],
                    content: 'goZigBeeEdit?zigbeeId=' + data.zigbeeId
                    , success: function (layero, index) {
                        var body = layer.getChildFrame('body', index);
                        var zigBeeForm = body.find('#zigBeeForm');
                        console.info("网关信息：");
                        console.log(data);
                        formUtilEL.fillFormData(zigBeeForm, data);
                    }, yes: function (index, layero) {
                        var body = layer.getChildFrame('body', index);
                        var zigBeeForm = body.find('#zigBeeForm');
                        var formData = formUtilEL.serializeObject(zigBeeForm);

                        console.log(formData);

                        var loading = layer.load(1, {shade: [0.1, '#fff']});
                        $.post('editZigBee', formData, function (res) {
                            if (res.code > 0) {
                                layer.close(index);
                                reloadTB();//重载表格
                            }
                            layer.msg(res.msg);
                        }).fail(function (msg) {
                            layer.msg('添加失败 ' + msg.status);
                        }).always(function () {
                            layer.close(loading);
                        })
                    }
                })
            }

        });


    });
</script>

<!--页面实时刷新-->
<script>
    var layer;
    layui.use(['layer'], function () {
        layer = layui.layer;
    });

    function WebSocketTest(wsPath) {
        if ("WebSocket" in window) {
            //alert("您的浏览器支持 WebSocket!");

            var hostName = window.location.hostname;
            var port = window.location.port;
            console.log("ws://" + hostName + ":" + port + "/" + wsPath);
            // 打开一个 web socket
            var ws = new WebSocket("ws://" + hostName + ":" + port + "/" + wsPath);
            ws.onopen = function () {
                console.log('ws 已连接');
            };
            ws.onmessage = function (evt) {
                console.log("WebSocket收到的消息:" + evt.data);
                if (evt.data == "ZigBeeGatewayOffline") {
                    reloadTB();
                }

            };
            ws.onclose = function () {
                // 关闭 websocket
                console.log("连接已关闭...");
            };
        } else {
            // 浏览器不支持 WebSocket
            console.log("您的浏览器不支持 WebSocket!");
        }
    }


</script>

<script>
    var form;
    var school;
    var house;
    var floor;
    var room;
    var onLine;
    layui.use('form', function () {
        form = layui.form;

        $(function () {
            //监听下拉框选中事件

            form.on('select(selectSchool)', function (data) {
                var select = $(data.elem);
                var id = select.val();
                console.info("id:" + id);
                if (id == "") {
                    $('[name="house"]').html('<option value="">全部</option>');
                    $('[name="floor"]').html('<option  value="">全部</option>');
                    $('[name="room"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if (id != 0) {
                    $.post('getChildrenOrganize', {id: select.val()}, function (res) {
                        console.log(res);
                        $('[name="house"]').html('<option value="">全部</option>');
                        //用学校Id作为pid查出校区下的楼栋，并遍历到html中
                        res.forEach(function (value, index) {
                            $('[name="house"]').append('<option value="' + value.id + '">' + value.text + '</option>');
                        });
                        $('[name="floor"]').html('<option value="">全部</option>');
                        form.render('select');
                    })
                }
                school = data.elem[data.elem.selectedIndex].text
                console.log("school : " + school)
            });
            form.on('select(selectHouse)', function (data) {

                var select = $(data.elem);
                var id = select.val();
                /*if(id==0){
                    $('[name="floor"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if (id == "") {
                    $('[name="floor"]').html('<option  value="">全部</option>');
                    $('[name="room"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if (id != 0) {
                    $.post('getChildrenOrganize', {id: select.val()}, function (res) {
                        console.log(res);
                        $('[name="floor"]').html('<option value="">全部</option>');
                        /*$('[name="floor"]').append('<option value="0">无</option>');*/
                        res.forEach(function (value, index) {
                            $('[name="floor"]').append('<option value="' + value.id + '">' + value.text + '</option>');
                        });
                        $('[name="room"]').html('<option value="">全部</option>');
                        form.render('select');
                    })
                }
                house = data.elem[data.elem.selectedIndex].text;
                console.log("house : " + house)
            });
            form.on('select(selectFloor)', function (data) {
                var select = $(data.elem);
                var id = select.val();
                /*if(id==0){
                    $('[name="floor"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if (id == "") {
                    $('[name="room"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if (id != 0) {
                    $.post('getChildrenOrganize', {id: select.val()}, function (res) {
                        console.log(res);
                        $('[name="room"]').html('<option value="">全部</option>');
                        /*$('[name="floor"]').append('<option value="0">无</option>');*/
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

                onLine = data.elem[data.elem.selectedIndex].text
                console.log("status : " + onLine)
            });
        });
    });

    function selectZigBee() {
        var school = $("#school").val();
        var house = $("#house").val();
        var floor = $("#floor").val();
        var room = $("#room").val();
        var onLine = $("#onLine").find("option:selected").text();
        var keyword = $("#keyword").val();
        if ("在线" == onLine) {
            onLine = "true";
        } else if ("离线" == onLine) {
            onLine = "false";
        } else {
            onLine = "全部";
        }
        console.info(onLine);
        tablezx = table.reloadExt('demo', {
            url: 'getZigBeeInfoByCondition'
            , page: {curr: 1}
            , method: 'post'
            , where: {
                school: school,
                house: house,
                floor: floor,
                room: room,
                ol: onLine,
                keyword: keyword,
            }
        });
        //导出按钮重新实现
        $("#export").click(function () {
            table.exportFile(tablezx.config.id, exportData, 'xls');
        })
        // });

    }
</script>

</html>
