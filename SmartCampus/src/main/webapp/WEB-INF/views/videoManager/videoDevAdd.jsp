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
    <title>添加监控设备</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        /*.layui-form-label{*/
        /*    width: 120px*/
        /*}*/
        /*.layui-input-block{*/
        /*    margin-left: 130px;*/
        /*    margin-right: 50px;*/
        /*}*/
        /*.layui-form-item{*/
        /*    margin: 20px 0;*/
        /*}*/
        /*.bodyDiv{*/
        /*    !*width: 300px;*!*/
        /*}*/
        .layui-input{
            max-width: 192px;
        }
        .layui-form-item{
            height: 38px;
            margin-bottom: 5px;
        }
        /*下拉框最大高度*/
        .layui-form-select dl{
            max-height: 150px;
        }
        /*修改label内边距*/
        .layui-form-pane .layui-form-label {
            padding: 8px 10px;
            text-align: end;
        }
        /*下拉框中被选中的颜色*/
        .layui-form-select dl dd.layui-this {
            background-color: #1666f9;
        }
        /*去除下拉框中layui的自带箭头*/
        .layui-form-select .layui-edge {
            display: none;
        }
        /*下拉框箭头图片*/
        .layui-select-title input {
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 157px center transparent;
        }
        /*点击后的下拉框箭头图片*/
        .layui-form-selected  .layui-select-title input{
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 157px center transparent;
        }
    </style>
</head>
<body>
<div class="bodyDiv"  style="margin-left:15px; margin-top:15px ;">
    <form class="layui-form layui-form-pane" name="form1" action="">
        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">校区:</label>
            <div class="layui-input-inline">
                <select id="school" name="schoolId" lay-filter="selectSchool" title="校区选择" >
                    <%--<option value="0">请选择</option>--%>
                        <option value="">请选择</option>
                    <c:forEach items="${schoolList}" var="item">
                        <option value="${item.id}">${item.text}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label">楼栋:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <select id="house" name="houseId" lay-filter="selectHouse" title="楼栋选择">
                    <%--                            <option value="">楼栋选择</option>--%>
                    <%--<option value="0">无</option>--%>
                        <option value="">请选择</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">楼层:</label>
            <div class="layui-input-inline">
                <select id="floor" name="floorId" lay-filter="selectFloor" title="楼层选择">
                    <%--                            <option value="">楼层选择</option>--%>
                   <%-- <option value="0">无</option>--%>
                        <option value="">请选择</option>
                </select>
            </div>
        </div>
        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label">房号:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <select id="room" name="roomId" lay-filter="selectRoom" title="房号选择">
                    <%--                            <option value="">房号选择</option>--%>
                    <%--<option value="0">无</option>--%>
                        <option value="">请选择</option>
                </select>
            </div>
        </div>

        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">监控设备名称:</label>
            <div class="layui-input-inline">
                <input type="text" name="devName" lay-verify="required" placeholder="请输入设备名称" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label">监控设备类型:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <select id="selType" name="devType" lay-filter="test">
                    <option value="IPC">IPC</option>
                    <option value="NVR">NVR</option>
                </select>
            </div>
        </div>
        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">监控设备IP:</label>
            <div class="layui-input-inline">
                <input type="text" name="ip" lay-verify="required" placeholder="请输入设备IP"
                       autocomplete="off" class="layui-input">
            </div>
        </div>
        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label">子网掩码:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="netMask" lay-verify="required" placeholder="请输入子网掩码"
                       autocomplete="off" value="255.255.255.0" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">默认网关:</label>
            <div class="layui-input-inline">
                <input type="text" name="gateWay" lay-verify="required" placeholder="请输入网关"
                       autocomplete="off" class="layui-input" value="192.168.0.1">
            </div>
        </div>
        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label">端口号:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="port" lay-verify="required" placeholder="请输入端口" autocomplete="off"
                       class="layui-input" value="80">
            </div>
        </div>
        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">用户名:</label>
            <div class="layui-input-inline">
                <input type="text" name="username" lay-verify="required" placeholder="请输入用户名" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label">密码:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="password" lay-verify="required" placeholder="请输入密码" autocomplete="off"
                       class="layui-input">
            </div>
        </div>


        <div style="padding-top: 20px"></div>
        <div class="layui-form-item" hidden="hidden">
            <button id="submitBtn" class="layui-btn" lay-submit="" lay-filter="demo2">保存</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
        </div>
    </form>
</div>
</body>

<script>
    var form ;
    layui.use(['table', 'element', 'form'], function () {
        table = layui.table
            , $ = layui.jquery
            , form = layui.form
            , element = layui.element;

        $(function () {
            //监听下拉框选中事件
            var school;
            var house;
            var floor;
            var room;

            form.on('select(selectSchool)', function (data) {
                var select = $(data.elem);
                var id =select.val();
                /*if(id==0){
                    $('[name="houseId"]').html('<option value="0">无</option>');
                    $('[name="floorId"]').html('<option value="0">无</option>');
                    $('[name="roomId"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if(id==""){
                    $('[name="houseId"]').html('<option value="">请选择</option>');
                    $('[name="floorId"]').html('<option  value="">请选择</option>');
                    $('[name="roomId"]').html('<option  value="">请选择</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        /*$('[name="houseId"]').html('<option value="0">无</option>');*/
                        res.forEach(function (value,index) {
                            $('[name="houseId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        /*$('[name="floorId"]').html('<option value="0">无</option>');
                        $('[name="roomId"]').html('<option value="0">无</option>');*/
                        form.render('select');
                    })
                }
                school = data.elem[data.elem.selectedIndex].text
                console.log("school : " + school)

            });
            form.on('select(selectHouse)', function (data) {

                var select = $(data.elem);
                var id =select.val();
                /*if(id==0){
                    $('[name="floorId"]').html('<option value="0">无</option>');
                    $('[name="roomId"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        /*$('[name="floorId"]').html('<option value="0">无</option>');*/
                        res.forEach(function (value,index) {
                            $('[name="floorId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        /*$('[name="roomId"]').html('<option value="0">无</option>');*/
                        form.render('select');
                    })
                }
                house = data.elem[data.elem.selectedIndex].text
                console.log("house : " + house)
            });
            form.on('select(selectFloor)', function (data) {

                var select = $(data.elem);
                var id =select.val();
                /*if(id==0){
                    $('[name="roomId"]').html('<option value="0">无</option>');
                    form.render('select');
                }*/
                if(id!=0) {
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        /*$('[name="roomId"]').html('<option value="0">无</option>');*/
                        res.forEach(function (value,index) {
                            $('[name="roomId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        form.render('select');
                    })
                }
                floor = data.elem[data.elem.selectedIndex].text
                // $.post('queryLoraDevByFloor',{school:school,house:house,floor:floor},function (res) {
                //     $("#loraSN").val("");
                //     $.each(res,function (index, item) {
                //         $("#loraSN").val(item.loraSN);
                //     });
                // })
                console.log("floor : " + floor)
            });
            form.on('select(selectRoom)', function (data) {

                room = data.elem[data.elem.selectedIndex].text
                console.log("room : " + room)
            });
        });

        var loginForm=document.forms['form1'],
            ip=loginForm.elements['ip'];
        ip.onchange=function(){
            console.log(ip.value);
            if(ip!=""){
                console.log("设备IP校验"+ip.value);
                $.ajax({
                    type: "POST",
                    url: 'selectVideoDevIP',  //从数据库查询返回的是个list
                    dataType: "json",
                    data: {"ip":ip.value},
                    success: function (data) {
                        if(data.code==1){
                            layer.msg("设备IP已存在！");
                            return false;
                        }
                    }, error: function () {
                        layer.msg("校验失败！");
                        return false;
                    }
                })
            }
        }

        //监听提交
        form.on('submit(demo2)', function (data) {
            var loading = layer.msg('设备注册中', {icon: 16, shade: 0.3, time:0});

            var status = false;
            $.ajax({
                type: "POST",
                url: 'selectVideoDevIP',  //从数据库查询返回的是个list
                dataType: "json",
                data: {"ip":data.field.ip},
                async:false,
                success: function (data) {
                    if(data.code==1){
                        layer.msg("设备IP已存在！");
                        status=true;
                        return false;
                    }
                }, error: function () {
                    layer.msg("校验失败！");
                    return false;
                }
            })
            if(!status){
                $.ajax({
                    url: "/addVideo",
                    type: "POST",
                    async: false,//同步
                    contentType: 'application/json',
                    data: JSON.stringify(data.field),
                    success: function (res) {
                        layer.close(loading);
                        if(res.code>0){
                            layer.msg('设备注册成功！',{time:1000});
                            //window.location.href = 'goMachine';
                            var index=parent.layer.getFrameIndex(window.name); //获取当前窗口的name
                            parent.layer.close(index);
                        }else{
                            layer.msg('设备注册失败！',{time:1500});
                        }
                    }
                });
            }

            return false;
        });
    });

</script>
<script>
    //初始化
    // function init(data) {
    //     // var type = data.type;
    //     // console.log('type',type);
    //     //
    //     // if(type == 'switch'){
    //     //     $('.div-lineCount').removeClass('layui-hide');
    //     // }
    //
    // }

    function init(data){
        $('[name="school"]').html('<option value="1">'+data.school+'</option>');
        $('[name="house"]').html('<option value="2">'+data.house+'</option>');
        $('[name="floor"]').html('<option value="3">'+data.floor+'</option>');
        $('[name="room"]').html('<option value="4">'+data.room+'</option>');

        $('[name="school"]').attr('disabled','true');
        $('[name="house"]').attr('disabled','');
        $('[name="floor"]').attr('disabled','');
        $('[name="room"]').attr('disabled','');
        $('[name="username"]').attr('disabled','true');
        $('[name="password"]').attr('disabled','');
        $('[name="ip"]').attr('disabled','');
        $('[name="port"]').attr('disabled','');

        form.render('select');
    }
</script>
</html>
