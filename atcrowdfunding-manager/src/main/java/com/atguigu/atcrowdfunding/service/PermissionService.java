package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TPermission;

import java.util.List;

/**
 * @ClassName: PermissionService
 * @Description:
 * @Author: hjt
 * @Date: Created in 2020-08-2020/8/4 16:43
 * @Version 1.0
 */
public interface PermissionService {

    //获得权限树菜单
    List<TPermission> getAllPermissions();

    //添加
    void saveTPermission(TPermission permission);

    //获得数据
    TPermission getPermissionById(Integer id);

    //修改数据
    void updateTPermission(TPermission permission);

    //删除数据
    void deleteTPermission(Integer id);

    //菜单分配权限
    void assignPermissionToMenu(Integer mid, List<Integer> perIdArray);

    //菜单权限树回显
    List<TPermission> getPermissionByMenuid(Integer mid);
}
