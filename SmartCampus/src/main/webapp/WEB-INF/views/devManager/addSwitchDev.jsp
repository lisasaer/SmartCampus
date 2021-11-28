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
            width: 210px;
        }
        .layui-select-title input{
            height: 38px;
            width: 210px;
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
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 180px center transparent;
        }
        /*点击后的下拉框箭头图片*/
        .layui-form-selected  .layui-select-title input{
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 180px center transparent;
        }
    </style>
</head>
<body style="padding: 15px;">

<div class="div-title" style="margin-top: 5px;">
    <h1 style="font-family: 'Microsoft Ya Hei'; font-size: 18px; color: #2c394a;margin-left: 5px">添加空开设备</h1>
</div>
<div class="div-btn-close">
    <button style="margin-top: 5px;border-width: 0;background-color: white;margin-right: 5px;" onclick="closeFrame()">
        <img src="../../res/layui/images/dev_icon/close_icon.png">
    </button>
</div>

<form id="form1" class="layui-form" style="padding-top: 25px">
    <div class="layui-form-item">
        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <label class="layui-form-label">校区:</label>
            <div class="layui-input-inline">
                <select id="school" name="school" lay-filter="selectSchool" title="校区选择" >
                    <option value="">请选择</option>
<%--                    <option value="0">无</option>--%>
                    <c:forEach items="${schoolList}" var="item">
                        <option value="${item.id}">${item.text}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <label class="layui-form-label">楼栋:</label>
            <div class="layui-input-inline">
                <select id="house" name="house" lay-filter="selectHouse" title="楼栋选择">
                    <option value="">请选择</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <label class="layui-form-label">楼层:</label>
            <div class="layui-input-inline">
                <select id="floor" name="floor" lay-filter="selectFloor" title="楼层选择">
                    <option value="">请选择</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <label class="layui-form-label">房号:</label>
            <div class="layui-input-inline">
                <select id="room" name="room" lay-filter="selectRoom" title="房号选择">
                    <option value="">请选择</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <div class="layui-form-item" style="width: auto">
                <label class="layui-form-label" style="padding-left: 0px;text-align: right" >LORA序列号:</label>
                <div class="layui-input-inline">
                    <%--                    <input type="text"  id="loraSN" name="loraSN" lay-verify="required|phone" autocomplete="off" class="layui-input" placeholder="Lora序列号" value="" readonly="readonly">--%>
                    <select id="loraSN" name="loraSN" lay-filter="selectRoom" title="房号选择">
                        <%--                        <option value="">请选择</option>--%>
                        <%--                    <option value="0">无</option>--%>
                        <%--                    <option value="">房号选择</option>--%>
                    </select>
                </div>
                <%--<div class="layui-input-block" >
                    <select  id="loraSN" name="loraSN" lay-verify="required" lay-filter="lora" lay-search="" class="select">
                        <option value="" readonly="readonly"></option>
                    </select>
                </div>--%>
            </div>
        </div>

        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <div class="layui-form-item ">
                <label class="layui-form-label"style=" padding-left: 0px;">空开组通讯地址:</label>
                <div class="layui-input-inline">
                    <input <%--type="number"--%> name="uuid" id="uuid" <%-- min="1" max="247"--%> lay-verify="required" autocomplete="off" placeholder="空开通讯地址" class="layui-input">
                </div>
            </div>
        </div>

        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <div class="layui-form-item">
                <label class="layui-form-label"  style=" white-space:nowrap;padding-left: 0px;text-align:right">数据上报时间(s):</label>
                <div class="layui-input-inline">
                    <input type="text"  id="intervaltime" name="intervaltime" lay-verify="required|phone" autocomplete="off" class="layui-input" value="10">
                    <%--                    <span style=" position: absolute; top: 8%; right: 6%; display: table-cell;/*background-color: #0d8ddb*/;white-space: nowrap; padding: 7px 10px;">s</span>--%>
                </div>
            </div>
        </div>

        <div class="layui-form-item"style="padding-left: 20px;padding-right: 40px">
            <div class="layui-form-item">
                <label class="layui-form-label" style="white-space:nowrap;text-align:right">空开线路数量:</label>
                <div class="layui-input-inline">
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
        </div>


        <%--<div class="layui-col-md1" style="width: 300px" align="center">
            <button id="btnUpdateDev" class="layui-btn layui-btn-warm">刷新</button>
            <button id="btnAddSwitchDev" type="button" class="layui-btn layui-btn-normal layui-btn-radius ">新增</button>
        </div>--%>
    </div>
</form>

<%--<table id="test" lay-filter="test"></table>--%>

</body>

<%--<script type="text/html" id="barDemo">--%>
<%--    <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edit">编辑</a>--%>
<%--    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>--%>
<%--</script>--%>
<%--<script>--%>
<%--    var table;--%>
<%--    $(function () {--%>
<%--        var list = '${switchDevinfo}' ;--%>
<%--        console.log("list"+list);--%>
<%--    });--%>

<%--    function closeFrame(){--%>
<%--        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引--%>
<%--        parent.layer.close(index);--%>
<%--    }--%>
<%--    var bOpen = false;--%>
<%--    var click=true;--%>

<%--    //遍历loraSN--%>
<%--    /*$(function () {--%>
<%--        $.ajax({--%>
<%--            type: "POST",--%>
<%--            url: 'getswitchDevLoraSN',  //从数据库查询返回的是个list--%>
<%--            dataType: "json",--%>
<%--            success: function (data) {--%>
<%--                $.each(data, function (index, item) {--%>
<%--                    $('#loraSN').append(new Option(item.loraSN));//往下拉菜单里添加元素--%>
<%--                })--%>
<%--                layui.form.render("select");--%>
<%--            }, error: function () {--%>
<%--                alert("查询LoraSN失败！！！")--%>
<%--            }--%>
<%--        })--%>
<%--    });*/--%>

<%--    layui.use('table', function() {--%>
<%--        table = layui.table;--%>
<%--        //表格渲染--%>
<%--        table.render({--%>
<%--            elem: '#test'--%>
<%--            ,id:'test'--%>
<%--            , title: '空开线路数据表'--%>
<%--            , height: 'full-150'--%>
<%--            ,url:'getswitchDev'--%>
<%--            //,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板--%>
<%--            , cols: [[ //表头--%>
<%--                //{type: 'checkbox', fixed: 'left'}--%>
<%--                {type: 'numbers', title: '序号', fixed: 'left',event:'row',align : 'center'}--%>
<%--                , {field: 'school', title: '校区' , width : 120,align : 'center',event:'row'}--%>
<%--                , {field: 'house', title: '楼栋' , width : 120,align : 'center',event:'row'}--%>
<%--                , {field: 'floor', title: '楼层' , width : 120,align : 'center',event:'row'}--%>
<%--                , {field: 'room', title: '房间号' , width : 120,align : 'center',event:'row'}--%>
<%--                // , {field: 'id', title: 'ID' , width : 150,event:'row'}--%>
<%--                , {field: 'loraSN', title: 'Lora序列号' , width : 200,event:'row',align : 'center'}--%>
<%--                , {field: 'uuid', title: '空开通讯地址' , width:150,align : 'center',event:'row'}--%>
<%--                //, {field: 'switchGroupNum', title: '空开组数量' , width:100,event:'row'}--%>
<%--                //, {field: 'sensortype', title: '设备类型' , width:100,event:'row'}--%>
<%--                , {field: 'devStatus', title: '状态检测' , width:120,align : 'center',event:'row'}--%>
<%--                , {field: 'intervaltime', title: '数据上报间隔(s)' , width:150,align : 'center',event:'row'}--%>
<%--                //, {field: 'port', title: '设备端口' , width:100,event:'row'}--%>
<%--                , {field: 'chncnt', title: '设备通道数量' , width:120,align : 'center',event:'row'}--%>
<%--                //, {field: 'chntype', title: '通道类型' , width:150,event:'row'}--%>
<%--                //, {fixed: 'right', title:'操作', align : 'center',toolbar: '#barDemo'}--%>
<%--            ]]--%>
<%--            //, data:${switchDevinfo}--%>
<%--            ,done: function(res, curr, count){--%>
<%--                $('[data-field="id"]').addClass('layui-hide');--%>
<%--                $('.layui-form-checkbox').css('margin-top','5px')--%>
<%--                res.data.forEach(function (item,index) {--%>
<%--                    //如果是在线，修改这行单元格背景和文字颜色--%>
<%--                    if(item.devStatus == "在线"){--%>
<%--                        $(".layui-table-body tbody tr[data-index='"+index+"']").css({'background-color': "#009688"});--%>
<%--                        $(".layui-table-body tbody tr[data-index='"+index+"']").css({'color': "#fff" });--%>
<%--                    }--%>
<%--                });--%>
<%--            }--%>
<%--            ,page:true--%>
<%--            ,limits:[10,15]--%>
<%--            ,limit:10--%>
<%--        });--%>
<%--    })--%>
<%--    //重载表格  刷新表格数据--%>
<%--    function reloadTb(){--%>
<%--        table.reload('test');--%>
<%--    }--%>
<%--    //添加空开设备--%>
<%--    // $('#btnAddSwitchDev').click(function (layero,index) {--%>
<%--    //     var $room=$.trim($('#room').val());--%>
<%--    //--%>
<%--    //     if($room=='' || $room=='房号选择'){--%>
<%--    //         layer.msg('请选择区域');--%>
<%--    //         return false;--%>
<%--    //     }--%>
<%--    //--%>
<%--    //     var school=$('select[name="school"] option:selected').text();--%>
<%--    //     var house=$('select[name="house"] option:selected').text();--%>
<%--    //     var floor=$('select[name="floor"] option:selected').text();--%>
<%--    //     var room=$('select[name="room"] option:selected').text();--%>
<%--    //     var loraSN=$('select[name="loraSN"] option:selected').text();--%>
<%--    //     var chncnt=$('select[name="chncnt"] option:selected').text();--%>
<%--    //--%>
<%--    //     console.log("school"+school);--%>
<%--    //     console.log("house"+house);--%>
<%--    //     console.log("floor"+floor);--%>
<%--    //     console.log("room"+room);--%>
<%--    //     console.log("loraSN"+loraSN);--%>
<%--    //     console.log("chncnt"+chncnt);--%>
<%--    //     layer.open({--%>
<%--    //         type: 2,--%>
<%--    //         zIndex:999,--%>
<%--    //         title: '添加空开设备',--%>
<%--    //         area: ["500px", "510px"],--%>
<%--    //         //shade: 0,--%>
<%--    //         btn:['确定','取消'],--%>
<%--    //         //fixed: false, //不固定--%>
<%--    //         //closeBtn: 0,--%>
<%--    //         //shadeClose: true,--%>
<%--    //         content: 'toSwitchDevAddView',--%>
<%--    //--%>
<%--    //         yes: function (index, layero) {--%>
<%--    //             var body = layer.getChildFrame('body', index);--%>
<%--    //             var form1 = body.find('#form1');--%>
<%--    //             var data = formUtilEL.serializeObject(form1);--%>
<%--    //             //console.log(data);--%>
<%--    //             for (var key in data) {--%>
<%--    //                 console.log(key, data[key]);--%>
<%--    //                 if (data[key] == null || data[key] == '') {--%>
<%--    //                     layer.msg('数据不能为空！');--%>
<%--    //                     return;--%>
<%--    //                 }--%>
<%--    //             }--%>
<%--    //             //空开组通讯地址验证--%>
<%--    //             var status = false;--%>
<%--    //             var uuid = $("#uuid").val();--%>
<%--    //             console.log("uuid"+uuid)--%>
<%--    //             if(uuid!=""){--%>
<%--    //                 $.ajax({--%>
<%--    //                     type: "POST",--%>
<%--    //                     url: 'selectUUID',  //从数据库查询返回的是个list--%>
<%--    //                     dataType: "json",--%>
<%--    //                     data: {"uuid":uuid},--%>
<%--    //                     async:false,--%>
<%--    //                     success: function (data) {--%>
<%--    //                         if(data.code==1){--%>
<%--    //                             layer.msg("空开组通讯地址已存在！");--%>
<%--    //                             status=true;--%>
<%--    //                             return false;--%>
<%--    //                         }--%>
<%--    //                     }, error: function () {--%>
<%--    //                         layer.msg("校验失败！");--%>
<%--    //                         return false;--%>
<%--    //                     }--%>
<%--    //                 })--%>
<%--    //             }--%>
<%--    //             var loading = layer.load(1, {shade: [0.1, '#fff']});--%>
<%--    //             //console.log(data);--%>
<%--    //             var temp={--%>
<%--    //                 school:school,--%>
<%--    //                 house:house,--%>
<%--    //                 floor:floor,--%>
<%--    //                 room:room,--%>
<%--    //                 intervaltime:body.find('#intervaltime').value(),--%>
<%--    //                 loraSN:loraSN,--%>
<%--    //                 uuid:body.find('#uuid').value(),--%>
<%--    //                 chncnt:chncnt--%>
<%--    //             };--%>
<%--    //             $.post('addSwitchDev',temp, function (res) {--%>
<%--    //                 layer.msg(res.msg);--%>
<%--    //                 layer.close(index);--%>
<%--    //                 reloadTb();--%>
<%--    //             }).fail(function (xhr) {--%>
<%--    //                 layer.msg('添加失败 ' + xhr.status);--%>
<%--    //             }).always(function () {--%>
<%--    //                 layer.close(loading);--%>
<%--    //             });--%>
<%--    //         },success(layero, index) {--%>
<%--    //--%>
<%--    //             //layer.iframeAuto(index);--%>
<%--    //             /* var body = layer.getChildFrame('body', index);--%>
<%--    //--%>
<%--    //              var childWindow = $(layero.find('iframe'))[0].contentWindow;--%>
<%--    //              childWindow.initAddView();*/--%>
<%--    //         }--%>
<%--    //     })--%>
<%--    //     $.post('addSwitchDev', {school:school,house:house,floor:floor,room:room}, function (res) {--%>
<%--    //--%>
<%--    //     });--%>
<%--    // });--%>

<%--    //搜索按钮点击事件--%>
<%--    $('btnSelectSwitchDev').click(function(){--%>
<%--        layer.open({--%>
<%--            type: 2,--%>
<%--            title: false,--%>
<%--            area: ['1000px', '623px'],--%>
<%--            shade: 0.8,--%>
<%--            closeBtn: 0,--%>
<%--            shadeClose: true,--%>
<%--            content: 'switchDevSearch'--%>
<%--            ,success: function(layero, index) {--%>
<%--                layer.iframeAuto(index);--%>
<%--            }--%>
<%--        });--%>
<%--    });--%>

<%--    //刷新页面--%>
<%--    $('#btnUpdateDev').click(function () {--%>
<%--        //var loading = MyLayUIUtil.loading();--%>
<%--        console.log("主页刷新");--%>
<%--        reloadTb();--%>
<%--        MyLayUIUtil.closeLoading(loading);--%>

<%--    })--%>
<%--    $(function () {//页面完全加载完后执行--%>

<%--        /*防止重复提交  10秒后恢复*/--%>
<%--        var isSubmitClick = true;--%>
<%--        $('.layui-btn-sm').click(function () {--%>
<%--            if (isSubmitClick) {--%>
<%--                isSubmitClick = false;--%>
<%--                $('.layui-btn-sm').css("background-color", "red");--%>
<%--                // $("form:first").submit();//提交第一个表单--%>
<%--                $("form[name='form_month']").submit();--%>
<%--                setTimeout(function () {--%>
<%--                    $('.layui-btn-sm').css("background-color", "#3CBAFF");--%>
<%--                    isSubmitClick = true;--%>
<%--                }, 10000);--%>
<%--            }--%>
<%--        });--%>
<%--        /**/--%>

<%--    });--%>
<%--</script>--%>
<script>

    function closeFrame(){
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        parent.layer.close(index);
    }


    var form ;
    layui.use('form', function(){
        form = layui.form;

        $(function () {
            //监听下拉框选中事件
            var school;
            var house;
            var floor;
            var room;
            var schoolId;
            var houseId;
            var floorId;
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
                school = data.elem[data.elem.selectedIndex].text;
                // console.log("school : " + school)
                house = "";
                floor = "";
                schoolId = $("#school").val();
                houseId = "";
                floorId = "";
                $.post('queryLoraDevByFloor',{school:schoolId,house:houseId,floor:floorId},function (res) {
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
                floor = "";
                houseId = $("#house").val();
                floorId = "";
                $.post('queryLoraDevByFloor',{school:schoolId,house:houseId,floor:floorId},function (res) {
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
                floorId = $("#floor").val();
                $.post('queryLoraDevByFloor',{school:schoolId,house:houseId,floor:floorId},function (res) {
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
</html>
