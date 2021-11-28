<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        .layui-form-label{
            width: 120px
        }
        .layui-input-block{
            margin-left: 130px;
            margin-right: 50px;
        }
        .layui-form-item{
            margin: 20px 0;
        }
        .bodyDiv{
            /*width: 300px;*/
        }
    </style>
</head>
<body>
    <div class="bodyDiv">
        <form id="form1" class="layui-form">
            <div class="layui-form-item ">
                <label class="layui-form-label">开始时间选择</label>
                <div class="layui-input-block">
                    <input type="text" class="layui-input" id="startTime">
                </div>
            </div>

            <div class="layui-form-item ">
                <label class="layui-form-label">结束时间选择</label>
                <div class="layui-input-block">
                    <input type="text" class="layui-input" id="endTime">
                </div>
            </div>

            <div class="layui-form-item ">
                <label class="layui-form-label">开时间段选择</label>
                <div class="layui-input-block">
                    <select name="floor" lay-filter="select" title="时间段选择">
                        <option value="">8:00-10:00</option>
                        <option value="">10:00-16:00</option>
                        <option value="">16:00-6:00</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item ">
                <label class="layui-form-label">关时间段选择</label>
                <div class="layui-input-block">
                    <select name="floor" lay-filter="select" title="时间段选择">
                        <option value="">8:00-10:00</option>
                        <option value="">10:00-16:00</option>
                        <option value="">16:00-6:00</option>
                    </select>
                </div>
            </div>

<%--            <div class="layui-form-item ">--%>
<%--                <label class="layui-form-label">设备ID</label>--%>
<%--                <div class="layui-input-block">--%>
<%--                    <input type="number" name="devId"  min="1" max="247" lay-verify="required" autocomplete="off" placeholder="请输入设备ID" class="layui-input">--%>
<%--                </div>--%>
<%--            </div>--%>
<%--            <div class="layui-form-item ">--%>
<%--                <label class="layui-form-label">设备名称</label>--%>
<%--                <div class="layui-input-block">--%>
<%--                    <input type="text" name="devName" lay-verify="required" autocomplete="off" placeholder="请输入设备名称" class="layui-input">--%>
<%--                </div>--%>
<%--            </div>--%>

        </form>
    </div>
</body>

<script>
    var form ;
    layui.use('form', function(){
        form = layui.form;

        form.on('select(select)', function(data){
            // console.log(data.elem); //得到select原始DOM对象
            // console.log(data.value); //得到被选中的值
            // console.log(data.othis); //得到美化后的DOM对象
            var select = $(data.elem);
            console.log( select.val(),select.find("option:selected").text());//选中的文本);

            var name = select.attr('name');
            console.log(name);
            if(name == 'school'){
                $.post('getChildrenOrganize',{id:select.val()},function (res) {
                    console.log(res);
                    $('[name="house"]').html('<option value="">楼栋选择</option>');
                    res.forEach(function (value,index) {
                        $('[name="house"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                    });
                    $('[name="floor"]').html('<option value="">楼层选择</option>');
                    $('[name="room"]').html('<option value="">房号选择</option>');
                    form.render('select');
                })
            }else if(name == 'house'){
                $.post('getChildrenOrganize',{id:select.val()},function (res) {
                    console.log(res);
                    $('[name="floor"]').html('<option value="">楼层选择</option>');
                    res.forEach(function (value,index) {
                        $('[name="floor"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                    });
                    $('[name="room"]').html('<option value="">房号选择</option>');
                    form.render('select');
                })
            }else if(name == 'floor'){
                $.post('getChildrenOrganize',{id:select.val()},function (res) {
                    console.log(res);
                    $('[name="room"]').html('<option value="">房号选择</option>');
                    res.forEach(function (value,index) {
                        $('[name="room"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                    });
                    form.render('select');
                })
            }
        });
    });

</script>
<script>
    //初始化
    function init(data) {
        var type = data.type;
        console.log('type',type);

        if(type == 'switch'){
            $('.div-lineCount').removeClass('layui-hide');
        }

    }

    function initModifyView(data){
        $('[name="school"]').html('<option value="1">'+data.school+'</option>');
        $('[name="house"]').html('<option value="2">'+data.house+'</option>');
        $('[name="floor"]').html('<option value="3">'+data.floor+'</option>');
        $('[name="room"]').html('<option value="4">'+data.room+'</option>');

        $('[name="school"]').attr('disabled','');
        $('[name="house"]').attr('disabled','');
        $('[name="floor"]').attr('disabled','');
        $('[name="room"]').attr('disabled','');
        $('[name="lineCount"]').attr('disabled','');
        $('[name="devId"]').attr('disabled','');


        if(data.type == '1'){
            //空开设备
            $('.div-lineCount').removeClass('layui-hide');
        }else if(data.type == '2'){
            //空调控制设备
        }

        form.render('select');
    }
</script>
<script>
    layui.use('laydate', function(){
        var laySdate = layui.laydate;
        var layEdate = layui.laydate;

        //执行一个laydate实例
        laySdate.render({
            elem: '#startTime' //指定元素
        });

        layEdate.render({
            elem: '#endTime' //指定元素
        });
    });
</script>
</html>
