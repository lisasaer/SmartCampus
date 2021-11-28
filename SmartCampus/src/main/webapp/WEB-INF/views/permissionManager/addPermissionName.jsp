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
    <title>Title</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        .layui-form-label{
            width: 120px
        }
        .layui-input-block{
            margin-left: 130px;
            margin-right: 50px;
        }
        .layui-form-item{
            margin: 20px 0;
        }
        .bodyDiv{
            /*width: 300px;*/
        }
    </style>
</head>
<body>
<div class="bodyDiv">
    <form id="form1" class="layui-form">
        <div class="layui-form-item">
            <label class="layui-form-label">名称</label>
            <div class="layui-input-block">
                <input type="text" id="name"  name="name" lay-verify="required" autocomplete="off" placeholder="请输入权限名称" class="layui-input">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">模块</label>
            <div class="layui-input-block">
                <input type="checkbox" name="permission" title="设备管理" value="1" checked>
                <input type="checkbox" name="permission" title="空间管理" value="2" checked>
                <input type="checkbox" name="permission" title="系统配置" value="3" checked>
                <input type="checkbox" name="permission" title="视频监控" value="4" checked>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <div class="layui-input-block">
                <input type="checkbox" name="permission" title="批量管理" value="5" checked>
                <input type="checkbox" name="permission" title="远程维护" value="6" checked>
                <input type="checkbox" name="permission" title="设备管理" value="7" checked>
                <input type="checkbox" name="permission" title="环境数据" value="8" checked>
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label"></label>
            <div class="layui-input-block">
                <input type="checkbox" name="permission" title="能耗统计" value="9" checked>
                <input type="checkbox" name="permission" title="用电安全" value="10" checked>
                <input type="checkbox" name="permission" title="使用时长" value="11" checked>
                <input type="checkbox" name="permission" title="门禁系统" value="12" checked>
            </div>
        </div>
    </form>
</div>
</body>

<script>
    var form ;
    layui.use('form', function(){
        form = layui.form;
    });

</script>
<script>


</script>
</html>
