package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.github.pagehelper.PageInfo;

import javax.security.auth.login.LoginException;
import java.util.Map;

/**
 * 业务层：AdminService接口，用于获取数据库中的登录参数
 */
public interface AdminService {

    TAdmin getAdminByLogin(String loginacct, String userpswd) throws LoginException;


    PageInfo<TAdmin> listPage(Map<String, Object> paramMap);

    void saveAdmin(TAdmin admin);

    TAdmin getAdminById(Integer id);

    void updateAdmin(TAdmin admin);

    void deleteAdminById(Integer id);


    void deleteAdminsByIds(String[] ids);
}
