<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2019/5/29
  Time: 20:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>权限下发</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        #ul .layui-transfer-data {
            height: 260px;
        }
        .layui-transfer-box{
            width: 40%;
        }
        /*去除table表单外边距*/
        .layui-table, .layui-table-view {
            margin: 0;
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
    </style>

</head>
<body>
<div class="layui-layout layui-layout-admin">
    <jsp:include page="../header/topHead.jsp"></jsp:include>

    <div class="layui-body" style="bottom: 0px;width: 1690px;height: 900px;margin-left: 25px;margin-top: 4px;">
        <!-- 内容主体区域 -->
        <div style="padding-top: 15px;padding-left: 15px;padding-right: 15px;">
            <div class="layui-row">
                <div style="float: left;border-width: 1px;border-style: solid;height: 400px;border-color: #e6e6e6;">
                    <div style="height: 30px; background: #d5d9e2">
                        <label class="layui-form-label" style="padding: 5px;">人员选择</label>
                    </div>
                    <div style="width: 250px; height: 363px;  margin-top: 5px; overflow-y: auto">
                        <ul id="tree1" > </ul>
                    </div>
                </div>
                <div style=" height: 400px;float: left;margin-left: 30px;margin-bottom: 5px; border-width: 1px; border-style: solid;border-color: #e6e6e6;">
                    <div style="padding: 5px;">
                        <div style="height: 30px">
                            <label>人员信息</label>
                        </div>
                        <div style="margin-top: 5px;">
                            <label >请输入关键字:</label>
                            <div class="layui-inline">
                                <input  type="text" id="staff" placeholder="请输入姓名/编号/卡号"  autocomplete="off" style="width: 150px;height: 30px;margin-right:10px;margin-left:10px;">
                            </div>
                            <label >人员类型</label>
                            <div class="layui-input-inline" >
                                <select id="personType" name="personType" lay-filter="selectRoom" title="人员类型">
                                    <option value="">全部</option>
                                    <option value="student">学生</option>
                                    <option value="teacher">教师</option>
                                    <option value="other">其他</option>
                                </select>
                            </div>
                            <button id="btnStaffQuery" class="layui-btn layui-btn-sm" onclick="queryStaff()">查询</button>
                            <button id="btnStaffClear" class="layui-btn layui-btn-sm" <%--style="height: 30px;line-height: 0px;"--%>>重置</button>
                            <button id="query" class="layui-btn layui-btn-sm">权限查看</button>
                        </div>
                    </div>
                    <div>
                        <div class="table_1" style="float: left;margin-left: 5px;margin-bottom: 5px">
                            <table id="table1" lay-filter="demo1">候选人员</table>
                        </div>

                        <div class="button_transfer1"  style="float: left;padding: 14px; padding-top: 130px;margin-left: 20px" >
                            <div><button id="move1" type="button" class="layui-btn layui-btn-sm " lay-event="transfer1"><i class="layui-icon">&#xe65b;</i></button></div><br>
                            <div><button id="move2" type="button" class="layui-btn layui-btn-sm layui-btn-danger" ><i class="layui-icon">&#xe65a;</i></button></div>
                        </div>

                        <div class="table_2" style="float: left;margin-left: 20px;margin-right: 5px">
                            <table id="table2" lay-filter="demo2">已选人员</table>
                        </div>
                    </div>
                </div>
            </div>
            <div style="margin-top: 5px;height:405px">
                <div style="float: left; border-width: 1px;border-style: solid;height: 400px;border-color: #e6e6e6;">
                    <div style="height: 30px; background: #d5d9e2">
                        <label class="layui-form-label" style="padding: 5px;">门选择</label>
                    </div>
                    <div  style="width: 250px; height: 363px;  margin-top: 5px; overflow-y: auto">
                        <ul id="tree2" > </ul>
                    </div>
                </div>

                <div style=" height: 400px;float: left;margin-left: 30px;margin-bottom: 5px; border-width: 1px; border-style: solid;border-color: #e6e6e6;">
                    <div style="padding: 5px;">
                        <div style="height: 30px">
                            <label>门信息</label>
                        </div>
                        <div style="margin-top: 5px;">
                            <label >门名称/ID:</label>
                            <div class="layui-inline">
                                <input type="text" id="dev" placeholder="门名称/ID" style="width: 100px;height: 30px;margin-right:10px;margin-left:10px" autocomplete="off">
                            </div>

                            <button id="btnDoorQuery" class="layui-btn layui-btn-sm" onclick="queryDoor()">查询</button>
                            <button id="btnDoorClear" class="layui-btn layui-btn-sm">重置</button>
                        </div>
                    </div>
                    <div>
                        <div style="float: left;margin-left: 5px;margin-bottom: 5px">
                            <table id="table3" lay-filter="demo1">候选门</table>
                        </div>

                        <div class="button_transfer1"  style="float: left;padding: 14px; padding-top: 130px;margin-left: 20px" >

                            <div><button id="move3" type="button" class="layui-btn layui-btn-sm " lay-event="transfer1"><i class="layui-icon">&#xe65b;</i></button></div><br>
                            <div><button id="move4" type="button" class="layui-btn layui-btn-sm layui-btn-danger" ><i class="layui-icon">&#xe65a;</i></button></div>
                        </div>

                        <div style="float: left;margin-left: 20px;margin-right: 5px">
                            <table id="table4" lay-filter="demo2">已选门</table>
                        </div>
                    </div>

                </div>

            </div>
            <div style="text-align: center">
                <button style="width: 200px" type="button" lay-submit class="layui-btn layui-btn-fluid layui-bg-orange"
                        lay-filter="#">禁止权限
                </button>
                <button style="width: 200px" type="button" lay-submit class="layui-btn layui-btn-fluid layui-bg-green"
                        lay-filter="*">下发权限
                </button>

            </div>
        </div>
    </div>
</div>

<script>
    var table;
    var staffTreeIconCls;
    var staffTreeId;
    var doorTreeIconCls;
    var doorTreeId;
    var staffList1 = new Array();
    var staffList2 = new Array();
    var doorList1 = new Array();
    var doorList2 = new Array();
    function submit() {
    }
    //水平导航栏选中显示
    $(document).ready(function () {
        $("#li5").addClass("layui-this");
    });
    $('#tree1,#tree2').tree({
        url:'getTreeVideoData',
    });

    //查询按钮
    function queryStaff() {
        var name = $('#staff').val();
        var staffId = $('#staff').val();
        var cardNo = $('#staff').val();
        var personType = $('#personType').val();

        table.reload('table1', {
            url: 'queryStaffTree'
            ,where: {
                name:name,
                staffId:staffId,
                cardNo:cardNo,
                personType:personType,
                staffTreeIconCls:staffTreeIconCls,
                staffTreeId:staffTreeId
            }
            ,done: function (res, curr, count) {
                staffList1=res.data;
            }
            ,page:{
                curr: 1
            }
        });
    }
    function queryDoor() {
        var doorName = $('#dev').val();
        var doorID = $('#dev').val();
        table.reload('table3', {
            url: 'queryWGDoor'
            ,where: {
                doorName:doorName,
                doorID:doorID,
                doorTreeIconCls:doorTreeIconCls,
                doorTreeId:doorTreeId,
            }
            ,done: function (res, curr, count) {
                doorList1=res.data;
            }
            ,page:{
                curr: 1
            }
        });
    }
    layui.use(['table', 'element', 'transfer', 'util', 'layer', 'form'], function () {
        table = layui.table
            , transfer = layui.transfer
            , $ = layui.jquery
            , form = layui.form
            , util = layui.util
            , layer = layui.layer
            , element = layui.element;
        var jsondata = [];
        var postdata = [];
        var jsondata2 = [];
        var postdata2 = [];

        //页面启动
        $(document).ready(function () {
            $("#li6").addClass("layui-this");
            $("#d2").addClass("layui-this");
        });

        function reloadTb2(){
            table.reload('table2');
        }
        table.render({
            elem: '#table1'
            , height: '300'
            , width:'515'
            , url: 'getAllCheck' //数据接口
            , cols: [[ //表头
                {type: 'checkbox', fixed: 'left'},
                {type: 'numbers', title: '序号', fixed: 100,event:'row'}
                , {field: 'personTypeName', title: '人员类型', width : 100,align : 'center'}
                , {field: 'staffId', title: '编号', width : 100,align : 'center'}
                , {field: 'name', title: '姓名', width : 100,align : 'center'}
                , {field: 'cardNo', title: '卡号', width : 120,align : 'center'}
            ]]

            ,page:true
            ,limits:[10,20,50,100]
            ,limit:20
        });
        table.render({
            elem: '#table2'
            , height: '300'
            , width:'515'
            , data:staffList2
            , cols: [[ //表头
                {type: 'checkbox', fixed: 'left'},
                {type: 'numbers', title: '序号', fixed: 100,event:'row'}
                , {field: 'personTypeName', title: '人员类型', width : 100,align : 'center'}
                , {field: 'staffId', title: '编号', width : 100,align : 'center'}
                , {field: 'name', title: '姓名', width : 100,align : 'center'}
                , {field: 'cardNo', title: '卡号', width : 120,align : 'center'}
            ]]
            ,page:true
            ,limits:[10,20,50,100]
            ,limit:20
        });
        table.render({
            elem: '#table3'
            , height: '300'
            , width:'515'
            , url: 'getAllCheck' //数据接口
            , cols: [[ //表头
                {type: 'checkbox', fixed: 'left'},
                {type: 'numbers', title: '序号', fixed: 100,event:'row'}
                //, {field: 'ctrlerSN', title: '控制器SN', width : 150,align : 'center'}
                //, {field: 'IP', title: '设备IP', width : 150,align : 'center'}
                , {field: 'doorName', title: '门名称', width : 211,align : 'center'}
                , {field: 'doorID', title: '门ID', width : 211,align : 'center'}
            ]]
            ,page:true
            ,limits:[10,20,50,100]
            ,limit:20
        });
        table.render({
            elem: '#table4'
            , height: '300'
            , width:'515'
            , url: 'getAllCheck' //数据接口
            , cols: [[ //表头
                {type: 'checkbox', fixed: 'left'},
                {type: 'numbers', title: '序号', fixed: 100,event:'row'}
                //, {field: 'ctrlerSN', title: '控制器SN', width : 150,align : 'center'}
                , {field: 'doorName', title: '门名称', width : 211,align : 'center'}
                , {field: 'doorID', title: '门ID', width : 211,align : 'center'}
            ]]
            ,page:true
            ,limits:[10,20,50,100]
            ,limit:20
        });
        $('#tree1').tree({
            onClick: function(node){
                staffTreeIconCls=node.iconCls;
                staffTreeId=node.id;
                $.ajax({
                    url: "/getDataByTree",
                    type: "POST",
                    data: {"iconCls": node.iconCls,"id":node.id},
                    dataType: "json",
                    success: function (res) {
                        table.render({
                            elem: '#table1'
                            , height: '300'
                            , width:'515'
                            , data: res.data
                            , cols: [[ //表头
                                {type: 'checkbox', fixed: 'left'},
                                {type: 'numbers', title: '序号', fixed: 100,event:'row'}
                                , {field: 'personTypeName', title: '人员类型', width : 100,align : 'center'}
                                , {field: 'staffId', title: '编号', width : 100,align : 'center'}
                                , {field: 'name', title: '姓名', width : 100,align : 'center'}
                                , {field: 'cardNo', title: '卡号', width : 120,align : 'center'}
                            ]]
                            ,done: function (res, curr, count) {
                                staffList1=res.data;
                            }
                            ,page:true
                            ,limits:[10,20,50,100]
                            ,limit:20
                        });
                    }
                });
            }
        });

        $('#tree2').tree({
            onClick: function(node){
                doorTreeIconCls=node.iconCls;
                doorTreeId=node.id;
                $.ajax({
                    url: "/getDoorByTree",
                    type: "POST",
                    data: {"iconCls": node.iconCls,"id":node.id},
                    dataType: "json",
                    success: function (res) {
                        table.render({
                            elem: '#table3'
                            , height: '300'
                            , width:'515'
                            , data: res.data
                            , cols: [[ //表头
                                {type: 'checkbox', fixed: 'left'},
                                {type: 'numbers', title: '序号', fixed: 100,event:'row'}
                                , {field: 'doorName', title: '门名称', width : 211,align : 'center'}
                                , {field: 'doorID', title: '门ID', width : 211,align : 'center'}
                            ]]
                            ,done: function (res, curr, count) {
                                doorList1=res.data;
                            }
                            ,page:true
                            ,limits:[10,20,50,100]
                            ,limit:20
                        });
                    }
                });
            }
        });
        $('#move1').click(function (){
            var checkStatus = table.checkStatus('table1')  //以id为索引
                ,data = checkStatus.data; //获取选中行的数据 ,Object数组类型

            data.forEach(function(res){ //forEach()实现循环
                $.each(staffList1,function (i,data) {
                    $.each(staffList1[i],function (index,item) {
                        if(item==res.id){
                            console.log(item);
                            staffList1.splice(i,1);
                        }
                    });
                });
                staffList2[staffList2.length]=res;
            });
            table.render({
                elem: '#table1'
                , height: '300'
                , width:'515'
                , data:staffList1
                , cols: [[ //表头
                    {type: 'checkbox', fixed: 'left'},
                    {type: 'numbers', title: '序号', fixed: 100,event:'row'}
                    , {field: 'personTypeName', title: '人员类型', width : 100,align : 'center'}
                    , {field: 'staffId', title: '编号', width : 100,align : 'center'}
                    , {field: 'name', title: '姓名', width : 100,align : 'center'}
                    , {field: 'cardNo', title: '卡号', width : 120,align : 'center'}
                ]]
                ,page:true
                ,limits:[10,20,50,100]
                ,limit:20
            });
            table.render({
                elem: '#table2'
                , height: '300'
                , width:'515'
                , data: staffList2
                , cols: [[ //表头
                    {type: 'checkbox', fixed: 'left'},
                    {type: 'numbers', title: '序号', fixed: 100,event:'row'}
                    , {field: 'personTypeName', title: '人员类型', width : 100,align : 'center'}
                    , {field: 'staffId', title: '编号', width : 100,align : 'center'}
                    , {field: 'name', title: '姓名', width : 100,align : 'center'}
                    , {field: 'cardNo', title: '卡号', width : 120,align : 'center'}
                ]]  ,page:true
                ,limits:[10,20,50,100]
                ,limit:20
            });
        })

        $('#move2').click(function (){
            var checkStatus = table.checkStatus('table2')
                ,data = checkStatus.data; //获取选中行的数据 ,数组类型
            data.forEach(function(res){
                staffList1[staffList1.length] =res;
                $.each(staffList2,function (i,data) {
                    $.each(staffList2[i],function (index,item) {
                        if(item==res.id){
                            staffList2.splice(i,1);
                        }
                    });
                });
            });
            table.render({
                elem: '#table1'
                , height: '300'
                , width:'515'
                , data:staffList1
                , cols: [[ //表头
                    {type: 'checkbox', fixed: 'left'},
                    {type: 'numbers', title: '序号', fixed: 100,event:'row'}
                    , {field: 'personTypeName', title: '人员类型', width : 100,align : 'center'}
                    , {field: 'staffId', title: '编号', width : 100,align : 'center'}
                    , {field: 'name', title: '姓名', width : 100,align : 'center'}
                    , {field: 'cardNo', title: '卡号', width : 120,align : 'center'}
                ]]
                ,page:true
                ,limits:[10,20,50,100]
                ,limit:20
            });
            table.render({
                elem: '#table2'
                , height: '300'
                , width:'515'
                , data: staffList2
                , cols: [[ //表头
                    {type: 'checkbox', fixed: 'left'},
                    {type: 'numbers', title: '序号', fixed: 100,event:'row'}
                    , {field: 'personTypeName', title: '人员类型', width : 100,align : 'center'}
                    , {field: 'staffId', title: '编号', width : 100,align : 'center'}
                    , {field: 'name', title: '姓名', width : 100,align : 'center'}
                    , {field: 'cardNo', title: '卡号', width : 120,align : 'center'}
                ]]  ,page:true
                ,limits:[10,20,50,100]
                ,limit:20
            });

        })
        $('#move3').click(function (){
            var checkStatus = table.checkStatus('table3')  //以id为索引
                ,data = checkStatus.data; //获取选中行的数据 ,Object数组类型

            console.log("doorList1"+doorList1);

            data.forEach(function(res){ //forEach()实现循环
                $.each(doorList1,function (i,data) {
                    $.each(doorList1[i],function (index,item) {
                        if(item==res.id){
                            console.log(item);
                            doorList1.splice(i,1);
                        }
                    });
                });
                doorList2[doorList2.length]=res;
            });
            console.log(doorList1.length+"---"+doorList2.length);
            table.render({
                elem: '#table3'
                , height: '300'
                , width:'515'
                , data:doorList1
                , cols: [[ //表头
                    {type: 'checkbox', fixed: 'left'},
                    {type: 'numbers', title: '序号', fixed: 100,event:'row'}
                    , {field: 'doorName', title: '门名称', width : 211,align : 'center'}
                    , {field: 'doorID', title: '门ID', width : 211,align : 'center'}
                ]]
                ,page:true
                ,limits:[10,20,50,100]
                ,limit:20
            });
            table.render({
                elem: '#table4'
                , height: '300'
                , width:'515'
                , data: doorList2
                , cols: [[ //表头
                    {type: 'checkbox', fixed: 'left'},
                    {type: 'numbers', title: '序号', fixed: 100,event:'row'}
                    , {field: 'doorName', title: '门名称', width : 211,align : 'center'}
                    , {field: 'doorID', title: '门ID', width : 211,align : 'center'}
                ]] ,page:true
                ,limits:[10,20,50,100]
                ,limit:20
            });
        })

        $('#move4').click(function (){
            var checkStatus = table.checkStatus('table4')
                ,data = checkStatus.data; //获取选中行的数据 ,数组类型
            data.forEach(function(res){
                doorList1[doorList1.length] =res;
                $.each(doorList2,function (i,data) {
                    $.each(doorList2[i],function (index,item) {
                        if(item==res.id){
                            doorList2.splice(i,1);
                        }
                    });
                });
            });
            table.render({
                elem: '#table3'
                , height: '300'
                , width:'515'
                , data:doorList1
                , cols: [[ //表头
                    {type: 'checkbox', fixed: 'left'},
                    {type: 'numbers', title: '序号', fixed: 100,event:'row'}
                    , {field: 'doorName', title: '门名称', width : 211,align : 'center'}
                    , {field: 'doorID', title: '门ID', width : 211,align : 'center'}
                ]]
                ,page:true
                ,limits:[10,20,50,100]
                ,limit:20
            });
            table.render({
                elem: '#table4'
                , height: '300'
                , width:'515'
                , data: doorList2
                , cols: [[ //表头
                    {type: 'checkbox', fixed: 'left'},
                    {type: 'numbers', title: '序号', fixed: 100,event:'row'}
                    , {field: 'doorName', title: '门名称', width : 211,align : 'center'}
                    , {field: 'doorID', title: '门ID', width : 211,align : 'center'}
                ]] ,page:true
                ,limits:[10,20,50,100]
                ,limit:20
            });
        })

        //提交下发权限
        form.on('submit(*)', function () {
            var loading = layer.msg('<span style="font-size:20px">权限下发中...请等待</span>', {icon: 16, shade: 0.3, time:0,});

            $.ajax({
                url: "/addCardWgDev",
                type: "POST",
                contentType: "application/json;charset=UTF-8",//指定消息请求类型
                data: JSON.stringify({cards: staffList2, devices: doorList2}),
                dataType: "text",
                success: function () {
                    layer.close(loading);
                    //location.href = "goCard";
                    layer.msg("下发成功",{ time:3000,});

                    setTimeout(function() { window.location.reload();},3000);
                }
            });
            return false; //阻止表单跳转。如果需要表单跳转，去掉这段即可。
        });

        //提交禁止权限
        form.on('submit(#)', function () {
            var loading = layer.msg('<span style="font-size:20px">权限禁止中...请等待</span>', {icon: 16, shade: 0.3, time:0,});

            $.ajax({
                url: "/delCardWgDev",
                type: "POST",
                contentType: "application/json;charset=UTF-8",//指定消息请求类型
                data: JSON.stringify({cards: staffList2, devices: doorList2}),
                dataType: "text",
                success: function () {
                    layer.close(loading);
                    //location.href = "goCard";
                    layer.msg("禁止成功",{ time:3000,});

                    setTimeout(function() { window.location.reload();},3000);
                }
            });
            return false; //阻止表单跳转。如果需要表单跳转，去掉这段即可。
        });

        $('body').on('click','#btnStaffClear',function(){
            $('#staff').val('');
            $('#personType').val('');
            return false;
        });
        $('body').on('click','#btnDoorClear',function(){
            $('#dev').val('');
            return false;
        });
        $("#query").on("click",function () {
            layer.open({
                type: 2,
                title: '权限信息',
                area: ['950px', '600px']
                ,content: 'goWgPromiseMsg'
                ,success: function(layero, index) {
                    layer.iframeAuto(index);
                }
            });
        })
        //部门下拉框
        // form.on('select(bmSelect)', function (data) {
        //     $.ajax({
        //         url: "/selectStaffNameByDepartmentIdCard",
        //         type: "POST",
        //         data: {"departmentId": data.value},
        //         dataType: "json",
        //         success: function (data) {
        //             console.log(data);
        //             transfer.render({
        //                 elem: '#test3'
        //                 , data: data
        //                 , value: jsondata
        //                 , width: 300
        //                 , height: 300
        //                 , title: ['候选人员', '已选人员']
        //                 , id: 'transfer1'
        //                 , onchange: function (obj, index) {
        //
        //                     if (index == 0) {
        //                         for (var i = 0; i < obj.length; i++) {
        //                             postdata.push(obj[i]);
        //                         }
        //                     }
        //                     if (index == 1) {
        //                         for (var i = 0; i < obj.length; i++) {
        //                             for (var j = 0; j < postdata.length; j++) {
        //                                 if (obj[i].value == postdata[j].value) {
        //                                     postdata[j] = "";
        //                                     break;
        //                                 }
        //                             }
        //                         }
        //                         for (var i = 0; i < obj.length; i++) {
        //                             for (var j = 0; j <= jsondata.length; j++) {
        //                                 if (obj[i].value == jsondata[j]) {
        //                                     jsondata[j] = "";
        //                                     break;
        //                                 }
        //                             }
        //                         }
        //                     }
        //                     //alert(JSON.stringify(postdata));
        //                     table1.reload({
        //                         data: postdata
        //                     });
        //
        //
        //                     //var arr = ['左边', '右边'];
        //                     //layer.alert('来自 <strong>' + arr[index] + '</strong> 的数据：' + JSON.stringify(obj)); //获得被穿梭时的数据
        //                 }
        //             });
        //         }
        //     });
        // });
        //
        // form.on('select(test4)', function (data) {
        //     var getData = transfer.getData('transfer2'); //获取右侧数据
        //     for (var i = 0, l = getData.length; i < l; i++) {
        //         if (jsondata2.length == 0) {
        //             jsondata2.push(getData[i].value);
        //         } else {
        //             var u = 0;
        //             for (var j = 0, z = jsondata2.length; j < z; j++, u++) {
        //                 if (getData[i].value == jsondata2[j]) {
        //                     break;
        //                 }
        //             }
        //             if (u == jsondata2.length) {
        //                 jsondata2.push(getData[i].value);
        //             }
        //         }
        //     }
        //     //alert(JSON.stringify(jsondata2));
        //     $.ajax({
        //         url: "/selectDeviceByDepartmentIdCard",
        //         type: "POST",
        //         data: {"departmentId": data.value},
        //         dataType: "json",
        //         success: function (data) {
        //             transfer.render({
        //                 elem: '#test4'
        //                 , data: data
        //                 , value: jsondata2
        //                 , width: 300
        //                 , height: 300
        //                 , title: ['当前部门未选设备', '当前部门已选设备']
        //                 , id: 'transfer2'
        //                 , onchange: function (obj, index) {
        //                     if (index == 0) {
        //                         for (var i = 0; i < obj.length; i++) {
        //                             postdata2.push(obj[i]);
        //                         }
        //                     }
        //                     if (index == 1) {
        //                         for (var i = 0; i < obj.length; i++) {
        //                             for (var j = 0; j < postdata2.length; j++) {
        //                                 if (obj[i].value == postdata2[j].value) {
        //                                     // delete postdata[j];
        //                                     postdata2[j] = "";
        //                                     break;
        //                                 }
        //                             }
        //                         }
        //                         for (var i = 0; i < obj.length; i++) {
        //                             for (var j = 0; j <= jsondata2.length; j++) {
        //                                 if (obj[i].value == jsondata2[j]) {
        //                                     jsondata2[j] = "";
        //                                     break;
        //                                 }
        //                             }
        //                         }
        //                     }
        //                     // alert(JSON.stringify(postdata2));
        //                     table2.reload({
        //                         data: postdata2
        //                     });
        //                     //var arr = ['左边', '右边'];
        //                     //layer.alert('来自 <strong>' + arr[index] + '</strong> 的数据：' + JSON.stringify(obj)); //获得被穿梭时的数据
        //                 }
        //             });
        //         }
        //     });
        // });
        //
        //
        // $.ajax({
        //     url: "/selectCascadeDepartmentName",
        //     type: "POST",
        //     dataType: "json",
        //     success: function (data) {
        //         $('#select3').html("");
        //         $('#select4').html("");
        //         var content = '<option value="">请选择使用部门</option>';
        //         $.each(data, function (i, val) {
        //             content += '<option value="' + val.rootId + '">' + val.title + '</option>';
        //         });
        //         $('#select3').html(content);
        //         $('#select4').html(content);
        //         form.render('select', 'test1');
        //         form.render('select', 'test3');
        //     }
        // });
        //
        // //显示搜索框
        // transfer.render({
        //     elem: '#test3'
        //     , id: 'transfer1'
        //     , data: ""
        //     , width: 500
        //     , height: 300
        //     , title: ['候选人员', '已选人员']
        //     , showSearch: false
        //     , onchange: function (obj, index) {
        //         //var arr = ['左边', '右边'];
        //         //layer.alert('来自 <strong>' + arr[index] + '</strong> 的数据：' + JSON.stringify(obj)); //获得被穿梭时的数据
        //     }
        // });
        // //显示搜索框
        // transfer.render({
        //     elem: '#test4'
        //     , id: 'transfer2'
        //     , data: ""
        //     , width: 300
        //     , height: 300
        //     , title: ['当前部门未选设备', '当前部门已选设备']
        //     , showSearch: false
        //     , onchange: function (obj, index) {
        //         //var arr = ['左边', '右边'];
        //         //layer.alert('来自 <strong>' + arr[index] + '</strong> 的数据：' + JSON.stringify(obj)); //获得被穿梭时的数据
        //     }
        // });
    });

</script>
</body>
</html>