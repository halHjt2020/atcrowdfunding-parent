<%--
  Created by IntelliJ IDEA.
  User: HP
  Date: 2020/7/26
  Time: 5:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="col-sm-3 col-md-2 sidebar">
    <div class="tree">
        <ul style="padding-left:0px;" class="list-group">

            <%-- 集合的迭代 --%>
            <c:forEach items="${parentMenuList}" var="parentMenu">
                <%--判断：没孩子菜单
                    ${PATH}/  上下文路径
                --%>
                <c:if test="${empty parentMenu.children}">
                    <li class="list-group-item tree-closed" >
                        <a href="${PATH}/${parentMenu.url}"><i class="${parentMenu.icon}"></i> ${parentMenu.name}</a>
                    </li>
                </c:if>
                <%-- 判断：有孩子菜单 --%>
                <c:if test="${not empty parentMenu.children}">
                    <li class="list-group-item tree-closed">
                        <span><i class="${parentMenu.icon}"></i> ${parentMenu.name} <span class="badge" style="float:right">${parentMenu.children.size()}</span></span>
                        <ul style="margin-top:10px;display:none;">
                            <%-- 孩子的迭代 --%>
                            <c:forEach items="${parentMenu.children}" var="childMenu">
                                <li style="height:30px;">
                                    <a href="${PATH}/${childMenu.url}"><i class="${childMenu.icon}"></i> ${childMenu.name}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </li>
                </c:if>
            </c:forEach>

        </ul>
    </div>
</div>
