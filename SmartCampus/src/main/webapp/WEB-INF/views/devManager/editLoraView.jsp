<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 2020-06-24
  Time: 9:49
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        .layui-form {
            white-space: nowrap;
        }
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
            width: 120px;
            padding: 0;
        }
        .layui-form-item .layui-input-inline {
            margin-left: 130px;
        }

    </style>
</head>
<body style="padding: 15px;">
<form id="form" class="layui-form" >
    <div class="layui-form-item">
        <%--<button id="setAllSwitch" class="layui-btn">设置空开设备</button>--%>
        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <label class="layui-form-label" style="white-space:nowrap;text-align:right">校区:</label>
            <div class="layui-input-inline">
                <select id="school" name="schoolId" lay-filter="selectSchool" title="校区选择" >
                    <%--                        <option value="">校区选择</option>--%>
                    <c:forEach items="${schoolList}" var="item">
                        <option value="${item.id}" <c:if test="${item.id==organizeList[0].schoolId}"> selected="selected" </c:if>>${item.text}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <label class="layui-form-label" style="white-space:nowrap;text-align:right">楼栋:</label>
            <div class="layui-input-inline">
                <select  id="house" name="houseId" <%--lay-verify="required"--%> lay-filter="selectHouse" <%--lay-search="" class="select"--%>>
                    <c:forEach items="${houseList}" var="item">
                        <option value="${item.id}" <c:if test="${item.id==organizeList[0].houseId}"> selected="selected" </c:if>>${item.text}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <label class="layui-form-label" style="white-space:nowrap;text-align:right">楼层:</label>
            <div class="layui-input-inline">
                <select  id="floor" name="floorId" <%--lay-verify="required"--%> lay-filter="selectFloor" <%--lay-search="" class="select"--%>>
                    <c:forEach items="${floorList}" var="item">
                        <option value="${item.id}" <c:if test="${item.id==organizeList[0].floorId}"> selected="selected" </c:if>>${item.text}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <label class="layui-form-label" style="width: 110px;/* text-align:left*/">LORA序列号:</label>
            <div class="layui-input-inline">
                <input type="text" id="loraSN" name="loraSN"  autocomplete="off" class="layui-input" readonly="readonly"style="background: lightsteelblue">
            </div>
        </div>
        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <label class="layui-form-label" style="width: 110px;/* text-align:left*/">空开组数量:</label>
            <div class="layui-input-inline">
                <input type="text" id="switchGroupNum" name="switchGroupNum"  autocomplete="off" class="layui-input" readonly="readonly"style="background: lightsteelblue">
            </div>
        </div>
        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <label class="layui-form-label" style="white-space:nowrap;width: 110px;/* text-align:right*/">MAC地址:</label>
            <div class="layui-input-inline">
                <input type="text" id="macAddress" name="macAddress"  autocomplete="off" class="layui-input" readonly="readonly"style="background: lightsteelblue">
            </div>
        </div>
        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <label class="layui-form-label" style="white-space:nowrap; width: 110px;/*text-align:right*/">端口号:</label>
            <div class="layui-input-inline">
                <input type="text" id="port" name="port"  autocomplete="off" class="layui-input" readonly="readonly"style="background: lightsteelblue">
            </div>
        </div>
        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <label class="layui-form-label" style="width: 110px; padding-left: 0px;/*text-align:left*/">LORA固件版本:</label>
            <div class="layui-input-inline" >
                <input type="text" id="fwVer" name="fwVer"  autocomplete="off" class="layui-input" readonly="readonly"style="background: lightsteelblue;">
            </div>
        </div>
        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <label class="layui-form-label" style="width:110px; padding-left: 0px;/*text-align:left*/">SUB1G接口数量:</label>
            <div class="layui-input-inline">
                <input type="text" id="sub1gNum" name="sub1gNum"  autocomplete="off" class="layui-input" readonly="readonly"style="background: lightsteelblue">
            </div>
        </div>
    </div>
    </div>
</form>

<table id="test" lay-filter="test"></table>

</body>

<script>
    var table;
    $(function () {
        var list = '${switchDevinfo}' ;
        console.log("list"+list);
    });

    function closeFrame(){
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        parent.layer.close(index);
    }
    //重载表格  刷新表格数据
    function reloadTb(){
        table.reload('test');
    }

</script>
<script>
    var form ;
    layui.use('form', function(){
        form = layui.form;

        $(function () {
            //监听下拉框选中事件
            var school;
            var house;
            var floor;
            var room;
            form.on('select(selectSchool)', function (data) {
                var select = $(data.elem);
                var id =select.val();
                if(id==0){
                    $('[name="houseId"]').html('<option value="0">无</option>');
                    $('[name="floorId"]').html('<option value="0">无</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        $('[name="houseId"]').html('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="houseId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="floorId"]').html('<option value="0">无</option>');
                        // $('[name="room"]').html('<option value="0">无</option>');
                        form.render('select');
                    })
                }
                school = data.elem[data.elem.selectedIndex].text
                console.log("school : " + school)

            });
            form.on('select(selectHouse)', function (data) {

                var select = $(data.elem);
                var id =select.val();
                if(id==0){
                    $('[name="floorId"]').html('<option value="0">无</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="floorId"]').html('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="floorId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="room"]').html('<option value="0">无</option>');
                        form.render('select');
                    })
                }
                house = data.elem[data.elem.selectedIndex].text
                console.log("house : " + house)

            });
            form.on('select(selectFloor)', function (data) {

                // var select = $(data.elem);
                // $.post('getChildrenOrganize',{id:select.val()},function (res) {
                //     console.log(res);
                //     $('[name="room"]').html('<option value="0">无</option>');
                //     res.forEach(function (value,index) {
                //         $('[name="room"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                //     });
                //     form.render('select');
                // })


                floor = data.elem[data.elem.selectedIndex].text
                console.log("floor : " + floor)

            });
            // form.on('select(selectRoom)', function (data) {
            //
            //     room = data.elem[data.elem.selectedIndex].text
            //     console.log("room : " + room)
            //
            // });
        });
    });

</script>
</html>
