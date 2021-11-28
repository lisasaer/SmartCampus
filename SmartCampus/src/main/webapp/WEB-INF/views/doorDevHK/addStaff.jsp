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
    <title>添加人员</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        /*.layui-form-label.layui-required:after{*/
        /*    content:"*";*/
        /*    color:red;*/
        /*    position: absolute;*/
        /*    top:5px;*/
        /*    left:15px;*/
        /*}*/
        .layui-form-item{
            margin-bottom:5px;
            height: 38px;
        }
        /* 下拉框最大高度*/
        .layui-form-select dl{
            max-height: 150px;
        }
        /*修改label内边距*/
        .layui-form-pane .layui-form-label {
            padding: 8px 10px;
            text-align: left;
        }
        /* 时间选择框大小*/
        .layui-laydate{margin: 2px 0!important;}
        .layui-laydate-main{width: 182px!important;}
        .layui-laydate-header{line-height: 20px!important;padding: 5px 30px 5px!important;}
        .layui-laydate-header i.laydate-prev-y{left:3px!important;}
        .layui-laydate-header i.laydate-prev-m{left:25px!important;}
        .layui-laydate-header i.laydate-next-y{right:3px!important;}
        .layui-laydate-header i.laydate-next-m{right:25px!important;}
        .layui-laydate-header i{top:5px!important;}
        .layui-laydate-content{padding:2px!important;}
        .layui-laydate-content td, .layui-laydate-content th{padding:2px!important;width:26px!important;height: 20px!important;}
        .layui-laydate-footer{padding:3px 5px!important;height: 30px!important;line-height:30px!important;}
        .layui-laydate-footer span{line-height: 24px!important;}
        .laydate-footer-btns{right:5px!important;top: 3px!important;}
        .laydate-footer-btns span{height:22px!important;line-height:22px!important;padding: 0 5px!important;}
        .layui-laydate-list{padding:3px!important;text-align: center;}
        .layui-laydate-list>li{height:22px!important;line-height:22px!important;}
        .laydate-theme-grid .laydate-month-list>li{height:50px!important;line-height:50px!important;}
        .laydate-theme-grid .laydate-year-list>li{height:30px!important;line-height:30px!important;}
        .laydate-month-list>li{margin: 12px 0!important;}
        .laydate-theme-grid .laydate-month-list>li{margin: 0 -1px -1px 0!important;}
        .laydate-time-list p{line-height:22px!important;top: -2px!important;}
        .laydate-time-list ol{height: 121px!important;}
        .laydate-time-list ol li{padding-left: 20px!important;}
        .laydate-theme-grid .laydate-month-list, .laydate-theme-grid .laydate-year-list{margin: 0!important;}
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
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 160px center transparent;
        }
        /*点击后的下拉框箭头图片*/
        .layui-form-selected  .layui-select-title input{
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 160px center transparent;
        }
        /*按钮样式*/
        .layui-btn {
            font-family: "Microsoft Ya Hei";
            font-size: 14px;
            color: #feffff;
            width: 90px;
            line-height: 32px;
            background-color: #1666f9;
            height: 32px;
            border-radius: 5px;
            border: none;
        }
        .layui-form-radio>i:hover, .layui-form-radioed>i {
            color: #1666f9;
        }
    </style>
</head>
<body>
<div class="bodyDiv" style="margin-left: 15px;margin-top: 15px;">
    <!-- 内容主体区域 -->
    <form class="layui-form layui-form-pane" name="form" action="">


        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">校 区:</label>
            <div class="layui-input-inline">
                <select id="school" name="schoolId" lay-filter="selectSchool" title="校区选择" >
<%--                    <option value="0">无</option>--%>
                    <option value="">请选择</option>
                    <c:forEach items="${schoolList}" var="item">
                        <option value="${item.id}">${item.text}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label" style=" ">联系方式:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="telphone" id="telphone" placeholder="请输入联系方式" autocomplete="off"
                       class="layui-input">
            </div>
        </div>


        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">楼 栋:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <select id="house" name="houseId" lay-filter="selectHouse" title="楼栋选择">
                    <option value="">请选择</option>
                </select>
            </div>
        </div>


        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label" style=" ">Q Q:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="qq" placeholder="请输入QQ" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">楼 层:</label>
            <div class="layui-input-inline">
                <select id="floor" name="floorId" lay-filter="selectFloor" title="楼层选择">
                    <option value="">请选择</option>
                </select>
            </div>
        </div>
        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label" style=" ">邮 箱:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="email" id="email" placeholder="请输入邮箱" autocomplete="off"
                       class="layui-input">
            </div>
        </div>
        <div class="layui-form-item"style="float: left;">
            <label class="layui-form-label">房 号:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <select id="room" name="roomId" lay-filter="selectRoom" title="房号选择">
                    <option value="">请选择</option>
                </select>
            </div>
        </div>
        <div class=""style="padding-right: 20px;float: right">
            <label class="layui-form-label" style=" ">备 注:</label>
            <div class="layui-input-inline" style="width: 190px;">
                <input type="text" name="remark" placeholder="" autocomplete="off"
                       class="layui-input">
            </div>
        </div>


        <div  class="layui-form-item" style="float: left;">
            <div class="layui-form-item"style="float: left;">
                <label class="layui-form-label">人员类型:</label>
                <div class="layui-input-inline" style="width: 190px;">
                    <select id="personType" name="personType" lay-filter="selectRoom" title="人员类型">
                        <option value="student">学生</option>
                        <option value="teacher">教师</option>
                        <option value="other">其他</option>
                    </select>
                </div>
            </div>

            <div class="layui-form-item" style="float: left;">
                <label class="layui-form-label" style=" ">编 号:</label>
                <div class="layui-input-inline" style="width: 190px;">
                    <input type="text" name="staffId" id="staffId" lay-verify="required" placeholder="请输入编号" autocomplete="off"
                           class="layui-input" oninput="value=value.replace(/[^\d]/g,'')">
                </div>
            </div>

            <div class="layui-form-item" style="float: left;">
                <label class="layui-form-label" style=" ">姓 名:</label>
                <div class="layui-input-inline" style="width: 190px;">
                    <input type="text" name="name" lay-verify="required" placeholder="请输入姓名" autocomplete="off"
                           class="layui-input">
                </div>
            </div>


            <div class="layui-form-item" style="float: left;">
                <label class="layui-form-label" style=" ">性 别:</label>
                <div class="layui-input-inline" style="width: 190px;">
                    <input type="radio" name="sex" value="男" title="男" checked="">
                    <input type="radio" name="sex" value="女" title="女">
                </div>
            </div>

            <div class="layui-form-item" style="float: left;">
                <label class="layui-form-label" style=" ">出生日期:</label>
                <div class="layui-input-inline" style="width: 190px;">
                    <input type="text" name="birth" id="date1" autocomplete="off" class="layui-input" lay-verify="required"
                           placeholder="请选择生日">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label" style=" ">卡 号:</label>
                <div class="layui-input-inline" style="width: 190px;">
                    <input type="text" name="cardNo" id="cardNo" lay-verify="required" placeholder="请输入卡号" autocomplete="off"
                           class="layui-input" oninput="value=value.replace(/[^\d]/g,'')">
                </div>
            </div>
        </div>
        <div style="float:left;width: 200px;    margin-left: 60px;">
            <div style="float:left;    margin-top: 60px;">
                <button type="button" class="layui-btn" id="test1">上传照片</button>
            </div>
            <div style="float:right;/*margin-right: 5%;margin-top: 15px ;width: 19.3%;*/">

                <input type="text" id="photo" name="photo" style="display:none">
                <div class="layui-upload-list" style="width: 2.5cm;height: 3.5cm;border: 1px solid #f0f0f0;overflow: hidden;position: relative;">
                    <p id="demoText"></p>
                    <img class="layui-upload-img" id="imageId" style="width: 2.5cm;height: 3.5cm;">
                </div>
            </div>
        </div>

        <div class="layui-form-item" hidden="hidden">
            <button id="submitBtn" class="layui-btn" lay-submit="" lay-filter="demo2">保存</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
        </div>

    </form>

</div>


<script>

    layui.use(['form', 'element', 'laydate', 'upload'], function () {
        var positionId ;
        var form = layui.form
            , laydate = layui.laydate
            , $ = layui.jquery
            , upload = layui.upload
            , element = layui.element;

        $(document).ready(function () {
            $("#li5").addClass("layui-this");
            $("#d2").addClass("layui-this");
        });

        $(this).removeAttr("lay-key");
        laydate.render({
            elem: '#date1'
            ,trigger : 'click'
            ,value: '2000-01-01'
            ,isInitValue: true
        });

        //普通图片上传
        var uploadInst = upload.render({
            elem: '#test1'
            , url: '/upload'
            , accept: 'images' //允许上传的文件类型
            , before: function (obj) {
                //预读本地文件示例，不支持ie8
                obj.preview(function (index, file, result) {
                    $('#imageId').attr('src', result); //图片链接（base64）
                    $('#imageId').css({'width':'2.5cm','height':'3.5cm'});
                });
            }
            , done: function (res) {
                //如果上传失败
                if (res.code > 0) {
                    return layer.msg('上传失败');
                }
                console.log(res);
                //上传成功
                $('#photo').val(res.data.src);

                //layer.alert(res.data.src);
            }
            , error: function () {
                //演示失败状态，并实现重传
                var demoText = $('#demoText');
                demoText.html('<span style="color: #FF5722;">上传失败</span> <a class="layui-btn layui-btn-xs demo-reload">重试</a>');
                demoText.find('.demo-reload').on('click', function () {
                    uploadInst.upload();
                });
            }
        });

        //监听卡号唯一性校验
        var loginForm=document.forms['form'],
            cardNo=loginForm.elements['cardNo'];
        cardNo.onchange=function(){
            console.log(cardNo.value);
            if(cardNo!=""){
                console.log("卡号校验"+cardNo.value);
                $.ajax({
                    type: "POST",
                    url: 'selectCardNo',  //从数据库查询返回的是个list
                    dataType: "json",
                    data: {"cardNo":cardNo.value},
                    success: function (data) {
                        if(data.code==1){
                            layer.msg("卡号已存在！");
                            return false;
                        }
                    }, error: function () {
                        layer.msg("校验失败！");
                        return false;
                    }
                })
            }
        }
        var loginForm=document.forms['form'],
            staffId=loginForm.elements['staffId'];
        staffId.onchange=function(){
            console.log(staffId.value);
            if(staffId!=""){
                console.log("人员编号校验"+staffId.value);
                $.ajax({
                    type: "POST",
                    url: 'queryByStaffId',  //从数据库查询返回的是个list
                    dataType: "json",
                    data: {"staffId":staffId.value},
                    success: function (data) {
                        if(data.code==1){
                            layer.msg("人员编号已存在！");
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
            //手机号码验证
            var checkPhone=/^1\d{10}$/;
            var telphone = $("#telphone").val();
            if(telphone!=""){
                if(!checkPhone.test(data.field.telphone)){
                    layer.msg('请输入正确的手机号',{icon: 5});
                    return false;
                }
            }
            //邮箱验证
            var checkEmail=/^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
            var email = $("#email").val();
            if(email!=""){
                if(!checkEmail.test(data.field.email)){
                    layer.msg('请输入正确的邮箱',{icon: 5});
                    return false;
                }
            }
            //卡号验证
            var cardNo = $("#cardNo").val();
            if(cardNo!=""){
                $.ajax({
                    type: "POST",
                    url: 'selectCardNo',  //从数据库查询返回的是个list
                    dataType: "json",
                    data: {"cardNo":cardNo},
                    async:false,
                    success: function (data) {
                        if(data.code==1){
                            layer.msg("卡号已存在！");
                            status=true;
                            return false;
                        }
                    }, error: function () {
                        layer.msg("校验失败！");
                        return false;
                    }
                })
            }
            //人员编号验证
            var staffId = $("#staffId").val();
            console.log(staffId.value);
            if(staffId!=""){
                $.ajax({
                    type: "POST",
                    url: 'queryByStaffId',  //从数据库查询返回的是个list
                    dataType: "json",
                    data: {"staffId":staffId},
                    success: function (data) {
                        if(data.code==1){
                            layer.msg("人员编号已存在！");
                            return false;
                        }
                        // layui.form.render("select");
                    }, error: function () {
                        layer.msg("校验失败！");
                        return false;
                    }
                })
            }

            var status = false;
            console.log(data)
            $.each(data.field, function (index, item) {
                if(!status){
                    if (index == "photo") {
                        console.log("照片");
                        if (item == "") {
                            layer.msg('请先添加本人照片');
                        } else {
                            $.ajax({
                                url: "/addStaff",
                                type: "POST",
                                async: false,//同步
                                contentType: 'application/json',
                                data: JSON.stringify(data.field),
                                dataType: "text",
                                success: function (res) {
                                    //window.parent.location.reload();//刷新父页面
                                    var index = parent.layer.getFrameIndex(window.name); //获取当前窗口的name
                                    parent.layer.close(index);//关闭当前页
                                }
                            });
                        }
                    }
                }
            });
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
                        $('[name="houseId"]').html('<option value="">请选择</option>');
                        res.forEach(function (value,index) {
                            $('[name="houseId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="floorId"]').html('<option value="">请选择</option>');
                        $('[name="roomId"]').html('<option value="">请选择</option>');
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
                if(id==""){
                    $('[name="floorId"]').html('<option  value="">请选择</option>');
                    $('[name="roomId"]').html('<option  value="">请选择</option>');
                    form.render('select');
                }
                if(id!=0){
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="floorId"]').html('<option value="">请选择</option>');
                        res.forEach(function (value,index) {
                            $('[name="floorId"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                        });
                        $('[name="roomId"]').html('<option value="">请选择</option>');
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
                if(id==""){
                    $('[name="roomId"]').html('<option  value="">请选择</option>');
                    form.render('select');
                }
                if(id!=0) {
                    $.post('getChildrenOrganize',{id:select.val()},function (res) {
                        console.log(res);
                        $('[name="roomId"]').html('<option value="">请选择</option>');
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
