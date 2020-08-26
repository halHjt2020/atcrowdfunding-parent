package com.atguigu.atcrowdfunding.dao;

import com.atguigu.atcrowdfunding.bean.TPermission;
import com.atguigu.atcrowdfunding.bean.TPermissionExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TPermissionMapper {
    long countByExample(TPermissionExample example);

    int deleteByExample(TPermissionExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(TPermission record);

    int insertSelective(TPermission record);

    List<TPermission> selectByExample(TPermissionExample example);

    TPermission selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") TPermission record, @Param("example") TPermissionExample example);

    int updateByExample(@Param("record") TPermission record, @Param("example") TPermissionExample example);

    int updateByPrimaryKeySelective(TPermission record);

    int updateByPrimaryKey(TPermission record);

    List<TPermission> getPermissionByMenuid(Integer mid);

    List<TPermission> listPermissionByAdminId(Integer adminId);
}