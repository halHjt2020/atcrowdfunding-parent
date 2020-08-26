package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.bean.TRoleExample;
import com.atguigu.atcrowdfunding.bean.TRolePermissionExample;
import com.atguigu.atcrowdfunding.dao.TAdminRoleMapper;
import com.atguigu.atcrowdfunding.dao.TRoleMapper;
import com.atguigu.atcrowdfunding.dao.TRolePermissionMapper;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @ClassName: RoleServiceImpl 权限管理模块业务实现类
 * @Description:
 * @Author: hjt
 * @Date: Created in 2020-07-2020/7/28 10:54
 * @Version 1.0
 */
@Service
public class RoleServiceImpl implements RoleService {

    @Autowired
    TRoleMapper roleMapper;

    @Autowired
    TAdminRoleMapper adminRoleMapper; //中间表的Mapper接口

    @Autowired
    TRolePermissionMapper rolePermissionMapper;

    /**
     * 分页功能
     * @param paramMap
     * @return
     */
    @Override
    public PageInfo<TRole> listPage(Map<String, Object> paramMap) {

        TRoleExample example = new TRoleExample();
        String condition = (String) paramMap.get("condition");
        if(!StringUtils.isEmpty(condition)){
            example.createCriteria().andNameLike("%"+condition+"%");
        }

        List<TRole> list = roleMapper.selectByExample(example);

        PageInfo<TRole> pageInfo = new PageInfo<>(list,5);

        return pageInfo; //注意这里不要忘了返回 pageInfo
    }

    /**
     * 添加功能
     * @param role
     */
    @Override
    public void saveRole(TRole role) {
        roleMapper.insertSelective(role);
    }


    /**
     * 获取权限表单数据
     * @param roleId
     * @return
     */
    @Override
    public TRole getRoleById(Integer roleId) {
        return roleMapper.selectByPrimaryKey(roleId);
    }

    /**
     * 修改表单数据
     * @param role
     */
    @Override
    public void updateRole(TRole role) {
        roleMapper.updateByPrimaryKeySelective(role);
    }


    /**
     * 通过id删除单条数据
     * @param id
     */
    @Override
    public void deleteRoleById(Integer id) {
        roleMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void deleteBatch(String ids) {
        if(!StringUtils.isEmpty(ids)){
            List<Integer> idList = new ArrayList<Integer>();
            String[] idstrArray = ids.split(",");
            for (String idstr : idstrArray) {
                int id = Integer.parseInt(idstr);
                idList.add(id);
            }

           TRoleExample example = new TRoleExample();
            example.createCriteria().andIdIn(idList);
            roleMapper.deleteByExample(example);
        }
    }

    /**
     * 查询所有role的list（用于角色分配页面）
     * @return
     */
    @Override
    public List<TRole> listAll() {
        return roleMapper.selectByExample(null);
    }

    /**
     * 用中间表的 adminRoleMapper 调用该方法
     * @param id
     * @return
     */
    @Override
    public List<Integer> listRoleIdByAdminId(Integer id) {
        return adminRoleMapper.listRoleIdByAdminId(id);
    }

    @Override
    public void saveAdminAndRoleRelationship(Integer adminId, Integer[] roleId) {
        adminRoleMapper.saveAdminAndRoleRelationship(adminId, roleId);
    }

    @Override
    public void deleteAdminAndRoleRelationship(Integer adminId, Integer[] roleId) {
        adminRoleMapper.deleteAdminAndRoleRelationship(adminId, roleId);
    }

    /**
     * 回显数据
     * @param roleId
     * @return
     */
    @Override
    public List<Integer> listPermissionIdByRoleId(Integer roleId) {
        return rolePermissionMapper.listPermissionIdByRoleId(roleId);
    }

    /**
     *
     * @param roleId
     * @param ids
     */
    @Override
    public void saveRoleAndPermissionRelationship(Integer roleId, List<Integer> ids) {

        TRolePermissionExample example = new TRolePermissionExample();

        example.createCriteria().andRoleidEqualTo(roleId);

        // 保存角色和许可关系数据前，将以前分配的许可关系数据删除
        rolePermissionMapper.deleteByExample(example);

        if (ids!=null && ids.size()>0) {
            // 重新保存最新关系数据。（这样，不必区分哪些id是需要保存，哪些id需要删除，以及哪些id是不动的。）
            rolePermissionMapper.saveRoleAndPermissionRelationship(roleId, ids);
        }
    }
}
