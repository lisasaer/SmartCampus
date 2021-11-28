<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2019/11/22
  Time: 19:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>权限设置</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        /*去除table表单外边距*/
        .layui-table, .layui-table-view {
            margin-bottom: 0;
        }
    </style>
</head>
<body class="layui-layout-body">
    <div class="layui-layout layui-layout-admin">
        <!-- 头部区域（可配合layui已有的水平导航） -->
        <jsp:include page="../header/topHead.jsp"></jsp:include>

        <div class="layui-body" style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;">
            <!-- 内容主体区域 -->
            <div class="layui-col-md5" style="border: 1px solid #eee;padding: 10px;" >
                <div>
                    <button id="btnPermission" class="layui-btn">添加权限</button>
                </div>
                <table id="demo" lay-filter="test"></table>
            </div>

            <label class="layui-form-label"></label>
            <div class="layui-col-md5" style="border: 1px solid #eee;padding: 10px;width: 50%;height: 100%">
                <form class="layui-form">
                    <label class="layui-form-label">模块</label>

                    <div class="layui-input-block">
                        <div class="layui-form-item">
                            <input type="checkbox" name="like[write]" title="1.设备管理" checked>
                            <input type="checkbox" name="like[read]" title="2.空间管理" checked>
                            <input type="checkbox" name="like[dai]" title="3.系统配置" checked>
                        </div>
                        <div class="layui-form-item">
                        <input type="checkbox" name="like[write]" title="4.视频监控" checked>
                        <input type="checkbox" name="like[read]" title="5.批量管理" checked>
                        <input type="checkbox" name="like[dai]" title="6.远程维护" checked>
                        </div>
                        <div class="layui-form-item">
                        <input type="checkbox" name="like[write]" title="7.设备状态" checked>
                        <input type="checkbox" name="like[read]" title="8.环境数据" checked>
                        <input type="checkbox" name="like[dai]" title="9.能耗统计" checked>
                        </div>
                        <div class="layui-form-item">
                        <input type="checkbox" name="like[write]" title="10.用电安全" checked>
                        <input type="checkbox" name="like[read]" title="11.使用时长" checked>
                        <input type="checkbox" name="like[dai]" title="12.门禁系统" checked>
                        </div>
                    </div>

<%--                    <div class="layui-form-item">--%>
<%--                        <div class="layui-input-block">--%>
<%--                            <button class="layui-btn" lay-submit lay-filter="formDemo">保存</button>--%>
<%--                            <button type="reset" class="layui-btn layui-btn-primary">重置</button>--%>
<%--                        </div>--%>
<%--                    </div>--%>
                </form>
            </div>
        </div>


    </div>
</body>

<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>
<script>
    var table ;
    //重载表格数据
    function reloadTB(){
        table.reload('demo');
    }

    layui.use(['element','table'], function(){
        element = layui.element;
        table = layui.table;
        table.render({
            id:'demo',
            elem: '#demo'
            ,height: 'full-229'
            ,cellMinWidth:90
            ,url: 'getPermission' //数据接口
            ,page: true //开启分页
            ,limits:[10,20,30,50]
            ,limit:20
            ,cols: [[ //表头
                {type: 'numbers',title:'序号',fixed: 'left'}
                ,{field: 'id', title: 'ID', style:'display:none',width:1}
                ,{field: 'name', title: '权限名称'}
                ,{field: 'permissionNum',title:'模块'}
                ,{fixed: 'right', title:'操作', toolbar: '#barDemo', width:150}
            ]]
            ,done:function (res, curr, count) {
                $('[data-field="id"]').addClass('layui-hide');
            }
        });

        //监听行工具事件
        table.on('tool(test)', function(obj){
            var data = obj.data;
            //console.log(obj)
            if(obj.event === 'del'){
                layer.confirm('确定删除？', function(index){
                    var loading = layer.load(1, {shade: [0.1,'#fff']});
                    var temp = {
                        id:data.id
                    };
                    $.post('delPermission',temp,function (res) {
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
                    ,area: ['600px', '800px']
                    ,content: 'addDevView'
                    ,btn:['确认','取消']
                    ,success:function (layero, index) {
                        var body = layer.getChildFrame('body', index);
                        var form1 = body.find('#form1');
                        console.log(data);
                        formUtilEL.fillFormData(form1,data);

                        var childWindow = $(layero.find('iframe'))[0].contentWindow;
                        data.type = '1';
                        childWindow.initModifyView(data);

                    },yes:function (index, layero) {
                        var body = layer.getChildFrame('body', index);
                        var form1 = body.find('#form1');
                        var tempData = formUtilEL.serializeObject(form1);
                        //删除无用信息
                        delete tempData.lineCount;
                        delete tempData.school;
                        delete tempData.house;
                        delete tempData.floor;

                        tempData.devSN = data.devSN;
                        tempData.id = data.id;
                        console.log(tempData);

                        var loading = layer.load(1, {shade: [0.1,'#fff']});
                        $.post('modifyDev',tempData,function (res) {
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
            else if(obj.event === 'row'){
                layer.open({
                    type: 2,
                    title: false,
                    area: ['1000px', '623px'],
                    shade: 0.8,
                    closeBtn: 0,
                    shadeClose: true,
                    content: 'switchView?devSN='+data.devSN
                    ,success: function(layero, index) {
                        layer.iframeAuto(index);
                    }
                });
            }
        });
    });

    $("#btnPermission").click(function () {
        //通过这种方式弹出的层，每当它被选择，就会置顶。
        layer.open({
            type: 2,
            shade: false,
            area: ['700px', '400px'],
            content: 'addPermission',
            //zIndex: layer.zIndex, //重点1
            btn:['确认','取消'],
            yes: function (index, layero) {
                var body = layer.getChildFrame('body', index);
                var form1 = body.find('#form1');
                var data = formUtilEL.serializeObject(form1);
                console.log(data);
                for(var key in data){
                    console.log("-------------"+key,data[key]);
                    if(data[key] == null || data[key] == ''){
                        layer.msg(body.find('[name="'+key+'"]').attr('placeholder'));
                        return;
                    }

                    if(key == "permission"){
                        var str = [];
                        str = data[key];
                        var permission = "";
                        for(var i = 0;i<str.length;i++){
                            permission+= str[i] + ",";
                        }
                    }

                    if(key == "name"){
                        var name = data[key];
                    }
                }
                console.log("permission:"+permission);


                var loading = layer.load(1, {shade: [0.1,'#fff']});
                $.post('addPermissionName',{name:name,permission:permission},function (res) {
                    if(Number(res.code) > 0){
                        layer.close(index);
                        reloadTB();
                    }
                    layer.msg(res.msg);
                }).fail(function (xhr) {
                    layer.msg('添加失败 '+xhr.status);
                }).always(function () {
                    layer.close(loading);
                });
            }
        });
    })

</script>
</html>
