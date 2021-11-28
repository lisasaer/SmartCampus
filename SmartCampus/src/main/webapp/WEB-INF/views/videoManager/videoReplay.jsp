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
    <title>录像回放</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />

    <%--    wpp - 2020-3-10 websdk--%>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate" />
    <meta http-equiv="Expires" content="0" />
    <%--    <script>--%>
    <%--        document.write("<link type='text/css' href='../res/websdk/demo.css?version=" + new Date().getTime() + "' rel='stylesheet' />");--%>
    <%--    </script>--%>
    <%--    wpp--%>
   <style>
       .searchdiv {
           height:400px;
           overflow:hidden;
           overflow:auto;
           border:1px solid #7F9DB9;
           font-size:9pt;
       }

        .searchlist th, .searchlist td {
           padding:2px;
           border:1px solid #7F9DB9;
           border-collapse:collapse;
           white-space:nowrap;
            font-size:9pt;
       }
       .realtime_left {
           width: 75%;
           height: 75%;
           float: left;
       }
   </style>

    <jsp:include page="../header/res.jsp"></jsp:include>
</head>
<body class="layui-layout-body">
<div class="layui-layout layui-layout-admin">
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <jsp:include page="../header/topHead.jsp"></jsp:include>

    <div class="layui-body" style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;">

        <%-- 左侧视频页面 --%>
        <div class="realtime_left">
            <div style="float: left; width: 100%;height: 100%">
                <div id="divPlugin" name="divPlugin" style="width: 99%;height: 90%"></div>   <%-- 视频区域 --%>
                <div style="height: 10%; width: 99%; background:#EEEEEE; padding: 10px;">
                    <button style="width: 100px;height: 50px;" onclick="clickStartPlayback()"><img src="\res\layui\images\dev_icon\back_icon_check.png">开始回放</button>
                    <button style="width: 100px;height: 50px;" onclick="clickStopPlayback()">停止回放</button>
                    <button style="width: 100px;height: 50px;" onclick="clickReversePlayback()">倒放</button>
                    <button style="width: 100px;height: 50px;" onclick="clickPause()">暂停</button>
                    <button style="width: 100px;height: 50px;" onclick="clickResume()">恢复</button>
                    <button style="width: 100px;height: 50px;" onclick="clickPlayFast()">快放</button>
                    <button style="width: 100px;height: 50px;" onclick="clickPlaySlow()">慢放</button>
                    <button style="width: 100px;height: 50px;" onclick="clickCapturePic()">抓图</button>
                </div>
            </div>

            <%-- 表格 --%>
            <table class="layui-hide" id="test"></table>

        </div>

        <%-- 右侧控制界面 --%>
        <div class="my-tree-div" style="width: 260px; height:600px; float: left; border: 0px; padding: 1px">
<%--            <div style="height: 10%">--%>
<%--                <div style="height: 20px;background: #00438a"></div>--%>
<%--                <button style="width: 50px;" onclick="changeWndNum(1)">1*1</button>--%>
<%--                <button style="width: 50px;" onclick="changeWndNum(2)">2*2</button>--%>
<%--                <button style="width: 50px;" onclick="changeWndNum(3)">3*3</button>--%>
<%--                <button style="width: 50px;" onclick="changeWndNum(4)">4*4</button>--%>
<%--            </div>--%>

            <%-- 视图 --%>
            <div style="margin-bottom: 5px">
                <div style="height: 30px; background: #d5d9e2; margin-bottom: 5px">
                    <label class="layui-form-label" style="padding: 5px; width: 60px;"><img  src="/res/layui/images/dev_icon/view_icon.png">  视图</label>
                    <button style="float: right; background: #d5d9e2; border: 0px; margin-right: 20px; margin-top: 5px" onclick="showhide('video_img')">
                        <label id="video_img_arrows">∧</label>
                    </button>
                </div>
                <div id="video_img" style="padding: 5px; display: block">
                    <input  type=image   src= "/res/layui/images/dev_icon/1window_check.png" style="width: 50px;height: 50px;" onclick="changeWndNum(1)" title="一画面分割"/>
                    <input  type=image   src= "/res/layui/images/dev_icon/4window_check.png" style="width: 60px;height: 50px;padding-left: 10px" onclick="changeWndNum(2)" title="四画面分割"/>
                    <input  type=image   src= "/res/layui/images/dev_icon/9window_check.png" style="width: 60px;height: 50px;padding-left: 10px" onclick="changeWndNum(3)" title="九画面分割"/>
                    <input  type=image   src= "/res/layui/images/dev_icon/16window_check.png" style="width: 60px;height: 50px;padding-left: 10px" onclick="changeWndNum(4)" title="十六画面分割"/>
                </div>
            </div>

            <%-- 监控点 --%>
            <div style="height: 70%;">
                <div style="height: 30px; background: #d5d9e2">
                    <label class="layui-form-label" style="padding: 5px; width: 80px;"><img  src="/res/layui/images/dev_icon/videoPosition_icon.png">  监控点</label>
                    <button style="float: right; background: #d5d9e2; border: 0px; margin-right: 20px; margin-top: 5px" onclick="showhide('jiankong')">
                        <label id="jiankong_arrows">∧</label>
                    </button>
                </div>
                <div id="jiankong" style="height: 90%; overflow-y: auto; display:block">
                    <ul id="tt"> </ul>
                </div>
            </div>

            <%-- 时间选择 --%>
            <div>
                <div style="height: 30px; background: #d5d9e2;">
                    <label class="layui-form-label" style="padding: 5px; width: 100px;"><img  src="/res/layui/images/dev_icon/timeicon.png">   时间选择</label>
                    <button style="float: right; background: #d5d9e2; border: 0px; margin-right: 20px; margin-top: 5px" onclick="showhide('timeChoose')">
                        <label id="timeChoose_arrows">∧</label>
                    </button>
                </div>

                <div id="timeChoose" style="border: 0px solid #00438a; width:100%; height: auto; display: block">
                    <div style="margin-left: -15px">
                        <label class="layui-form-label" style="width: 100px">开始时间</label>
                        <input type="text" id="starttime" class="layui-input" style="height: 35px; width: 80%;margin-left: 30px">
                        <span ><img  src="/res/layui/images/dev_icon/time_icon_check.png"></span>
                    </div>
                    <div style="margin-left: -15px">
                        <label class="layui-form-label" style="width: 100px">结束时间</label>
                        <input type="text" id="endtime" class="layui-input" style="height: 34px; width: 80%; margin-left: 30px">
                        <span <%--style=" position: absolute; top: 8%; right: 6%; display: table-cell;white-space: nowrap; padding: 7px 10px;"--%>><img  src="/res/layui/images/dev_icon/time_icon_check.png"></span>
                    </div>
                    <div  style="text-align: center;padding: 10px">
                        <button style="width: 100%" class="layui-btn layui-btn-radius layui-btn-normal"  onclick="searchVideo()">搜索</button>
                    </div>
                </div>
            </div>

        </div>


            <%--   查看效果   --%>
            <div style="margin-left: 100px; margin-top: 1000px">
                <div style="">
                    <div style="height: 30px; width: auto; background: #d5d9e2;margin-bottom: 5px">
                        <label class="layui-form-label" style="padding: 5px; width: 100px;">当前设备信息</label>
                        <button style="float: right; background: #d5d9e2; border: 0px; margin-right: 20px; margin-top: 5px" onclick="showhide('devInfo')">
                            <label id="devInfo_arrows">∧</label>
                        </button>
                    </div>
                    <ul id="tt1"></ul>
                    <div>

                        <table width="280" cellspacing="0">
                            <tr>
                                <td>设备端口</td>
                                <td><input id="deviceport" type="text" style="width:100px;" disabled/>（可选参数）</td>
                            </tr>
                            <tr>
                                <td>RTSP端口</td>
                                <td><input id="rtspport" type="text" style="width:100px;"  disabled/>（可选参数）</td>
                            </tr>
                            <tr>
                                <td>通道列表</td>
                                <td><select id="channels" style="width: 100px;" disabled></select></td>
                            </tr>
                            <tr>
                                <td>码流类型</td>
                                <td><select id="record_streamtype" style="width: 90px;">
                                    <option value="1">主码流</option>
                                    <option value="2">子码流</option>
                                    <option value="3">第三码流</option>
                                    <option value="4">转码码流</option>
                                </select>
                                </td>
                            </tr>
                            <tr>
                                <td>当前设备ip</td>
                                <td><input id="ip" type="text" style="width:140px;" disabled/></td>
                            </tr>
                            <tr><input id="transstream" type="checkbox" class="vtop" />&nbsp;启用转码码流</tr>
                        </table>
                    </div>
                </div>


                <%--      <div class="my-tree-body-div" >--%>


                <%--<div style="float: left;width: 80%;height: 100%">
                    <div id="divPlugin" name="divPlugin" style="width: 99%;height: 90%"></div>   &lt;%&ndash; 视频区域 &ndash;%&gt;
                    <div style="height: 10%;background:#EEEEEE;padding: 10px;">
                        <button style="width: 100px;height: 50px;" onclick="clickStartPlayback()">开始回放</button>
                        <button style="width: 100px;height: 50px;" onclick="clickStopPlayback()">停止回放</button>
                        <button style="width: 100px;height: 50px;" onclick="clickReversePlayback()">倒放</button>
                        <button style="width: 100px;height: 50px;" onclick="clickPause()">暂停</button>
                        <button style="width: 100px;height: 50px;" onclick="clickResume()">恢复</button>
                        <button style="width: 100px;height: 50px;" onclick="clickPlayFast()">快放</button>
                        <button style="width: 100px;height: 50px;" onclick="clickPlaySlow()">慢放</button>
                        <button style="width: 100px;height: 50px;" onclick="clickCapturePic()">抓图</button>
                    </div>
                </div>--%>
                <div style="width: 20%;height: 100%; border: 1px solid #0E2D5F; float: left">
                    <div style="border: 1px solid #00438a; width:100%; height: 140px; padding: 5px">
                        <div>
                            <label>回放图片保存路径</label>
                            <input id="playbackPicPath" type="text" class="txt" />&nbsp;<input type="button" class="btn" value="浏览" onclick="clickOpenFileDlg('playbackPicPath', 0);" />
                        </div>
                        <div>
                            <label>回放下载保存路径</label>
                            <input id="downloadPath" type="text" class="txt" />&nbsp;<input type="button" class="btn" value="浏览" onclick="clickOpenFileDlg('downloadPath', 0);" />
                        </div>
                        <div style="text-align: center;padding: 5px">
                            <button onclick="ZyclickGetLocalCfgReplay()">获取</button>
                            <button onclick="ZyclickSetLocalCfgReplay()">设置</button>
                        </div>

                    </div>

                </div>
                <%--            </div>--%>

            </div>


            <div style="border: 1px solid #00438a;width:100%;padding: 10px;">
                <div id="searchdiv" class="searchdiv">
                    <table id="searchlist" class="searchlist" cellpadding="0" cellspacing="0" border="0"></table>
                </div>
            </div>
    </div>

<%--    <jsp:include page="../header/footer.jsp"></jsp:include>--%>
</div>
</body>
<script type="text/html" id="barDemo">
<%--    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>--%>
<%--    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>--%>
        <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">下载</a>
</script>

<script>
    layui.use('table',function () {
        var table = layui.table;

        table.render({
            elem:'#test'
            ,url:'getVideoReplayInfo'
            ,title:'录像回放视频'
            ,cols:[[
                 {fixed: 'left', type:'numbers', title:'序号', width:80}
                ,{field:'id', width:80, title: 'ID',hide:true}
                ,{field:'szDeviceIdentify', title: '设备名称'}
                ,{field:'szStartTime',title:'开始时间'}
                ,{field:'szEndTime',title:'结束时间'}
                ,{field:'fileSize',title:'文件大小'}
                // ,{fixed:'right', title:'操作', toolbar: '#barDemo', width:150}
            ]]
            ,page:true
            , limits: [10, 20, 30, 50]
            , limit: 20
        });
    });
</script>


<script>
    leftThis('录像回放');

    layui.use('laydate', function(){
        var laydate = layui.laydate;
        var laydateEnd = layui.laydate;

        //执行一个laydate实例
        laydate.render({
            elem: '#starttime' //指定元素
            ,type: 'datetime'
        });

        //执行一个laydate实例
        laydateEnd.render({
            elem: '#endtime' //指定元素
            ,type: 'datetime'
        });
    });

    //注意：导航 依赖 element 模块，否则无法进行功能性操作
    layui.use('element','layer', function() {
        var element = layui.element;
    });

    $('#tt').tree({
        url:'getTreeVideoData'
    });

    $('#tt').tree({
        onClick: function(node) {
            //console.log(node);
            var id = node.id;
            $.post('getVideoInfo',{id:id},function (res) {
                // alert(res.ip);
                var szIP = res.ip,
                    szPort = res.port,
                    szUsername = res.username,
                    szPassword = res.password;
                $('#ip').val(szIP);
                ZyclickLogin(szIP,szPort,szUsername,szPassword);//1.登录摄像机
                setTimeout(function () {
                    ZyclickStartRealPlay(szIP,szPort,0,true,1);//2.预览
                }, 20);
            })
        },
        onContextMenu: function (e, title) {
            e.preventDefault();
            $(".contextmenu").css({
                "left":  e.pageX-200,
                "top": e.pageY-50
            }).show();
        }
    });

    $(document).click(function(){
        $(".contextmenu").hide();
    });

    // $(document).mousedown(function(e){
    //     if(1 == e.which){
    //         $(".contextmenu").hide();
    //     }
    // });

    //停止播放
    function stopVideo() {
        clickStopRealPlay();
        ZyclickLogout();
    }

    //抓图
    function catchVideo() {
        clickCapturePic(1);
    }

    //搜索录像
    function searchVideo(){
        var ip = $('#ip').val();
        // console.log("searchIp=" + ip);
        if(ip==''){
            onTips("请选择监控设备",2);
            return;
        }
        clickRecordSearch(0);
    }

    //div显示与隐藏
    function showhide(divid) {
        // console.log("aaaaaaaaaaaaaa")
        var dis = document.getElementById(divid).style.display;
        var id = divid +'_arrows';

        if(dis == "none" || dis==""){
            // $(did).attr("style","display:block");
            document.getElementById(divid).style.display="block";
            document.getElementById(id).innerText='∧';
        }else{
            // $(did).attr("style","display:none");
            document.getElementById(divid).style.display="none";
            document.getElementById(id).innerText='∨';
        }
        var dd = '#'+divid+'div';
        $(dd).attr("height","0");
        // console.log(dd);
    }


</script>
<script src="../res/hkwebsdk/websdk/jquery-1.7.1.min.js"></script>
<script id="videonode" src="../res/hkwebsdk/websdk/codebase/webVideoCtrl.js"></script>
<script src="../res/hkwebsdk/websdk/cn/demo.js"></script>
<script type="text/javascript" src='../res/js/jquery.min.js'></script>
</html>
