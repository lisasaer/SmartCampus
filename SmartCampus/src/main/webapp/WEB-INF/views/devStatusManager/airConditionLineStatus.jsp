<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2019/11/30
  Time: 14:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        .div-title{
            display: inline-block;
            vertical-align: top;
        }
        .div-btn-close{
            float: right;
            vertical-align: top;
            display: inline-block;
            text-align: right
        }
        .div-query-btn{
            margin: 10px;
        }
        .layui-table-tool-self{
            display: none;
        }
    </style>
</head>
<body style="padding: 15px;">

    <div class="div-title">
        <h1>空调控制器信息</h1>
    </div>
    <div class="div-btn-close">
        <button style="width: 30px;height: 30px" onclick="closeFrame()">X</button>
    </div>

    <div class="layui-form">
        <table class="layui-table">
            <colgroup>
                <col width="150">
                <col width="150">
                <col width="200">
                <col>
            </colgroup>
            <thead>
            <tr>
                <th>设备ID</th>
                <th>温度</th>
                <th>湿度</th>
                <th>人体红外感应</th>
                <th>继电器开关状态</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>1</td>
                <td>20</td>
                <td>50</td>
                <td>有人</td>
                <td>已开启</td>
            </tr>
            </tbody>
        </table>
    </div>
</body>

<script>
    //启动
    $(function () {

    });

    function  init(data) {
        //设置devId
        $('td').eq(0).text(data.devId);

    }
    //关闭frame
    function closeFrame(){
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        parent.layer.close(index);
    }
    //刷新
    $('button').eq(1).click(function () {
        console.log('刷新');
    });
    //开启继电器
    $('button').eq(2).click(function () {
        console.log('开启继电器');
        var devId = $('td').eq(0).text();
        var data = MyUtil.getHexUpperString(devId)+"06014B0001";
        $.post('testduankou',{data:data},function (res) {
            console.log(res);
        })
    });
    //关闭继电器
    $('button').eq(3).click(function () {
        console.log('关闭继电器');
        var devId = $('td').eq(0).text();
        var data = MyUtil.getHexUpperString(devId)+"06014B0000";
        $.post('testduankou',{data:data},function (res) {
            console.log(res);
        })
    });
</script>

</html>
