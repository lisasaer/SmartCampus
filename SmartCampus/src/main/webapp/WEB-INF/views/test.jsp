<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>test</title>
    <!-- layui -->
    <link rel="stylesheet" type="text/css" href="/res/layui/css/layui.css">
    <script type="text/javascript" src="/res/layui/layui.js"></script>

    <script src="res/js/jquery.min.js"></script>
    <script src="res/js/myjs.js" ></script>

    <style>
        .div_center{
            padding-top: 20px;
            margin: 0 auto;
        }
        .div_setting{
            text-align: center;
        }
        #divVideo{
            margin: 20px 0;
        }
        .test-icon{
            background: url("../res/image/icon_base.png") no-repeat  center center;
            width: 16px;
            line-height: 17px;
            display: inline-block;
        }
        .icon-ydy2{
            background-position: -30px -50px;
        }
        .ttt{
            margin-left: 120px;
            margin-top: 120px;
            width: 300px;
            height: 300px;
            border: green 1px solid ;
            border-right-style: none;
        }
    /*
         border-style: solid none solid solid ;
            border-color: red;
            border-width: 1px;
    */
    </style>

</head>
<body>


    <div style="margin: 50px;">

        <label>从机:</label>
        <select>
            <%
                for(int i= 0 ;i<9 ;i++){
            %>
                <option value="<%= "0"+(1+i) %>">从机<%= i+1 %></option>
            <%
                }
            %>
        </select>
        <label>CMD指令:</label>
        <select id="cmd">
            <option value="01">读取开关合/分闸状态</option>
            <option value="05">开关闸</option>
        </select>
        <label>开关地址:</label>
        <input id="address">


        <select id="select">
            <option value="010500FFFF00">全部合闸</option>
            <option value="010500FF0000">全部开闸</option>
            <option value="01050001FF00">2合闸</option>
            <option value="010500010000">2开闸</option>
            <option value="01050004FF00">5合闸</option>
            <option value="010500040000">5开闸</option>
            <option value="01050006FF00">7合闸</option>
            <option value="010500060000">7开闸</option>
            <option value="010100000009">读取开关合/分闸状态</option>
            <option value="0101000000FF">读取开关是否存在，读取全部可能存在的位</option>
            <option value="010300000008">读从机实时数据</option>
            <option value="010300000008">读从机参数</option>
        </select>

        <button onclick="sendSP()">发送串口指令</button>
        <script>
            function sendSP() {
                console.log('sendSP');
                $.post('testduankou',{data:$('#select').val()},function (res) {
                    console.log(res);
                })
            }
        </script>
    </div>
    <div id="div-tts">
        <input type="text" id="ttsText"><button id="btnSetTTS">设置TTS</button>
        <script>
            $('#btnSetTTS').click(function () {
                console.log('setTTS');
                $.post('setTTS',{tts:$('#ttsText').val()},function (res) {
                    $('#div-tts').prepend(res);
                })
            })
        </script>
    </div>

    <div class="ttt">

    </div>
    <div class="test-icon icon-ydy2" style="background-color: red;height: 17px;width: 16px">

    </div>

    <div class="div_center">
        <div class="div_setting">
            <button onclick="initVideo()">加载视频</button>
            <input id="inputMysqlVersion"><button onclick="queryMysqlVersion()">查询Mysql数据库版本</button>
        </div>

        <div id="divVideo"></div>

        <div class="sddd" style="width: 900px"></div>
    </div>

</body>

<script>
    function queryMysqlVersion() {
        $.post('testGetMysqlVersion',function (res) {
            $('#inputMysqlVersion').val(res);
        })
    }
</script>

<script>

    window.onload = function (ev) {
        //alert(2);
        console.log(window.screen.availWidth,window.screen.availHeight);

        console.log(MyUtil.repairZero('2'));
    };


    function initVideo() {
        var elem = $('#divVideo');

        //获取divVideo的长宽
        var width = elem.width();
        var colum = 2;

        var itemWidth = (width - 40) / colum;
        var itemHeight = itemWidth * 2/3;

        var data = {};
        data.elem = elem;
        data.accessToken = '${accessToken}';
        data.width = itemWidth;
        data.height = itemHeight;

        //ZY萤石设备
        // data.id = 'ys1';
        // data.url = 'ezopen://open.ys7.com/547287482/1.live';
        // addVideoFrame(data);

        //客户设备
        data.id = 'ys2';
        data.url = 'ezopen://JUSMPR@open.ys7.com/D95435428/1.live';
        addVideoFrame(data);

        // //官方提供的测试设备
        // data.id = 'ys3';
        // data.url = 'ezopen://open.ys7.com/203751922/1.live';
        // data.accessToken = 'ra.6tlybprnawi5o05i5gqjky9h37sjh2zk-6plkb98aog-1v7pkiv-tkductnor';
        // addVideoFrame(data);

    }

    //elem , id , url , accessToken ,width , height
    function addVideoFrame(data) {
        var src = '';
        src += 'https://open.ys7.com/ezopen/h5/iframe';
        src += '?url='+data.url;
        src += '&autoplay=1&';
        src += 'accessToken='+data.accessToken;
        var html = '<iframe class="zyFrame" src='+src+' id='+data.id+' width='+data.width+' height='+data.height+' allowfullscreen></iframe>';
        data.elem.append(html);

        /* 获取播放器元素 */
        var player = document.getElementById(data.id).contentWindow;
        /* iframe 支持方法 */
        player.postMessage("play", "https://open.ys7.com/ezopen/h5/iframe"); /* 播放 */
        player.postMessage("stop", "https://open.ys7.com/ezopen/h5/iframe"); /* 结束 */
        player.postMessage("capturePicture", "https://open.ys7.com/ezopen/h5/iframe"); /* 截图 */
        player.postMessage("openSound", "https://open.ys7.com/ezopen/h5/iframe"); /* 开启声音 */
        player.postMessage("closeSound", "https://open.ys7.com/ezopen/h5/iframe") ;/* 关闭声音 */
        player.postMessage("startSave", "https://open.ys7.com/ezopen/h5/iframe") ;/* 开始录制 */
        player.postMessage("stopSave", "https://open.ys7.com/ezopen/h5/iframe") ;/* 结束录制 */
    }


</script>
</html>



