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
        </div>
        <div class="my-tree-body-div" style="bottom: 15px;margin-left: 25px;margin-top: 4px;padding:15px;">
            <fieldset class="layui-elem-field layui-field-title">
                <legend style="font-size: 16px;">使用时长</legend>
            </fieldset>
            <div id="main" class="layui-row" style="border:1px solid #999;height:700px;">空调使用率</div>
<%--            <table id="demo" lay-filter="test"></table>--%>
        </div>

    </div>
</body>

<!-- 引入 echarts.js -->
<script src="https://cdn.staticfile.org/echarts/4.3.0/echarts.min.js"></script>

<script>
    $(function () {
        leftThis("使用时长");
        console.log('comOpen','<%=bComOpen%>');
    });

    //注意：导航 依赖 element 模块，否则无法进行功能性操作
    layui.use('element', function(){
        var element = layui.element;
    });

    //指定图标的配置和数据
    var dom = document.getElementById("main");
    var myChart = echarts.init(dom);
    var app = {};
    option = null;
    option = {
        title: {
            text: '空调使用时长'
        },
        tooltip: {},
        legend: {
            data: ['用户来源']
        },
        xAxis: {
            data: ["0", "2", "4", "6", "8", "10", "12", "14", "16", "18", "20", "22", "24"]
        },
        yAxis: {
            data: ["0", "0.5", "1", "1.5", "2", "2.5"]
        },
        series: [{
            name: '访问量',
            type: 'line',
            data: [0.5, 0.8, 1, 2, 2.5, 0.5, 0.8, 1, 2, 2.5, 0, 1.7, 2.5]
        }]
    };

    //初始化echarts实例
    var myChart = echarts.init(document.getElementById('main'));

    //使用制定的配置项和数据显示图表
    myChart.setOption(option);

    var list = [];
    list.push($('.my-xq-add-ctrl'));
    list.push($('.my-xq-add-area'));
    list.push($('.my-xq-modify-ctrl'));
    list.push($('.my-xq-modify-area'));

    $(function () {
        leftThis("区域信息");
        // list.forEach(function (value, index) {
        //     value.removeClass('layui-hide');
        // })
    });

    $('[type="reset"]').click(function () {
        //alert(111);
        $(this).closest('.ddd').addClass('layui-hide');
    });

    $('#tt').tree({
        url:'getTreeData?iconCls=1'
    });

    $('#tt').tree({
        onClick: function(node){
            //console.log(node);
            $('strong').text(node.text);
            $('[name="inputName"]').val(node.text);

            if(node.iconCls == "my-tree-icon-1"){
                show($('.my-xq-modify-ctrl'));
            }else{
                show($('.my-xq-modify-area'));
            }
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