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
    <title>能耗统计</title>
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

        <div class="my-tree-body-div" style="bottom: 15px;margin-left: 25px;margin-top: 4px;padding:15px;overflow-y: hidden;">
            <div>
<%--                <fieldset class="layui-elem-field layui-field-title">--%>
<%--                <legend style="font-size: 16px;">设备列表</legend>--%>
<%--                </fieldset>--%>

                <div class="layui-card">
                    <div id="pie_echarts" class="layui-card-body" style="width: 100%;height:170%;">
                    </div>
                </div>

                <table id="demo" lay-filter="test"></table>
            </div>
        </div>

    </div>
</body>

<!-- 引入 echarts.js -->
<script src="https://cdn.staticfile.org/echarts/4.3.0/echarts.min.js"></script>

<script>

    layui.use('laydate', function(){
        var laydate = layui.laydate;

        //执行一个laydate实例
        laydate.render({
            elem: '#startTime' //指定元素
        });
    });

    //注意：导航 依赖 element 模块，否则无法进行功能性操作
    layui.use('element', function(){
        var element = layui.element;
    });

$(function () {
        leftThis("能耗统计");
        console.log('comOpen','<%=bComOpen%>');
    });


    var table;

    //重载表格数据
    function reloadTB(){
        table.reload('demo');
    }

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

    // 基于准备好的dom，初始化echarts实例
    var myChart = echarts.init(document.getElementById('pie_echarts'));
    // 指定图表的配置项和数据
    option = {
        title: {
            text: '耗能分布',
            x: 'left'
        },
        tooltip: {
            trigger: 'item',
            formatter: "{a} <br/>{b} : {c} ({d}%)"
        },
        color: ['#CD5C5C', '#00CED1', '#9ACD32', '#FFC0CB'],
        stillShowZeroSum: false,
        series: [
            {
                name: '耗能',
                type: 'pie',
                radius: '40%',
                center: ['40%', '30%'],
                data: [
                    {value: 1, name: '空调设备'},
                    {value: 3, name: '空开设备'},
                    {value: 7, name: '多媒体设备'},
                    {value: 4, name: '其他设备'},
                ],
                itemStyle: {
                    emphasis: {
                        shadowBlur: 10,
                        shadowOffsetX: 0,
                        shadowColor: 'rgba(128, 128, 128, 0.5)'
                    }
                }
            }
        ]
    };
    // 使用刚指定的配置项和数据显示图表。
    myChart.setOption(option);

</script>

</html>