<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2019/11/22
  Time: 19:56
  To change this template use File | Settings | File Templates.
--%>
<%
    boolean bComOpen = Boolean.valueOf(request.getSession().getAttribute("comOpen").toString());
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>普通门禁管理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <jsp:include page="../header/res.jsp"></jsp:include>
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
            padding-right: 20px;
        }
        /* 处理勾选框上移*/
        .layui-table-cell .layui-form-checkbox[lay-skin=primary] {
            top: 0px;
            padding: 0;
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
            width: 100px;
        }
        .layui-select-title input{
            height: 32px;
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
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 80px center transparent;
        }
        /*点击后的下拉框箭头图片*/
        .layui-form-selected  .layui-select-title input{
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 80px center transparent;
        }
        /*去除条件查询内边距*/
        .layui-table-tool-temp {
            padding: 0;
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
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <jsp:include page="../header/topHead.jsp"></jsp:include>

    <div class="layui-body" style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;background-color: #e8ebee">
        <table id="demo" lay-filter="test"></table>
    </div>

</div>
</body>

<script type="text/html" id="barDemo">
    <a lay-event="edit"><img src="../../res/layui/images/dev_icon/edit_icon.png"></a>
    <a lay-event="del" style="margin-left: 20px"><img src="../../res/layui/images/dev_icon/close_icon.png"></a>
    <a lay-event="delPer" style="margin-left: 20px"><img src="../../res/layui/images/dev_icon/delete_icon.png"></a>
</script>
<script type="text/html" id="toolbarDemo">
    <div class="layui-inline">
        <div class="layui-col-md1" style="width: 330px;">
            <button id="btnSearchDev" class="layui-btn"style="width: 100px; ">搜索设备<img src="../../res/layui/images/dev_icon/query_icon.png" style="margin-left: 5px;margin-bottom: 4px;"></button>
            <button class="layui-btn layui-btn-sm" lay-event="checkedDel"style="width: 80px; ">批量删除</button>
            <button id="btnDevDoorSetting" class="layui-btn layui-btn-sm" style="width: 60px; " onclick="devDoorSetting()">门设置</button>
            <button id="btnDevDoor" class="layui-btn layui-btn-sm" style="width: 45px; " onclick="setTime()">校时</button>
        </div>
        <div class="layui-input-inline" style="padding-left: 10px">
            <label >校区</label>
            <div class="layui-input-inline">
                <select id="school" name="school" lay-filter="selectSchool" title="校区选择" >
                    <option value="">全部</option>
                    <%--<option value="无">无</option>--%>
                    <c:forEach items="${schoolList}" var="item">
                        <option value="${item.id}">${item.text}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="layui-input-inline" style="padding-left: 10px">
            <label >楼栋</label>
            <div class="layui-input-inline">
                <select id="house" name="house" lay-filter="selectHouse" title="楼栋选择">
                    <option value="">全部</option>
                </select>
            </div>
        </div>

        <div class="layui-input-inline" style="padding-left: 10px">
            <label >楼层</label>
            <div class="layui-input-inline">
                <select id="floor" name="floor" lay-filter="selectFloor" title="楼层选择">
                    <option value="">全部</option>
                </select>
            </div>
        </div>

        <div class="layui-input-inline" style="padding-left: 10px">
            <label >房号</label>
            <div class="layui-input-inline">
                <select id="room" name="room" lay-filter="selectRoom" title="房号选择">
                    <option value="">全部</option>

                </select>
            </div>
        </div>

        <div class="layui-input-inline" style="padding-left: 10px">
            <label >设备状态</label>
            <div class="layui-input-inline">
                <select id="status" name="status" lay-filter="selectStatus" title="设备状态">
                    <option value="">全部</option>
                    <option value="在线">在线</option>
                    <option value="离线">离线</option>
                </select>
            </div>
        </div>
        <div class="layui-inline">
            <input class="layui-input" type="text" id="wgDevSNorIp" placeholder="请输入设备SN/IP" style="width: 170px;height: 32px;">
            <span style=" position: absolute; top: 8%; right: 6%; display: table-cell;/*background-color: #0d8ddb*/;white-space: nowrap; padding: 7px 10px;">
                    <img src="../../res/layui/images/dev_icon/input_query_icon.png" style="padding-right: 0px;margin-bottom: 4px;">
            </span>
        </div>
    </div>
    <div style="float: right;">
        <button id="btnQuery" class="layui-btn layui-btn-sm" onclick="searchDev()" ><img src="../../res/layui/images/dev_icon/query_icon.png" style="margin-right: 8px;margin-bottom: 4px;">查询</button>
        <button id="reset" class="layui-btn layui-btn-sm" onclick="reset()"><img src="../../res/layui/images/dev_icon/reset_icon.png" style="margin-right: 8px;margin-bottom: 4px;">重置</button>
        <button id="orOnLine" class="layui-btn layui-btn-normal layui-btn-radius layui-btn-sm" onclick="orOnLine()">状态监测</button>
        <button id="export" class="layui-btn layui-btn-sm"><img src="../../res/layui/images/dev_icon/export_icon.png" style="margin-right: 8px;margin-bottom: 4px;">导出</button>
    </div>
</script>
<script>
    var table;
    var tablezx;
    //重载表格数据
    function reloadTB(){
        table.reload('demo');
    }
    //重置
    function reset(){
        window.location.reload();
    }
    layui.use(['element','table'], function() {
        var element = layui.element;
        table = layui.table;
        //第一个实例
        tablezx = table.render({
            id : 'demo',
            elem: '#demo'
            , height: 'full-160'
            , cellMinWidth: 120
            , url: 'getWGAcessDev' //数据接口
            , page: true //开启分页
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            /*,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
                title: '提示'
                ,layEvent: 'LAYTABLE_TIPS'
                ,icon: 'layui-icon-tips'
            }]*/
            , cols: [[ //表头
                {type: 'checkbox'}
                , {type: 'numbers', title: '序号',width:65}
                , {field: 'school', title: '校区', width: 100, align: 'center'}
                , {field: 'house', title: '楼栋', width: 100, align: 'center'}
                , {field: 'floor', title: '楼层', width: 100, align: 'center'}
                , {field: 'room', title: '房号', width: 100, align: 'center'}
                , {field: 'ctrlerSN', title: '设备序列号', width: 120, align: 'center'}
                //, {field: 'devName', title: '控制器名称', width: 120, align: 'center'}
                , {field: 'ip', title: '设备IP', width: 120, align: 'center'}
                , {field: 'status', title: '在线状态', width: 95, align: 'center'}
                , {field: 'netmask', title: '子网掩码', width: 120, align: 'center'}
                , {field: 'defaultGateway', title: '默认网关', width: 120, align: 'center'}
                , {field: 'macAddress', title: 'MAC地址', width: 130, align: 'center'}
                , {field: 'port', title: '端口号', width: 85, align: 'center'}
                , {field: 'driverVerID', title: '版本号', width: 85, align: 'center'}
                , {field: 'verDate', title: '版本日期', width: 110, align: 'center'}
                , {field: 'right',   title: '操作', toolbar: '#barDemo', width: 120}
            ]]
            , done: function (res, curr, count) {
                $('[data-field="id"]').addClass('layui-hide');
                exportData=res.data;
                res.data.forEach(function (item, index) {
                    //如果是在线，修改这行单元格背景和文字颜色
                    // if (item.status == "在线") {
                    //     $(".layui-table-body tbody tr[data-index='" + index + "']").css({'background-color': "#009688"});
                    //     $(".layui-table-body tbody tr[data-index='" + index + "']").css({'color': "#fff"});
                    // }
                    if (item.status == "离线") {
                        $(".layui-table-body tbody tr td[data-field=\"status\"]").css({'color': "#b74531"});
                    }
                    if (item.status == "在线") {
                        $(".layui-table-body tbody tr td[data-field=\"status\"]").css({'color': "#1666f9"});
                    }
                });
            }
            ,limit:20
            // ,limits:[15,20,30,50]
        });

        //导出按钮
        $("#export").click(function(){
            table.exportFile(tablezx.config.id,exportData, 'xls');
        })

        //监听事件
        var checkStatus;
        table.on('toolbar(test)', function (obj) {
            checkStatus = table.checkStatus(obj.config.id);
            switch (obj.event) {
                //批量删除设备
                case 'checkedDel':
                    var data = checkStatus.data;
                    layer.confirm('请再次确认是否删除？', {
                        yes: function (index, layero) {
                            var loading = layer.msg("删除中，请等待！");
                            $.ajax({
                                url: "/delSomeWG",
                                type: "POST",
                                contentType: "application/json;charset=UTF-8",//指定消息请求类型
                                data: JSON.stringify(data),
                                success: function () {
                                    layer.close(loading);
                                    tablezx.reload({
                                        method: 'post'
                                        , page: {
                                            curr: 1
                                        }
                                    });
                                    layer.msg("删除成功", {icon: 6});
                                },
                                error: function () {
                                    layer.alert("删除失败");
                                },
                            });
                        }
                    });
            }
        });

        //监听行工具事件
        table.on('tool(test)', function(obj){
            var data = obj.data;
            if(obj.event === 'del'){
                layer.confirm('此操作会连带删除此门禁设备下关联的所有人员权限，请再次确认是否删除？', function(index){
                    var loading = layer.load(1, {shade: [0.1,'#fff']});
                    var temp = {
                        id:data.id
                    };
                    $.post('delWGAccessDev',temp,function (res) {
                        obj.del();
                        layer.close(index);
                        layer.msg('删除成功');
                        reloadTB();
                    }).fail(function (xhr) {
                        layer.msg('删除失败 '+xhr.status);
                        console.log(xhr.status);
                    }).always(function () {
                        layer.close(loading);
                    });
                });
            }else if (obj.event === 'edit') {
                var ctrlerSN=data.ctrlerSN;
                layer.open({
                    type: 2,
                    title: '修改设备',
                    area: ['430px', '780px'],
                    fixed: false, //不固定
                    content: 'editWGAccessDev?ctrlerSN='+ctrlerSN,
                    btn: ['确认', '取消'],
                    success: function (layero, index) {
                        var body = layer.getChildFrame('body', index);
                        var form = body.find('#form');
                        console.log(data);
                        formUtilEL.fillFormData(form, data);
                    }
                    ,yes: function (index, layero) {
                        var body = layer.getChildFrame('body', index);
                        var form = body.find('#form');
                        var newData = formUtilEL.serializeObject(form);
                        //newData.ctrlerSN = data.ctrlerSN;
                        var area = 'schoolId houseId floorId roomId';
                        // for(var key in newData) {
                        //     //console.log("key:"+key,newData[key]);
                        //     if (key = 'schoolId' && newData[key] != '') {
                        //
                        //     }else {
                        //         if(area.indexOf(key) > -1){
                        //             layer.msg('请选择区域');
                        //         }else {
                        //             layer.msg(body.find('[name="' + key + '"]').attr('placeholder'));
                        //         }
                        //         return;
                        //     }
                        //     //     if(area.indexOf(key) == '其他'){
                        //     //
                        //     //     } else if(area.indexOf(key) > -1){
                        //     //         layer.msg('请选择区域');
                        //     //     }else {
                        //     //         layer.msg(body.find('[name="' + key + '"]').attr('placeholder'));
                        //     //     }
                        //     //     return;
                        //     // }
                        // }
                        var loading = layer.load(1, {shade: [0.1, '#fff']});
                        $.post('updateWGAccessDev', {school:newData.schoolId, house:newData.houseId,floor:newData.floorId,room:newData.roomId,ctrlerSN:data.ctrlerSN,devName:newData.devName}, function (res) {
                            layer.msg(res.msg);
                            layer.close(index);
                            reloadTB();
                        }).fail(function (xhr) {
                            layer.msg('编辑失败' + xhr.status)
                        }).always(function () {
                            layer.close(loading);
                            //setTimeout('window.location.reload()',10);
                        });
                    }

                });
            }else if (obj.event === 'delPer') {
                layer.confirm('此操作删除此门禁设备下关联的所有人员权限，请再次确认是否继续？', function(index){
                    var loading = layer.load(1, {shade: [0.1,'#fff']});
                    var temp = {
                        ctrlerSN:data.ctrlerSN
                    };
                    $.post('delDevAllPerssion',temp,function (res) {
                        obj.del();
                        layer.close(index);
                        layer.msg('清除成功');
                        reloadTB();
                    }).fail(function (xhr) {
                        layer.msg('清除失败 '+xhr.status);
                        console.log(xhr.status);
                    }).always(function () {
                        layer.close(loading);
                    });
                });
            }
        });

        //搜索设备
        $('body').on('click','#btnSearchDev',function(){
        // $('#btnSearchDev').click(function () {
            layer.open({
                type: 2,
                title: false,
                area: ['1000px', '623px'],
                shade: 0.8,
                closeBtn: 0,
                shadeClose: true,
                content: 'wgAccessDevSearch'
                ,success: function(layero, index) {
                    layer.iframeAuto(index);
                }
            });
        });
    });


    //设备状态监测
    function orOnLine(){
        table.reload('demo', {
            url: '/WGDevStatusTest'
            ,page: {
                curr: 1 //重新从第 1 页开始
            }
        });
    }


    function devDoorSetting() {
        var checkStatus = table.checkStatus('demo'); //idTest 即为基础参数 id 对应的值
        if(checkStatus.data.length == 0){
            layer.msg("请选择门禁设备");
            return;
        }

        if(checkStatus.data.length >1){
            layer.msg("请选择单个门禁设备");
            return;
        }
        var chooseDevList = checkStatus.data;
        var  ctrlerSN= chooseDevList[0].ctrlerSN;
        layer.open({
            type: 2,
            title: '门设置',
            offset: 't',
            area: ['750', '600px'],
            btn:['确认',' 取消'],
            shade: 0.8,
            // closeBtn: 0,
            //shadeClose: true,
            content: 'wgAccessDevDoorSetting?ctrlerSN='+ctrlerSN
            ,success: function(layero, index) {
                layer.iframeAuto(index);
            }
            ,yes:function (index,layero) {
                var loading = layer.load(1, {shade: [0.1, '#fff']});
                var body = layer.getChildFrame('body', index);
                body.find('#submitBtn').click();
                layer.close(layer.index);

            },end:function () {

            }
        });
    }
    function setTime(){
        var checkStatus = table.checkStatus('demo'); //idTest 即为基础参数 id 对应的值
        if(checkStatus.data.length == 0){
            layer.msg("请选择门禁设备");
            return;
        }
        if(checkStatus.data.length >1){
            layer.msg("请选择单个门禁设备");
            return;
        }
        var chooseDevList = checkStatus.data;
        var  ctrlerSN= chooseDevList[0].ctrlerSN;
        $.post('wgAccessDevSetTime',{ctrlerSN:ctrlerSN},function (res) {
            var loading = layer.load(1, {shade: [0.1,'#fff']});
            layer.close(loading);
            layer.msg(res.msg);
        }).fail(function (xhr) {
            layer.msg('校时失败 '+xhr.status);
        }).always(function () {
            layer.close(loading);
        })
    }
</script>
<script>
    var form ;
    /*var school;
    var house;
    var floor;
    var room;
    var status;*/
    layui.use('form', function(){
        form = layui.form;

        $(function () {
            //监听下拉框选中事件

            form.on('select(selectSchool)', function (data) {
                var select = $(data.elem);
                if(select.val()=="无"){
                    $('[name="house"]').html('<option value="无">无</option>');
                    $('[name="floor"]').html('<option value="无">无</option>');
                    $('[name="room"]').html('<option value="无">无</option>');
                    form.render('select');
                    school = data.elem[data.elem.selectedIndex].value;
                }else if(select.val()==""){
                    $('[name="house"]').html('<option value="">全部</option>');
                    $('[name="floor"]').html('<option value="">全部</option>');
                    $('[name="room"]').html('<option value="">全部</option>');
                    form.render('select');
                    school = data.elem[data.elem.selectedIndex].value;

                } else {
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="house"]').html('<option value="">全部</option>');
                        res.forEach(function (value,index) {
                            $('[name="house"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="floor"]').html('<option value="">全部</option>');
                        $('[name="room"]').html('<option value="">全部</option>');
                        form.render('select');
                    })
                    school = data.elem[data.elem.selectedIndex].text;
                }



                /*table.reload('demo', {
                    url: 'getWGDevByArea'
                    , page:{curr: 1}
                    ,method:'post'
                    , where:{
                        school:school,
                        house:"",
                        floor:"",
                        room:"",
                        status:status,
                    },
                    done:function (res) {
                        console.log(school);
                    }
                });*/
            });
            form.on('select(selectHouse)', function (data) {
                var select = $(data.elem);
                $.post('getChildrenOrganize',{id:select.val()},function (res) {
                    console.log(res);
                    $('[name="floor"]').html('<option value="">全部</option>');
                    res.forEach(function (value,index) {
                        $('[name="floor"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                    });
                    $('[name="room"]').html('<option value="">全部</option>');
                    form.render('select');
                })

                house = data.elem[data.elem.selectedIndex].text
                console.log("house : " + house)
                /*table.reload('demo', {
                    url: 'getWGDevByArea'
                    , page:{curr: 1}
                    ,method:'post'
                    , where:{
                        school:school,
                        house:house,
                        floor:"",
                        room:"",
                        status:status,
                    }
                });*/
            });
            form.on('select(selectFloor)', function (data) {

                var select = $(data.elem);
                $.post('getChildrenOrganize',{id:select.val()},function (res) {
                    console.log(res);
                    $('[name="room"]').html('<option value="">全部</option>');
                    res.forEach(function (value,index) {
                        $('[name="room"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                    });
                    form.render('select');
                })


                floor = data.elem[data.elem.selectedIndex].text
                console.log("floor : " + floor)
                /*table.reload('demo', {
                    url: 'getWGDevByArea'
                    , page:{curr: 1}
                    ,method:'post'
                    , where:{
                        school:school,
                        house:house,
                        floor:floor,
                        room:"",
                        status:status,
                    }
                });*/
            });
            form.on('select(selectRoom)', function (data) {

                room = data.elem[data.elem.selectedIndex].text
                console.log("room : " + room)
                /*table.reload('demo', {
                    url: 'getWGDevByArea'
                    , page:{curr: 1}
                    ,method:'post'
                    , where:{
                        school:school,
                        house:house,
                        floor:floor,
                        room:room,
                        status:status,
                    }
                });*/
            });
            form.on('select(selectStatus)', function (data) {

                status = data.elem[data.elem.selectedIndex].text
                console.log("status : " + status)
                /*table.reload('demo', {
                    url: 'getWGDevByArea'
                    , page:{curr: 1}
                    ,method:'post'
                    , where:{
                        school:school,
                        house:house,
                        floor:floor,
                        room:room,
                        status:status,
                    }
                });*/
            });

        });

    });
    //通过设备SN或者IP搜索设备
    function searchDev(){
        /*if($("#school").find("option:selected").val()==''){*/
            var school=$('#school').val();
            var house=$('#house').val();
            var floor=$('#floor').val();
            var room=$('#room').val();
        /*}else {
            var school=$("#school").find("option:selected").text();
            var house=$("#house").find("option:selected").text();
            if(house=="全部"){house = "";}
            var floor=$("#floor").find("option:selected").text();
            if(floor=="全部"){floor = "";}
            var room=$("#room").find("option:selected").text();
            if(room=="全部"){room = "";}
        }*/
        var wgDevSNorIP=$('#wgDevSNorIp').val();
        var status=$('#status').val();
        tablezx = table.reloadExt('demo', {
            url: '/queryWGDevBySNorIP'
            ,method:'post'
            ,where: {
                SNorIP:wgDevSNorIP,
                school:school,
                house:house,
                floor:floor,
                room:room,
                status:status
            }
            ,page: {
                curr: 1 //重新从第 1 页开始
            }
        });
        //导出按钮重新实现
        $("#export").click(function(){
            table.exportFile(tablezx.config.id,exportData, 'xls');
        })
    }
</script>
</html>