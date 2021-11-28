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
    <title>设备管理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        /*去除table表单外边距*/
        .layui-table, .layui-table-view {
            margin-bottom: 0;
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
                <%--                <div id="btnAddTree" title="添加区域" class="my-iconset my-icon-addVideo"></div>--%>
                <%--                <div id="btnDel" title="删除" class="my-iconset my-icon-del"></div>--%>
                <%--                <hr style="margin: 2px;">--%>
                <ul id="tt"></ul>
            </div>
            <div class="my-tree-body-div" style="bottom: 15px;margin-left: 25px;margin-top: 4px;padding:15px;">
            <fieldset class="layui-elem-field layui-field-title">
                <legend style="font-size: 16px;">空调设备列表</legend>
            </fieldset>
            <table id="demo" lay-filter="test"></table>
            </div>
        </div>

<%--         --%>
    </div>
</body>

<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs " lay-event="edit">查看</a>
</script>

<script>
    // $(function () {
        leftThis('空调设备');
        console.log('comOpen','<%=bComOpen%>');
    // });

    //注意：导航 依赖 element 模块，否则无法进行功能性操作
    layui.use('element', function(){
        var element = layui.element;
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
            id: 'demo',
            elem: '#demo'
            , height: 'full-251'
            , cellMinWidth: 120
            , url: 'getDev' //数据接口
            , page: true //开启分页
            , cols: [[ //表头
                {type: 'numbers', title: '序号', fixed: 'left', event: 'row'}
                , {field: 'id', title: 'ID', style: 'display:none', width: 1, event: 'row'}
                , {field: 'school', title: '校区', event: 'row'}
                , {field: 'house', title: '楼栋', event: 'row'}
                , {field: 'floor', title: '楼层', event: 'row'}
                , {field: 'room', title: '房号', event: 'row'}
                , {field: 'devId', title: '设备ID', event: 'row'}
                , {field: 'devSN', title: '设备SN', event: 'row', style: 'display:none', width: 1, event: 'row'}
                , {field: 'devName', title: '设备名称', event: 'row'}
                , {field: 'devStatus', title: '状态', event: 'row'}
                , {fixed: 'right', title: '操作', toolbar: '#barDemo', width: 150}
            ]]
            , done: function (res, curr, count) {
                $('[data-field="id"]').addClass('layui-hide');
                $('[data-field="devSN"]').addClass('layui-hide');
            }
            , limit: 15
            , limits: [15, 20, 30, 50]
            , where: {
                devType: '2'
            }
        });

        //监听行工具事件
        table.on('tool(test)', function(obj){
            var data = obj.data;
            if(obj.event === 'edit'){
                layer.open({
                    type: 2,
                    title: false,
                    area: ['1000px', '300px'],
                    shade: 0.8,
                    closeBtn: 0,
                    shadeClose: true,
                    content: 'airConditionLineStatus'
                    ,success: function(layero, index) {
                        layer.iframeAuto(index);
                        var childWindow = $(layero.find('iframe'))[0].contentWindow;
                        childWindow.init(data);

                    },yes:function (index, layero) {
                        var childWindow = $(layero.find('iframe'))[0].contentWindow;

                    }
                });
              }
           });
    });

    var list = [];
    list.push($('.my-xq-add-ctrl'));
    list.push($('.my-xq-add-area'));
    list.push($('.my-xq-modify-ctrl'));
    list.push($('.my-xq-modify-area'));

    $('[type="reset"]').click(function () {
        //alert(111);
        $(this).closest('.ddd').addClass('layui-hide');
    });

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
                    devType:"2"
                } //设定异步数据接口的额外参数
                ,page: {
                    curr: 1 //重新从第 1 页开始
                }
            });
        }
    });

    function show(dom){
        list.forEach(function (value, index) {
            if(value[0] == dom[0]){
                value.removeClass('layui-hide');
            }else{
                value.addClass('layui-hide');
            }
        })
    }

    //检测有无根节点,无根节点则默认添加根节点
    function checkRoot (){
        var root = $('#tt').tree('getRoot');
        if(root == null){
            var data = {};
            data.id = MyUtil.getUUid();
            data.pId = 0;
            data.text = '根节点';
            data.iconCls = 'my-tree-icon-1';
            $.post('addTree',data,function (res) {
                $('#tt').tree('append', {
                    parent: null,
                    data: [{
                        id: data.id,
                        text: data.text
                        ,iconCls:data.iconCls
                        ,pId:data.pId
                    }]
                });
            });
            return true;
        }
        return false;
    }

    layui.use(['tree','element'], function(){
        var tree = layui.tree
            ,element = layui.element;
    });
</script>

</html>