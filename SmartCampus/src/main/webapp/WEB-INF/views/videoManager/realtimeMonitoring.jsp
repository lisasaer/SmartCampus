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
    <title>实时预览</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />

    <%--    wpp - 2020-3-10 websdk--%>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate" />
    <meta http-equiv="Expires" content="0" />
    <script>
         document.write("<link type='text/css' href='../../res/hkwebsdk/websdk/demo.css?version=" + new Date().getTime() + "' rel='stylesheet' />");
    </script>
    <link type="text/css" rel="stylesheet" href="../../res/css/styleRight.css">

    <style>
        .realtime_left {float: left; width: 75%; }
        .realtime_left_bottom { background-color: #b9c0c8; margin-top: 10px; width: 100%; height: 50px}
    </style>

    <jsp:include page="../header/res.jsp"></jsp:include>
</head>

<body class="layui-layout-body" >
<div class="layui-layout layui-layout-admin">
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <jsp:include page="../header/topHead.jsp"></jsp:include> <!-- background-image:../res/image/SplitScreenOne.png-->

    <div class="layui-body"  style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;">

        <%-- 左边视频页面 --%>
        <div class="realtime_left" >
            <%--<div style="position:absolute; left: 0; top: 0; z-index: 1000"  >
                <iframe cals="newiframe" src="" style="position: absolute; left: 0; top: 0; z-index:-1; width: 100%; height: 100%; background-color: transparent; opacity:0; " frameborder="0"></iframe>

                <button style="width: auto; height: auto; " onclick="stopVideo()" onmouseover="changeImgMonA()" onmouseout="changeImgMonB()">
                    <img title="停止预览" id="imgMonitory" src="/res/image/video/stopPreviewOut.jpg" >
                </button>
                <button style="width: auto; height: auto;" onclick="catchVideo()">
                    <img title="开始抓图" id="imgZhua" src="/res/image/video/zhua.png" >
                </button>
                <button style="width: auto; height: auto;" onclick="clickStartRecord('realplay');" >
                    <img title="开始录像" id="imgVideoStart" src="/res/image/video/videoStart.jpg" >
                </button>
                <button style="width: auto; height: auto;" onclick="clickStopRecord('realplay');">
                    <img title="停止录像" id="imgVideoEnd" src="/res/image/video/videoEnd.png" >
                </button>
                <button style="width: auto; height: auto;" onclick="stopAllVideo()">
                    <img title="全部停止预览" id="imgMonitoryAll" src="/res/image/video/stopPreviewOut.jpg" >
                </button>
            </div>--%>
            <div id="divPlugin" name="divPlugin" style=" width: 99%; height: 80% "></div> <%--视频画面区域（插件类型为object，object标签层级无法覆盖）--%>
            <div class="realtime_left_bottom">
                <div style="padding: 7px">
                    <button style="width: auto; height: auto; " onclick="stopVideo()" onmouseover="changeImgMonA()" onmouseout="changeImgMonB()">
                        <img title="停止预览" id="" src="/res/layui/images/dev_icon/stop_icon_check.png" >
                    </button>
                    <button style="width: auto; height: auto;" onclick="catchVideo()">
                        <img title="开始抓图" id="imgZhua" src="/res/layui/images/dev_icon/photo_icon_check.png" >
                    </button>
                    <button style="width: auto; height: auto;" onclick="clickStartRecord('realplay');" >
                        <img title="开始录像" id="imgVideoStart" src="/res/layui/images/dev_icon/videoStart_icon_check.png" >
                    </button>
                    <button style="width: auto; height: auto;" onclick="clickStopRecord('realplay');">
                        <img title="停止录像" id="imgVideoEnd" src="/res/layui/images/dev_icon/videoStop_icon_checked.png" >
                    </button>
                    <button style="width: auto; height: auto;" onclick="stopAllVideo()">
                        <img title="全部停止预览" id="imgMonitoryAll" src="/res/image/video/stopPreviewOut.jpg" >
                    </button>
                </div>

            </div>
        </div>

        <%--右边控制界面 --%>
        <div class="my-tree-div" style="width: 260px; height:600px; float: left; border: 0px; padding: 1px" >
            <div>
                <div style="height: 30px; background: #d5d9e2">
                    <label class="layui-form-label" style="padding: 5px; width: 70px;"><img  src="/res/layui/images/dev_icon/view_icon.png"> 视图</label>
                    <button style="float: right; background: #d5d9e2; border: 0px; margin-right: 20px; margin-top: 5px" onclick="showhide('video_img')">
                        <label id="video_img_arrows">∧</label>
                    </button>
                </div>
                <%--<div id="video" style="display:block" class="demo-tree-more"></div>--%>

                <div id="video_img" style="padding: 5px; display: block">
                    <input  type=image   src= "/res/layui/images/dev_icon/1window_check.png" style="width: 50px;height: 50px;" onclick="changeWndNum(1)" title="一画面分割"/>
                    <input  type=image   src= "/res/layui/images/dev_icon/4window_check.png" style="width: 60px;height: 50px;padding-left: 10px" onclick="changeWndNum(2)" title="四画面分割"/>
                    <input  type=image   src= "/res/layui/images/dev_icon/9window_check.png" style="width: 60px;height: 50px;padding-left: 10px" onclick="changeWndNum(3)" title="九画面分割"/>
                    <input  type=image   src= "/res/layui/images/dev_icon/16window_check.png" style="width: 60px;height: 50px;padding-left: 10px" onclick="changeWndNum(4)" title="十六画面分割"/>
                </div>

                <div style="display:none;">
                    <tr>
                        <td class="tt">设备端口</td>
                        <td colspan="2"><input id="deviceport" type="text" class="txt" />（可选参数）</td>
                    </tr>
                    <tr>
                        <td class="tt">RTSP端口</td>
                        <td colspan="3"><input id="rtspport" type="text" class="txt" />（可选参数）</td>
                    </tr>
                    <td class="tt">通道列表</td>
                    <td>
                        <select id="channels" class="sel"></select>
                    </td>
                    <td style="display: none">
                        <select id="streamtype" class="sel">
                            <option value="1">主码流</option>
                            <option value="2">子码流</option>
                            <option value="3">第三码流</option>
                            <option value="4">转码码流</option>
                        </select>
                    </td>
                </div>
            </div>

            <div id="ttdiv" style="height: auto;  margin-top: 10px; ">
                <div style="height: 30px; background: #d5d9e2">
                    <label class="layui-form-label" style="padding: 5px; width: 80px ; background: url('../../res/layui/images/dev_icon/videoPosition_icon.png') no-repeat scroll 10px center transparent;">监控点</label>
                    <button style="float: right; background: #d5d9e2; border: 0px; margin-right: 20px; margin-top: 5px"; onclick="showhide('monitoring')">
                        <label id="monitoring_arrows">∧</label>
                    </button>
                </div>
                <div id="monitoring" style="height: 90%; overflow-y:auto; display: block">
                    <ul id="tt" > </ul>  <%-- 下拉列表监控区域 --%>
                </div>

                 <%--右键功能--%>
                <ul class="contextmenu">
                    <li><a onclick="rightVideo()">全部预览</a></li>
                </ul>
            </div>
            <div style="height: 20%;margin-top: 10px">
                <div style="height: 30px; background: #d5d9e2">
                    <label class="layui-form-label" style="padding: 5px; width: 90px;"><img  src="/res/layui/images/dev_icon/yuntai_icon.png">  云台控制</label>
                    <button style="float: right; background: #d5d9e2; border: 0px; margin-right: 20px; margin-top: 5px"; onclick="showhide('spead')">
                        <label id="spead_arrows">∧</label>
                    </button>
                </div>
                <div id="spead" style="display: block">
                    <div class="layui-col-md6" style="padding: 5px;">
                        <div class="layui-col-md3">

                            <%-- <button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(5);" onmouseup="mouseUpPTZControl();">左上</button>--%>
                            <%--<button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(1);" onmouseup="mouseUpPTZControl();">上</button>--%>
                                <%--<button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(7);" onmouseup="mouseUpPTZControl();">右上</button>--%>

                                <%--<input  id="leftUp" type=image src= "../res/image/video/左上.png" style="width: 37px;height: 30px;" onmouseover="changeHolder('leftUp')"
                                onmouseout="changeHolderOut('leftUp')" onmousedown="mouseDownPTZControl(5);" onmouseup="mouseUpPTZControl()" title="左上"/>--%>
                                <%--<input  id="left" type=image   src= "../res/image/video/左.png"   style="width: 37px;height: 30px;" onmouseover="changeHolder('left')"
                                 onmouseout="changeHolderOut('left')" onmousedown="mouseDownPTZControl(3);" onmouseup="mouseUpPTZControl()" title="左"  />--%>
                                <%--<input  id="leftDown" type=image   src= "../res/image/video/左下.png" style="width: 37px;height: 30px;" onmouseover="changeHolder('leftDown')"
                                 onmouseout="changeHolderOut('leftDown')" onmousedown="mouseDownPTZControl(6);" onmouseup="mouseUpPTZControl()" title="左下"/>--%>
                            <button title="左上" style="width: 37px; height: 30px;" onmousedown="mouseDownPTZControl(5);" onmouseup="mouseUpPTZControl();">
                                <input  id="leftUp" type=image src= "/res/layui/images/dev_icon/leftup_icon_check.png" style="width: 32px;height: 30px;" onmouseover="changeHolder('leftUp')" onmouseout="changeHolderOut('leftUp')"/>
                            </button>
                            <button title="左"  style="width: 37px; height: 30px;" onmousedown="mouseDownPTZControl(1);" onmouseup="mouseUpPTZControl();">
                                <input  id="left" type=image   src= "/res/layui/images/dev_icon/left_icon_check.png"   style="width: 32px;height: 30px;" onmouseover="changeHolder('left')" onmouseout="changeHolderOut('left')"/>
                            </button>
                            <button  title="左下" style="width: 37px; height: 30px;" onmousedown="mouseDownPTZControl(7);" onmouseup="mouseUpPTZControl();">
                                <input  id="leftDown" type=image   src= "/res/layui/images/dev_icon/leftdown_icon_check.png" style="width: 32px;height: 30px;" onmouseover="changeHolder('leftDown')" onmouseout="changeHolderOut('leftDown')" />
                            </button>
                        </div>
                        <div class="layui-col-md3">
                            <%-- <button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(3);" onmouseup="mouseUpPTZControl();">左</button>--%>
                            <%-- <button style="width: 37px;height: 30px;" onclick="mouseDownPTZControl(9);">自动</button>--%>
                                <%--  <button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(4);" onmouseup="mouseUpPTZControl();">右</button>--%>
                            <button title="上" style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(3);" onmouseup="mouseUpPTZControl();">
                                <input id="up"  type=image src= "/res/layui/images/dev_icon/up_icon_check.png" style="width: 32px;height: 30px;" onmouseover="changeHolder('up')" onmouseout="changeHolderOut('up')"/>
                            </button>
                            <button title="自动" style="width: 37px;height: 30px;" onclick="mouseDownPTZControl(9);">
                                <input id="auto" type=image src= "/res/layui/images/dev_icon/round_icon_check.png" style="width: 32px;height: 30px;text-align: center" onmouseover="changeHolder('auto')" />
                            </button>
                            <button title="下" style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(4);" onmouseup="mouseUpPTZControl();">
                                <input id="down" type=image src= "/res/layui/images/dev_icon/down_icon_check.png" style="width: 32px;height: 30px;" onmouseover="changeHolder('down')" onmouseout="changeHolderOut('down')" title="下"/>
                            </button>
                        </div>
                        <div class="layui-col-md3">
                            <%--  <button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(6);" onmouseup="mouseUpPTZControl();">左下</button>--%>
                            <%--  <button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(2);" onmouseup="mouseUpPTZControl();">下</button>--%>
                                <%-- <button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(8);" onmouseup="mouseUpPTZControl();">右下</button>--%>
                            <button title="右上" style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(6);" onmouseup="mouseUpPTZControl();">
                                <input id="rightUp" type=image src= "/res/layui/images/dev_icon/rightup_icon_check.png" style="width: 32px;height: 30px;" onmouseover="changeHolder('rightUp')" onmouseout="changeHolderOut('rightUp')" />
                            </button>
                            <button title="右" style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(2);" onmouseup="mouseUpPTZControl();">
                                <input id="right" type=image src= "/res/layui/images/dev_icon/right_icon_check.png" style="width: 32px;height: 30px;" onmouseover="changeHolder('right')" onmouseout="changeHolderOut('right')"  />
                            </button>
                            <button title="右下" style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(8);" onmouseup="mouseUpPTZControl();">
                                <input id="rightDown" type=image src= "/res/layui/images/dev_icon/rightdown_icon_check.png" style="width: 32px;height: 30px;" onmouseover="changeHolder('rightDown')" onmouseout="changeHolderOut('rightDown')"/>
                            </button>

                        </div>
                    </div>

                    <div class="layui-col-md6" style="padding: 5px;">
                        <div class="layui-col-md3">
                            <%--<button style="width: 60px;height: 30px;" onmousedown="PTZZoomIn()" onmouseup="PTZZoomStop()">变倍+</button>--%>
                            <%--<button style="width: 60px;height: 30px;" onmousedown="PTZFocusIn()" onmouseup="PTZFoucusStop()">变焦+</button>--%>
                            <%--<button style="width: 60px;height: 30px;" onmousedown="PTZIrisIn()" onmouseup="PTZIrisStop()">光圈+</button>--%>
                            <input  type=image   src= "/res/layui/images/dev_icon/big_icon_check.png" style="width: 30px;height: 30px;" onmousedown="PTZZoomIn()" onmouseup="PTZZoomStop()" title="变倍+"/>
                            <input  type=image   src= "/res/layui/images/dev_icon/big_icon_check.png" style="width: 30px;height: 30px;" onmousedown="PTZFocusIn()" onmouseup="PTZFoucusStop()" title="变焦+"/>
                            <input  type=image   src= "/res/layui/images/dev_icon/big_icon_check.png" style="width: 30px;height: 30px;" onmousedown="PTZIrisIn()" onmouseup="PTZIrisStop()" title="光圈+"/>
                        </div>
                        <div class="layui-col-md3">
                            <input  type=image   src= "/res/layui/images/dev_icon/double_icon_check.png" style="width: 30px;height: 30px;"  title="变倍-"/>
                            <input  type=image   src= "/res/layui/images/dev_icon/coke_icon_check.png" style="width: 30px;height: 30px;"  title="变焦-"/>
                            <input  type=image   src= "/res/layui/images/dev_icon/light_icon_check.png" style="width: 30px;height: 30px;"  title="光圈-"/>
                        </div>
                        <div class="layui-col-md3">
                            <%--<button style="width: 60px;height: 30px;" onmousedown="PTZZoomout()" onmouseup="PTZZoomStop()" >变倍-</button>--%>
                            <%--<button style="width: 60px;height: 30px;" onmousedown="PTZFoucusOut()" onmouseup="PTZFoucusStop()">变焦-</button>--%>
                            <%--<button style="width: 60px;height: 30px;" onmousedown="PTZIrisOut()" onmouseup="PTZIrisStop()">光圈-</button>--%>
                            <input  type=image   src= "/res/layui/images/dev_icon/small_icon_check.png" style="width: 30px;height: 30px;" onmousedown="PTZZoomout()" onmouseup="PTZZoomStop()" title="变倍-"/>
                            <input  type=image   src= "/res/layui/images/dev_icon/small_icon_check.png" style="width: 30px;height: 30px;" onmousedown="PTZFoucusOut()" onmouseup="PTZFoucusStop()" title="变焦-"/>
                            <input  type=image   src= "/res/layui/images/dev_icon/small_icon_check.png" style="width: 30px;height: 30px;" onmousedown="PTZIrisOut()" onmouseup="PTZIrisStop()" title="光圈-"/>
                        </div>
                    </div>

                    <div>
                        <div style="float: left">
                            <label>云台速度</label>
                            <select id="ptzspeed" class="sel">
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4" selected>4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7</option>
                            </select>
                        </div>
                        <%--                    <div style="float: left">&nbsp;--%>
                        <%--                        <label>预置点号</label><input id="preset" style="width: 50px;" value="1"/><button onclick="clickSetPreset()">设置</button>--%>
                        <%--                        <button onclick="clickGoPreset()">调用</button>--%>
                        <%--                    </div>--%>
                    </div>
                </div>
            </div>
        </div>

<%--    <jsp:include page="../header/footer.jsp"></jsp:include>--%>
    </div>


    <div <%--class="layui-body" style="padding: 15px; width: 100%;"--%>>

        <%-- 左边视频显示区域 --%>
        <%--<div class="my-tree-body-div">

            <div style="height:1%; background:#EEEEEE; padding:1px;">
                <div class="layui-col-md9">
                    <button style="width: auto; height: auto; " onclick="stopVideo()" onmouseover="changeImgMonA()" onmouseout="changeImgMonB()">
                        <img title="停止预览" id="imgMonitory" src="/res/image/video/stopPreviewOut.jpg" >
                    </button>
                    <button style="width: auto; height: auto;" onclick="catchVideo()">
                        <img title="开始抓图" id="imgZhua" src="/res/image/video/zhua.png" >
                    </button>
                    <button style="width: auto; height: auto;" onclick="clickStartRecord('realplay');" >
                        <img title="开始录像" id="imgVideoStart" src="/res/image/video/videoStart.jpg" >
                    </button>
                    <button style="width: auto; height: auto;" onclick="clickStopRecord('realplay');">
                        <img title="停止录像" id="imgVideoEnd" src="/res/image/video/videoEnd.png" >
                    </button>
                    <button style="width: auto; height: auto;" onclick="stopAllVideo()">
                        <img title="全部停止预览" id="imgMonitoryAll" src="/res/image/video/stopPreviewOut.jpg" >
                    </button>
                    <button style="width: 100px;height: 50px;" onclick="catchVideo()">抓图</button>
                    <button style="width: 100px;height: 50px;" onclick="clickStartRecord('realplay');">开始录像</button>
                    <button style="width: 100px;height: 50px;" onclick="clickStopRecord('realplay');">停止录像</button>
                    <button style="width: 100px;height: 50px;" onclick="stopAllVideo()">全部停止预览</button>
                </div>

                &lt;%&ndash;<div class="layui-col-md3">
                    <div class="layui-row grid-demo grid-demo-bg1" style="border:1px solid #606479;padding: 3px">
                        <div>
                            图片保存路径&nbsp;<input id="previewPicPath" type="text" class="txt" />&nbsp;<input type="button" class="btn" value="浏览" onclick="clickOpenFileDlg('previewPicPath', 0);" />
                        </div>
                        <div>
                            录像保存路径&nbsp;<input id="recordPath" type="text" class="txt" />&nbsp;<input type="button" class="btn" value="浏览" onclick="clickOpenFileDlg('recordPath', 0);" />
                        </div>
                        <div style="text-align:center;padding: 3px">
                            <button onclick="ZyclickGetLocalCfg()">获取</button>
                            <button onclick="ZyclickSetLocalCfg()">设置</button>
                        </div>
                    </div>
                </div>&ndash;%&gt;

            </div>
        </div>--%>

        <%-- 右边控制界面 --%>
      <%--
        <div class="my-tree-div"  >
            <div>
                <div style="height: 30px; background: #d5d9e2">
                    <label class="layui-form-label" style="padding: 5px; width: 40px;">视图</label>
                    <button style="float: right; background: #d5d9e2; border: 0px; margin-right: 20px; margin-top: 5px" onclick="showhide('video')">
                        <label id="video_arrows">∧</label>
                    </button>
                </div>
                &lt;%&ndash;                <div id="video" style="display:block" ></div>&ndash;%&gt;
                <div id="video" style="display:block" class="demo-tree-more"></div>

                &lt;%&ndash;                <div style="padding: 5px;">&ndash;%&gt;
                &lt;%&ndash;                    <input  type=image   src= "../res/image/SplitScreenOne.png" style="width: 40px;height: 40px;" onclick="changeWndNum(1)" title="一画面分割"/>&ndash;%&gt;
                &lt;%&ndash;                    <input  type=image   src= "../res/image/SplitScreenTwo.png" style="width: 40px;height: 40px;" onclick="changeWndNum(2)" title="四画面分割"/>&ndash;%&gt;
                &lt;%&ndash;                    <input  type=image   src= "../res/image/SplitScreenThree.png" style="width: 40px;height: 40px;" onclick="changeWndNum(3)" title="九画面分割"/>&ndash;%&gt;
                &lt;%&ndash;                    <input  type=image   src= "../res/image/SplitScreenFour.png" style="width: 40px;height: 40px;" onclick="changeWndNum(4)" title="十六画面分割"/>&ndash;%&gt;
                &lt;%&ndash;                </div> &ndash;%&gt;

                <div style="display:none;">
                    <tr>
                        <td class="tt">设备端口</td>
                        <td colspan="2"><input id="deviceport" type="text" class="txt" />（可选参数）</td>
                    </tr>
                    <tr>
                        <td class="tt">RTSP端口</td>
                        <td colspan="3"><input id="rtspport" type="text" class="txt" />（可选参数）</td>
                    </tr>
                    <td class="tt">通道列表</td>
                    <td>
                        <select id="channels" class="sel"></select>
                    </td>
                    <td style="display: none">
                        <select id="streamtype" class="sel">
                            <option value="1">主码流</option>
                            <option value="2">子码流</option>
                            <option value="3">第三码流</option>
                            <option value="4">转码码流</option>
                        </select>
                    </td>
                </div>
            </div>

            <div id="ttdiv" style="height: 60%;  margin-top: 10px; ">
                <div style="height: 30px; background: #d5d9e2">
                    <label class="layui-form-label" style="padding: 5px; width: 100px;">视频监控区域</label>
                    <button style="float: right; background: #d5d9e2; border: 0px; margin-right: 20px; margin-top: 5px"; onclick="showhide('monitoring')">
                        <label id="monitoring_arrows">∧</label>
                    </button>
                </div>
                <div id="monitoring" style="height: 90%; overflow-y:auto">
                    <ul id="tt" > </ul>  &lt;%&ndash; 下拉列表监控区域 &ndash;%&gt;
                </div>

                &lt;%&ndash;                右键功能&ndash;%&gt;
                <ul class="contextmenu">
                    <li><a onclick="rightVideo()">全部预览</a></li>
                </ul>
            </div>
            <div style="height: 20%">
                <div style="height: 30px; background: #d5d9e2">
                    <label class="layui-form-label" style="padding: 5px; width: 70px;">云台控制</label>
                    <button style="float: right; background: #d5d9e2; border: 0px; margin-right: 20px; margin-top: 5px"; onclick="showhide('spead')">
                        <label id="spead_arrows">∧</label>
                    </button>
                </div>
                <div id="spead">
                    <div class="layui-col-md6" style="padding: 5px;">
                        <div class="layui-col-md3">

                            &lt;%&ndash;                            <button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(5);" onmouseup="mouseUpPTZControl();">左上</button>&ndash;%&gt;
                            &lt;%&ndash;                            <button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(1);" onmouseup="mouseUpPTZControl();">上</button>&ndash;%&gt;
                            &lt;%&ndash;                            <button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(7);" onmouseup="mouseUpPTZControl();">右上</button>&ndash;%&gt;

                            &lt;%&ndash;                            <input  id="leftUp" type=image src= "../res/image/video/左上.png" style="width: 37px;height: 30px;" onmouseover="changeHolder('leftUp')" onmouseout="changeHolderOut('leftUp')" onmousedown="mouseDownPTZControl(5);" onmouseup="mouseUpPTZControl()" title="左上"/>&ndash;%&gt;
                            &lt;%&ndash;                            <input  id="left" type=image   src= "../res/image/video/左.png"   style="width: 37px;height: 30px;" onmouseover="changeHolder('left')" onmouseout="changeHolderOut('left')" onmousedown="mouseDownPTZControl(3);" onmouseup="mouseUpPTZControl()" title="左"  />&ndash;%&gt;
                            &lt;%&ndash;                            <input  id="leftDown" type=image   src= "../res/image/video/左下.png" style="width: 37px;height: 30px;" onmouseover="changeHolder('leftDown')" onmouseout="changeHolderOut('leftDown')" onmousedown="mouseDownPTZControl(6);" onmouseup="mouseUpPTZControl()" title="左下"/>&ndash;%&gt;

                            <button title="左上" style="width: 37px; height: 30px;" onmousedown="mouseDownPTZControl(5);" onmouseup="mouseUpPTZControl();">
                                <input  id="leftUp" type=image src= "../res/image/video/左上.png" style="width: 37px;height: 30px;" onmouseover="changeHolder('leftUp')" onmouseout="changeHolderOut('leftUp')"/>
                            </button>
                            <button title="左"  style="width: 37px; height: 30px;" onmousedown="mouseDownPTZControl(1);" onmouseup="mouseUpPTZControl();">
                                <input  id="left" type=image   src= "../res/image/video/左.png"   style="width: 37px;height: 30px;" onmouseover="changeHolder('left')" onmouseout="changeHolderOut('left')"/>
                            </button>
                            <button  title="左下" style="width: 37px; height: 30px;" onmousedown="mouseDownPTZControl(7);" onmouseup="mouseUpPTZControl();">
                                <input  id="leftDown" type=image   src= "../res/image/video/左下.png" style="width: 37px;height: 30px;" onmouseover="changeHolder('leftDown')" onmouseout="changeHolderOut('leftDown')" />
                            </button>

                        </div>
                        <div class="layui-col-md3">
                            &lt;%&ndash;                            <button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(3);" onmouseup="mouseUpPTZControl();">左</button>&ndash;%&gt;
                            &lt;%&ndash;                            <button style="width: 37px;height: 30px;" onclick="mouseDownPTZControl(9);">自动</button>&ndash;%&gt;
                            &lt;%&ndash;                            <button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(4);" onmouseup="mouseUpPTZControl();">右</button>&ndash;%&gt;
                            <button title="上" style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(3);" onmouseup="mouseUpPTZControl();">
                                <input id="up"  type=image src= "../res/image/video/上.png" style="width: 37px;height: 30px;" onmouseover="changeHolder('up')" onmouseout="changeHolderOut('up')"/>
                            </button>
                            <button title="自动" style="width: 37px;height: 30px;" onclick="mouseDownPTZControl(9);">
                                <input id="auto" type=image src= "../res/image/video/自动.png" style="width: 37px;height: 30px;" onmouseover="changeHolder('auto')" />
                            </button>
                            <button title="下" style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(4);" onmouseup="mouseUpPTZControl();">
                                <input id="down" type=image src= "../res/image/video/下.png" style="width: 37px;height: 30px;" onmouseover="changeHolder('down')" onmouseout="changeHolderOut('down')" title="下"/>
                            </button>
                        </div>
                        <div class="layui-col-md3">
                            &lt;%&ndash;                            <button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(6);" onmouseup="mouseUpPTZControl();">左下</button>&ndash;%&gt;
                            &lt;%&ndash;                            <button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(2);" onmouseup="mouseUpPTZControl();">下</button>&ndash;%&gt;
                            &lt;%&ndash;                            <button style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(8);" onmouseup="mouseUpPTZControl();">右下</button>&ndash;%&gt;

                            <button title="右上" style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(6);" onmouseup="mouseUpPTZControl();">
                                <input id="rightUp" type=image src= "../res/image/video/右上.png" style="width: 37px;height: 30px;" onmouseover="changeHolder('rightUp')" onmouseout="changeHolderOut('rightUp')" />
                            </button>
                            <button title="右" style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(2);" onmouseup="mouseUpPTZControl();">
                                <input id="right" type=image src= "../res/image/video/右.png" style="width: 37px;height: 30px;" onmouseover="changeHolder('right')" onmouseout="changeHolderOut('right')"  />
                            </button>
                            <button title="右下" style="width: 37px;height: 30px;" onmousedown="mouseDownPTZControl(8);" onmouseup="mouseUpPTZControl();">
                                <input id="rightDown" type=image src= "../res/image/video/右下.png" style="width: 37px;height: 30px;" onmouseover="changeHolder('rightDown')" onmouseout="changeHolderOut('rightDown')"/>
                            </button>

                        </div>
                    </div>

                    <div class="layui-col-md6" style="padding: 5px;">
                        <div class="layui-col-md3">
                            &lt;%&ndash;                            <button style="width: 60px;height: 30px;" onmousedown="PTZZoomIn()" onmouseup="PTZZoomStop()">变倍+</button>&ndash;%&gt;
                            &lt;%&ndash;                            <button style="width: 60px;height: 30px;" onmousedown="PTZFocusIn()" onmouseup="PTZFoucusStop()">变焦+</button>&ndash;%&gt;
                            &lt;%&ndash;                            <button style="width: 60px;height: 30px;" onmousedown="PTZIrisIn()" onmouseup="PTZIrisStop()">光圈+</button>&ndash;%&gt;

                            <input  type=image   src= "../res/image/video/变倍加.png" style="width: 30px;height: 30px;" onmousedown="PTZZoomIn()" onmouseup="PTZZoomStop()" title="变倍+"/>
                            <input  type=image   src= "../res/image/video/变焦加.png" style="width: 30px;height: 30px;" onmousedown="PTZFocusIn()" onmouseup="PTZFoucusStop()" title="变焦+"/>
                            <input  type=image   src= "../res/image/video/光圈加.png" style="width: 30px;height: 30px;" onmousedown="PTZIrisIn()" onmouseup="PTZIrisStop()" title="光圈+"/>
                        </div>
                        <div class="layui-col-md3">
                            &lt;%&ndash;                            <button style="width: 60px;height: 30px;" onmousedown="PTZZoomout()" onmouseup="PTZZoomStop()" >变倍-</button>&ndash;%&gt;
                            &lt;%&ndash;                            <button style="width: 60px;height: 30px;" onmousedown="PTZFoucusOut()" onmouseup="PTZFoucusStop()">变焦-</button>&ndash;%&gt;
                            &lt;%&ndash;                            <button style="width: 60px;height: 30px;" onmousedown="PTZIrisOut()" onmouseup="PTZIrisStop()">光圈-</button>&ndash;%&gt;
                            <input  type=image   src= "../res/image/video/变倍减.png" style="width: 30px;height: 30px;" onmousedown="PTZZoomout()" onmouseup="PTZZoomStop()" title="变倍-"/>
                            <input  type=image   src= "../res/image/video/变焦减.png" style="width: 30px;height: 30px;" onmousedown="PTZFoucusOut()" onmouseup="PTZFoucusStop()" title="变焦-"/>
                            <input  type=image   src= "../res/image/video/光圈减.png" style="width: 30px;height: 30px;" onmousedown="PTZIrisOut()" onmouseup="PTZIrisStop()" title="光圈-"/>
                        </div>
                    </div>

                    <div>
                        <div style="float: left">
                            <label>云台速度</label>
                            <select id="ptzspeed" class="sel">
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4" selected>4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                                <option value="7">7</option>
                            </select>
                        </div>
                        &lt;%&ndash;                    <div style="float: left">&nbsp;&ndash;%&gt;
                        &lt;%&ndash;                        <label>预置点号</label><input id="preset" style="width: 50px;" value="1"/><button onclick="clickSetPreset()">设置</button>&ndash;%&gt;
                        &lt;%&ndash;                        <button onclick="clickGoPreset()">调用</button>&ndash;%&gt;
                        &lt;%&ndash;                    </div>&ndash;%&gt;
                    </div>
                </div>


            </div>
        </div>
        </div>
--%>

    </div>
</body>


<script>

    leftThis('实时预览');  //点击左侧左侧导航栏不刷新

    var array = new Array();
    //leftThis('实时预览');
    //注意：导航 依赖 element 模块，否则无法进行功能性操作
    layui.use(['element','layer'], function(){
        var element = layui.element;
        // leftThis('实时预览');
        $(function () {
            layer.msg('请将浏览器模式改为兼容模式！');
        })
    });

    $('#tt').tree({
        url:'getTreeVideoDevData',
    });

    $('#tt').tree({
        onClick: function(node){
            // console.log(node);
            var id = node.id;
            console.log("id===" + id);
            $.post('getVideoInfo',{id:id},function (res) {
                // alert(res.ip);
                console.log( res.ip +" " + res.port + " " + res.username + " " + res.password );

                var szIP = res.ip,
                    szPort = res.port,
                    szUsername = res.username,
                    szPassword = res.password;

                   ZyclickLogin(szIP,szPort,szUsername,szPassword);//1.登录摄像机
                // clickLogin();
                setTimeout(function () {
                     ZyclickStartRealPlay(szIP,szPort,0,true,1);//2.预览
                    //clickStartRealPlay();
                }, 20);
            })
        },
        onContextMenu: function (e, title) {
            //console.log(title.children);
            e.preventDefault();
            array = title.children;
            if(title.iconCls == "my-tree-icon-5"){
                $(".contextmenu").css({
                    "left":  e.pageX-200,
                    "top": e.pageY-50
                }).show();
            }
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
        //ZyclickLogout();
    }

    //全部停止播放
    function stopAllVideo() {
        ZyclickAllStopRealPlay();
    }

    //抓图
    function catchVideo() {
        clickCapturePic(1);
        //onTips("操作成功");
    }

    function rightVideo() {
        // var id = array[0].id;
        // ippost(id,0);
        //  id = array[1].id;
        // ippost(id,1);
        //  id = array[2].id;
        // ippost(id,2);
        //  id = array[3].id;
        // ippost(id,3);

        for(var a=0;a<array.length;a++){
            var id = array[a].id;
                ippost(id,a);
        }
    }

    function ippost(id,a) {
        $.post('getVideoInfo',{id:id},function (res) {
            console.log(res);
            //alert(res.ip);
            setTimeout(function () {
                var szIP = res.ip,
                szPort = res.port,
                szUsername = res.username,
                szPassword = res.password;

                ZyclickLogin(szIP,szPort,szUsername,szPassword);//1.登录摄像机
                ZyAllclickStartRealPlay(szIP,szPort,0,true,1,a);//2.预览
            }, 200);
        })
    }

    //div显示与隐藏
    function showhide(divid) {
        console.log("aaaaaaaaaaaaaa");
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

    //云台控制鼠标放在上面变色 dd 2020.6.22
    function changeHolder(divid) {
        // console.log("aaaaaaa")
        // console.log(divid)
        document.getElementById(divid).style.backgroundColor='#ff1008';
    }

    //云台控制鼠标离开变色 dd 2020.6.22
    function changeHolderOut(divid) {
        document.getElementById(divid).style.backgroundColor='#fff5f5';
    }

</script>

<script src="../../res/hkwebsdk/websdk/jquery-1.7.1.min.js"></script>
<%--<script id="videonode" src="../res/hkwebsdk/websdk/codebase/webVideoCtrl.js"></script>--%>
<script id="videonode" src="../../res/hkwebsdk/websdk/codebase/webVideoCtrl.js"></script>
<script src="../../res/hkwebsdk/websdk/cn/demo.js"></script>


<%--<script type="text/javascript" src='../res/js/jquery.min.js'></script>&lt;%&ndash;右键用到这个js&ndash;%&gt;--%>
<script>

    layui.use(['tree'], function(){
        var tree = layui.tree
            ,layer = layui.layer

        //数据
        ,data = [{
            title:'默认视图' //一级菜单
            ,id:1
            ,field:'name1'
            ,spread:true
            ,children: [{
                title:'1*1-画面' //二级菜单
                ,id:11
                ,field: 'name11'
            },{
                title:'4*4-画面'
                ,id:12
                ,field:'name12'
            },{
                title: '9*9-画面'
                ,id:13
                ,field:'name13'
            },{
                title: '16*16-画面'
                ,id:14
                ,field:'name14'
            }]
        }]

        //渲染
       tree.render({
            elem: '#video'  //绑定元素
            ,data: data
            ,isJump:true //允许点击节点时弹出新窗口跳转
            ,click:function (obj) {
                var data = obj.data;
                // console.log("data" + data);
                var id = data.id;
                // console.log(id);
               if (id == 11) {
                   changeWndNum(1);
               } else if (id == 12) {
                   changeWndNum(2);
               }else if(id == 13) {
                   changeWndNum(3);
               }else if(id == 14) {
                   changeWndNum(4);
               }

            }

        });
    });
</script>

<script>
    function changeImgMonA() {
        document.getElementById('imgMonitory').src = '/res/image/video/stopPreviewOver.png';
    }
    function changeImgMonB() {
        document.getElementById('imgMonitory').src = '/res/image/video/stopPreviewOut.jpg';
    }
</script>

</html>
