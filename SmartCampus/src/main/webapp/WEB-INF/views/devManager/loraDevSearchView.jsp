<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2019/11/30
  Time: 14:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Title</title>
    <!-- layui -->
    <link rel="stylesheet" type="text/css" href="/res/layui/css/layui.css">
    <script type="text/javascript" src="/res/layui/layui.js"></script>
    <script src="res/js/jquery.min.js"></script>
    <script src="res/js/myjs.js" ></script>
    <%--<jsp:include page="../header/res.jsp"></jsp:include>--%>
    <style>
        /*title样式*/
        .div-title{
            display: inline-block;
            vertical-align: top;
        }
        /*关闭按钮样式*/
        .div-btn-close{
            float: right;
            vertical-align: top;
            display: inline-block;
            text-align: right
        }
        .div-query-btn{
            margin: 10px;
        }
        /*去掉table头部工具栏样式*/
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

        .layui-table-tool-temp {
            padding-right: 0;
        }
        /*条件查询-下拉框*/
        .layui-form-select{
            width: 150px;
        }
        .layui-select-title input{
            height: 32px;
            width: 150px;
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
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 117px center transparent;
        }
        /*点击后的下拉框箭头图片*/
        .layui-form-selected  .layui-select-title input{
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 117px center transparent;
        }
        /* 处理勾选框上移*/
        /*.layui-table-cell .layui-form-checkbox[lay-skin=primary] {*/
        /*    top: 4px;*/
        /*    padding: 0;*/
        /*}*/
        .layui-table-cell, .layui-table-tool-panel li{
            overflow: visible;
        }
        .laytable-cell-1-0-0 {
            top: 14px;
        }
        /*去除table表单外边距*/
        .layui-table, .layui-table-view {
            margin: 0;
            border-width: 0;
        }
        /*条件查询框*/
        .layui-table-tool{
            background-color: white;
            height: 55px;
            border-width:0;
            padding-left: 5px;
            padding-right: 5px;
        }
        /*按钮样式*/
        .layui-btn {
            font-family: "Microsoft Ya Hei";
            font-size: 14px;
            color: #feffff;
            width: 150px;
            line-height: 32px;
            background-color: #1666f9;
            height: 32px;
            border-radius: 5px;
            border: none;
        }
        /*table表单主体*/
        .layui-table-box{
            background-color: white;
            padding-left: 10px;
            padding-right: 10px;
        }
        /* table 表头背景色*/
        .layui-table thead tr , .layui-table-header{
            background-color: white;
            border-width:0;
            color: #999999;
            font-size: 16px;
            font-family: "Microsoft Ya Hei";
        }
        /*table 表头字体大小*/
        .layui-table thead tr th{
            font-size: 16px;
        }
        .layui-table td,.layui-table th{
            border-width: 0px;
        }
        /*table 每行数据顶部线*/
        .layui-table tr{
            /*border-width: 1px;*/
            border-style: solid;
            border-color: #e6e6e6;
            border-top-width: 1px;
            border-right-width: 0px;
            border-bottom-width: 0px;
            border-left-width: 0px;
            height: 40px;
        }
        /*分页栏页数背景色*/
        .layui-laypage .layui-laypage-curr .layui-laypage-em {
            background-color: #1666f9;
        }
        /*分页栏背景色*/
        .layui-table-page {
            background-color: white;
            border-width:0;
            text-align: center;
        }
        /*去除分页*/
        .layui-laypage .layui-laypage-limits, .layui-laypage .layui-laypage-refresh {
            display: none;
        }
        /*table表单序号靠左显示*/
        .laytable-cell-numbers{
            text-align: left;
            height: 16px;
            line-height: 16px;
            padding: 0 15px;
        }
        /*提示框样式修改*/
        .layui-layer-dialog .layui-layer-padding {
            padding: 20px;
        }
        .layui-layer-dialog .layui-layer-content .layui-layer-ico {
            display: none;
        }
        .layui-form-radio>i:hover, .layui-form-radioed>i {
            color: #1666f9;
        }
    </style>
</head>
<body style="padding: 15px;">

<div class="div-title" style="margin-top: 5px;">
    <h1 style="font-family: 'Microsoft Ya Hei'; font-size: 18px; color: #2c394a;margin-left: 5px">Lora网关在线搜索</h1>
</div>
<div class="div-btn-close">
    <button style="margin-top: 5px;border-width: 0;background-color: white;margin-right: 5px;" onclick="closeFrame()">
        <img src="../../res/layui/images/dev_icon/close_icon.png">
    </button>
</div>


<div <%-- class="div-modify layui-hide"--%>>
    <div<%-- class="div-modify-view" --%>>
        <table id="test" lay-filter="test"></table>
        <input  id = "searchStatus" value="${searchStatus}" type="hidden">
        <input  id = "connStatus" value="${connectionStatus}" type="hidden">
    </div>
</div>


</body>
<script type="text/html" id="toolbarDemo">
    <%--    <div class="layui-btn-container" id ="button">--%>
    <div style="float:left;">
        <div class="layui-input-inline"> <label >校区:</label></div>
        <div class="layui-input-inline">

            <select id="school" name="school" lay-filter="selectSchool" title="校区选择" >
                <option value="">请选择</option>
                <%--<option value="0">无</option>--%>
                <c:forEach items="${schoolList}" var="item">
                    <option value="${item.id}">${item.text}</option>
                </c:forEach>
            </select>
        </div>

        <div class="layui-input-inline"  style="margin-left: 40px">
            <label >楼栋:</label>
        </div>
        <div class="layui-input-inline">
            <select id="house" name="house" lay-filter="selectHouse" title="楼栋选择">
                <option value="">请选择</option>
            </select>
        </div>

        <div class="layui-input-inline" style="margin-left: 40px">
            <label >楼层:</label>
        </div>
        <div class="layui-input-inline">
            <select id="floor" name="floor" lay-filter="selectFloor" title="楼层选择">
                <option value="">请选择</option>
            </select>
        </div>
    </div>
    <div style="float: right;">
        <button class="layui-btn layui-btn-sm" lay-event="addDev"  onclick="chooseDev()">添加选中的Lora网关</button>
    </div>

    <%--        <button class="layui-btn layui-btn-sm" lay-event="updateDev">刷新</button>--%>
    <%--        <button class="layui-btn layui-btn-sm" lay-event="openSwitch">修改</button>--%>
    <%--    </div>--%>
</script>
<script>
    var table;
    $(function () {

    });

    function closeFrame(){
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        parent.layer.close(index);
    }

    layui.use('table', function() {
        table = layui.table;

        var searchStatus = $("#searchStatus").val();
        var connStatus = $("#connStatus").val();
        console.log("status"+status)
        if(searchStatus == "true"){
            layer.confirm("没有新的LORA设备在线",{icon:1,btn:['确定'],title:'提示'})
        }
        if(connStatus == "true"){
            layer.confirm("搜索时间过长，请检查LORA设备连接是否正常",{icon:1,btn:['确定'],title:'提示'})
        }
        //表格渲染
        table.render({
            elem: '#test'
            ,id:'test'
            , title: '网关数据表'
            , height: 'full-100'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            , cols: [[
                {type:'radio'}
                ,{type: 'numbers', title: '序号', event:'row'}
                , {field: 'loraSN', title: 'LORA序列号',width:180}
                // , {field: 'ip', title: '设备IP',width:130}
                , {field: 'macAddress', title: 'MAC地址',width:170}
                , {field: 'port', title: '端口号',width:170}
                //, {field: 'netmask', title: '子网掩码',width:130}
                //, {field: 'defaultGateway', title: '默认网关',width:130}
                , {field: 'fwVer', title: 'LORA固件版本',width:170}
                , {field: 'sub1gNum', title: 'SUB1G接口数量',width:170}
                // , {field: 'school', title: '校区'}
                // , {field: 'house', title: '楼栋'}
                // , {field: 'floor', title: '楼层'}
            ]]
            ,data:${list}
            ,done: function(res, curr, count){
                // $('[data-field="id"]').addClass('layui-hide');
                $('.layui-form-checkbox').css('margin-top','5px');
                // $('[data-field="school"]').addClass('layui-hide');
                // $('[data-field="house"]').addClass('layui-hide');
                // $('[data-field="floor"]').addClass('layui-hide');
            }
            ,page:true
            ,limits:[10,15]
            ,limit:10
        });
    })

    function chooseDev(){
        var checkStatus = table.checkStatus('test'); //idTest 即为基础参数 id 对应的值

        if(checkStatus.data.length == 0){
            layer.msg("请选择网关设备");
            return;
        }

        var school=$("#school").find("option:selected").text();
        var house=$("#house").find("option:selected").text();
        var floor=$("#floor").find("option:selected").text();
        var schoolId=$("#school").val();
        var houseId=$("#house").val();
        var floorId=$("#floor").val();
        if(school == "全部"){
            layer.msg("请选择校区");
            return;
        }
        if(house == "全部" && school != "其他"){
            layer.msg("请选择楼栋");
            return;
        }
        if(floor == "全部" && house != "其他" && school != "其他"){
            layer.msg("请选择楼层");
            return;
        }
        checkStatus.data[0].school = schoolId;
        checkStatus.data[0].house = houseId;
        checkStatus.data[0].floor = floorId;
        console.log(schoolId+";"+houseId+";"+floorId)

        var chooseDevList = checkStatus.data;
        var loading = layer.load(1, {shade: [0.1, '#fff']});
        $.post('addLoraDev',{list:JSON.stringify(chooseDevList)},function (res) {
            closeFrame();
            layer.msg(res.msg);
            parent.location.reload();
        })

        // console.log(checkStatus.data) //获取选中行的数据
        // console.log(checkStatus.data.length) //获取选中行数量，可作为是否有选中行的条件
        // console.log(checkStatus.isAll ) //表格是否全选
    }

</script>
<script>
    var form ;
    var school;
    var house;
    var floor;
    var onLine;
    layui.use('form', function(){
        form = layui.form;

        $(function () {
            //监听下拉框选中事件

            form.on('select(selectSchool)', function (data) {
                var select = $(data.elem);
                var id =select.val();
                var school=$("#school").find("option:selected").text();
                /*if(id==0){
                    $('[name="house"]').html('<option value="0">无</option>');
                    $('[name="floor"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if(id==""){
                    $('[name="house"]').html('<option value="">全部</option>');
                    $('[name="floor"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if(id!=null){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="house"]').html('<option value="">全部</option>');
                        /*$('[name="house"]').append('<option value="0">无</option>');*/
                        res.forEach(function (value,index) {
                            $('[name="house"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="floor"]').html('<option value="">全部</option>');
                        form.render('select');
                    })
                }
                school = data.elem[data.elem.selectedIndex].text
                console.log("school : " + school)
            });
            form.on('select(selectHouse)', function (data) {

                var select = $(data.elem);
                var id =select.val();
                /*if(id==0){
                    $('[name="floor"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if(id==""){
                    $('[name="floor"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="floor"]').html('<option value="">全部</option>');
                        /*$('[name="floor"]').append('<option value="0">无</option>');*/
                        res.forEach(function (value,index) {
                            $('[name="floor"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        form.render('select');
                    })
                }
                house = data.elem[data.elem.selectedIndex].text
                console.log("house : " + house)
            });
            form.on('select(selectFloor)', function (data) {

                floor = data.elem[data.elem.selectedIndex].text
                console.log("floor : " + floor)
            });

            form.on('select(selectStatus)', function (data) {

                onLine = data.elem[data.elem.selectedIndex].text
                console.log("status : " + onLine)
            });
        });
    });
</script>
</html>
