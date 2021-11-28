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
    <title>当天人员刷卡记录</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <link rel="stylesheet" type="text/css" media="all" href="res/test/css/styles.css">
    <script type="text/javascript" src="res/test/js/jquery-1.11.0.min.js"></script>
    <script type="text/javascript" src="res/test/js/responsiveCarousel.min.js"></script>
    <%--    <link rel="stylesheet" href="css/layui.css" media="all">--%>
    <style>
        /*table表单去掉顶部样式(导入图标等)*/
        .layui-table-tool-self {
            display: none;
        }
        /*去除table表单外边距*/
        .layui-table, .layui-table-view {
            margin: 0;
        }
        .layui-table-tool-temp {
            padding-right: 0;
        }
        /*table表单主体*/
        .layui-table-box{
            background-color: white;
            top: 12px;
            padding-left: 20px;
            padding-right: 20px;
        }
        .layui-table-box ::-webkit-scrollbar {width: 0px; height: 0px;}

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
            /*width: 80px;*/
            /*line-height: 32px;*/
            background-color: #1666f9;
            /*height: 32px;*/
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
    </style>
</head>
<body>
<div class="layui-layout layui-layout-admin">
    <jsp:include page="../header/topHead.jsp"></jsp:include>

    <div class="layui-body"style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;background-color: #e8ebee">
        <!-- 内容主体区域 -->

        <div <%--style="padding: 15px;"--%>>
            <%--            <form class="layui-form">--%>

            <script type="text/javascript">
                $(function(){
                    $('.crsl-items').carousel({
                        visible: 6,             //一个页面显示最多几张图
                        itemMinWidth: 120,        //一张图最小宽度
                        itemEqualHeight: 100,
                        itemMargin: 40,
                    });

                    $("a[href=#]").on('click', function(e) {
                        e.preventDefault();
                    });
                });
            </script>

            <table id="demo" lay-filter="test" class="layui-hide"></table>
            <%--            </div>--%>

            <script type="text/html" id="toolbarDemo">
                姓名
                <div class="layui-inline">
                    <input type="text" class="layui-input" id="staffName" autocomplete="off" placeholder="姓名" style="width: 100px;height: 30px;margin-right:5px;margin-left:5px;">
                </div>
                卡号
                <div class="layui-inline">
                    <input type="text" class="layui-input" id="cardNo" autocomplete="off" placeholder="卡号" style="width: 120px;height: 30px;margin-right:5px;margin-left:5px;">
                </div>
                <div class="layui-input-inline">
                    <label >校区</label>
                    <div class="layui-input-inline" >
                        <select id="school" name="school" lay-filter="selectSchool" title="校区选择">
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
                时间范围
                <div class="layui-inline">
                    <input type="text" class="layui-input" id="time" autocomplete="off" placeholder="请输入时间" style="width: 180px;height: 30px;margin-right:5px;margin-left:5px;">
                </div>
                <%--            至--%>
                <%--                <div class="layui-inline">--%>
                <%--                    <input type="text" class="layui-input" id="endTime" autocomplete="off" placeholder="请输入结束时间" style="width: 300px;height: 34px;margin-right:10px;margin-left:10px;">--%>
                <%--                </div>--%>
                <button id="btnQuery" class="layui-btn" onclick="query()" style="height: 30px;line-height: 0px;">查询</button>
                <button id="btnClear" class="layui-btn" style="height: 30px;line-height: 0px;">重置</button>
<%--                <button id="btnReload" class="layui-btn" style="height: 30px;line-height: 0px;">刷新</button>--%>

                <%--            </form>--%>
                <%---------------------------------------------------------------------------------------------%>

                <div style="margin-left: 48px;width: 1520px;">
                    <div id="w">
                        <div class="crsl-items layui-row" data-navigation="navbtns">

                            <div class="crsl-wrap" id="detailRecord">
                                <c:forEach items="${listNewTenRecord}" var="item" varStatus="i">
                                    <div class="crsl-item" style="position: relative;float: left;overflow: hidden;width: 240px;margin-left: 5px;margin-right: 5px;height: 140px;">
                                        <div  style="float: left;margin-bottom: 0px">
                                            <div class="thumbnail" style="margin-bottom: 5px;">
                                                <img id="picture" src="${item.imagePath}" <%--alt="nyc subway" lay-event="previewImg" --%>style="width: 80px;height: 100px">
                                                <span class="postdate" style="padding: 0px">${item.strAlarmTime}</span>
                                            </div>
                                            <div>
                                                <a id="btnDetail" class="layui-btn layui-btn-primary layui-btn-xs" type="button" value="${item.id}">详情</a>
                                            </div>
                                        </div>

                                        <div style="margin-left: 90px;padding-top: 5px;width: 134px;">
                                            <h3><p> 校 区：${item.schoolName}</p></h3>
                                            <h3><p> 楼 栋：${item.houseName}</p></h3>
                                            <h3><p> 楼 层：${item.floorName}</p></h3>
                                            <h3><p> 房 号：${item.roomName}</p></h3>
                                            <h3><p> 姓 名：${item.staffName}</p></h3>
                                            <h3><p> 工 号：${item.staffId}</p></h3>
                                            <h3><p> 卡 号：${item.cardNo}</p></h3>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </script>

            <script type="text/html" id="barDemo">
                <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail">详情</a>
                <%--                <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>--%>
            </script>

        </div>
    </div>
</div>

<script>
    leftThis('实时监测');
    var table;
    var id;
    var $;
    var laydate;
    layui.use(['table', 'element'], function () {
        table = layui.table
            , $ = layui.jquery
            , laydate = layui.laydate
            , element = layui.element;

        $(document).ready(function () {
            $("#li7").addClass("layui-this");
            $("#d1").addClass("layui-this");
        });

        laydate.render({
            elem: '#time'
            // ,value: "09:00:00 - 21:00:00"//默认时间
            ,type: 'time'
            ,range: true
            ,trigger : 'click'
        });

        // websocket
        $(function () {

            console.log(window.location.hostname, window.location.port);
            WebSocketTest('recordWSL');
        });

        function WebSocketTest(wsPath) {
            if ("WebSocket" in window) {
                //alert("您的浏览器支持 WebSocket!");

                var hostName = window.location.hostname;
                var port = window.location.port;

                // 打开一个 web socket
                var ws = new WebSocket("ws://" + hostName + ":" + port + "/" + wsPath);
                ws.onopen = function () {
                    // Web Socket 已连接上，使用 send() 方法发送数据
                    console.log('ws 已连接');

                    //ws.send("发送数据");
                    //alert("数据发送中...");
                };

                ws.onmessage = function (evt) {
                    var received_msg = evt.data;
                    console.log(received_msg);
                    // window.location.reload();
                    var data = JSON.parse(received_msg);
                    //table.reload('demo');
                    $.ajax({
                        url: "/getRealTimeData",
                        type: "POST",
                        // data: {"iconCls": node.iconCls,"id":node.id},
                        dataType: "json",
                        success: function (res) {

                            $.each(res.data,function (index,item) {
                                console.log(index+item);
                            })
                            table.render({
                                id: 'demo',
                                elem: '#demo'
                                , toolbar: '#toolbarDemo'
                                , height: 'full-95'
                                , data: res.data
                                , page: true //开启分页
                                , cols: [[ //表头
                                    // {type: 'checkbox', fixed: 'left'}
                                    {type: 'numbers', title: '序号'/*, fixed: 'left'*/}
                                    ,{field: 'id', title: 'ID',width:1}
                                    , {field: 'schoolName', title: '校区', width: 120,align: 'center'}
                                    , {field: 'houseName', title: '楼栋', width: 120,align: 'center'}
                                    , {field: 'floorName', title: '楼层', width: 120,align: 'center'}
                                    , {field: 'roomName', title: '房号', width: 120,align: 'center'}
                                    , {field: 'staffId', title: '编号', width: 160,align: 'center'}
                                    , {field: 'staffName', title: '姓名', width: 160,align: 'center'}
                                    , {field: 'cardNo', title: '卡号', width: 160,align: 'center'}
                                    , {field: 'strAlarmTime', title: '刷卡时间', width: 160,align: 'center'}
                                    , {field: 'devIP', title: '设备IP', width: 160,align: 'center'}
                                    // , {field: 'dname', title: '所属部门', width: '10%',align: 'center'}
                                    , {field: 'imagePath', title: '抓拍图片', width: 160,align: 'center',templet:'#img',event:'previewImg'}
                                    , {fixed: 'right', title: '操作', toolbar: '#barDemo', width:120,align: 'center'}
                                ]],

                                page:true,
                                //limits:[5,10,15,20,30,50],
                                limit:20,
                                done: function(res, curr, limit ,count){
                                    _cur_page =curr;
                                    _cur_limit = limit;
                                    $('[data-field="id"]').addClass('layui-hide');
                                }
                                ,where:{
                                    recordType:'1'//1-当天记录;2-历史记录
                                }
                            });
                        }
                    });

                    $.ajax({
                        type: "POST",
                        url: 'getLatestSixRecords',  //从数据库查询返回的是个list
                        dataType: "json",
                        success: function (data) {
                            var str="";
                            $.each(data,function (index,item) {
                                // console.log(index+item);
                                str +=' <div class="crsl-item" style="position: relative;float: left;overflow: hidden;width: 240px;margin-left: 5px;margin-right: 5px;height: 140px;">';
                                str +='  <div  style="float: left;margin-bottom: 0px">';
                                str +=' <div class="thumbnail" style="margin-bottom: 5px;">';
                                str +=' <img id="picture" src='+item.imagePath+' style="width: 80px;height: 100px">';

                                str +=' <span class="postdate" style="padding: 0px">'+item.strAlarmTime;
                                str +=' </span>';
                                str +=' </div>';
                                str +=' <div>';
                                str +=' <a id="btnDetail" class="layui-btn layui-btn-primary layui-btn-xs" type="button" value='+item.id+'>详情</a>';
                                str +=' </div>';
                                str +=' </div>';

                                str +=' <div style="margin-left: 90px;padding-top: 5px;width: 134px;">';
                                str +=' <h3><p> 校 区：'+item.schoolName;
                                str +=' </p></h3>';
                                str +=' <h3><p> 楼 栋：'+item.houseName;
                                str +=' </p></h3>';
                                str +=' <h3><p> 楼 层：'+item.floorName;
                                str +=' </p></h3>';
                                str +=' <h3><p> 房 号：'+item.roomName;
                                str +=' </p></h3>';
                                str +=' <h3><p> 姓 名：'+item.staffName;
                                str +=' </p></h3>';
                                str +=' <h3><p> 工 号：'+item.staffId;
                                str +=' </p></h3>';
                                str +=' <h3><p> 卡 号：'+item.cardNo;
                                str +=' </p></h3>';
                                str +=' </div>';
                                str +=' </div>';
                            })
                            // console.log(str);
                            $('#detailRecord').html(str);
                        }
                    })

                };

                ws.onclose = function () {
                    // 关闭 websocket
                    console.log("连接已关闭...");
                };
            } else {
                // 浏览器不支持 WebSocket
                console.log("您的浏览器不支持 WebSocket!");
            }
        }

        table.render({
            id: 'demo',
            elem: '#demo'
            , toolbar: '#toolbarDemo'
            , height: 'full-95'
            , url: 'searchRealRecord' //数据接口
            , page: true //开启分页
            , cols: [[ //表头
                // {type: 'checkbox', fixed: 'left'}
                {type: 'numbers', title: '序号'/*, fixed: 'left'*/}
                ,{field: 'id', title: 'ID',width:1}
                , {field: 'schoolName', title: '校区', width: 120,align: 'center'}
                , {field: 'houseName', title: '楼栋', width: 120,align: 'center'}
                , {field: 'floorName', title: '楼层', width: 120,align: 'center'}
                , {field: 'roomName', title: '房号', width: 120,align: 'center'}
                , {field: 'staffId', title: '编号', width: 160,align: 'center'}
                , {field: 'staffName', title: '姓名', width: 160,align: 'center'}
                , {field: 'cardNo', title: '卡号', width: 160,align: 'center'}
                , {field: 'strAlarmTime', title: '刷卡时间', width: 160,align: 'center'}
                , {field: 'devIP', title: '设备IP', width: 160,align: 'center'}
                // , {field: 'dname', title: '所属部门', width: '10%',align: 'center'}
                , {field: 'imagePath', title: '抓拍图片', width: 160,align: 'center',templet:'#img',event:'previewImg'}
                , {fixed: 'right', title: '操作', toolbar: '#barDemo', width:120,align: 'center'}
            ]],

            page:true,
            //limits:[5,10,15,20,30,50],
            limit:20,
            done: function(res, curr, limit ,count){
                _cur_page =curr;
                _cur_limit = limit;
                $('[data-field="id"]').addClass('layui-hide');
            }
            ,where:{
                recordType:'1'//1-当天记录;2-历史记录
            }
        });
        //人员管理日期时间范围选择
        layui.use('laydate', function(){
            var $ = layui.$;
            var laydate = layui.laydate;
            //默认开始时间：当天00:00:00
            // var nowTime1 = DateUtil.dateformat(new Date().setDate(new Date().getDate()),"yyyy-MM-dd") + " 00:00:00";
            // //默认结束时间：当天23:59:59
            // var nowTime2 = DateUtil.dateformat(new Date().setDate(new Date().getDate()),"yyyy-MM-dd") + " 23:59:59";
            // var max = null;
            //执行一个laydate实例

            laydate.render({
                elem: '#time'
                ,value: "09:00:00 - 21:00:00"//默认时间
                ,type: 'time'
                ,range: true
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
                    content: 'recordView?id='+data.id
                    ,success: function(layero, index) {

                        layer.iframeAuto(index);
                    }
                });
            }else if(obj.event === "previewImg"){
                console.log(data.imagePath);
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
                // case 'detail':
                //     var data = checkStatus.data;
                //     console.log(data);
                //
                //     break;
                // case 'delete':
                //     var data = checkStatus.data;
                //     layer.confirm('是否删除所选行', function (index) {
                //         $.ajax({
                //             url: "/delSomeRecord",
                //             type: "POST",
                //             contentType: "application/json;charset=UTF-8",//指定消息请求类型
                //             data: JSON.stringify(data),
                //             success: function () {
                //                 table.reload({
                //                     method: 'post'
                //                     , page: {
                //                         curr: 1
                //                     }
                //                 });
                //                 layer.msg("删除成功", {icon: 6});
                //             },
                //             error: function () {
                //                 layer.alert("删除失败");
                //             },
                //         });
                //         return false;
                //     });
                //     break;
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

        // $('#btnReload').click(function () {
        //     var staffName = "";
        //     var staffId = "";
        //     var cardNo = "";
        //     var dName = "";
        //     var startTime = "";
        //     var endTime = "";
        //
        //     // alert("limit:"+ table_name.config.limit +"; "+"page:"+_cur_page);
        //     table.reload('demo', {
        //         url: 'searchRealRecord'
        //         ,where: {
        //             staffName:staffName,
        //             staffId:staffId,
        //             cardNo:cardNo,
        //             dName:dName,
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
            // $('#startTime').val('');
            // $('#endTime').val('');
            $('#staffName').val('');
            // $('#staffId').val('');
            $('#cardNo').val('');
            // $('#dName').val('');
            $('#time').val('');
            $('#school').val('');
            $('#house').val('');
            $('#floor').val('');
            $('#room').val('');
            query();
            return false;
        });

        //轮播详情按钮
        $('body').on('click','a[id=\'btnDetail\']',function(){
            // $("a[id='btnDetail']").click(function (data) {
            var id = $(this).attr('value');
            console.log("ID",id);
            layer.open({
                type: 2,
                zIndex:999,
                title: '详情',
                area: ['670px', '380px'],
                btn: ['返回'],
                content: 'recordView?id='+id
                ,success: function(layero, index) {

                    layer.iframeAuto(index);
                }
            });
        });

        $('body').on('click','img[id=\'picture\']',function(){
            console.log("++++++++++++++++++++++++++++")
            var path = $(this).attr('src');
            console.log("path",path);
            layer.open({
                type: 1,
                title: false,
                area: ['auto'],
                closeBtn:0,
                skin:'layui-layer-nobg',//没有背景色
                shadeClose:true,
                content:'<img src = "'+path+'">'
            });
        })
        // $("img[id='picture']").click(function () {
        //     console.log("-------------------------------")
        //     var path = $(this).attr('src');
        //     console.log("path",path);
        //     layer.open({
        //         type: 1,
        //         title: false,
        //         area: ['auto'],
        //         closeBtn:0,
        //         skin:'layui-layer-nobg',//没有背景色
        //         shadeClose:true,
        //         content:'<img src = "'+path+'">'
        //     });
        // });


    });

    //查询记录
    function query(){
        console.log("查询")
        var staffName = $('#staffName').val();
        // var staffId = $('#staffId').val();
        var cardNo = $('#cardNo').val();
        // var dName = $('#dName').val();
        var schoolId = $('#school').val();
        var houseId = $('#house').val();
        var floorId = $('#floor').val();
        var roomId = $('#room').val()

        var time = $('#time').val();
        var startTime;
        var endTime;
        if(time!=""){
            var s = " " + time.substring(0,8);
            var e = " " + time.substring(11,19);
            var date = DateUtil.dateformat(new Date().setDate(new Date().getDate()),"yyyy-MM-dd");
            //alert("time:"+time);
            startTime = date.concat(s);
            endTime = date.concat(e);
            console.log(endTime);
            console.log(startTime);
            console.log(date);
        }


        table.reloadExt('demo', {
            url: 'searchRealRecord'
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
            elem: '#time'

            ,type: 'time'
            ,range: true
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
            console.log("查看1")
            var school;
            var house;
            var floor;
            var room;
            //校区下拉框选中点击
            // $("#school").click(function (data) {
            //
            // })
            form.on('select(selectSchool)', function (data) {
                // var value = $("option").val();
                // if(value!=""){
                //     $(".layui-input-inline select option[value='" + value + "']").css({'color': "#000000"});
                // }
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