<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2019/11/22
  Time: 19:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>空调设备</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        /*去除table表单外边距*/
        .layui-table, .layui-table-view {
            margin: 0;
        }
        /*去除table顶部栏标签*/
        .layui-table-tool-self {
            display: none;
        }
        /*条件查询-下拉框*/
        .layui-form-select{
            width: 140px;
        }
        .layui-select-title input{
            height: 32px;
            width: 140px;
        }
        /*去除条件查询内边距*/
        .layui-table-tool-temp {
            padding:0;
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
    </style>
</head>
<body class="layui-layout-body">
    <div class="layui-layout layui-layout-admin">
        <!-- 头部区域（可配合layui已有的水平导航） -->
        <jsp:include page="../header/topHead.jsp"></jsp:include>
        <div class="layui-body" style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;">
<%--            <div>--%>
<%--                <button id="btnAddDev" class="layui-btn">添加设备</button>--%>

<%--                <button id="btnSerialPortSetting" class="layui-btn">串口设置</button>--%>
<%--                <button id="btnUpdate" class="layui-btn">刷新</button>--%>
<%--                <input type="text" id="devID" placeholder="请输入设备ID" style="width: 150px;height: 37px;">--%>
<%--                <input type="text" id="devName" placeholder="请输入设备名称" style="width: 150px;height: 37px;">--%>
<%--                <button id="btnSearch" class="layui-btn" onclick="searchDev()">搜索</button>--%>
<%--            </div>--%>

            <table  id="demo" lay-filter="test"></table>
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
    <div <%--class="layui-form-item"--%>style="padding: 0px;height: 30px;    float: left;">
        <div class="layui-col-md1" style="width: 300px;">
            <button id="btnAddDev" class="layui-btn layui-btn-sm">添加设备</button>
            <button id="checkedDel" class="layui-btn layui-btn-sm" lay-event="checkedDel">批量删除</button>
            <button id="btnUpdate" style="border: 0px;margin-left: 20px;background-color: #ffff0000;"><img src="../../res/layui/images/dev_icon/refresh_icon.png"></button>
        </div>
        <%--        <div class="layui-col-md1" style="width: 800px">--%>
        <%--            <form id="form1" class="layui-form" >--%>

        <div class="layui-input-inline"style="padding-left: 10px">
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
        <div class="layui-input-inline"style="padding-left: 10px">
            <label >楼栋</label>
            <div class="layui-input-inline">
                <select id="house" name="house" lay-filter="selectHouse" title="楼栋选择">
                    <option value="">全部</option>
                </select>
            </div>
        </div>
        <div class="layui-input-inline"style="padding-left: 10px">
            <label >楼层</label>
            <div class="layui-input-inline">
                <select id="floor" name="floor" lay-filter="selectFloor" title="楼层选择">
                    <option value="">全部</option>
                </select>
            </div>
        </div>
        <div class="layui-input-inline"style="padding-left: 10px">
            <label >房号</label>
            <div class="layui-input-inline" >
                <select id="room" name="room" lay-filter="selectRoom" title="房号选择">
                    <option value="">全部</option>
                </select>
            </div>

        </div>
        <div class="layui-input-inline"style="padding-left: 10px">
            <label >设备状态</label>
            <div class="layui-input-inline">
                <select id="onLine" name="onLine" lay-filter="selectStatus" title="设备状态">
                    <option value="">全部</option>
                    <option value="在线">在线</option>
                    <option value="离线">离线</option>
                </select>
            </div>
        </div>
        <%--            </form>--%>
        <%--        </div>--%>

    </div>
    <div style="float: right;">
        <button id="btnSearch" class="layui-btn" onclick="searchDev()" style="padding-left: 7px;"><img src="../../res/layui/images/dev_icon/query_icon.png" style="margin-right: 8px;margin-bottom: 4px;">查询</button>
        <button id="reset" class="layui-btn" onclick="reset()" style="padding-left: 7px;"><img src="../../res/layui/images/dev_icon/reset_icon.png" style="margin-right: 8px;margin-bottom: 4px;">重置</button>
        <button id="export" class="layui-btn layui-btn-sm"  style="padding-left: 7px;"><img src="../../res/layui/images/dev_icon/export_icon.png" style="margin-right: 8px;margin-bottom: 4px;">导出</button>
    </div>
</script>
<script>
    // $(function () {
    //     leftThis("空调设备");
    // });
    // 串口设置
    // $('#btnSerialPortSetting').click(function () {
    //     layer.open({
    //         type: 2,
    //         title: false,
    //         area: ['430px', '330px'],
    //         shade: 0.8,
    //         closeBtn: 0,
    //         shadeClose: true,
    //         content: '/serialPortSettingView'
    //     });
    // });
    //重置
    function reset(){
        window.location.reload();
    }
    //刷新
    $('body').on('click','#btnUpdate',function(){
    // $('#btnUpdate').click(function () {
        var loading = MyLayUIUtil.loading();
        $.post('getRealStatus',{devType:'2'},function (res) {

        }).always(function () {
            setTimeout(function () {
                reloadTB();
                MyLayUIUtil.closeLoading(loading);
            },1000);
        })
    });
    var table ;

    //重载表格数据
    function reloadTB(){
        table.reload('demo');
    }

    layui.use(['element','table'], function() {
        var element = layui.element;
        table = layui.table;
        //第一个实例
        tablezx = table.render({
            id : 'demo',
            elem: '#demo'
            , height: 'full-160'
            , toolbar: '#toolbarDemo'
            //, cellMinWidth: 120
            , url: 'getDev' //数据接口
            , page: true //开启分页
            , cols: [[ //表头
                {type: 'checkbox'}
                ,{type: 'numbers', title: '序号',event:'row',width:70}
                , {field: 'id', title: 'ID', style: 'display:none', width: 1,event:'row'}
                , {field: 'school',   title: '校区', width: 150,event:'row'}
                , {field: 'house',   title: '楼栋', width: 150,event:'row'}
                , {field: 'floor',   title: '楼层', width: 150,event:'row'}
                , {field: 'room',   title: '房号', width: 150,event:'row'}
                , {field: 'loraSN', title: 'LORA序列号' , width : 180,event:'row'/*sort: true*/}
                , {field: 'uuid', title: '空调通讯地址' , width:180,event:'row'}
                , {field: 'devId',   title: '设备ID', width: 180,event:'row'}
                // , {field: 'devSN',   title: '设备SN',event:'row', style: 'display:none', width: 1,event:'row'}
                // , {field: 'devName', title: '设备名称',event:'row'}
                , {field: 'devName', title: '空调名称', width: 180,event:'row'}
                , {field: 'devStatus', title: '设备状态', width: 160,event:'row'}
                , {field: 'right',   title: '操作', toolbar: '#barDemo', width: 180}
            ]]
            , done: function (res, curr, count) {
                exportData=res.data;
                $('[data-field="id"]').addClass('layui-hide');
                $('[data-field="devId"]').addClass('layui-hide');
                res.data.forEach(function (item,index) {
                    //如果是在线，修改这行单元格背景和文字颜色
                    /*if(item.devStatus == "在线"){
                        $(".layui-table-body tbody tr[data-index='"+index+"']").css({'background-color': "#009688"});
                        $(".layui-table-body tbody tr[data-index='"+index+"']").css({'color': "#fff" });
                    }*/
                    if (item.devStatus == "离线") {
                        $(".layui-table-body tbody tr td[data-field=\"devStatus\"]").css({'color': "#b74531"});
                    }
                    if (item.devStatus == "在线") {
                        $(".layui-table-body tbody tr td[data-field=\"devStatus\"]").css({'color': "#1666f9"});
                    }
                });
            }
            ,limit:1
            // ,limits:[15,20,30,50]
            // ,where:{
            //     devType:'2'
            // }
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
                ,title:'添加设备'
                ,area: ['400px', '550px']
                ,content: 'addDevView'
                ,btn:['确认','取消']
                ,success:function (layero, index) {

                },yes:function (index, layero) {
                    var body = layer.getChildFrame('body', index);
                    var form1 = body.find('#form1');
                    var data = formUtilEL.serializeObject(form1);
                    var status = false;
                    //删除无用信息
                    // delete data.lineCount;
                    // delete data.school;
                    // delete data.house;
                    // delete data.floor;

                    var area = 'school house floor room';
                    for(var key in data) {
                        console.log(key,data[key]);
                        if (data[key] == '' ) {
                            if(area.indexOf(key) > -1){
                                layer.msg('请选择区域');
                            }else {
                                layer.msg(body.find('[name="' + key + '"]').attr('placeholder'));
                            }
                            return;
                        }
                        if(key=="uuid"){
                            var uuid = data[key];
                            console.log("uuid"+uuid)
                            if(uuid!=""){
                                $.ajax({
                                    type: "POST",
                                    url: 'selectAirDevUUID',  //从数据库查询返回的是个list
                                    dataType: "json",
                                    data: {"uuid":uuid},
                                    async:false,
                                    success: function (data) {
                                        if(data.code==1){
                                            layer.msg("空调通讯地址已存在！");
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

                    // data.devType = '2';
                    // data.devPostion = data.room;
                    //
                    // console.log(data);
                    // var loading = layer.load(1, {shade: [0.1,'#fff']});
                    if(!status){
                        $.post('addAirDev',data,function (res) {
                            if(res.code > 0){
                                layer.close(index);
                                reloadTB();//重载表格
                                window.location.reload();
                            }
                            layer.msg(res.msg);
                        }).fail(function (xhr) {
                            layer.msg('添加失败 '+xhr.status);
                        }).always(function () {
                            // layer.close(loading);
                        })
                    }

                }
            })
        });

        //监听行工具事件
        table.on('tool(test)', function(obj){
            var data = obj.data;
            //console.log(obj)
            if(obj.event === 'del'){
                layer.confirm('请再次确认是否删除？', function(index){
                    var loading = layer.load(1, {shade: [0.1,'#fff']});
                    $.post('delAirDev',data,function (res) {
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
            }
            else if(obj.event === 'edit'){
                layer.open({
                    type:2
                    ,zIndex:999
                    ,title:'修改设备'
                    ,area: ['400px', '550px']
                    ,content: 'editAirDev'
                    ,btn:['确认','取消']
                    ,success:function (layero, index) {
                        var body = layer.getChildFrame('body', index);
                        var form1 = body.find('#form1');
                        console.log(data);
                        formUtilEL.fillFormData(form1,data);

                        // var childWindow = $(layero.find('iframe'))[0].contentWindow;
                        // childWindow.initModifyView(data);

                    },yes:function (index, layero) {
                        var body = layer.getChildFrame('body', index);
                        var form1 = body.find('#form1');
                        var data2 = formUtilEL.serializeObject(form1);
                        //删除无用信息
                        // delete data2.lineCount;
                        // delete data2.school;
                        // delete data2.house;
                        // delete data2.floor;
                        //
                        // data2.devSN = data.devSN;
                         console.log(data2);

                        var loading = layer.load(1, {shade: [0.1,'#fff']});
                        $.post('modifyDev',data2,function (res) {
                            if(res.code > 0){
                                layer.close(index);
                                reloadTB();//重载表格
                            }
                            layer.msg(res.msg);
                        }).fail(function (xhr) {
                            layer.msg('添加失败 '+xhr.status);
                        }).always(function () {
                            layer.close(loading);
                        })
                    }
                })
            }
            else if(obj.event === 'detail'){
                layer.open({
                    type: 2,
                    title: false,
                    area: ['1000px', '300px'],
                    shade: 0.8,
                    closeBtn: 0,
                    shadeClose: true,
                    content: 'airView?devId='+data.devId
                    ,success: function(layero, index) {
                        layer.iframeAuto(index);
                        /*var childWindow = $(layero.find('iframe'))[0].contentWindow;
                        childWindow.init(data);*/

                    }/*,yes:function (index, layero) {
                        var childWindow = $(layero.find('iframe'))[0].contentWindow;

                    }*/
                });
            }
        });
    });

    //设备搜索
    function searchDev(){
        var school=$("#school").find("option:selected").val();
        var house=$("#house").find("option:selected").val();
        var floor=$("#floor").find("option:selected").val();
        var room=$("#room").find("option:selected").val();
        var onLine=$("#onLine").find("option:selected").text();
        // var devId = $('#devID').val();
        // var devName = $('#devName').val();
        console.log("school"+school)
        console.log("house"+house)
        console.log("floor"+floor)
        console.log("room"+room)
        console.log("onLine"+onLine)


        tablezx = table.reloadExt('demo', {
            url: '/searchDev'
            ,where: {
                // devId:devId,
                // devName:devName,
                school:school,
                house:house,
                floor:floor,
                room:room,
                onLine:onLine
                // devType:"2"
            } //设定异步数据接口的额外参数
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
                school = data.elem[data.elem.selectedIndex].text
                console.log("school : " + school)
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
                house = data.elem[data.elem.selectedIndex].text
                console.log("house : " + house)
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
</script>
</html>
