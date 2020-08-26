package com.atguigu.atcrowdfunding.component;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TAdminExample;
import com.atguigu.atcrowdfunding.bean.TPermission;
import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.dao.TAdminMapper;
import com.atguigu.atcrowdfunding.dao.TPermissionMapper;
import com.atguigu.atcrowdfunding.dao.TRoleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * @ClassName: UserDetailsServiceImpl
 * @Description:
 * @Author: hjt
 * @Date: Created in 2020-08-2020/8/7 15:10
 * @Version 1.0
 */

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    @Autowired
    TAdminMapper adminMapper;

    @Autowired
    TRoleMapper roleMapper;

    @Autowired
    TPermissionMapper permissionMapper;



    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        //1.根据用户名查询用户信息
        TAdminExample example = new TAdminExample();
        example.createCriteria().andLoginacctEqualTo(username);
        List<TAdmin> list = adminMapper.selectByExample(example);

        if(list == null || list.size() == 0){
            return null;
        }

        TAdmin admin = list.get(0);
        Integer adminId = admin.getId();

        //2.根据用户id查询角色
        List<TRole> roleList = roleMapper.listRoleByAdminId(adminId);


        //3.根据用户id查询许可
        List<TPermission> permissionsList = permissionMapper.listPermissionByAdminId(adminId);

        //4.构建权限集合
        Set<GrantedAuthority> authorities = new HashSet<GrantedAuthority>();

        //用角色表示权限，需要增加“ROLE_”前缀
        for (TRole role : roleList) {
            authorities.add(new SimpleGrantedAuthority("ROLE_"+role.getName()));//"ROLE_"+role.getName() 用名字校验权限
        }

        for (TPermission permission : permissionsList) {
            authorities.add(new SimpleGrantedAuthority(permission.getName()));
        }

        //5.返回查询结果，交给框架进行认证
        //User user = new User(admin.getLoginacct(), admin.getUserpswd(), authorities);

        return new TAdminUser(admin,authorities);
    }
}
