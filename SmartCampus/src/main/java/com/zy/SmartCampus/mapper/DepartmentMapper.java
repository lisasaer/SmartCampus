package com.zy.SmartCampus.mapper;

import com.zy.SmartCampus.polo.Department;
import com.zy.SmartCampus.polo.DepartmentExample;
import com.zy.SmartCampus.polo.DepartmentTree;
import com.zy.SmartCampus.polo.Device;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DepartmentMapper {
    int countByExample(DepartmentExample example);

    int deleteByExample(DepartmentExample example);

    int deleteByPrimaryKey(Integer departmentid);

    int insert(Department record);

    int insertSelective(Department record);

    List<Department> selectDepartmentName();

    List<DepartmentTree> selectCascadeDepartmentName();

    List<DepartmentTree> selectRootDepartmentTree();

    List<DepartmentTree> selectDepartmentTreeByParentId(Integer parentId);


    List<Department> selectByExample(DepartmentExample example);

    Department selectByPrimaryKey(Integer departmentid);

    int updateByExampleSelective(@Param("record") Department record, @Param("example") DepartmentExample example);

    int updateByExample(@Param("record") Department record, @Param("example") DepartmentExample example);

    int updateByPrimaryKeySelective(Department record);

    int updateByPrimaryKey(Department record);
    void addFirstDepartment(Department department);
    void addDepartment(Department department);
    void editDepartment(Department department);
    void deleteDepartment(Department department);


    List<Department> queryDepartmentByParentId(int departmentId);
}