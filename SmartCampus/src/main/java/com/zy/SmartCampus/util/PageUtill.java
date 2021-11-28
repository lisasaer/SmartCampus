package com.zy.SmartCampus.util;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;

public class PageUtill implements Serializable {
    private static final long serialVersionUID = -1202716581589799959L;

    //总记录数
    private int totalCount;
    //每页记录数
    private int pageSize;
    //总页数
    private int totalPage;
    //当前页数
    private int currPage;
    //列表数据
    private List<?> list;

    /**
     * 分页
     *
     * @param list       列表数据
     * @param totalCount 总记录数
     * @param pageSize   每页记录数
     * @param currPage   当前页数
     */
    public PageUtill(List<?> list, int totalCount, int pageSize, int currPage) {
        this.list = list;
        this.totalCount = totalCount;
        this.pageSize = pageSize;
        this.currPage = currPage;
        this.totalPage = (int) Math.ceil((double) totalCount / pageSize);
}

    public static HashMap<String, Object> PageMap(String page, String limit, String states) {
        HashMap<String, Object> map = new HashMap();
        if (page != null) {
            int start = Integer.parseInt(page);
            int size = Integer.parseInt(limit);
            if (states == null) {
            } else {
                int state = Integer.parseInt(states);
                map.put("state", state);
            }
            map.put("start", (start - 1) * size);
            map.put("size", size);
            return map;
        }
        return map;
    }

}