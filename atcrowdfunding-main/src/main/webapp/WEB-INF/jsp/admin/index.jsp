<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2020/7/27
  Time: 10:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="UTF-8">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <%@include file="/WEB-INF/common/css.jsp"%>
    <style>
        .tree li {
            list-style-type: none;
            cursor:pointer;
        }
        table tbody tr:nth-child(odd){background:#F4F4F4;}
        table tbody td:nth-child(even){color:#C00;}
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/common/top.jsp"></jsp:include>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/common/menu.jsp"></jsp:include>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">



                    <form id="queryForm" class="form-inline" role="form" style="float:left;" action="${PATH}/admin/index" method="post">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input class="form-control has-success" type="text" name="condition" value="${param.condition}" placeholder="请输入查询条件"><%-- value="${param.condition}" 实现条件查询的目标回显 --%>
                            </div>
                        </div>
                        <button id="searchBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>
                    <button id="deleteBatchBtn" type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button type="button" class="btn btn-primary" style="float:right;" onclick="window.location.href='${PATH}/admin/toAdd'"><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">#</th>
                                <%-- 表头的复选框 --%>
                                <th width="30"><input id="theadCheckbox" type="checkbox"></th>
                                <th>账号</th>
                                <th>名称</th>
                                <th>邮箱地址</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>

                            <tbody>

                            <c:forEach items="${page.list}" var="admin" varStatus="status">
                                <tr>
                                    <td>${status.count}</td>
                                    <td><input class="itemCheckboxClass" type="checkbox" adminId="${admin.id}"></td>
                                    <td>${admin.loginacct}</td>
                                    <td>${admin.username}</td>
                                    <td>${admin.email}</td>
                                    <td>
                                        <%-- 分配按钮，给分配按钮绑定事件，做映射 --%>
                                        <button type="button" class="btn btn-success btn-xs" onclick="window.location.href='${PATH}/admin/toAssignRole?id=${admin.id}'"><i class=" glyphicon glyphicon-check"></i></button>
                                        <%-- 修改按钮 &pageNum=${page.pageNum} 修改后立即跳到修改的用户信息页  --%>
                                        <button type="button" class="btn btn-primary btn-xs" onclick="window.location.href = '${PATH}/admin/toUpdate?id=${admin.id}&pageNum=${page.pageNum}'"><i class=" glyphicon glyphicon-pencil"></i></button>
                                        <%-- 删除按钮 有两个参数：${admin.loginacct},${admin.id}--%>
                                        <button type="button" class="btn btn-danger btn-xs" onclick="deleteAdmin('${admin.loginacct}',${admin.id})"><i class=" glyphicon glyphicon-remove"></i></button>
                                    </td>
                                </tr>
                            </c:forEach>

                            <%-- 分页条 --%>
                            </tbody>
                            <tfoot>
                            <tr >
                                <td colspan="6" align="center">
                                    <ul class="pagination">
                                        <c:if test="${page.isFirstPage}">
                                            <li class="disabled"><a href="#">上一页</a></li>
                                        </c:if>
                                        <c:if test="${!page.isFirstPage}">
                                            <li><a href="${PATH}/admin/index?condition=${param.condition}&pageNum=${page.pageNum - 1}">上一页</a></li>
                                        </c:if>

                                        <c:forEach items="${page.navigatepageNums}" var="num">
                                            <c:if test="${num == page.pageNum}">
                                                <li class="active"><a href="${PATH}/admin/index?pageNum=${num}">${num}</a></li>
                                            </c:if>
                                            <c:if test="${num != page.pageNum}">
                                                <li><a href="${PATH}/admin/index?condition=${param.condition}&pageNum=${num}">${num}</a></li>
                                            </c:if>
                                        </c:forEach>

                                        <c:if test="${page.isLastPage}">
                                            <li class="disabled"><a href="#">下一页</a></li>
                                        </c:if>
                                        <c:if test="${!page.isLastPage}">
                                            <li><a href="${PATH}/admin/index?condition=${param.condition}&pageNum=${page.pageNum + 1}">下一页</a></li>
                                        </c:if>
                                    </ul>
                                </td>
                            </tr>

                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/common/js.jsp"%>

<%-- 控制菜单栏的展开与合并  --%>
<script type="text/javascript">
    $(function () {
        $(".list-group-item").click(function(){
            if ( $(this).find("ul") ) {
                $(this).toggleClass("tree-closed");
                if ( $(this).hasClass("tree-closed") ) {
                    $("ul", this).hide("fast");
                } else {
                    $("ul", this).show("fast");
                }
            }
        });
    });

    //回调函数 通过： #id + 回调函数 实现绑定点击事件
    $("#searchBtn").click(function () {
        //提交查询表单
       $("#queryForm").submit();

    });

    //删除一条数据
    function deleteAdmin(loginacct,id) {
        // alert(loginacct+" - "+id);
        //layer弹框组件
        layer.confirm("您确定要删除【"+loginacct+"】账号吗？",{btn:['确定','取消']},function(){
            //确定
            window.location.href = "${PATH}/admin/doDelete?id="+id+"&pageNum=${page.pageNum}";
        },function () {
            //取消
        })
    }

    //复选框联动
    $("#theadCheckbox").click(function () {
       var theadChecked = $(this).prop("checked");
       //alert(theadChecked);
       $(".itemCheckboxClass").prop("checked",theadChecked);
    });
    
    //批量删除（难）
    $("#deleteBatchBtn").click(function () {
        //拿表体否复选框
        var checkedboxList = $(".itemCheckboxClass:checked");
        if(checkedboxList.length == 0){
            layer.msg("请选择要删除的数据");
            return false;
        }

        //ids = '1,2,3,4';
        var idArray = new Array(); //[1,2,3,4]
        var c = '';

        $.each(checkedboxList,function (i,e) { //i 索引 e 元素
            //var adminId = e.adminId; //获取元素自定义属性，这样获取拿不到
            //调用attr()函数获取自定义属性，就可以了
            var adminId = $(e).attr("adminId"); //将dom对象转换为jQuery对象
            idArray.push(adminId);
        });
        //[1,2,3,4] -> "1,2,3,4"  将数组变成了串
        idstr = idArray.join(","); //将数组中的元素循环获取并拼成串，并使用逗号分割

        layer.confirm("您确定要删除这些数据吗？",{btn:['确定','取消']},function(){
            //确定
            window.location.href = "${PATH}/admin/deleteBatch?ids="+idstr+"&pageNum=${page.pageNum}";
        },function(){
            //取消
        });

    });



    /*$("tbody .btn-success").click(function(){
        window.location.href = "assignRole.html";
    });
    $("tbody .btn-primary").click(function(){
        window.location.href = "edit.html";
    });*/
</script>
</body>
</html>

