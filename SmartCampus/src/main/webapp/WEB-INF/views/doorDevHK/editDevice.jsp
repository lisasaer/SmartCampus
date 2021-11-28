<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2019/11/30
  Time: 14:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>修改设备</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <%--<style>
        .layui-input{
            max-width: 192px;
        }
        .layui-form-item{
            height: 38px;
            margin-bottom: 5px;
        }
        /*下拉框最大高度*/
        .layui-form-select dl{
            max-height: 150px;
        }
        /*修改label内边距*/
        .layui-form-pane .layui-form-label {
            padding: 8px 10px;
            text-align: end;
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
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 157px center transparent;
        }
        /*点击后的下拉框箭头图片*/
        .layui-form-selected  .layui-select-title input{
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 157px center transparent;
        }
    </style>--%>

    <style>
        .layui-form{
            width: 90%;
            text-align: center;
            margin-top: 10px;
            margin-left: 20px;
        }
        .layui-form-label {
            float: left;
            display: block;
            padding: 9px 15px;
            width: 156px;
            font-weight: 400;
            line-height: 20px;
            text-align: right;
        }
    </style>

    <style>
        .layui-input{
            /*max-width: 194px;*/
            width: 194px;
            padding: 0px 0px 0px 10px;
        }                           /*控制手打输入框*/

        .layui-input-color{
            width: 194px;
            height: 38px;
            padding: 0px 0px 0px 10px;
            border-style: none;
            background-color: #CCCCCC;
        }
        .layui-input-block{
            /*text-align: center;*/
            width: 194px;
        }                          /*控制下拉框*/
        .layui-form-item{
            height: 38px;
            margin-bottom: 5px;
        }
        /*下拉框最大高度*/
        .layui-form-select dl{
            max-height: 120px;
        }
        /*修改label内边距*/
        .layui-form-pane .layui-form-label {
            border-style: none;
            width: 120px;
            height: 38px;
            text-align: left;
            /*padding: 8px 10px;
            text-align: end;*/
        }
        .layui-inline{
            margin-top: 3px;
        }

    </style>

</head>
<body>
<%--<div style="margin-left:15px; margin-top:15px ;display: inline-block ;/*max-width: 600px;*/">

    <form class="layui-form layui-form-pane" name="form1" action="">
        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">校园:</label>
            <div class="layui-input-inline">
                <select id="school" name="schoolId" lay-filter="selectSchool" title="校区选择" >
                    <c:forEach items="${schoolList}" var="item">
                        <option value="${item.id}" <c:if test="${item.id==deviceList[0].schoolId}"> selected="selected" </c:if>>${item.text}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label">楼栋:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <select id="house" name="houseId" lay-filter="selectHouse" title="楼栋选择">
                    <c:forEach items="${houseList}" var="item">
                        <option value="${item.id}" <c:if test="${item.id==deviceList[0].houseId}"> selected="selected" </c:if>>${item.text}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">楼层:</label>
            <div class="layui-input-inline">
                <select id="floor" name="floorId" lay-filter="selectFloor" title="楼层选择">

                    <c:forEach items="${floorList}" var="item">
                        <option value="${item.id}" <c:if test="${item.id==deviceList[0].floorId}"> selected="selected" </c:if>>${item.text}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label">房号:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <select id="room" name="roomId" lay-filter="selectRoom" title="房号选择">
                    <c:forEach items="${roomList}" var="item">
                        <option value="${item.id}" <c:if test="${item.id==deviceList[0].roomId}"> selected="selected" </c:if>>${item.text}</option>
                    </c:forEach>
                </select>
            </div>
        </div>

        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">人脸设备名称:</label>
            <div class="layui-input-inline">
                <input type="text" name="dname" lay-verify="required" value = "" placeholder="修改设备名称" autocomplete="off"
                       class="layui-input">
            </div>
        </div>

        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label">设备类型:</label>
            <div class="layui-input-inline" style="width: 190px;">

                <select id="selType" name="dtype" lay-filter="test">
                    <option value=""></option>
                    <option value="HIKVISION"  <c:if test="${'HIKVISION'==deviceList.get(0).dtype}"> selected="selected" </c:if>>HIKVISION</option>
                    <option value="UNIVIEM"  <c:if test="${'UNIVIEM'==deviceList.get(0).dtype}"> selected="selected" </c:if>>UNIVIEM</option>
                    <option value="DAHUA" <c:if test="${'DAHUA'==deviceList.get(0).dtype}"> selected="selected" </c:if>>DAHUA</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">设备IP:</label>
            <div class="layui-input-inline">
                <input type="text" name="dip" lay-verify="required" value = "" placeholder="修改设备IP" autocomplete="off"
                       class="layui-input" readonly="readonly" style="background-color: #d7d7d7">
            </div>
        </div>

        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label">子网掩码:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="dnetMask" lay-verify="required" value = "" placeholder="修改子网掩码" autocomplete="off"
                       class="layui-input" readonly="readonly" style="background-color: #d7d7d7">
            </div>
        </div>

        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">默认网关:</label>
            <div class="layui-input-inline">
                <input type="text" name="dgateWay" lay-verify="required" value = "" placeholder="修改网关" autocomplete="off"
                       class="layui-input" readonly="readonly" style="background-color: #d7d7d7">
            </div>
        </div>

        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label">端口号:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="port" lay-verify="required" placeholder="请输入端口" autocomplete="off"
                       class="layui-input" readonly="readonly" style="background-color: #d7d7d7">
            </div>
        </div>
        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">用户名:</label>
            <div class="layui-input-inline">
                <input type="text" name="duser" lay-verify="required" value = "" placeholder="修改用户名" autocomplete="off"
                       class="layui-input">
            </div>
        </div>

        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label">密码:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="dpassWord" value = "" lay-verify="required" placeholder="修改密码"
                       autocomplete="off"
                       class="layui-input">
            </div>
        </div>

        <div class="layui-form-item" hidden="hidden">
            <button class="layui-btn" lay-submit="" lay-filter="demo2" id="submitBtn">修改</button>
        </div>

    </form>
</div>--%>

<div class="">
    <div >
        <form class="layui-form layui-form-pane" name="form" action="">

            <div class="layui-inline" >
                <label class="layui-form-label">校&nbsp;&nbsp;区:</label>
                <div class="layui-input-inline">
                    <select  id="school" name="schoolId" lay-filter="selectSchool" title="校区选择" >
                        <c:forEach items="${schoolList}" var="item">
                            <option value="${item.id}" <c:if test="${item.id==deviceList[0].schoolId}"> selected="selected" </c:if>>${item.text}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">楼&nbsp;&nbsp;栋:</label>
                <div class="layui-input-inline">
                    <select id="house" name="houseId" lay-filter="selectHouse" title="楼栋选择">
                        <c:forEach items="${houseList}" var="item">
                            <option value="${item.id}" <c:if test="${item.id==deviceList[0].houseId}"> selected="selected" </c:if>>${item.text}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">楼&nbsp;&nbsp;层:</label>
                <div class="layui-input-inline">
                    <select id="floor" name="floorId" lay-filter="selectFloor" title="楼层选择">
                        <c:forEach items="${floorList}" var="item">
                            <option value="${item.id}" <c:if test="${item.id==deviceList[0].floorId}"> selected="selected" </c:if>>${item.text}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">房&nbsp;&nbsp;号:</label>
                <div class="layui-input-inline">
                    <select id="room" name="roomId" lay-filter="selectRoom" title="房号选择">
                        <c:forEach items="${roomList}" var="item">
                            <option value="${item.id}" <c:if test="${item.id==deviceList[0].roomId}"> selected="selected" </c:if>>${item.text}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">人脸设备名称:</label>
                <div class="layui-input-inline">
                    <input type="text" name="dname" lay-verify="required" placeholder="请输入人脸设备名称" autocomplete="off"
                           class="layui-input">
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">设备类型:</label>
                <div class="layui-input-inline">
                    <select id="selType" name="dtype" lay-filter="test">
                        <option value="HIKVISION">HIKVISION</option>
                        <option value="UNIVIEM">UNIVIEM</option>
                        <option value="DAHUA">DAHUA</option>
                    </select>
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">设备IP:</label>
                <div class="layui-input-inline">
                    <input type="text" name="dip" lay-verify="required" placeholder="请输入设备IP"
                           autocomplete="off" class="layui-input-color" readonly>
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">子网掩码:</label>
                <div class="layui-input-inline">
                    <input type="text" name="dnetMask" lay-verify="required" placeholder="请输入子网掩码"
                           autocomplete="off" value="255.255.255.0" class="layui-input-color" readonly>
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">默认网关:</label>
                <div class="layui-input-inline">
                    <input type="text" name="dgateWay" lay-verify="required" placeholder="请输入网关"
                           autocomplete="off" class="layui-input-color" value="192.168.0.1" readonly>
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">端口号:</label>
                <div class="layui-input-inline">
                    <input type="text" name="port" lay-verify="required" placeholder="请输入端口" autocomplete="off"
                           class="layui-input-color" value="8000" readonly>
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">用户名:</label>
                <div class="layui-input-inline">
                    <input type="text" name="duser" lay-verify="required" placeholder="请输入用户名" autocomplete="off"
                           class="layui-input">
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">密&nbsp;&nbsp;码:</label>
                <div class="layui-input-inline">
                    <input type="text" name="dpassWord" lay-verify="required" placeholder="请输入密码" autocomplete="off"
                           class="layui-input">
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    layui.use(['form', 'element', 'laydate', 'upload'], function () {
        var form = layui.form
            , laydate = layui.laydate
            , $ = layui.jquery
            , upload = layui.upload
            , element = layui.element;

        $(document).ready(function () {
            $("#li5").addClass("layui-this");
            $("#d2").addClass("layui-this");
        });

        laydate.render({
            elem: '#date1'
        });

        //监听提交
        form.on('submit(demo2)', function (data) {
            // alert(JSON.stringify(data.field));
            data.field.deviceId=${deviceList[0].deviceId};
            $.ajax({
                url: "/updateDevice",
                type: "POST",
                async: false,//同步
                contentType: 'application/json',
                data: JSON.stringify(data.field),
                dataType: "text",
                success: function (res) {
                    var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
                    parent.layer.close(index);
                }
            });
            return false;
        });

    });
</script>
</body>
<script>
    var form ;
    layui.use('form', function(){
        form = layui.form;

        $(function () {

            var school;
            var house;
            var floor;
            var room;

            //监听下拉框选中事件
            form.on('select(selectSchool)', function (data) {
                var select = $(data.elem);
                var id =select.val();
                /*if(id==0){
                    $('[name="houseId"]').html('<option value="0">无</option>');
                    $('[name="floorId"]').html('<option value="0">无</option>');
                    $('[name="roomId"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        // $('[name="houseId"]').html('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="houseId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        // $('[name="floorId"]').html('<option value="0">无</option>');
                        // $('[name="roomId"]').html('<option value="0">无</option>');
                        form.render('select');
                    })
                }
                school = data.elem[data.elem.selectedIndex].text
                console.log("school : " + school)
            });
            form.on('select(selectHouse)', function (data) {

                var select = $(data.elem);
                var id =select.val();
               /* if(id==0){
                    $('[name="floorId"]').html('<option value="0">无</option>');
                    $('[name="roomId"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        // $('[name="floorId"]').html('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="floorId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        // $('[name="roomId"]').html('<option value="0">无</option>');
                        form.render('select');
                    })
                }
                house = data.elem[data.elem.selectedIndex].text
                console.log("house : " + house)
            });
            form.on('select(selectFloor)', function (data) {

                var select = $(data.elem);
                var id =select.val();
                /*if(id==0){
                    $('[name="roomId"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if(id!=0) {
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        // $('[name="roomId"]').html('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="roomId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        form.render('select');
                    })
                }
                floor = data.elem[data.elem.selectedIndex].text
                // $.post('queryLoraDevByFloor',{school:school,house:house,floor:floor},function (res) {
                //     $("#loraSN").val("");
                //     $.each(res,function (index, item) {
                //         $("#loraSN").val(item.loraSN);
                //     });
                // })


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
