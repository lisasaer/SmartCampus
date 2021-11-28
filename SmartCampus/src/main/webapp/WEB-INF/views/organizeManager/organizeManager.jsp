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
    <title>区域管理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <jsp:include page="../header/res.jsp"></jsp:include>

</head>
<body class="layui-layout-body">
    <div class="layui-layout layui-layout-admin">
        <!-- 头部区域（可配合layui已有的水平导航） -->
        <jsp:include page="../header/topHead.jsp"></jsp:include>
        <div class="layui-body" style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;">
            <!-- 内容主体区域 -->
            <div class="my-tree-div">
                <div id="btnAddTree" title="添加区域" class="my-iconset my-icon-addVideo"></div>
                <div id="btnDel" title="删除" class="my-iconset my-icon-del"></div>
                <hr style="margin: 2px;">
                <ul id="tt"></ul>
            </div>

            <div class="my-tree-body-div" style="    bottom: 0px; margin-left: 25px;margin-top: 4px; margin-bottom: 15px;">
                <fieldset class="layui-elem-field layui-field-title">
                    <legend style="font-size: 16px;">详细信息</legend>
                </fieldset>

                <%--     控制中心     --%>
                <div class="layui-hide my-xq-add-ctrl ddd">
                    <div class="my-tree-div-add" role="alert" style="display: block;">
                        添加控制中心 <strong class="">控制中心</strong> 的下级控制中心
                    </div>
                    <div class="my-btn-body">
                        <form class="layui-form maxWidthForm">
                            <div class="layui-form-item">
                                <label class="layui-form-label minWidthDiv">中心名称</label>
                                <div class="layui-input-block">
                                    <input name="inputName"  type="text" placeholder="请输入中心名称" autocomplete="off" class="layui-input" lay-verify="required">
                                </div>
                            </div>
<%--                            <div class="layui-form-item">--%>
<%--                                <label class="layui-form-label minWidthDiv">备注</label>--%>
<%--                                <div class="layui-input-block">--%>
<%--                                    <textarea name="remarks"  type="text" placeholder="备注" autocomplete="off" class="layui-input" lay-verify="required" style="min-height: 100px;"></textarea>--%>
<%--                                </div>--%>
<%--                            </div>--%>
                        </form>
                        <div class="layui-form-item">
                            <div class="layui-input-block">
                                <button zy="addCtrl" class="layui-btn layui-bg-blue" onclick="btnSave(this)">保存</button>
                                <button type="reset" class="layui-btn layui-btn-primary">取消</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="layui-hide my-xq-modify-ctrl ddd">
                    <div class="my-tree-div-modify" role="alert" style="display: block;">
                        修改控制中心 <strong class="">控制中心</strong>
                    </div>
                    <div class="my-btn-body">
                        <form class="layui-form maxWidthForm">
                            <div class="layui-form-item">
                                <label class="layui-form-label minWidthDiv">中心名称</label>
                                <div class="layui-input-block">
                                    <input name="inputName"  type="text" placeholder="请输入中心名称" autocomplete="off" class="layui-input" lay-verify="required">
                                </div>
                            </div>
<%--                            <div class="layui-form-item">--%>
<%--                                <label class="layui-form-label minWidthDiv">备注</label>--%>
<%--                                <div class="layui-input-block">--%>
<%--                                    <textarea name="remarks"  type="text" placeholder="备注" autocomplete="off" class="layui-input" lay-verify="required" style="min-height: 100px;"></textarea>--%>
<%--                                </div>--%>
<%--                            </div>--%>
                        </form>
                        <div class="layui-form-item">
                            <div class="layui-input-block">
                                <button zy="modifyCtrl"  class="layui-btn layui-bg-blue" onclick="btnSave(this)">保存</button>
                                <button type="reset" class="layui-btn layui-btn-primary" >取消</button>
                            </div>
                        </div>
                    </div>
                </div>

                <%--     区域     --%>
                <div class="my-xq-add-area layui-hide ddd">
                    <div class="my-tree-div-add" role="alert" style="display: block;">
                        添加区域 <strong class="">区域</strong>的下级区域
                    </div>
                    <div class="my-btn-body">
                        <form class="layui-form maxWidthForm">
                            <div class="layui-form-item">
                                <label class="layui-form-label minWidthDiv">区域名称</label>
                                <div class="layui-input-block">
                                    <input name="inputName"  type="text" placeholder="请输入区域名称" autocomplete="off" class="layui-input" lay-verify="required">
                                </div>
                            </div>
<%--                            <div class="layui-form-item">--%>
<%--                                <label class="layui-form-label minWidthDiv">备注</label>--%>
<%--                                <div class="layui-input-block">--%>
<%--                                    <textarea name="remarks"  type="text" placeholder="备注" autocomplete="off" class="layui-input" lay-verify="required" style="min-height: 100px;"></textarea>--%>
<%--                                </div>--%>
<%--                            </div>--%>
                        </form>
                        <div class="layui-form-item">
                            <div class="layui-input-block">
                                <button zy="addArea"  class="layui-btn layui-bg-blue" onclick="btnSave(this)">保存</button>
                                <button type="reset" class="layui-btn layui-btn-primary">取消</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="my-xq-modify-area layui-hide ddd">
                    <div class="my-tree-div-modify" role="alert" style="display: block;">
                        修改区域 <strong class="">区域</strong>
                    </div>
                    <div class="my-btn-body">
                        <form class="layui-form maxWidthForm">
                            <div class="layui-form-item">
                                <label class="layui-form-label minWidthDiv">区域名称</label>
                                <div class="layui-input-block">
                                    <input name="inputName"  type="text" placeholder="请输入区域名称" autocomplete="off" class="layui-input" lay-verify="required">
                                </div>
                            </div>
<%--                            <div class="layui-form-item">--%>
<%--                                <label class="layui-form-label minWidthDiv">备注</label>--%>
<%--                                <div class="layui-input-block">--%>
<%--                                    <textarea name="remarks"  type="text" placeholder="备注" autocomplete="off" class="layui-input" lay-verify="required" style="min-height: 100px;"></textarea>--%>
<%--                                </div>--%>
<%--                            </div>--%>
                        </form>
                        <div class="layui-form-item">
                            <div class="layui-input-block">
                                <button zy="modifyArea"  class="layui-btn layui-bg-blue" onclick="btnSave(this)">保存</button>
                                <button type="reset" class="layui-btn layui-btn-primary" >取消</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</body>

<script>
    var list = [];
    list.push($('.my-xq-add-ctrl'));
    list.push($('.my-xq-add-area'));
    list.push($('.my-xq-modify-ctrl'));
    list.push($('.my-xq-modify-area'));

    $(function () {
        leftThis("区域信息");
        // list.forEach(function (value, index) {
        //     value.removeClass('layui-hide');
        // })
    });

    $('[type="reset"]').click(function () {
        //alert(111);
        $(this).closest('.ddd').addClass('layui-hide');
    });

    $('#tt').tree({
        url:'getTreeData?iconCls=1'
    });

    $('#tt').tree({
        onClick: function(node){
            //console.log(node);
            $('strong').text(node.text);
            $('[name="inputName"]').val(node.text);

            if(node.iconCls == "my-tree-icon-1"){
                show($('.my-xq-modify-ctrl'));
            }else{
                show($('.my-xq-modify-area'));
            }
        }
    });

    function show(dom){
        list.forEach(function (value, index) {
            if(value[0] == dom[0]){
                value.removeClass('layui-hide');
            }else{
                value.addClass('layui-hide');
            }
        })
    }

    function btnSave(dom){
        //console.log(dom);
        var inputName = $(dom).closest('.my-btn-body').find('[name="inputName"]').val();
        console.log($(dom).attr('zy'),inputName);
        var type = $(dom).attr('zy');
        if(inputName.length < 1){
            MyUtil.msg('请输入'+((type.indexOf('Ctrl') > -1)?'中心名称':'区域名称'),1000);
            return;
        }
        var selected = $('#tt').tree('getSelected');
        if(type == 'addCtrl'){
            var data = {};
            data.id = MyUtil.getUUid();
            data.text = inputName;
            data.iconCls = 'my-tree-icon-1';
            data.pId = selected.id;
            addTree(data,selected);
        }else if(type == 'addArea'){
            var data = {};
            data.id = MyUtil.getUUid();
            data.text = inputName;
            data.iconCls = 'my-tree-icon-2';
            data.pId = selected.id;
            addTree(data,selected);
        }else{
            if (selected){
                var data = {};
                data.id = selected.id;
                data.text = inputName;
                $.post('modifyTree',data,function (res) {
                    console.log(res);
                    $('#tt').tree('update', {
                        target: selected.target,
                        text: data.text
                    });
                    $('strong').text(data.text);
                })
            }
        }
    }

    // $('#btnNow').click(function () {
    //     var selected = $('#tt').tree('getSelected');
    //     if(selected == null){
    //         MyUtil.msg('请先选择节点');
    //         return;
    //     }
    //     //console.log(selected);
    // });

    //检测有无根节点,无根节点则默认添加根节点
    function checkRoot (){
        var root = $('#tt').tree('getRoot');
        if(root == null){
            var data = {};
            data.id = MyUtil.getUUid();
            data.pId = 0;
            data.text = '根节点';
            data.iconCls = 'my-tree-icon-1';
            $.post('addTree',data,function (res) {
                $('#tt').tree('append', {
                    parent: null,
                    data: [{
                        id: data.id,
                        text: data.text
                        ,iconCls:data.iconCls
                        ,pId:data.pId
                    }]
                });
            });
            return true;
        }
        return false;
    }

    // $('#btnAddArea').click(function () {
    //     if(checkRoot()){
    //         return;
    //     }
    //
    //     var selected = $('#tt').tree('getSelected');
    //     if(selected == null){
    //         MyUtil.msg('请先选择节点');
    //         return;
    //     }
    //
    //     if(selected.iconCls == 'my-tree-icon-2'){
    //         MyUtil.msg('区域下无法添加',1000);
    //         return;
    //     }
    //
    //     $('[name="inputName"]').val('');
    //     $('[name="remarks"]').val('');
    //     show($('.my-xq-add-ctrl'));
    //
    //     return;
    //
    //     var data = {};
    //     data.id = MyUtil.getUUid();
    //     data.text = $('#nodeName').val();
    //     data.iconCls = 'my-tree-icon-1';
    //     data.pId = selected.id;
    //
    //     addTree(data,selected);
    // });

    // $('#btnAddVideo').click(function () {
    //     if(checkRoot()){
    //         return;
    //     }
    //
    //     var selected = $('#tt').tree('getSelected');
    //     if(selected == null){
    //         MyUtil.msg('请先选择节点');
    //         return;
    //     }
    //
    //     if(selected.iconCls == 'my-tree-icon-2'){
    //         MyUtil.msg('区域下无法添加',1000);
    //         return;
    //     }
    //
    //     $('[name="inputName"]').val('');
    //     $('[name="remarks"]').val('');
    //     show($('.my-xq-add-area'));
    //
    //     return;
    //
    //     var data = {};
    //     data.id = MyUtil.getUUid();
    //     data.text = $('#nodeName').val();
    //     data.iconCls = 'my-tree-icon-2';
    //     data.pId = selected.id;
    //
    //     addTree(data,selected);
    // });


    $('#btnAddTree').click(function () {
        if(checkRoot()){
            return;
        }

        var selected = $('#tt').tree('getSelected');
        if(selected == null){
            MyUtil.msg('请先选择节点');
            return;
        }
        var iconCls = selected.iconCls;
        var level = Number(iconCls.substring(iconCls.length-1,iconCls.length));
        console.log(iconCls,level);

        if(level == 5){
            MyUtil.msg('当前区域下无法添加');
            return;
        }

        layer.prompt({title:'请输入区域名称'},function(value, index, elem){
            console.log(value); //得到value
            layer.close(index);

            var data = {};
            data.text = value;
            // switch (level) {
            //     case 1:
            //         data.text = 'xx校区';
            //         break;
            //     case 2:
            //         data.text = 'xx幢';
            //         break;
            //     case 3:
            //         data.text = 'xx楼层';
            //         break;
            //     case 4:
            //         data.text = 'xx房号';
            //         break;
            //     case 5:
            //         return;
            // }


            data.id = MyUtil.getUUid();
            data.iconCls = 'my-tree-icon-'+(level+1);
            data.pId = selected.id;
            addTree(data,selected);
        });
    });

    function addTree(data,node){
        $.post('addTree',data,function (res) {
            $('#tt').tree('append', {
                parent: node.target,
                data: [{
                    id: data.id,
                    text: data.text
                    ,iconCls:data.iconCls
                    ,pId:data.pId
                }]
            });
        })
    }

    $('#btnDel').click(function () {
        var selected = $('#tt').tree('getSelected');
        if(selected == null){
            MyUtil.msg('请先选择节点');
            return;
        }
        layer.confirm('此操作会连带删除此区域下关联的所有人员和设备信息，请再次确认是否删除？',{

            yes : function (index,layero) {
                var loading = layer.msg('<span style="font-size:20px">删除中...请等待</span>', {icon: 16, shade: 0.3, time:0,});
                console.log("-----------"+selected);
                $.each(selected,function (index,item) {
                    console.log(index,item)
                })
                $.ajax({
                    url: "/delTree",
                    type: "POST",
                    data: {"id": selected.id,"iconCls":selected.iconCls},
                    success: function () {
                        layer.close(loading);
                        // $(".layui-laypage-btn").click();//刷新本页面（父页面） 的数据
                        $('#tt').tree('remove',selected.target);
                        $('.my-tree-body-div').find('.ddd').addClass('layui-hide');
                        //关闭弹框
                        // layer.close(index);
                        layer.msg("删除成功", {icon: 6});
                    },
                    error: function () {
                        layer.alert("删除失败");
                    },
                });
                // $.post('delTree',{id:selected.id},function (res) {
                //     $('#tt').tree('remove',selected.target);
                //     $('.my-tree-body-div').find('.ddd').addClass('layui-hide');
                // })
            }
        });
        //console.log(selected);
        // $.post('delTree',{id:selected.id},function (res) {
        //     $('#tt').tree('remove',selected.target);
        //     $('.my-tree-body-div').find('.ddd').addClass('layui-hide');
        // })
    });

    // $('#btnModify').click(function () {
    //     var node = $('#tt').tree('getSelected');
    //
    //     if (node){
    //         var data = {};
    //         data.id = node.id;
    //         data.text = $('#nodeName').val();
    //         $.post('modifyTree',data,function (res) {
    //             console.log(res);
    //             $('#tt').tree('update', {
    //                 target: node.target,
    //                 text: data.text
    //             });
    //         })
    //     }
    // });

    layui.use(['tree','element'], function(){
        var tree = layui.tree
            ,element = layui.element;
    });
</script>
</html>
