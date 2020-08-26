package com.atguigu.atcrowdfunding.service.impl;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TAdminExample;
import com.atguigu.atcrowdfunding.dao.TAdminMapper;
import com.atguigu.atcrowdfunding.exception.LoginException;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.util.Const;
import com.atguigu.atcrowdfunding.util.DateUtil;
import com.atguigu.atcrowdfunding.util.MD5Util;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * AdminService接口的实现类AdminServiceImpl
 * 需要注入持久层的TAdminMapper adminMapper;
 * 用于取到数据库中的相关数据
 */
@Service
public class AdminServiceImpl implements AdminService {

    //对应的dao
    @Autowired
    TAdminMapper adminMapper;

    /**
     * 登录
     * @param loginacct
     * @param userpswd
     * @return
     * @throws LoginException
     */
    @Override
    public TAdmin getAdminByLogin(String loginacct, String userpswd) throws LoginException {

        TAdminExample example = new TAdminExample();
        example.createCriteria().andLoginacctEqualTo(loginacct);//admin表里设置loginacct为唯一性约束

        List<TAdmin> list = adminMapper.selectByExample(example);

        if(list==null || list.size()==0){
            throw new LoginException(Const.LOGIN_LOGINACCT_ERROR);
        }
        TAdmin admin = list.get(0);

        if(!admin.getUserpswd().equals(MD5Util.digest(userpswd))){
            throw new LoginException(Const.LOGIN_USERPSWD_ERROR);
        }

        return admin;
    }

    /**
     * 分页查询 - 跳转到用户数据列表
     * @param paramMap
     * @return
     */
    //@PreAuthorize("hasRole('学徒')")
    @Override
    public PageInfo<TAdmin> listPage(Map<String, Object> paramMap) {

        //封装查询条件
        TAdminExample example = new TAdminExample();

        //请求参数
        String condition = (String)paramMap.get("condition");

        //判断请求参数是否存在，是否要根据请求参数进行where条件查询
        if(!StringUtils.isEmpty(condition)){
            example.createCriteria().andLoginacctLike("%"+condition+"%");

            TAdminExample.Criteria criteria2 = example.createCriteria();
            criteria2.andUsernameLike("%"+condition+"%");

            TAdminExample.Criteria criteria3 = example.createCriteria();
            criteria3.andEmailLike("%"+condition+"%");

            example.or(criteria2);
            example.or(criteria3);
        }

        //desc: 倒序排序
        //example.setOrderByClause("createtime desc");


        //有查询条件根据条件查询，没有查询条件查询所有；根据查询结果进行分页。
        //limit ?,? 索引不是从0开始的，需要指定，开始索引，分页条数
        //limit ?  当索引是从0开始的，可以省略第一个参数
        List<TAdmin> list = adminMapper.selectByExample(example);  // limit ?,?  ->  limit (pageNum-1)*pageSize,pageSize
        int navigatePages = 5;
        //封装分页数据
        PageInfo<TAdmin> page = new PageInfo<TAdmin>(list,navigatePages);

        return page;
    }

    /**
     * 保存新增用户
     * @param admin
     */
    @Override
    public void saveAdmin(TAdmin admin) {
        //MD5加密
        //admin.setUserpswd(MD5Util.digest(Const.DEFALUT_PASSWORD));

        //获取系统时间
        admin.setCreatetime(DateUtil.getFormatTime());

        //不用：adminMapper.insert(admin) //所有属性都要参与SQL语句的生成，不管你的属性值是否为null

        //insert into t_admin(id,loginacct,userpswd,username,email,createtime) values(?,?,?,?,?,?);
        adminMapper.insertSelective(admin); //属性为null的不参与SQL的生成（动态SQL）
    }

    /**
     * 跳转到 - 修改用户数据页面
     * @param id
     * @return
     */
    @Override
    public TAdmin getAdminById(Integer id) {
        return adminMapper.selectByPrimaryKey(id);
    }

    /**
     * 修改用户数据
     * @param admin
     */
    @Override
    public void updateAdmin(TAdmin admin) {
        //updateByPrimaryKeySelective() 有选择性的修改
        // 由于密码和创建时间不参与修改，所以选择动态修改
        adminMapper.updateByPrimaryKeySelective(admin);
    }

    /**
     * 删除一条用户数据
     * @param id
     */
    @Override
    public void deleteAdminById(Integer id) {
        adminMapper.deleteByPrimaryKey(id);
    }

    //批量删除功能(难)
    /*@Override
    public void deleteBatch(String ids) {
        if(!StringUtils.isEmpty(ids)){
            List<Integer> idList = new ArrayList<Integer>();
            String[] idstrArray = ids.split(",");
            for (String idstr : idstrArray) {
                int id = Integer.parseInt(idstr);
                idList.add(id);
            }

            TAdminExample example = new TAdminExample();
            example.createCriteria().andIdIn(idList);
            adminMapper.deleteByExample(example); //delete from t_admin where id in (1,2,3,4)
        }
    }*/

    @Override
    public void deleteAdminsByIds(String[] ids) {
        TAdminExample example = new TAdminExample();

        List<Integer> idList = new ArrayList<Integer>();

        for (String id : ids) {
            idList.add(Integer.parseInt(id));
        }

        example.createCriteria().andIdIn(idList);

        adminMapper.deleteByExample(example);
    }


}
