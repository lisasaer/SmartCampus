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
    <jsp:include page="./header/res.jsp"></jsp:include>
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
    <h1>空开列表</h1>
</div>
<div class="div-btn-close">
    <button style="width: 30px;height: 30px" onclick="closeFrame()">X</button>
</div>
<br>
<br>
<div class="layui-btn-group demoTable">
    <button id="setAllSwitch" class="layui-btn">设置空开设备</button>
    <button id="btnUpdateDev" class="layui-btn layui-btn-warm">刷新</button>
    <button id="btnAddSwitchDev" type="button" class="layui-btn layui-btn-normal layui-btn-radius ">新增</button>
</div>
<table id="test" lay-filter="test"></table>

</body>
<%--<script type="text/html" id="toolbarDemo">
    <div class="layui-btn-container" id ="button">
    </div>
</script>--%>
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs layui-btn-normal" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
<script>
    var table;
    $(function () {
        var list = '${switchDevinfo}' ;
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
            , height: 'full-150'

            //,toolbar: '#toolbarDemo' //开启头部工具栏，并为其绑定左侧模板
            , cols: [[ //表头
                //{type: 'checkbox', fixed: 'left'}
                 {type: 'numbers', title: '序号', fixed: 'left',event:'row',align : 'center'}
                // , {field: 'id', title: 'ID' , width : 150,event:'row'}
                , {field: 'loraSN', title: 'Lora序列号' , width : 200,event:'row',align : 'center'}
                , {field: 'uuid', title: '空开通讯地址' , width:150,align : 'center',event:'row'}
                //, {field: 'switchGroupNum', title: '空开组数量' , width:100,event:'row'}
                //, {field: 'sensortype', title: '设备类型' , width:100,event:'row'}
                , {field: 'devStatus', title: '状态检测' , width:120,align : 'center',event:'row'}
                , {field: 'intervaltime', title: '数据上报间隔(s)' , width:150,align : 'center',event:'row'}
                //, {field: 'port', title: '设备端口' , width:100,event:'row'}
                , {field: 'chncnt', title: '设备通道数量' , width:120,align : 'center',event:'row'}
                //, {field: 'chntype', title: '通道类型' , width:150,event:'row'}
                , {fixed: 'right', title:'操作', align : 'center',toolbar: '#barDemo'}
            ]]
            , data:${switchDevinfo}
            ,done: function(res, curr, count){
                $('[data-field="id"]').addClass('layui-hide');
                $('.layui-form-checkbox').css('margin-top','5px')
                res.data.forEach(function (item,index) {
                    //如果是在线，修改这行单元格背景和文字颜色
                    if(item.devStatus == "在线"){
                        $(".layui-table-body tbody tr[data-index='"+index+"']").css({'background-color': "#009688"});
                        $(".layui-table-body tbody tr[data-index='"+index+"']").css({'color': "#fff" });
                    }
                });
            }
            ,page:true
            ,limits:[10,15]
            ,limit:10
        });

        //监听行工具事件
        table.on('tool(test)', function(obj) {
            //console.log(obj)
            var dataAdd;
            var data = obj.data;
            //console.log(data.uuid);
            /*var addData;
            layui.common.ajaxPost(layui.cache.host+'',data.founction(res){
                dataAdd=res.addData;
                table.render({
                    elem:'#currentTable',
                    cols: [[ //表头
                        {type: 'checkbox', fixed: 'left'}
                        , {type: 'numbers', title: '序号', fixed: 'left',event:'row'}
                        // , {field: 'id', title: 'ID' , width : 150,event:'row'}
                        , {field: 'loraSN', title: 'Lora序列号' , width : 150,event:'row'}
                        , {field: 'uuid', title: '空开通讯地址' , width:150,event:'row'}
                        , {field: 'switchGroupNum', title: '空开组数量' , width:100,event:'row'}
                        , {field: 'sensortype', title: '设备类型' , width:100,event:'row'}
                        , {field: 'devStatus', title: '设备在线状态' , width:150,event:'row'}
                        , {field: 'intervaltime', title: '数据上报间隔(s)' , width:150,event:'row'}
                        , {field: 'port', title: '设备端口' , width:100,event:'row'}
                        , {field: 'chncnt', title: '设备通道数量' , width:150,event:'row'}
                        , {field: 'chntype', title: '通道类型' , width:150,event:'row'}
                        , {fixed: 'right', title:'操作', toolbar: '#barDemo', width:120}
                    ]],
                    addData:dataAdd,
                });
            }*/
            if (obj.event === 'del') {
                layer.confirm('确定删除该设备？', function (index) {
                    var loading = layer.load(1, {shade: [0.1, '#fff']});
                    var temp = {
                        id:data.id
                        //,devSN:data.devSN
                    };
                    $.post('delSwitchDev',temp, function (res) {
                        layer.close(index);
                        layer.msg('删除成功');
                        setTimeout('window.location.reload()',10);
                        //reloadTb();
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
                    area: ['500px', '400px'],
                    fixed: false, //不固定
                    content: 'toSwitchDevUpdateView',
                    btn: ['确认', '取消'],
                    yes: function (index, layero) {
                        var body = layer.getChildFrame('body', index);
                        var form1 = body.find('#form1');
                        var newData = formUtilEL.serializeObject(form1);
                        //删除无用信息
                        // delete newData.switchGroupNum;
                        // delete newData.uuid;
                        // delete newData.devId;
                        // delete newData.intervaltime;
                        /*port
                        chncnt*/

                        newData.id = data.id;
                        console.log('newData', newData);
                        var loading = layer.load(1, {shade: [0.1, '#fff']});
                        $.post('updateswitchDev', newData,function (res) {
                            if (Number(res) > 0) {
                                layer.close(index);
                                setTimeout('window.location.reload()',10);
                                layer.msg('修改成功');
                                reloadTb();
                            }
                        }).fail(function (xhr) {
                            layer.msg('修改失败' + xhr.status)
                        }).always(function () {
                            layer.close(loading);
                        });
                    }
                    , success: function (layero, index) {
                        var body = layer.getChildFrame('body', index);

                        var form1 = body.find('#form1');
                        console.log(form1);
                        formUtilEL.fillFormData(form1, data);
                        console.log(data);
                        console.log(formUtilEL);
                        var childWindow = $(layero.find('iframe'))[0].contentWindow;
                        console.log(childWindow);
                        childWindow.initModifyView(data);
                    }
                });
            }
            else if(obj.event === 'row'){
                console.log("data.devId:"+data.devId);
                layer.open({
                    type: 2,
                    title: false,
                    area: ['1000px', '623px'],
                    shade: 0.8,
                    closeBtn: 0,
                    shadeClose: true,
                    content: 'switchViewTest?devId='+data.devId
                    ,success: function(layero, index) {
                        layer.iframeAuto(index);
                    }
                });
            }
        })
    })
    //重载表格  刷新表格数据
    function reloadTb(){
        table.reload('test');
    }
    //添加空开设备
    $('#btnAddSwitchDev').click(function () {
        layer.open({
            type: 2,
            zIndex:999,
            title: '添加空开设备',
            area: ["500px", "400px"],
            //shade: 0,
            btn:['确定','取消'],
            //fixed: false, //不固定
            //closeBtn: 0,
            //shadeClose: true,
            content: 'toSwitchDevAddView',
            yes: function (index, layero) {
                var body = layer.getChildFrame('body', index);
                var form1 = body.find('#form1');
                var data = formUtilEL.serializeObject(form1);
                //console.log(data);
                for (var key in data) {
                    console.log(key, data[key]);
                    if (data[key] == null || data[key] == '') {
                        layer.msg('内容不能为空！');
                        layer.msg(body.find('[name="' + key + '"]').attr('不能为空！'));
                        return;
                    }
                }
                var loading = layer.load(1, {shade: [0.1, '#fff']});
                //console.log(data);
                $.post('addSwitchDev', data, function (res) {
                    console.log(Number(res.code));
                    if (Number(res.code) > 0) {
                        layer.close(index);
                        reloadTb();
                        setTimeout('window.location.reload()', 10);
                    }
                    layer.msg(res.msg);
                }).fail(function (xhr) {
                    layer.msg('添加失败 ' + xhr.status);
                }).always(function () {
                    layer.close(loading);
                });
            },success(layero, index) {
                //layer.iframeAuto(index);
                var body = layer.getChildFrame('body', index);

                var childWindow = $(layero.find('iframe'))[0].contentWindow;
                childWindow.initAddView();
            }
        })
    });

    //搜索按钮点击事件
    $('btnSelectSwitchDev').click(function(){
        layer.open({
            type: 2,
            title: false,
            area: ['1000px', '623px'],
            shade: 0.8,
            closeBtn: 0,
            shadeClose: true,
            content: 'switchDevSearch'
            ,success: function(layero, index) {
                layer.iframeAuto(index);
            }
        });
    });

    //刷新页面
    $('#btnUpdateDev').click(function () {
        var loading = MyLayUIUtil.loading();
        console.log("主页刷新");
        $.post('updateDev',function (res) {

        }).fail(function (xhr) {
            console.log(xhr.status);
        }).always(function () {
            layer.close(loading);
        })
        reloadTb();
        MyLayUIUtil.closeLoading(loading);

    })
    //发送设置命令按钮
    $('#setAllSwitch').click(function ({}) {
        var loading = MyLayUIUtil.loading();
        $.post('setSwitchDev',function(res){

        }).fail(function (xhr){
            console.log(xhr.status);
            layer.msg("设置失败"+xhr.status);
        }).always(function () {
            layer.close(loading);
        })
        //MyLayUIUtil.closeLoading(loading);
        layer.msg("设置成功");
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
