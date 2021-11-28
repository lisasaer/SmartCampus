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
    <title>普通门禁在线搜索</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
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
            width: 100px;
        }
    </style>
</head>
<body style="padding: 15px;">


    <div class="div-btn-close">
        <button style="width: 30px;height: 30px" onclick="closeFrame()">X</button>
    </div>
    <div >
        <div class="div-title">
            <a>普通门禁在线搜索</a>
        </div>
        <table id="test" lay-filter="test"></table>
    </div>

<%--    <div  class="div-modify layui-hide">--%>
<%--        <div class="div-modify-view" >--%>

<%--            <div style="margin-left: 65px;margin-top: 40px;">--%>
<%--                <div class="layui-form-item">--%>
<%--                    <label class="layui-form-label">原线路名</label>--%>
<%--                    <div class="layui-input-inline">--%>
<%--                        <input disabled  class="layui-input" id="oldName">--%>
<%--                    </div>--%>
<%--                </div>--%>

<%--                <div class="layui-form-item">--%>
<%--                    <label class="layui-form-label">新线路名</label>--%>
<%--                    <div class="layui-input-inline">--%>
<%--                        <input id="newName" placeholder="请输入新线路名" class="layui-input">--%>
<%--                    </div>--%>
<%--                </div>--%>
<%--            </div>--%>

<%--            <div style="text-align: center;margin-top: 20px">--%>
<%--                <button class="layui-btn" id="btnSure">确认</button>--%>
<%--                <button class="layui-btn" id="btnCancel">取消</button>--%>
<%--            </div>--%>
<%--            <div class="layui-hide">--%>
<%--                <input  id="inputId">--%>
<%--                <input id="inputDevSN">--%>
<%--            </div>--%>


<%--            <script>--%>
<%--                $('#btnCancel').click(function () {--%>
<%--                    $('.div-modify').addClass('layui-hide');--%>
<%--                });--%>
<%--                $('#btnSure').click(function () {--%>
<%--                    var newName = $('#newName').val();--%>
<%--                    if(newName.length < 1){--%>
<%--                        MyUtil.msg('请输入新线路名称');--%>
<%--                        return;--%>
<%--                    }--%>
<%--                    var temp = {--%>
<%--                        id:$('#inputId').val()--%>
<%--                        ,switchName:newName--%>
<%--                        ,devSN:$('#inputDevSN').val()--%>
<%--                    };--%>

<%--                    $.post('modifySwitch',temp,function (res) {--%>
<%--                        console.log(res);--%>
<%--                        table.reload('test',{--%>
<%--                            data:res.data--%>
<%--                        });--%>
<%--                        $('.div-modify').addClass('layui-hide');--%>
<%--                    });--%>
<%--                })--%>
<%--            </script>--%>
<%--        </div>--%>
<%--    </div>--%>


</body>
<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container">
        <button class="layui-btn layui-btn-sm" lay-event="addDev"  onclick="chooseDev()">添加选中的控制器</button>
<%--        <button class="layui-btn layui-btn-sm" lay-event="openSwitch">修改</button>--%>
    </div>
</script>
<script>
    var table;
    $(function () {
        var list = '${list}' ;
    });

    function closeFrame(){
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        parent.layer.close(index);
    }

    layui.use('table', function() {
        table = layui.table;
        //表格渲染
        table.render({
            elem: '#test'
            ,id:'test'
            , title: '用户数据表'
            , height: 'full-100'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            , cols: [[
                {type: 'checkbox', fixed: 'left'}
                ,{type: 'numbers', title: '序号', fixed: 'left'}
                // , {field: 'id', title: 'ID',style:'display:none',width:1}
                , {field: 'ctrlerSN', title: '普通门禁SN',width:120}
                , {field: 'ip', title: '普通门禁设备IP',width:140}
                , {field: 'netmask', title: '子网掩码',width:120}
                , {field: 'defaultGateway', title: '默认网关',width:120}
                , {field: 'macAddress', title: 'MAC地址',width:150}
                , {field: 'port', title: '端口号',width:80}
                , {field: 'driverVerID', title: '版本号',width:80}
                , {field: 'verDate', title: '版本日期',width:120}
            ]]
            ,data:${list}
            ,done: function(res, curr, count){
                // $('[data-field="id"]').addClass('layui-hide');
                $('.layui-form-checkbox').css('margin-top','5px');
            }
            ,page:true
            ,limits:[10,15,20,30]
            ,limit:20
        });
    })

    function chooseDev(){
        var checkStatus = table.checkStatus('test'); //idTest 即为基础参数 id 对应的值

        if(checkStatus.data.length == 0){
            layer.msg("请选择门禁设备");
            return;
        }
        var chooseDevList = checkStatus.data;
        $.post('addwgAccessDev',{list:JSON.stringify(chooseDevList)},function (res) {
            if(res.code > 0){
                layer.msg("添加成功");
                parent.location.reload();
            }
            else{
                layer.msg("添加失败");
            }
        })
        closeFrame();
        // console.log(checkStatus.data) //获取选中行的数据
        // console.log(checkStatus.data.length) //获取选中行数量，可作为是否有选中行的条件
        // console.log(checkStatus.isAll ) //表格是否全选
    }
</script>
</html>
