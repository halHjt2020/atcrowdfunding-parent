package com.atguigu.atcrowdfunding.dao;

import com.atguigu.atcrowdfunding.bean.TAdminRole;
import com.atguigu.atcrowdfunding.bean.TAdminRoleExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TAdminRoleMapper {
    long countByExample(TAdminRoleExample example);

    int deleteByExample(TAdminRoleExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(TAdminRole record);

    int insertSelective(TAdminRole record);

    List<TAdminRole> selectByExample(TAdminRoleExample example);

    TAdminRole selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") TAdminRole record, @Param("example") TAdminRoleExample example);

    int updateByExample(@Param("record") TAdminRole record, @Param("example") TAdminRoleExample example);

    int updateByPrimaryKeySelective(TAdminRole record);

    int updateByPrimaryKey(TAdminRole record);

    List<Integer> listRoleIdByAdminId(Integer id);

    void saveAdminAndRoleRelationship(@Param("adminId") Integer adminId,@Param("roleIds") Integer[] roleId);

    void deleteAdminAndRoleRelationship(@Param("adminId") Integer adminId,@Param("roleIds") Integer[] roleId);
}