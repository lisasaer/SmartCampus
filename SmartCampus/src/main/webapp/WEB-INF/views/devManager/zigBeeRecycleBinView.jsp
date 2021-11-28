<%--
  Created by IntelliJ IDEA.
  User: zy-dzb
  Date: 2021/8/11
  Time: 9:44
  To change this template use File | Settings | File Templates.
  网关回收站
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>


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
<body class="layui-layout-body" >
<div class="layui-layout layui-layout-admin" >
    <div
         style="bottom: 0px;padding:15px;background-color: #e8ebee">
        <table id="recycleBinTable" lay-filter="recycleBinTable"></table>
    </div>
</div>
</body>
<%--头部工具栏--%>
<script type="text/html" id="toolbarDemo">
    <div class="layui-input-inline " style="margin-left: 10px">
        <input type="text" id="keyword" name="keyword" placeholder="请输入ZigBee网关ID" autocomplete="on"
               class="layui-input" style="height: 32px;width: 170px;">
    </div>
    <div style="display: inline-block; margin-left: 10px">
        <button id="selectZigBee" class="layui-btn" onclick="selectZigBee()" style="padding-left: 7px;"><img
                src="../../res/layui/images/dev_icon/query_icon.png" style="margin-right: 8px;margin-bottom: 4px;">查询
        </button>
    </div>
</script>
<%--右侧工具栏--%>
<script type="text/html" id="barDemo" style="margin-right: 10px">
    <a lay-event="recover">
        <img src="../../res/layui/images/dev_icon/recover_icon. png">
    </a>
</script>
<script>
    var table;
    var tablezx;
    //重载表格数据
    function reloadTB() {
        table.reload('recycleBinTable');
    }

    layui.use(['element', 'table'], function () {
        var element = layui.element;
        table = layui.table;
        tablezx = table.render({
            id: 'recycleBinTable',
            elem: '#recycleBinTable'
            , height: 510
            //, cellMinWidth: 120
            , url: 'getFalseDelZigBeeInfo' //数据接口
            , toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            , page: true //开启分页
            , cols: [[ //表头
                 {type: 'numbers', title: '序号'/*, fixed: 'left'*/, event: 'row'/*,align : 'center'*/, width: 80}
                //, {field: 'id', title: 'ID',width:50,align : 'center'}
                , {field: 'school', title: '校区', width: 80, event: 'row', align: 'center'}
                , {field: 'house', title: '楼栋', width: 80, event: 'row', align: 'center'}
                , {field: 'floor', title: '楼层', width: 80, event: 'row', align: 'center'}
                , {field: 'room', title: '房号', width: 80, event: 'row', align: 'center'}
                , {field: 'zigbeeId', title: 'ZigBee网关ID', width: 180, event: 'row', align: 'center'}
                , {
                    field: 'ol', title: '网关状态', width: 110, event: 'row', align: 'center', templet: function (res) {
                        if (res.ol == "true") {
                            return '在线';
                        } else {
                            return '离线';
                        }
                    }
                }
                , {field: 'remark', title: '备注', event: 'row', width: 200}
                , {field: 'right', title: '操作', toolbar: '#barDemo', width: 80, align: 'center'}
            ]]
            , done: function (res, curr, count) {
                exportData = res.data;
                res.data.forEach(function (item, index) {
                    if (item.ol == "true") {
                        $(".layui-table-body tbody tr td[data-field=\"onLine\"]").css({'color': "#b74531"});
                    }
                    if (item.ol == "false") {
                        $(".layui-table-body tbody tr td[data-field=\"onLine\"]").css({'color': "#1666f9"});
                    }
                });
            }
            , limit: 20
        });


        //监听行工具事件
        table.on('tool(recycleBinTable)', function (obj) {
            var data = obj.data;
            console.info("回收站点击的数据为：");
            console.info(data);
            if (obj.event === 'recover') {
                layer.confirm('请确认是否恢复该网关？恢复回设备将在一分钟内自动重新添加', function (index) {
                    var loading = layer.load(1, {shade: [0.1, '#fff']});
                    var temp = {
                        zigbeeId: data.zigbeeId
                    };
                    $.post('recoverZigBeeGateway', temp, function (res) {
                        reloadTB();
                        layer.msg(res.msg);
                        obj.del();
                        layer.close(index);
                    }).fail(function (xhr) {
                        layer.msg('恢复失败 ' + xhr.status);
                        console.log(xhr.status);
                    }).always(function () {
                        layer.close(loading);
                    });
                });
            }
        });


    });


    function selectZigBee() {
        var keyword = $("#keyword").val();
        tablezx = table.reloadExt('recycleBinTable', {
            url: 'getFalseDelZigBeeInfo'
            , page: {curr: 1}
            , method: 'post'
            , where: {
                keyword: keyword
            }
        });
    }


</script>
</html>
