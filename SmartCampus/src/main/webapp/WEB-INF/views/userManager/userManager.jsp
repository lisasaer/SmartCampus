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
    <title>人员管理</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        .layui-table-cell{
            height:40px;
            line-height: 40px;
        }
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
            <div <%--style="padding: 15px;"--%>>
                <div>
                    <button id="btnAdd" type="button" class="layui-btn" >添加人员</button>
<%--                    <button type="button" class="layui-btn ">导入人员</button>--%>
                </div>
                <table id="demo" lay-filter="test"></table>
            </div>
        </div>

<%--         --%>
    </div>
</body>

<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>

<script>
    layui.use(['element','table'], function(){
        var table = layui.table
            ,element = layui.element;

        table.render({
            id:'demo',
            elem: '#demo'
            ,height: 'full-210'
            ,cellMinWidth:90
            ,url: 'getAllUser' //数据接口
            ,page: true //开启分页
            ,limits:[10,20,30,50]
            ,limit:20
            ,cols: [[ //表头
                {type: 'numbers',title:'序号',fixed: 'left'}
                ,{field: 'id', title: 'ID', style:'display:none',width:1}
                ,{field: 'username', title: '用户名'}
                ,{field: 'typename',title:'权限类型'}
                ,{fixed: 'right', title:'操作', toolbar: '#barDemo', width:150}
            ]]
            ,done:function (res, curr, count) {
                $('[data-field="id"]').addClass('layui-hide');
                $('[data-field="imgPath"]').css('text-align','center');
            }
        });

        //重载表格  刷新表格数据
        function reloadTb(){
            table.reload('demo');
        }

        $('#btnAdd').click(function () {
            layer.open({
                type: 2,
                title:'添加人员',
                area: ['450px', '350px'],
                fixed: false, //不固定
                content: 'AddUserForm',
                btn:['确认','取消'],
                yes: function (index, layero) {
                    var body = layer.getChildFrame('body', index);
                    var form1 = body.find('#form1');
                    var data = formUtilEL.serializeObject(form1);
                    //console.log(data);
                    for(var key in data){
                        //console.log(key,data[key]);
                        if(data[key] == null || data[key] == ''){
                            layer.msg(body.find('[name="'+key+'"]').attr('placeholder'));
                            return;
                        }
                    }
                    var loading = layer.load(1, {shade: [0.1,'#fff']});
                    $.post('addUser',data,function (res) {
                        if(Number(res.code) > 0){
                            layer.close(index);
                            reloadTb();
                        }
                        layer.msg(res.msg);
                    }).fail(function (xhr) {
                        layer.msg('添加失败 '+xhr.status);
                    }).always(function () {
                        layer.close(loading);
                    });
                }
            })
        });

        //监听行工具事件
        table.on('tool(test)', function(obj){
            //console.log(obj)
            var data = obj.data;
            //console.log('id',data.id);
            if(obj.event === 'previewImg'){
                layer.open({
                    type: 1,
                    title: false,
                    closeBtn: 0,
                    area: ['auto'],
                    skin: 'layui-layer-nobg', //没有背景色
                    shadeClose: true,
                    content: '<img src="'+data.imgPath+'">'
                });
            }
            else if(obj.event === 'del'){
                layer.confirm('确定删除该用户？', function(index){
                    var loading = layer.load(1, {shade: [0.1,'#fff']});
                    $.post('delUser',{userid:data.id},function (res) {
                        obj.del();
                        layer.close(index);
                        layer.msg('删除成功');
                        reloadTb();
                    }).fail(function (xhr) {
                        layer.msg('删除失败 '+xhr.status);
                        console.log(xhr.status);
                    }).always(function () {
                        layer.close(loading);
                    });
                });
            } else if(obj.event === 'edit'){
                layer.open({
                    type:2
                    ,zIndex:999
                    ,title:'人员修改'
                    ,area: ['450px', '350px']
                    ,content: 'AddUserForm'
                    ,btn:['确认','取消']
                    ,success:function (layero, index) {
                        var body = layer.getChildFrame('body', index);
                        var form1 = body.find('#form1');
                        console.log(data);
                        formUtilEL.fillFormData(form1,data);

                        body.find('#username').attr('readonly','readonly');
                        body.find('#password').val('******');
                        body.find('#password').attr('readonly','readonly');

                    },yes:function (index, layero) {
                        var body = layer.getChildFrame('body', index);
                        var form1 = body.find('#form1');
                        var tempData = formUtilEL.serializeObject(form1);

                        tempData.devSN = data.devSN;
                        tempData.id = data.id;
                        console.log(tempData);

                        var loading = layer.load(1, {shade: [0.1,'#fff']});
                        $.post('modifyUser',tempData,function (res) {
                            if(res.code > 0){
                                layer.close(index);
                                reloadTb();//重载表格
                            }
                            layer.msg(res.msg);
                        }).fail(function (xhr) {
                            layer.msg('修改失败 '+xhr.status);
                        }).always(function () {
                            layer.close(loading);
                        })
                    }
                })
            }
        });
    });

</script>
</html>
