<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 2020-07-16
  Time: 13:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <meta charset="utf-8">
    <title>微耕权限管理</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <%--    <link rel="stylesheet" href="css/layui.css" media="all">--%>
</head>
<body>
<div class="layui-layout layui-layout-admin">
    <div style="bottom: 0px">
        <!-- 内容主体区域 -->
        <div style="padding: 15px;">
            <div >
                <div class="demoTable">
                    <label >根据员工关键字查询:</label>
                    <div class="layui-inline">
                        <input type="text" id="staff" placeholder="编号/卡号/姓名" style="width: 150px;height: 30px;margin-right:10px;margin-left:10px;" autocomplete="off">
                    </div>
                    <label >根据门禁关键字查询:</label>
                    <div class="layui-inline">
                        <input type="text" id="door" placeholder="门名称/控制器序列号" style="width: 150px;height: 30px;margin-right:10px;margin-left:10px;" autocomplete="off">
                    </div>
                    <button id="btnQuery" class="layui-btn" style="height: 30px;line-height: 0px;" onclick="query()">查询</button>
                    <button id="btnClear" class="layui-btn" style="height: 30px;line-height: 0px;">重置</button>
                    <button id="btnReload" class="layui-btn" style="height: 30px;line-height: 0px;">刷新</button>

                </div>
                <table id="demo" lay-filter="test" class="layui-hide"></table>
            </div>
        </div>
    </div>

    <script>
        var table;

        layui.use(['table', 'element'], function () {
            table = layui.table
                , $ = layui.jquery
                , element = layui.element;

            table.render({
                elem: '#demo'
                , height: '450'
                , width: '900'
                , url: 'getWGPermission' //数据接口
                , page: true //开启分页
                , cols: [[ //表头
                    {type: 'numbers', title: '序号', fixed: 'left'}
                    , {field: 'staffId', title: '编号', width: 130,align: 'center'}
                    , {field: 'name', title: '姓名', width: 125,align: 'center'}
                    , {field: 'cardNo', title: '卡号', width: 135,align: 'center'}
                    , {field: 'doorName', title: '门名称', width: 125,align: 'center'}
                    , {field: 'ctrlerSN', title: '控制器序列号', width: 135,align: 'center'}
                    , {field: 'strCreatedTime', title: '创建日期', width: 200,align: 'center'}
                ]],
                page: true,
                limits: [15, 20, 30, 50],
                limit: 20,
                done: function (res, curr, limit, count) {
                    _cur_page = curr;
                    _cur_limit = limit;
                    $('[data-field="id"]').addClass('layui-hide');
                }
                , where: {
                    recordType: '1'//1-当天记录;2-历史记录
                }
            });

        });
        //查询按钮
        function query() {
            var name = $('#staff').val();
            var cardNo = $('#staff').val();
            var staffId = $('#staff').val();
            var ctrlerSN = $('#door').val();
            var doorName = $('#door').val();
            table.reload('demo', {
                url: 'getAllWGPermission'
                ,where: {
                    name:name,
                    cardNo:cardNo,
                    staffId:staffId,
                    ctrlerSN:ctrlerSN,
                    doorName:doorName,
                }
                ,page:{
                    curr: 1
                }
            });
        }

        //刷新按钮
        $('#btnReload').click(function () {
            var staffName = "";
            var staffId = "";
            var cardNo = "";
            var devName = "";
            var departmentName = "";
            var workState = "";
            table.reload('demo', {
                url: 'getWGPermission'
                ,where: {
                    staffName:staffName,
                    staffId:staffId,
                    cardNo:cardNo,
                    devName:devName,
                    departmentName:departmentName,
                    workState:workState
                }
                ,page:{
                    curr:1
                }
            });
            return false;
        });

        //重置按钮
        $('#btnClear').click(function () {

            $('#door').val('');
            $('#staff').val('');
            return false;
        });
    </script>
</div>
</body>
</html>
