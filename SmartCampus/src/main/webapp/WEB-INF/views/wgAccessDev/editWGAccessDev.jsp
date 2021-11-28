<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 2020-07-18
  Time: 13:34
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
            width: 100px;
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
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 190px center transparent;
        }
        /*点击后的下拉框箭头图片*/
        .layui-form-selected  .layui-select-title input{
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 190px center transparent;
        }
    </style>
</head>
<body style="padding: 15px;">
<form id="form" class="layui-form" >
        <div class="layui-form-item">
            <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
                <label class="layui-form-label" style="width: 110px; padding-left: 0px;text-align:left">校区选择</label>
                <div class="layui-input-block">
                    <select id="school" name="schoolId" lay-filter="selectSchool" title="校区选择" >
                        <%--<option value="无">无</option>--%>
                        <c:forEach items="${schoolList}" var="item">
                            <option value="${item.id}" <c:if test="${item.id==organizeList[0].schoolId}"> selected="selected" </c:if>>${item.text}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
                <label class="layui-form-label" style="width: 110px; padding-left: 0px;text-align:left">楼栋选择</label>
                <div class="layui-input-block">
                    <select  id="house" name="houseId" lay-verify="required" lay-filter="selectHouse" <%--lay-search="" class="select"--%>>
                        <c:forEach items="${houseList}" var="item">
                            <option value="${item.id}" <c:if test="${item.id==organizeList[0].houseId}"> selected="selected" </c:if>>${item.text}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
                <label class="layui-form-label" style="width: 110px; padding-left: 0px;text-align:left">楼层选择</label>
                <div class="layui-input-block">
                    <select  id="floor" name="floorId" lay-verify="required" lay-filter="selectFloor" <%--lay-search="" class="select"--%>>
                        <c:forEach items="${floorList}" var="item">
                            <option value="${item.id}" <c:if test="${item.id==organizeList[0].floorId}"> selected="selected" </c:if>>${item.text}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
                    <label class="layui-form-label" style="width: 110px; padding-left: 0px;text-align:left">房间选择</label>
                    <div class="layui-input-block">
                        <select  id="room" name="roomId" lay-verify="required" lay-filter="selectRoom"<%-- lay-search="" class="select"--%>>
                            <c:forEach items="${roomList}" var="item">
                                <option value="${item.id}" <c:if test="${item.id==organizeList[0].roomId}"> selected="selected" </c:if>>${item.text}</option>
                            </c:forEach>
                        </select>
                    </div>
            </div>
            <%--<div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
                <label class="layui-form-label" style="width: 110px; padding-left: 0px;text-align:left">控制器名称</label>
                <div class="layui-input-block">
                    <input type="text" id="devName" name="devName"  autocomplete="off" class="layui-input">
                </div>
            </div>--%>
            <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
                <label class="layui-form-label" style="width: 110px; padding-left: 0px;text-align:left">普通门禁SN</label>
                <div class="layui-input-block">
                    <input type="text" id="ctrlerSN" name="ctrlerSN"  autocomplete="off" class="layui-input" readonly="readonly"style="background: lightsteelblue">
                </div>
            </div>

            <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
                <label class="layui-form-label" style="width: 110px; padding-left: 0px;text-align:left">普通门禁IP</label>
                <div class="layui-input-block">
                    <input type="text" id="ip" name="ip"  autocomplete="off" class="layui-input" readonly="readonly"style="background: lightsteelblue">
                </div>
            </div>
            <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
                <label class="layui-form-label" style="width: 110px; padding-left: 0px;text-align:left">子网掩码</label>
                <div class="layui-input-block">
                    <input type="text" id="netmask" name="netmask"  autocomplete="off" class="layui-input" readonly="readonly"style="background: lightsteelblue">
                </div>
            </div>
            <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
                <label class="layui-form-label" style="width: 110px; padding-left: 0px;text-align:left">默认网关</label>
                <div class="layui-input-block">
                    <input type="text" id="defaultGateway" name="defaultGateway"  autocomplete="off" class="layui-input" readonly="readonly"style="background: lightsteelblue">
                </div>
            </div>
            <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
                <label class="layui-form-label" style="width: 110px; padding-left: 0px;text-align:left">MAC地址</label>
                <div class="layui-input-block" >
                    <input type="text" id="macAddress" name="macAddress"  autocomplete="off" class="layui-input" readonly="readonly"style="background: lightsteelblue;">
                </div>
            </div>
            <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
                <label class="layui-form-label" style="width:110px; padding-left: 0px;text-align:left">端口号</label>
                <div class="layui-input-block">
                    <input type="text" id="port" name="port"  autocomplete="off" class="layui-input" readonly="readonly"style="background: lightsteelblue">
                </div>
            </div>
            <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
                <label class="layui-form-label" style="width:110px; padding-left: 0px;text-align:left">版本号</label>
                <div class="layui-input-block">
                    <input type="text" id="driverVerID" name="driverVerID"  autocomplete="off" class="layui-input" readonly="readonly"style="background: lightsteelblue">
                </div>
            </div>
            <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
                <label class="layui-form-label" style="width:110px; padding-left: 0px;text-align:left">版本日期</label>
                <div class="layui-input-block">
                    <input type="text" id="verDate" name="verDate"  autocomplete="off" class="layui-input" readonly="readonly"style="background: lightsteelblue">
                </div>
            </div>
        </div>
    </form>
</body>

<script>

    $('#school').attr('value','无');
    $(".selector").val("无");
    $(".selector").find("option:contains('无')").attr("selected",true);


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
                /*$("#school").find("option:selected").text();*/
                // if(select.val()==0) {
                //     $('[name="houseId"]').html('<option value="无">无</option>');
                //     $('[name="floorId"]').html('<option value="无">无</option>');
                //     $('[name="roomId"]').html('<option value="无">无</option>');
                //     form.render('select');
                //     school = data.elem[data.elem.selectedIndex].value;
                // }else {
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="houseId"]').html('<option value="">楼栋选择</option>');
                        res.forEach(function (value,index) {
                            $('[name="houseId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="floorId"]').html('<option value="">楼层选择</option>');
                        $('[name="roomId"]').html('<option value="">房号选择</option>');
                        form.render('select');
                    })
                    school = data.elem[data.elem.selectedIndex].text
                // }

                console.log("school : " + school)

            });
            form.on('select(selectHouse)', function (data) {

                var select = $(data.elem);
                $.post('getChildrenOrganize',{id:select.val()},function (res) {
                    console.log(res);
                    $('[name="floorId"]').html('<option value="">楼层选择</option>');
                    res.forEach(function (value,index) {
                        $('[name="floorId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                    });
                    $('[name="roomId"]').html('<option value="">房号选择</option>');
                    form.render('select');
                })

                house = data.elem[data.elem.selectedIndex].text
                console.log("house : " + house)

            });
            form.on('select(selectFloor)', function (data) {

                var select = $(data.elem);
                $.post('getChildrenOrganize',{id:select.val()},function (res) {
                    console.log(res);
                    $('[name="roomId"]').html('<option value="">房号选择</option>');
                    res.forEach(function (value,index) {
                        $('[name="roomId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                    });
                    form.render('select');
                })


                floor = data.elem[data.elem.selectedIndex].text
                console.log("floor : " + floor)

            });
            form.on('select(selectRoom)', function (data) {
                room = data.elem[data.elem.selectedIndex].text
                console.log("room : " + room)
            });
        });
    });

</script>
</html>
