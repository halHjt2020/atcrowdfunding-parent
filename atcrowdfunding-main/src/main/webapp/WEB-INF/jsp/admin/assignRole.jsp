<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%-- bug点：一定不要忘记获取c标签库，不然 用于数据迭代的 c:foreach 无法使用，即无法从数据库获取数据 --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
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
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/common/top.jsp"></jsp:include>

<div class="container-fluid">
    <div class="row">

        <div class="col-sm-3 col-md-2 sidebar">
        <jsp:include page="/WEB-INF/common/menu.jsp"></jsp:include>
        </div>

        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <ol class="breadcrumb">
                <li><a href="#">首页</a></li>
                <li><a href="#">数据列表</a></li>
                <li class="active">分配角色</li>
            </ol>
            <div class="panel panel-default">
                <div class="panel-body">
                    <form role="form" class="form-inline">
                        <div class="form-group">
                            <label for="exampleInputPassword1">未分配角色列表</label><br>
                            <%-- select下拉列选： size="10"可显示10行数据，超过10行出现滚动条 --%>
                            <%-- multiple：允许多选 --%>
                            <%-- leftRoleList： 左边的下拉列选 --%>
                            <select id="leftRoleList" class="form-control" multiple size="10" style="width:250px;overflow-y:auto;">
                                <c:forEach items="${unAssignList}" var="role"> <%--  c标签库 一定要做绑定 --%>
                                    <option value="${role.id}">${role.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <%-- 两个分配按钮 --%>
                        <div class="form-group">
                            <ul>
                                <li id="leftToRightBtn" class="btn btn-default glyphicon glyphicon-chevron-right"></li>
                                <br>
                                <li id="rightToLeftBtn" class="btn btn-default glyphicon glyphicon-chevron-left" style="margin-top:20px;"></li>
                            </ul>
                        </div>

                        <div class="form-group" style="margin-left:40px;">
                            <label for="exampleInputPassword1">已分配角色列表</label><br>
                            <%-- select下拉列选 --%>
                            <%-- rightRoleList：右边的下拉列选 --%>
                            <select id="rightRoleList" class="form-control" multiple size="10" style="width:250px;overflow-y:auto;">
                                <c:forEach items="${assignList}" var="role">
                                    <option value="${role.id}">${role.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

 <%@include file="/WEB-INF/common/js.jsp"%>

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

    //分配角色
    //左边的按钮
    $("#leftToRightBtn").click(function(){
        var leftOptionSelected = $("#leftRoleList option:selected");

        if(leftOptionSelected.lenght==0){
            layer.msg("请先选择分配角色");
            return false ;
        }

        var str = "adminId=${param.id}" ; //   adminId=${param.id} &roleId=1 &roleId=2 &roleId=3

        $.each(leftOptionSelected,function(i,e){ // e ==>>>  <option value="${role.id}">${role.name}</option>
            var roleId = e.value ;
            str += "&";
            str += "roleId="+roleId;
        });

        $.ajax({
            type:"post",
            url:"${PATH}/admin/doAssignRoleToAdmin",
            data:str,
            success:function(result){
                if("ok"==result){
                    $("#rightRoleList").append(leftOptionSelected.clone());
                    leftOptionSelected.remove();
                    layer.msg("分配成功");
                }else{
                    layer.msg("分配失败");
                }
            }
        });
    });


    //取消分配角色
    //右边的按钮
    $("#rightToLeftBtn").click(function(){
        var rightOptionSelected = $("#rightRoleList option:selected");

        if(rightOptionSelected.lenght==0){
            layer.msg("请先选择要取消分配的角色");
            return false ;
        }

        var str = "adminId=${param.id}" ; //   adminId=${param.id} &roleId=1 &roleId=2 &roleId=3

        $.each(rightOptionSelected,function(i,e){ // e ==>>>  <option value="${role.id}">${role.name}</option>
            var roleId = e.value ;
            str += "&";
            str += "roleId="+roleId;
        });

        $.ajax({
            type:"post",
            url:"${PATH}/admin/doUnAssignRoleToAdmin",
            data:str,
            success:function(result){
                if("ok"==result){
                    $("#leftRoleList").append(rightOptionSelected.clone());
                    rightOptionSelected.remove();
                    layer.msg("取消分配成功");
                }else{
                    layer.msg("取消分配失败");
                }
            }
        });
    });


</script>
</body>
</html>
