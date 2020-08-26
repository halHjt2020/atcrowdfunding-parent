package com.atguigu.atcrowdfunding.dao;

import com.atguigu.atcrowdfunding.bean.TRolePermission;
import com.atguigu.atcrowdfunding.bean.TRolePermissionExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TRolePermissionMapper {
    long countByExample(TRolePermissionExample example);

    int deleteByExample(TRolePermissionExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(TRolePermission record);

    int insertSelective(TRolePermission record);

    List<TRolePermission> selectByExample(TRolePermissionExample example);

    TRolePermission selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") TRolePermission record, @Param("example") TRolePermissionExample example);

    int updateByExample(@Param("record") TRolePermission record, @Param("example") TRolePermissionExample example);

    int updateByPrimaryKeySelective(TRolePermission record);

    int updateByPrimaryKey(TRolePermission record);

    void saveRoleAndPermissionRelationship(@Param("roleId") Integer roleId,@Param("permissionIds") List<Integer> ids);

    List<Integer> listPermissionIdByRoleId(Integer roleId);

    //void saveRoleAndPermissionRelationship(Integer roleId, List<Integer> ids);

}