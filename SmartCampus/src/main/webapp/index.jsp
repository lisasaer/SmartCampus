<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="utf-8">
    <title>登录</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <link rel="stylesheet" href="res/loginRes/css/style.css">

    <!-- layui -->
    <link rel="stylesheet" type="text/css" href="/res/layui/css/layui.css">
    <script type="text/javascript" src="/res/layui/layui.js"></script>
    <style>
        .container{
            margin: auto auto;
        }
    </style>
</head>

<body>
<div class="dowebok">
    <div class="container">
        <div class="left" >
            <div class="login" style="font-size: 25px;text-align: center;">智慧校园<br>信息管理系统</div>
            <div class="eula">欢迎登录！</div>
        </div>
        <div class="right">
            <svg viewBox="0 0 320 300">
                <defs>
                    <linearGradient inkscape:collect="always" id="linearGradient" x1="13" y1="193.49992" x2="307"
                                    y2="193.49992" gradientUnits="userSpaceOnUse">
                        <stop style="stop-color:#ff00ff;" offset="0" id="stop876" />
                        <stop style="stop-color:#ff0000;" offset="1" id="stop878" />
                    </linearGradient>
                </defs>
                <path d="m 40,120.00016 239.99984,-3.2e-4 c 0,0 24.99263,0.79932 25.00016,35.00016 0.008,34.20084 -25.00016,35 -25.00016,35 h -239.99984 c 0,-0.0205 -25,4.01348 -25,38.5 0,34.48652 25,38.5 25,38.5 h 215 c 0,0 20,-0.99604 20,-25 0,-24.00396 -20,-25 -20,-25 h -190 c 0,0 -20,1.71033 -20,25 0,24.00396 20,25 20,25 h 168.57143" />
            </svg>
            <div class="form">
                <label >用户名</label>
                <input type="text" id="username" value="admin" style="height: 30px;background:transparent">
                <label for="password">密码</label>
                <input type="password" id="password" value="123456">
                <input type="submit" id="submit" value="登录" style="padding-top: 5px;padding-left: 18px">
            </div>
        </div>
    </div>
</div>
<script src="res/loginRes/js/anime.min.js"></script>
<script src="res/loginRes/js/index.js"></script>
</body>
<script>
    layui.use(['element','jquery','table','laydate','form','transfer'], function() {
        var element = layui.element,
            $ = layui.jquery,
            laydate = layui.laydate,
            table = layui.table,
            form = layui.form,
            transfer = layui.transfer;

        $('#submit').click(function () {
            setTimeout(function () {
                var username = $('#username').val();
                var password = $('#password').val();
                if(username =='' || password ==''){
                    layer.msg('请输入用户名密码',{time:2000});
                    return;
                }
                var loading = layer.load(1, {shade: [0.1,'#fff']});
                $.post('checkLogin',{username:username,password:password},function (res) {
                    console.log(res.code);
                    if(res.code > 0){
                        layer.msg('登录成功',{time:500},function () {
                            window.location.href = res.msg;
                        });
                    }else {
                        layer.msg(res.msg,{time:1000});
                    }
                }).fail(function (xhr) {
                    layer.msg('登录失败 '+xhr.status);
                }).always(function () {
                    layer.close(loading);
                });
            },200);
        })
    })
</script>
</html>


