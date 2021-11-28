<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <!-- layui -->
    <link rel="stylesheet" type="text/css" href="/res/layui/css/layui.css">
    <script type="text/javascript" src="/res/layui/layui.js"></script>
    <script src="res/js/jquery.min.js"></script>
    <script src="res/js/myjs.js" ></script>
    <script src="/res/js/formUtil.js"></script>

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
        .div-query-btn{
            margin: 10px;
        }
        .layui-table-tool-self{
            display: none;
        }
        .div-modify{
            position: absolute;
            top: 50%;
            left: 50%;
            width: 100%;
            height: 100%;
            transform: translate(-50%,-50%);
            padding: 30px;
            z-index: 9999;
            background-color: rgba(0,0,0,0.2);
        }
        .div-modify-view{
            border-radius: 10px;
            padding: 30px;
            opacity: 1;
            background-color: rgb(255,255,255);
            z-index: 99999;
            width: 50%;
            height:50%;
            position: relative;
            left: 50%;
            top: 50%;
            transform: translate(-50%,-50%);
        }
        .layui-form-label{
            width: 100px;
        }
    </style>
    <title>空开管理</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.5, maximum-scale=2.0, user-scalable=yes" />
    <%--<jsp:include page="header/res.jsp"></jsp:include>--%>
</head>
<body class="layui-layout-body">
<%--<ul class="layui-nav">
    <li class="layui-nav-item"><a href="/LoraDevManager">Lora网关管理</a></li>
    <li class="layui-nav-item"><a href="/SwitchDevManager">空开设备管理</a></li>
</ul>--%>
<div class="div-title">
    <h1>空开列表</h1>
</div>
<div class="div-btn-close">
    <button style="width: 30px;height: 30px" onclick="closeFrame()">X</button>
</div>

<div class="layui-layout layui-layout-admin">
    <!-- 头部区域（可配合layui已有的水平导航） -->
    <%--<jsp:include page="header/topHead.jsp"></jsp:include>--%>

    <div class="layui-body" style="padding: 15px;width: 80%;">
        <!-- 内容主体区域 -->
        <%--<div class="my-tree-div">
            <ul id="tt"></ul>
        </div>--%>

        <div class="my-tree-body-div">
            <button id="btnAddSwitchDev" class="layui-btn">添加空开设备</button>
            <%--<button id="btnSetDev" class="layui-btn">设置设备</button>--%>

            <button id="btnUpdateDev" class="layui-btn">刷新</button>
            <table id="test" lay-filter="test"></table>
        </div>
    </div>
    <%--<jsp:include page="header/footer.jsp"></jsp:include>--%>
</div>
</body>

<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>


<script>
    var table;
    $(function () {
        var list = '${switchDevinfo}' ;
        console.log("list"+list);
    });
    function closeFrame(){
        var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
        parent.layer.close(index);
    }
    var bOpen = false;
    var click=true;

    layui.use(['element','table'], function() {
        var element = layui.element;
        table = layui.table;
        //第一个实例
        table.render({
            id : 'test',
            elem: '#test'
            , height: 'full-220'
            //,width:'100%'
            //, url: 'getswitchDev' //数据接口
            , page: true //开启分页
            , cols: [[ //表头
                {type: 'checkbox', fixed: 'left'}
                ,{fixed: 'right', title:'操作', toolbar: '#barDemo', width:150}
                ,{type: 'numbers', title: '序号', fixed: 'left',event:'row'}
                // , {field: 'id', title: 'ID' , width : 150,event:'row'}
                , {field: 'loraSN', title: 'Lora序列号' , width : 150,event:'row'}
                , {field: 'uuid', title: '空开通讯地址' , width:150,event:'row'}
                , {field: 'switchGroupNum', title: '空开组数量' , width:100,event:'row'}
                , {field: 'sensortype', title: '设备类型' , width:100,event:'row'}
                , {field: 'devStatus', title: '设备在线状态' , width:150,event:'row'}
                , {field: 'intervaltime', title: '数据上报间隔(s)' , width:150,event:'row'}
                , {field: 'port', title: '设备端口' , width:100,event:'row'}
                , {field: 'chncnt', title: '设备通道数量' , width:150,event:'row'}
                , {field: 'chntype', title: '通道类型' , width:100,event:'row'}
            ]]
            , data:${switchDevinfo}
            , done: function (res, curr, count) {
                $('[data-field="id"]').addClass('layui-hide');
                $('.layui-form-checkbox').css('margin-top','5px')
            }
            ,limit:10
            ,limits:[10,15]
        });

        //监听行工具事件
        table.on('tool(test)', function(obj) {
            //console.log(obj)
            var data = obj.data;
            //console.log(data.uuid);
            if (obj.event === 'del') {
                layer.confirm('确定删除该设备？', function (index) {
                    var loading = layer.load(1, {shade: [0.1, '#fff']});
                    var temp = {
                        id:data.id
                        //,devSN:data.devSN
                    };
                    $.post('delSwitchDev',temp, function (res) {
                        layer.close(index);
                        layer.msg('删除成功');
                        reloadTb();
                    }).fail(function (xhr) {
                        layer.msg('删除失败 ' + xhr.status);
                        console.log(xhr.status);
                    }).always(function () {
                        layer.close(loading);
                    });
                });
            } else if (obj.event === 'edit') {
                layer.open({
                    type: 2,
                    title: '修改设备',
                    area: ['500px', '600px'],
                    fixed: false, //不固定
                    content: 'toSwitchDevUpdateView',
                    btn: ['确认', '取消'],
                    yes: function (index, layero) {
                        var body = layer.getChildFrame('body', index);
                        var form1 = body.find('#form1');
                        var newData = formUtilEL.serializeObject(form1);
                        //删除无用信息
                        // delete newData.switchGroupNum;
                        // delete newData.uuid;
                        // delete newData.devId;
                        // delete newData.intervaltime;
                        /*port
                        chncnt*/

                    newData.id = data.id;
                    console.log('newData', newData);
                    var loading = layer.load(1, {shade: [0.1, '#fff']});
                    $.post('updateswitchDev', newData,function (res) {
                        if (Number(res) > 0) {
                            layer.close(index);
                            layer.msg('修改成功');
                            reloadTb();
                        }
                    }).fail(function (xhr) {
                        layer.msg('修改失败' + xhr.status)
                    }).always(function () {
                        layer.close(loading);
                    });
                }
                , success: function (layero, index) {
                    var body = layer.getChildFrame('body', index);

                        var form1 = body.find('#form1');
                        console.log(form1);
                        formUtilEL.fillFormData(form1, data);
                        console.log(data);
                        console.log(formUtilEL);
                        var childWindow = $(layero.find('iframe'))[0].contentWindow;
                        console.log(childWindow);
                        childWindow.initModifyView(data);
                    }
                });
            }
            else if(obj.event === 'row'){
                console.log("data.devId:"+data.devId);
                layer.open({
                    type: 2,
                    title: false,
                    area: ['1000px', '623px'],
                    shade: 0.8,
                    closeBtn: 0,
                    shadeClose: true,
                    content: 'switchViewTest?devId='+data.devId
                    ,success: function(layero, index) {
                        layer.iframeAuto(index);
                    }
                });
            }
        })
    })
        //重载表格  刷新表格数据
    function reloadTb(){
        table.reload('test');
    }
    //添加空开设备
    $('#btnAddSwitchDev').click(function () {
        layer.open({
            type: 2,
            zIndex:999,
            title: '添加空开设备',
            area: ["800px", "600px"],
            //shade: 0,
            btn:['确定','取消'],
            //fixed: false, //不固定
            //closeBtn: 0,
            //shadeClose: true,
            content: 'toSwitchDevAddView',
            yes: function (index, layero) {
                var body = layer.getChildFrame('body', index);
                var form1 = body.find('#form1');
                var data = formUtilEL.serializeObject(form1);
                //console.log(data);
                for (var key in data) {
                    console.log(key, data[key]);
                    if (data[key] == null || data[key] == '') {
                        layer.msg('内容不能为空！');
                        layer.msg(body.find('[name="' + key + '"]').attr('不能为空！'));
                        return;
                    }
                }
                var loading = layer.load(1, {shade: [0.1, '#fff']});
                //console.log(data);
                $.post('addSwitchDev', data, function (res) {
                    console.log(Number(res.code));
                    if (Number(res.code) > 0) {
                        layer.close(index);
                        reloadTb();
                    }
                    layer.msg(res.msg);
                }).fail(function (xhr) {
                    layer.msg('添加失败 ' + xhr.status);
                }).always(function () {
                    layer.close(loading);
                });
            },success(layero, index) {
                //layer.iframeAuto(index);
                var body = layer.getChildFrame('body', index);

                var childWindow = $(layero.find('iframe'))[0].contentWindow;
                childWindow.initAddView();
            }
        })
    });

    //搜索按钮点击事件
        $('btnSelectSwitchDev').click(function(){
            layer.open({
                type: 2,
                title: false,
                area: ['1000px', '623px'],
                shade: 0.8,
                closeBtn: 0,
                shadeClose: true,
                content: 'switchDevSearch'
                ,success: function(layero, index) {
                    layer.iframeAuto(index);
                }
            });
        });

        //刷新页面
        $('#btnUpdateDev').click(function () {
            var loading = MyLayUIUtil.loading();
            console.log("主页刷新");
            $.post('updateDev',function (res) {

            }).fail(function (xhr) {
                console.log(xhr.status);
            }).always(function () {
                layer.close(loading);
            })
            reloadTB();
            MyLayUIUtil.closeLoading(loading);

        })

    $(function () {//页面完全加载完后执行

        /*防止重复提交  10秒后恢复*/
        var isSubmitClick = true;
        $('.layui-btn-sm').click(function () {
            if (isSubmitClick) {
                isSubmitClick = false;
                $('.layui-btn-sm').css("background-color", "red");
                // $("form:first").submit();//提交第一个表单
                $("form[name='form_month']").submit();
                setTimeout(function () {
                    $('.layui-btn-sm').css("background-color", "#3CBAFF");
                    isSubmitClick = true;
                }, 10000);
            }
        });
    });
    /*$(function () {
        let form = layui.form
            ,laydate = layui.laydate,
            laypage = layui.laypage,
            layer = layui.layer,
            table = layui.table;//非模块化加载相应的依赖
        //常规用法
        laydate.render({
            elem: '#test1'//日期框id
        });
        laydate.render({
            elem: '#test2'//日期框id
        });




        let i=1;//为了给后台传值方便记录每条记录的number值
        $('.add-btn').click(function () {
            i++;
            addstrs1(i);//增加一条内容函数
            form.render();//每次点击添加按钮就会重新渲染一次
            //这个并不能解决日期框的弹出但是可以让下拉选有效果
        });

        //下面整个是弹出询问框是否删除，
        $('body').on("click",".btn-del",function () {
            var pre = $(this);//这里获取点击当前行，就是要删除此行把此行的属性交给变量pre
            layer.confirm('确定要删除么？',{
                btn:['确定','取消']
            },function () {
                //为什么这个里不能直接用this表示当前行，因为作用域不一样，通过变量传递的方式获取当前行
                $(pre).parent().parent().remove();//这里是移除当前删除行的内容
                layer.closeAll('dialog');//这里是点击确定删除后关闭整个弹出层
            })
        });

        //产生随机数函数
        function getRandomNum() {
            return parseInt(Math.random()*50);
        }
        //动态添加一行内容的函数
        function addstrs1(i) {
            let  iNums = getRandomNum();//获取随机数
            let strs1;
            strs1 = '<tr>\n' +
                '                            <td style="display: none">\n' +
                '                                <input type="text" name="number1" value="'+i+'">\n' +
                '                            </td>\n' +
                '                            <td>\n' +
                '                                <input type="text"  name="StartTime" class="layui-input" id="test1'+iNums+'" >\n' +
                '                            </td>\n' +
                '                            <td>\n' +
                '                                <input type="text" name="EndTime" class="layui-input" id="test2'+iNums+'" >\n' +
                '                            </td>\n' +
                '                            <td>\n' +
                '                                <input type="text" name="Major" class="layui-input">\n' +
                '                            </td>\n' +
                '                            <td>\n' +
                '                                <select name="Education" lay-filter="">\n' +
                '                                    <option value="">请选择你的学历</option>\n' +
                '                                    <option value="大专及以下">大专及以下</option>\n' +
                '                                    <option value="本科">本科</option>\n' +
                '                                    <option value="研究生(硕士)">研究生(硕士)</option>\n' +
                '                                    <option value="研究生(博士)">研究生(博士)</option>\n' +
                '                                </select>\n' +
                '                            </td>\n' +
                '                            <td>\n' +
                '                                <input type="text" name="SchType" class="layui-input">\n' +
                '                            </td>\n' +
                '                            <td>\n' +
                '                                <select name="Education" lay-filter="">\n' +
                '                                    <option value="">请选择您的教育类型</option>\n' +
                '                                    <option value="全日制">全日制</option>\n' +
                '                                    <option value="在职">在职</option>\n' +
                '                                </select>\n' +
                '                            </td>\n' +
                '                            <td style="text-align: center"><button type="button" class="layui-btn layui-btn-danger btn-del">删除</button></td>\n' +
                '                        </tr>';
            $('.addlists').append(strs1);
            //重新渲染
            laydate.render({
                elem: '#test1'+iNums  //这里加上随机数的原因是为了让日期框能显示出来，
                //每次点击添加就会给input加上一个新的id，让后就会继续渲染下一行里面的日期
                //很好的解决了，日期框闪现消失，或者根本不出现的情况，根本原因在于id一样。
                ,trigger: 'click' //采用click弹出
            });
            laydate.render({
                elem: '#test2'+iNums
                ,trigger: 'click' //采用click弹出
            });
        }



    })*/

</script>

</html>