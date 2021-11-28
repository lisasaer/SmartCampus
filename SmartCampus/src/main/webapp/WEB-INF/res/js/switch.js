var currItem = null;

function addSingleSwitch(dom,title) {
    var magin = 2;
    var width_1 = 100;
    var width_2 = width_1 + 2*magin;

    var html = '<div onclick="switchDiv1Clicked(this)" class="switch-div-1" style="width:'+width_2+'px;height:'+width_2+'px;">'+
                    '<div class="switch-div-2" style="width:'+width_1+'px;height:'+width_1+'px;">' +
                        '<div class="switch-div-11" style="width:'+(width_1-10)+'px;height:'+(width_2/2 - 10)+'px">' +
                            '<h6 class="switch-title title-text" style="color: #12563B;font-weight: bold">'+title+'</h6><h6 class="switch-title" style="font-size: 12px;">0瓦</h6>'+
                        '</div>'+
                        '<div class="switch-div-12" style="width:'+(width_1/2-10)+'px;height:'+(width_1/2-10)+'px;">'+
                            '<div class="ON-OFF">ON</div><div class="ON-OFF">OFF</div>'+
                        '</div>'+
                    '</div>' +
                '</div>';
    $(dom).append(html);
}

//var data = {content:'#divSwitch',list:[{title:'分路1'},{title:'分路2'},{title:'分路3'},{title:'分路11'},{title:'分路11'},{title:'分路11'}]};
function addSwitch(data) {
    var magin = 2;
    var width_1 = 100;
    var width_2 = width_1 + 2*magin;

    var tempList = data.list;
    for(var i=0;i<tempList.length;i++){
        var itemData = tempList[i];
        var html = '<div onclick="switchDiv1Clicked(this)" class="switch-div-1" style="width:'+width_2+'px;height:'+width_2+'px;">'+
            '<div class="switch-div-2" style="width:'+width_1+'px;height:'+width_1+'px;">' +
            '<div class="switch-div-11" style="width:'+(width_1-10)+'px;height:'+(width_2/2 - 10)+'px">' +
            '<h6 class="switch-title title-text" style="color: #12563B;font-weight: bold">'+itemData.title+'</h6><h6 class="switch-title" style="font-size: 12px;">0瓦</h6>'+
            '</div>'+
            '<div class="switch-div-12" style="width:'+(width_1/2-10)+'px;height:'+(width_1/2-10)+'px;">'+
            '<div class="ON-OFF">ON</div><div class="ON-OFF">OFF</div>'+
            '</div>'+
            '</div>' +
            '</div>';
        $(data.content).append(html);
    }
}

function switchDiv1Clicked(dom) {
    //单选
    singleClicked($(dom));
    return;

    //多选
    if($(dom).attr('switch-check') == null){
        $(dom).attr('switch-check','');

        $(dom).css('background-color','#94A75C');
        $(dom).find('.switch-div-2').css('background-color','#C8DC94');
        $(dom).find('.switch-div-11').css('background-color','#92C123');
    }else {
        $(dom).removeAttr('switch-check');

        $(dom).css('background-color','white');
        $(dom).find('.switch-div-2').css('background-color','#DFDFDF');
        $(dom).find('.switch-div-11').css('background-color','#CCCCCC');
    }
}

function singleClicked(dom) {
    if(currItem != null){
        setClickedCSS(currItem,false);
    }

    if(dom[0] == currItem){
        setClickedCSS(dom,false);
        currItem = null;
    }else {
        setClickedCSS(dom,true);
        currItem = dom[0];
    }
}

function setClickedCSS(dom,checked) {
    if(checked && $(dom).attr('switch-check') == null){
        $(dom).attr('switch-check','');

        $(dom).css('background-color','#94A75C');
        $(dom).find('.switch-div-2').css('background-color','#C8DC94');
        $(dom).find('.switch-div-11').css('background-color','#92C123');
    }else {
        $(dom).removeAttr('switch-check');

        $(dom).css('background-color','white');
        $(dom).find('.switch-div-2').css('background-color','#DFDFDF');
        $(dom).find('.switch-div-11').css('background-color','#CCCCCC');
    }
    //console.log($(dom).find('.title-text').html());
}

function delArray(array,delValue) {
    array.forEach(function (value, index) {
        if(delValue[0] == value[0]){
            array.splice(index,1);
            return;
        }
    })
}