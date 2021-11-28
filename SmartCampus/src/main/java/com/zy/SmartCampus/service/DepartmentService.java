package com.zy.SmartCampus.service;

import com.zy.SmartCampus.mapper.DepartmentMapper;
import com.zy.SmartCampus.polo.Department;
import com.zy.SmartCampus.polo.DepartmentTree;
import com.zy.SmartCampus.polo.Device;
import com.zy.SmartCampus.util.MyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@Service
public class DepartmentService {
    @Autowired
    private DepartmentMapper departmentMapper;

    public List<Department> selectDepartmentName() {
        return departmentMapper.selectDepartmentName();
    }

    public List<DepartmentTree> getDepartmetTree() {
        List<DepartmentTree> departmentTrees = departmentMapper.selectRootDepartmentTree();
        //List<DepartmentTree> departmentTrees =new ArrayList<>();
        List<DepartmentTree> list =new ArrayList<>();
        DepartmentTree tree = new DepartmentTree();
        //tree.setTitle("所有部门");
        if(departmentTrees.size()>0){
            if(departmentTrees.get(0).getRootId()==1){
                tree.setTitle(departmentTrees.get(0).getTitle());
                tree.setRootId(departmentTrees.get(0).getRootId());
                departmentTrees.remove(0);
            }else{
                tree.setTitle("所有部门");
                tree.setRootId(1);
            }

            for(int i= 0;i<departmentTrees.size();i++){
                if(departmentTrees.get(i).getParentId()==1){
                    list.add(departmentTrees.get(i));
                }
            }
        }else{
            tree.setTitle("所有部门");
            tree.setRootId(1);
            Department department = new Department();
            department.setDname("所有部门");
            department.setDepartmentid(1);
            MyUtil.printfInfo(department.toString());
            departmentMapper.addFirstDepartment(department);
        }
        tree.setSpread(true);//默认tree展开
        tree.setChildren(allTree(list));
        List<DepartmentTree> trees = new ArrayList();
        trees.add(tree);
        MyUtil.printfInfo(trees.toString());
        return trees;
    }

    public void addDepartment(Department department) {
        departmentMapper.addDepartment(department);
    }
    public void editDepartment(Department department) {
        departmentMapper.editDepartment(department);
    }
    public void deleteDepartment(Department department) {
        departmentMapper.deleteDepartment(department);
    }
    public HashMap<Integer, DepartmentTree> selectCascadeDepartmentName() {
        List<DepartmentTree> departmentTrees = departmentMapper.selectRootDepartmentTree();
        HashMap<Integer, DepartmentTree> departmentNames = new HashMap();
        return allTreename(departmentTrees, departmentNames);
    }

    public List<DepartmentTree> getTree(DepartmentTree departmentTree) {
        List<DepartmentTree> child = departmentMapper.selectDepartmentTreeByParentId(departmentTree.getRootId());
        return child;
    }

    public List<DepartmentTree> allTree(List<DepartmentTree> departmentTrees) {
        for (DepartmentTree departmentTree : departmentTrees) {
            List<DepartmentTree> trees = getTree(departmentTree);
            departmentTree.setSpread(true);//默认tree展开
            departmentTree.setChildren(trees);
            if (trees != null)
                allTree(trees);
        }
        return departmentTrees;
    }

    public HashMap<Integer, DepartmentTree> allTreename(List<DepartmentTree> departmentTrees, HashMap<Integer, DepartmentTree> departmentNames) {
        for (DepartmentTree departmentTree : departmentTrees) {
            if (departmentTree.getParentId() != null && !departmentTree.getParentId().equals("")) {
                String title = departmentNames.get(departmentTree.getParentId()).getTitle() + " - "+departmentTree.getTitle();
                departmentTree.setTitle(title);
                departmentNames.put(departmentTree.getRootId(), departmentTree);
            } else {
                departmentNames.put(departmentTree.getRootId(), departmentTree);
            }
            List<DepartmentTree> trees = getTree(departmentTree);
            if (trees != null)
                allTreename(trees, departmentNames);
        }
        return departmentNames;
    }


    //根据部门ID查询人员信息
    public List<Department> queryDepartmentByParentId(int departmentId){
        return departmentMapper.queryDepartmentByParentId(departmentId);
    }
}
//      [{
//        title: '远方科技中心' //一级菜单
//          ,children: [{
//              title: '远方大厅门口' //二级菜单
//              },{
//              title: '19楼' //二级菜单
//                  ,children: [{
//                      title: '1909大门' //三级菜单
//                      //…… //以此类推，可无限层级
//                  },{
//                  title: '1908大门' //三级菜单
//                  //…… //以此类推，可无限层级
//                  },{
//                  title: '1907大门' //三级菜单
//                  //…… //以此类推，可无限层级
//                  }]
//              }]
//        },{
//        title: '陕西' //一级菜单
//            ,children: [{
//              title: '西安' //二级菜单
//                  ,children: [{
//                      title: '高新区' //三级菜单
//                      //…… //以此类推，可无限层级
//                      }]
//              }]
//        }]
