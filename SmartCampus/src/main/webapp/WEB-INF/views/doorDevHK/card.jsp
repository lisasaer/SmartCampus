<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/5/29
  Time: 20:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <meta charset="utf-8">
    <title>权限管理</title>
    <jsp:include page="../header/res.jsp"></jsp:include>

</head>
<body>
<div class="layui-layout layui-layout-admin">
    <div style="bottom: 0px">
        <!-- 内容主体区域 -->
        <div style="padding: 15px;">
            <div >
                <div class="demoTable">
                    <label >请输入关键字:</label>
                    <div class="layui-inline">
                        <input type="text" id="staff" placeholder="请输入设备名称/设备IP/姓名/卡号" style="width: 150px;height: 30px;margin-right:10px;margin-left:10px;">
                    </div>
                    <button id="btnQuery" class="layui-btn" style="height: 30px;line-height: 0px;" onclick="query()">查询</button>
                    <button id="btnClear" class="layui-btn" style="height: 30px;line-height: 0px;">重置</button>
                </div>
                <table id="demo" lay-filter="test" class="layui-hide"></table>
            </div>
        </div>
    </div>

    <script>
        var table;
        //查询按钮
        function query() {
            var name = $('#staff').val();
            var cardNo = $('#staff').val();
            var dname = $('#staff').val();
            var dip = $('#staff').val();
            table.reload('demo', {
                url: 'getAllPermission'
                ,where: {
                    name:name,
                    cardNo:cardNo,
                    dname:dname,
                    dip:dip
                }
                ,page:{
                    curr: 1
                }
            });
        }
        layui.use(['table', 'element'], function () {
            table = layui.table
                , $ = layui.jquery
                , element = layui.element;

            table.render({
                elem: '#demo'
                , height: '400'
                , width: '847'
                , url: 'getAllPermission' //数据接口
                , page: true //开启分页
                , cols: [[ //表头
                    {type: 'numbers', title: '序号', fixed: 'left'}
                    , {field: 'devName', title: '设备名称', width: 200,align: 'center'}
                    , {field: 'dip', title: '设备IP', width: 200,align: 'center'}
                    , {field: 'staffName', title: '姓名', width:200,align: 'center'}
                    , {field: 'cardNo', title: '卡号', width: 200,align: 'center'}
                ]],
                page:true,
                limits:[15,20,30,50],
                limit:20,
                done: function(res, curr, limit ,count){
                    _cur_page =curr;
                    _cur_limit = limit;
                    $('[data-field="id"]').addClass('layui-hide');
                }
                ,where:{
                    recordType:'1'//1-当天记录;2-历史记录
                }
            });

            //刷新按钮
            $('#btnReload').click(function () {
                var staffName = "";
                var staffId = "";
                var cardNo = "";
                var devName = "";
                var departmentName = "";
                var workState = "";
                table.reload('demo', {
                    url: 'getAllPermission'
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

                $('#staffName').val('');
                $('#staffId').val('');
                $('#cardNo').val('');
                $('#devName').val('');
                $('#departmentName').val('');
                $('#workState').val('');
                $('#btnQuery').click();
                return false;
            });
            //查询按钮

            $('#btnQuery').click(function () {
                var staffName = $('#staffName').val();
                var staffId = $('#staffId').val();
                var cardNo = $('#cardNo').val();
                var devName = $('#devName').val();
                var departmentName = $('#departmentName').val();
                var workState = $('#workState').val();
                table.reload('demo', {
                    url: 'getAllPermission'
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
        });
    </script>
</div>
</body>
</html>