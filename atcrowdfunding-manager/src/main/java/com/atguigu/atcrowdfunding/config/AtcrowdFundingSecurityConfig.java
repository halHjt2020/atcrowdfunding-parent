package com.atguigu.atcrowdfunding.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.access.AccessDeniedHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @ClassName: AtcrowdFundingSecurityConfig
 * @Description:
 * @Author: hjt
 * @Date: Created in 2020-08-2020/8/7 14:53
 * @Version 1.0
 */
@Configuration //声明一个配置类
@EnableWebSecurity //开启权限框架功能
@EnableGlobalMethodSecurity(prePostEnabled = true) //开启全局方法级别的细粒度权限控制 别忘了：prePostEnabled = true
public class AtcrowdFundingSecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    UserDetailsService userDetailsService;


    //认证
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        //super.configure(auth);
        auth.userDetailsService(userDetailsService).passwordEncoder(new BCryptPasswordEncoder());
    }

    //方法提示快捷键（crtl+alt+空格）
    //授权
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        //super.configure(http);

        //1.授权静态资源和首页
        http.authorizeRequests()
                .antMatchers("/static/**","/login.jsp").permitAll()
                .anyRequest().authenticated();

        //2.授权登录页面
        http.formLogin()
                .loginPage("/login.jsp")
                .loginProcessingUrl("/login")
                .usernameParameter("loginacct")
                .passwordParameter("userpswd")
                .defaultSuccessUrl("/main");

        //3.授权注销
        http.logout().logoutUrl("/logout").logoutSuccessUrl("/login.jsp");

        //4.统一异常处理403
        //通过匿名内部类自行处理
        http.exceptionHandling().accessDeniedHandler(new AccessDeniedHandler() {
            @Override
            public void handle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, AccessDeniedException e) throws IOException, ServletException {
                //同步请求  VS  异步请求
                //处理的方式是不一样的。
                //同步请求直接跳转到错误的页面就可以了；异步请求，需要返回一个错误的标识；
                //X-Requested-With: XMLHttpRequest   异步请求会携带这个请求头信息。同步请求不会携带。
                String s = httpServletRequest.getHeader("X-Requested-With");
                if("XMLHttpRequest".endsWith(s)){ //异步
                    httpServletResponse.getWriter().print("403");
                }else{//同步
                    httpServletRequest.getRequestDispatcher("/WEB-INF/jsp/error/error403.jsp")
                            .forward(httpServletRequest,httpServletResponse);
                }


            }
        });

        //5.授权记住我功能 - cookie版 默认记住我 2周
        //清理浏览器的Cookie 或者 服务器重启  导致记住我功能失效
        http.rememberMe(); //请求必须携带remember-me参数名称

        //禁用csrf
        http.csrf().disable();
    }
}
