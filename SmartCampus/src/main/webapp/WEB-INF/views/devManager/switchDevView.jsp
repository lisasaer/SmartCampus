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
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>设备管理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <jsp:include page="../header/res.jsp"></jsp:include>
</head>
<body class="layui-layout-body"  >
    <div class="layui-layout layui-layout-admin">
        <!-- 头部区域（可配合layui已有的水平导航） -->
        <jsp:include page="../header/topHead.jsp" ></jsp:include>
        <div class="layui-body"style="bottom: 0px;margin-left: 25px;margin-top: 4px;padding:15px;">
            <div class="layui-form-item">
                <div class="layui-col-md1" style="width: 800px">
                    <form id="form1" class="layui-form" >
                        <%--<button id="setAllSwitch" class="layui-btn">设置空开设备</button>--%>
                        <div class="layui-input-inline">
                            <select id="school" name="school" lay-filter="selectSchool" title="校区选择" >
                                <option value="">校区选择</option>
                                <c:forEach items="${schoolList}" var="item">
                                    <option value="${item.id}">${item.text}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="layui-input-inline">
                            <select id="house" name="house" lay-filter="selectHouse" title="楼栋选择">
                                <option value="">楼栋选择</option>
                            </select>
                        </div>

                        <div class="layui-input-inline">
                            <select id="floor" name="floor" lay-filter="selectFloor" title="楼层选择">
                                <option value="">楼层选择</option>
                            </select>
                        </div>

                        <div class="layui-input-inline">
                            <select id="room" name="room" lay-filter="selectRoom" title="房号选择">
                                <option value="">房号选择</option>
                            </select>
                        </div>
                        <%-- <input type="text" id="devID" placeholder="请输入设备ID" style="width: 150px;height: 37px;">
                         <input type="text" id="devName" placeholder="请输入设备名称" style="width: 150px;height: 37px;">--%>
                        <%--<button id="btnSearch" class="layui-btn" onclick="searchDev()">搜索</button>--%>
                    </form>
                </div>
                <div class="layui-col-md1" style="width: 300px">
                    <%--<button id="btnSerialPortSetting" class="layui-btn">串口设置</button>--%>
                    <button id="btnUpdate" class="layui-btn">刷新</button>
                </div>
            </div>
            <form id="formId">
            <div class="layui-row" id="change" style="height: 400px;width: 1250px;">
                <c:forEach items="${switchDevList}" var="item">

                    <div class="layui-col-md1" style="height: 200px;width: 300px;">
                        <div class="layui-row" style="height: 30px;width: 300px;background: #7F9DB9">
                            <div class="layui-col-md1" style="height: 30px;width: 100px" align="center">
                                    ${item.devStatus}
                            </div>
                            <div class="layui-col-md1" style="height: 30px;width: 200px;padding-left: 50px" align="right">
                                线路数:${item.chncnt}
                                <a  id="switch" href="/switchChnView?devId=${item.devId}">
                                    <img  src="../res/image/开关.jpg" style="height: 30px;width:30px;padding-right: 0px" align="right">
                                </a>
                            </div>
                        </div>
                        <div class="layui-row" style="height: 120px;width: 300px;background: #0E2D5F ">
                            <div class="layui-col-md1" style="height: 120px;width: 100px" align="center">
                                <img src="../res/image/空开.png" style="height: 120px;width:100px " align="center">
                            </div>
                            <div class="layui-col-md1" style="height: 120px;width: 190px;padding-top: 10px">
                                <div class="layui-row" style="height:30px ;width: 180px;padding-top: 5px;color: #ffffff" >
                                        网关序列号:${item.loraSN}
                                </div>
                                <div id="devId" class="layui-row" style="height:30px ;width: 180px;padding-top: 5px;color: #ffffff" >
                                        设备ID:${item.devId}
                                </div>
                                <div class="layui-row" style="height:30px ;width: 180px;padding-top: 5px;color: #ffffff" >
                                        ${item.school}-${item.house}-${item.floor}-${item.room}
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="layui-col-md1" style="height: 200px;width: 15px;"></div>
                </c:forEach>
            </div>
            </form>
            <%--<table  id="demo" lay-filter="test" lay-skin="row" ></table>--%>
        </div>
<%--        <jsp:include page="../header/footer.jsp"></jsp:include>--%>
    </div>
</body>
<script>
    $('#btnSerialPortSetting').click(function () {
        layer.open({
            type: 2,
            area: ['430px', '300px'],
            maxmin: true,
            fixed: false, //不固定
            content: '/serialPortSettingView'
        });
    });

    layui.use(['element'], function() {});

    $('#btnUpdate').click(function () {
        window.location.reload();
        // var loading = MyLayUIUtil.loading();
        // $.post('getRealStatus',{devType:'1'},function (res) {
        //
        // }).always(function () {
        //     setTimeout(function () {
        //         reloadTB();
        //         MyLayUIUtil.closeLoading(loading);
        //     },1000);
        // })
    });
    var table ;

</script>
<script>
    var form ;
    var devId;
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
                $.post('getChildrenOrganize',{id:select.val()},function (res) {
                    console.log(res);
                    $('[name="house"]').html('<option value="">楼栋选择</option>');
                    res.forEach(function (value,index) {
                        $('[name="house"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                    });
                    $('[name="floor"]').html('<option value="">楼层选择</option>');
                    $('[name="room"]').html('<option value="">房号选择</option>');
                    form.render('select');
                })

                school = data.elem[data.elem.selectedIndex].text
                console.log("school : " + school)
                $.post('updataSwitchDevView',
                    {school:school},
                    function(res) {
                        console.log(res);
                        var items=eval(res);
                          var str="";
                        $.each(items,function (index,item) {
                            str+='<div class="layui-col-md1" style="height: 200px;width: 300px;">';
                              str+=' <div class="layui-row" style="height: 30px;width: 300px;background: #7F9DB9">';

                                str+=' <div class="layui-col-md1" style="height: 30px;width: 100px" align="center">' +item.devStatus;

                                str+=' </div> ';
                                str+=' <div class="layui-col-md1" style="height: 30px;width: 200px;padding-left: 50px" align="right"> 线路数:'+item.chncnt;

                                str+=' <a id="switch" href="/switchChnView?devId= '+item.devId;
                                str+='">';
                                    str+=' <img  src="../res/image/开关.jpg" style="height: 30px;width:30px;padding-right: 0px" align="right">';
                                str+=' </a>';
                               str+=' </div>';
                              str+=' </div>';
                            str+=' <div class="layui-row" style="height: 120px;width: 300px;background: #0E2D5F ">';
                            str+=' <div class="layui-col-md1" style="height: 120px;width: 100px" align="center">';
                            str+=' <img src="../res/image/空开.png" style="height: 120px;width:100px " align="center">';
                            str+=' </div>';
                            str+=' <div class="layui-col-md1" style="height: 120px;width: 190px;padding-top: 10px">';
                            str+=' <div class="layui-row" style="height:30px ;width: 180px;padding-top: 5px;color: #ffffff" >  网关序列号:' + item.loraSN;
                                    str+=' </div>';
                            str+=' <div id="devId" class="layui-row" style="height:30px ;width: 180px;padding-top: 5px;color: #ffffff" >  设备ID:'+item.devId;

                                    str+=' </div>';
                            str+=' <div class="layui-row" style="height:30px ;width: 180px;padding-top: 5px;color: #ffffff" >'+item.school+'-'+item.house+'-'+item.floor+'-'+item.room;
                                    str+=' </div>';
                            str+=' </div>';
                            str+=' </div>';
                            str+=' </div>';
                            str+=' <div class="layui-col-md1" style="height: 200px;width: 15px;"></div>';
                        })
                        $('#change').html(str);
                });

            });
            form.on('select(selectHouse)', function (data) {
                var select = $(data.elem);
                $.post('getChildrenOrganize',{id:select.val()},function (res) {
                    console.log(res);
                    $('[name="floor"]').html('<option value="">楼层选择</option>');
                    res.forEach(function (value,index) {
                        $('[name="floor"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                    });
                    $('[name="room"]').html('<option value="">房号选择</option>');
                    form.render('select');
                })

                house = data.elem[data.elem.selectedIndex].text
                console.log("house : " + house)
                $.post('updataSwitchDevView',
                    {school:school,house:house},
                    function(res) {
                        console.log(res);
                        var items=eval(res);
                        var str="";
                        $.each(items,function (index,item) {
                            str+='<div class="layui-col-md1" style="height: 200px;width: 300px;">';
                            str+=' <div class="layui-row" style="height: 30px;width: 300px;background: #7F9DB9">';

                            str+=' <div class="layui-col-md1" style="height: 30px;width: 100px" align="center">' +item.devStatus;

                            str+=' </div> ';
                            str+=' <div class="layui-col-md1" style="height: 30px;width: 200px;padding-left: 50px" align="right"> 线路数:'+item.chncnt;

                            str+=' <a  id="switch" href="/switchChnView?devId='+item.devId+'">';

                            str+=' <img  src="../res/image/开关.jpg" style="height: 30px;width:30px;padding-right: 0px" align="right">';
                            str+=' </a>';
                            str+=' </div>';
                            str+=' </div>';
                            str+=' <div class="layui-row" style="height: 120px;width: 300px;background: #0E2D5F ">';
                            str+=' <div class="layui-col-md1" style="height: 120px;width: 100px" align="center">';
                            str+=' <img src="../res/image/空开.png" style="height: 120px;width:100px " align="center">';
                            str+=' </div>';
                            str+=' <div class="layui-col-md1" style="height: 120px;width: 190px;padding-top: 10px">';
                            str+=' <div class="layui-row" style="height:30px ;width: 180px;padding-top: 5px;color: #ffffff" >  网关序列号:' + item.loraSN;
                            str+=' </div>';
                            str+=' <div id="devId" class="layui-row" style="height:30px ;width: 180px;padding-top: 5px;color: #ffffff" >  设备ID:'+item.devId;

                            str+=' </div>';
                            str+=' <div class="layui-row" style="height:30px ;width: 180px;padding-top: 5px;color: #ffffff" >'+item.school+'-'+item.house+'-'+item.floor+'-'+item.room;
                            str+=' </div>';
                            str+=' </div>';
                            str+=' </div>';
                            str+=' </div>';
                            str+=' <div class="layui-col-md1" style="height: 200px;width: 15px;"></div>';
                        })
                        $('#change').html(str);
                    });
            });
            form.on('select(selectFloor)', function (data) {

                var select = $(data.elem);
                $.post('getChildrenOrganize',{id:select.val()},function (res) {
                    console.log(res);
                    $('[name="room"]').html('<option value="">房号选择</option>');
                    res.forEach(function (value,index) {
                        $('[name="room"]').append('<option value="'+value.id+'">'+value.text+'</option>');
                    });
                    form.render('select');
                })


                floor = data.elem[data.elem.selectedIndex].text
                console.log("floor : " + floor)
                $.post('updataSwitchDevView',
                    {school:school,house:house,floor:floor},
                    function(res) {
                        console.log(res);
                        var items=eval(res);
                        var str="";
                        $.each(items,function (index,item) {
                            str+='<div class="layui-col-md1" style="height: 200px;width: 300px;">';
                            str+=' <div class="layui-row" style="height: 30px;width: 300px;background: #7F9DB9">';

                            str+=' <div class="layui-col-md1" style="height: 30px;width: 100px" align="center">' +item.devStatus;

                            str+=' </div> ';
                            str+=' <div class="layui-col-md1" style="height: 30px;width: 200px;padding-left: 50px" align="right"> 线路数:'+item.chncnt;

                            str+=' <a  id="switch" href="/switchChnView?devId='+item.devId+'">';
                            str+=' <img  src="../res/image/开关.jpg" style="height: 30px;width:30px;padding-right: 0px" align="right">';
                            str+=' </a>';
                            str+=' </div>';
                            str+=' </div>';
                            str+=' <div class="layui-row" style="height: 120px;width: 300px;background: #0E2D5F ">';
                            str+=' <div class="layui-col-md1" style="height: 120px;width: 100px" align="center">';
                            str+=' <img src="../res/image/空开.png" style="height: 120px;width:100px " align="center">';
                            str+=' </div>';
                            str+=' <div class="layui-col-md1" style="height: 120px;width: 190px;padding-top: 10px">';
                            str+=' <div class="layui-row" style="height:30px ;width: 180px;padding-top: 5px;color: #ffffff" >  网关序列号:' + item.loraSN;
                            str+=' </div>';
                            str+=' <div id="devId" class="layui-row" style="height:30px ;width: 180px;padding-top: 5px;color: #ffffff" >  设备ID:'+item.devId;

                            str+=' </div>';
                            str+=' <div class="layui-row" style="height:30px ;width: 180px;padding-top: 5px;color: #ffffff" >'+item.school+'-'+item.house+'-'+item.floor+'-'+item.room;
                            str+=' </div>';
                            str+=' </div>';
                            str+=' </div>';
                            str+=' </div>';
                            str+=' <div class="layui-col-md1" style="height: 200px;width: 15px;"></div>';
                        })
                        $('#change').html(str);
                    });
            });
            form.on('select(selectRoom)', function (data) {

                room = data.elem[data.elem.selectedIndex].text
                console.log("room : " + room)
                $.post('updataSwitchDevView',
                    {school:school,house:house,floor:floor,room:room},
                    function(res) {
                        console.log(res);
                        var items=eval(res);
                        var str="";
                        $.each(items,function (index,item) {
                            str+='<div class="layui-col-md1" style="height: 200px;width: 300px;">';
                            str+=' <div class="layui-row" style="height: 30px;width: 300px;background: #7F9DB9">';

                            str+=' <div class="layui-col-md1" style="height: 30px;width: 100px" align="center">' +item.devStatus;

                            str+=' </div> ';
                            str+=' <div class="layui-col-md1" style="height: 30px;width: 200px;padding-left: 50px" align="right"> 线路数:'+item.chncnt;

                            str+=' <a  id="switch" href="/switchChnView?devId='+item.devId+'">';
                            str+=' <img  src="../res/image/开关.jpg" style="height: 30px;width:30px;padding-right: 0px" align="right">';
                            str+=' </a>';
                            str+=' </div>';
                            str+=' </div>';
                            str+=' <div class="layui-row" style="height: 120px;width: 300px;background: #0E2D5F ">';
                            str+=' <div class="layui-col-md1" style="height: 120px;width: 100px" align="center">';
                            str+=' <img src="../res/image/空开.png" style="height: 120px;width:100px " align="center">';
                            str+=' </div>';
                            str+=' <div class="layui-col-md1" style="height: 120px;width: 190px;padding-top: 10px">';
                            str+=' <div class="layui-row" style="height:30px ;width: 180px;padding-top: 5px;color: #ffffff" >  网关序列号:' + item.loraSN;
                            str+=' </div>';
                            str+=' <div id="devId" class="layui-row" style="height:30px ;width: 180px;padding-top: 5px;color: #ffffff" >  设备ID:'+item.devId;

                            str+=' </div>';
                            str+=' <div class="layui-row" style="height:30px ;width: 180px;padding-top: 5px;color: #ffffff" >'+item.school+'-'+item.house+'-'+item.floor+'-'+item.room;
                            str+=' </div>';
                            str+=' </div>';
                            str+=' </div>';
                            str+=' </div>';
                            str+=' <div class="layui-col-md1" style="height: 200px;width: 15px;"></div>';
                        })
                        $('#change').html(str);
                    });
            });
        });

    });
</script>
</html>
