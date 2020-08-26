package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.github.pagehelper.PageInfo;

import java.util.List;
import java.util.Map;

/**
 * @ClassName: RoleService ：权限管理模块业务接口
 * @Description:
 * @Author: hjt
 * @Date: Created in 2020-07-2020/7/28 10:54
 * @Version 1.0
 */
public interface RoleService {
    //分页（权限页面）
    PageInfo<TRole> listPage(Map<String, Object> paramMap);

    //增加（权限页面）
    void saveRole(TRole role);

    //获取表单数据（通过id）
    TRole getRoleById(Integer roleId);

    //修改表单数据
    void updateRole(TRole role);

    //删除一条表单数据
    void deleteRoleById(Integer id);

    //异步批量删除
    void deleteBatch(String ids);

    //用于遍历role表单
    List<TRole> listAll();

    //查询该用户所拥有的角色id的方法
    List<Integer> listRoleIdByAdminId(Integer id);

    //
    void saveAdminAndRoleRelationship(Integer adminId, Integer[] roleId);

    //
    void deleteAdminAndRoleRelationship(Integer adminId, Integer[] roleId);

    //
    List<Integer> listPermissionIdByRoleId(Integer roleId);

    //
    void saveRoleAndPermissionRelationship(Integer roleId, List<Integer> ids);
}
