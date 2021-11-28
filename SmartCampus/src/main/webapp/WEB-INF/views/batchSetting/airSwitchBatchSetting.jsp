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
<html>
<head>
    <title>首页</title>
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
<%--                <fieldset class="layui-elem-field layui-field-title">--%>
<%--                    <legend style="font-size: 16px;">设备列表</legend>--%>
<%--                </fieldset>--%>
                <div>
                    <button id="btnBatch" class="layui-btn">批量设置</button>
                </div>
                <table  id="demo" lay-filter="test"></table>
            </div>
        </div>

<%--         --%>
    </div>
</body>
<script>

    $('#tt').tree({
        url:'getTreeData?iconCls=1'
    });

    $('#tt').tree({
        onClick: function(node){
            $('strong').text(node.text);
            table.reload('demo', {
                url: '/getDevByTreeID'
                ,where: {
                    nodeId:node.id,
                    iconCls:node.iconCls,
                    devType:"1"
                } //设定异步数据接口的额外参数
                ,page: {
                    curr: 1 //重新从第 1 页开始
                }
            });
        }
    });

    layui.use(['tree','element'], function(){
        var tree = layui.tree
            ,element = layui.element;
    });

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
            , height: 'full-240'
            , cellMinWidth: 120
            , url: 'getDev' //数据接口
            , page: true //开启分页
            , cols: [[ //表头
                  {type: 'checkbox', fixed: 'left'}
                , {field: 'id', title: 'ID', style: 'display:none', width: 1,event:'row'}
                , {field: 'school',   title: '校区',event:'row'}
                , {field: 'house',   title: '楼栋',event:'row'}
                , {field: 'floor',   title: '楼层',event:'row'}
                , {field: 'room',   title: '房号',event:'row'}
                , {field: 'devId',   title: '设备ID',event:'row'}
                , {field: 'devSN',   title: '设备SN',event:'row',style: 'display:none', width: 1}
                , {field: 'devName', title: '设备名称',event:'row'}
                , {field: 'lineCount', title: '线路数',event:'row'}
                , {field: 'devStatus', title: '状态',event:'row'}
            ]]
            , done: function (res, curr, count) {
                $('[data-field="id"]').addClass('layui-hide');
                $('[data-field="devSN"]').addClass('layui-hide');

            }
            ,limit:15
            ,limits:[15,20,30,50]
            ,where:{
                devType:'1'
            }
        });

        //监听行工具事件
        table.on('tool(test)', function(obj){
            var data = obj.data;
            if(obj.event === 'edit'){
                layer.open({
                    type: 2,
                    title: false,
                    area: ['1000px', '623px'],
                    shade: 0.8,
                    closeBtn: 0,
                    shadeClose: true,
                    content: 'airSwitchLineStatus?devSN='+data.devSN
                    ,success: function(layero, index) {
                        layer.iframeAuto(index);
                    }
                });
            }
        });
    });
    
    $("#btnBatch").click(function () {
        //通过这种方式弹出的层，每当它被选择，就会置顶。
        layer.open({
            type: 2,
            shade: false,
            area: ['400px', '600px'],
            content: 'addAirSwithBatchSetting',
            //zIndex: layer.zIndex, //重点1
            btn:['确认','取消'],
            success: function(layero){
                //layer.setTop(layero); //重点2
            }
        });
    })
</script>

</html>
