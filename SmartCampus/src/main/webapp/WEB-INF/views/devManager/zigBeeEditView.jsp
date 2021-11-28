<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: zy-dzb
  Date: 2019/11/30
  Time: 14:38
  To change this template use File | Settings | File Templates.
  网关编辑页
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        .layui-form {
            white-space: nowrap;
        }

        .div-title {
            display: inline-block;
            vertical-align: top;
        }

        .div-btn-close {
            float: right;
            vertical-align: top;
            display: inline-block;
            text-align: right
        }

        .div-query-btn {
            margin: 10px;
        }

        .layui-table-tool-self {
            display: none;
        }

        .div-modify {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 100%;
            height: 100%;
            transform: translate(-50%, -50%);
            padding: 30px;
            z-index: 9999;
            background-color: rgba(0, 0, 0, 0.2);
        }

        .div-modify-view {
            border-radius: 10px;
            padding: 30px;
            opacity: 1;
            background-color: rgb(255, 255, 255);
            z-index: 99999;
            width: 50%;
            height: 50%;
            position: relative;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
        }

        .layui-form-label {
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
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 250px center transparent;
        }

        /*点击后的下拉框箭头图片*/
        .layui-form-selected .layui-select-title input {
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 250px center transparent;
        }
    </style>
</head>
<body>
<div class="bodyDiv">
    <form id="zigBeeForm" class="layui-form">
        <div class="layui-form-item">
            <div class="layui-form-item" style="padding-left: 40px;padding-right: 40px;margin-top: 10px">
                <label class="layui-form-label" style="width: 110px; padding-left: 0px;text-align:left">校区:</label>
                <div class="layui-input-block layui-form" lay-filter="selectSchoolDiv">
                    <select id="school" name="school" lay-filter="selectSchool" title="校区选择">
                        <option value="">校区选择</option>
                        <c:forEach items="${schoolList}" var="item">
                            <option value="${item.id}" <c:if
                                    test="${item.id==zigBeeGatewayInfo.school}"> selected="selected" </c:if>>${item.text}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="layui-form-item" style="padding-left: 40px;padding-right: 40px">
                <label class="layui-form-label" style="width: 110px; padding-left: 0px;text-align:left">楼栋:</label>
                <div class="layui-input-block layui-form" lay-filter="selectHouseDiv">
                    <select id="house" name="house" lay-verify="required" lay-filter="selectHouse">
                        <c:forEach items="${houseList}" var="item">
                            <option value="${item.id}" <c:if
                                    test="${item.id==zigBeeGatewayInfo.house}"> selected="selected" </c:if>>${item.text}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="layui-form-item" style="padding-left: 40px;padding-right: 40px">
                <label class="layui-form-label" style="width: 110px; padding-left: 0px;text-align:left">楼层:</label>
                <div class="layui-input-block layui-form" lay-filter="selectFloorDiv">
                    <select id="floor" name="floor" lay-verify="required" lay-filter="selectFloor">
                        <c:forEach items="${floorList}" var="item">
                            <option value="${item.id}" <c:if
                                    test="${item.id==zigBeeGatewayInfo.floor}"> selected="selected" </c:if>>${item.text}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="layui-form-item" style="padding-left: 40px;padding-right: 40px">
                <label class="layui-form-label" style="width: 110px; padding-left: 0px;text-align:left">房号:</label>
                <div class="layui-input-block layui-form" lay-filter="selectRoomDiv">
                    <select id="room" name="room" lay-verify="required" lay-filter="selectRoom">
                        <c:forEach items="${roomList}" var="item">
                            <option value="${item.id}" <c:if
                                    test="${item.id==zigBeeGatewayInfo.room}"> selected="selected" </c:if>>${item.text}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            <div class="layui-form-item " style="padding-left: 40px;padding-right: 40px">
                <label class="layui-form-label"
                       style="width: 110px; padding-left: 0px;text-align:left">ZigBee网关ID:</label>
                <div class="layui-input-block">
                    <input type="text" name="zigbeeId" autocomplete="off"
                           style="pointer-events: none;background-color: #d7d7d7" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item " style="padding-left:40px;padding-right: 40px">
                <label class="layui-form-label" style="width: 110px; padding-left: 0px;text-align:left">备注:</label>
                <div class="layui-input-block">

                    <textarea name="remark" placeholder="" class="layui-textarea "></textarea>
                </div>
            </div>
        </div>
    </form>
</div>
</body>
<script>
    $('#schoolId').attr('value', '无');
    $(".selector").val("无");
    $(".selector").find("option:contains('无')").attr("selected", true);
</script>
<script>
    var form;
    layui.use('form', function () {
        form = layui.form;

        $(function () {
            //监听下拉框选中事件
            var school;
            var house;
            var floor;
            var room;
            form.on('select(selectSchool)', function (data) {
                var select = $(data.elem);
                if (select.val() == "") {
                    $('[name="house"]').html('<option value="">楼栋选择</option>');
                    $('[name="floor"]').html('<option  value="">楼层选择</option>');
                    $('[name="room"]').html('<option  value="">房号选择</option>');
                    form.render('select');
                }

                if (0 != select.val()) {
                    $.post('getChildrenOrganize', {id: select.val()}, function (res) {
                        console.log(res);
                        $('[name="house"]').html('<option value="">楼栋选择</option>');
                        res.forEach(function (value, index) {
                            $('[name="house"]').append('<option value="' + value.id + '">' + value.text + '</option>');
                        });
                        $('[name="floor"]').html('<option value="">楼层选择</option>');
                        $('[name="room"]').html('<option value="">房号选择</option>');
                        form.render('select');
                    });
                }
                school = data.elem[data.elem.selectedIndex].text;
                // }

                console.log("school : " + school)

            });
            form.on('select(selectHouse)', function (data) {
                var select = $(data.elem);
                var id = select.val();
                if (id == "") {
                    $('[name="floor"]').html('<option  value="">楼层选择</option>');
                    $('[name="room"]').html('<option  value="">房号选择</option>');
                    //局部更新
                    form.render('select','selectFloorDiv');
                    form.render('select','selectRoomDiv');
                }
                if (0 != id) {
                    $.post('getChildrenOrganize', {id: select.val()}, function (res) {
                        console.log(res);
                        $('[name="floor"]').html('<option value="">楼层选择</option>');
                        res.forEach(function (value, index) {
                            $('[name="floor"]').append('<option class="layui-form" value="' + value.id + '">' + value.text + '</option>');
                        });
                        $('[name="room"]').html('<option value="">房号选择</option>');
                        //局部更新
                        form.render('select','selectFloorDiv');
                        form.render('select','selectRoomDiv');
                    });
                }
                house = data.elem[data.elem.selectedIndex].text;
                console.log("house : " + house)

            });
            form.on('select(selectFloor)', function (data) {
                var select = $(data.elem);
                var id = select.val();
                if (id == "") {
                    $('[name="room"]').html('<option  value="">房号选择</option>');
                    //局部更新
                    form.render('select','selectRoomDiv');
                }
                if (0 != id) {
                    $.post('getChildrenOrganize', {id: select.val()}, function (res) {
                        console.log(res);
                        $('[name="room"]').html('<option value="">房号选择</option>');
                        res.forEach(function (value, index) {
                            $('[name="room"]').append('<option value="' + value.id + '">' + value.text + '</option>');
                        });
                        //局部更新
                        form.render('select','selectRoomDiv');
                    });
                }
                floor = data.elem[data.elem.selectedIndex].text;
                console.log("floor : " + floor)

            });
            form.on('select(selectRoom)', function (data) {
                room = data.elem[data.elem.selectedIndex].text;
                console.log("room : " + room)
            });
        });
    });

</script>
</html>