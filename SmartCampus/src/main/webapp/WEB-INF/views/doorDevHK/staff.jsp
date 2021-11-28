<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/5/29
  Time: 20:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>人员管理</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <%--    <link rel="stylesheet" href="css/layui.css" media="all">--%>
    <style>
        /*去掉table顶部栏标签*/
        .layui-table-tool-self {
            display: none;
        }
        /*去除table表单外边距*/
        .layui-table, .layui-table-view {
            margin: 0;
        }
        /*table表单主体*/
        .layui-table-box{
            background-color: white;
            top: 12px;
            padding-left: 20px;
           /* padding-right: 20px;*/
        }
        /* 处理勾选框上移*/
        .layui-table-cell .layui-form-checkbox[lay-skin=primary] {
            top: 0;
            bottom: 0;
        }
        .layui-table-view .layui-form-checkbox[lay-skin=primary] i {
            width: 15px;
            height: 15px;
            border-color:#d2d2d2;
        }
        /*勾选框中被选中*/
        .layui-form-checked[lay-skin=primary] i {
            border-color: #1666f9!important;
            background-color: #1666f9;
            color: #fff;
            /*background: url('../../res/layui/images/dev_icon/checked.png');*/
        }
        /*勾选框中未被选中*/
        .layui-form-checkbox[lay-skin=primary] i {
            /*border-color: #1666f9!important;
            background-color: #1666f9;*/
            color: #fff;
            width: 12px;
            height: 12px;
            /*background: url('../../res/layui/images/dev_icon/checkbox.png');*/
        }
        /*条件查询-下拉框*/
        .layui-form-select{
            width: 120px;
        }
        /*去除条件查询内边距*/
        .layui-table-tool-temp {
            padding:0;
        }
        .layui-select-title input{
            height: 32px;
            width: 120px;
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
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 100px center transparent;
        }
        /*点击后的下拉框箭头图片*/
        .layui-form-selected  .layui-select-title input{
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 100px center transparent;
        }
        /*去除条件查询内边距*/
        .layui-table-tool-temp {
            padding:0;
        }
        /*条件查询框*/
        .layui-table-tool{
            background-color: white;
            height: 55px;
            border-width:0;
            padding-left: 20px;
            padding-right: 20px;
        }
        /* table 表头背景色*/
        .layui-table thead tr , .layui-table-header{
            background-color: white;
            border-width:0;
            color: #999999;
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
        /*按钮样式*/
        .layui-btn {
            font-family: "Microsoft Ya Hei";
            font-size: 14px;
            color: #feffff;
            width: 80px;
            line-height: 32px;
            background-color: #1666f9;
            height: 32px;
            border-radius: 5px;
            border: none;
        }
        /*table表单序号靠左显示*/
        .laytable-cell-numbers{
            text-align: left;
            height: 16px;
            line-height: 16px;
            padding: 0 15px;
        }
        /*table表头字体div高度*/
        .layui-table-cell {
            height: 16px;
            line-height: 16px;
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

    </style>
</head>
<body>
<div class="layui-layout layui-layout-admin">
    <jsp:include page="../header/topHead.jsp"></jsp:include>

    <div class="layui-body" style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;">
        <!-- 内容主体区域 -->
        <div <%--style="padding: 15px;"--%>>

            <table id="demo" lay-filter="test" class="layui-hide"></table>
            <script type="text/html" id="toolbarDemo">

                <button class="layui-btn layui-btn-sm" lay-event="add">添加人员</button>
                <button class="layui-btn layui-btn-sm" lay-event="delete">批量删除</button>

                <div class="layui-input-inline" style="margin-left: 10px">
                    <label >校区</label>
                    <div class="layui-input-inline" >
                        <select id="school" name="school" lay-filter="selectSchool" title="校区选择" >
                            <option value="">全部</option>
<%--                            <option value="0">无</option>--%>
                            <c:forEach items="${schoolList}" var="item">
                                <option value="${item.id}">${item.text}</option>
                            </c:forEach>
                        </select>
                    </div>

                </div>
                <div class="layui-input-inline" style="margin-left: 10px">
                    <label >楼栋</label>
                    <div class="layui-input-inline" >
                        <select id="house" name="house" lay-filter="selectHouse" title="楼栋选择">
                            <option value="">全部</option>
                        </select>
                    </div>

                </div>

                <div class="layui-input-inline" style="margin-left: 10px">
                    <label >楼层</label>
                    <div class="layui-input-inline" >
                        <select id="floor" name="floor" lay-filter="selectFloor" title="楼层选择">
                            <option value="">全部</option>
                        </select>
                    </div>

                </div>

                <div class="layui-input-inline" style="margin-left: 10px">
                    <label >房号</label>
                    <div class="layui-input-inline" >
                        <select id="room" name="room" lay-filter="selectRoom" title="房号选择">
                            <option value="">全部</option>
                        </select>
                    </div>

                </div>

                <div class="layui-input-inline" style="margin-left: 10px">
                    <label >人员类型</label>
                    <div class="layui-input-inline" >
                        <select id="personType" name="personType" lay-filter="selectRoom" title="人员类型">
                            <option value="">全部</option>
                            <option value="student">学生</option>
                            <option value="teacher">教师</option>
                            <option value="other">其他</option>
                        </select>
                    </div>

                </div>
                <div class="layui-input-inline" style="margin-left: 10px">
                    <div class="layui-inline">
                        <input class="layui-input" name="staff" id="staff" placeholder="请输入姓名/编号/卡号"
                               autocomplete="off"  style="width: 150px;height: 30px;">
                    </div>
                </div>


                <div style="float: right;">
                    <button id="btnQuery" class="layui-btn layui-btn-sm" onclick="query()"><img src="../../res/layui/images/dev_icon/query_icon.png" style="margin-right: 8px;margin-bottom: 4px;">查询</button>
                    <button id="btnClear" class="layui-btn layui-btn-sm" ><img src="../../res/layui/images/dev_icon/reset_icon.png" style="margin-right: 8px;margin-bottom: 4px;">重置</button>
                    <button id="export" class="layui-btn layui-btn-sm"><img src="../../res/layui/images/dev_icon/export_icon.png" style="margin-right: 8px;margin-bottom: 4px;">导出</button>
                </div>
            </script>

            <script type="text/html" id="barDemo">
                <a lay-event="edit"><img src="../../res/layui/images/dev_icon/edit_icon.png"></a>
                <a lay-event="detail" style="margin-left: 20px"><img src="../../res/layui/images/dev_icon/detail_icon.png"></a>
                <a lay-event="del" style="margin-left: 20px">
                    <img src="../../res/layui/images/dev_icon/delete_icon.png">
                </a>
<%--                <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail">详情</a>--%>
<%--                <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>--%>
<%--                <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>--%>
            </script>

        </div>
    </div>

</div>

<script>
    //水平导航栏选中显示
    $(document).ready(function () {
        $("#li5").addClass("layui-this");
    });
    var tablezx;
    var table;
    layui.use(['table', 'element'], function () {
        table = layui.table
            , $ = layui.jquery
            , element = layui.element;
        $(document).ready(function () {
            $("#li5").addClass("layui-this");
            // $("#d1").addClass("layui-this");
        });
        tablezx = table.render({
            elem: '#demo'
            , toolbar: '#toolbarDemo'
            , height: 'full-95'
            , url: 'selectStaffDetailAll' //数据接口
            , cols: [[ //表头
                {type: 'checkbox'},
                {type: 'numbers', title: '序号', event:'row', width: 65}
                , {field: 'schoolName', title: '校区', width: 100}
                , {field: 'houseName', title: '楼栋', width: 100}
                , {field: 'floorName', title: '楼层', width: 100}
                , {field: 'roomName', title: '房号', width: 100}
                , {field: 'personTypeName', title: '人员类型', width: 100}
                , {field: 'staffId', title: '编号', width : 100/*, sort: true, fixed: 'left'*/}
                , {field: 'name', title: '姓名', width : 100}
                , {field: 'cardNo', title: '卡号', width : 130}
                , {field: 'sex', title: '性别', width : 100}
                , {field: 'birth', title: '出生日期', width : 100}
                , {field: 'telphone', title: '联系方式',width : 130}
                , {field: 'qq', title: 'QQ', width : 130}
                , {field: 'email', title: '邮箱',width : 190}
                , {field: 'remark', title: '备注',width : 100}
                , {field: 'photo', title: '照片', width : 80,templet:'#img',event:'previewImg'}

                // , {field: 'strCreatedTime', title: '创建时间',width : 170,align : 'center'}
                // , {field: 'strUpdatedTime', title: '补卡时间',width : 170,align : 'center'}
                , {field: 'right', title: '操作', toolbar: '#barDemo',width : 150,fixed:'right'}
            ]],
            done: function (res, curr, count) {
                exportData=res.data;
            }
            ,page:true
            // ,limits:[10,20,50,100]
            ,limit:20
        });
        $("#export").click(function(){
            table.exportFile(tablezx.config.id,exportData, 'xls');
        })
        //监听行工具事件
        table.on('tool(test)', function (obj) {
            var data = obj.data;//获取当前行的数据
            if (obj.event === 'del') {
                layer.confirm('此操作会连带删除此人员在系统内的相关权限，</br>请再次确认是否删除？',{

                    yes : function (index,layero) {
                        layer.msg("删除中，请等待！");
                        $.ajax({
                            url: "/delStaff",
                            type: "POST",
                            //data: {"id": data.staffId},
                            data: data,
                            success: function () {
                                $(".layui-laypage-btn").click();//刷新本页面（父页面） 的数据
                                //关闭弹框
                                layer.close(index);
                                layer.msg("删除成功", {icon: 6});
                            },
                            error: function () {
                                layer.alert("删除失败");
                            },
                        });
                    }
                });

            } else if (obj.event === 'edit') {

                layer.open({
                    type: 2,
                    zIndex:999,
                    title: '人员编辑',
                    area: ['660px', '600px'],
                    //fixed: false, //不固定
                    content: 'editStaffView?staffId='+data.staffId,
                    btn: ['确认', '取消'],
                    success: function (layero, index) {
                        var obj = $(layero).find("iframe")[0].contentWindow;   //obj可以调用子页面的任何方法
                        var body = layer.getChildFrame('body', index);

                        body.find('input[name="staffId"]').val(data.staffId);
                        body.find('input[name="name"]').val(data.name);
                        body.find('input[name="birth"]').val(data.birth);
                        body.find('select[name="departmentId"]').val(data.departmentId);
                        body.find('input[name="positionId"]').val(data.pname);
                        body.find('input[name="telphone"]').val(data.telphone);
                        body.find('input[name="email"]').val(data.email);
                        body.find('input[name="qq"]').val(data.qq);
                        body.find('input[name="photo"]').val(data.photo);
                        body.find('input[name="remark"]').val(data.remark);
                        body.find('img[id="imageId"]').attr("src",data.photo);
                    }
                    ,yes:function (index,layero) {
                        layer.confirm('确认修改？</br>请注意是否需要下发人员信息！',function () {
                            var body = layer.getChildFrame('body', index);
                            body.find('#submitBtn').click();
                            layer.close(layer.index);

                        });
                    },end:function () {
                        tablezx.reload();
                    }

                });
            }else if(obj.event === "detail"){
                layer.open({
                    type: 2,
                    zIndex:999,
                    title: '人员详情',
                    area: ['660px', '600px'],
                    content: 'showStaffView',
                    btn: ['返回'],
                    success: function (layero, index) {

                        var obj = $(layero).find("iframe")[0].contentWindow;   //obj可以调用子页面的任何方法
                        var body = layer.getChildFrame('body', index);
                        body.find('input[name="schoolName"]').val(data.schoolName);
                        body.find('input[name="houseName"]').val(data.houseName);
                        body.find('input[name="floorName"]').val(data.floorName);
                        body.find('input[name="roomName"]').val(data.roomName);
                        body.find('input[name="remark"]').val(data.remark);
                        body.find('input[name="personType"]').val(data.personTypeName);
                        body.find('input[name="staffId"]').val(data.staffId);
                        body.find('input[name="cardNo"]').val(data.cardNo);
                        body.find('input[name="name"]').val(data.name);
                        body.find('input[name="sex"]').val(data.sex);
                        body.find('input[name="birth"]').val(data.birth);
                        body.find('input[name="positionId"]').val(data.pname);
                        body.find('input[name="telphone"]').val(data.telphone);
                        body.find('input[name="email"]').val(data.email);
                        body.find('input[name="qq"]').val(data.qq);
                        body.find('input[id="photo"]').val(data.photo);
                        body.find('img[id="imageId"]').attr("src",data.photo);

                    }
                    ,yes:function (index,layero) {
                        layer.close(layer.index); //关闭子弹框
                    }
                });
            }else if(obj.event === "previewImg"){
                console.log(data.photo);
                layer.open({
                    type: 1,
                    title: false,
                    area: ['400px'],
                    closeBtn:0,
                    skin:'layui-layer-nobg',//没有背景色
                    shadeClose:true,
                    content:'<img src = "'+data.photo+'" style="width: 400px">'
                });
            }
        });

        //监听事件
        table.on('toolbar(test)', function (obj) {
            var checkStatus = table.checkStatus(obj.config.id);
            switch (obj.event) {
                case 'add':
                    layer.open({
                        type:2,
                        zIndex:999
                        ,title:'添加人员'
                        ,area: ['660px', '550px']
                        ,content: 'addStaffView'
                        ,btn: ['确认', '取消']
                        ,yes:function (index,layero) {
                            var body = layer.getChildFrame('body', index);
                            body.find('#submitBtn').click();
                            // layer.close(layer.index);
                        },end:function () {
                            tablezx.reload();
                        }
                    });

                    break;
                case 'delete':
                    var data = checkStatus.data;
                    layer.confirm('是否删除所选信息？</br>请谨慎操作！', {
                        yes : function (index,layero) {
                            layer.msg("删除中，请等待！");
                            $.ajax({
                                url: "/delSomeStaff",
                                type: "POST",
                                contentType: "application/json;charset=UTF-8",//指定消息请求类型
                                data: JSON.stringify(data),
                                success: function () {
                                    tablezx.reload({
                                        method: 'post'
                                        , page: {
                                            curr: 1
                                        }
                                    });
                                    layer.msg("批量删除成功", {icon: 6});
                                },
                                error: function () {
                                    layer.alert("批量删除失败");
                                },
                            });
                        }
                    });
                    break;
                case 'update':
                    layer.msg('编辑');
                    break;
            }
        });

        //重置按钮
        $('body').on('click','#btnClear',function(){
            // $('#btnClear').click(function () {

            $('#schoolId').val('');
            $('#houseId').val('');
            $('#floorId').val('');
            $('#roomId').val('');
            $('#personType').val('');
            $('#staff').val('');
            query() ;
            return false;
        });

    });
    //查询按钮
    function query() {
        // $('#btnQuery').click(function () {
        var schoolId = $('#school').val();
        var houseId = $('#house').val();
        var floorId = $('#floor').val();
        var roomId = $('#room').val();
        var personType = $('#personType').val();
        var staff = $('#staff').val();
        // table.refresh();
        tablezx = table.reloadExt('demo', {
            url: 'searchStaff'
            ,where: {
                schoolId:schoolId,
                houseId:houseId,
                floorId:floorId,
                roomId:roomId,
                personType:personType,
                staff:staff
            }
            ,page:{
                curr: 1
            }
        });
        //导出按钮重新实现
        $("#export").click(function(){
            table.exportFile(tablezx.config.id,exportData, 'xls');
        })
    }
</script>
<script type="text/html" id="img">
    <div><img src="{{d.photo}}" style="width:30px;height:30px"></div>
</script>
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
                    $('[name="house"]').html('<option value="">全部</option>');
                    $('[name="floor"]').html('<option  value="">全部</option>');
                    $('[name="room"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="house"]').html('<option value="">全部</option>');
                        // $('[name="house"]').append('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="house"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="floor"]').html('<option value="">全部</option>');
                        $('[name="room"]').html('<option value="">全部</option>');
                        form.render('select');
                    })
                }

                school = $('[name="school"]').val();
                console.log("school : " +  school)
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
                    $('[name="floor"]').html('<option  value="">全部</option>');
                    $('[name="room"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="floor"]').html('<option value="">全部</option>');
                        // $('[name="floor"]').append('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="floor"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="room"]').html('<option value="">全部</option>');
                        form.render('select');
                    })
                }
                house = $('[name="house"]').val();
                console.log("house : " + house);
            });
            form.on('select(selectFloor)', function (data) {

                var select = $(data.elem);
                var id =select.val();
                /*if(id==0){
                    $('[name="room"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if(id==""){
                    $('[name="room"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if(id!=0) {
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="room"]').html('<option value="">全部</option>');
                        // $('[name="room"]').append('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="room"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        form.render('select');
                    })
                }
                floor =  $('[name="floor"]').val();
                console.log("floor : " + floor)

            });
            form.on('select(selectRoom)', function (data) {
                room =  $('[name="room"]').val();
                console.log("room : " + room)
            });
        });
    });

</script>
</html>