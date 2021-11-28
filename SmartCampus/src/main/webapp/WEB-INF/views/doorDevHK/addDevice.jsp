<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2019/11/30
  Time: 14:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>添加人脸门禁设备</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <%--    <link rel="stylesheet" href="css/layui.css">--%>

    <style>
        .layui-form{

            text-align: center;
            margin-top: 10px;
            margin-bottom: 10px;
            margin-left: 25px;
            margin-right: 25px;
            width: 90%;
        }
        .layui-form-label {
            float: left;
            display: block;
            padding: 9px 15px;
            width: 156px;
            font-weight: 400;
            line-height: 20px;
            text-align: right;
        }
    </style>

    <style>
        .layui-input{
            /*max-width: 194px;*/
            width: 194px;
        }                           /*控制手打输入框*/
        .layui-input-block{
            /*text-align: center;*/
            width: 194px;
        }                          /*控制下拉框*/
        .layui-form-item{
            height: 38px;
            margin-bottom: 5px;
        }
        /*下拉框最大高度*/
        .layui-form-select dl{
            max-height: 120px;
        }
         /*修改label内边距*/
        .layui-form-pane .layui-form-label {
            border-style: none;
            width: 120px;
            height: 38px;
            text-align: left;
            /*padding: 8px 10px;
            text-align: end;*/
        }
        .layui-inline{
            margin-top: 3px;
        }
    </style>

</head>
<body>
<%--<div class="layui-layout layui-layout-admin">

    <div class="" style="left:0px;top: 0px;bottom: 0px;">--%>
        <!-- 内容主体区域 -->
        <%--< style="margin-left:15px; margin-top:15px ;/*max-width: 600px;display: inline-block ;*/">

            <form class="layui-form layui-form-pane" name="form" action="">

              <div class="layui-form-item"style="float: left;">
                   <label class="layui-form-label">校 区:</label>
                   <div class="layui-input-inline">
                       <select id="school" name="schoolId" lay-filter="selectSchool" title="校区选择" >
                           <option value="0">无</option>
                           <c:forEach items="${schoolList}" var="item">
                               <option value="${item.id}">${item.text}</option>
                           </c:forEach>
                       </select>
                   </div>
               </div>


               <div class=""style="padding-right: 20px;float: right">
                   <label class="layui-form-label">楼 栋:</label>
                   <div class="layui-input-inline" style="width: 190px;">
                       <select id="house" name="houseId" lay-filter="selectHouse" title="楼栋选择">
                           &lt;%&ndash;                            <option value="">楼栋选择</option>&ndash;%&gt;
                           <option value="0">无</option>
                       </select>
                   </div>
               </div>


               <div class="layui-form-item"style="float: left;">
                   <label class="layui-form-label">楼 层:</label>
                   <div class="layui-input-inline">
                       <select id="floor" name="floorId" lay-filter="selectFloor" title="楼层选择">
                           &lt;%&ndash;                            <option value="">楼层选择</option>&ndash;%&gt;
                           <option value="0">无</option>
                       </select>
                   </div>
               </div>


               <div class=""style="padding-right: 20px;float: right">
                   <label class="layui-form-label">房 号:</label>
                   <div class="layui-input-inline" style="width: 190px;">
                       <select id="room" name="roomId" lay-filter="selectRoom" title="房号选择">
                           &lt;%&ndash;                            <option value="">房号选择</option>&ndash;%&gt;
                           <option value="0">无</option>
                       </select>
                   </div>
               </div>

               <div class="layui-form-item"style="float: left;">
                   <label class="layui-form-label">人脸设备名称:</label>
                   <div class="layui-input-inline">
                       <input type="text" name="dname" lay-verify="required" placeholder="请输入设备名称" autocomplete="off"
                              class="layui-input">
                   </div>
               </div>
               <div class=""style="padding-right: 20px;float: right">
                   <label class="layui-form-label">设备类型:</label>
                   <div class="layui-input-inline" style="width: 190px;">
                       <select id="selType" name="dtype" lay-filter="test">
                           <option value="">请选择设备类型</option>
                           <option value="HIKVISION">HIKVISION</option>
                           <option value="UNIVIEM">UNIVIEM</option>
                           <option value="DAHUA">DAHUA</option>
                       </select>
                   </div>
               </div>
               <div class="layui-form-item"style="float: left;">
                   <label class="layui-form-label">设备IP:</label>
                   <div class="layui-input-inline">
                       <input type="text" name="dip" lay-verify="required" placeholder="请输入设备IP"
                              autocomplete="off" class="layui-input">
                   </div>
               </div>

               <div class=""style="padding-right: 20px;float: right">
                   <label class="layui-form-label">子网掩码:</label>
                   <div class="layui-input-inline" style="width: 190px;">
                       <input type="text" name="dnetMask" lay-verify="required" placeholder="请输入子网掩码"
                              autocomplete="off" value="255.255.255.0" class="layui-input">
                   </div>
               </div>

               <div class="layui-form-item"style="float: left;">
                   <label class="layui-form-label">默认网关:</label>
                   <div class="layui-input-inline">
                       <input type="text" name="dgateWay" lay-verify="required" placeholder="请输入网关"
                              autocomplete="off" class="layui-input" value="192.168.0.1">
                   </div>
               </div>

               <div class=""style="padding-right: 20px;float: right">
                   <label class="layui-form-label">端口号:</label>
                   <div class="layui-input-inline" style="width: 190px;">
                       <input type="text" name="port" lay-verify="required" placeholder="请输入端口" autocomplete="off"
                              class="layui-input" value="8000">
                   </div>
               </div>

               <div class="layui-form-item"style="float: left;">
                   <label class="layui-form-label">用户名:</label>
                   <div class="layui-input-inline">
                       <input type="text" name="duser" lay-verify="required" placeholder="请输入用户名" autocomplete="off"
                              class="layui-input">
                   </div>
               </div>

               <div class=""style="padding-right: 20px;float: right">
                   <label class="layui-form-label">密码:</label>
                   <div class="layui-input-inline" style="width: 190px;">
                       <input type="text" name="dpassWord" lay-verify="required" placeholder="请输入密码" autocomplete="off"
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
    </div>
</div>--%>
<div class="">
       <div >
        <form class="layui-form layui-form-pane" name="form" action="">

            <div class="layui-inline" >
                <label class="layui-form-label">校&nbsp;&nbsp;区:</label>
                <div class="layui-input-inline">
                    <select  id="school" name="schoolId" lay-filter="selectSchool" title="校区选择" >
                        <option value="">全部</option>
                        <c:forEach items="${schoolList}" var="item">
                            <option value="${item.id}">${item.text}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">楼&nbsp;&nbsp;栋:</label>
                <div class="layui-input-inline">
                    <select id="house" name="houseId" lay-filter="selectHouse" title="楼栋选择">
                        <option value="">全部</option>
                    </select>
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">楼&nbsp;&nbsp;层:</label>
                <div class="layui-input-inline">
                    <select id="floor" name="floorId" lay-filter="selectFloor" title="楼层选择">
                        <option value="">全部</option>
                    </select>
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">房&nbsp;&nbsp;号:</label>
                <div class="layui-input-inline">
                    <select id="room" name="roomId" lay-filter="selectRoom" title="房号选择">
                        <option value="">房号选择</option>
                    </select>
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">人脸设备名称:</label>
                <div class="layui-input-inline">
                    <input type="text" name="dname" lay-verify="required" placeholder="请输入人脸设备名称" autocomplete="off"
                           class="layui-input">
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">设备类型:</label>
                <div class="layui-input-inline">
                    <select id="selType" name="dtype" lay-filter="test">
                        <option value="HIKVISION">HIKVISION</option>
                        <option value="UNIVIEM">UNIVIEM</option>
                        <option value="DAHUA">DAHUA</option>
                    </select>
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">设备IP:</label>
                <div class="layui-input-inline">
                    <input type="text" name="dip" lay-verify="required" placeholder="请输入设备IP"
                           autocomplete="off" class="layui-input">
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">子网掩码:</label>
                <div class="layui-input-inline">
                    <input type="text" name="dnetMask" lay-verify="required" placeholder="请输入子网掩码"
                           autocomplete="off" value="255.255.255.0" class="layui-input">
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">默认网关:</label>
                <div class="layui-input-inline">
                    <input type="text" name="dgateWay" lay-verify="required" placeholder="请输入网关"
                           autocomplete="off" class="layui-input" value="192.168.0.1">
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">端口号:</label>
                <div class="layui-input-inline">
                    <input type="text" name="port" lay-verify="required" placeholder="请输入端口" autocomplete="off"
                           class="layui-input" value="8000">
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">用户名:</label>
                <div class="layui-input-inline">
                    <input type="text" name="duser" lay-verify="required" placeholder="请输入用户名" autocomplete="off"
                           class="layui-input">
                </div>
            </div>

            <div class="layui-inline" >
                <label class="layui-form-label">密&nbsp;&nbsp;码:</label>
                <div class="layui-input-inline">
                    <input type="text" name="dpassWord" lay-verify="required" placeholder="请输入密码" autocomplete="off"
                           class="layui-input">
                </div>
            </div>
        </form>
       </div>
</div>


</body>
<script>
    layui.use(['table', 'element', 'form'], function () {
        table = layui.table
            , $ = layui.jquery
            , form = layui.form
            , element = layui.element;
        $(document).ready(function () {
            $("#li2").addClass("layui-this");
            $("#d2").addClass("layui-this");
        });

        $('#selType').val('HIKVISION');
        layui.form.render('select');
        form.render('select', 'test1');

        var loginForm=document.forms['form'],
            dip=loginForm.elements['dip'];
        dip.onchange=function(){
            console.log(dip.value);
            if(dip!=""){
                console.log("卡号校验"+dip.value);
                $.ajax({
                    type: "POST",
                    url: 'selectDevIP',  //从数据库查询返回的是个list
                    dataType: "json",
                    data: {"dip":dip.value},
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
                url: 'selectDevIP',  //从数据库查询返回的是个list
                dataType: "json",
                data: {"dip":data.field.dip},
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
                    url: "/addDevice",
                    type: "POST",
                    async: false,//同步
                    contentType: 'application/json',
                    data: JSON.stringify(data.field),
                    success: function (res) {
                        layer.close(loading);
                        if(res == "succ"){
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
</body>
<script>
    var form ;
    layui.use('form', function(){
        form = layui.form;

        $(function () {
            //监听下拉框选中事件
            var school;
            var house;
            var floor;
            var room;

            form.on('select(selectSchool)', function (data) {
                var select = $(data.elem);
                var id =select.val();
                if(id==0){
                    $('[name="houseId"]').html('<option value="0">无</option>');
                    $('[name="floorId"]').html('<option value="0">无</option>');
                    $('[name="roomId"]').html('<option value="0">无</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="houseId"]').html('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="houseId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="floorId"]').html('<option value="0">无</option>');
                        $('[name="roomId"]').html('<option value="0">无</option>');
                        form.render('select');
                    })
                }
                school = data.elem[data.elem.selectedIndex].text
                console.log("school : " + school)

            });
            form.on('select(selectHouse)', function (data) {

                var select = $(data.elem);
                var id =select.val();
                if(id==0){
                    $('[name="floorId"]').html('<option value="0">无</option>');
                    $('[name="roomId"]').html('<option value="0">无</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="floorId"]').html('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="floorId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="roomId"]').html('<option value="0">无</option>');
                        form.render('select');
                    })
                }
                house = data.elem[data.elem.selectedIndex].text
                console.log("house : " + house)
            });
            form.on('select(selectFloor)', function (data) {

                var select = $(data.elem);
                var id =select.val();
                if(id==0){
                    $('[name="roomId"]').html('<option value="0">无</option>');
                    form.render('select');
                }
                if(id!=0) {
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="roomId"]').html('<option value="0">无</option>');
                        res.forEach(function (value,index) {
                            $('[name="roomId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        form.render('select');
                    })
                }
                floor = data.elem[data.elem.selectedIndex].text

                console.log("floor : " + floor)
            });
            form.on('select(selectRoom)', function (data) {

                room = data.elem[data.elem.selectedIndex].text
                console.log("room : " + room)
            });
        });
    });

</script>
</html>