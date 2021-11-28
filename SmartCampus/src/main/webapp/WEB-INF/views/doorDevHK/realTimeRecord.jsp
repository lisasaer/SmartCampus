<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
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
    <title>Title</title>
    <!-- layui -->
    <jsp:include page="../header/res.jsp"></jsp:include>
    <%--<jsp:include page="../header/res.jsp"></jsp:include>--%>
    <style>
        .div-title{
            display: inline-block;
            vertical-align: top;
        }
        .div-btn-close{
            float: right;
            vertical-align: top;
            display: inline-block;
            text-align: right
        }
        .layui-form-item{
            height: 38px;

            margin-bottom: 5px;
        }

    </style>
</head>
<body style="height: 340px;margin-right: 20px;margin-left: 10px" >

<form class="layui-form layui-form-pane" name="form1" action="">

    <%--    <div style="float:right;margin-right: 20px;margin-top: 15px;">--%>

    <%--        <input type="text" id="photo" name="photo" style="display:none">--%>
    <%--        <div class="layui-upload-list" style="width: 2.5cm;height: 3.5cm;border: 1px solid #f0f0f0;overflow: hidden;position: relative;">--%>
    <%--            <p id="demoText"></p>--%>
    <%--            <img class="layui-upload-img" id="imageId" style="width: 2.5cm;height: 3.5cm;" src="${list[0].imagePath}">--%>
    <%--        </div>--%>
    <%--    </div>--%>


    <%--    <div style="margin-left:15px; margin-top:15px ; /*display: inline-block ;*//*width: 710px*/">--%>
    <%--        &lt;%&ndash;    <fieldset class="layui-elem-field layui-field-title">&ndash;%&gt;--%>
    <%--        &lt;%&ndash;        <legend>查看人员信息</legend>&ndash;%&gt;--%>
    <%--        &lt;%&ndash;    </fieldset>&ndash;%&gt;--%>

    <%--        <c:forEach var="list" items="${list}" varStatus="row">--%>

    <%--            <div class="layui-form-item" style="float: left">--%>
    <%--                <label class="layui-form-label">编号</label>--%>
    <%--                <div class="layui-input-inline">--%>
    <%--                    <input type="text" name="staffId" lay-verify="required" value="${list.staffId}" utocomplete=""--%>
    <%--                           class="layui-input" readonly="readonly">--%>
    <%--                </div>--%>
    <%--            </div>--%>

    <%--            <div style="float: right">--%>
    <%--                <label class="layui-form-label">卡号</label>--%>
    <%--                <div class="layui-input-inline">--%>
    <%--                    <input type="text" name="cardNo" lay-verify="required" value = "${list.cardNo}" placeholder="" autocomplete="off"--%>
    <%--                           class="layui-input" readonly="readonly">--%>
    <%--                </div>--%>
    <%--            </div>--%>

    <%--            <div class="layui-form-item" style="float: left">--%>
    <%--                <label class="layui-form-label">姓名</label>--%>
    <%--                <div class="layui-input-inline">--%>
    <%--                    <input type="text" name="name" lay-verify="required" value = "${list.name}" placeholder="" autocomplete="off"--%>
    <%--                           class="layui-input" readonly="readonly">--%>
    <%--                </div>--%>
    <%--            </div>--%>
    <%--            &lt;%&ndash;            <input value="${list.dname}">&ndash;%&gt;--%>
    <%--            <div style="float: right">--%>
    <%--                <label class="layui-form-label">部门</label>--%>
    <%--                <div class="layui-input-inline">--%>
    <%--                    <input type="text" name="departentId" lay-verify="required" value = "${list.dname}" placeholder="" autocomplete="off"--%>
    <%--                           class="layui-input" readonly="readonly">--%>
    <%--                </div>--%>
    <%--            </div>--%>

    <%--            <div class="layui-form-item" style="float: left">--%>
    <%--                <label class="layui-form-label">性别</label>--%>
    <%--                <div class="layui-input-inline">--%>
    <%--                    <input type="text" name="sex" lay-verify="required" value = "${list.sex}" placeholder="" autocomplete="off"--%>
    <%--                           class="layui-input" readonly="readonly">--%>
    <%--                </div>--%>
    <%--            </div>--%>

    <%--            <div style="float: right">--%>
    <%--                <label class="layui-form-label">刷卡时间</label>--%>
    <%--                <div class="layui-input-inline">--%>
    <%--                    <input type="text" name="alarmTime" id="alarmTime" lay-verify="required" value="${list.alarmTime}" placeholder="" utocomplete="off"--%>
    <%--                           class="layui-input" readonly="readonly">--%>
    <%--                </div>--%>
    <%--            </div>--%>

    <%--            <div class="layui-form-item" style="float: left">--%>
    <%--                <label class="layui-form-label">出生日期</label>--%>
    <%--                <div class="layui-input-inline">--%>
    <%--                    <input type="text" name="birth" lay-verify="required" value = "${list.birth}" placeholder="" autocomplete="off"--%>
    <%--                           class="layui-input" readonly="readonly">--%>
    <%--                </div>--%>
    <%--            </div>--%>
    <%--            <div style="float: right">--%>
    <%--                <label class="layui-form-label">设备IP</label>--%>
    <%--                <div class="layui-input-inline">--%>
    <%--                    <input type="text" name="devIP" id="devIP" lay-verify="required" value="${list.devIP}" placeholder="" utocomplete="off"--%>
    <%--                           class="layui-input" readonly="readonly">--%>
    <%--                </div>--%>
    <%--            </div>--%>

    <%--            <div class="layui-form-item" style="float: left;clear:both;">--%>
    <%--                <label class="layui-form-label">联系方式</label>--%>
    <%--                <div class="layui-input-inline">--%>
    <%--                    <input type="text" name="telphone" value = "${list.telphone}" lay-verify="required" placeholder=""--%>
    <%--                           autocomplete="off"--%>
    <%--                           class="layui-input" readonly="readonly">--%>
    <%--                </div>--%>
    <%--            </div>--%>
    <%--            <div style="float:right;height: 10px">--%>

    <%--                    &lt;%&ndash;<input type="text" id="photo" name="photo" value="photo">&ndash;%&gt;--%>
    <%--                <div class="layui-upload-list" style="margin: 0px;overflow: hidden;position: relative;">--%>
    <%--                    <p id="demoText"></p>--%>
    <%--                    <img class="layui-upload-img" id="imageId" style="width: 291px;" src="${list.imagePath}">--%>
    <%--                </div>--%>
    <%--            </div>--%>


    <%--            <div class="layui-form-item" style="float: left;clear:both;">--%>
    <%--                <label class="layui-form-label">邮箱</label>--%>
    <%--                <div class="layui-input-inline">--%>
    <%--                    <input type="text" name="email" id="email" value="${list.email}" lay-verify="required" placeholder="" utocomplete="off"--%>
    <%--                           class="layui-input" readonly="readonly">--%>
    <%--                </div>--%>
    <%--            </div>--%>
    <%--            <div class="layui-form-item" style="float: left">--%>
    <%--                <label class="layui-form-label">QQ</label>--%>
    <%--                <div class="layui-input-inline">--%>
    <%--                    <input type="text" name="qq" id="qq" lay-verify="required" value="${list.qq}" placeholder="" utocomplete="off"--%>
    <%--                           class="layui-input" readonly="readonly">--%>
    <%--                </div>--%>
    <%--            </div>--%>



    <%--            &lt;%&ndash;        <div class="layui-form-item">&ndash;%&gt;--%>
    <%--            &lt;%&ndash;            <label class="layui-form-label">职务</label>&ndash;%&gt;--%>
    <%--            &lt;%&ndash;            <div class="layui-input-inline">&ndash;%&gt;--%>
    <%--            &lt;%&ndash;                <input type="text" name="positionId" lay-verify="required" value = "" placeholder="修改职务" autocomplete="off"&ndash;%&gt;--%>
    <%--            &lt;%&ndash;                       class="layui-input" readonly="readonly">&ndash;%&gt;--%>
    <%--            &lt;%&ndash;            </div>&ndash;%&gt;--%>
    <%--            &lt;%&ndash;        </div>&ndash;%&gt;--%>







    <%--        </c:forEach>--%>






    <%--    </div>--%>
</form>
<%--<div class="div-title">--%>
<%--    <h1>详情</h1>--%>
<%--</div>--%>
<%--<div class="div-btn-close">--%>
<%--    <button style="width: 30px;height: 30px" onclick="closeFrame()">X</button>--%>
<%--</div>--%>
<table id="test" lay-filter="test"></table>
</body>
<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail">详情</a>
</script>
<script>
    var table;
    $(function () {
        var list = '${list}' ;
    });

    function closeFrame(){
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        parent.layer.close(index);
    }

    layui.use('table', function() {
        table = layui.table;
        //表格渲染
        table.render({
            elem: '#test'
            ,id:'test'
            , title: '详情'
            , height: '540'
            , cols: [[
                // {type: 'checkbox', fixed: 'left'}
                {type: 'numbers', title: '序号', fixed: 'left'}
                // ,{field: 'id', title: 'ID', style:'display:none',width:1}
                , {field: 'schoolName', title: '校区', width: 90,align: 'center'}
                , {field: 'houseName', title: '楼栋', width: 90,align: 'center'}
                , {field: 'floorName', title: '楼层', width: 90,align: 'center'}
                , {field: 'roomName', title: '房号', width: 90,align: 'center'}
                , {field: 'staffId', title: '编号', width: 120,align: 'center'}
                , {field: 'staffName', title: '人员姓名', width: 90,align: 'center'}
                , {field: 'cardNo', title: '卡号', width: 120,align: 'center'}
                , {field: 'strAlarmTime', title: '刷卡时间', width: 180,align: 'center'}
                , {field: 'devIP', title: '设备IP', width: 120,align: 'center'}
                // , {field: 'dname', title: '所属部门', width: '130',align: 'center'}
                , {field: 'imagePath', title: '抓拍图片', width:90,align: 'center',templet:'#img',event:'previewImg'}
                , {fixed: 'right', title: '操作', toolbar: '#barDemo', width: 90,align: 'center'}

            ]]
            ,data:${list}
            ,done: function(res, curr, count){
                // $('[data-field="id"]').addClass('layui-hide');
                $('.layui-form-checkbox').css('margin-top','5px');
            }
            ,page:true
            ,limits:[10,20,50,100]
            ,limit:20
        });
        table.on('tool(test)', function (obj) {
            var data = obj.data;
            if(obj.event === "previewImg"){
                layer.open({
                    type: 1,
                    title: false,
                    area: ['auto'],
                    closeBtn:0,
                    skin:'layui-layer-nobg',//没有背景色
                    shadeClose:true,
                    content:'<img src = "'+data.imagePath+'">'
                });
            }else if(obj.event === "detail"){
                layer.open({
                    type: 2,
                    zIndex:999,
                    title: '详情',
                    area: ['670px', '380px'],
                    btn: ['返回'],
                    content: 'recordHistoryView?id='+data.id
                    ,success: function(layero, index) {
                        layer.iframeAuto(index);
                    }
                });
            }
        })
    })


</script>
<script type="text/html" id="img">
    <div><img src="{{d.imagePath}}" style="width:30px;height:30px"></div>
</script>
</html>
