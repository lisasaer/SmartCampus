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
                        console.log("res: "+res);
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
<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container" id ="button">
<%--        <button class="layui-btn layui-btn-sm" lay-event="closeSwitch">合闸</button>--%>
        <button id = "openSwitch" class="layui-btn layui-btn-sm" lay-event="openCloseSwitch">开闸</button>
        <button class="layui-btn layui-btn-sm" lay-event="editSwitch">编辑</button>
    </div>
</script>
<script>
    var table;
    $(function () {
        var list = '${switchInfo}' ;
        console.log("list"+list);
    });

    function closeFrame(){
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        parent.layer.close(index);
    }
    var bOpen = false;
    var click=true;


    layui.use('table', function() {
        table = layui.table;
        //表格渲染
        table.render({
            elem: '#test'
            ,id:'test'
            , title: '空开线路数据表'
            , height: 'full-100'
            ,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            , cols: [[
                {type: 'checkbox', fixed: 'left'}
                , {field: 'id', title: 'ID',style:'display:none',width:80,align : 'center'}
                , {field: 'devId', title: '设备ID',width:80,align : 'center'}
                , {field: 'switchAddress', title: '线路地址',width:100,align : 'center'}
                , {field: 'switchName', title: '线路名称',width:100,align : 'center'}
                , {field: 'switchStatus', title: '状态',width:80,align : 'center'}
                , {field: 'recordTime', title: '分闸/合闸时间',width:180,align : 'center'}
                , {field: 'lineVoltage', title: '线路电压(V)',width:130,align : 'center'}
                , {field: 'lineCurrent', title: '线路电流(A)',width:130,align : 'center'}
                , {field: 'linePower', title: '线路功率(W)',width:130,align : 'center'}
                , {field: 'leakageCurrent', title: '漏电电流(A)',width:130,align : 'center'}
                , {field: 'moduleTemperature', title: '模块温度(度)',width:130,align : 'center'}
            ]]
            ,data:${switchInfo}
            ,done: function(res, curr, count){
                $('[data-field="id"]').addClass('layui-hide');
                $('.layui-form-checkbox').css('margin-top','5px')
                if (item.switchStatus == "断电") {
                    $(".layui-table-body tbody tr td[data-field=\"switchStatus\"]").css({'color': "#b74531"});
                }
                if (item.switchStatus == "通电") {
                    $(".layui-table-body tbody tr td[data-field=\"switchStatus\"]").css({'color': "#1666f9"});
                }
            }
            ,page:true
            ,limits:[10,15]
            ,limit:10

        });

        table.on('toolbar(test)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id);
            var data = checkStatus.data;

            if(data.length < 1){
                MyUtil.msg('请选择线路');
                return;
            }
            //console.log(data.length);
            //console.log(data);
            var addressList = '';
            for(var i = 0;i<data.length;i++){
                addressList += data[i].switchAddress+",";
            }
            addressList = addressList.substring(0,addressList.length-1);
            console.log("addressList: "+addressList);

            var ctrlData = {};
            ctrlData.devId = data[0].devId;
            ctrlData.address = addressList;
            ctrlData.dd = 100;
            switch(obj.event){
                // case 'closeSwitch':
                //     ctrlData.type = 'close';
                //     $.post('ctrlDev',ctrlData,function (res) {
                //         console.log("res: "+res);
                //     });
                //     break;
                // case 'openSwitch':
                //     ctrlData.type = 'open';
                //     $.post('ctrlDev',ctrlData,function (res) {
                //         console.log("res: "+res);
                //     });
                //     break;
                case 'openCloseSwitch':

                    if (!click)
                    {
                        //不能执行下面动作
                        console.log("等待ing......");
                        return;
                    }

                    console.log("执行开闸/合闸......");

                    if(bOpen)
                    {
                        console.log("合闸");
                        ctrlData.type = 'close';
                        var data = "";
                        $.post('ctrlDev',ctrlData,function (res)
                        {
                            console.log("res: " + res);
                            /*alert("数据传输完毕");
                            data=res;*/
                        });
                        bOpen = !bOpen;
                        change = document.getElementById("openSwitch");
                        change.innerHTML = "开闸";
                        /*if(data==""){
                            alert("数据还在传输中，请稍后");
                        }*/
                    }
                    else
                    {
                        console.log("开闸");
                        ctrlData.type = 'open';
                        $.post('ctrlDev',ctrlData,function (res) {
                            console.log("res: " + res);
                        });
                        bOpen =! bOpen;
                        change = document.getElementById("openSwitch");
                        change.innerHTML = "合闸";
                    };
                    click = false;
                    console.log("+++++++++++++++++++++++++++++++++");
                    $(this).css("background-color","#4e5465");
                    setTimeout(function () {
                        console.log("等待时间结束......");
                        click = true;
                        $('#openSwitch').css("background-color","#009688");
                    },15000);

                    break;
                case 'editSwitch':
                    if(data.length > 1){
                        MyUtil.msg('请选择单个设备');
                        return;
                    }

                    $('#oldName').val(data[0].switchName);
                    $('#inputId').val(data[0].id);
                    $('#inputDevSN').val(data[0].devSN);
                    $('#newName').val('');
                    $('.div-modify').removeClass('layui-hide');

                    break;
            }
        })

    })
    $(function () {//页面完全加载完后执行

        /*防止重复提交  10秒后恢复*/
        var isSubmitClick = true;
        $('.layui-btn-sm').click(function () {
            if (isSubmitClick) {
                isSubmitClick = false;
                $('.layui-btn-sm').css("background-color", "red");
                // $("form:first").submit();//提交第一个表单
                $("form[name='form_month']").submit();
                setTimeout(function () {
                    $('.layui-btn-sm').css("background-color", "#3CBAFF");
                    isSubmitClick = true;
                }, 10000);
            }
        });
        /**/

    });
</script>
</html>
