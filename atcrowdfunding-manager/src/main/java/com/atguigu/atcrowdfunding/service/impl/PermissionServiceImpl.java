package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TPermission;
import com.atguigu.atcrowdfunding.bean.TPermissionMenuExample;
import com.atguigu.atcrowdfunding.dao.TPermissionMapper;
import com.atguigu.atcrowdfunding.dao.TPermissionMenuMapper;
import com.atguigu.atcrowdfunding.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @ClassName: PermissionServiceImpl
 * @Description:
 * @Author: hjt
 * @Date: Created in 2020-08-2020/8/4 16:47
 * @Version 1.0
 */
@Service
public class PermissionServiceImpl implements PermissionService {

    @Autowired
    TPermissionMapper permissionMapper;

    @Autowired
    TPermissionMenuMapper permissionMenuMapper;

    /**
     * Ztree树的加载
     * @return
     */
    @Override
    public List<TPermission> getAllPermissions() {
        return permissionMapper.selectByExample(null);
    }

    /**
     * 添加
     * @param permission
     */
    @Override
    public void saveTPermission(TPermission permission) {
        permissionMapper.insertSelective(permission);
    }

    /**
     * 获得数据（回显）
     * @param id
     * @return
     */
    @Override
    public TPermission getPermissionById(Integer id) {
        return permissionMapper.selectByPrimaryKey(id);
    }

    /**
     * 修改数据
     * @param permission
     */
    @Override
    public void updateTPermission(TPermission permission) {
        permissionMapper.updateByPrimaryKeySelective(permission);
    }

    /**
     * 删除数据
     * @param id
     */
    @Override
    public void deleteTPermission(Integer id) {
        permissionMapper.deleteByPrimaryKey(id);
    }

    /**
     * 菜单分配权限
     * @param mid
     * @param perIdArray
     */
    @Override
    public void assignPermissionToMenu(Integer mid, List<Integer> perIdArray) {
        //1-删除之前菜单对应的权限
        TPermissionMenuExample example = new TPermissionMenuExample();
        example.createCriteria().andMenuidEqualTo(mid);
        permissionMenuMapper.deleteByExample(example);

        //2-插入提交过的新的权限集合
        if(perIdArray!=null && perIdArray.size() > 0){
            permissionMenuMapper.insertBatch(mid, perIdArray);
        }
    }


    /**
     * 菜单权限树回显
     * @param mid
     * @return
     */
    @Override
    public List<TPermission> getPermissionByMenuid(Integer mid) {
        return permissionMapper.getPermissionByMenuid(mid);
    }
}
