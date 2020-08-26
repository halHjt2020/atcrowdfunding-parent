package com.atguigu.atcrowdfunding.dao;

import com.atguigu.atcrowdfunding.bean.TPermissionMenu;
import com.atguigu.atcrowdfunding.bean.TPermissionMenuExample;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TPermissionMenuMapper {
    long countByExample(TPermissionMenuExample example);

    int deleteByExample(TPermissionMenuExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(TPermissionMenu record);

    int insertSelective(TPermissionMenu record);

    List<TPermissionMenu> selectByExample(TPermissionMenuExample example);

    TPermissionMenu selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") TPermissionMenu record, @Param("example") TPermissionMenuExample example);

    int updateByExample(@Param("record") TPermissionMenu record, @Param("example") TPermissionMenuExample example);

    int updateByPrimaryKeySelective(TPermissionMenu record);

    int updateByPrimaryKey(TPermissionMenu record);

    void insertBatch(@Param("mid") Integer mid,@Param("perIdArray") List<Integer> perIdArray);
}