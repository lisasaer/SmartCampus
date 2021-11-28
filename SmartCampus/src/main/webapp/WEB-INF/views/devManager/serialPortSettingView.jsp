<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>串口设置</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        button:disabled{
            background-color: #ccc;
            cursor: default;
        }

    </style>
</head>
<body style="padding: 0 20px">
    <div style="text-align: center;position: relative;top: 50%;left:50%;transform: translate(-50%,-50%)">
        <form class="layui-form">
            <div class="layui-form-item">
                <label class="layui-form-label" >串口</label>
                <div class="layui-input-inline">
                    <select id="comName">
                        <c:forEach items="${comNameList}" var="vvv">
                            <option value="${vvv}">${vvv}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="layui-form-item">
                <label  class="layui-form-label">波特率</label>
                <div class="layui-input-inline">
                    <select id="btlConnect">
                        <option value="9600">9600</option>
                        <option value="19200">19200</option>
                    </select>
                </div>
            </div>
        </form>
        <div>
            <button <c:if test="${openState != false}">disabled</c:if>  id="btnOpenSerialPort" class="layui-btn" onclick="serialPortSetting('open')" >打开串口</button>
            <button <c:if test="${openState == false}">disabled</c:if> id="btnCloseSerialPort" class="layui-btn"  onclick="serialPortSetting('close')">关闭串口</button>
        </div>
    </div>
</body>
<script>
    var form ;
    layui.use('form', function(){
        form = layui.form;
    });
</script>
<script>
    var openState = ${openState};
    $(function () {
        if(openState){
            var comName = '${comName}';
            $('#comName').val(comName);

            selectEnable(false);
        }
    });

    function selectEnable(bOk) {
        if(bOk){
            $('#comName').removeAttr('disabled');
            $('#btlConnect').removeAttr('disabled');
        }else {
            $('#comName').attr('disabled','');
            $('#btlConnect').attr('disabled','');
        }
        form.render('select');
    }

    function serialPortSetting(msg) {
        var data = {};
        data.comName = $('#comName').val();
        data.btl = $('#btlConnect').val();
        data.msg = msg;
        console.log(data);

        $.post('serialportSetting',{data:JSON.stringify(data)},function (res) {
            if(Number(res.code) > 0) {
                openState = !openState;
                if (openState) {
                    $('#btnCloseSerialPort').removeAttr('disabled');
                    $('#btnOpenSerialPort').attr('disabled', '');

                    selectEnable(false);
                } else {
                    $('#btnOpenSerialPort').removeAttr('disabled');
                    $('#btnCloseSerialPort').attr('disabled', '');

                    selectEnable(true);
                }
            }
            MyUtil.msg(res.msg);
        });
    }


</script>
</html>
