<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2019/11/22
  Time: 19:56
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>用户增加</title>
    <jsp:include page="../header/res.jsp"></jsp:include>
<%--    <style>--%>
<%--        .layui-form-label{--%>
<%--            width: 120px--%>
<%--        }--%>
<%--        .layui-input-block{--%>
<%--            margin-left: 130px;--%>
<%--            margin-right: 50px;--%>
<%--        }--%>
<%--        .layui-form-item{--%>
<%--            margin: 20px 0;--%>
<%--        }--%>
<%--        .bodyDiv{--%>
<%--            /*width: 300px;*/--%>
<%--        }--%>
<%--    </style>--%>
</head>
<body>

<div  style="width:90%;text-align: center; margin: 10px auto">
    <form id="form1">

        <div id="divMain" class="divLineBlock divMainCss">
            <div class="layui-form-item">
                <label class="layui-form-label">用户名</label>
                <div class="layui-input-block">
                    <input type="text" id="username"  name="username" lay-verify="required" autocomplete="off" placeholder="请输入姓名" class="layui-input">
                </div>
            </div>

            <div class="layui-form-item">
                <label class="layui-form-label">密码</label>
                <div class="layui-input-block">
                    <input id="password" type="text" name="password" lay-verify="required" autocomplete="off" placeholder="请输入密码" class="layui-input">
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">权限</label>
                <div class="layui-input-block">
                    <select name="type" lay-filter="select" title="权限选择" style="width:290px;height: 40px;" >
                        <option value="0">选择权限</option>
                        <c:forEach items="${permissionList}" var="v">
                            <option value="${v.id}">${v.name}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
        </div>
    </form>

</div>
</body>

<script>

</script>
</html>
