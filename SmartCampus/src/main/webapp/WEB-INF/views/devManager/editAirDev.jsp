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
        <div class="layui-form-item ">
            <label class="layui-form-label">校区:</label>
            <div class="layui-input-block">
                <input type="text" name="school" lay-verify="required" autocomplete="off" placeholder="校区选择" class="layui-input"readonly="readonly"  style="background-color: #d7d7d7">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label">楼栋:</label>
            <div class="layui-input-block">
                <input type="text" name="house" lay-verify="required" autocomplete="off" placeholder="楼栋选择" class="layui-input"readonly="readonly"  style="background-color: #d7d7d7">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label">楼层:</label>
            <div class="layui-input-block">
                <input type="text" name="floor" lay-verify="required" autocomplete="off" placeholder="楼层选择" class="layui-input"readonly="readonly"  style="background-color: #d7d7d7">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label">房号:</label>
            <div class="layui-input-block">
                <input type="text" name="room" lay-verify="required" autocomplete="off" placeholder="房号选择" class="layui-input"readonly="readonly"  style="background-color: #d7d7d7">
            </div>
        </div>
        <div class="layui-form-item" style="width: auto">
            <label class="layui-form-label" style="text-align: right" >LORA序列号:</label>
            <div class="layui-input-block" >
                <input type="text" name="loraSN" lay-verify="required" autocomplete="off" placeholder="LORA序列号" class="layui-input"readonly="readonly"  style="background-color: #d7d7d7">
            </div>
        </div>

        <div class="layui-form-item ">
            <label class="layui-form-label">空调通讯地址</label>
            <div class="layui-input-block">
                <input <%--type="number"--%> name="uuid" id="uuid" <%-- min="1" max="247"--%> lay-verify="required" autocomplete="off" placeholder="空开通讯地址" class="layui-input" readonly="readonly" style="background-color: #d7d7d7">
            </div>
        </div>
        <div class="layui-form-item ">
            <label class="layui-form-label">空调名称</label>
            <div class="layui-input-block">
                <input type="text" name="devName" lay-verify="required" autocomplete="off" placeholder="请输入设备名称" class="layui-input">
            </div>
        </div>

    </form>
</div>
</body>