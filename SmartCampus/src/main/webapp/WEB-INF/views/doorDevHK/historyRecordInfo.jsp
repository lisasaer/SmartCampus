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
    <title>历史人员刷卡记录</title>
    <jsp:include page="../header/res.jsp"></jsp:include>

    <%--    <link rel="stylesheet" href="css/layui.css" media="all">--%>
    <style>
        /*table表单去掉顶部样式(导入图标等)*/
        .layui-table-tool-self {
            display: none;
        }
        .layui-table-tool-temp {
            padding-right: 0;
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
        /* table表单去掉外边距*/
        .layui-table, .layui-table-view {
            margin: 0;
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
        /*修改table -box样式*/
        .layui-table-box {
            background-color: white;
            top: 12px;
            padding-left: 20px;
            padding-right: 20px;
        }
        /*去除垂直滚动条*/
        .layui-table-box ::-webkit-scrollbar {width: 0px; height: 0px;}
    </style>
</head>
<body>
<div class="layui-layout layui-layout-admin">
    <jsp:include page="../header/topHead.jsp"></jsp:include>

    <div class="layui-body" style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;">
        <!-- 内容主体区域 -->
        <div class="layui-body" style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;background-color: #e8ebee">
            <table id="demo" lay-filter="test" class="layui-hide"></table>
            <script type="text/html" id="toolbarDemo">
                <%--                <div class="layui-btn-container">--%>
                <div>
                    <div class="layui-inline">
                        <label >姓名</label>
                        <input type="text" id="staffName" placeholder="姓名" autocomplete="off" style="width: 100px;height: 30px;margin-right:10px;margin-left:10px;">
                    </div>

                    <div class="layui-inline">
                        <label >卡号</label>
                        <input type="text" id="cardNo" placeholder="卡号" autocomplete="off" style="width: 100px;height: 30px;margin-right:10px;margin-left:10px;">
                    </div>
                    <div class="layui-input-inline">
                        <label >校区</label>
                        <div class="layui-input-inline" >
                            <select id="school" name="school" lay-filter="selectSchool" title="校区选择" >
                                <option value="">全部</option>
                                <option value="0">无</option>
                                <c:forEach items="${schoolList}" var="item">
                                    <option value="${item.id}">${item.text}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="layui-input-inline">
                        <label >楼栋</label>
                        <div class="layui-input-inline" >
                            <select id="house" name="house" lay-filter="selectHouse" title="楼栋选择">
                                <option value="">全部</option>
                            </select>
                        </div>

                    </div>

                    <div class="layui-input-inline">
                        <label >楼层</label>
                        <div class="layui-input-inline" >
                            <select id="floor" name="floor" lay-filter="selectFloor" title="楼层选择">
                                <option value="">全部</option>
                            </select>
                        </div>

                    </div>

                    <div class="layui-input-inline">
                        <label >房号</label>
                        <div class="layui-input-inline" >
                            <select id="room" name="room" lay-filter="selectRoom" title="房号选择">
                                <option value="">全部</option>
                            </select>
                        </div>

                    </div>
                    日期时间
                    <div class="layui-inline">
                        <input type="text" class="layui-input" id="startTime" autocomplete="off" placeholder="请输入开始时间" style="width: 150px;height: 30px;margin-right:10px;margin-left:10px;">
                    </div>至
                    <div class="layui-inline">
                        <input type="text" class="layui-input" id="endTime" autocomplete="off" placeholder="请输入结束时间" style="width: 150px;height: 30px;margin-right:10px;margin-left:10px;">
                    </div>
                    <button id="btnQuery" class="layui-btn" onclick="query()" style="height: 30px;line-height: 0px;">查询</button>
                    <button id="btnClear" class="layui-btn" style="height: 30px;line-height: 0px;">重置</button>
<%--                    <button id="btnReload" class="layui-btn" style="height: 30px;line-height: 0px;">刷新</button>--%>
                </div>
                <%--                    <button class="layui-btn layui-btn-sm" lay-event="delete">批量删除</button>--%>
                <%--                </div>--%>
            </script>

            <script type="text/html" id="barDemo">
                <a lay-event="detail" style="margin-left: 20px"><img src="../../res/layui/images/dev_icon/detail_icon.png"></a>
                <%--                <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>--%>
            </script>

        </div>
    </div>

</div>

<script>
    leftThis('历史记录');
    var table;
    var laydate;
    layui.use(['table', 'laydate', 'element'], function () {
        table = layui.table
            , $ = layui.jquery
            , laydate = layui.laydate
            , element = layui.element;

        $(document).ready(function () {
            $("#li7").addClass("layui-this");
            $("#d1").addClass("layui-this");
        });

        laydate.render({
            elem: '#startTime'
            ,type: 'datetime'
            ,trigger : 'click'
        });
        laydate.render({
            elem: '#endTime'
            ,type: 'datetime'
            ,trigger : 'click'
        });

        table.render({
            elem: '#demo'
            , toolbar: '#toolbarDemo'
            , height: 'full-95'
            , url: 'searchHistoryRecord' //数据接口
            , page: true //开启分页
            , cols: [[ //表头
                // {type: 'checkbox', fixed: 'left'}
                {type: 'numbers', title: '序号',width: 65}
                ,{field: 'id', title: 'ID', style:'display:none',width:1}
                , {field: 'schoolName', title: '校区', width: 120,align: 'center'}
                , {field: 'houseName', title: '楼栋', width: 120,align: 'center'}
                , {field: 'floorName', title: '楼层', width: 120,align: 'center'}
                , {field: 'roomName', title: '房号', width: 120,align: 'center'}
                , {field: 'staffId', title: '编号', width: 150,align: 'center'}
                , {field: 'staffName', title: '姓名', width: 170,align: 'center'}
                , {field: 'cardNo', title: '卡号', width: 170,align: 'center'}
                , {field: 'strAlarmTime', title: '刷卡时间', width: 170,align: 'center'}
                , {field: 'devIP', title: '设备IP', width: 170,align: 'center'}
                // , {field: 'dname', title: '所属部门', width: '10%',align: 'center'}
                , {field: 'imagePath', title: '抓拍图片', width:162,align: 'center',templet:'#img',event:'previewImg'}
                , {field: 'right', title: '操作', toolbar: '#barDemo', width: 100,align: 'center'}
            ]],

            // page:true,
            limits:[5,10,15,20,30,50],
            limit:2,
            done: function(res, curr, limit ,count){
                _cur_page =curr;
                _cur_limit = limit;
                $('[data-field="id"]').addClass('layui-hide');
            }
            ,where:{
                recordType:'2'//1-当天记录;2-历史记录
            }

        });
        //人员管理日期时间范围选择
        layui.use('laydate', function(){
            var $ = layui.$;
            var laydate = layui.laydate;
            //默认开始时间：当天00:00:00
            var nowTime1 = DateUtil.dateformat(new Date().setDate(new Date().getDate()),"yyyy-MM-dd") + " 00:00:00";
            //默认结束时间：当天23:59:59
            var nowTime2 = DateUtil.dateformat(new Date().setDate(new Date().getDate()),"yyyy-MM-dd") + " 23:59:59";
            var max = null;
            //执行一个laydate实例
            var start = laydate.render({
                elem: '#startTime',//指定元素
                type: 'datetime',
                value: nowTime1,//默认时间
                isInitValue: true,//是否允许填充初始值，默认为 true
                btns: ['clear', 'now', 'confirm'],//右下角显示的按钮，会按照数组顺序排列，内置可识别的值有：clear、now、confirm
                done: function(value, date){
                    endMax = end.config.max;
                    end.config.min = date;
                    end.config.min.month = date.month -1;
                },
                change: function(value, date, end){
                    var timestamp2 = Date.parse(new Date(value));
                    timestamp2 = timestamp2 / 1000;
                    end.config.min = timestamp2;
                    end.config.min.month = date.month -1;
                }
            });

            var end = laydate.render({
                elem: '#endTime',
                type: 'datetime',
                value: nowTime2,
                isInitValue: true,//是否允许填充初始值，默认为 true
                done: function(value, date){
                    console.log(" ====== "+date);
                    if($.trim(value) == ''){
                        var curDate = new Date();
                        date = {'date': curDate.getDate(), 'month': curDate.getMonth()+1, 'year': curDate.getFullYear()};
                    }
                    start.config.max = date;
                    start.config.max.month = date.month -1;
                    //获取value的值
                    var nDate = new Date(value);
                    console.log(nDate);
                    //获取当前输入时间的时分秒
                    var hours = nDate.getHours();
                    var minutes = nDate.getMinutes();
                    var seconds = nDate.getSeconds();
                    //若时分秒都为0时，结束时间初始化为：指定日期+23:59:59
                    if (hours == "0" && minutes == "0" && seconds == "0"){
                        $(".layui-laydate-footer [lay-type='datetime'].laydate-btns-time").click();
                        $(".laydate-main-list-0 .layui-laydate-content li ol li:last-child").click();
                        $(".layui-laydate-footer [lay-type='date'].laydate-btns-time").click();
                    }
                },

            });
        });
        //监听行工具事件
        table.on('tool(test)', function (obj) {
            var data = obj.data;//获取当前行的数据
            if (obj.event === 'del') {
                layer.confirm('是否删除记录ID为' + data.id+'的数据', function (index) {
                    $.ajax({
                        url: "/deleteRecord",
                        type: "POST",
                        data: {"id": data.id},
                        success: function () {
                            //删除这一行
                            obj.del();
                            //关闭弹框
                            layer.close(index);
                            layer.msg("删除成功", {icon: 6});
                        },
                        error: function () {
                            layer.alert("删除失败");
                        },
                    });
                    return false;
                });

            }else if(obj.event === "detail"){
                layer.open({
                    type: 2,
                    zIndex:999,
                    title: '详情',
                    area: ['670px', '380px'],
                    btn: ['返回'],
                    content: 'recordHistoryView?id='+data.id
                    ,success: function(layero, index) {
                        layer.iframeAuto(index);
                    }
                });
            }else if(obj.event === "previewImg"){
                layer.open({
                    type: 1,
                    title: false,
                    area: ['auto'],
                    closeBtn:0,
                    skin:'layui-layer-nobg',//没有背景色
                    shadeClose:true,
                    content:'<img src = "'+data.imagePath+'">'
                });
            }
        });

        //监听事件
        table.on('toolbar(test)', function (obj) {
            var checkStatus = table.checkStatus(obj.config.id);
            switch (obj.event) {
                // case 'add':
                //     layer.msg('添加');
                //     window.location.href = 'addStaffView';
                //     break;
                case 'delete':
                    var data = checkStatus.data;
                    layer.confirm('是否删除所选行', function (index) {
                        $.ajax({
                            url: "/delSomeRecord",
                            type: "POST",
                            contentType: "application/json;charset=UTF-8",//指定消息请求类型
                            data: JSON.stringify(data),
                            success: function () {
                                table.reload({
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
                        return false;
                    });
                    break;
            }
        });
        // $.ajax({
        //     type: "POST",
        //     url: 'getDepartmentName',  //从数据库查询返回的是个list
        //     dataType: "json",
        //     success: function (data) {
        //         $.each(data, function (index, item) {
        //             console.log("查询到的item.dname:"+item.dname);
        //             $('#dName').append(new Option(item.dname));//往下拉菜单里添加元素
        //         })
        //         // layui.form.render("select");
        //     }, error: function () {
        //         alert("查询dName失败！！！")
        //     }
        // })

        //刷新按钮
        //
        // $('#btnReload').click(function () {
        //     var staffName = "";
        //     var staffId = "";
        //     var cardNo = "";
        //     // var dName = "";
        //     var startTime = "";
        //     var endTime = "";
        //     // alert("limit:"+ table_name.config.limit +"; "+"page:"+_cur_page);
        //     table.reload('demo', {
        //         url: 'searchHistoryRecord'
        //         ,where: {
        //             staffName:staffName,
        //             staffId:staffId,
        //             cardNo:cardNo,
        //             // dName:dName,
        //             startTime:startTime,
        //             endTime:endTime/*,
        //             limit:table_name.config.limit*/
        //         } //设定异步数据接口的额外参数
        //         ,page: {
        //             curr: 1 //重新从第 1 页开始
        //         }
        //     });
        //     return false;
        // });
        //重置按钮
        $('body').on('click','#btnClear',function(){
            $('#startTime').val('');
            $('#endTime').val('');
            $('#staffName').val('');
            // $('#staffId').val('');
            $('#cardNo').val('');
            $('#school').val('');
            $('#house').val('');
            $('#floor').val('');
            $('#room').val('');
            query();
            return false;
        });
    });

    //查询记录
    function query(){
        console.log("查询")
        var staffName = $('#staffName').val();
        // var staffId = $('#staffId').val();
        var cardNo = $('#cardNo').val();
        var schoolId = $('#school').val();
        var houseId = $('#house').val();
        var floorId = $('#floor').val();
        var roomId = $('#room').val();
        var startTime = $('#startTime').val();
        var endTime = $('#endTime').val();
        table.reloadExt('demo', {
            url: 'searchHistoryRecord'
            ,where: {
                staffName:staffName,
                // staffId:staffId,
                cardNo:cardNo,
                schoolId:schoolId,
                houseId:houseId,
                floorId:floorId,
                roomId:roomId,
                startTime:startTime,
                endTime:endTime
            } //设定异步数据接口的额外参数
            ,page: {
                curr: 1 //重新从第 1 页开始
            }
        });

        laydate.render({
            elem: '#startTime'
            ,type: 'datetime'
            ,trigger : 'click'
        });
        laydate.render({
            elem: '#endTime'
            ,type: 'datetime'
            ,trigger : 'click'
        });

    }



</script>
<script type="text/html" id="img">
    <div><img src="{{d.imagePath}}" style="width:30px;height:30px"></div>
</script>


<script>
    var form ;
    layui.use('form', function(){
        form = layui.form;
        //监听下拉框选中事件
        $(function () {

            var school;
            var house;
            var floor;
            var room;
            //校区下拉框选中点击
            form.on('select(selectSchool)', function (data) {

                var select = $(data.elem);
                var id =select.val();
                if(id==0){
                    $('[name="house"]').html('<option value="0">无</option>');
                    $('[name="floor"]').html('<option value="0">无</option>');
                    $('[name="room"]').html('<option value="0">无</option>');
                    form.render('select');
                }
                if(id==""){
                    $('[name="house"]').html('<option value="">全部</option>');
                    $('[name="floor"]').html('<option  value="">全部</option>');
                    $('[name="room"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        $('[name="house"]').html('<option value="">全部</option>');
                        $('[name="house"]').append('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="house"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="floor"]').html('<option value="">全部</option>');
                        $('[name="room"]').html('<option value="">全部</option>');
                        form.render('select');
                    })
                }
                school = $('[name="school"]').val();
                console.log("校区下拉框选中点击"+school)
            });
            //楼栋下拉框选中点击
            form.on('select(selectHouse)', function (data) {
                var select = $(data.elem);
                var id =select.val();
                if(id==0){
                    $('[name="floor"]').html('<option value="0">无</option>');
                    $('[name="room"]').html('<option value="0">无</option>');
                    form.render('select');
                }
                if(id==""){
                    $('[name="floor"]').html('<option  value="">全部</option>');
                    $('[name="room"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        $('[name="floor"]').html('<option value="">全部</option>');
                        $('[name="floor"]').append('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="floor"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="room"]').html('<option value="">全部</option>');
                        form.render('select');
                    })
                }

                house = $('[name="house"]').val();
            });
            //楼层下拉框选中点击
            form.on('select(selectFloor)', function (data) {

                var select = $(data.elem);
                var id =select.val();
                if(id==0){
                    $('[name="room"]').html('<option value="0">无</option>');
                    form.render('select');
                }
                if(id==""){
                    $('[name="room"]').html('<option  value="">全部</option>');
                    form.render('select');
                }
                if(id!=0) {
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        $('[name="room"]').html('<option value="">全部</option>');
                        $('[name="room"]').append('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="room"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        form.render('select');
                    })
                }


                floor =  $('[name="floor"]').val();
            });
            form.on('select(selectRoom)', function (data) {
                room =  $('[name="room"]').val();
            });
        });
    });

</script>
</body>
</html>