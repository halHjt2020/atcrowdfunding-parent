package com.atguigu.atcrowdfunding.listener;

import com.atguigu.atcrowdfunding.util.Const;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * ServletContextListener：监听服务器启动和销毁时的触发事件，
 *                         重点监听ServletContext对象的创建和销毁。
 */
public class StartSystemInitListener implements ServletContextListener {

    //服务器启动时执行的事件处理
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        System.out.println("StartSystemInitListener - contextInitialized");
        //启动后，拿到application域对象
        ServletContext application = servletContextEvent.getServletContext();
        //之后，拿到上下文路径
        String contextPath = application.getContextPath();
        //将上下文路径 PATH 放到 application域 中共享
        application.setAttribute(Const.PATH,contextPath);
        System.out.println("contextPath = " + contextPath);
    }

    //服务器停止时执行的事件处理
    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        System.out.println("StartSystemInitListener - contextDestroyed");
    }
}
