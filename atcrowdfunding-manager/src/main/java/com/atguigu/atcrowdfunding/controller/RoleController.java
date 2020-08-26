package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.atguigu.atcrowdfunding.util.Data;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @ClassName: RoleController: 权限管理模块控制层（控制业务逻辑，与前端交互）
 * @Description:
 * @Author: hjt
 * @Date: Created in 2020-07-2020/7/28 10:29
 * @Version 1.0
 */

@Controller
public class RoleController {

    @Autowired
    RoleService roleService;

    /**
     * 批量删除
     * @param ids
     * @return
     */
    @ResponseBody
    @RequestMapping("/role/deleteBatch")
    public String deleteBatch(String ids){
        roleService.deleteBatch(ids);
        return "ok";
    }


    /**
     * 删除单项表单数据
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/role/doDelete")
    public String delete(Integer id){
        roleService.deleteRoleById(id);
        return "ok";
    }


    /**
     * 修改表单
     * @param role
     * @return
     */
    @ResponseBody
    @RequestMapping("/role/doUpdate")
    public String doUpdate(TRole role){
        roleService.updateRole(role);
        return "ok";
    }


    /**
     * 获取表单
     * @param roleId
     * @return
     */
    @ResponseBody
    @RequestMapping("/role/getRoleById")
    public TRole get(Integer roleId){
        return roleService.getRoleById(roleId);
    }



    /**
     *  权限菜单添加
     * @param role
     * @return
     */
    @ResponseBody
    @RequestMapping("/role/doAdd")
    public String doAdd(TRole role){
        roleService.saveRole(role);
        return "ok";
    }


    /**
     * 分页查询
     * @param pageNum
     * @param pageSize
     * @param condition
     * @return
     */
    @ResponseBody //告诉框架，采用    组件，将bean对象转换为json格式数据
    @RequestMapping("/role/loadData")
    public PageInfo<TRole> loadData(
            @RequestParam(value = "pageNum",required = false,defaultValue = "") Integer pageNum,
            @RequestParam(value = "pageSize",required = false,defaultValue = "") Integer pageSize,
            @RequestParam(value = "condition",required = false,defaultValue = "") String condition){

        PageHelper.startPage(pageNum,pageSize);

        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("condition",condition);

        PageInfo<TRole> pageInfo = roleService.listPage(paramMap);

        return pageInfo; //不再跳转页面，而是将数据以json格式返回
    }

    /**
     * 跳转页面
     * @return
     */
    @RequestMapping("role/index")
    public String index(){
        return "role/index";
    }

    /**
     * Ztree回显数据库中的数据
     * @param roleId
     * @return
    @ResponseBody
    @RequestMapping("/role/listPermissionIdByRoleId")
    public List<Integer> listPermissionIdByRoleId(Integer roleId){
        List<Integer> list = roleService.listPermissionIdByRoleId(roleId);
        return list;
    }*/


    //Logger log = LoggerFactory.getLogger(RoleController.class);


    @ResponseBody
    @RequestMapping("/role/listPermissionIdByRoleId")
    public List<Integer> listPermissionIdByRoleId(Integer roleId){
        //roleService.saveRoleAndPermissionRelationship(roleId, ds.getIds());

        List<Integer> list = roleService.listPermissionIdByRoleId(roleId);


        return list;
    }


    /**
     * 给角色分配许可
     * @param ds
     * @param roleId
     * @return
     */
    @ResponseBody
    @RequestMapping("/role/doAssignPermissionToRole")
    public String doAssignPermissionToRole(Data ds, Integer roleId){

/*        log.debug("roleId={}", roleId);
        log.debug("permissionIds={}", ds.getIds());*/

        roleService.saveRoleAndPermissionRelationship(roleId, ds.getIds());
        return "ok";
    }




}
