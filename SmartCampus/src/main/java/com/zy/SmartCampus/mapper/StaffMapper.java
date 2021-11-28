package com.zy.SmartCampus.mapper;

import com.alibaba.fastjson.JSONObject;
import com.zy.SmartCampus.polo.*;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;

@Repository
public interface StaffMapper {
    int countByExample(StaffExample example);

    int deleteByExample(StaffExample example);

    void deleteByPrimaryKey(String id);
    void deleteRecord(Integer id);

    int insertSelective(Staff record);

    //SignInDetail selectStaffDetail(int id);
    List<StaffDetail> selectStaffDetail(String id);
    List<Staff> queryRecordDetail(int id);
    List<Staff> queryRecordHistoryDetail(int id);

    int selectCount(StatementBean statementBean);

    List<StaffDetail> selectStaffDetailAll(HashMap<String, Object> map);
    List<HistoryFaceAlarm> selectRecordAll(HashMap<String, Object> map);

    List<Staff> selectByExample(StaffExample example);

    Staff selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") Staff record, @Param("example") StaffExample example);

    int updateByExample(@Param("record") Staff record, @Param("example") StaffExample example);

    int updateByPrimaryKeySelective(Staff record);

    int updateByPrimaryKey(Staff record);

    int addStaff(Staff staff);

    List<String> selectStaffNameByDepartmentId(int departmentId);

    List<StatementDetail> getStaffSome(StatementBean statementBean);

    List<ManageCardBean> selectStaffNameByDepartmentIdCard(int departmentId);

    String queryphotoByCardId(String cardId);
    void updateStaff(Staff staff);

    List<StaffDetail> queryStaff(JSONObject json);
    int queryStaffCount(JSONObject json);
    //根据条件查询刷卡记录
    List<HistoryFaceAlarm> queryRecord(JSONObject json);
    List<HistoryFaceAlarm> queryHistoryRecord(JSONObject json);

    //查询刷卡记录条数
    int queryRecordCount(JSONObject json);
    int queryHistoryRecordCount(JSONObject json);

    List<StaffDetail> queryCardNo(String cardNo);
    List<StaffDetail> queryByStaffId(String staffId);
    List<StaffDetail> queryStaffName(String name);
    //根据部门ID查询人员信息（2020-7-2，hhp）
    List<StaffDetail> queryStaffByDepartmentId(int departmentId);

    List<HistoryFaceAlarm> selectRecord(JSONObject json);
    List<HistoryFaceAlarm> selectPicture(JSONObject json);
}