package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TMenu;

import java.util.List;

public interface MenuService {

    //查询所有父，父含有children属性
    //侧边栏，组装好父子关系后返回所有的父
    List<TMenu> listAllMenus();// ? 为什么没有Controller

    //生成菜单树
    List<TMenu> listAllMenusTree();


    //模态框的存储
    void saveTMenu(TMenu menu);






    //删除
    void deleteTMenu(Integer id);

    //修改
    void updateTMenu(TMenu menu);



    TMenu getTMenu(Integer id);
}
