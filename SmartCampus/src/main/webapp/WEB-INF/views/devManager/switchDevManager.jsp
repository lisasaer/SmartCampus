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
    <title>空开设备</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <jsp:include page="../header/res.jsp" ></jsp:include>
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
    <a lay-event="detail" style="margin-left: 20px"><img src="../../res/layui/images/dev_icon/detail_icon.png"></a>
    <a lay-event="del" style="margin-left: 20px">
        <img src="../../res/layui/images/dev_icon/delete_icon.png">
    </a>
</script>
<script type="text/html" id="toolbarDemo">
    <div class="layui-inline">
        <div class="layui-col-md1" style="width: 250px;">
            <button id="btnAddDev" class="layui-btn layui-btn-sm">添加设备</button>
            <button id="checkedDel" class="layui-btn layui-btn-sm" lay-event="checkedDel">批量删除</button>
            <button id="btnUpdate" style="border: 0px;margin-left: 20px;background-color: #ffff0000;"><img src="../../res/layui/images/dev_icon/refresh_icon.png"></button>
        </div>
        <div class="layui-input-inline" style="margin-left: 10px">
            <label >校区</label>
            <div class="layui-input-inline">
                <select id="school" name="school" lay-filter="selectSchool" title="校区选择" >
                    <option value="">全部</option>
<%--                    <option value="0">无</option>--%>
                    <c:forEach items="${schoolList}" var="item">
                        <option value="${item.id}">${item.text}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="layui-input-inline" style="margin-left: 10px">
            <label >楼栋</label>
            <div class="layui-input-inline">
                <select id="house" name="house" lay-filter="selectHouse" title="楼栋选择">
                    <option value="">全部</option>
                </select>
            </div>
        </div>
        <div class="layui-input-inline" style="margin-left: 10px">
            <label >楼层</label>
            <div class="layui-input-inline">
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
            <label >设备状态</label>
            <div class="layui-input-inline">
                <select id="onLine" name="onLine" lay-filter="selectStatus" title="设备状态">
                    <option value="">全部</option>
                    <option value="在线">在线</option>
                    <option value="离线">离线</option>
                </select>
            </div>
        </div>
        <div class="layui-inline"style="padding-left: 10px">
            <input class="layui-input" name="loraSN" id="loraSN" placeholder="请输入Lora序列号"
                   autocomplete="off"  style="width: 190px;height: 32px;">
            <span style=" position: absolute; top: 8%; right: 6%; display: table-cell;/*background-color: #0d8ddb*/;white-space: nowrap; padding: 7px 10px;">
                <img src="../../res/layui/images/dev_icon/input_query_icon.png" style="padding-right: 0px;margin-bottom: 4px;">
            </span>
        </div>
        
    </div>
    <div style="float: right;">
        <button id="selectLora" class="layui-btn" onclick="query()" style="padding-left: 7px;"><img src="../../res/layui/images/dev_icon/query_icon.png" style="margin-right: 8px;margin-bottom: 4px;">查询</button>
        <button id="reset" class="layui-btn" onclick="reset()" style="padding-left: 7px;"><img src="../../res/layui/images/dev_icon/reset_icon.png" style="margin-right: 8px;margin-bottom: 4px;">重置</button>
        <button id="export" class="layui-btn layui-btn-sm"  style="padding-left: 7px;"><img src="../../res/layui/images/dev_icon/export_icon.png" style="margin-right: 8px;margin-bottom: 4px;">导出</button>
    </div>
</script>
<script>
    $('#btnSerialPortSetting').click(function () {
        layer.open({
            type: 2,
            area: ['430px', '300px'],
            maxmin: true,
            fixed: false, //不固定
            content: '/serialPortSettingView'
        });
    });

    //重载表格数据
    function reloadTB(){
        table.reload('demo');
    }

    //重置
    function reset(){
        window.location.reload();
    }
    //刷新
    $('body').on('click','#btnUpdate',function(){
    // $('#btnUpdate').click(function () {
        var loading = MyLayUIUtil.loading();
        $.post('getRealStatus',{devType:'1'},function (res) {

        }).always(function () {
            setTimeout(function () {
                reloadTB();
                MyLayUIUtil.closeLoading(loading);
            },1000);
        })
    });
    var table ;

    layui.use(['element','table'], function() {
        var element = layui.element;
        table = layui.table;
        //第一个实例
        tablezx = table.render({
            elem: '#demo'
            ,id:'demo'
            , title: '空开线路数据表'
            , height: 'full-158'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            // ,defaultToolbar: ['filter', 'exports', 'print', { //自定义头部工具栏右侧图标。如无需自定义，去除该参数即可
            //     title: '提示'
            //     ,layEvent: 'LAYTABLE_TIPS'
            //     ,icon: 'layui-icon-tips'
            // }]
            ,url:'getswitchDev'
            , cols: [[ //表头
                {type: 'checkbox'}
                ,{type: 'numbers', title: '序号', width:65,event:'row'}
                // , {field: 'id', title: 'ID' , width : 150,event:'row'}
                , {field: 'school', title: '校区' , width : 150,align : 'center',event:'row',/*sort: true*/}
                , {field: 'house', title: '楼栋' , width : 150,align : 'center',event:'row',/*sort: true*/}
                , {field: 'floor', title: '楼层' , width : 150,align : 'center',event:'row',/*sort: true*/}
                , {field: 'room', title: '房间号' , width : 150,align : 'center',event:'row',/*sort: true*/}
                , {field: 'loraSN', title: 'LORA序列号' , width : 170,event:'row',align : 'center',/*sort: true*/}
                , {field: 'uuid', title: '空开组通讯地址' , width:150,align : 'center',event:'row'}
                //, {field: 'switchGroupNum', title: '空开组数量' , width:100,event:'row'}
                //, {field: 'sensortype', title: '设备类型' , width:100,event:'row'}
                , {field: 'devStatus', title: '设备状态' , width:120,align : 'center',event:'row',/*sort: true*/}
                , {field: 'intervaltime', title: '数据上报时间(s)' , width:150,align : 'center',event:'row'}
                //, {field: 'port', title: '设备端口' , width:100,event:'row'}
                , {field: 'chncnt', title: '空开线路数量' , width:140,align : 'center',event:'row'}
                //, {field: 'chntype', title: '通道类型' , width:150,event:'row'}
                , {field: 'right', title:'操作', width:180,align : 'center',toolbar: '#barDemo'}
            ]]
            ,done: function(res, curr, count){
                exportData=res.data;
                $('[data-field="id"]').addClass('layui-hide');
                // $('.layui-form-checkbox').css('margin-top','5px')
                res.data.forEach(function (item,index) {
                    //如果是在线，修改这行单元格背景和文字颜色
                    if (item.devStatus == "离线") {
                        $(".layui-table-body tbody tr td[data-field=\"devStatus\"]").css({'color': "#b74531"});
                    }
                    if (item.devStatus == "在线") {
                        $(".layui-table-body tbody tr td[data-field=\"devStatus\"]").css({'color': "#1666f9"});
                    }
                });
            }
            ,page:true
            //,limits:[10,20,30,50]
            ,limit:20
        });
        //导出按钮
        $("#export").click(function(){
            table.exportFile(tablezx.config.id,exportData, 'xls');
        })
        //添加设备按钮点击
        $('body').on('click','#btnAddDev',function(){
        // $('#btnAddDev').click(function () {
            layer.open({
                type:2
                ,zIndex:999
                ,title:false
                ,closeBtn: 0
                ,area: ['430px', '680px']
                ,content: 'toAddSwitchDevView'
                ,btn:['确认','取消']
                ,success:function (layero, index) {
                    /*var childWindow = $(layero.find('iframe'))[0].contentWindow;
                    var temp = {};
                    temp.type = 'switch';
                    childWindow.init(temp);*/
                },yes:function (index, layero) {
                    var body = layer.getChildFrame('body', index);
                    var form1 = body.find('#form1');
                    var data = formUtilEL.serializeObject(form1);
                    var area = 'school house floor room';
                    var status = false;
                    for(var key in data) {
                        console.log(key,data[key]);
                        if(key=="school"){
                            if(data[key] == ''){
                                layer.msg('请输入'+body.find('[name="' + key + '"]').attr('placeholder'));
                                return;
                            }
                        }
                        // if (data[key] == '' ) {
                        //     if(area.indexOf(key) > -1){
                        //         layer.msg('请选择区域');
                        //     }else {
                        //         layer.msg('请输入'+body.find('[name="' + key + '"]').attr('placeholder'));
                        //     }
                        //     return;
                        // }
                        if(key=="uuid"){
                            var uuid = data[key];
                            //console.log("uuid"+uuid)
                            if(uuid!=""){
                                $.ajax({
                                    type: "POST",
                                    url: 'selectUUID',  //从数据库查询返回的是个list
                                    dataType: "json",
                                    data: {"uuid":uuid},
                                    async:false,
                                    success: function (data) {
                                        if(data.code==1){
                                            layer.close(loading);
                                            layer.msg("空开组通讯地址已存在！");
                                            status=true;
                                            return false;
                                        }
                                    }, error: function () {
                                        layer.msg("校验失败！");
                                        return false;
                                    }
                                })
                            }
                        }
                    }
                     var loading = layer.load(1, {shade: [0.1, '#fff']});
                    console.log(status);
                    if(!status){
                        $.post('addSwitchDev', data, function (res) {
                            layer.msg(res.msg);
                            layer.close(index);
                             layer.close(loading);
                            reloadTB();
                        }).fail(function (xhr) {
                            layer.msg('添加失败 ' + xhr.status);
                        }).always(function () {
                            layer.close(loading);
                        });
                    }

                }
            })
        });

        //监听行工具事件
        table.on('tool(test)', function(obj) {
            //console.log(obj)
            var data = obj.data;
            console.log(data.loraSN);
            if (obj.event === 'del') {
                layer.confirm('请再次确认是否删除？', function (index) {
                    var loading = layer.load(1, {shade: [0.1, '#fff']});
                    var temp = {
                        Id:data.id
                        ,thisLoraSN:data.loraSN
                    };
                    $.post('delSwitchDev',temp, function (res) {
                        layer.close(loading);
                        reloadTB();
                        layer.msg(res.msg);

                    }).fail(function (xhr) {
                        layer.msg('删除失败 ' + xhr.status);
                        console.log(xhr.status);
                    }).always(function () {
                        layer.close(loading);
                    });
                });
            } else if (obj.event === 'edit') {
                layer.open({
                    type: 2,
                    title: '修改设备',
                    area: ['500px', '350px'],
                    fixed: false, //不固定
                    content: 'toSwitchDevUpdateView',
                    btn: ['确认', '取消'],
                    yes: function (index, layero) {
                        var body = layer.getChildFrame('body', index);
                        var form1 = body.find('#form1');
                        var newData = formUtilEL.serializeObject(form1);

                        newData.id = data.id;
                        console.log('newData'+newData.toString());
                        var loading = layer.load(1, {shade: [0.1, '#fff']});
                        $.post('updateswitchDev', {newUuid:newData.uuid,oldUuid:data.uuid,intervaltime:newData.intervaltime,chncnt:newData.chncnt},function (res) {
                            layer.msg(res.msg);
                            layer.close(index);
                            reloadTB();
                        }).fail(function (xhr) {
                            layer.msg('修改失败' + xhr.status)
                        }).always(function () {
                            layer.close(loading);
                            //setTimeout('window.location.reload()',10);
                        });
                    }
                    , success: function (layero, index) {
                        var body = layer.getChildFrame('body', index);
                        var form1 = body.find('#form1');
                        console.log(form1);
                        formUtilEL.fillFormData(form1, data);
                    }
                });
            }else if (obj.event === 'detail') {
                layer.open({
                    type: 2,
                    title: false,
                    zIndex:999,
                    closeBtn: 0,
                    area: ['1000px', '623px'],
                    shade: 0.8,
                    shadeClose: true,
                    content: 'switchView?devId='+data.devId
                    ,success: function(layero, index) {
                        layer.iframeAuto(index);
                    }
                });
            }

        })
    })


</script>
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
            var devStatus;
            form.on('select(selectSchool)', function (data) {
                var select = $(data.elem);
                var id =select.val();
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
                        res.forEach(function (value,index) {
                            $('[name="house"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="floor"]').html('<option value="">全部</option>');
                        $('[name="room"]').html('<option value="">全部</option>');
                        form.render('select');
                    })
                }
                school = data.elem[data.elem.selectedIndex].text
                console.log("school : " + school)
            });
            form.on('select(selectHouse)', function (data) {
                var select = $(data.elem);
                var id =select.val();
                if(id==""){
                    $('[name="floor"]').html('<option  value="">全部</option>');
                    $('[name="room"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="floor"]').html('<option value="">全部</option>');
                        res.forEach(function (value,index) {
                            $('[name="floor"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="room"]').html('<option value="">全部</option>');
                        form.render('select');
                    })
                }
                house = data.elem[data.elem.selectedIndex].text
                console.log("house : " + house)
            });
            form.on('select(selectFloor)', function (data) {

                var select = $(data.elem);
                var id =select.val();
                if(id==""){
                    $('[name="room"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if(id!=0) {
                    $.post('getChildrenOrganize', {id: select.val()}, function (res) {
                        console.log(res);
                        $('[name="room"]').html('<option value="">全部</option>');
                        // $('[name="room"]').append('<option value="0">无</option>');
                        res.forEach(function (value, index) {
                            $('[name="room"]').append('<option value="' + value.id + '">' + value.text + '</option>');
                        });
                        form.render('select');
                    })
                }

                floor = data.elem[data.elem.selectedIndex].text
                console.log("floor : " + floor)
            });
            form.on('select(selectRoom)', function (data) {

                room = data.elem[data.elem.selectedIndex].text
                console.log("room : " + room)
            });
            form.on('select(selectStatus)', function (data) {

                devStatus = data.elem[data.elem.selectedIndex].text
                console.log("status : " + onLine)
            });
        });
    });
    function query(){

        var school=$("#school").find("option:selected").val();
        var house=$("#house").find("option:selected").val();
        var floor=$("#floor").find("option:selected").val();
        var room=$("#room").find("option:selected").val();
        var onLine=$("#onLine").find("option:selected").text();
        var loraSN = $("#loraSN").val()

         // table.reloadExt('demo')
        tablezx = table.reloadExt('demo', {
            url: 'getSwitchDevByArea'
            , page:{curr: 1}
            ,method:'post'
            , where:{
                school:school,
                house:house,
                floor:floor,
                room:room,
                devStatus:onLine,
                loraSN:loraSN
            }
            // ,done: function(res, curr, count){
            //     $("#school").find("option:selected").val(school);
            //     $("#house").find("option:selected").val(house);
            //     $("#floor").find("option:selected").val(floor);
            //     $("#room").find("option:selected").val(room);
            //     $("#onLine").find("option:selected").text(onLine);
            //     $("#loraSN").val(loraSN)
            // }
        });
    }
    //导出按钮重新实现
    $("#export").click(function(){
        table.exportFile(tablezx.config.id,exportData, 'xls');
    })
</script>
</html>
