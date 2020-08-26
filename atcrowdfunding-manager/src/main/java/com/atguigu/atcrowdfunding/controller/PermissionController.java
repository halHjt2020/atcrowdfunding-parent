package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TPermission;
import com.atguigu.atcrowdfunding.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @ClassName: PermissionController
 * @Description:
 * @Author: hjt
 * @Date: Created in 2020-08-2020/8/4 16:29
 * @Version 1.0
 */
@Controller
public class PermissionController {

    @Autowired
    PermissionService permissionService;


    /**
     * 跳转permission模块的index.jsp页面
     * @return
     */
    @RequestMapping("/permission/index")
    public String index(){
        return "permission/index";
    }

    /**
     * 生成Ztree树形式的权限菜单
     * @return
     */
    @ResponseBody
    @RequestMapping("/permission/listAllPermissionTree")
    public List<TPermission> getAllPermissions(){
        return permissionService.getAllPermissions();
    }

    /**
     * 实现添加功能
     * @param permission
     * @return
     */
    @ResponseBody
    @RequestMapping("/permission/save")
    public String save(TPermission permission){
        permissionService.saveTPermission(permission);
        return "ok";
    }

    /**
     * 实现获得数据功能（用于数据回显）
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/permission/get")
    public TPermission get(Integer id){
        return permissionService.getPermissionById(id);
    }

    /**
     * 实现修改功能
     * @param permission
     * @return
     */
    @ResponseBody
    @RequestMapping("/permission/doUpdate")
    public String doUpdate(TPermission permission){
        permissionService.updateTPermission(permission);
        return "ok";
    }

    /**
     * 删除
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/permission/delete")
    public String delete(Integer id){
        permissionService.deleteTPermission(id);
        return "ok";
    }



}
