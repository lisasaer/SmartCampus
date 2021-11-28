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
        .div-modify{
            position: absolute;
            top: 50%;
            left: 50%;
            width: 100%;
            height: 100%;
            transform: translate(-50%,-50%);
            padding: 30px;
            z-index: 9999;
            background-color: rgba(0,0,0,0.2);
        }
        .div-modify-view{
            border-radius: 10px;
            padding: 30px;
            opacity: 1;
            background-color: rgb(255,255,255);
            z-index: 99999;
            width: 50%;
            height:50%;
            position: relative;
            left: 50%;
            top: 50%;
            transform: translate(-50%,-50%);
        }
        .layui-form-label{
            width: 100px;
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
            width: 110px;
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
<body style="padding: 15px;">

    <div class="div-title" style="margin-top: 5px;">
        <h1 style="font-family: 'Microsoft Ya Hei'; font-size: 18px; color: #2c394a;margin-left: 5px">Lora网关在线搜索</h1>
    </div>
    <div class="div-btn-close">
        <button style="margin-top: 5px;border-width: 0;background-color: white;margin-right: 5px;" onclick="closeFrame()">
            <img src="../../res/layui/images/dev_icon/close_icon.png">
        </button>
    </div>
    <table id="test" lay-filter="test"></table>
    <%--<hr>
    <div class="layui-btn-container">
        <button class="layui-btn layui-hide" >刷新</button>
        <button class="layui-btn" >开启继电器</button>
        <button class="layui-btn" >关闭继电器</button>
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
    </div>--%>
</body>
<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
       <%-- <button class="layui-btn layui-hide" >刷新</button>--%>
        <button class="layui-btn" lay-event="openAir">开启继电器</button>
        <button class="layui-btn" lay-event="closeAir">关闭继电器</button>
    </div>
</script>
<script>
    //启动
    var table;
    $(function () {
        var list = '${airInfo}' ;
        console.log("airInfo---list"+list+"777777777777");
    });

    /*function  init(data) {
        //设置devId
        $('td').eq(0).text(data.devId);

    }*/
    //关闭frame
    function closeFrame(){
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        parent.layer.close(index);
    }
    //刷新
    /*$('button').eq(1).click(function () {
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
    });*/


    layui.use('table', function() {
        table = layui.table;
        //表格渲染
        table.render({
            elem: '#test'
            ,id:'test'
            , title: '空调数据表'
            , height: 'full-100'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            , cols: [[
                // {type: 'checkbox', fixed: 'left'}
                 {field: 'id', title: 'ID',style:'display:none',align : 'center'}
                , {field: 'room',   title: '房号', width:100,event:'row'}
                , {field: 'uuid', title: '空调通讯地址' , width:150,align : 'center',event:'row'}
                , {field: 'temperature', title: '温度(摄氏度)', width:130,align : 'center'}
                , {field: 'humidity', title: '湿度(%)', width:100,align : 'center'}
                , {field: 'infraredInduction', title: '人体红外感应',width : 140 ,align : 'center'}
                , {field: 'relayStatus', title: '继电器开关状态',width : 150 ,align : 'center'}
                , {field: 'recordTime', title: '开启/关闭继电器的时间',width : 200 , align : 'center'}
            ]]
            ,data:${airInfo}
            ,done: function(res, curr, count){
                $('[data-field="id"]').addClass('layui-hide');
                $('.layui-form-checkbox').css('margin-top','5px')
            }
            ,page:true
            ,limits:[10,15]
            ,limit:10
        });

        table.on('toolbar(test)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            var data = checkStatus.data;
            var ctrlData = {};
            ctrlData.devId = data[0].devId;
            ctrlData.dd = 100;
            switch(obj.event){
                case 'closeAir':
                    ctrlData.type = 'close';
                    $.post('ctrlAir',ctrlData,function (res) {
                        console.log("res: "+res);
                    });
                    break;
                case 'openAir':
                    ctrlData.type = 'open';
                    $.post('ctrlAir',ctrlData,function (res) {
                        console.log("res: "+res);
                    });
                    break;

            }
        })
    })
</script>

</html>
