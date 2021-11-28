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

        .layui-form-select dl{
            max-height: 100px;
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
        /*条件查询-下拉框*/
        .layui-form-select{
            width: 182px;
        }
        .layui-select-title input{
            height: 38px;
            width: 182px;
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
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 150px center transparent;
        }
        /*点击后的下拉框箭头图片*/
        .layui-form-selected  .layui-select-title input{
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 150px center transparent;
        }
    </style>

    <style>
        .layui-form-select-up dl { max-height:250px; }
    </style>
    <title>修改空开设备</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <%--<jsp:include page="header/res.jsp"></jsp:include>--%>
</head>
<body class="layui-layout-body">

<%--div class="div-title" style="margin-top: 5px;">
    <h1 style="font-family: 'Microsoft Ya Hei'; font-size: 18px; color: #2c394a;margin-left: 5px">修改设备</h1>
</div>
<div class="div-btn-close">
    <button style="margin-top: 5px;border-width: 0;background-color: white;margin-right: 5px;" onclick="closeFrame()">
        <img src="../../res/layui/images/dev_icon/close_icon.png">
    </button>
</div>--%>

<div  style="width:90%;text-align: center; margin: 0px auto">
    <form id="form1" method="POST" class="layui-form" action="server/HelloServlet" >

        <div id="divMain" class="divLineBlock divMainCss">
                <div class="layui-form-item">
                    <label class="layui-form-label" style="white-space:nowrap; text-align:right">空开通讯地址:</label>
                    <div class="layui-input-block">
                        <input type="text" id="uuid" name="uuid"  autocomplete="off" class="layui-input" readonly="readonly" style="background: #7F9DB9">
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label" style="white-space:nowrap;text-align: right" >数据上报间隔:</label>
                    <div class="layui-input-block">
                        <input type="text"  id="intervaltime" name="intervaltime" lay-verify="required|phone" autocomplete="off" class="layui-input" >
                        <span style=" position: absolute; top: 8%; right: 6%; display: table-cell;/*background-color: #0d8ddb*/;white-space: nowrap; padding: 7px 10px;">s</span>
                    </div>
                </div>
                <div class="layui-form-item">
                    <label class="layui-form-label" style="white-space:nowrap;text-align:right">空开线路数量:</label>
                    <div class="layui-input-block">
                        <select  id="chncnt" name="chncnt" <%--lay-verify="required" lay-filter="lora" lay-search="" class="select"--%>>
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
                        </select>
                    </div>
                </div>

        </div>
    </form>

</div>


</body>

<script type="text/javascript">

    function closeFrame(){
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        parent.layer.close(index);
    }

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
                        //console.log("查询到的item.devSN:"+item.devSN);
                        $('#loraSN').append(new Option(item.devSN));//往下拉菜单里添加元素
                    })
                    layui.form.render("select");
                }, error: function () {
                    alert("查询失败！！！")

                }

            })
        });
    });

</script>

</html>