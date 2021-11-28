<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="utf-8">
    <title>404</title>

    <!-- layui -->
    <link rel="stylesheet" type="text/css" href="/res/layui/css/layui.css">
    <script type="text/javascript" src="/res/layui/layui.js"></script>

    <script src="/res/js/jquery.min.js"></script>
    <script src="/res/js/jquery.rotate.js"></script>

    <style>
        .css404{
            position: absolute;
            left:50%;
            top:50%;
            text-align: center;
            font-size: 100px;
            transform: translate(-50%,-50%);
        }
        #zero{
            display: inline-block;
            margin: 0 20px;
        }
    </style>
</head>

<body>
    <div class="css404">
        4<div id="zero">0</div>4<br>
        NOT FOUND
    </div>
</body>
<script>
    var rotation2 = function(){
        $('#zero').rotate({
            angle: 0,
            animateTo: 360,
            callback: rotation2,
            easing: function(x,t,b,c,d){
                return c*(t/d)+b;
            }
        });
    };

    $(function (){
        rotation2();
    });

</script>
</html>


