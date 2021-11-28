<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2019/12/19
  Time: 19:02
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>萤石测试</title>

    <script src="res/js/jquery.min.js"></script>
    <script src="res/ys/ezuikit.js"></script>
    <style>
        .div-video{
            width:800px;
            margin:0 auto;
            /*margin-top: 20px;*/
            /*margin-bottom: 20px;*/
        }
    </style>
</head>
<body>
<div>
    <div class="div-video">
        <div >
            <button onclick="caputerPicture()">截图</button>
            <button onclick="play()">播放</button>
            <button onclick="stop()">停止</button>
            <button onclick="big()">大大大</button>
            <button onclick="small()">小小小</button>
        </div>

        <%--页面创建div标签--%>
        <div  id="myPlayer"></div>
    </div>

</div>
</body>
<script>

    //开始初始化监控地址
    var player ;
    var url = 'ezopen://JUSMPR@open.ys7.com/D95435428/1.live';

    //刷新
    window.onbeforeunload = function (ev) {
        if(player != null){
            stop();
        }
    };

    //播放
    function play() {
        player = new EZUIKit.EZUIPlayer({   //new EZUIPlayer  EZUIKit.EZUIPlayer
            id: 'myPlayer',
            url: url,
            autoplay: true,
            accessToken: '${accessToken}',
            decoderPath: 'res/ys',
            width: 600,
            height: 400
        });

        //player.play();

        // 这里是打印日志，本例抛出到播放页面
        player.on('log', log);
        function log(str) {
            var div = document.createElement('DIV');
            div.innerHTML = (new Date()).Format('yyyy-MM-dd hh:mm:ss.S') + JSON.stringify(str);
            document.body.appendChild(div);
        }
    }
    //停止
    function stop() {
        count = url.split(',').length;
        player.stop();
    }
    //截图
    function caputerPicture() {
        player.capturePicture(1,'defult');
    }
</script>
</html>
