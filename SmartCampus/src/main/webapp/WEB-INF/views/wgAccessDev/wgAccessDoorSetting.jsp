<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2019/11/30
  Time: 14:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>门设置</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        .layui-form-label{
            width: 120px;
        }
        /*.layui-table-view .layui-form-checkbox[lay-skin=primary] i {*/
        /*    width: 15px;*/
        /*    height: 15px;*/
        /*    border-color:#d2d2d2;*/
        /*}*/
        /*勾选框中被选中*/
        .layui-form-checked[lay-skin=primary] i {
            border-color: #1666f9!important;
            background-color: #1666f9;
            color: #fff;
            /*background: url('../../res/layui/images/dev_icon/checked.png');*/
        }
        /*勾选框中未被选中*/
        .layui-form-checkbox[lay-skin=primary] i {
            border-color: #d2d2d2!important;
            /*background-color: #1666f9;*/
            color: #fff;
            width: 16px;
            height: 16px;
            /*background: url('../../res/layui/images/dev_icon/checkbox.png');*/
        }
        .layui-form-radio>i:hover, .layui-form-radioed>i {
            color: #1666f9;
        }
    </style>
</head>
<body style="padding: 15px;">
<%--    <form  class="layui-form">--%>
        <fieldset class="layui-elem-field layui-field-title">
            <legend style="font-size: 16px;">门禁控制器</legend>
        </fieldset>
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label">控制器SN</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" id="ctrlerSN" name="ctrlerSN" value="${wGAccessDevInfo.ctrlerSN}" readonly="readonly">
                </div>
                <label class="layui-form-label">IP地址</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" id="test1" value="${wGAccessDevInfo.ip}" disabled>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">子网掩码</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" id="test4" value="${wGAccessDevInfo.netmask}" disabled>
                </div>
                <label class="layui-form-label">网关</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" id="test21" value="${wGAccessDevInfo.defaultGateway}" disabled>
                </div>
            </div>
            <div class="layui-inline">
                <label class="layui-form-label">MAC地址</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" id="test11" value="${wGAccessDevInfo.macAddress}" disabled>
                </div>
                <label class="layui-form-label">启用</label>
                <div class="layui-input-inline">
                    <input type="checkbox" id="devOnUse" name="devOnUse" style="height: 20px;width:40px;margin-top: 10px" lay-skin="primary" onclick="devOrUse()" value="1" <c:if test="${wGAccessDevInfo.onUse==1}"> checked=""</c:if>>
                </div>
            </div>
        </div>
<%--    </form>--%>
        <fieldset class="layui-elem-field layui-field-title">
            <legend style="font-size: 16px;">门设置</legend>

        </fieldset>

        <c:forEach items="${WGDoordevList}" var="item" varStatus="index">
        <form id="${item.doorID}" class="layui-form">

            <fieldset class="layui-elem-field site-demo-button" style="width: 250px;text-align: center" >
            <legend>${index.count}号门</legend>
                <input type="text" class="layui-input" id="doorID" name="doorID" value="${item.doorID}" style="width: 0px;height: 0px;background-color:transparent;border:0;" hidden="hidden">
            <div class="layui-form-item">
                <div class="layui-inline"style="width: 700px">
                    <div class="layui-col-md1" style="padding-top: 10px;height: 40px">
                        <div style="padding-left: 30px">
                            <label class="layui-form-label" style="width: 60px">启用</label>
                            <div class="layui-input-inline" style="width: 35px;padding-left: 0px">
                                <input type="checkbox" id="doorOnUse" name="doorOnUse" lay-skin="primary" value="1" onclick="doorOrUse()" <c:if test="${item.onUse==1}"> checked=""</c:if>>
                            </div>
                        </div>
                        <div style="padding-left: 180px">
                            <label class="layui-form-label"style="width: 100px">${index.count}号门名称</label>
                            <div class="layui-input-inline"style="width: 100px">
                                <input type="text" class="layui-input" id="doorName" style="width: 100px" name="doorName" placeholder="门名称" value="${item.doorName}">
                            </div>
                        </div>
                        <div style="padding-left: 430px">
                            <label class="layui-form-label" style="width: 130px">进门读卡器性质</label>
                            <div class="layui-input-inline"style="width: 130px">
                                <input type="text"  class="layui-input" id="inType" name="inType" placeholder="读卡器性质" value="${item.inType}">
                            </div>
                        </div>
                    </div>
                    <br>
                    <div class="layui-col-md2" >
                        <label class="layui-form-label" style="width: 100px;padding-left: 0px">开门延时(s)</label>
                        <div class="layui-input-inline"style="width: 50px;padding-left: 0px">
                            <input type="number" class="layui-input"  min="1" max="247"style="width: 45px" id="doorDelay" name="doorDelay" value="${item.doorDelay}">
                        </div>
                        <div style="float: left;padding-left: 10px">
                            <fieldset class="layui-elem-field site-demo-button" style="width: 250px;text-align: center" >
                                <div style="width: 250px">
                                    <input type="radio" name="doorCtrlWay" value="3" title="在线"  <c:if test="${item.doorCtrlWay=='3'}"> checked=""</c:if>>
                                    <input type="radio" name="doorCtrlWay" value="1" title="常开"  <c:if test="${item.doorCtrlWay=='1'}"> checked=""</c:if>>
                                    <input type="radio" name="doorCtrlWay" value="2" title="常闭"  <c:if test="${item.doorCtrlWay=='2'}"> checked=""</c:if>>
                                </div>
                            </fieldset>
                        </div>
                        <div style="padding-left: 430px">
                            <label class="layui-form-label" style="width: 130px">出门读卡器性质</label>
                            <div class="layui-input-inline"style="width: 130px">
                                <input type="text"  class="layui-input" id="outType" name="outType" placeholder="读卡器性质" value="${item.outType}">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            </fieldset>
        </form>
        </c:forEach>

        <div class="layui-form-item" hidden="hidden">
            <button id="submitBtn" class="layui-btn" lay-submit="" lay-filter="demo2">保存</button>
            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
        </div>
</body>
<%--<body style="padding: 15px;">
&lt;%&ndash;    <form  class="layui-form">&ndash;%&gt;
<fieldset class="layui-elem-field layui-field-title">
    <legend style="font-size: 16px;">门禁控制器</legend>
</fieldset>
<div class="layui-form-item">
    <div class="layui-inline">
        <label class="layui-form-label">控制器SN</label>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" id="ctrlerSN" name="ctrlerSN" value="${wGAccessDevInfo.ctrlerSN}" readonly="readonly">
        </div>
        <label class="layui-form-label">IP地址</label>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" id="test1" value="${wGAccessDevInfo.ip}" disabled>
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">子网掩码</label>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" id="test4" value="${wGAccessDevInfo.netmask}" disabled>
        </div>
        <label class="layui-form-label">网关</label>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" id="test21" value="${wGAccessDevInfo.defaultGateway}" disabled>
        </div>
    </div>
    <div class="layui-inline">
        <label class="layui-form-label">MAC地址</label>
        <div class="layui-input-inline">
            <input type="text" class="layui-input" id="test11" value="${wGAccessDevInfo.macAddress}" disabled>
        </div>
        <label class="layui-form-label">启用</label>
        <div class="layui-input-inline">
            <input type="checkbox" id="devOnUse" name="devOnUse" style="height: 20px;width:40px;margin-top: 10px" lay-skin="primary" onclick="devOrUse()" value="1" <c:if test="${wGAccessDevInfo.onUse==1}"> checked=""</c:if>>
        </div>
    </div>
</div>
&lt;%&ndash;    </form>&ndash;%&gt;
<fieldset class="layui-elem-field layui-field-title">
    <legend style="font-size: 16px;">门设置</legend>

</fieldset>
<div class="layui-inline">
    <label class="layui-form-label" style="padding-left: 100px;width: 200px" >门名称</label>
    <label class="layui-form-label"style="padding-left: 180px;width: 300px">控制方式</label>
    <label class="layui-form-label"style="padding-left: 100px;width: 200px">开门延时(s)</label>
</div>

<c:forEach items="${WGDoordevList}" var="item" varStatus="index">
    <form id="${item.doorID}" class="layui-form">
        <input type="text" class="layui-input" id="doorID" name="doorID" value="${item.doorID}" style="width: 0px;height: 0px" hidden="hidden">
        <div class="layui-form-item">

            <div class="layui-inline"style="width: 700px">
                <label class="layui-form-label">${index.count}号门 </label>
                <div class="layui-input-inline"style="width: 100px">
                    <input type="text" class="layui-input" id="doorName" style="width: 100px" name="doorName" placeholder="门名称" value="${item.doorName}">
                </div>
                <label class="layui-form-label" style="width: 60px">启用</label>
                <div class="layui-input-inline" style="width: 30px">
                    <input type="checkbox" id="doorOnUse" name="doorOnUse" lay-skin="primary"  value="1" onclick="doorOrUse()" <c:if test="${item.onUse==1}"> checked=""</c:if>>
                </div>
                <div style="float: left">
                    <fieldset class="layui-elem-field site-demo-button" style="width: 250px;text-align: center" >
                        <div style="width: 250px">
                            <input type="radio" name="doorCtrlWay" value="3" title="在线"  <c:if test="${item.doorCtrlWay=='3'}"> checked=""</c:if>>
                            <input type="radio" name="doorCtrlWay" value="1" title="常开"  <c:if test="${item.doorCtrlWay=='1'}"> checked=""</c:if>>
                            <input type="radio" name="doorCtrlWay" value="2" title="常闭"  <c:if test="${item.doorCtrlWay=='2'}"> checked=""</c:if>>
                        </div>
                    </fieldset>
                </div>
                <div class="layui-input-inline"style="width: 50px;padding-left: 40px">
                    <input type="number" class="layui-input"  min="1" max="247"style="width: 40px" id="doorDelay" name="doorDelay" value="${item.doorDelay}">
                </div>
            </div>
        </div>
    </form>
</c:forEach>
<fieldset class="layui-elem-field layui-field-title">
    <legend style="font-size: 16px;">读卡器</legend></fieldset>

<c:forEach items="${WGDoordevList}" var="item" varStatus="index">
    <form id="${item.doorID}" class="layui-form">
        <div class="layui-form-item">
            <div class="layui-inline">
                <label class="layui-form-label" style="width: 150px">${index.count}号门进门-读卡器</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" id="inType" name="inType" placeholder="读卡器性质" value="${item.inType}">
                </div>
                <label class="layui-form-label" style="width: 150px">${index.count}出门-读卡器</label>
                <div class="layui-input-inline">
                    <input type="text" class="layui-input" id="outType" name="outType" placeholder="读卡器性质" value="${item.outType}">
                </div>
            </div>
        </div>
    </form>
</c:forEach>

<div class="layui-form-item" hidden="hidden">
    <button id="submitBtn" class="layui-btn" lay-submit="" lay-filter="demo2">保存</button>
    <button type="reset" class="layui-btn layui-btn-primary">重置</button>
</div>


</body>--%>
<script>


    layui.use(['form', 'element', 'laydate', 'upload'], function () {

        //监听提交
        var form = layui.form,
            layer = layui.layer,
            $ = layui.$;

        form.on('submit(demo2)', function (data) {
            var id = $('.id').val();
            var ids=[];
            $("form").each(function(i){
                var id = this.id;
                /*console.log("id:"+id)
                console.log("i:"+i)*/
                ids.push(id);
            });

            var doorInfos=[];
            for (var i=0;i<ids.length;i++) {
                var obj = document.getElementById(ids[i]);
                var formID=obj.id;
                console.log(obj);
                var doorName=obj.doorName.value;
                if ( document.getElementsByName("doorOnUse")[i].checked) {
                    var doorOnUse=1;
                }else {
                    var doorOnUse=0;
                }
                var doorID=obj.doorID.value;
                var doorCtrlWay=obj.doorCtrlWay.value;
                var doorDelay=obj.doorDelay.value;
                var inType=obj.inType.value;
                var outType=obj.outType.value;

                var doorInfo={
                    ctrlerSN:$('#ctrlerSN').val(),
                    doorID:doorID,
                    doorName:doorName,
                    onUse:doorOnUse,
                    doorCtrlWay:doorCtrlWay,
                    doorDelay:doorDelay,
                    inType:inType,
                    outType:outType,
                }
                doorInfos.push(doorInfo);
            }
            $.ajax({
                url: "/wgAccessDevDoorSet",
                type: "POST",
                async: false,//同步
                contentType: 'application/json',
                data: JSON.stringify(doorInfos),
                dataType: "text",
                success: function (res) {
                    console.log(JSON.stringify(doorInfos));
                    //window.parent.location.reload();//刷新父页面

                    var index = parent.layer.getFrameIndex(window.name); //获取当前窗口的name
                    parent.layer.close(index);//关闭当前页
                },error: function () {
                    layer.alert("设置失败");
                }
            });
            return false;
        })
    });

    //判断门是否启用
    function doorOrUse() {
        if ($('#doorOnUse').is(':checked')) {
            alert("选中");
            $("#doorOnUse").value = 1;
        }else{
            $("#doorOnUse").value = 0;
        }
    }

    //判断控制器是否启用
    function devOrUse() {
        if(document.getElementById("devOnUse").checked){
            alert("选中");
            document.getElementById("devOnUse").value = 1;
        }else{
            document.getElementById("devOnUse").value = 0;
        }
    }
</script>
<%--<script>


    layui.use(['form', 'element', 'laydate', 'upload'], function () {
        var form = layui.form
            , laydate = layui.laydate
            , $ = layui.jquery;

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

        //监听提交
        var form = layui.form,
            layer = layui.layer,
            table = layui.table,
            $ = layui.$;

        &lt;%&ndash;<c:forEach items="${WGDoordevList}" var="item">
            var doorDelay=$('##{item.doorID}+"doorDelay"').val();
        </c:forEach>&ndash;%&gt;

        &lt;%&ndash;var list=[];&ndash;%&gt;
        &lt;%&ndash;list=${WGDoordevList};&ndash;%&gt;
        &lt;%&ndash;for(var i=0;i<list.length;i++){&ndash;%&gt;
        &lt;%&ndash;    var doorDelay=$('#doorDelay').val();&ndash;%&gt;
        &lt;%&ndash;}&ndash;%&gt;

        var temp={
            doorDelay:$('#doorDelay').val()
        }
        form.on('submit(demo2)', function (data) {
            $.ajax({
                url: "/wgAccessDevDoorSet",
                type: "POST",
                async: false,//同步
                contentType: 'application/json',
                data: JSON.stringify(data.field),
                dataType: "text",
                success: function (res) {
                    console.log(JSON.stringify(data.field));
                    //window.parent.location.reload();//刷新父页面
                    layer.msg(res.msg);
                    var index = parent.layer.getFrameIndex(window.name); //获取当前窗口的name
                    parent.layer.close(index);//关闭当前页
                }
            });
            return false;
        })
    });

</script>--%>
</html>
