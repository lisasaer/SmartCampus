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
        }
        .layui-form-item .layui-input-inline {
            margin-left: 130px;
            margin-bottom: 5px;
        }
        /*条件查询-下拉框*/
        .layui-form-select{
            width: 180px;
        }
        .layui-select-title input{
            height: 38px;
            width: 180px;
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
        /*输入框*/
        .layui-input, .layui-textarea {
             width: 100%;
        }
    </style>
</head>
<body>
    <div class="bodyDiv">
        <form id="form1" class="layui-form" style="padding-top: 25px">
            <div class="layui-form-item ">
                <label class="layui-form-label">校区:</label>
                <div class="layui-input-inline">
                    <select id="school" name="school" lay-filter="selectSchool" title="校区选择" >
                        <option value="">请选择</option>
                        <%--<option value="0">无</option>--%>
                        <c:forEach items="${schoolList}" var="item">
                            <option value="${item.id}">${item.text}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="layui-form-item ">
                <label class="layui-form-label">楼栋:</label>
                <div class="layui-input-inline">
                    <select id="house" name="house" lay-filter="selectHouse" title="楼栋选择">
                        <option value="">请选择</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item ">
                <label class="layui-form-label">楼层:</label>
                <div class="layui-input-inline">
                    <select id="floor" name="floor" lay-filter="selectFloor" title="楼层选择">
                        <option value="">请选择</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item ">
                <label class="layui-form-label">房号:</label>
                <div class="layui-input-inline">
                    <select id="room" name="room" lay-filter="selectRoom" title="房号选择">
                        <option value="">请选择</option>
                    </select>
                </div>
            </div>
            <div class="layui-form-item" style="width: auto">
                <label class="layui-form-label" style="text-align: right" >LORA序列号:</label>
                <div class="layui-input-inline" >
                    <select  id="loraSN" name="loraSN" lay-verify="required" lay-filter="lora" lay-search="" class="select">
                        <option value="" readonly="readonly"></option>
                    </select>
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label" >空调通讯地址:</label>
                <div class="layui-input-inline" style="width: 180px">
                    <input <%--type="number"--%> name="uuid" id="uuid" <%-- min="1" max="247"--%> lay-verify="required" autocomplete="off" placeholder="空开通讯地址" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item ">
                <label class="layui-form-label">空调名称:</label>
                <div class="layui-input-inline" style="width: 180px">
                    <input type="text" name="devName" lay-verify="required" autocomplete="off" placeholder="请输入设备名称" class="layui-input">
                </div>
            </div>
<%--            <div class="layui-form-item">--%>
<%--                <label class="layui-form-label"  style=" white-space:nowrap;text-align:right">数据上报间隔</label>--%>
<%--                <div class="layui-input-block">--%>
<%--                    <input type="text"  id="intervaltime" name="intervaltime" lay-verify="required|phone" autocomplete="off" class="layui-input" value="10">--%>
<%--                    <span style=" position: absolute; top: 8%; right: 6%; display: table-cell;/*background-color: #0d8ddb*/;white-space: nowrap; padding: 7px 10px;">s</span>--%>
<%--                </div>--%>
<%--            </div>--%>
        </form>
    </div>
</body>

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
                /*if(id==0){
                    $('[name="house"]').html('<option value="0">无</option>');
                    $('[name="floor"]').html('<option value="0">无</option>');
                    $('[name="room"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if(id==""){
                    $('[name="house"]').html('<option value="">请选择</option>');
                    $('[name="floor"]').html('<option  value="">请选择</option>');
                    $('[name="room"]').html('<option  value="">请选择</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="house"]').html('<option value="">请选择</option>');
                        // $('[name="house"]').append('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="house"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="floor"]').html('<option value="">请选择</option>');
                        $('[name="room"]').html('<option value="">请选择</option>');
                        form.render('select');
                    })
                }
                school = data.elem[data.elem.selectedIndex].text
                // console.log("school : " + school)
                house = "";
                floor = "";
                $.post('queryLoraDevByFloor',{school:school,house:house,floor:floor},function (res) {
                    $("#loraSN").html("");
                    $.each(res,function (i, data) {
                        // console.log("lora网关序列号"+ res[i].id+","+res[i].loraSN)
                        $('[name="loraSN"]').append('<option value="' + res[i].loraSN + '">' + res[i].loraSN + '</option>');
                    });
                    form.render('select');
                })
            });
            form.on('select(selectHouse)', function (data) {

                var select = $(data.elem);
                var id =select.val();
                /*if(id==0){
                    $('[name="floor"]').html('<option value="0">无</option>');
                    $('[name="room"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if(id==""){
                    $('[name="floor"]').html('<option  value="">请选择</option>');
                    $('[name="room"]').html('<option  value="">请选择</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="floor"]').html('<option value="">请选择</option>');
                        // $('[name="floor"]').append('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="floor"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="room"]').html('<option value="">请选择</option>');
                        form.render('select');
                    })
                }
                house = data.elem[data.elem.selectedIndex].text
                console.log("house : " + house)
                floor = "";
                $.post('queryLoraDevByFloor',{school:school,house:house,floor:floor},function (res) {
                    $("#loraSN").html("");
                    $.each(res,function (i, data) {
                        // console.log("lora网关序列号"+ res[i].id+","+res[i].loraSN)
                        $('[name="loraSN"]').append('<option value="' + res[i].loraSN + '">' + res[i].loraSN + '</option>');
                    });
                    form.render('select');
                })
            });
            form.on('select(selectFloor)', function (data) {

                var select = $(data.elem);
                var id =select.val();
                /*if(id==0){
                    $('[name="room"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if(id==""){
                    $('[name="room"]').html('<option  value="">请选择</option>');
                    form.render('select');
                }
                if(id!=0) {
                    $.post('getChildrenOrganize', {id: select.val()}, function (res) {
                        console.log(res);
                        $('[name="room"]').html('<option value="">请选择</option>');
                        // $('[name="room"]').append('<option value="0">无</option>');
                        res.forEach(function (value, index) {
                            $('[name="room"]').append('<option value="' + value.id + '">' + value.text + '</option>');
                        });
                        form.render('select');
                    })
                }
                floor = data.elem[data.elem.selectedIndex].text

                $.post('queryLoraDevByFloor',{school:school,house:house,floor:floor},function (res) {
                    $("#loraSN").html("");
                    $.each(res,function (i, data) {
                        // console.log("lora网关序列号"+ res[i].id+","+res[i].loraSN)
                        $('[name="loraSN"]').append('<option value="' + res[i].loraSN + '">' + res[i].loraSN + '</option>');
                    });
                    form.render('select');
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
<script>
    // //初始化
    // function init(data) {
    //     var type = data.type;
    //     console.log('type',type);
    //
    //     if(type == 'switch'){
    //         $('.div-lineCount').removeClass('layui-hide');
    //     }
    //
    // }
    //
    // $(function () {
    //     $.ajax({
    //         type: "POST",
    //         url: 'getswitchDevLoraSN',  //从数据库查询返回的是个list
    //         dataType: "json",
    //         //contentType: "application/x-www-form-urlencoded; charset=UTF-8",
    //         // async: false,
    //         // cache: false,
    //         success: function (data) {
    //
    //             $.each(data, function (index, item) {
    //                 console.log("查询到的item.devSN:"+item.devSN);
    //                 $('#loraSN').append(new Option(item.devSN));//往下拉菜单里添加元素
    //
    //             })
    //
    //             layui.form.render("select");
    //         }, error: function () {
    //             alert("查询LoraSN失败！！！")
    //
    //         }
    //
    //     })
    // });
    // function initModifyView(data){
    //     $('[name="school"]').html('<option value="1">'+data.school+'</option>');
    //     $('[name="house"]').html('<option value="2">'+data.house+'</option>');
    //     $('[name="floor"]').html('<option value="3">'+data.floor+'</option>');
    //     $('[name="room"]').html('<option value="4">'+data.room+'</option>');
    //     $('[name="school"]').attr('disabled','');
    //     $('[name="house"]').attr('disabled','');
    //     $('[name="floor"]').attr('disabled','');
    //     $('[name="room"]').attr('disabled','');
    //     $('[name="lineCount"]').attr('disabled','');
    //     $('[name="devId"]').attr('disabled','');
    //
    //
    //     if(data.type == '1'){
    //         //空开设备
    //         $('.div-lineCount').removeClass('layui-hide');
    //     }else if(data.type == '2'){
    //         //空调控制设备
    //     }
    //
    //     form.render('select');
    // }
</script>
</html>
