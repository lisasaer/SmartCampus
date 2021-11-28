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
<html>
<head>
    <title>首页</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
</head>
<body class="layui-layout-body">
<!-- 引入 echarts.js -->
<script src="https://cdn.staticfile.org/echarts/4.3.0/echarts.min.js"></script>
<div class="layui-layout layui-layout-admin">
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <jsp:include page="../header/topHead.jsp"></jsp:include>
    <div class="layui-body">
        <div class="layui-col-md9" >
            <div class="layui-row" style="background: #eee;font-size: 30px;height: 60px;padding-left: 400px;background: #1f637b">
                智慧校园用电安全和用电管理平台
            </div>
        </div>

        <div class="layui-col-md3" style="background: #1f637b;">
            <div>
                <fieldset class="layui-elem-field layui-field-title" style="margin-top: 50px;width:425px ;height: 20px">
                    <legend>分类能耗统计</legend>
                </fieldset>
            </div>
            <div style="height: 300px;width: 425px;background: #7F9DB9;padding-left: 10px;padding-top: 10px">
                <div>
                    <div class="layui-col-md9">
                        <label>空调用电</label>
                        <div style="height: 90px;" class="layui-col-md3" >
                            <img src="../res/image/mainPage-airCondition.jpg" style="width: 70px;height: 70px;">
                        </div>
                        <div class="layui-col-md9" style="font-size:xx-large;color: #0E2D5F">
                            <label>3863</label>
                            <label > kwh</label>
                        </div>
                    </div>
                    <div class="layui-col-md3">跟同期比上涨20%</div>
                </div>
                <hr>
                <div>
                    <div class="layui-col-md9">
                        <label>照明用电</label>
                        <div style="height: 90px;" class="layui-col-md3" >
                            <img src="../res/image/mainPage-airSwitch.jpg" style="width: 70px;height: 70px;">
                        </div>
                        <div class="layui-col-md9" style="font-size:xx-large;color: #0E2D5F">
                            <label id="light"></label>
                            <label > kwh</label>
                        </div>
                    </div>
                    <div class="layui-col-md3">
                        <label >跟昨日比</label>
                        <label id="zero"></label>
                        <label id="up"></label>
                    </div>
                </div>
                <hr>
                <div>
                    <div class="layui-col-md9">
                        <label>其他用电</label>
                        <div style="height: 90px;" class="layui-col-md3" >
                            <img src="../res/image/mainPage-Other.jpg" style="width: 70px;height: 70px;">
                        </div>
                        <div class="layui-col-md9" style="font-size:xx-large;color: #0E2D5F"><label>3863</label><label > kwh</label></div>
                    </div>
                    <div class="layui-col-md3">跟同期比上涨20%</div>
                </div>
            </div>
            <div>
                <fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;width:415px ;height: 20px">
                    <legend>设备报警类型分布</legend>
                </fieldset>
            </div>
            <div style="height: 360px;width: 415px">
                <div class="layui-col-md9" style="height:365px;width: 425px" id ="chart2"></div>
            </div>
        </div>
    </div>

</div>
</body>

<script>

    var dom2 = document.getElementById('chart2');//报警类型分布图
    var Chart2 = echarts.init(dom2);

    /*$.ajax({
        type:"get",
        async:true,
        url:"lightEnergyConsumption",
        success:function(data){

            $("#light").append('123');
        }
    });*/
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
            Chart2.setOption(option);
        }
    });

</script>
</html>
