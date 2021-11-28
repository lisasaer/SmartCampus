<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2019/11/22
  Time: 19:56
  To change this template use File | Settings | File Templates.
--%>
<%
    boolean bComOpen = Boolean.valueOf(request.getSession().getAttribute("comOpen").toString());
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title>部门管理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <jsp:include page="../header/res.jsp"></jsp:include>
<%--    <link rel="stylesheet" href="/css/layui.css" media="all">--%>

</head>

<body>

<div class="layui-layout layui-layout-admin">
    <jsp:include page="../header/topHead.jsp"></jsp:include>
    <div class="layui-body">
        <!-- 内容主体区域 -->
        <div style="padding: 15px;">
            <span>部门管理</span>

<%--            <form class="layui-form" action="">--%>
<%--                <div class="demoTable">--%>
<%--                    <div class="layui-inline">--%>
<%--                        <input class="layui-input" name="id" id="demoReload" placeholder="部门名称" autocomplete="off"  style="width: 120px;height: 30px;">--%>
<%--                    </div>--%>
<%--                    <button class="layui-btn" data-type="reload" style="height: 30px;line-height: 0px;">搜索</button>--%>
<%--                    <button type="reset" class="layui-btn layui-btn-primary" style="height: 30px;line-height: 0px;">重置</button>--%>
<%--                </div>--%>
<%--            </form>--%>
            <div id="test1"></div>
        </div>
    </div>

</div>


<%--<script src="/js/layui.js"></script>--%>
<script>
    leftThis('部门管理');
    layui.use(['tree', 'util', 'element', 'layer'], function () {
        var tree = layui.tree
            , layer = layui.layer
            , util = layui.util
            , $ = layui.jquery
            , element = layui.element;

        $(document).ready(function () {
            $("#li4").addClass("layui-this");
            $("#d1").addClass("layui-this");
        });
        init();
        var number;

        // tree.render({
        //     elem: '#test1'
        //     ,content:"/DepartmentText"
        //     ,data: data1
        //     ,edit: ['add', 'update', 'del'] //操作节点的图标
        //     ,click: function(obj){
        //         layer.msg(JSON.stringify(obj.data));
        //     }
        // });
        function init() {
            $.ajax({
                url: "/DepartmentText",
                type: "POST",
                dataType: "json",
                success: function (data) {
                    //可以重载所有基础参数
                    tree.reload('demoId', {
                        data: data
                    });
                    // $.each(data[0],function (index,item) {
                    //     console.log("load:---"+index+" : " + item);
                    //     if(index=="children"){
                    //         number = data[0].children.length
                    //         console.log(data[0].children.length);
                    //         for(var key=0;key<data[0].children.length;key++){
                    //             $.each(data[0].children[key],function (index,item) {
                    //                 console.log("children:---" + index + " : " + item);
                    //                 /*$.each(data[0].children[key][0],function (index2,item2) {
                    //                     console.log("children:---" + index2 + " : " + item2);
                    //                 })*/
                    //             })
                    //         }
                    //
                    //     }
                    // })
                },
                error: function () {
                    layer.alert("数据加载失败");
                },
            });
        };

        //渲染
        tree.render({
            elem: '#test1'
            , id: 'demoId'//绑定元素
            , edit: ['add', 'update', 'del'] //操作节点的图标
            , treeDefaultClose: false
            , treeLinkage: false
            , click: function (obj) {
                layer.msg(JSON.stringify(obj.data));
            }, operate: function (obj) {
                var type = obj.type; //得到操作类型：add、edit、del
                var data = obj.data; //得到当前节点的数据
                var elem = obj.elem; //得到当前节点元素
                //Ajax 操作
                //var parentId = data.rootId; //得到节点索引
                //var id1 = data.parentId;
                $.each(data,function (index,item) {
                    console.log("查看数据"+index+" : " + item);
                })
                $.each(elem[0],function (index,item) {
                    //console.log("查看elem"+index+" : " + item);
                })
                console.log("type:"+type);
                console.log("data:"+data);
                console.log("elem:"+elem);
                //console.log("id:"+id);
               // console.log("id1:"+id1);
                if (type === 'add') { //增加节点
                    var parentId = data.rootId;//获取父节点的rootId作为新增的parentId
                    var title = "未命名";
                    console.log("发送请求");
                    console.log(parentId);
                    $.ajax({
                        url: "addDepartment",
                        type: "POST",
                        data: {"parentId":parentId ,"dname":title},
                        success: function (data) {
                            //可以重载所有基础参数
                            layer.alert("新增成功");

                            tree.reload('demoId', {
                                data: data
                            });

                        },
                        error: function () {
                            layer.alert("新增失败");
                        },
                    });

                } else if (type === 'update') { //修改节点
                    var rootId = data.rootId;
                    var dname= data.title;
                    $.ajax({
                            url: "/editDepartment",
                            type: "POST",
                            data: {"rootId": rootId,"dname":dname},
                            success: function (data) {
                                //可以重载所有基础参数
                                layer.alert("编辑成功");

                                tree.reload('demoId', {
                                    data: data
                                });
                            },
                            error: function () {
                                layer.alert("编辑失败");
                            },
                        });
                } else if (type === 'del') { //删除节点
                    var rootId = data.rootId;
                    layer.confirm('是否删除所选部门？该操作会删除该部门下的所有人员和设备,请谨慎操作！', {
                        yes: function (index, layero) {
                            layer.msg("删除中，请等待！");
                            $.ajax({
                                url: "/deleteDepartment",
                                type: "POST",
                                data: {"rootId": rootId},
                                success: function (data) {
                                    //可以重载所有基础参数
                                    layer.alert("删除成功");

                                    tree.reload('demoId', {
                                        data: data
                                    });
                                },
                                error: function () {
                                    layer.alert("删除失败");
                                },
                            });
                        }
                    });


                }
                ;
            }
        });
    });
</script>
</body>
</html>