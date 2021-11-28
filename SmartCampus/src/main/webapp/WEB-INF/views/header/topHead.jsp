<%@ page import="com.zy.SmartCampus.polo.UserInfo" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    HttpSession session1 = request.getSession();
    UserInfo userInfo = (UserInfo) session1.getAttribute("userinfo");
%>
<style>
    .layui-table-box ::-webkit-scrollbar {width: 0px; height: 0px;}
    .layui-nav .layui-nav-mored,.layui-nav-itemed>a .layui-nav-more
    .layui-nav .layui-nav-more
    .layui-layout-admin .layui-side{
        top: 64px;
    }
    .layui-layout-admin .layui-header {
        background-color: #102038;
    }
    .layui-layout-admin .layui-logo {
        font-family: FZZZHONGJW--GB1-0;
        font-size: 16px;
        color: #d3ebff;
        float: left;
    }
    .layui-nav .layui-nav-item a {
        font-family: Microsoft Ya Hei;
        font-size: 18px;
        color: rgba(211,235,255,0.5);

        padding-left: 20px;
        padding-right: 20px;
        /* background-color: #102038;*/
        /*float: left;*/
    }
    .layui-nav .layui-nav-child a:hover{
        background-color: #102038;
    }
    .layui-nav .layui-nav-item a:hover{
        font-family: Microsoft Ya Hei;
        font-size: 18px;
        color: #d3ebff;
        /*background-color: #102038;*/
        /*float: left;*/
    }
    .layui-nav-child {
        display: none;
        position: absolute;
        left: 0;
        top: 65px;
        min-width: 100%;
        line-height: 36px;
        padding: 5px 0;
        box-shadow: 0 2px 4px rgba(0,0,0,.12);
        border: 1px solid #102038;
        background-color: #102038;
        z-index: 100;
        border-radius: 2px;
        white-space: nowrap;
    }
    .layui-nav {
        background-color: #13233c;
    }
    .layui-bg-black {
        background-color: #13233c;
    }
    .layui-nav-tree .layui-nav-item a:hover {
        background-color: #13233c;
    }
    .layui-nav-tree .layui-nav-child dd.layui-this,
    .layui-nav-tree .layui-nav-child dd.layui-this a,
    .layui-nav-tree .layui-this,
    .layui-nav-tree .layui-this>a,
    .layui-nav-tree .layui-this>a:hover{
        background-color: #1666f9;
        width: 190px;
        border-top-right-radius: 20px;
        border-bottom-right-radius: 20px;
    }
    .layui-nav-tree .layui-nav-bar {
        background-color: #1666f9;
    }
    .layui-nav .layui-this:after, .layui-nav-bar, .layui-nav-tree .layui-nav-itemed:after {
        background-color: #1666f9;
    }
    .layui-nav-child dd{
        background-color: #13233c;
    }
    /*右侧子菜单选中后的背景色*/
    .layui-nav-itemed>.layui-nav-child{
        background-color: #13233c;
    }
    /*.layui-nav-tree .layui-nav-child, .layui-nav-tree .layui-nav-child a:hover {*/

    /*}*/
    .layui-side-scroll .layui-nav .layui-nav-item a {
        font-family: Microsoft Ya Hei;
        font-size: 16px;
        color: rgba(211,235,255,0.5);
        background-color: #13233c;
        padding-left: 30px;
    }
    .layui-side-scroll .layui-nav .layui-nav-item a:hover {
        font-family: Microsoft Ya Hei;
        font-size: 16px;
        color: #d3ebff;

        /*float: left;*/
    }
    .a1{
        background : url(" ../../res/layui/images/homePageNotClicked/TopHomePageNotClicked.png") no-repeat 0 center;
    }
    .a1:hover{
        background : url(" ../../res/layui/images/homePageCliked/TopHomePageClicked.png") no-repeat 0 center;
    }
    .a2{
        background : url(" ../../res/layui/images/homePageNotClicked/TopSystemManagerNotClicked.png") no-repeat 0 center;
    }
    .a2:hover{
        background : url(" ../../res/layui/images/homePageCliked/TopSystemManagerClicked.png") no-repeat 0 center;
    }
    .a3{
        background : url(" ../../res/layui/images/homePageNotClicked/TopDevManagerNotClicked.png") no-repeat 0 center;
    }
    .a3:hover{
        background : url(" ../../res/layui/images/homePageCliked/TopDevManagerClicked.png") no-repeat 0 center;
    }
    .a4{
        background : url(" ../../res/layui/images/homePageNotClicked/TopPersonManagerNotClicked.png") no-repeat 0 center;
    }
    .a4:hover{
        background : url(" ../../res/layui/images/homePageCliked/TopPersonManagerClicked.png") no-repeat 0 center;
    }
    .a5{
        background : url(" ../../res/layui/images/homePageNotClicked/TopFaultManagerNotClicked.png") no-repeat 0 center;
    }
    .a5:hover{
        background : url(" ../../res/layui/images/homePageCliked/TopFaultManagerClicked.png") no-repeat 0 center;
    }
    .a6{
        background : url(" ../../res/layui/images/homePageNotClicked/TopSpatialManagerNotClicked.png") no-repeat 0 center;
    }
    .a6:hover{
        background : url(" ../../res/layui/images/homePageCliked/TopSpatialManagerClicked.png") no-repeat 0 center;
    }
    .b1{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarVideoMonitorNotClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b1:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarVideoMonitorClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b2{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarRealTimePreviewNotClicked.png") no-repeat 30px center;

    }
    .b2:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarRealTimePreviewClicked.png") no-repeat 30px center;

    }
    .b3{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarVideoPlaybackNotClicked.png") no-repeat 30px center;

    }
    .b3:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarVideoPlaybackClicked.png") no-repeat 30px center;

    }
    .b4{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarBatchSetupNotClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b4:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarBatchSetupClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b5{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarDevMaintenanceNotClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b5:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarDevMaintenanceClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b6{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarDevStatusNotClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b6:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarDevStatusClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b7{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarEnergyCountNotClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b7:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarEnergyCountClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b8{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarElectricalSafetyNotClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b8:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarElectricalSafetyClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b9{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarUseTimeNotClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b9:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarUseTimeClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b10{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarFaceEntranceControlNotClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b10:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarFaceEntranceControlClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b11{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarRealTimeMonitoringNotClicked.png") no-repeat 30px center;
    }
    .b11:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarRealTimeMonitoringClicked.png") no-repeat 30px center;
    }
    .b12{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarHistoricalInformationNotClicked.png") no-repeat 30px center;
    }
    .b12:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarHistoricalInformationClicked.png") no-repeat 30px center;
    }
    .b13{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarElectricityConsumptionNotClicked.png") no-repeat 30px center;
    }
    .b13:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarElectricityConsumptionClicked.png") no-repeat 30px center;
    }
    .b14{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarOrdinaryEntranceControlNotClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b14:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarOrdinaryEntranceControlClicked.png") no-repeat 0 center;
        margin-left: 10px;
    }
    .b15{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarElectricalSafetyNotClicked.png") no-repeat 30px center;

    }
    .b15:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarElectricalSafetyClicked.png") no-repeat 30px center;

    }
    .b16{
        background : url(" ../../res/layui/images/homePageNotClicked/SidebarUseTimeNotClicked.png") no-repeat 30px center;

    }
    .b16:hover{
        background : url(" ../../res/layui/images/homePageCliked/SidebarUseTimeClicked.png") no-repeat 30px center;

    }
    .bn{
        margin-left: 10px;
    }
    .li{
        margin-left: 30px;
    }
    .layui-header .layui-nav .layui-nav-more{
        background : url('../../res/layui/images/homePageNotClicked/TopExpand.png') no-repeat center center;
        content:'';
        width:20px;
        height:20px;
        border-color:#fff transparent transparent;
        overflow:hidden;
        cursor:pointer;
        transition:all .2s;
        -webkit-transition:all .2s;
        position:absolute;
        top:50%;
        right:3px;
        margin-top:-9px;
        border-width:6px;
        border-top-color:rgba(255,255,255,.7);
        margin-left: 14px;
    }
    .layui-header .layui-nav .layui-nav-item a{
        padding-left: 30px;

    }
    /*layui滚动条样式*/
    .layui-side-scroll ::-webkit-scrollbar {width: 0px; height: 0px;}
    /*::-webkit-scrollbar-button:vertical{display: none;}*/
    /*::-webkit-scrollbar-track, ::-webkit-scrollbar-corner{background-color: #e2e2e2;}*/
    /*::-webkit-scrollbar-thumb{border-radius: 0; background-color: rgba(0,0,0,.3);}*/
    /*::-webkit-scrollbar-thumb:vertical:hover{background-color: rgba(0,0,0,.35);}*/
    /*::-webkit-scrollbar-thumb:vertical:active{background-color: rgba(0,0,0,.38);}*/
</style>

<div class="layui-header" style="height: 64px;" id="header">
    <div class="layui-logo">智慧校园信息管理系统</div>
    <div class="face1" style="z-index:9999; position:relative;">
        <ul class="layui-nav layui-layout-left">

            <li class="layui-nav-item li" id="li1" ><a href="/mainPage" class="a1">首页</a></li>
            <li class="layui-nav-item li"><a href="javascript:;" class="a2">系统管理</a></li>
            <%--        <li class="layui-nav-item li"><a href="">视频大屏</a></li>--%>
            <li  class="layui-nav-item li" id="li4" style=""><a href="javascript:;" class="a3" style="padding-right: 34px;">设备管理</a>
                <dl class="layui-nav-child" style="background-color: #102038;"> <!-- 二级菜单 -->
                    <iframe cals="newiframe" src="" style="position: absolute; left: 0; top: 0; z-index:-1; width: 100%; height: 100%; background-color: transparent; opacity:0; " frameborder="0"></iframe>
                    <dd><a href="/loraView">Lora网关</a></dd>
                    <dd><a href="/switchDevManager">空开设备</a></dd>
                    <dd><a href="/devAir">空调设备</a></dd>
                    <dd><a href="/videoManager">监控设备</a></dd>
                    <dd><a href="/wgAccessDev">普通门禁</a></dd>
                    <dd><a href="goMachine">人脸门禁</a></dd>
                    <dd><a href="goNoiseDev">噪声传感器</a></dd>
                    <dd><a href="goZigBeeGateway">ZigBee网关</a></dd>
                </dl>
            </li>
            <li id="li5" class="layui-nav-item li"><a href="javascript:;" class="a4" style="padding-right: 34px;">人员管理</a>
                <dl class="layui-nav-child"> <!-- 二级菜单 -->
                    <%--                <dd><a href="/switchDevManager">人员管理</a></dd>--%>
                    <iframe cals="newiframe" src="" style="position: absolute; left: 0; top: 0; z-index:-1; width: 100%; height: 100%; background-color: transparent; opacity:0; " frameborder="0"></iframe>
                    <dd><a href="goStaff">人员信息</a></dd>
                    <dd><a href="goManageCard">人脸门禁权限管理</a></dd>
                    <dd><a href="wgAccessDevPromise">普通门禁权限管理</a></dd>
                </dl>
            </li>
            <li class="layui-nav-item li"><a href="javascript:;" class="a5">故障管理</a></li>
            <li class="layui-nav-item li"><a href="/organizeM" class="a6">空间管理</a></li>
            <li class="layui-nav-item" <%--onmouseover="iframeVisibleSys();" onmouseout="iframeInvisibleSys()"--%>><a href="javascript:;" style="padding-right: 34px;">系统配置</a>
                <dl class="layui-nav-child"> <!-- 二级菜单 -->
                    <iframe cals="newiframe" src="" style="position: absolute; left: 0; top: 0; z-index:-1; width: 100%; height: 100%; background-color: transparent; opacity:0; " frameborder="0"></iframe>
                    <dd><a href="/userManage">用户管理</a></dd>
                    <dd><a href="/permissionManage">权限设置</a></dd>
                </dl>
            </li>
        </ul>

        <!-- 头部区域（可配合layui已有的水平导航） -->
        <ul class="layui-nav layui-layout-left layui-hide">
            <li class="layui-nav-item"><a href="/userManager">人员管理</a></li>
            <li class="layui-nav-item"><a href="javascript:;">使用情况</a></li>
            <li class="layui-nav-item"><a href="javascript:;">设备管理</a></li>
        </ul>


        <ul class="layui-nav layui-layout-right">


            <li class="layui-nav-item" style="  width: 100px;margin-right: 10px;" <%--onmouseover="iframeVisible();" onmouseout="iframeInvisible()"--%>>
                <div style="width: 25px;height: 25px;border-radius: 15px ;background-color: #FFFFFF;float: left;    margin-top: 20px;"></div>
                <a href="javascript:;" style="font-size: 12px;width: 70px;padding-left: 10px;  margin-left: 25px;"><%=userInfo.getUsername()%>
                    <%--<img src="/res/image/userImg.png" class="layui-nav-img" style="object-fit: cover">

                    <%=userInfo.getUsername()%>--%>

                    <%--                        <a style="width: 55px;height: 22px;float: left;font-size: 12px;line-height: 60px;color: rgba(211,235,255,0.5);">admin</a>--%>
                </a>

                <dl class="layui-nav-child" style="">
                    <iframe cals="newiframe" src="" style="position: absolute; left: 0; top: 0; z-index:-1; width: 100%; height: 100%; background-color: transparent; opacity:0; " frameborder="0"></iframe>
                    <dd id="modifyPSW" onclick="modifyPSW()"><a>修改密码</a></dd>
                    <dd <%--class="layui-nav-item"--%>><a  onclick="exit()">退出</a></dd>
                </dl>
            </li>

        </ul>

    </div>

</div>

<div class="layui-side-scroll" style="width: 225px" id="leftSide">
    <div class="layui-side layui-bg-black"  style="width: 225px;/*overflow-y:hidden*/">

        <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
        <ul class="layui-nav layui-nav-tree"  lay-filter="test">

            <li class="layui-nav-item" style="width: 225px"><a href="javascript:;" class="b1">视频监控</a>
                <dl class="layui-nav-child">
                    <%--                    <dd><a href="/videoManager">监控设备</a></dd>--%>
                    <dd><a href="/realtimeMonitoring"style="padding-left: 60px" class="b2">实时预览</a></dd>
                    <dd><a href="/videoReplay"style="padding-left: 60px" class="b3">录像回放</a></dd>
                </dl>
            </li>
            <li class="layui-nav-item" style="width: 225px"><a href="javascript:;" class="b4">批量设置</a>
                <dl class="layui-nav-child">
                    <dd><a href="/batchSetting"style="padding-left: 60px">空开设备批量</a></dd>
                    <dd><a href="/airConditionBatchSetting"style="padding-left: 60px">空调设备批量</a></dd>
                </dl>
            </li>
            <li class="layui-nav-item" style="width: 225px"><a href="javascript:;" class="b5">远程维护</a>
                <dl class="layui-nav-child">
                    <dd><a href="/airSwitchRemote"style="padding-left: 60px">空开设备维护</a></dd>
                    <dd><a href="/airConditionRemote"style="padding-left: 60px">空调设备维护</a></dd>
                </dl>
            </li>
            <li class="layui-nav-item" style="width: 225px"><a href="javascript:;" class="b6">设备状态</a>
                <dl class="layui-nav-child">
                    <dd><a href="/airSwitchStatus"style="padding-left: 60px">空开设备</a></dd>
                    <dd><a href="/airConditionStatus"style="padding-left: 60px">空调设备</a></dd>
                </dl>
            </li>
            <%--            <li class="layui-nav-item"><a href="javascript:;" class="bn">环境数据</a></li>--%>
            <li class="layui-nav-item" style="width: 225px"><a href="javascript:;" class="b7">能耗统计</a>
                <dl class="layui-nav-child">
                    <dd><a href="/energyConsumption"style="padding-left: 60px" class="b13">用电量</a></dd>
                </dl>
            </li>
            <li class="layui-nav-item" style="width: 225px"><a href="javascript:;" class="b8">用电安全</a>
                <dl class="layui-nav-child">
                    <dd><a href="javascript:;"style="padding-left: 60px" class="b15">用电安全</a></dd>
                </dl>
            </li>

            <li class="layui-nav-item" style="width: 225px"><a href="javascript:;" class="b9">使用时长</a>
                <dl class="layui-nav-child">
                    <dd><a href="/durationUse"style="padding-left: 60px"  class="b16">使用时长</a></dd>
                </dl>
            </li>
            <%-- <li class="layui-nav-item"><a href="javascript:;" class="bn">门禁系统</a></li>--%>

            <%--            <li class="layui-nav-item"><a href="javascript:;" class="bn">主控台</a>--%>
            <%--                <dl class="layui-nav-child">--%>
            <%--                    <dd><a href="javascript:;"style="padding-left: 60px">用电状态</a></dd>--%>
            <%--                    <dd><a href="javascript:;"style="padding-left: 60px">空调状态</a></dd>--%>
            <%--                </dl>--%>
            <%--            </li>--%>
            <li class="layui-nav-item" style="width: 225px"><a href="javascript:;" class="b14">普通门禁</a>
                <dl class="layui-nav-child">
                    <%--                    <dd><a href="javascript:;">人卡管理</a></dd>--%>
                    <%--                    <dd><a href="javascript:;">权限管理</a></dd>--%>
                    <%--                    <dd><a href="javascript:;">远程操作</a></dd>--%>
                    <dd><a href="/wgAccessDevRealTime"style="padding-left: 60px"class="b11">实时监控</a></dd>
                    <dd><a href="/goWgAccessOpenDoor"style="padding-left: 60px"class="b12">历史信息</a></dd>
                    <%--<dd><a href="/goWgPromiseMsg" style="padding-left: 60px">权限信息</a></dd>--%>
                </dl>
            </li>

            <li class="layui-nav-item" style="width: 225px"><a href="javascript:;" class="b10">通行记录</a>
                <dl class="layui-nav-child">
                    <dd><a href="recordInfo" style="padding-left: 60px"class="b11">实时监测</a></dd>
                    <dd><a href="historyRecordInfo" style="padding-left: 60px" class="b12">历史记录</a></dd>
                </dl>
            </li>
            <li class="layui-nav-item" style="width: 225px"><a href="javascript:;" class="b10">噪声传感器</a>
                <dl class="layui-nav-child">
                    <dd><a href="noiseRealDataView" style="padding-left: 60px"class="b11">实时噪声监测</a></dd>
                </dl>
            </li>
            <%--            <li class="layui-nav-item" style="width: 225px"><a href="javascript:;" class="bn">门禁设备</a>--%>
            <%--                <dl class="layui-nav-child">--%>
            <%--                    <dd><a href="goDepartment" style="padding-left: 60px">部门管理</a></dd>--%>
            <%--                    <dd><a href="goMachine" style="padding-left: 60px">设备管理</a></dd>--%>
            <%--                    <dd><a href="goCard" style="padding-left: 60px">权限信息</a></dd>--%>
            <%--                </dl>--%>
            <%--            </li>--%>
            <%--            <li class="layui-nav-item">--%>
            <%--                <a href="javascript:;">设备管理</a>--%>
            <%--                <dl class="layui-nav-child">--%>
            <%--                    <dd><a href="/devM">空开设备</a></dd>--%>
            <%--                    <dd><a href="/devAir">空调设备</a></dd>--%>
            <%--                </dl>--%>
            <%--            </li>--%>
            <%--            <li class="layui-nav-item">--%>
            <%--                <a href="javascript:;">区域管理</a>--%>
            <%--                <dl class="layui-nav-child">--%>
            <%--                    <dd><a href="/organizeM">区域信息</a></dd>--%>
            <%--                </dl>--%>
            <%--            </li>--%>
        </ul>
    </div>
</div>

<style>
    .div-modify-password{
        background-color: rgba(0,0,0,0.2);
        position: absolute;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        z-index: 9999999;

    }
    .div-modify-password-view{
        z-index: 999999999;
        position: relative;
        top: 50%;
        left: 50%;
        width: 400px;
        height: 300px;
        margin-left: -200px;
        margin-top: -150px;
        background-color: rgba(255,255,255,1);
        border-radius: 5px;
    }
</style>
<div class="div-modify-password layui-hide ">
    <div class="div-modify-password-view">
        <div style="margin-left: 45px;padding-top: 55px;">
            <div class="layui-form-item">
                <label style="width: 100px" class="layui-form-label">旧密码</label>
                <div class="layui-input-inline">
                    <input  type="password" class="layui-input" id="oldUserPassword">
                </div>
            </div>

            <div class="layui-form-item">
                <label style="width: 100px" class="layui-form-label">新密码</label>
                <div class="layui-input-inline">
                    <input type="password"  class="layui-input" id="newUserPassword1">
                </div>
            </div>

            <div class="layui-form-item">
                <label style="width: 100px" class="layui-form-label">新密码确认</label>
                <div class="layui-input-inline">
                    <input type="password"  class="layui-input" id="newUserPassword2">
                </div>
            </div>
        </div>

        <div style="text-align: center;margin-top: 20px">
            <button class="layui-btn" id="btnModifyPasswordSure">确认</button>
            <button class="layui-btn" id="btnModifyPasswordCancel">取消</button>
        </div>

        <script>
            $('#btnModifyPasswordCancel').click(function () {
                hideModifyPasswordDiv();
            });

            $('#btnModifyPasswordSure').click(function () {
                var oldPsw = $('#oldUserPassword').val();
                var newPsw1 = $('#newUserPassword1').val();
                var newPsw2 = $('#newUserPassword2').val();

                if(oldPsw.length<1 || newPsw1.length < 1|| newPsw2.length <1){
                    MyUtil.msg('请输入全部密码');
                    return;
                }
                if(newPsw1.length < 6 || newPsw2.length<6){
                    MyUtil.msg('密码不足6位');
                    return;
                }

                if(newPsw1 != newPsw2){
                    MyUtil.msg('密码不一致');
                    return;
                }

                if(oldPsw == newPsw2){
                    MyUtil.msg('新密码不能与旧密码相同');
                    return;
                }

                var data = {
                    psw0:oldPsw
                    ,psw1:newPsw1
                    ,psw2:newPsw2
                };

                $.post('modifyPsw',data,function (res) {
                    console.log(res);
                    if(res.code > 0){
                        hideModifyPasswordDiv();
                    }
                    MyUtil.msg(res.msg);
                });
            });

            function hideModifyPasswordDiv() {
                $('.div-modify-password').addClass('layui-hide');
            }
            function showModifyPasswordDiv() {
                $('.div-modify-password').removeClass('layui-hide');
            }
            function initModifyPasswordInput() {
                $('#oldUserPassword').val('');
                $('#newUserPassword1').val('');
                $('#newUserPassword2').val('');
            }
            //修改密码
            function modifyPSW() {
                initModifyPasswordInput();
                showModifyPasswordDiv();
                //除去选中样式
                $('#modifyPSW').removeClass('layui-this');

                return;
                //prompt层
                layer.prompt({title: '输入新密码', formType: 1,maxlength:10}, function(pass, index){
                    var loading = layer.load(1, {shade: [0.1,'#fff']});
                    $.post('modifyPSW',{id:$('#userId').val(),password:pass},function (res) {
                        layer.msg(res.msg);
                    }).fail(function (xhr) {

                    }).always(function () {
                        layer.close(loading);
                    });
                    layer.close(index);
                });
                //除去选中样式
                $('#modifyPSW').removeClass('layui-this');
            }
        </script>
    </div>
</div>

<script>
    //设置头部选中样式
    function headThis(str) {
        var lis = $('.layui-nav.layui-layout-left').find('li');
        //alert(lis.length);
        for(var i =0; i<lis.length;i++){
            //alert($(lis[i]).text());
            var temp = $(lis[i]);
            if(temp.text() == str){
                temp.addClass('layui-this');
            }else{
                temp.removeClass('layui-this');
            }
        }
    }

    // $(function () {
    //     $(".layui-nav-child dd a").click(function () {
    //         $(this).css('background-color','#1666f9');
    //     })
    // })
    //设置左边导航选中样式
    function leftThis(str) {
        //管理下的节点缩进
        // $('.layui-side.layui-bg-black').find('dd').find('a').css('padding-left','50px');

        var tree = $('.layui-nav.layui-nav-tree');
        var lis = $(tree).find('li');
        //alert(lis.length);
        for(var i=0;i<lis.length;i++){
            var dds = $(lis[i]).find('dd');
            //alert(dds.length);
            var bHas = false;
            for(var j=0;j<dds.length;j++){
                //alert($(dds[j]).text());
                if($(dds[j]).text() == str){
                    $(dds[j]).addClass('layui-this');
                    bHas = true;
                }else{
                    $(dds[j]).removeClass('layui-this');
                }
            }
                if(bHas){
                $(lis[i]).addClass('layui-nav-itemed');
            }else{
                $(lis[i]).removeClass('layui-nav-itemed');
            }
        }
    }
    //退出登录
    function exit() {
        var loading = layer.load(1);
        $.post('loginOut',function (res) {
            //console.log(res);
            layer.close(loading);
            layer.msg('退出成功',{time:800},function () {
                window.location.href = '/';
            })
        }).fail(function (xhr) {
            layer.msg('退出失败 '+xhr.status);
        }).always(function () {
            layer.close(loading);
        })
    }

    //提示弹窗
    function onTips(msg,icon) {
        layui.use("layer",function(){
                //layer.msg('有表情地提示', {icon: 6});
                layer.msg(msg, {
                    skin: 'demo-class',
                    title:'提示信息',
                    time: 2000, //2秒关闭（如果不配置，默认是3秒）
                    icon:icon,
                    offset:'rb',
                    area: ['300px', '150px']
                }, function(){
                    //do something
                });
            }
        )
    }
</script>
