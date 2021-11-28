<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <!-- layui -->
    <%--    <link rel="stylesheet" type="text/css" href="/res/layui/css/layui.css">--%>
    <%--    <script type="text/javascript" src="/res/layui/layui.js"></script>--%>
    <%--    <script src="res/js/jquery.min.js"></script>--%>
    <%--    <script src="res/js/myjs.js" ></script>--%>

    <title>网关管理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <jsp:include page="../header/res.jsp"></jsp:include>
    <link rel="stylesheet" type="text/css" href="/res/css/jquery.classycountdown.css" />
<%--    <link rel="stylesheet" type="text/css" href="/res/css/default.css">--%>
    <style>
        /*去除table顶部栏标签*/
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
            width: 140px;
        }
        .layui-select-title input{
            height: 32px;
            width: 140px;
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
        .ClassyCountdown-seconds{
            width: 100%;
            line-height: 1em;
            position: absolute;
            text-align: center;
            left: 0;
            display: block;
        }
        .ClassyCountdown-value {
            width: 100%;
            line-height: 1em;
            position: absolute;
            top: 50%;
            text-align: center;
            left: 0;
            display: block;
          /*  color:#2c394a;
            font-size:14px;*/
        }
    </style>
<%--    <style>--%>
<%--        .ClassyCountdownDemo { margin:0 auto 30px auto; max-width:800px; width:calc(100%); padding:30px; display:block }--%>
<%--        #countdown8 { background:#222 }--%>
<%--    </style>--%>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <jsp:include page="../header/topHead.jsp"></jsp:include>
<%--    <div style="width: 400px;height: 400px;background: #f79393;margin: 250px;position: relative;z-index: 20000;">--%>
<%--        <div style="text-align:center;clear:both">--%>
<%--            <script src="/gg_bd_ad_720x90.js" type="text/javascript"></script>--%>
<%--            <script src="/follow.js" type="text/javascript"></script>--%>
<%--        </div>--%>
<%--        <div id="countdown8" class="ClassyCountdownDemo"></div>--%>
<%--    </div>--%>
    <div class="layui-body" style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;background-color: #e8ebee">
        <table id="demo" lay-filter="test"></table>
    </div>
    <%--        <jsp:include page="../header/footer.jsp"></jsp:include>--%>
</div>
</body>

<script type="text/javascript">
    $(document).ready(function() {
        $('#countdown8').ClassyCountdown({
            theme: "white-black",
            end: $.now() + 10000
        });
    });
</script>

<script type="text/html" id="barDemo">
    <a lay-event="del">
        <img src="../../res/layui/images/dev_icon/delete_icon.png">
    </a>
    <a lay-event="restart" style="margin-left: 20px">
        <img src="../../res/layui/images/dev_icon/restart_icon.png">
    </a>
    <a lay-event="upgrade" style="margin-left: 20px">
        <img src="../../res/layui/images/dev_icon/upgrade_icon.png">
    </a>
    <%--    <a class="layui-btn layui-btn-xs layui-btn-danger" lay-event="del">删除</a>--%>
    <%--&lt;%&ndash;    <a id="edit" class="layui-btn layui-btn-xs " lay-event="edit">编辑</a>&ndash;%&gt;--%>
    <%--    <a id = "restartId" class="layui-btn layui-btn-xs layui-btn-warm" lay-event="restart">重启</a>--%>
    <%--    <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="upgrade">升级</a>--%>
</script>
<script type="text/html" id="toolbarDemo">
    <div <%--class="layui-form-item"--%><%--style="padding: 0px;height: 30px"--%>>
        <div class="layui-col-md1" style="width: 300px;">
            <button id="btnSearchDev" class="layui-btn" style="width: 150px; ">搜索设备<img src="../../res/layui/images/dev_icon/query_icon.png" style="margin-left: 10px;margin-bottom: 4px;"></button>
            <button id="checkedDel" class="layui-btn layui-btn-sm" lay-event="checkedDel">批量删除</button>
            <button id="btnUpdateDev" style="border: 0px;margin-left: 20px;background-color: #ffff0000;"><img src="../../res/layui/images/dev_icon/refresh_icon.png"></button>
        </div>
        <div class="layui-col-md1" style="width: 1000px;">
            <%--                <form id="form1" class="layui-form" >--%>
            <div class="layui-input-inline" style="margin-left: 40px"> <label >校区:</label></div>
            <div class="layui-input-inline">

                <select id="school" name="school" lay-filter="selectSchool" title="校区选择">
                    <option value="">全部</option>
                    <%--<option value="0">无</option>--%>
                    <c:forEach items="${schoolList}" var="item">
                        <option value="${item.id}">${item.text}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="layui-input-inline"  style="margin-left: 40px">
                <label >楼栋:</label>
            </div>
            <div class="layui-input-inline" style="height: 32px;">
                <select id="house" name="house" lay-filter="selectHouse" title="楼栋选择">
                    <option value="">全部</option>
                </select>
            </div>

            <div class="layui-input-inline"  style="margin-left: 40px">
                <label >楼层:</label>
            </div>
            <div class="layui-input-inline">
                <select id="floor" name="floor" lay-filter="selectFloor" title="楼层选择">
                    <option value="">全部</option>
                </select>
            </div>

            <div class="layui-input-inline"style="margin-left: 40px">
                <label >设备状态:</label>
            </div>
            <div class="layui-input-inline">
                <select id="onLine" name="onLine" lay-filter="selectStatus" title="设备状态">
                    <option value="">全部</option>
                    <option value="在线">在线</option>
                    <option value="离线">离线</option>
                </select>
            </div>
        </div>
        <div style="float: right">
            <!--查询、重置、导出!-->
            <button id="selectLora" class="layui-btn" onclick="selectLora()" style="padding-left: 7px;"><img src="../../res/layui/images/dev_icon/query_icon.png" style="margin-right: 8px;margin-bottom: 4px;">查询</button>
            <button id="reset" class="layui-btn" onclick="reset()" style="padding-left: 7px;"><img src="../../res/layui/images/dev_icon/reset_icon.png" style="margin-right: 8px;margin-bottom: 4px;">重置</button>
            <button id="export" class="layui-btn layui-btn-sm"  style="padding-left: 7px;"><img src="../../res/layui/images/dev_icon/export_icon.png" style="margin-right: 8px;margin-bottom: 4px;">导出</button>
        </div>

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
            id: 'demo',
            elem: '#demo'
            , height: 'full-94'
            //, cellMinWidth: 120
            , url: 'getLoraDev' //数据接口
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            // ,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
            //     title: '提示'
            //     ,layEvent: 'LAYTABLE_TIPS'
            //     ,icon: 'layui-icon-tips'
            // }]
            , page: true //开启分页
            , cols: [[ //表头
                {type: 'checkbox'}
                ,{type: 'numbers', title: '序号'/*, fixed: 'left'*/,event:'row'/*,align : 'center'*/,width: 80}
                //, {field: 'id', title: 'ID',width:50,align : 'center'}
                , {field: 'school', title: '校区', width: 130,  event: 'row'}
                , {field: 'house', title: '楼栋', width: 130,  event: 'row'}
                , {field: 'floor', title: '楼层', width: 130,  event: 'row'}
                , {field: 'loraSN', title: 'LORA序列号', width: 140,  event: 'row'}
                //, {field: 'ip', title: '设备IP' , width:150,align : 'center',event:'row'}
                , {field: 'onLine', title: '设备状态', width: 120,  event: 'row'}
                , {field: 'switchGroupNum', title: '空开组数量', width: 140,  event: 'row'}
                , {field: 'macAddress', title: 'MAC地址', width: 150,  event: 'row'}
                , {field: 'port', title: '端口号', width: 110,  event: 'row'}
                //, {field: 'netmask', title: '子网掩码' , width:150,align : 'center',event:'row'}
                //, {field: 'defaultGateway', title: '默认网关' , width:150,align : 'center',event:'row'}
                , {field: 'fwVer', title: 'LORA固件版本', width: 140,  event: 'row'}
                , {field: 'sub1gNum', title: 'SUB1G接口数量', width: 150,  event: 'row'}
                , {field: 'right', title: '操作', toolbar: '#barDemo', width: 150}
            ]]
            , done: function (res, curr, count) {
                exportData=res.data;
                res.data.forEach(function (item,index) {
                    //如果是在线，修改这行单元格背景和文字颜色
                    // if (item.onLine == "在线") {
                    //     $(".layui-table-body tbody tr[data-index='" + index + "']").css({'background-color': "#009688"});
                    //     $(".layui-table-body tbody tr[data-index='" + index + "']").css({'color': "#fff"});
                    // }
                    if (item.onLine == "离线") {
                        $(".layui-table-body tbody tr td[data-field=\"onLine\"]").css({'color': "#b74531"});
                    }
                    if (item.onLine == "在线") {
                        $(".layui-table-body tbody tr td[data-field=\"onLine\"]").css({'color': "#1666f9"});
                    }
                });
            }
            , limit: 20
           /* , limits: [15, 20, 30, 50]*/
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
                                url: "/delSomeLora",
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
        table.on('tool(test)', function (obj) {
            var data = obj.data;
            if (obj.event === 'del') {
                layer.confirm('此操作会连带删除此网关下关联的所有设备，请再次确认是否删除？', function (index) {
                    var loading = layer.load(1, {shade: [0.1, '#fff']});
                    var temp = {
                        id: data.id
                        // ,devSN:data.devSN
                    };
                    $.post('delLoraDev', temp, function (res) {
                        reloadTB();
                        layer.msg(res.msg);
                        obj.del();
                        layer.close(index);
                    }).fail(function (xhr) {
                        layer.msg('删除失败 ' + xhr.status);
                        console.log(xhr.status);
                    }).always(function () {
                        layer.close(loading);
                    });
                });
            }
            // else if (obj.event === 'edit') {
            //     layer.open({
            //         type: 2,
            //         zIndex:999,
            //         title: '修改设备',
            //         area: ['430px', '630px'],
            //         //fixed: false, //不固定
            //         content: 'editLoraDev?loraSN='+data.loraSN,
            //         btn: ['确认', '取消'],
            //         success: function (layero, index) {
            //             var body = layer.getChildFrame('body', index);
            //             var form = body.find('#form');
            //             //console.log(form);
            //             formUtilEL.fillFormData(form, data);
            //         }
            //         ,yes: function (index, layero) {
            //             var body = layer.getChildFrame('body', index);
            //             var form = body.find('#form');
            //             var newData = formUtilEL.serializeObject(form);
            //             newData.loraSN = data.loraSN;
            //
            //             console.log("index:"+newData);
            //             var area = 'school house floor';
            //             for(var key in newData) {
            //                 console.log("key:"+key,newData[key]);
            //                 if (newData[key] == '' ) {
            //                     if(area.indexOf(key) > -1){
            //                         layer.msg('请选择区域');
            //                     }else {
            //                         layer.msg(body.find('[name="' + key + '"]').attr('placeholder'));
            //                     }
            //                     return;
            //                 }
            //             }
            //             var loading = layer.load(1, {shade: [0.1, '#fff']});
            //             $.post('updateLoraDev', {schoolId:newData.schoolId, houseId:newData.houseId,floorId:newData.floorId,loraSN:newData.loraSN}, function (res) {
            //                 layer.msg(res.msg);
            //                 layer.close(index);
            //                 reloadTB();
            //             }).fail(function (xhr) {
            //                 layer.msg('编辑失败' + xhr.status)
            //             }).always(function () {
            //                 layer.close(loading);
            //                 //setTimeout('window.location.reload()',10);
            //             });
            //         }
            //
            //     });
            // }
            else if (obj.event === 'restart') {
                layer.confirm('确定重启该设备？', function (index) {
                    var loading = layer.load(1, {shade: [0.1, '#fff']});
                    //var loading = layer.msg('<span style="font-size:20px">权限下发中...请等待</span>', {icon: 16, shade: 0.3, time:0,});

                    var temp = {
                        id: data.id
                        // ,devSN:data.devSN
                    };
                    $.post('restartLoraDev', temp, function (res) {
                        console.log(res.code);
                        if (res.code == 1) {
                            layer.msg("请检查是否连接网关!");
                            reloadTB();
                        } else if (res.code == 2) {
                            layer.msg("服务器发送请求数据失败！");
                            reloadTB();
                        } else if (res.code == 3) {
                            layer.msg("网关没有返回消息！");
                            reloadTB();
                        } else if (res.code == 4) {
                            layer.msg("网关返回内容显示操作失败！");
                            reloadTB();
                        } else if (res.code == 5) {


                            layer.msg("重启成功！");
                            reloadTB();
                            click = false;
                            $(this).css("background-color", "#4e5465");
                            setTimeout(function () {
                                console.log("等待时间结束......");
                                click = true;
                                $('#restartId').css("background-color", "#009688");
                            }, 60000);
                        }
                    }).always(function () {
                        layer.close(loading);
                    });

                });
            } else if (obj.event === 'upgrade') {
                layer.confirm('确定升级该设备？', function (index) {
                    var loading = layer.load(1, {shade: [0.1, '#fff']});
                    var temp = {
                        id: data.id
                        // ,devSN:data.devSN
                    };
                    $.post('upgradeLoraDev', temp, function (res) {
                        console.log(res.code);
                        if (res.code == 1) {
                            layer.msg("请检查是否连接网关!");
                            reloadTB();
                        } else if (res.code == 2) {
                            layer.msg("服务器发送请求数据失败！");
                            reloadTB();
                        } else if (res.code == 3) {
                            layer.msg("网关没有返回消息！");
                            reloadTB();
                        } else if (res.code == 4) {
                            layer.msg("网关返回内容显示操作失败！");
                            reloadTB();
                        } else if (res.code == 5) {
                            layer.msg("升级成功！");
                            reloadTB();
                        }
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
                content: 'loraDevSearch'
                , success: function (layero, index) {
                    layer.iframeAuto(index);
                }
            });
        });


        //刷新设备
        $('body').on('click','#btnUpdateDev',function(){
            // $('#btnUpdateDev').click(function () {
            var loading = MyLayUIUtil.loading();
            console.log("主页刷新");
            reloadTB();
            MyLayUIUtil.closeLoading(loading);

        });
    });

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
                if(id!=0){
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
    function selectLora(){

        /*var school=$("#school").find("option:selected").text();
        var house=$("#house").find("option:selected").text();
        var floor=$("#floor").find("option:selected").text();*/
        var school=$("#school").val();
        var house=$("#house").val();
        var floor=$("#floor").val();
        var onLine=$("#onLine").find("option:selected").text();

        tablezx = table.reloadExt('demo', {
            url: 'getLoraByArea'
            , page:{curr: 1}
            ,method:'post'
            , where:{
                school:school,
                house:house,
                floor:floor,
                onLine:onLine,
            }
        });
        //导出按钮重新实现
        $("#export").click(function(){
            table.exportFile(tablezx.config.id,exportData, 'xls');
        })
        // });

    }
</script>
</html>