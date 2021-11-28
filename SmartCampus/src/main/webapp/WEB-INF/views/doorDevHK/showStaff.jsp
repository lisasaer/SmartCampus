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
    <title>查看</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        .layui-form-item{
            height: 38px;
            /*margin-left: 20px;*/
            margin-bottom: 5px;
        }
        /*修改label内边距*/
        .layui-form-pane .layui-form-label {
            padding: 8px 10px;
            text-align: left;
        }
    </style>
</head>
<body>
<div class="bodyDiv" style="margin-left: 15px;margin-top: 15px;">
    <form class="layui-form layui-form-pane" name="form1" action="">

        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">校 区:</label>
            <div class="layui-input-inline">
                <input type="text" name="schoolName" id="schoolName" placeholder="校区选择" autocomplete="off"
                       class="layui-input" readonly="readonly" >
            </div>
        </div>
        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label" style=" ">联系方式:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="telphone" id="telphone" placeholder="请输入联系方式" autocomplete="off"
                       class="layui-input" readonly="readonly">
            </div>
        </div>


        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">楼 栋:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="houseName" id="houseName" placeholder="楼栋选择" autocomplete="off"
                       class="layui-input" readonly="readonly" >
            </div>
        </div>

        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label" style=" ">Q Q:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="qq" id="qq" placeholder="请输入QQ" autocomplete="off"
                       class="layui-input" readonly="readonly">
            </div>
        </div>

        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">楼 层:</label>
            <div class="layui-input-inline">
                <input type="text" name="floorName" id="floorName" placeholder="楼层选择" autocomplete="off"
                       class="layui-input" readonly="readonly" >

            </div>
        </div>
        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label" style=" ">邮 箱:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="email" id="email" placeholder="请输入邮箱" autocomplete="off"
                       class="layui-input" readonly="readonly">
            </div>
        </div>
        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">房 号:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="roomName" id="roomName" placeholder="房号选择" autocomplete="off"
                       class="layui-input" readonly="readonly" >

            </div>
        </div>
        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label" style=" ">备 注:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="remark" id="remark" placeholder="" autocomplete="off"
                       class="layui-input"readonly="readonly">
            </div>
        </div>
        <div  class="layui-form-item" style="float: left;">
            <div class="layui-form-item"style="float: left;">
                <label class="layui-form-label">人员类型:</label>
                <div class="layui-input-inline" style="width: 190px;">
                    <input type="text" name="personType" id="personType" placeholder="" autocomplete="off"
                           class="layui-input"readonly="readonly">
                </div>
            </div>

            <div class="layui-form-item" style="float: left;">
                <label class="layui-form-label layui-required" style=" ">编 号:</label>
                <div class="layui-input-inline" style="width: 190px;">
                    <input type="text" name="staffId" id="staffId" lay-verify="required" placeholder="请输入编号" autocomplete="off"
                           class="layui-input" readonly="readonly"  >
                </div>
            </div>

            <div class="layui-form-item" style="float: left;">
                <label class="layui-form-label layui-required" style=" ">姓 名:</label>
                <div class="layui-input-inline" style="width: 190px;">
                    <input type="text" name="name" id="name" lay-verify="required" placeholder="请输入姓名" autocomplete="off"
                           class="layui-input"  readonly="readonly">
                </div>
            </div>


            <div class="layui-form-item" style="float: left;">
                <label class="layui-form-label" style="  ">性 别:</label>
                <div class="layui-input-inline" style="width: 190px;">
                    <input type="text" name="sex" id="sex" lay-verify="required" placeholder="请输入姓名" autocomplete="off"
                           class="layui-input"  readonly="readonly">
                </div>
            </div>

            <div class="layui-form-item" style="float: left;">
                <label class="layui-form-label layui-required" style=" ">出生日期:</label>
                <div class="layui-input-inline" style="width: 190px;">
                    <input type="text" name="birth" id="birth" autocomplete="off" class="layui-input" lay-verify="required"
                           placeholder="请选择生日" readonly="readonly">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label layui-required" style=" ">卡 号:</label>
                <div class="layui-input-inline" style="width: 190px;">
                    <input type="text" name="cardNo" id="cardNo" lay-verify="required" placeholder="请输入卡号" autocomplete="off"
                           class="layui-input" readonly="readonly"  >
                </div>

            </div>

        </div>
        <div style="float:right;width: 200px;    margin-right: 60px;">
            <div style="float:right;/*margin-right: 5%;margin-top: 15px ;width: 19.3%;*/">
                <input type="text" id="photo" name="photo" style="display:none">
                <div class="layui-upload-list" style="width: 2.5cm;height: 3.5cm;border: 1px solid #f0f0f0;overflow: hidden;position: relative;">
                    <p id="demoText"></p>
                    <img class="layui-upload-img" id="imageId" style="width: 2.5cm;height: 3.5cm;">
                </div>
            </div>
        </div>
    </form>
</div>
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
                $.post('getChildrenOrganize',{id:select.val()},function (res) {
                    //console.log(res);
                    $('[name="houseId"]').html('<option value="0">无</option>');
                    res.forEach(function (value,index) {
                        $('[name="houseId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                    });
                    $('[name="floorId"]').html('<option value="0">无</option>');
                    $('[name="roomId"]').html('<option value="0">无</option>');
                    form.render('select');
                })
                school = data.elem[data.elem.selectedIndex].text
                console.log("school : " + school)

            });
            form.on('select(selectHouse)', function (data) {
                var select = $(data.elem);
                $.post('getChildrenOrganize',{id:select.val()},function (res) {
                    console.log(res);
                    $('[name="floorId"]').html('<option value="0">无</option>');
                    res.forEach(function (value,index) {
                        $('[name="floorId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                    });
                    $('[name="roomId"]').html('<option value="0">无</option>');
                    form.render('select');
                })

                house = data.elem[data.elem.selectedIndex].text
                console.log("house : " + house)
            });
            form.on('select(selectFloor)', function (data) {
                var select = $(data.elem);
                $.post('getChildrenOrganize',{id:select.val()},function (res) {
                    console.log(res);
                    $('[name="roomId"]').html('<option value="0">无</option>');
                    res.forEach(function (value,index) {
                        $('[name="roomId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                    });
                    form.render('select');
                })
                floor = data.elem[data.elem.selectedIndex].text
                $.post('queryLoraDevByFloor',{school:school,house:house,floor:floor},function (res) {
                    $("#loraSN").val("");
                    $.each(res,function (index, item) {
                        $("#loraSN").val(item.loraSN);
                    });
                })
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
