<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <!-- layui -->
    <link rel="stylesheet" type="text/css" href="/res/layui/css/layui.css">
    <script type="text/javascript" src="/res/layui/layui.js"></script>
    <script src="res/js/jquery.min.js"></script>
    <script src="res/js/myjs.js" ></script>

    <style>
        .layui-input{margin: 20px 0px;}
        .divLineBlock{display: inline-block;vertical-align: top}
        .divMainCss{margin-left: -50px;margin-right: 20px}
        .divCaptureCss{margin-top: 20px;}
    </style>

    <style>
        .layui-form-select dl { max-height:250px; }
    </style>
    <title>修改空开设备</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <%--<jsp:include page="header/res.jsp"></jsp:include>--%>
</head>
<body class="layui-layout-body">
<div  style="width:90%;text-align: center; margin: 0px auto">
    <form id="form1" method="POST" class="layui-form" action="server/HelloServlet" >

        <div id="divMain" class="divLineBlock divMainCss">
            <%--<div class="layui-form-item" style="width: auto">
                <label class="layui-form-label" style="text-align: right" >Lora网关:</label>
                <div class="layui-input-block" >
                    <select  id="loraSN" name="loraSN" lay-verify="required" lay-filter="lora" lay-search="" class="select"readonly="readonly"disabled="disabled">
                        <option value="" readonly="readonly"></option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label" style="text-align: right"> 空开组数量:</label>
                <div class="layui-input-block">
                    <input  id="switchGroupNum" name="switchGroupNum"  lay-filter="switchGroupNum" autocomplete="off" class="layui-input" readonly="readonly"  value="">
                </div>
            </div>--%>
                <div class="layui-form-item">
                    <label class="layui-form-label" style="white-space:nowrap;text-align:right">空开线路数量:</label>
                    <div class="layui-input-block">
                        <select  id="chncnt" name="chncnt" lay-verify="required" lay-filter="lora" lay-search="" class="select">
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                            <option value="5">5</option>
                            <option value="6" selected>6</option>
                            <option value="7">7</option>
                            <option value="8">8</option>
                            <option value="9">9</option>
                            <option value="10">10</option>
                            <option value="11">11</option>
                            <option value="12">12</option>
                        </select>
                    </div>
                </div>
            <div class="layui-form-item">
                <label class="layui-form-label" style="white-space:nowrap; text-align:right">空开通讯地址:</label>
                <div class="layui-input-block">
                    <input type="text" id="uuid" name="uuid"  autocomplete="off" class="layui-input" >
                </div>
            </div>
           <%-- <div class="layui-form-item">
                <label class="layui-form-label" style="text-align: right"> 设备类型:</label>
                <div class="layui-input-block">
                    <input type="text" id="sensortype" name="sensortype"  autocomplete="off" class="layui-input" value="12"readonly="readonly">
                </div>
            </div>--%>

            <div class="layui-form-item">
                <label class="layui-form-label" style="white-space:nowrap;text-align: right" >数据上报间隔:</label>
                <div class="layui-input-block">
                    <input type="text"  id="intervaltime" name="intervaltime" lay-verify="required|phone" autocomplete="off" class="layui-input" >
                    <span style=" position: absolute; top: 8%; right: 6%; display: table-cell;/*background-color: #0d8ddb*/;white-space: nowrap; padding: 7px 10px;">s</span>
                </div>
            </div>
            <%--<div class="layui-form-item">
                <label class="layui-form-label" style="white-space:nowrap;text-align:right">设备连接端口:</label>
                <div class="layui-input-block">
                    <input type="text" id="port" name="port"  autocomplete="off" value="0" class="layui-input" readonly="readonly">
                </div>
            </div>--%>

            <%--<div class="layui-form-item">
                <label class="layui-form-label" style="text-align: right"> 通道类型:</label>
                <div class="layui-input-block">
                    <input type="text" id="chntype" name="chntype"  autocomplete="off" class="layui-input" value="19" readonly="readonly">
                </div>
            </div>--%>
        </div>
    </form>



</div>


</body>

<script type="text/javascript">

    var form;


    layui.use(['form', 'layer', 'layedit'], function() {
        $ = layui.jquery;
        form = layui.form;
        var layer = layui.layer;
        var layedit = layui.layedit;
        $(function () {
            $.ajax({
                type: "POST",
                url: 'getswitchDevLoraSN',  //从数据库查询返回的是个list
                dataType: "json",
                //contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                // async: false,
                // cache: false,
                success: function (data) {
                    $.each(data, function (index, item) {
                        console.log("查询到的item.devSN:"+item.devSN);
                        $('#loraSN').append(new Option(item.devSN));//往下拉菜单里添加元素
                    })
                    layui.form.render("select");
                }, error: function () {
                    alert("查询失败！！！")

                }

            })
/*
            //监听下拉框选中事件
            form.on('select(lora)', function (data) {
                //$("#chncnt").val("");
                $("#switchGroupNum").val("");
                var devSN = $('#loraSN').val();
                //console.log("uuid : " + data.devId)
                $.post('getSwitchGroupNum',{devSN:devSN},function (res) {
                    $.each(res,function (index, item) {
                        console.log("item.SwitchGroupNum:"+ item.switchGroupNum);
                        //console.log("item.devSN:"+ );
                        console.log("data.value:"+ data.value);
                        $("#switchGroupNum").val(item.switchGroupNum)

                    });
                });
            });*/
        });
    });

    function initModifyView(data){
        console.log("<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>" +data);

        $('[name="loraSN"]').html('<option value="1">'+data.loraSN+'</option>');
        $('[name="loraSN"]').attr('disabled','');
        $('[name="switchGroupNum"]').attr('disabled','');
        $('[name="sensortype"]').attr('disabled','');
        $('[name="port"]').attr('disabled','');
        $('[name="chntype"]').attr('disabled','');
        form.render('select');
    }



</script>

</html>