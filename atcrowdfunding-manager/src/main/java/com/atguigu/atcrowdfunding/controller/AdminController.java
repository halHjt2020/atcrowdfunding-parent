package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.atguigu.atcrowdfunding.util.Const;
import com.atguigu.atcrowdfunding.util.DateUtil;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

/**
 * @ClassName: AdminController   控制有关用户数据的 CRUD
 * @Description:
 * @Author: hjt
 * @Date: Created in 2020-07-2020/7/27 10:44
 * @Version 1.0
 */
@Controller
public class AdminController {

    @Autowired
    AdminService adminService;

    @Autowired
    RoleService roleService;



    /**
     * 批量删除用户数据
     * @param ids
     * @return
     */
    @RequestMapping("/admin/deleteBatch")
    public String deleteBatch(String ids){
        /*String[] ids = ids.split(",");
        adminService.deleteBatch(ids);*/

        String[] idArray = ids.split(",");
        adminService.deleteAdminsByIds(idArray);
        return "redirect:/admin/index";
    }


    /**
     * 删除一条用户数据
     * @param id
     * @return
     */
    @RequestMapping("/admin/doDelete")
    public String doDelete(Integer id){
        adminService.deleteAdminById(id);
        return "redirect:/admin/index";
    }

    /**
     * 实现修改用户数据
     * @param admin
     * @return
     */
    @RequestMapping("/admin/doUpdate")
    public String doUpdate(TAdmin admin,Integer pageNum){
        adminService.updateAdmin(admin);
        //重定向
        return "redirect:/admin/index?pageNum=" + pageNum;
    }

    /**
     * 跳转update（修改）页面
     * @param id
     * @param model
     * @return
     */
    @RequestMapping("/admin/toUpdate")
    public String toUpdate(Integer id,Model model){
        TAdmin admin = adminService.getAdminById(id);
        model.addAttribute("admin",admin);

        return "admin/update";
    }

    /**
     * 实现添加用户
     * @return
     */
    @RequestMapping("/admin/doAdd")
    public String doAdd(TAdmin admin){

        //补充数据
        admin.setUserpswd(new BCryptPasswordEncoder().encode(Const.DEFALUT_PASSWORD));

        //日期格式转换
        admin.setCreatetime(DateUtil.format(new Date(), "yyyy-MM-dd HH:mm:ss"));

        //保存数据
        adminService.saveAdmin(admin);

        //添加后跳转到最后一页。根据分页合理化实现的。指定一个不可能存在的页码，分页组件会抛异常，并处理异常，去到最后一页
        return "redirect:/admin/index？pageNum=" + Integer.MAX_VALUE;//用户数据增加后，重定向到分页查询页面
    }


    /**
     * 用户模块 - 添加功能 - 跳转添加页面
     * @return
     */
    @RequestMapping("/admin/toAdd")
    public String toAdd(){
        return "admin/add";
    }

    /**
     *   跳转到用户列表页面
     * @param pageNum :查第几页
     * @param pageSize ：查多少条
     * @param condition ：查询关键词（查询条件）
     *
     *      required = false：不传
     *      defaultValue = "1"：默认第一页
     *
     *      required = false,defaultValue = "2" 默认2条
     * @return
     */
    //声明，与找页面无关
    @PreAuthorize("hasRole('学徒')")
    @RequestMapping("/admin/index")
    public String index(
            @RequestParam(value = "pageNum",required = false,defaultValue = "1") Integer pageNum,
            @RequestParam(value = "pageSize",required = false,defaultValue = "5") Integer pageSize,
            String condition,
            Model model) {

        //1.开启分页插件功能  pageHelper：分页插件
        PageHelper.startPage(pageNum,pageSize); //将数据通过ThreadLocal将数据绑定到线程上，传递给后续流程

        //2.获取分页数据。业务层调用dao层，并封装成分页对象返回
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("condition",condition);

        //分页查询  PageInfo分页组件
        PageInfo<TAdmin> page = adminService.listPage(paramMap);

        //3.数据存储
        model.addAttribute("page",page);

        //4.跳转页面(转发)  admin/index页面名字
        return "admin/index";
    }


    /**
     * 跳转到角色分配页面并实现分配功能
     * 对数据库的查找方式：
     *      以 admin_id 作为外键，将 role_id 查出来
     *      (1)集合1 - allRoleList：role_id的集合
     *      (2)集合2 - selfRoleIdList：admin_id的集合
     *
     *      1 - 查询所有角色（role）
     *      2 - 根据用户id查询已经分配过的角色id
     *      3 - 将所有角色，进行划分：
     *      4 - 已分配角色的集合
     *      5 - 未分配角色的集合
     *
     *
     */
    @RequestMapping("/admin/toAssignRole") // "/admin/toAssignRole"做映射
    public String toAssignRole(Integer id,Model model){ //Model model:请求对象（将数据放在model中，再讲model的数据放在请求域中）

        // 1.查询所有角色
        List<TRole> allRoleList = roleService.listAll();

        // 2.根据用户id查询已经分配过的角色id
        List<Integer> selfRoleIdList = roleService.listRoleIdByAdminId(id);

        // 3.将所有角色，进行划分：
        List<TRole> assignList = new ArrayList<TRole>(); //已分配集合 assignList
        List<TRole> unAssignList = new ArrayList<TRole>(); //未分配集合 unAssignList

        model.addAttribute("assignList",assignList); //将 assignList 集合放到请求域中
        model.addAttribute("unAssignList", unAssignList); //将 unAssignList 集合放到请求域中

        for (TRole role : allRoleList) {

            if (selfRoleIdList.contains(role.getId())) {// 如果 selfRoleIdList集合 里包含了当前的 role 的id，就说明已经分配过了
                // 4.获得已分配角色集合
                assignList.add(role);
            } else { // 未分配
                // 5.获得未分配角色集合
                unAssignList.add(role);
            }
        }

        return "admin/assignRole";
    }

    @ResponseBody
    @RequestMapping("/admin/doAssignRoleToAdmin")
    public String doAssignRoleToAdmin(Integer adminId, Integer[] roleId, Model model) {

        roleService.saveAdminAndRoleRelationship(adminId, roleId);

        return "ok";
    }

    @ResponseBody
    @RequestMapping("/admin/doUnAssignRoleToAdmin")
    public String doUnAssignRoleToAdmin(Integer adminId, Integer[] roleId, Model model) {
        roleService.deleteAdminAndRoleRelationship(adminId, roleId);
        return "ok";
    }

}
