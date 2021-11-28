<%--
  Created by IntelliJ IDEA.
  User: zy-dzb
  Date: 2021/8/3
  Time: 14:44
  To change this template use File | Settings | File Templates.
  设备编辑页
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

        .layui-input-block {
            width: 92px;
            margin-left: 52px;
            min-height: 36px;
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
            width: 49px;
            margin-left: 0px;
            padding-left: 5px;
            padding-right: 5px;
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
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 70px center transparent;
        }

        /*点击后的下拉框箭头图片*/
        .layui-form-selected .layui-select-title input {
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 70px center transparent;
        }
    </style>
</head>
<body>
<div class="bodyDiv">
    <form id="zigBeeDevForm" class="layui-form" style="text-align:center">
        <div class="layui-form-item">

            <input name="devId" hidden value="${jsonArray.get(0).devId}">
            <div id="devImage" class="layui-form-item" style="margin: 20px auto">
                <input name="ep" hidden value="${jsonArray.get(0).ep}">
                <img src="../../res/layui/images/zigBee_dev_icon/${jsonArray.get(0).note}_${jsonArray.get(0).st.on}_big.png">
            </div>
            <c:forEach items="${zigBeeGatewayDevInfoList}" var="item">
                <div style="display: inline-block">
                    <input name="dn" style="border:none;font-size: 13px;text-align: center;width: 80px"
                           value="${item.dn}">
                </div>
            </c:forEach>
        </div>
    </form>
</div>
</body>
<script>

    console.info(${jsonArray});

    var dataLen =
    ${jsonArray}.length;
    console.info("个数：" + dataLen);
    switch ("${jsonArray.get(0).note}") {
        case "双开关面板":
            var html = '';
            for (var i = 0; i < dataLen; i++) {
                var note = ${jsonArray}[i].note;
                var ep = ${jsonArray}[i].ep;
                var on = ${jsonArray}[i].st.on;
                if (i == 0) {
                    html += "<input name=\"ep\" hidden value=" + ep + ">";
                    html += "<img  src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_" + ep + "_" + on + "_big.png\">";

                } else {
                    html += "<input name=\"ep\" hidden value=" + ep + ">";
                    html += "<img style=\"margin-left:-7px;\" src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_" + ep + "_" + on + "_big.png\">";

                }

            }
            $("#devImage").html(html);
            break;
        case "三开关面板":
            var html = '';
            $("#devImage").html(html);
            for (var i = 0; i < dataLen; i++) {
                var note = ${jsonArray}[i].note;
                var ep = ${jsonArray}[i].ep;
                var on = ${jsonArray}[i].st.on;
                if (i == 0) {
                    html += "<input name=\"ep\" hidden value=" + ep + ">";
                    html += "<img  src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_" + ep + "_" + on + "_big.png\">";
                } else {
                    html += "<input name=\"ep\" hidden value=" + ep + ">";
                    html += "<img style=\"margin-left: -7px;\" src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_" + ep + "_" + on + "_big.png\">";
                }
            }
            $("#devImage").html(html);
            break;
        case "人体红外":
            var html = "";
            var note = ${jsonArray}[0].note;
            var zsta = ${jsonArray}[0].st.zsta;
            if (null == zsta) {
                html += "<input name=\"ep\" hidden value=\"1\">";
                html += "<img src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_false" + "_big.png\">";
            } else {
                html += "<input name=\"ep\" hidden value=\"1\">";
                html += "<img src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_" + zsta + "_big.png\">";
            }
            $("#devImage").html(html);
            break;
        case "环境盒子":
            var html = "";
            var note = ${jsonArray}[0].note;
            var on = ${jsonArray}[0].st.on;
            var mtemp = ${jsonArray}[0].st.mtemp;
            var tempTenNum = 0;
            var tempUnitNum = 0;
            var tempPointNum = 0;
            if (null != mtemp && "" != mtemp) {
                tempTenNum = mtemp.substring(0, 1);   //十位
                tempUnitNum = mtemp.substring(1, 2);  //个位
                tempPointNum = mtemp.substring(2, 3);  //分位
            }
            console.info("十位：" + tempTenNum + "   个位:" + tempUnitNum + "   分位" + tempPointNum);
            if ("true" == on) {
                html += "<input name=\"ep\" hidden value=\"1\">";
                html += "<img style=\"position:relative;\"  src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_" + on + "_big_bg.png\">";
                html += "<img style=\"position:absolute;margin-top: 78px;margin-left: -144px\"  src=\"../../res/layui/images/zigBee_dev_icon/before_" + tempTenNum + "_big.png\">"
                html += "<img style=\"position:absolute;margin-top: 78px;margin-left: -123px\"  src=\"../../res/layui/images/zigBee_dev_icon/before_" + tempUnitNum + "_big.png\">"
                html += "<img style=\"position:absolute;margin-top: 93px;margin-left: -93px\"  src=\"../../res/layui/images/zigBee_dev_icon/after_" + tempPointNum + "_big.png\">"
            } else {
                html += "<input name=\"ep\" hidden value=\"1\">";
                html += "<img src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_" + on + "_big.png\">";
            }
            $("#devImage").html(html);
            break;
        default:
            break;
    }


</script>
<%--<script>--%>
<%--    $('#schoolId').attr('value', '无');--%>
<%--    $(".selector").val("无");--%>
<%--    $(".selector").find("option:contains('无')").attr("selected", true);--%>
<%--</script>--%>
<%--<script>--%>
<%--    var form;--%>
<%--    layui.use('form', function () {--%>
<%--        form = layui.form;--%>

<%--        $(function () {--%>
<%--            //监听下拉框选中事件--%>
<%--            var school;--%>
<%--            var house;--%>
<%--            var floor;--%>
<%--            var room;--%>
<%--            form.on('select(selectSchool)', function (data) {--%>
<%--                var select = $(data.elem);--%>
<%--                if (select.val() == "") {--%>
<%--                    $('[name="house"]').html('<option value="">楼栋选择</option>');--%>
<%--                    $('[name="floor"]').html('<option  value="">楼层选择</option>');--%>
<%--                    $('[name="room"]').html('<option  value="">房号选择</option>');--%>
<%--                    form.render('select');--%>
<%--                }--%>

<%--                if (0 != select.val()) {--%>
<%--                    $.post('getChildrenOrganize', {id: select.val()}, function (res) {--%>
<%--                        console.log(res);--%>
<%--                        $('[name="house"]').html('<option value="">楼栋选择</option>');--%>
<%--                        res.forEach(function (value, index) {--%>
<%--                            $('[name="house"]').append('<option value="' + value.id + '">' + value.text + '</option>');--%>
<%--                        });--%>
<%--                        $('[name="floor"]').html('<option value="">楼层选择</option>');--%>
<%--                        $('[name="room"]').html('<option value="">房号选择</option>');--%>
<%--                        form.render('select');--%>
<%--                    });--%>
<%--                }--%>
<%--                school = data.elem[data.elem.selectedIndex].text;--%>
<%--                // }--%>

<%--                console.log("school : " + school)--%>

<%--            });--%>
<%--            form.on('select(selectHouse)', function (data) {--%>
<%--                var select = $(data.elem);--%>
<%--                var id = select.val();--%>
<%--                if (id == "") {--%>
<%--                    $('[name="floor"]').html('<option  value="">楼层选择</option>');--%>
<%--                    $('[name="room"]').html('<option  value="">房号选择</option>');--%>
<%--                    //局部更新--%>
<%--                    form.render('select', 'selectFloorDiv');--%>
<%--                    form.render('select', 'selectRoomDiv');--%>
<%--                }--%>
<%--                if (0 != id) {--%>
<%--                    $.post('getChildrenOrganize', {id: select.val()}, function (res) {--%>
<%--                        console.log(res);--%>
<%--                        $('[name="floor"]').html('<option value="">楼层选择</option>');--%>
<%--                        res.forEach(function (value, index) {--%>
<%--                            $('[name="floor"]').append('<option class="layui-form" value="' + value.id + '">' + value.text + '</option>');--%>
<%--                        });--%>
<%--                        $('[name="room"]').html('<option value="">房号选择</option>');--%>
<%--                        //局部更新--%>
<%--                        form.render('select', 'selectFloorDiv');--%>
<%--                        form.render('select', 'selectRoomDiv');--%>
<%--                    });--%>
<%--                }--%>
<%--                house = data.elem[data.elem.selectedIndex].text;--%>
<%--                console.log("house : " + house)--%>

<%--            });--%>
<%--            form.on('select(selectFloor)', function (data) {--%>
<%--                var select = $(data.elem);--%>
<%--                var id = select.val();--%>
<%--                if (id == "") {--%>
<%--                    $('[name="room"]').html('<option  value="">房号选择</option>');--%>
<%--                    //局部更新--%>
<%--                    form.render('select', 'selectRoomDiv');--%>
<%--                }--%>
<%--                if (0 != id) {--%>
<%--                    $.post('getChildrenOrganize', {id: select.val()}, function (res) {--%>
<%--                        console.log(res);--%>
<%--                        $('[name="room"]').html('<option value="">房号选择</option>');--%>
<%--                        res.forEach(function (value, index) {--%>
<%--                            $('[name="room"]').append('<option value="' + value.id + '">' + value.text + '</option>');--%>
<%--                        });--%>
<%--                        //局部更新--%>
<%--                        form.render('select', 'selectRoomDiv');--%>
<%--                    });--%>
<%--                }--%>
<%--                floor = data.elem[data.elem.selectedIndex].text;--%>
<%--                console.log("floor : " + floor)--%>

<%--            });--%>
<%--            form.on('select(selectRoom)', function (data) {--%>
<%--                room = data.elem[data.elem.selectedIndex].text;--%>
<%--                console.log("room : " + room)--%>
<%--            });--%>
<%--        });--%>
<%--    });--%>

<%--</script>--%>
</html>