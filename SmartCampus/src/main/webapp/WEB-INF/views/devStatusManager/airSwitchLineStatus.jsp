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
    <title>Title</title>
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

    <div class="div-title">
        <h1>线路列表</h1>
    </div>
    <div class="div-btn-close">
        <button style="width: 30px;height: 30px" onclick="closeFrame()">X</button>
    </div>
    <table id="test" lay-filter="test"></table>

    <div  class="div-modify layui-hide">
        <div class="div-modify-view" >

            <div style="margin-left: 65px;margin-top: 40px;">
                <div class="layui-form-item">
                    <label class="layui-form-label">原线路名</label>
                    <div class="layui-input-inline">
                        <input disabled  class="layui-input" id="oldName">
                    </div>
                </div>

                <div class="layui-form-item">
                    <label class="layui-form-label">新线路名</label>
                    <div class="layui-input-inline">
                        <input id="newName" placeholder="请输入新线路名" class="layui-input">
                    </div>
                </div>
            </div>

            <div style="text-align: center;margin-top: 20px">
                <button class="layui-btn" id="btnSure">确认</button>
                <button class="layui-btn" id="btnCancel">取消</button>
            </div>
            <div class="layui-hide">
                <input  id="inputId">
                <input id="inputDevSN">
            </div>


            <script>
                $('#btnCancel').click(function () {
                    $('.div-modify').addClass('layui-hide');
                });
                $('#btnSure').click(function () {
                    var newName = $('#newName').val();
                    if(newName.length < 1){
                        MyUtil.msg('请输入新线路名称');
                        return;
                    }
                    var temp = {
                        id:$('#inputId').val()
                        ,switchName:newName
                        ,devSN:$('#inputDevSN').val()
                    };

                    $.post('modifySwitch',temp,function (res) {
                        console.log(res);
                        table.reload('test',{
                            data:res.data
                        });
                        $('.div-modify').addClass('layui-hide');
                    });
                })
            </script>
        </div>
    </div>


</body>

<script>
    var table;
    $(function () {
        var list = '${switchInfo}' ;
        console.log(list);
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
            , cols: [[
                {field: 'id', title: 'ID',style:'display:none',width:1}
                , {field: 'devId', title: '设备ID'}
                , {field: 'switchAddress', title: '线路地址'}
                , {field: 'switchName', title: '线路名称'}
                , {field: 'switchStatus', title: '状态'}
                , {field: 'recordTime', title: '分闸/合闸时间'}
            ]]
            ,data:${switchInfo}
            ,done: function(res, curr, count){
                $('[data-field="id"]').addClass('layui-hide');
                $('.layui-form-checkbox').css('margin-top','5px')
            }
            ,page:true
            ,limits:[10,15]
            ,limit:10
        });
    })
</script>
</html>
