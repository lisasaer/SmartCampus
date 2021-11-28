<%--
  Created by IntelliJ IDEA.
  User: zy-dzb
  Date: 2021/7/30
  Time: 15:31
  To change this template use File | Settings | File Templates.
  设备详情页
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="th" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <!-- layui -->
    <%--    <link rel="stylesheet" type="text/css" href="/res/layui/css/layui.css">--%>
    <%--    <script type="text/javascript" src="/res/layui/layui.js"></script>--%>
    <%--    <script src="res/js/jquery.min.js"></script>--%>
    <%--    <script src="res/js/myjs.js" ></script>--%>


    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes"/>
    <jsp:include page="../header/res.jsp"></jsp:include>
    <link rel="stylesheet" type="text/css" href="/res/css/jquery.classycountdown.css"/>
    <%--    <link rel="stylesheet" type="text/css" href="/res/css/default.css">--%>
    <style>
        /*去除table顶部栏标签*/
        .layui-table-tool-self {
            display: none;
        }

        /*去除table表单外边距*/
        .layui-table, .layui-table-view {
            margin: 0;
        }

        /*table表单主体*/
        .layui-table-box {
            background-color: white;
            top: 12px;
            padding-left: 20px;
            padding-right: 20px;
        }

        /* 处理勾选框上移*/
        .layui-table-cell .layui-form-checkbox[lay-skin=primary] {
            top: 0;
            bottom: 0;
        }

        .layui-table-view .layui-form-checkbox[lay-skin=primary] i {
            width: 15px;
            height: 15px;
            border-color: #d2d2d2;
        }

        /*勾选框中被选中*/
        .layui-form-checked[lay-skin=primary] i {
            border-color: #1666f9 !important;
            background-color: #1666f9;
            color: #fff;
            /*background: url('../../res/layui/images/dev_icon/checked.png');*/
        }

        /*勾选框中未被选中*/
        .layui-form-checkbox[lay-skin=primary] i {
            /*border-color: #1666f9!important;
            background-color: #1666f9;*/
            color: #fff;
            width: 12px;
            height: 12px;
            /*background: url('../../res/layui/images/dev_icon/checkbox.png');*/
        }

        /*条件查询-下拉框*/
        .layui-form-select {
            width: 140px;
        }

        .layui-select-title input {
            height: 32px;
            width: 140px;
        }

        /*下拉框中被选中的颜色*/
        .layui-form-select dl dd.layui-this {
            background-color: #1666f9;
        }

        /*去除下拉框中layui的自带箭头*/
        .layui-form-select .layui-edge {
            display: none;
        }

        /*下拉框箭头图片*/
        .layui-select-title input {
            background: url('../../res/layui/images/dev_icon/arrow_down_icon.png') no-repeat scroll 117px center transparent;
        }

        /*点击后的下拉框箭头图片*/
        .layui-form-selected .layui-select-title input {
            background: url('../../res/layui/images/dev_icon/arrow_up_icon.png') no-repeat scroll 117px center transparent;
        }

        /*去除条件查询内边距*/
        .layui-table-tool-temp {
            padding: 0;
        }

        /*条件查询框*/
        .layui-table-tool {
            background-color: white;
            height: 55px;
            border-width: 0;
            padding-left: 20px;
            padding-right: 20px;
        }

        /* table 表头背景色*/
        .layui-table thead tr, .layui-table-header {
            background-color: white;
            border-width: 0;
            color: #999999;
        }

        /*table 表头字体大小*/
        .layui-table thead tr th {
            font-size: 16px;
        }

        .layui-table td, .layui-table th {
            border-width: 0px;
        }

        /*table 每行数据顶部线*/
        .layui-table tr {
            /*border-width: 1px;*/
            border-style: solid;
            border-color: #e6e6e6;
            border-top-width: 1px;
            border-right-width: 0px;
            border-bottom-width: 0px;
            border-left-width: 0px;
            height: 40px;
        }

        /*按钮样式*/
        .layui-btn {
            font-family: "Microsoft Ya Hei";
            font-size: 14px;
            color: #feffff;
            width: 80px;
            line-height: 32px;
            background-color: #1666f9;
            height: 32px;
            border-radius: 5px;
            border: none;
        }

        /*table表单序号靠左显示*/
        .laytable-cell-numbers {
            text-align: left;
            height: 16px;
            line-height: 16px;
            padding: 0 15px;
        }

        /*table表头字体div高度*/
        .layui-table-cell {
            height: 16px;
            line-height: 16px;
        }

        /*分页栏页数背景色*/
        .layui-laypage .layui-laypage-curr .layui-laypage-em {
            background-color: #1666f9;
        }

        /*分页栏背景色*/
        .layui-table-page {
            background-color: white;
            border-width: 0;
            text-align: center;
        }

        /*去除分页*/
        .layui-laypage .layui-laypage-limits, .layui-laypage .layui-laypage-refresh {
            display: none;
        }

        .ClassyCountdown-seconds {
            width: 100%;
            line-height: 1em;
            position: absolute;
            text-align: center;
            left: 0;
            display: block;
        }

        .ClassyCountdown-value {
            width: 100%;
            line-height: 1em;
            position: absolute;
            top: 50%;
            text-align: center;
            left: 0;
            display: block;
            /*  color:#2c394a;
              font-size:14px;*/
        }

        .blue {
            color: rgba(30, 137, 255, 0.78);
        }
    </style>
    <%--    <style>--%>
    <%--        .ClassyCountdownDemo { margin:0 auto 30px auto; max-width:800px; width:calc(100%); padding:30px; display:block }--%>
    <%--        #countdown8 { background:#222 }--%>
    <%--    </style>--%>
</head>
<body style="background: #F2F2F2;border-radius: 8px;">
<div style="text-align:center;font-size: 15px;margin: 5px">
    <label style="margin-left: 20px; ">设备数量：</label>
    <label id="devCount" style="margin-left: 5px;color: rgba(25,81,255,0.78)">${devCount}</label>
    <label style="margin-left: 20px">在线数量：</label>
    <label id="devOnlineCount" style="margin-left: 5px;color: rgba(21,217,0,0.38)">${devOnlineCount}</label>
    <label style="margin-left: 20px">离线数量：</label>
    <label id="devOfflineCount" style="margin-left: 5px;color: rgba(255,154,34,0.42)">${devOfflineCount}</label>
</div>
<%--数据展示--%>
<div id="zigBeeGatewayDevInfoList"></div>
<%--分页条展示--%>
<div id="page"
     style="background-color: #FFFFFF;width:1200px;text-align: center;padding-left:10px;position: fixed;bottom: 0;"></div>
</body>
<script id="devDisplay" type="text/html">
    <div style="margin-left: 15px">
        {{# layui.each(d, function(index, item){ }}
        <div style="border-radius: 8px;display: inline-block;margin: 6px;padding: 6px;background-color: #FFFFFF"
             onclick="devItemClick(this)">
            <div id="devId" name="devId" style="display:none">{{item.devId}}</div>

            <div class="layui-inline" style="text-align: center;width: 265px;color: #333333;font-size: 12px">
                <div name="online_icon" style='display: inline-block;text-align: center'>
                    <%--  {{# layui.each(item.devInfoEps, function(index, devInfoEp){ }}--%>
                    <img src='../../res/layui/images/zigBee_dev_icon/online_{{item.ol}}_icon.png'>
                    <%--   {{# }); }}--%>
                </div>

                <label name="ol" style="margin-left: 3px">{{item.ol=="true"?"在线":"离线"}}</label>
                <label id="note" name="note" style="margin-left: 130px ">{{item.note}}</label>
            </div>
            <div style="margin-top: 5px;margin-left: 5px;color: #333333">
                <div name="devImage" style="display: inline-block;text-align: center">

                    <img src="../../res/layui/images/zigBee_dev_icon/{{item.note}}_{{item.st.on}}.png">
                </div>
                <div name="region" style="display: inline-block;float: right;margin-top: 30px">
                    <label style="display: inline-block;font-size: 14px">{{item.school}}</label><label
                        style="margin-right: 40px">{{item.house}}</label>
                    <div style="margin-top: 10px">
                        <label>{{item.floor}}</label> <label style="margin-right: 20px">{{item.room}}</label>
                    </div>
                    <label style="float: right;margin-top: 20px;font-size: 12px; margin-right: 10px;">{{item.dn}}</label>
                </div>


            </div>

        </div>
        {{# }); }}
    </div>
</script>

<script>

    //启动webScoket
    $(function () {
        WebSocketTest('refreshZigBeeView');
    });

    var laytpl;
    layui.use(['element', 'table', 'laypage', 'laytpl'], function () {
        var element = layui.element;
        // table = layui.table;
        var laypage = layui.laypage;
        laytpl = layui.laytpl;


        //执行一个laypage实例
        laypage.render({
            elem: 'page' //注意，这里的 test1 是 ID，不用加 # 号
            , count: ${devCount}//数据总数，从服务端得到
            , limit: 16
            , curr: 1                        //起始页
            , limits: [5, 10, 20, 30]
            , prev: '<'
            , next: '>'
            , layout: ['prev', 'page', 'next', 'skip', 'count', 'limits']
            , jump: function (obj, first) { //obj为当前页的属性和方法，第一次加载first为true
                console.info("当前页，显示条数");
                console.info(obj.curr);
                console.info(obj.limit);

                //调用函数封装参数，加载数据
                showData(obj.curr, obj.limit);

            }

        });


    });

    function showData(page, limit) {
        // 模版引擎导入
        var html = $('#devDisplay').html()
            , element = document.getElementById('zigBeeGatewayDevInfoList');
        // var element = $('#zigBeeGatewayDevInfoList');
        $.ajax({
            url: "/selectZigBeeDev",
            type: "POST",
            async: false,//同步
            data: {"page": page, "limit": limit, "zigbeeId": '${zigbeeId}'},
            success: function (res) {
                console.info("查询的设备数据");
                console.info(res);
                // var template = laytpl(html),
                // result = template.render(res);
                // element.innerHTML = result
                laytpl(html).render(res, function (html) {
                    element.innerHTML = html;
                });

                //更改文字颜色
                var list = document.getElementsByName("ol");
                console.info(list);
                for (var i = 0; i < list.length; i++) {
                    var ol = list[i].innerText;
                    if (ol == '在线') {
                        $('[name="ol"]').eq(i).css("color", " rgba(21,217,0,0.38)");
                        $('[name="note"]').eq(i).css("color", "rgba(25,81,255,0.78)");

                    } else {
                        $('[name="ol"]').eq(i).css("color", "rgba(255,154,34,0.42)");
                        $('[name="note"]').eq(i).css("color", "#BDBDBD");
                        $('[name="region"]').eq(i).css("color", "#BDBDBD");
                        // $('[name="online_icon"]').eq(i).html("<img src='../../res/layui/images/zigBee_dev_icon/offline_icon.png'>");
                    }
                }

                console.info(res.length);

                //更换页面图片
                var on;
                var ep;
                var devId;
                var note;
                var ol;
                for (var i = 0; i < res.length; i++) {
                    switch (res[i].note) {
                        case "双开关面板":
                            if ("null" != res[i].devInfoEps) {
                                for (var j = 0; j < res[i].devInfoEps.length; j++) {
                                    ep = res[i].devInfoEps[j].ep;
                                    on = res[i].devInfoEps[j].st.on;
                                    note = res[i].note;
                                    devId = res[i].devId;
                                    var devList = document.getElementsByName("devId");
                                    for (var k = 0; k < devList.length; k++) {
                                        if (devId == devList[k].innerText) {
                                            var htmlImg = $('[name="devImage"]').eq(k).html();
                                            if (j == 0) {
                                                htmlImg = "";
                                                htmlImg += "<img  src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_" + ep + "_" + on + "_small.png\">";
                                            } else {
                                                htmlImg += "<img style=\"margin-left:-1px;\" src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_" + ep + "_" + on + "_small.png\">";
                                            }
                                            $('[name="devImage"]').eq(k).html(htmlImg);
                                        }
                                    }
                                }
                            }
                            break;
                        case "三开关面板":
                            if ("null" != res[i].devInfoEps) {
                                for (var j = 0; j < res[i].devInfoEps.length; j++) {
                                    ep = res[i].devInfoEps[j].ep;
                                    on = res[i].devInfoEps[j].st.on;
                                    note = res[i].note;
                                    devId = res[i].devId;
                                    var devList = document.getElementsByName("devId");
                                    for (var k = 0; k < devList.length; k++) {
                                        if (devId == devList[k].innerText) {
                                            var htmlImg = $('[name="devImage"]').eq(k).html();
                                            if (j == 0) {
                                                htmlImg = "";
                                                htmlImg += "<img  src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_" + ep + "_" + on + "_small.png\">";
                                            } else {
                                                htmlImg += "<img style=\"margin-left:-2px;\" src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_" + ep + "_" + on + "_small.png\">";
                                            }
                                            $('[name="devImage"]').eq(k).html(htmlImg);
                                        }
                                    }
                                }
                            }
                            break;
                        case "人体红外":
                            note = res[i].note;
                            devId = res[i].devId;
                            ol = res[i].ol;
                            var zsta = res[i].st.zsta;
                            var devList = document.getElementsByName("devId");
                            for (var k = 0; k < devList.length; k++) {
                                if (devId == devList[k].innerText) {
                                    var htmlImg = "";
                                    if (null != zsta) {
                                        htmlImg += "<img src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_" + zsta + "_" + ol + "_small.png\">";
                                    }else {
                                        htmlImg += "<img src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_" +"false.png\">";
                                    }
                                    $('[name="devImage"]').eq(k).html(htmlImg);
                                }
                            }
                            break;
                        case "环境盒子":
                            ol = res[i].ol;
                            note = res[i].note;
                            devId = res[i].devId;
                            var mtemp = res[i].st.mtemp;
                            var tempTenNum = 0;   //十位
                            var tempUnitNum = 0;  //个位
                            var tempPointNum = 0;  //分位
                            if (null != mtemp && "" != mtemp) {
                                tempTenNum = mtemp.substring(0, 1);   //十位
                                tempUnitNum = mtemp.substring(1, 2);  //个位
                                tempPointNum = mtemp.substring(2, 3);  //分位
                                console.info("十位：" + tempTenNum + "   个位:" + tempUnitNum + "   分位" + tempPointNum);
                            }
                            var devList = document.getElementsByName("devId");
                            for (var k = 0; k < devList.length; k++) {
                                if (devId == devList[k].innerText) {
                                    var htmlImg = "";
                                    if ("true" == ol) {
                                        htmlImg += "<img style=\"position:relative;\"  src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_" + ol + "_small_bg.png\">";
                                        htmlImg += "<img style=\"position:absolute;margin-top: 40px;margin-left: -73px\"  src=\"../../res/layui/images/zigBee_dev_icon/before_" + tempTenNum + "_small.png\">"
                                        htmlImg += "<img style=\"position:absolute;margin-top: 40px;margin-left: -61px\"  src=\"../../res/layui/images/zigBee_dev_icon/before_" + tempUnitNum + "_small.png\">"
                                        htmlImg += "<img style=\"position:absolute;margin-top: 47px;margin-left: -47px\"  src=\"../../res/layui/images/zigBee_dev_icon/after_" + tempPointNum + "_small.png\">"
                                    } else {
                                        htmlImg += "<img src=\"../../res/layui/images/zigBee_dev_icon/" + note + "_" + ol + "_small.png\">";
                                    }
                                    $('[name="devImage"]').eq(k).html(htmlImg);
                                }
                            }
                            break;
                        default:
                            break
                    }

                }

            },
            error: function (res) {
                console.log("获取数据失败");
                console.log(res);
            }
        });


    }


    function devItemClick(Obj) {
        //获取item的设备devId
        console.info("设备Id：" + $(Obj).find('div[id=devId]').html());
        var devId = $(Obj).find('div[id=devId]').html();
        var note = $(Obj).find('label[id=note]').html();
        layer.open({
            type: 2,
            title: note,
            area: ['360px', '430px'],
            shade: 0.8,
            shadeClose: true,
            btn: ['确认', '取消'],
            content: 'goZigBeeDevEdit?devId=' + devId
            , success: function (layero, index) {
                <%--var body = layer.getChildFrame('body', index);--%>
                <%--var zigBeeDevForm = body.find('#zigBeeDevForm');--%>
                <%--console.info("设备信息：");--%>
                <%--console.log(${zigBeeGatewayDevInfo});--%>
                <%--formUtilEL.fillFormData(zigBeeDevForm, ${requestScope.zigBeeGatewayDevInfo});--%>
            }, yes: function (index, layero) {
                var body = layer.getChildFrame('body', index);
                var zigBeeDevForm = body.find('#zigBeeDevForm');
                var formData = formUtilEL.serializeObject(zigBeeDevForm);
                console.info("需要修改的信息");
                console.log(formData);

                var devId = formData.devId;
                console.info("ep个数:" + formData.ep.length);
                var ep = new Array();
                var dn = new Array();
                if (formData.ep.length <= 1) {
                    ep[0] = formData.ep;
                    dn[0] = formData.dn;
                } else {
                    for (var i = 0; i < formData.ep.length; i++) {
                        ep.push(formData.ep[i]);
                    }
                    for (var i = 0; i < formData.dn.length; i++) {
                        dn.push(formData.dn[i]);
                    }
                }

                console.info("ep和dn的值");
                console.info(ep);
                console.info(dn);
                var loading = layer.load(1, {shade: [0.1, '#fff']});
                $.ajax({
                    type: "POST",
                    url: 'editZigBeeDev',
                    async: true,
                    contentType: 'application/json',
                    dataType: "json",
                    // traditional: true, //深度序列化，保证传数组给后台时，key不会带上[]
                    // data:{"devId":devId,"ep":ep,"dn":dn}
                    data: JSON.stringify({"devId": devId, "ep": ep, "dn": dn})
                    , success: function (res) {
                        //请求并修改信息成功
                        if (res.code > 0) {
                            layer.close(index);
                            //重载遍历数据
                            showData(1, 16);
                        }
                        layer.msg(res.msg);
                        layer.close(loading);
                    },
                    error: function (e) {
                        //失败后回调
                        layer.msg('添加失败 ' + msg.status);
                        layer.close(loading);
                    }
                })

            }
        })
    }
</script>
<!--页面实时刷新-->
<script>
    var layer;
    layui.use(['layer'], function () {
        layer = layui.layer;
    });

    function WebSocketTest(wsPath) {
        if ("WebSocket" in window) {
            //alert("您的浏览器支持 WebSocket!");

            var hostName = window.location.hostname;
            var port = window.location.port;
            console.log("ws://" + hostName + ":" + port + "/" + wsPath);
            // 打开一个 web socket
            var ws = new WebSocket("ws://" + hostName + ":" + port + "/" + wsPath);
            ws.onopen = function () {
                console.log('ws 已连接');
            };
            ws.onmessage = function (evt) {
                console.log("WebSocket收到的消息:" + evt.data);
                if (evt.data == "StateChange") {
                    //重载遍历数据
                    showData(1, 16);
                }

            };
            ws.onclose = function () {
                // 关闭 websocket
                console.log("连接已关闭...");
            };
        } else {
            // 浏览器不支持 WebSocket
            console.log("您的浏览器不支持 WebSocket!");
        }
    }


</script>

</html>
