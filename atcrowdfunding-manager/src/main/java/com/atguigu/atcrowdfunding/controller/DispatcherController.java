package com.atguigu.atcrowdfunding.controller;

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * DispatcherController:用于用户登录功能的转发业务
 */
@Controller
public class DispatcherController {

    //要获取登录数据，需要去业务层进行逻辑处理，访问数据库，
    // 所以需要AdminService adminService接口
    // 写代码的流程：从 表现层(controller) -> 业务层(service) -> 持久层（dao）
    @Autowired
    AdminService adminService;

    @Autowired
    MenuService menuService;

    //实现用户注销
    /*@RequestMapping("/logout")
    public String logout(HttpSession session){
        if(session!=null){
            session.invalidate();
        }
        return "redirect:/login.jsp";
    }*/

    //实现菜单显示
    @RequestMapping("/main")
    public String main(HttpSession session){
        System.out.println("main...");
        //查询所有的菜单，显示菜单

        //集合中只需要返回所有父菜单。
        List<TMenu> parentMenuList = (List<TMenu>)session.getAttribute("parentMenuList");
        if(parentMenuList == null){
            parentMenuList = menuService.listAllMenus();
            session.setAttribute("parentMenuList",parentMenuList);
        }
        return "main";
    }

    //实现用户登录功能
    /*@RequestMapping("/login")
    public String login(String loginacct, String userpswd, HttpSession session, Model model){

        try {
            TAdmin admin = adminService.getAdminByLogin(loginacct,userpswd);
            session.setAttribute(Const.LOGIN_ADMIN,admin);
            //return "main";  //代表转发，路径不变，还是login.jsp  -> 会出现表单重复提交的问题
            return "redirect:/main";  //需要重定向到/main避免重复提交问题
        } catch (LoginException e) {
            e.printStackTrace();
            model.addAttribute("message",e.getMessage());
            return "forward:/login.jsp";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("message","系统出现问题");
            return "forward:/login.jsp";
        }
    }*/
}
