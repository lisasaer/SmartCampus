<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2019/11/22
  Time: 19:56
  To change this template use File | Settings | File Templates.
--%>
<%--<%--%>
<%--    boolean bComOpen = Boolean.valueOf(request.getSession().getAttribute("comOpen").toString());--%>
<%--%>--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>首页</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <jsp:include page="../header/res.jsp"></jsp:include>

    <%--<script src="http://d1.lashouimg.com/static/js/release/jquery-1.4.2.min.js" type="text/javascript"></script>--%>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script type="text/javascript" src="http://api.map.baidu.com/api?v=3.0&ak=2b866a6daac9014292432d81fe9b47e3"></script>

    <style>
        .opacity1, .opacity2, .opacity_img { display: inline-block; }

        .opacity1 { filter: Alpha(opacity=0); }

        .opacity2 { filter: Alpha(opacity=50); }

        .opacity_img { filter: Alpha(opacity=100); }

        :root .opacity1 { opacity: 0; filter: none; }

        :root .opacity2 { opacity: .5; filter: none; }

        :root .opacity_img { opacity: 1; filter: none; }
        .frameName{
            font-family: Microsoft YaHei-Bold;
            font-size: 18px;
            color: #10bbf8;
            float: left;

            padding-left: 30px;
            margin-top: 13px;
            margin-left: 6px;
        }
        .record{
            width:75px;
            height: 30px;
            display: table-cell;
            vertical-align: middle;
            font-family: 'Microsoft Ya Hei';
            font-size:14px;
            color: #10bbf8;
            border-width: 0;
            background-color: rgba(16, 187, 248, 0);
        }

        .record:hover{
            background-color: #10bbf854;
        }
        .chinkRecord{
            width:75px;
            height: 30px;
            display: table-cell;
            vertical-align: middle;
            font-family: 'Microsoft Ya Hei';
            font-size:14px;
            color: #10bbf8;
            border-width: 0;
            background-color: #10bbf854;
        }
        .layui-table {
            background-color: rgba(243, 241, 236, 0);
            font-family: 'Microsoft Ya Hei';
            font-size:14px;
            color: #d3ebff;
        }
        .layui-table td, .layui-table th,
        .layui-table-col-set, .layui-table-fixed-r,
        .layui-table-grid-down, .layui-table-header,
        .layui-table-page, .layui-table-tips-main,
        .layui-table-tool, .layui-table-total,
        .layui-table-view, .layui-table[lay-skin=line], .layui-table[lay-skin=row] {
            border-color: rgba(19, 215, 157, 0);

        }
        .layui-table tbody tr:hover,
        .layui-table thead tr,
        .layui-table-click,
            /*.layui-table-header,*/
        .layui-table-hover
        /*.layui-table-mend,*/
        /*.layui-table-patch,*/
        /*.layui-table-tool,*/
        /*.layui-table-total*/
        /*.layui-table-total tr,*/
        /*.layui-table[lay-even] tr:nth-child(even) */{
            background-color: rgba(16, 187, 248, 0.44);
        }
        .layui-table-header{
            background-color: rgba(243, 241, 236, 0);
        }
        .layui-table-header span {
            color:#10bbf8;

        }
        .layui-table-cell {
            padding:0;
        }
        .layui-table-view .layui-table td, .layui-table-view .layui-table th {
            padding-top: 2px;
            padding-bottom: 2px;
        }

        /*layui滚动条样式*/
        ::-webkit-scrollbar{width: 0px; height: 0px;}
        ::-webkit-scrollbar-button:vertical{display: none;}
        ::-webkit-scrollbar-track, ::-webkit-scrollbar-corner{background-color: #e2e2e2;}
        ::-webkit-scrollbar-thumb{border-radius: 0; background-color: rgba(0,0,0,.3);}
        ::-webkit-scrollbar-thumb:vertical:hover{background-color: rgba(0,0,0,.35);}
        ::-webkit-scrollbar-thumb:vertical:active{background-color: rgba(0,0,0,.38);}

        .container div {
            width: 824px;
            height: 555px;
            padding-left: 0px;
            padding-top: 0px;
            overflow: hidden;
            position: relative;
            z-index: 0;
            background-color: rgb(243, 6, 24);
            color: rgb(0, 0, 0);
            text-align: left;
        }

        .BMap_mask div {
            width: 824px;
            height: 555px;
            padding-left: 0px;
            padding-top: 0px;
            overflow: hidden;
            position: relative;
            z-index: 0;
            background-color: rgb(75, 243, 33);
            color: rgb(0, 0, 0);
            text-align: left;
        }
        body, html,#allmap {width: 100%;height: 100%;overflow: hidden;margin:0;font-family:"微软雅黑";/*background-color: rgba(243, 241, 236, 0)*/;}
        .BMap_cpyCtrl {
            display: none;
        }
        .anchorBL {
            display: none;
        }
        .layui-table-box{
            background-color: rgba(248, 24, 30, 0);
        }

        /*table表单初始化的背景颜色*/
        .layui-table-init {
            position: absolute;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            text-align: center;
            z-index: 110;
            background-color: rgba(255, 255, 255, 0.08);
        }
       /* :-webkit-full-screen #divBody div{
            width: 100%;
            height: 100%;
        }*/

        .fullScreen {
            background: url("../../res/layui/images/homePage/iconFullScreen.png")no-repeat;
            margin-left: 42px;
            width: 24px;
            height: 24px;
        }
        .zoom {
            background: url("../../res/layui/images/homePage/iconZoom.png")no-repeat;
            margin-left: 42px;
            width: 24px;
            height: 24px;
        }
        .body{
            margin-left: 25px;
            margin-top: 3px;
            position: absolute;
            left: 200px;
            right: 0;
            top: 60px;
            bottom: 0;
            z-index: 998;
            width: auto;
            overflow-y: auto;
            overflow-x:hidden;
            box-sizing: border-box;
        }
        .test{
            top:0;
            margin:0;
            left:0;
            width: 1920px;
        }

    </style>
</head>
<body class="layui-layout-body" >
<!-- 引入 echarts.js -->
<script src="https://cdn.staticfile.org/echarts/4.3.0/echarts.min.js"></script>
<div class="layui-layout layui-layout-admin">
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <jsp:include page="../header/topHead.jsp"></jsp:include>
    <div id="divBody" class="body" style="bottom: 0px;background: url('../../res/layui/images/homePage/backGround.png') no-repeat;background-size: 100%">
        <div id="information">
        <div class="layui-row" style="width:100%;height:94px;/*margin-top: 4px;*/background: url('../../res/layui/images/homePage/titleBar.png') no-repeat 0 center;">

            <div style="float: left">
                <div id="start" style=" padding-top: 25px;margin-left: 1250px;width: 100%;font-family:'ArialMT'; font-size: 18px;color: #10bbf8;">
                    <%--                <a  style=" />--%>
                </div>
            </div>
            <div style="padding-top: 25px;float: left;">
                <button  onclick='toggleFullScreen();' style="background-color: rgba(193, 21, 21, 0);border: 0;">
                    <div class="fullScreen" id="fullId"></div>
                </button>

                <%--                <input type='button' onclick='toggleFullScreen();'0>--%>
            </div>
        </div>
        <div >
            <div style="height: 42px; margin-left: 14px;">
                <span class="frameName" style="background: url('../../res/layui/images/homePage/iconAlarmAnalysis.png') no-repeat 0 center;">报警分析</span>
                <span class="frameName" style="margin-left: 1165px;background: url('../../res/layui/images/homePage/iconClassifiedEnergyConsumptionStatistics.png') no-repeat 0 center;">分类能耗分析</span>
            </div>

            <div id="left" style="margin-left: 14px;float: left;">
<%--                <img src="../../res/layui/images/homePage/analysisFrame.png" style="width: 500px;height: 235px;">--%>
                <div style="background: url('../../res/layui/images/homePage/analysisFrame.png') no-repeat 0 center;width: 386px;height: 235px;">
                    <div style="width:326px;height: 235px;display: table-cell;vertical-align: middle;">
                        <div style="background: url('../../res/layui/images/homePage/alarmAnalysis_dataBallGreen.png') no-repeat 0 center;margin-left: 30px;width: 137px;height: 137px;float: left;">
                            <div style="width: 137px;height: 137px;display: table-cell;vertical-align: middle;text-align: center">
                                <a style="font-family: 'ArialMT';font-size:31px;color: #07d4dc;">354</a>
                                <br>
                                <a style="font-family: 'SourceHanSansCN-Regular';font-size:17px;color: #d3ebff;">今日报警</a>
                            </div>
                        </div>
                        <div style="background: url('../../res/layui/images/homePage/alarmAnalysis_dataBallYellow.png') no-repeat 0 center;margin-left: 177px;width: 137px;height: 137px;">
                            <div style="width: 137px;height: 137px;display: table-cell;vertical-align: middle;text-align: center">
                                <a style="font-family: 'ArialMT';font-size:31px;color: #ffa016">354</a>
                                <br>
                                <a style="font-family: 'SourceHanSansCN-Regular';font-size:17px;color: #d3ebff;">昨日报警</a>
                            </div>
                        </div>
                    </div>
                    <div style="width:60px;height: 235px;display: table-cell;vertical-align: middle;">
                        <a style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;/*float: left*/">同比</a>
                        <br>
                        <a style="font-family: 'ArialMT';font-size:24px;color: #10bbf8;/*float: left*/">0</a>
                        <a style="font-family: 'ArialMT';font-size:12px;color: #10bbf8;/*float: left*/">%</a>
                    </div>
                </div>
                <span class="frameName" style="background: url('../../res/layui/images/homePage/iconAlarmHandlingSituation.png') no-repeat 0 center;">报警处理情况</span>
                <div style="margin-top:50px;background: url('../../res/layui/images/homePage/alarmHandlingSituationFrame.png') no-repeat 0 center;width: 386px;height: 286px; ">
                    <div style="width: 386px;height: 40px;padding-top: 20px;">
                        <img src="../../res/layui/images/homePage/AlarmHandlingSituation_TotalAlarms.png" style="margin-left: 110px;">
                        <a style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;">报警总数</a>
                        <img src="../../res/layui/images/homePage/AlarmHandlingSituation_Processed.png" style="margin-left: 15px;">
                        <a style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;">已处理</a>
                        <img src="../../res/layui/images/homePage/AlarmHandlingSituation_NotProcessed.png" style="margin-left: 15px;">
                        <a style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;">未处理</a>
                    </div>
                    <div id ="chart3" style="width: 386px;height: 250px;padding-left: 10px;"></div>
                </div>
                <span class="frameName" style="background: url('../../res/layui/images/homePage/iconAlarmTypeDistribution.png') no-repeat 0 center;margin-top: 24px;">报警类型分布</span>
                <div style="margin-top:56px;background: url('../../res/layui/images/homePage/alarmTypeDistributionFrame.png') no-repeat 0 center;width: 386px;height: 220px; ">
                    <div id ="chart1" style="width: 386px;height: 190px;"></div>
                    <div style="width: 386px;height: 20px;">
                        <div style="height: 12px;width: 12px ;background-image: linear-gradient(to top, #0c369a,#08a9ff); ;float:left;margin-left: 50px;margin-top: 4px;border-radius: 2px;"></div>
                        <div style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;float:left;margin-left: 8px;">监控</div>
                        <div style="height: 12px;width: 12px ;background-image: linear-gradient(to top, #fc822c,#fcb233);float:left;margin-left: 30px;margin-top: 4px;border-radius: 2px;"></div>
                        <div style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;float:left;margin-left: 8px;">空开</div>
                        <div style="height: 12px;width: 12px ;background-image: linear-gradient(to top, #13b27b,#13d79d);float:left;margin-left: 30px;margin-top: 4px;border-radius: 2px;"></div>
                        <div style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;float:left;margin-left: 8px;">门禁</div>
                        <div style="height: 12px;width: 12px ;background-image: linear-gradient(to top, #069ce8,#07d1e8);float:left;margin-left: 30px;margin-top: 4px;border-radius: 2px;"></div>
                        <div style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;float:left;margin-left: 8px;">其他</div>
                    </div>
                </div>
            </div>

            <div style="float: left; margin-left: 22px;">
                <div style="background: url('../../res/layui/images/homePage/mapFrame.png') no-repeat 0 center;width: 839px;height: 572px;">
                    <div style="    padding-top: 8px;padding-left: 8px;">
                        <div id="container" style="width: 824px;height: 555px;padding-left: 0px;padding-top: 0px;background-color: rgba(243,189,12,0);z-index: 0;overflow: hidden;position: relative;color: rgb(0, 0, 0);text-align: left;"></div>
                    </div>
                </div>
                <span class="frameName" style="background: url('../../res/layui/images/homePage/iconOperationOfEquipment.png') no-repeat 0 center;margin-top: 24px;">设备运行情况</span>
                <div style="margin-top:56px;background: url('../../res/layui/images/homePage/devOperationConditionFrame.png') no-repeat 0 center;width: 839px;height: 220px;">
                    <div style="width: 739px;height: 220px;display: table-cell;vertical-align: middle;">
                        <a href="/switchDevView" style="background: url('../../res/layui/images/homePage/空开设备数据.png') no-repeat 0 center;margin-left: 50px;width: 137px;height: 137px;float: left;">
                            <div style="width: 137px;height: 137px;display: table-cell;vertical-align: middle;text-align: center">
                                <div style="font-family: 'ArialMT';font-size:31px;color: #06f3fb;">98</div>
                                <div style="font-family: 'SourceHanSansCN-Regular';font-size:17px;color: #d3ebff;">空开设备</div>
                            </div>
                        </a>
                        <a href="" style="background: url('../../res/layui/images/homePage/空调设备数据.png') no-repeat 0 center;margin-left: 30px;width: 137px;height: 137px;float: left;">
                            <div style="width: 137px;height: 137px;display: table-cell;vertical-align: middle;text-align: center">
                                <div style="font-family: 'ArialMT';font-size:31px;color: #16d483;">50</div>
                                <div style="font-family: 'SourceHanSansCN-Regular';font-size:17px;color: #d3ebff;">空调设备</div>
                            </div>
                        </a>
                        <a href="" style="background: url('../../res/layui/images/homePage/监控设备数据.png') no-repeat 0 center;margin-left: 30px;width: 137px;height: 137px;float: left;">
                            <div style="width: 137px;height: 137px;display: table-cell;vertical-align: middle;text-align: center">
                                <div style="font-family: 'ArialMT';font-size:31px;color: #ffa016;">354</div>
                                <div style="font-family: 'SourceHanSansCN-Regular';font-size:17px;color: #d3ebff;">监控设备</div>
                            </div>
                        </a>
                        <a href="" style="background: url('../../res/layui/images/homePage/门禁设备数据.png') no-repeat 0 center;margin-left: 30px;width: 137px;height: 137px;float: left;">
                            <div style="width: 137px;height: 137px;display: table-cell;vertical-align: middle;text-align: center">
                                <div style="font-family: 'ArialMT';font-size:31px;color: #d9610a;">128</div>
                                <div style="font-family: 'SourceHanSansCN-Regular';font-size:17px;color: #d3ebff;">门禁设备</div>
                            </div>
                        </a>
                    </div>
                    <div style="width:100px;height: 220px;display: table-cell;vertical-align: middle;">
                        <a style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;/*float: left*/">今日报警</a>
                        <br>
                        <a style="font-family: 'ArialMT';font-size:24px;color: #10bbf8;/*float: left*/">201</a>
                        <br>
                        <br>
                        <a style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;/*float: left*/">报警总数</a>
                        <br>
                        <a style="font-family: 'ArialMT';font-size:24px;color: #10bbf8;/*float: left*/">201</a>
                    </div>
                </div>
            </div>

            <div style="float: left; margin-left: 22px;">
                <div style="background: url('../../res/layui/images/homePage/analysisFrame.png') no-repeat 0 center;width: 386px;height: 235px;">
                    <div>
                        <div style="padding-left: 30px;width: 96px;height: 90px;display: table-cell;vertical-align: middle;">
                            <div style="background:url('../../res/layui/images/homePage/空调用电icon.png') no-repeat;width: 31px;height: 32px;"></div>
                        </div>
                        <div style="width: 150px;height: 90px;display: table-cell;vertical-align: middle;">
                            <a style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;/*float: left*/">空调用电</a>
                            <br>
                            <a style="font-family: 'ArialMT';font-size:24px;color: #10bbf8;/*float: left*/">1651</a>
                            <a style="font-family: 'ArialMT';font-size:12px;color: #10bbf8;/*float: left*/">kwh</a>
                        </div>
                        <div style="width: 80px;height: 90px;display: table-cell;vertical-align: middle;">
                            <a style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;/*float: left*/">昨日同比</a>
                            <br>
                            <a style="font-family: 'ArialMT';font-size:24px;color: #10bbf8;/*float: left*/">216</a>
                            <a style="font-family: 'ArialMT';font-size:12px;color: #10bbf8;/*float: left*/">%</a>
                        </div>
                        <div style="width: 60px;height: 90px;display: table-cell;vertical-align: middle;">
                            <div style="width: 0;height: 0; border-bottom: 7px solid #10bbf8;border-left: 7px solid transparent;border-right: 7px solid transparent;"></div>
                            <div style="width: 4px;height: 22px;background-color: #10bbf8;margin-left: 5px"></div>
                        </div>
                    </div>
                    <div>
                        <div  style="padding-left: 30px;width: 96px;height: 50px;display: table-cell;vertical-align: middle;">
                            <div style="background:url('../../res/layui/images/homePage/照明用电icon.png') no-repeat;width: 31px;height: 32px;"></div>
                        </div>
                        <div style="width: 150px;height: 50px;display: table-cell;vertical-align: middle;">
                            <a style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;/*float: left*/">照明用电</a>
                            <br>
                            <a id="light" style="font-family: 'ArialMT';font-size:24px;color: #10bbf8;/*float: left*/"></a>
                            <a style="font-family: 'ArialMT';font-size:12px;color: #10bbf8;/*float: left*/">kwh</a>
                        </div>
                        <div style="width: 80px;height: 50px;display: table-cell;vertical-align: middle;">
                            <a style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;/*float: left*/">昨日同比</a>
                            <br>
                            <a id="up" style="font-family: 'ArialMT';font-size:24px;color: #10bbf8;/*float: left*/"></a>
                            <a id="percent" style="font-family: 'ArialMT';font-size:12px;color: #10bbf8;/*float: left*/">%</a>
                        </div>
                        <div id="lightUp" style="width: 60px;height: 50px;display: table-cell;vertical-align: middle;">
                            <div style="width: 0;height: 0; border-bottom: 7px solid #10bbf8;border-left: 7px solid transparent;border-right: 7px solid transparent;"></div>
                            <div style="width: 4px;height: 22px;background-color: #10bbf8;margin-left: 5px"></div>
                        </div>
                        <div id="lightDown" style="width: 60px;height: 50px;display: table-cell;vertical-align: middle;">
                            <div style="width: 4px;height: 22px;background-color: #ff6f03;margin-left: 5px"></div>
                            <div style="width: 0;height: 0; border-top: 7px solid #ff6f03;border-left: 7px solid transparent;border-right: 7px solid transparent;"></div>
                        </div>
                    </div>

                    <div>
                        <div  style="padding-left: 30px;width: 96px;height: 95px;display: table-cell;vertical-align: middle;">
                            <div style="background:url('../../res/layui/images/homePage/其他用电icon.png') no-repeat;width: 31px;height: 32px;"></div>
                        </div>
                        <div style="width: 150px;height: 95px;display: table-cell;vertical-align: middle;">
                            <a style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;/*float: left*/">其他用电</a>
                            <br>
                            <a style="font-family: 'ArialMT';font-size:24px;color: #10bbf8;/*float: left*/">1651</a>
                            <a style="font-family: 'ArialMT';font-size:12px;color: #10bbf8;/*float: left*/">kwh</a>
                        </div>
                        <div style="width: 80px;height: 95px;display: table-cell;vertical-align: middle;">
                            <a style="font-family: 'Microsoft Ya Hei';font-size:14px;color: #10bbf8;/*float: left*/">昨日同比</a>
                            <br>
                            <a style="font-family: 'ArialMT';font-size:24px;color: #ff6f03;/*float: left*/">110</a>
                            <a style="font-family: 'ArialMT';font-size:12px;color: #ff6f03;/*float: left*/">%</a>
                        </div>
                        <div style="width: 60px;height: 95px;display: table-cell;vertical-align: middle;">
                            <div style="width: 4px;height: 22px;background-color: #ff6f03;margin-left: 5px"></div>
                            <div style="width: 0;height: 0; border-top: 7px solid #ff6f03;border-left: 7px solid transparent;border-right: 7px solid transparent;"></div>

                            </div>
                        </div>
                    </div>
                    <span class="frameName" style="background: url('../../res/layui/images/homePage/iconTrafficRealTimeDynamic.png') no-repeat 0 center;">通行实时动态</span>
                    <div style="margin-top:50px;background: url('../../res/layui/images/homePage/TrafficRealTimeDynamicFrame.png') no-repeat 0 center;width: 386px;height: 286px;">
                        <div style="width: 375px;height: 33px;padding-top:7px;padding-left: 7px">
                            <button class="record button1" ><div style="width: 4px;height: 4px;background-color: #10bbf8;border-radius: 4px;position:absolute;z-index:-1;float: left;margin-left: 13px;margin-top: 8px"></div>今日</button>

                            <button class="record button2" style="padding-left: 0"><div style="width: 4px;height: 4px;background-color: #10bbf8;border-radius: 4px;position:absolute;z-index:-1;margin-left: 8px;margin-top: 8px"></div>近7天</button>
                            <button class="record button3" style="padding-left: 0"><div style="width: 4px;height: 4px;background-color: #10bbf8;border-radius: 4px;position:absolute;z-index:-1;margin-left: 4px;margin-top: 8px"></div>近30天</button>
                        </div>
                        <div style="padding-left: 6px">
                            <table id="demo" lay-filter="test" class="layui-hide" ></table>
                        </div>

                    </div>
                    <span class="frameName" style="background: url('../../res/layui/images/homePage/iconRecentlyCapturedPhotos.png') no-repeat 0 center; margin-top: 24px;">最近抓拍照片</span>
                    <div style="margin-top:56px;background: url('../../res/layui/images/homePage/alarmTypeDistributionFrame.png') no-repeat 0 center;width: 386px;height: 220px;">

                        <div class="divId" id="picture" style="width: 386px;height: 220px;display: table-cell;vertical-align: middle;">
                            <div style="width: 122px;height: 184px;border-width: 1px;border-style: solid;border-color: #10bbf8;margin-left: 20px;float: left;">

                                <div style="width: 114px;height: 175px; margin-left: 3px;margin-top: 3.5px;">
                                    <img id="picture1" src="${list[0].imagePath}" style="width: 114px;height: 175px;">
                                </div>
                            </div>
                            <div style="width: 122px;height: 184px;border-width: 1px;border-style: solid;border-color: #10bbf8;margin-left: 20px;float: left;">
                                <div style="width: 114px;height: 175px; margin-left: 3px;margin-top: 3.5px;">
                                    <img id="picture2" src="${list[1].imagePath}" style="width: 114px;height: 175px;">
                                </div>
                            </div>
                            <div style="width: 76px;height: 184px;border-width: 1px;border-style: solid;border-color: #10bbf8;margin-left: 20px;float: left;overflow:hidden;">
                                <div style="width: 72px;height: 175px; margin-left: 3px;margin-top: 3.5px;background: rgba(0,238,0,0) -webkit-linear-gradient(left, rgba(255,255,255,0),#070f24);">

                                    <img id="picture3"  src="${list[2].imagePath}" style="width: 114px;height: 175px;mix-blend-mode: overlay;">
                                    <div style="/*width: 72px;height: 175px;background-size: 158.3% 100%;*/position:absolute;z-index:-1;"></div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>

<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs " lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>

<script>
    // websocket
    layui.use(['table', 'layer','element'], function () {
        var table = layui.table
            , $ = layui.jquery
            , layer = layui.layer
            , element = layui.element;
        $(document).ready(function () {
            $("#li1").addClass("layui-this");
            // $("#d1").addClass("layui-this");
        });
        table.render({
            elem: '#demo'
            , width:'full-800'
            , height: 'full-700'
            , url: 'getWgAccessOpenDoor' //数据接口
            , page: false //开启分页
            , cols: [[ //表头
                {field: 'username', title: '姓名', width: '70',height:'30',align: 'center'}
                ,{field: 'isPass', title: '是否通过', width: '90',height:'30',align: 'center',templet: function(d){if(d.isPass==1){return "通过"}else{return "不通过"}}}
                , {field: 'direction', title: '方向', width: '30',height:'30',align: 'center',templet: function(d){if(d.direction==1){return "进"}else{return "出"}}}
                , {field: 'doorDateTime', title: '时间', width: '180',height:'30',align: 'center'}
            ]],


        });
        //实时动态三个按钮
        var button1=$('.button1');
        var button2=$('.button2');
        var button3=$('.button3');
        button1.on('click',function(){
            if(button1.hasClass('record')){//如果有‘test’的样式，就去除他的样式，添加‘active’的样式
                button1.removeClass('record').addClass('chinkRecord');
                if(button2.hasClass('chinkRecord')){
                    button2.removeClass('chinkRecord').addClass('record');
                }else if(button3.hasClass('chinkRecord')){
                    button3.removeClass('chinkRecord').addClass('record');
                }
            }
            layer.open({
                type: 2,
                title: '今日记录',
                area: ['1080px', '610px'],
                content: 'realTimeRecord?type=1'
                ,success: function(layero, index) {
                    layer.iframeAuto(index);
                }
            });
        });

        button2.on('click',function(){
            if(button2.hasClass('record')){//如果有‘test’的样式，就去除他的样式，添加‘active’的样式
                button2.removeClass('record').addClass('chinkRecord');
                if(button1.hasClass('chinkRecord')){
                    button1.removeClass('chinkRecord').addClass('record');
                }else if(button3.hasClass('chinkRecord')){
                    button3.removeClass('chinkRecord').addClass('record');
                }
            }
            layer.open({
                type: 2,
                title: '近7天记录',
                area: ['1080px', '610px'],
                content: 'realTimeRecord?type=2'
                ,success: function(layero, index) {
                    layer.iframeAuto(index);
                }
            });
        });

        button3.on('click',function(){
            if(button3.hasClass('record')){//如果有‘test’的样式，就去除他的样式，添加‘active’的样式
                button3.removeClass('record').addClass('chinkRecord');
                if(button1.hasClass('chinkRecord')){
                    button1.removeClass('chinkRecord').addClass('record');
                }else if(button2.hasClass('chinkRecord')){
                    button2.removeClass('chinkRecord').addClass('record');
                }
            }
            layer.open({
                type: 2,
                title: '近30天记录',
                area: ['1080px', '610px'],
                content: 'realTimeRecord?type=3'
                ,success: function(layero, index) {
                    layer.iframeAuto(index);
                }
            });
        });

        $(function () {
            console.log(window.location.hostname, window.location.port);
            WebSocketTest('recordWSL');
            WebSocketTest('WgAccessOpenDoor');
        });

        function WebSocketTest(wsPath) {
            if ("WebSocket" in window) {
                //alert("您的浏览器支持 WebSocket!");

                var hostName = window.location.hostname;
                var port = window.location.port;
                console.log("ws://" + hostName + ":" + port + "/" + wsPath)
                // 打开一个 web socket
                var ws = new WebSocket("ws://" + hostName + ":" + port + "/" + wsPath);
                ws.onopen = function () {
                    console.log('ws 已连接');
                };

                ws.onmessage = function (evt) {
                    var received_msg = evt.data;
                    // console.log(received_msg);

                    var data = JSON.parse(received_msg);

                    //table.reload('demo');

                    /*$.ajax({
                        url: 'getWgAccessOpenDoor',
                        type: "POST",
                        // data: {"iconCls": node.iconCls,"id":node.id},
                        dataType: "json",
                        success: function (res) {
                            $.each(res.data,function (index,item) {
                                console.log(index+item);
                            })
                            table.render({
                                elem: '#demo'
                                , width:'full-800'
                                , height: 'full-700'
                                , data: res.data
                                , page: false //开启分页
                                , cols: [[ //表头
                                    {field: 'username', title: '姓名', width: '70',height:'30',align: 'center'}
                                    ,{field: 'isPass', title: '是否通过', width: '90',height:'30',align: 'center',templet: function(d){if(d.isPass==1){return "通过"}else{return "不通过"}}}
                                    , {field: 'direction', title: '方向', width: '30',height:'30',align: 'center',templet: function(d){if(d.direction==1){return "进"}else{return "出"}}}
                                    , {field: 'doorDateTime', title: '时间', width: '180',height:'30',align: 'center'}
                                ]],

                            });
                        }
                    });

                    $.ajax({
                        type: "POST",
                        url: 'searchRealTimePicture',  //从数据库查询返回的是个list
                        dataType: "json",
                        success: function (data) {
                            var str="";
                            $.each(data,function (index,item) {
                                // console.log(index+item);
                                if(index==0){
                                    str+=' <div style="width: 122px;height: 184px;border-width: 1px;border-style: solid;border-color: #10bbf8;margin-left: 20px;float: left;">';

                                    str+='<div style="width: 114px;height: 175px; margin-left: 3px;margin-top: 3.5px;">';
                                    str+=' <img id="picture1" src='+item.imagePath+' style="width: 114px;height: 175px;">';
                                    str+=' </div>';
                                    str+=' </div>';
                                }
                                if(index==1){
                                    str+=' <div style="width: 122px;height: 184px;border-width: 1px;border-style: solid;border-color: #10bbf8;margin-left: 20px;float: left;">';
                                    str+=' <div style="width: 114px;height: 175px; margin-left: 3px;margin-top: 3.5px;">';
                                    str+=' <img id="picture2" src='+item.imagePath+' style="width: 114px;height: 175px;">';
                                    str+=' </div>';
                                    str+=' </div>';
                                }
                                if(index==2){
                                    str+=' <div style="width: 76px;height: 184px;border-width: 1px;border-style: solid;border-color: #10bbf8;margin-left: 20px;float: left;overflow:hidden;">';
                                    str+=' <div style="width: 72px;height: 175px; margin-left: 3px;margin-top: 3.5px;background: rgba(0,238,0,0) -webkit-linear-gradient(left, rgba(255,255,255,0),#070f24);">';

                                    str+=' <img id="picture3"  src='+item.imagePath+' style="width: 114px;height: 175px;mix-blend-mode: overlay;">';
                                    str+=' <div style="position:absolute;z-index:-1;"></div>';
                                    str+=' </div>';
                                    str+=' </div>';
                                }
                            })
                            // console.log(str);
                            $('#picture').html(str);
                        }
                    })

                };*/
                switch (wsPath) {

                    case 'WgAccessOpenDoor':
                        $.ajax({
                            url: 'getWgAccessOpenDoor',
                            type: "POST",
                            // data: {"iconCls": node.iconCls,"id":node.id},
                            dataType: "json",
                            success: function (res) {
                                $.each(res.data,function (index,item) {
                                    console.log(index+item);
                                })
                                table.render({
                                    elem: '#demo'
                                    , width:'full-800'
                                    , height: 'full-700'
                                    , data: res.data
                                    , page: false //开启分页
                                    , cols: [[ //表头
                                        {field: 'username', title: '姓名', width: '70',height:'30',align: 'center'}
                                        ,{field: 'isPass', title: '是否通过', width: '90',height:'30',align: 'center',templet: function(d){if(d.isPass==1){return "通过"}else{return "不通过"}}}
                                        , {field: 'direction', title: '方向', width: '30',height:'30',align: 'center',templet: function(d){if(d.direction==1){return "进"}else{return "出"}}}
                                        , {field: 'doorDateTime', title: '时间', width: '180',height:'30',align: 'center'}
                                    ]],

                                });
                            }
                        });
                        break;
                    case 'recordWSL':
                        $.ajax({
                            type: "POST",
                            url: 'searchRealTimePicture',  //从数据库查询返回的是个list
                            dataType: "json",
                            success: function (data) {
                                var str="";
                                $.each(data,function (index,item) {
                                    // console.log(index+item);
                                    if(index==0){
                                        str+=' <div style="width: 122px;height: 184px;border-width: 1px;border-style: solid;border-color: #10bbf8;margin-left: 20px;float: left;">';

                                        str+='<div style="width: 114px;height: 175px; margin-left: 3px;margin-top: 3.5px;">';
                                        str+=' <img id="picture1" src='+item.imagePath+' style="width: 114px;height: 175px;">';
                                        str+=' </div>';
                                        str+=' </div>';
                                    }
                                    if(index==1){
                                        str+=' <div style="width: 122px;height: 184px;border-width: 1px;border-style: solid;border-color: #10bbf8;margin-left: 20px;float: left;">';
                                        str+=' <div style="width: 114px;height: 175px; margin-left: 3px;margin-top: 3.5px;">';
                                        str+=' <img id="picture2" src='+item.imagePath+' style="width: 114px;height: 175px;">';
                                        str+=' </div>';
                                        str+=' </div>';
                                    }
                                    if(index==2){
                                        str+=' <div style="width: 76px;height: 184px;border-width: 1px;border-style: solid;border-color: #10bbf8;margin-left: 20px;float: left;overflow:hidden;">';
                                        str+=' <div style="width: 72px;height: 175px; margin-left: 3px;margin-top: 3.5px;background: rgba(0,238,0,0) -webkit-linear-gradient(left, rgba(255,255,255,0),#070f24);">';

                                        str+=' <img id="picture3"  src='+item.imagePath+' style="width: 114px;height: 175px;mix-blend-mode: overlay;">';
                                        str+=' <div style="position:absolute;z-index:-1;"></div>';
                                        str+=' </div>';
                                        str+=' </div>';
                                    }
                                })
                                // console.log(str);
                                $('#picture').html(str);
                            }
                        })
                        break;
                    default:
                        break;
                }
            };
                ws.onclose = function () {
                    // 关闭 websocket
                    console.log("连接已关闭...");
                };
            } else {
                // 浏览器不支持 WebSocket
                console.log("您的浏览器不支持 WebSocket!");
            }
        }
    })


    function load(){
        document.getElementById("demo").innerHTML;
    }


    function toggleFullScreen() {

        if (!document.fullscreenElement && !document.mozFullScreenElement && !document.webkitFullscreenElement) {
            console.log("1")


            $("#fullId").removeClass('fullScreen');
            $("#fullId").addClass('zoom')
            $('#information').css('transform','translate(120px, 0px) scale(1.1)');
            $('#header').css('display','none');
            $('#leftSide').css('display','none');

            $('#divBody').addClass('test')
            if (document.documentElement.requestFullscreen) {
                document.documentElement.requestFullscreen();
                console.log("1")
            } else if (document.documentElement.mozRequestFullScreen) {
                document.documentElement.mozRequestFullScreen();
                console.log("2")
            } else if (document.documentElement.webkitRequestFullscreen) {
                document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
                console.log("3")
            }
        }else {

            if (document.cancelFullScreen) {
                document.cancelFullScreen();
                console.log("4")
            } else if (document.mozCancelFullScreen) {
                document.mozCancelFullScreen();
                console.log("5")
            } else if (document.webkitCancelFullScreen) {
                document.webkitCancelFullScreen();
                console.log("6")
            }
            $("#fullId").removeClass('zoom');
            $("#fullId").addClass('fullScreen');
            $('#header').css('display','block');
            $('#leftSide').css('display','block');
            $("#divBody").removeClass('test');
            $('#information').css('transform','translate(0px, 0px) scale(1)');
        }
    }

    //当前时间
    $(function () {
        var t = null;
        t = setTimeout(time, 1);//開始运行
        function time() {
            clearTimeout(t);//清除定时器
            dt = new Date();
            var year = dt.getFullYear();
            var month = dt.getMonth() + 1;//(0-11,0代表1月)
            var date = dt.getDate();//获取天
            var num = dt.getDay();//获取星期
            var weekday = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
            var hour = dt.getHours();//获取时
            var minute = dt.getMinutes();//获取分
            var second = dt.getSeconds();//获取秒
            //分秒时间是一位数字，在数字前补0。
            date = extra(date);
            month = extra(month);
            minute = extra(minute);
            second = extra(second);
            var type;
            if(hour>12){
                type='PM';
            }else{
                type='AM';
            }
            document.getElementById("start").innerHTML = year + " . " + month + " . " + date + '\xa0\xa0' +type + " "+ hour + "：" + minute + "：" + second + " " + weekday[num];
            t = setTimeout(time, 1000); //设定定时器，循环运行
        }

    });
    //补位函数。
    function extra(x) {
        //如果传入数字小于10，数字前补一位0。
        if (x < 10) {
            return "0" + x;
        }
        else {
            return x;
        }
    }

    //空开
    var switchNum;
    var switchOnline;
    var dom1 = document.getElementById('chart1');//设备分布饼状图
    var Chart1 = echarts.init(dom1);
    // var dom2 = document.getElementById('chart2');//报警类型分布图
    // var Chart2 = echarts.init(dom2);
    var dom3 = document.getElementById('chart3');//报警处理情况图
    var Chart3 = echarts.init(dom3);

    //ajax请求后台数据
    $.ajax({
        type:"get",
        async:true,
        url:"switchDevBtn",
        success:function(data){
            // switchNum=data.switchNum;
            // switchOnline=data.switchOnline;
            // $("#switchDev").append(+switchOnline+"/"+switchNum);

            option = {
                series : [
                    {

                        type : 'pie',
                        center : ['50%', '50%'],//圆心坐标（div中的%比例）
                        radius : [60,70],//半径
                        x: '0%', // for funnel
                        startAngle : 90,
                        //hoverAnimation:false,
                        //legendHoverLink: true,
                        // animation: false,
                        hoverOffset: 1,
                        data : [{
                            name:'50%',
                            value:50,
                            label:{
                                fontSize:'14',
                                fontFamily:'ArialMT',
                                color:'#0c369a',
                            },
                            labelLine:{
                                lineStyle:{
                                    type:'solid',
                                    color:'#0c369a'
                                }
                            },
                            itemStyle : {//上层样式
                                color: {
                                    type: 'linear',
                                    x: 0,
                                    y: 0,
                                    x2: 0,
                                    y2: 1,
                                    colorStops: [{
                                        offset: 0, color: '#08a9ff' // 0% 处的颜色
                                    }, {
                                        offset: 1, color: '#0c369a' // 100% 处的颜色
                                    }],
                                    global: false // 缺省为 false
                                },

                            }},{
                            name:'',
                            value:100-(50*1), //底层样式
                            label : {
                                show : false,
                                position : 'center'
                            },
                            labelLine : {
                                show : false
                            },
                            itemStyle : {
                                color: 'rgba(12,54,154,0.11)',
                            }}
                        ]
                    },
                    {
                        type : 'pie',
                        center : ['50%', '50%'],//圆心坐标（div中的%比例）
                        radius : [45,55],//半径
                        startAngle : 90,
                        hoverOffset: 1,
                        data : [{
                            name:'25%',
                            value:25,
                            label:{
                                fontSize:'14',
                                fontFamily:'ArialMT',
                                color:'#fc822c',
                            },
                            labelLine:{
                                lineStyle:{
                                    type:'solid',
                                    color:'#fc822c'
                                }
                            },
                            itemStyle : {//上层样式
                                color: {
                                    type: 'linear',
                                    x: 0,
                                    y: 0,
                                    x2: 0,
                                    y2: 1,
                                    colorStops: [{
                                        offset: 0, color: '#fcb233' // 0% 处的颜色
                                    }, {
                                        offset: 1, color: '#fc822c' // 100% 处的颜色
                                    }],
                                    global: false // 缺省为 false
                                },

                            }},
                            {
                                name:'',
                                value:100-(25*1), //底层样式
                                label : {
                                    show : false,
                                    position : 'center'
                                },
                                labelLine : {
                                    show : false
                                },
                                itemStyle : {
                                    color: 'rgba(252,130,44,0.11)',
                                }}
                        ]
                    },
                    {
                        type : 'pie',
                        center : ['50%', '50%'],//圆心坐标（div中的%比例）
                        radius : [30,40],//半径
                        startAngle : 150,
                        hoverOffset: 1,
                        data : [{
                            name:'10%',
                            value:10,
                            label:{
                                fontSize:'14',
                                fontFamily:'ArialMT',
                                color:'#13b27b',
                            },
                            labelLine:{
                                length2:40,
                                lineStyle:{
                                    type:'solid',
                                    color:'#13b27b'
                                }
                            },
                            itemStyle : {//上层样式
                                color: {
                                    //type: 'linear',
                                    x: 0,
                                    y: 0,
                                    x2: 0,
                                    y2: 1,
                                    colorStops: [{
                                        offset: 0, color: '#13d79d' // 0% 处的颜色
                                    }, {
                                        offset: 1, color: '#13b27b' // 100% 处的颜色
                                    }],
                                    global: false // 缺省为 false
                                },

                            }},
                            {
                                name:'',
                                value:100-(50*1), //底层样式
                                label : {
                                    show : false,
                                    position : 'center'
                                },
                                labelLine : {
                                    show : false
                                },
                                itemStyle : {
                                    color: 'rgba(19,178,123,0.1)',
                                }}
                        ]
                    },
                    {
                        type : 'pie',
                        center : ['50%', '50%'],//圆心坐标（div中的%比例）
                        radius : [15,25],//半径
                        startAngle : 0,
                        hoverOffset: 1,
                        data : [{
                            name:'15%',
                            value:15,
                            label:{
                                fontSize:'14',
                                fontFamily:'ArialMT',
                                color:'#069ce8',
                            },
                            labelLine:{
                                length2:50,
                                lineStyle:{
                                    type:'solid',
                                    color:'#069ce8'
                                }
                            },
                            itemStyle : {//上层样式
                                color: {
                                    type: 'linear',
                                    x: 0,
                                    y: 0,
                                    x2: 0,
                                    y2: 1,
                                    colorStops: [{
                                        offset: 0, color: '#07d1e8' // 0% 处的颜色
                                    }, {
                                        offset: 1, color: '#069ce8' // 100% 处的颜色
                                    }],
                                    global: false // 缺省为 false
                                },

                            }},
                            {
                                name:'',
                                value:100-(50*1), //底层样式
                                label : {
                                    show : false,
                                    position : 'center'
                                },
                                labelLine : {
                                    show : false
                                },
                                itemStyle : {
                                    color: 'rgba(6,156,232,0.11)',
                                }}
                        ]
                    }
                ]

            };

            Chart1.setOption(option);
        }
    });
    //空调
    $.ajax({
        type:"get",
        async:true,
        //url:"showTest",
        success:function(data){
            $("#Dev").val(data.aironlinenum);
            option = {
                backgroundColor: '#2F4056',

                title: {
                    text: '报警类型分布',
                    left: 'center',
                    top: 20,
                    textStyle: {
                        color: '#ccc'
                    }
                },

                tooltip: {
                    trigger: 'item',
                    formatter: '{a} <br/>{b} : {c} ({d}%)'
                },
                visualMap: {
                    show: false,
                    min: 80,
                    max: 600,
                    inRange: {
                        colorLightness: [0, 1]
                    }
                },
                series: [
                    {
                        name: '报警来源',
                        type: 'pie',
                        radius: '55%',
                        center: ['50%', '50%'],
                        data: [
                            {value: 335, name: '电源'},
                            {value: 310, name: '硬件'},
                            {value: 274, name: '电路'},
                            {value: 235, name: '信号'},
                        ].sort(function (a, b) { return a.value - b.value; }),
                        roseType: 'radius',
                        label: {
                            color: 'rgba(255, 255, 255, 0.8)'
                        },
                        labelLine: {
                            lineStyle: {
                                color: 'rgba(255, 255, 255, 0.3)'
                            },
                            smooth: 0.2,
                            length: 10,
                            length2: 20
                        },
                        itemStyle: {
                            color: '#c23531',
                            shadowBlur: 200,
                            shadowColor: 'rgba(0, 0, 0, 0.5)'
                        },

                        animationType: 'scale',
                        animationEasing: 'elasticOut',
                        animationDelay: function (idx) {
                            return Math.random() * 200;
                        }
                    }
                ]
            };
            // Chart2.setOption(option);
        }
    });
    //柱形图
    $.ajax({
        type:"get",
        async:true,
        //url:"showTest",
        success:function(data){


            //$("#Dev").val(data.aironlinenum);
            var url1='image://../../res/layui/images/homePage/AlarmHandlingSituation_Blue.png';
            var url2='image://../../res/layui/images/homePage/AlarmHandlingSituation_Orange.png';
            var url3='image://../../res/layui/images/homePage/AlarmHandlingSituation_Green.png';
            option = {
                grid: {
                    top: '8%',
                    bottom: '15%'
                },
                xAxis: {
                    type: 'category',
                    axisTick: {show: false},
                            axisLine: {show: false},
                            axisLabel: {show: false}
                },
                yAxis: {
                    type: 'value',
                    show:true,
                    splitLine: {show: false},
                    axisLine:{                  //---坐标轴 轴线
                        show:false,                  //---是否显示
                        lineStyle:{
                            color:'#10bbf8',
                            width:1,
                            type:'MicrosoftYaHei',
                        },
                    },
                    axisTick:{                  //---坐标轴 刻度
                        show:false,                  //---是否显示
                    },

                },
                series: [{
                    name: '报警总数',
                    type: 'pictorialBar',
                    barWidth:'25px',
                    barCategoryGap:'20%',

                    label: {
                        show: true,
                        position: 'top',
                        color:'#10bbf8'
                    },
                    data: [{
                        value:5,
                        symbol: url1,
                    }, {
                        value:3,
                        symbol: url2
                    }, {
                        value:2,
                        symbol: url3
                    }]

                }]
            }

            Chart3.setOption(option);
        }
    });

</script>
<script type="text/javascript">

    layui.use('element', function(){
        var element = layui.element;
    });
    //设备类型饼状图
</script>

<%--地图--%>
<script type="text/javascript">
    var map = new BMap.Map("container");
    var point = new BMap.Point(113.865004,22.589183);//创建点坐标，不一定是点坐标，要看设置
    var opts = {
//                anchor: BMAP_ANCHOR_TOP_LEFT,
//                offset: new BMap.Size(150,5)
    }
    var marker = new BMap.Marker(point);//创建标注

    var styleJson = [
        {
            "featureType": "land",
            "elementType": "geometry",
            "stylers": {
                "visibility": "on",
                "color": "#091220ff"
            }
        }, {
            "featureType": "water",
            "elementType": "geometry",
            "stylers": {
                "visibility": "on",
                "color": "#113549ff"
            }
        }, {
            "featureType": "green",
            "elementType": "geometry",
            "stylers": {
                "visibility": "on",
                "color": "#0e1b30ff"
            }
        }, {
            "featureType": "building",
            "elementType": "geometry",
            "stylers": {
                "visibility": "on"
            }
        }, {
            "featureType": "building",
            "elementType": "geometry.fill",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "building",
            "elementType": "geometry.stroke",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "subwaystation",
            "elementType": "geometry",
            "stylers": {
                "visibility": "on",
                "color": "#b15454B2"
            }
        }, {
            "featureType": "education",
            "elementType": "geometry",
            "stylers": {
                "visibility": "on",
                "color": "#1e7691"
            }
        }, {
            "featureType": "medical",
            "elementType": "geometry",
            "stylers": {
                "visibility": "on",
                "color": "#12223dff"
            }
        }, {
            "featureType": "scenicspots",
            "elementType": "geometry",
            "stylers": {
                "visibility": "on",
                "color": "#12223dff"
            }
        },/* {
            "featureType": "highway",
            "elementType": "geometry",
            "stylers": {
                "visibility": "on",
                "weight": 4
            }
        }, {
            "featureType": "highway",
            "elementType": "geometry.fill",
            "stylers": {
                "color": "#f7c54dff"
            }
        }, {
            "featureType": "highway",
            "elementType": "geometry.stroke",
            "stylers": {
                "color": "#fed669ff"
            }
        }, {
            "featureType": "highway",
            "elementType": "labels",
            "stylers": {
                "visibility": "on"
            }
        }, {
            "featureType": "highway",
            "elementType": "labels.text.fill",
            "stylers": {
                "color": "#8f5a33ff"
            }
        }, {
            "featureType": "highway",
            "elementType": "labels.text.stroke",
            "stylers": {
                "color": "#ffffffff"
            }
        }, {
            "featureType": "highway",
            "elementType": "labels.icon",
            "stylers": {
                "visibility": "on"
            }
        },*/ {
            "featureType": "arterial",
            "elementType": "geometry",
            "stylers": {
                "visibility": "on",
                "weight": 2
            }
        }, {
            "featureType": "arterial",
            "elementType": "geometry.fill",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "arterial",
            "elementType": "geometry.stroke",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "arterial",
            "elementType": "labels",
            "stylers": {
                "visibility": "on"
            }
        }, {
            "featureType": "arterial",
            "elementType": "labels.text.fill",
            "stylers": {
                "color": "#525355ff"
            }
        }, {
            "featureType": "arterial",
            "elementType": "labels.text.stroke",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "local",
            "elementType": "geometry",
            "stylers": {
                "visibility": "on",
                "weight": 1
            }
        }, {
            "featureType": "local",
            "elementType": "geometry.fill",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "local",
            "elementType": "geometry.stroke",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "local",
            "elementType": "labels",
            "stylers": {
                "visibility": "on"
            }
        }, {
            "featureType": "local",
            "elementType": "labels.text.fill",
            "stylers": {
                "color": "#979c9aff"
            }
        }, {
            "featureType": "local",
            "elementType": "labels.text.stroke",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "railway",
            "elementType": "geometry",
            "stylers": {
                "visibility": "on",
                "weight": 1
            }
        }, {
            "featureType": "railway",
            "elementType": "geometry.fill",
            "stylers": {
                "color": "#123c52ff"
            }
        }, {
            "featureType": "railway",
            "elementType": "geometry.stroke",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "subway",
            "elementType": "geometry",
            "stylers": {
                "visibility": "on",
                "weight": 1
            }
        }, {
            "featureType": "subway",
            "elementType": "geometry.fill",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "subway",
            "elementType": "geometry.stroke",
            "stylers": {
                "color": "#ffffff00"
            }
        }, {
            "featureType": "subway",
            "elementType": "labels",
            "stylers": {
                "visibility": "on"
            }
        }, {
            "featureType": "subway",
            "elementType": "labels.text.fill",
            "stylers": {
                "color": "#979c9aff"
            }
        }, {
            "featureType": "subway",
            "elementType": "labels.text.stroke",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "continent",
            "elementType": "labels",
            "stylers": {
                "visibility": "on"
            }
        }, {
            "featureType": "continent",
            "elementType": "labels.icon",
            "stylers": {
                "visibility": "on"
            }
        }, {
            "featureType": "continent",
            "elementType": "labels.text.fill",
            "stylers": {
                "color": "#333333ff"
            }
        }, {
            "featureType": "continent",
            "elementType": "labels.text.stroke",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "city",
            "elementType": "labels.icon",
            "stylers": {
                "visibility": "off"
            }
        }, {
            "featureType": "city",
            "elementType": "labels",
            "stylers": {
                "visibility": "on"
            }
        }, {
            "featureType": "city",
            "elementType": "labels.text.fill",
            "stylers": {
                "color": "#205a91ff"
            }
        }, {
            "featureType": "city",
            "elementType": "labels.text.stroke",
            "stylers": {
                "color": "#0d1550ff"
            }
        }, {
            "featureType": "town",
            "elementType": "labels.icon",
            "stylers": {
                "visibility": "on"
            }
        }, {
            "featureType": "town",
            "elementType": "labels",
            "stylers": {
                "visibility": "on"
            }
        }, {
            "featureType": "town",
            "elementType": "labels.text.fill",
            "stylers": {
                "color": "#454d50ff"
            }
        }, {
            "featureType": "town",
            "elementType": "labels.text.stroke",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "road",
            "elementType": "geometry.fill",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "poilabel",
            "elementType": "labels",
            "stylers": {
                "visibility": "on"
            }
        }, {
            "featureType": "districtlabel",
            "elementType": "labels",
            "stylers": {
                "visibility": "off"
            }
        }, {
            "featureType": "road",
            "elementType": "geometry",
            "stylers": {
                "visibility": "on"
            }
        }, {
            "featureType": "road",
            "elementType": "labels.icon",
            "stylers": {
                "visibility": "off"
            }
        },  {
            "featureType": "road",
            "elementType": "labels",
            "stylers": {
                "visibility": "off"
            }
        },{
            "featureType": "road",
            "elementType": "geometry.stroke",
            "stylers": {
                "color": "#ffffff00"
            }
        }, {
            "featureType": "district",
            "elementType": "labels",
            "stylers": {
                "visibility": "off"
            }
        }, {
            "featureType": "poilabel",
            "elementType": "labels.icon",
            "stylers": {
                "visibility": "off"
            }
        }, {
            "featureType": "poilabel",
            "elementType": "labels.text.fill",
            "stylers": {
                "color": "#2dc4bbff"
            }
        }, {
            "featureType": "poilabel",
            "elementType": "labels.text.stroke",
            "stylers": {
                "color": "#ffffff00"
            }
        }, {
            "featureType": "manmade",
            "elementType": "geometry",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "districtlabel",
            "elementType": "labels.text.stroke",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "entertainment",
            "elementType": "geometry",
            "stylers": {
                "color": "#12223dff"
            }
        }, {
            "featureType": "shopping",
            "elementType": "geometry",
            "stylers": {
                "color": "#12223dff"
            }
        }
    ];


    // function createLable(map, point, content) {
    //     var opts = {
    //         position: point,
    //         offset: new BMap.Size(-5, 10)
    //     }
    //     var label = new BMap.Label(content, opts);
    //     label.setStyle({
    //         color: "#000",
    //         border: "0px",
    //         backgroundColor: "0.000000000001", //通过这个方法，去掉背景色
    //         fontSize: "12px",
    //         height: "20px",
    //         lineHeight: "20px"
    //     });
    //
    //     return label;
    // }
    // map.addOverlay(label);

    // label.setStyle({
    //     backgroundColor: rgba(243, 241, 236, 0),
    // });
    // map.addOverlay(label);
    map.addOverlay(marker);//方法addOverlay() 向地图中添加覆盖物
    map.centerAndZoom(point,13);//设置中心点（确定中心点坐标）
    //map.setCurrentCity("北京");//在设置好地图中心点的前提下显示背景的整体图
    map.enableScrollWheelZoom(true);//在PC端可以通过滚轮放大缩小地图，移动端关闭该功能
    //map.addControl(new BMap.NavigationControl(opts));//addControl()向地图添加控件 平移和缩放控件 PC端默认左上角 移动端默认右下角且只有缩放功能
    map.addControl(new BMap.ScaleControl(opts));//比例尺控件 默认左下角
    //map.addControl(new BMap.OverviewMapControl(opts));//缩略图控件 默认右下角且呈可折叠状态（点击隐藏和显示）
    //map.addControl(new BMap.MapTypeControl());//地图类型控件 默认右上角可切换地图/卫星/三维三种状态
    //map.addControl(new BMap.GeolocationControl(opts));//定位控件 默认左下角

    var mapStyle={
        features: ["road", "building","water","land","highway"],//隐藏地图上的poi
        style : "dark"
    }
    //map.setMapStyle(mapStyle);


    //单击获取点击的经纬度
    map.addEventListener("click",function(e){
        var strPoint = e.point.lng + "," + e.point.lat;
        qtui.recieveJsMessage("addPoint,"+strPoint);
    });
    map.setMapStyleV2({styleJson:styleJson});
    var i=0;
    var mapPoints = [
        {x:22.589183,y:113.865004,title:"公司",con:"您好，这里是深圳立为信息科技有限公司。",branch:"深圳立为"},
        /*{x:30.18508,y:120.193172,title:"家",con:"您好，这里是长江小区。",branch:"长江小区"},
        {x:30.18015,y:120.174968,title:"洛杉矶",con:"我是詹姆斯",branch:"湖人总冠军"},*/
    ];
    // 函数 创建多个标注
    function markerFun (points,label,infoWindows) {
        var markers = new BMap.Marker(points);
        map.addOverlay(markers);
        markers.setLabel(label);
        markers.addEventListener("click",function (event) {
            console.log("0001");
            map.openInfoWindow(infoWindows,points);//参数：窗口、点  根据点击的点出现对应的窗口
        });
    }
    for (;i<mapPoints.length;i++) {
        var points = new BMap.Point(mapPoints[i].y,mapPoints[i].x);//创建坐标点
        var opts = {
            width:250,
            height: 100,
            title:mapPoints[i].title,
            //backgroundColor: rgba(243, 241, 236, 0),
        };
        var label = new BMap.Label(mapPoints[i].branch,{
            offset:new BMap.Size(25,5),

        });
        var infoWindows = new BMap.InfoWindow(mapPoints[i].con,opts,{

        });
        label.setStyle({
            color : "#808080",
            borderColor: "#808080",
            backgroundColor:"#12223dff",
            fontSize : "12px",
            height : "20px",
            /*lineHeight : "20px",*/
            fontFamily:"微软雅黑",
            maxWidth:"none"
        });
        markerFun(points,label,infoWindows);
    }

</script>

<%--实时数据--%>
<script>

    $(function(){
        //$("#light").text(stopData);
        $("#light").append(sessionStorage.getItem('now'));
        $("#up").append(sessionStorage.getItem('pass'));
        //$("#zero").append(sessionStorage.getItem('zero'));
        $('#lightUp').addClass('layui-hide');
        $('#lightDown').addClass('layui-hide');
        WebSocketTest('realEnergyConsumption');
    });
    function WebSocketTest(wsPath) {
        if("WebSocket" in window){
            var hostName=window.location.hostname;
            var port =window.location.port;

            //打开一个web socket
            var ws=new WebSocket("ws://"+hostName+":"+port+"/"+wsPath);
            console.log("ws://"+hostName+":"+port+"/"+wsPath);
            ws.onopen=function () {
                console.log('ws 已连接');
            };
            //$('[data-field="id"]').addClass('layui-hide');
            ws.onmessage=function (newData) {
                var getData=newData.data;
                var data=JSON.parse(getData);
                console.log(data.switchInfo);
                if(data.passAndNow>=0){
                    /*$("#zero").text("增长");
                    sessionStorage.setItem('zero','增长');*/
                    $("#up").css('color',' #10bbf8');
                    $("#percent").css('color',' #10bbf8');
                    $('#lightUp').removeClass('layui-hide');
                    $('#lightDown').addClass('layui-hide');
                    $("#up").text(data.passAndNow);
                    sessionStorage.setItem('pass',data.passAndNow);
                }else if(data.passAndNow<0){
                    //$("#zero").text("下降");
                    $("#up").css('color',' #ff6f03');
                    $("#percent").css('color',' #ff6f03');
                    $('#lightDown').removeClass('layui-hide');
                    $('#lightUp').addClass('layui-hide');
                    sessionStorage.setItem('zero','下降');
                    $("#up").text(data.passAndNow*(-1));
                    sessionStorage.setItem('pass',data.passAndNow*(-1));
                }else {
                    $("#zero").text("");
                    sessionStorage.setItem('zero','');
                    $("#up").text(data.passAndNow);
                    sessionStorage.setItem('pass',data.passAndNow);
                }
                $("#light").text(data.light);
                sessionStorage.setItem('now',data.light);
                console.log("111   "+sessionStorage.getItem('now'));
                console.log("111   "+sessionStorage.getItem('pass'));
            };

            ws.onclose=function () {
                //$("#light").text(stopData);
                console.log("连接已关闭！")
            }
        }else{
            console.log("浏览器不支持 WebSocket！")
        }
    }
</script>
<%--<%--%>
<%--    Double data= %>"<script>value</script>"<% ; %>--%>
<%--<c:out value="${data}"></c:out>--%>
<%--<script type="text/javascript">--%>
<%--    /*--%>
<%--     * 移动得距离就为点击位置坐标（clientX） - 移动后的位置坐标（clientX），那么现在盒子总共的宽度就是其本身宽度（oBox.offsetWidth）加上前面坐标之差。向左拉伸原理差不多，就是多加个改变盒子的位置,盒子的offsetLeft等于光标移动后的位置坐标。我们对盒子就行绝对定位，获取它的left值，将它left值减去改变的距离，他就会向左边拉伸了。上下同理--%>
<%--     */--%>

<%--    var oBox = document.getElementById('left');--%>
<%--    oBox.onmousedown = function(e){--%>
<%--        console.log("----------------------------------------------------------------")--%>
<%--        e = e ||event;--%>
<%--        var x = e.clientX;--%>
<%--        var y = e.clientY;--%>
<%--        var oBoxL = oBox.offsetLeft;--%>
<%--        var oBoxT = oBox.offsetTop;--%>
<%--        var oBoxW = oBox.offsetWidth;--%>
<%--        var oBoxH = oBox.offsetHeight;--%>

<%--        var d = 0;--%>
<%--        if(x < oBoxL + 10){--%>
<%--            d = 'left';--%>
<%--        }--%>
<%--        else if(x > oBoxL + oBoxW -10){--%>
<%--            d = 'right';--%>
<%--        }--%>

<%--        if(y < oBoxT + 10){--%>
<%--            d = 'top';--%>
<%--        }--%>
<%--        else if(d < oBoxT + oBoxH -10){--%>
<%--            d = 'bottom';--%>
<%--        }--%>
<%--        if(x < oBoxL + 10 && y < oBoxT + 10){--%>
<%--            d ='LT';--%>
<%--        }--%>
<%--        document.onmousemove = function(e){--%>
<%--            e = e ||event;--%>
<%--            var xx = e.clientX;--%>
<%--            var yy = e.clientY;--%>
<%--            if(d == 'left'){--%>
<%--                oBox.style.width = oBoxW + x -xx + 'px'--%>
<%--                oBox.style.left = xx  + 'px';--%>
<%--            }--%>
<%--            else if(d == 'right'){--%>
<%--                oBox.style.width = oBoxW + xx -x + 'px'--%>
<%--            }--%>

<%--            if(d == 'top'){--%>
<%--                oBox.style.height = oBoxH + y - yy + 'px';--%>
<%--                oBox.style.top = yy + 'px';--%>
<%--            }--%>
<%--            else if(d == 'bottom'){--%>
<%--                oBox.style.height = oBoxH + yy - y + 'px';--%>
<%--            }--%>
<%--            if(d == 'LT'){--%>
<%--                oBox.style.width = oBoxW + x -xx + 'px'--%>
<%--                oBox.style.left = xx  + 'px';--%>
<%--                oBox.style.height = oBoxH + y - yy + 'px';--%>
<%--                oBox.style.top = yy + 'px';--%>
<%--            }--%>
<%--            return false;--%>
<%--        }--%>
<%--        document.onmouseup = function(){--%>
<%--            document.onmousemove = null;--%>
<%--            document.onmouseup = null;--%>
<%--        }--%>
<%--        if(e.preventDefault){--%>
<%--            e.preventDefault();--%>
<%--        }--%>
<%--    }--%>
<%--</script>--%>

</html>
