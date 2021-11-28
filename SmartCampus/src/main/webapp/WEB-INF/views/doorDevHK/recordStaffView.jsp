<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <!-- layui -->
    <jsp:include page="../header/res.jsp"></jsp:include>
    <%--<jsp:include page="../header/res.jsp"></jsp:include>--%>
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
        .layui-form-item{
            height: 38px;
            margin-bottom: 5px;
        }
        /*修改label内边距*/
        .layui-form-pane .layui-form-label {
            padding: 8px 10px;
            text-align: left;
        }
    </style>
</head>
<body style="height: 340px;margin-right: 20px" >

<form class="layui-form layui-form-pane" name="form1" action="">

<%--    <div style="float:right;margin-right: 20px;margin-top: 15px;">--%>

<%--        <input type="text" id="photo" name="photo" style="display:none">--%>
<%--        <div class="layui-upload-list" style="width: 2.5cm;height: 3.5cm;border: 1px solid #f0f0f0;overflow: hidden;position: relative;">--%>
<%--            <p id="demoText"></p>--%>
<%--            <img class="layui-upload-img" id="imageId" style="width: 2.5cm;height: 3.5cm;" src="${list[0].imagePath}">--%>
<%--        </div>--%>
<%--    </div>--%>


    <div style="margin-left:15px; margin-top:15px ; /*display: inline-block ;*//*width: 710px*/">
        <%--    <fieldset class="layui-elem-field layui-field-title">--%>
        <%--        <legend>查看人员信息</legend>--%>
        <%--    </fieldset>--%>

        <c:forEach var="list" items="${list}" varStatus="row">
            <div class="layui-form-item"style="float: left;">
                <label class="layui-form-label">设备校区:</label>
                <div class="layui-input-inline">
                    <input type="text" name="schoolName" id="schoolName" placeholder="校区选择" autocomplete="off"
                           class="layui-input" readonly="readonly" value="${list.schoolName}">
                </div>
            </div>
            <div style="float: right">
                <label class="layui-form-label">设备楼栋:</label>
                <div class="layui-input-inline">
                    <input type="text" name="houseName" id="houseName" placeholder="楼栋选择" autocomplete="off"
                           class="layui-input" readonly="readonly" value="${list.houseName}">
                </div>
            </div>
            <div class="layui-form-item"style="float: left;">
                <label class="layui-form-label">设备楼层:</label>
                <div class="layui-input-inline">
                    <input type="text" name="floorName" id="floorName" placeholder="楼层选择" autocomplete="off"
                           class="layui-input" readonly="readonly" value="${list.floorName}">
                </div>
            </div>
            <div style="float: right">
                <label class="layui-form-label">设备房号:</label>
                <div class="layui-input-inline">
                    <input type="text" name="roomName" id="roomName" placeholder="房号选择" autocomplete="off"
                           class="layui-input" readonly="readonly" value="${list.roomName}">
                </div>
            </div>
            <div class="layui-form-item" style="float: left">
                <label class="layui-form-label">工 号:</label>
                <div class="layui-input-inline">
                    <input type="text" name="staffId" lay-verify="required" value="${list.staffId}" utocomplete=""
                           class="layui-input" readonly="readonly">
                </div>
            </div>

            <div style="float: right">
                <label class="layui-form-label">人员类型:</label>
                <div class="layui-input-inline">
                    <input type="text" name="personTypeName" lay-verify="required" value = "${list.personTypeName}" placeholder="" autocomplete="off"
                           class="layui-input" readonly="readonly">
                </div>
            </div>

            <div class="layui-form-item" style="float: left">
                <label class="layui-form-label">姓 名:</label>
                <div class="layui-input-inline">
                    <input type="text" name="name" lay-verify="required" value = "${list.staffName}" placeholder="" autocomplete="off"
                           class="layui-input" readonly="readonly">
                </div>
            </div>
<%--            <input value="${list.dname}">--%>
            <div style="float: right">
                <label class="layui-form-label">刷卡时间:</label>
                <div class="layui-input-inline">
                    <input type="text" name="alarmTime" id="alarmTime" lay-verify="required" value="${list.strAlarmTime}" placeholder="" utocomplete="off"
                           class="layui-input" readonly="readonly">
                </div>
            </div>
            <div class="layui-form-item" style="float: left">
                <label class="layui-form-label">卡 号:</label>
                <div class="layui-input-inline">
                    <input type="text" name="cardNo" lay-verify="required" value = "${list.cardNo}" placeholder="" autocomplete="off"
                           class="layui-input" readonly="readonly">
                </div>
            </div>
            <div style="float: right">
                <label class="layui-form-label">设备IP:</label>
                <div class="layui-input-inline">
                    <input type="text" name="devIP" id="devIP" lay-verify="required" value="${list.devIP}" placeholder="" utocomplete="off"
                           class="layui-input" readonly="readonly">
                </div>
            </div>
            <div class="layui-form-item" style="float: left">
                <label class="layui-form-label">性 别:</label>
                <div class="layui-input-inline">
                    <input type="text" name="sex" lay-verify="required" value = "${list.sex}" placeholder="" autocomplete="off"
                           class="layui-input" readonly="readonly">
                </div>
            </div>

            <div style="float:right;height: 10px;width: 291px">

                    <%--<input type="text" id="photo" name="photo" value="photo">--%>
                <div class="layui-upload-list" style="margin: 0px;overflow: hidden;position: relative;">
                    <p id="demoText"></p>
                    <img class="layui-upload-img" id="imageId" style="width: 122px;" src="${list.imagePath}">
                </div>
            </div>

            <div class="layui-form-item" style="float: left">
                <label class="layui-form-label">出生日期:</label>
                <div class="layui-input-inline">
                    <input type="text" name="birth" lay-verify="required" value = "${list.birth}" placeholder="" autocomplete="off"
                           class="layui-input" readonly="readonly">
                </div>
            </div>


            <div class="layui-form-item" style="float: left;clear:both;">
                <label class="layui-form-label">联系方式:</label>
                <div class="layui-input-inline">
                    <input type="text" name="telphone" value = "${list.telphone}" lay-verify="required" placeholder=""
                           autocomplete="off"
                           class="layui-input" readonly="readonly">
                </div>
            </div>



            <div class="layui-form-item" style="float: left;clear:both;">
                <label class="layui-form-label">邮 箱:</label>
                <div class="layui-input-inline">
                    <input type="text" name="email" id="email" value="${list.email}" lay-verify="required" placeholder="" utocomplete="off"
                           class="layui-input" readonly="readonly">
                </div>
            </div>
            <div class="layui-form-item" style="float: left">
                <label class="layui-form-label">Q Q:</label>
                <div class="layui-input-inline">
                    <input type="text" name="qq" id="qq" lay-verify="required" value="${list.qq}" placeholder="" utocomplete="off"
                           class="layui-input" readonly="readonly">
                </div>
            </div>



            <%--        <div class="layui-form-item">--%>
            <%--            <label class="layui-form-label">职务</label>--%>
            <%--            <div class="layui-input-inline">--%>
            <%--                <input type="text" name="positionId" lay-verify="required" value = "" placeholder="修改职务" autocomplete="off"--%>
            <%--                       class="layui-input" readonly="readonly">--%>
            <%--            </div>--%>
            <%--        </div>--%>







        </c:forEach>






    </div>
</form>
<%--<div class="div-title">--%>
<%--    <h1>详情</h1>--%>
<%--</div>--%>
<%--<div class="div-btn-close">--%>
<%--    <button style="width: 30px;height: 30px" onclick="closeFrame()">X</button>--%>
<%--</div>--%>
<%--<table id="test" lay-filter="test"></table>--%>
</body>

<script>
    var table;
    $(function () {
        var list = '${list}' ;
    });

    function closeFrame(){
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        parent.layer.close(index);
    }

    layui.use('table', function() {
        table = layui.table;
        //表格渲染
        <%--table.render({--%>
        <%--    elem: '#test'--%>
        <%--    ,id:'test'--%>
        <%--    , title: '详情'--%>
        <%--    , height: 'full-100'--%>

        <%--    , cols: [[--%>
        <%--        {field: 'staffId', title: '编号', width: '100',align: 'center'}--%>
        <%--        , {field: 'name', title: '姓名', width: '100'}--%>
        <%--        , {field: 'cardNo', title: '卡号', width: '200'}--%>
        <%--        , {field: 'imagePath', title: '抓拍图片', width: '100',align: 'center',templet:'#img',event:'previewImg'}--%>

        <%--        , {field: 'alarmTime', title: '刷卡时间', width: '200',align: 'center'}--%>
        <%--        , {field: 'devIP', title: '设备IP', width: '150',align: 'center'}--%>
        <%--        , {field: 'dName', title: '所属部门', width: '100',align: 'center'}--%>

        <%--        , {field: 'sex', title: '性别', width: '100'}--%>
        <%--        , {field: 'birth', title: '生日', width: '150'}--%>
        <%--        , {field: 'telphone', title: '联系方式', width: '200'}--%>
        <%--        , {field: 'qq', title: 'QQ', width: '200'}--%>
        <%--        , {field: 'email', title: '邮箱', width: '200'}--%>



        <%--    ]]--%>
        <%--    ,data:${list}--%>
        <%--    ,done: function(res, curr, count){--%>
        <%--        // $('[data-field="id"]').addClass('layui-hide');--%>
        <%--        $('.layui-form-checkbox').css('margin-top','5px');--%>
        <%--    }--%>
        <%--    ,page:true--%>
        <%--    ,limits:[10,15]--%>
        <%--    ,limit:10--%>
        <%--});--%>
        table.on('tool(test)', function (obj) {
            var data = obj.data;
            if(obj.event === "previewImg"){
                layer.open({
                    type: 1,
                    title: false,
                    area: ['auto'],
                    closeBtn:0,
                    skin:'layui-layer-nobg',//没有背景色
                    shadeClose:true,
                    content:'<img src = "'+data.imagePath+'">'
                });
            }
        })
    })


</script>
<script type="text/html" id="img">
    <div><img src="{{d.imagePath}}" style="width:30px;height:30px"></div>
</script>
</html>
