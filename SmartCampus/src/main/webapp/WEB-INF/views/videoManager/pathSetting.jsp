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
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Cache-Control" content="no-cache, must-revalidate" />
    <meta http-equiv="Expires" content="0" />

    <jsp:include page="../header/res.jsp"></jsp:include>
    <style>
        /*.layui-form-label{*/
        /*    width: 120px*/
        /*}*/
        /*.layui-input-block{*/
        /*    margin-left: 130px;*/
        /*    margin-right: 50px;*/
        /*}*/
        /*.layui-form-item{*/
        /*    margin: 20px 0;*/
        /*}*/
        /*.bodyDiv{*/
        /*    !*width: 300px;*!*/
        /*}*/
    </style>
</head>
<body>
    <div class="bodyDiv">
        <form id="form1" class="layui-form">

            <div class="layui-form-item " style="height:30px">
                <label style="width:100px;padding: 10px;margin-bottom: 20px;height: 50px">预览抓图保存路径</label>
                <div class="layui-input-block">

                        <td colspan="3"><input id="previewPicPath" type="text" class="txt" />&nbsp;<input type="button" class="btn" value="浏览" onclick="clickOpenFileDlg('previewPicPath', 0);" /></td>

                </div>
            </div>
            <div class="layui-form-item ">
                <label style="width:100px;padding: 10px;">录像文件保存路径</label>
                <div class="layui-input-block">
                    <input type="text" name="videoPath" lay-verify="required" autocomplete="off" placeholder="请输入录像文件保存路径" class="layui-input">
                </div>
            </div>
        </form>
    </div>
</body>

<script src="../res/websdk/jquery-1.7.1.min.js"></script>
<script src="../res/websdk/codebase/encryption/AES.js"></script>
<script src="../res/websdk/codebase/encryption/cryptico.min.js"></script>
<!-- <script src="../codebase/encryption/encryption.js"></script> -->
<script src="../res/websdk/codebase/encryption/crypto-3.1.2.min.js"></script>
<script id="videonode" src="../res/websdk/codebase/webVideoCtrl.js"></script>
<script src="../res/websdk/cn/demo.js"></script>
</html>
