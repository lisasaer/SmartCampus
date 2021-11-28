package com.zy.SmartCampus.polo;

import lombok.Data;
import java.util.List;

@Data
public class EasyTree {
    private String id;                  //主键
    private String text;                //显示内容
    private String state;               //节点状态，'open' 或 'closed'，默认是 'open'。当设置为 'closed' 时，该节点有子节点，并且将从远程站点加载它们。
    private boolean checked;            //指示节点是否被选中。true or false
    private String iconCls;             //图标样式
    private String attributes;          //给一个节点添加的自定义属性
    private List<EasyTree> children;    //子节点数据
    private String pId;                 //父节点id

    private List<VideoInfo> videoInfoList; //wpp-2020-3-10 监控-实时预览会用到
}
