package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.bean.TPermission;
import com.atguigu.atcrowdfunding.service.MenuService;
import com.atguigu.atcrowdfunding.service.PermissionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

/**
 * @ClassName: MenuController
 * @Description:
 * @Author: hjt
 * @Date: Created in 2020-07-2020/7/29 9:12
 * @Version 1.0
 */
@Controller
public class MenuController {

    @Autowired
    MenuService menuService;

    @Autowired
    PermissionService permissionService;


    /**
     * 菜单树中的模态框的删除功能
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/menu/delete")
    public String delete(Integer id){
        menuService.deleteTMenu(id);
        return "ok";
    }

    /**
     * 菜单树中的模态框的修改功能
     * @param menu
     * @return
     */
    @ResponseBody
    @RequestMapping("/menu/doUpdate")
    public String doUpdate(TMenu menu){
        menuService.updateTMenu(menu);
        return "ok";
    }



    /**
     * 菜单树中模态框的存储功能
     * @param menu
     * @return
     */
    @ResponseBody
    @RequestMapping("/menu/save")
    public String save(TMenu menu){
        menuService.saveTMenu(menu);
        return "ok";
    }

    /**
     * 用于模态框获取数据
     * @param id
     * @return
     */
    @ResponseBody
    @RequestMapping("/menu/get")
    public TMenu get(Integer id){
        TMenu menu = menuService.getTMenu(id);
        return menu;
    }


    /**
     * 生成Ztree树
     * @return
     */
    @ResponseBody
    @RequestMapping("/menu/loadTree")
    public List<TMenu> loadTree(){
        return menuService.listAllMenusTree();
    }


    /**
     * 跳转index
     * @return
     */
    @RequestMapping("/menu/index")
    public String index(){
        return "menu/index";
    }

    /**
     * 为菜单分配权限 {mid: "3", perIds: "1,2,4,5,6"}
     * @param mid
     * @param perIds
     * @return
     */
    @ResponseBody
    @PostMapping("/menu/assignPermissionToMenu")
    public String assignPermissionToMenu(@RequestParam("mid") Integer mid, @RequestParam("perIds") String perIds){
        //1.权限id的集合
        List<Integer> perIdArray = new ArrayList<>();
        String[] split = perIds.split(",");
        for (String str : split) {
            int id;
            try {
                id = Integer.parseInt(str);
                perIdArray.add(id);
                } catch (NumberFormatException e) {
            }
        }

        //将菜单和权限id的集合关系保存起来
        permissionService.assignPermissionToMenu(mid, perIdArray);
        return "ok";
    }

    @ResponseBody
    @GetMapping("/menu/menu_permission")
    public List<TPermission> getPermissionByMenuid(@RequestParam("menuid") Integer mid){
        //查询出当前菜单能被哪些权限操作
        return permissionService.getPermissionByMenuid(mid);
    }

}
