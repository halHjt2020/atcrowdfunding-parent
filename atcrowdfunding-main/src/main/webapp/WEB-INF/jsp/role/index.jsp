<%--
  Created by IntelliJ IDEA.
  User: HP
  Date: 2020/7/28
  Time: 10:31
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
                    <button id="saveBtn" type="button" class="btn btn-primary" style="float:right;"><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">#</th>
                                <%-- 表头的复选框 id="theadCheckbox" --%>
                                <th width="30"><input id="theadCheckbox" type="checkbox"></th>
                                <th>名称</th>

                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody>

                            </tbody>
                            <tfoot>
                            <tr >
                                <td colspan="6" align="center">
                                    <ul class="pagination">

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


<%-- 添加功能-模态框（异步请求，不跳转页面，弹出对话框（模态框）来解决）
    模态框：模态框经过了优化，更加灵活，以弹出对话框的形式出现，具有最小和最实用的功能集。
    调用方式 - 通过JavaScript调用（有多种，本项目用这种）
        $('#myModal').modal(options)

    方法：
        $('#myModal').modal({
           keyboard: false
        })

--%>
<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">添加</h4>
            </div>
            <div class="modal-body">
                <form id="addForm" role="form">
                    <div class="form-group">
                        <label>名称</label>
                        <input type="text" class="form-control"  name="name" placeholder="请输入角色名称">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="saveModalBtn" type="button" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>


<%-- 修改功能-模态框 --%>
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel2">修改</h4>
            </div>
            <div class="modal-body">
                <form id="updateForm" role="form">
                    <div class="form-group">
                        <label>名称</label>
                        <input type="hidden" name="id">
                        <input type="text" class="form-control"  name="name" placeholder="请输入角色名称">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="updateModalBtn" type="button" class="btn btn-primary">修改</button>
            </div>
        </div>
    </div>
</div>

<%-- 给角色许可分配模态框 --%>
<div class="modal fade" id="assignModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel3">给角色分配许可</h4>
            </div>
            <div class="modal-body">
               <%-- 许可分配树 --%>
                <ul id="treeDemo" class="ztree"></ul>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="assignBtn" type="button" class="btn btn-primary">分配</button>
            </div>
        </div>
    </div>
</div>




<%@include file="/WEB-INF/common/js.jsp"%>

<%-- 控制菜单栏的展开与合并  --%>
<script type="text/javascript">
    $(function () { //页面加载完成时执行的事件处理
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
        showData(1);
    });

    var json = {
        //三个条件
        pageNum:1,
        pageSize:3,
        condition:""
    };

    var pageNum1=1;

    //分页显示权限角色数据(局部刷新的)
    function showData(pageNum) {
        // alert("局部刷新第一页数据");

        json.pageNum = pageNum;
        //发起Ajax请求
        $.ajax({
            type: "post",  //默认get请求
            data:json,    //传json
            url: "${PATH}/role/loadData",
            success:function(result){

                json.totalPages = result.pages;

                console.log(result.list); //拿不到pageInfo这里就无法显示数据（注意业务层代码不要出错） //result  == PageInfo<TRole> ==>>  JSON
                //显示列表数据
                showTable(result.list);
                //显示导航页码
                showNavg(result);
            }
        });
    }

    //显示列表数据
    function showTable(list) {
        var content = '';//在js代码中，拼串推荐使用单引号
        //list在jquery中的循环函数：each()  循环拼串，实现数据条目的增加
        $.each(list,function (i,e) { //i索引， e元素  //roleId="'+e.id+'" 绑自定义id
            content+='<tr>';
            content+='  <td>'+(i+1)+'</td>';
            content+='  <td><input roleId="'+e.id+'"  class="itemCheckboxClass" type="checkbox"></td>';   //表体复选框, class="itemCheckboxClass" 样式类  roleId 自定义的属性
            content+='  <td>'+e.name+'</td>';
            content+='  <td>';
            content+='	  <button type="button" roleId="'+e.id+'" class="assignBtnClass btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>';
            content+='	  <button type="button" roleId="'+e.id+'" class="updateBtnClass btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>';
            content+='	  <button type="button" roleId="'+e.id+'" class="deleteBtnClass btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>';
            content+='  </td>';
            content+='</tr>';
        });

        $("tbody").html(content);
    }

    //显示导航页码
    function showNavg(pageInfo) {
        var content = '';
        if(pageInfo.isFirstPage){
            content+='<li class="disabled"><a href="#">上一页</a></li>';
        }else{
            content+='<li><a onclick="showData('+(pageInfo.pageNum-1)+')">上一页</a></li>';
        }

        $.each(pageInfo.navigatepageNums,function(i,num) {
            if(num == pageInfo.pageNum){
                content+='<li class="active"><a onclick="showData('+num+')">'+num+'</a></li>';
            }else{
                content+='<li><a onclick="showData('+num+')">'+num+'</a></li>';
            }
        });

        if(pageInfo.isLastPage){
            content+='<li class="disabled"><a href="#">下一页</a></li>';
        }else{
            content+='<li><a onclick="showData('+(pageInfo.pageNum+1)+')">下一页</a></li>';
        }
        $(".pagination").html(content);
    }



    //条件查询，回调函数
    $("#searchBtn").click(function () {
        //获取查询条件
        var condition = $("#queryForm input[name='condition']").val();
        json.condition = condition;
        showData(1);
    });


    //---- 异步-模态框方式-添加功能 ----------------------------------------------------
    $("#saveBtn").click(function () {
        //弹出模态框
        $("#addModal").modal({
            show: true,  //模态框初始化后立即显示出来
            backdrop: "static", //静态的，点背景页面不会消失
            keyboard: false    //禁用键盘快捷键esc去关闭模态框
        });
    });

    // 添加按钮（完成权限角色的增加）
    // 1-绑定单击事件
    // 2-获取用户输入页面的数据
    // 3-利用Ajax请求，把数据传给后台，通过弹框返回结果（异步请求）
    // 4-关闭模态框

    //给添加模态框 添加  按钮增加单击事件
    $("#saveModalBtn").click(function () {
        //1.获取表单参数
        var name = $("#addModal input[name='name']").val();

        //2.发起Ajax请求，保存数据
        $.ajax({
            type:"post",
            data:{
              name:name
            },
            url:"${PATH}/role/doAdd",
            success:function (result) {
                //3.判断是否保存成功
                //4.关闭模态框

                //$("#addModal input[name='name']").val("");
                if(result == "ok"){
                    $("#addModal").modal("hide");
                    layer.msg("添加成功",{time:1000,icon:6});
                    showData();
                }else if(result == "403"){
                    layer.msg("您无权访问",{time:1000,icon:5});
                }else{
                    layer.msg("保存失败",{time:1000,icon:5});
                }
            }
        });
    });


    //====== 异步-模态框方式-修改功能 ========================================================
    //对于页面后来元素，增加事件处理时，不能用click()，需要使用on()函数
    /*$(".updateBtnClass").click(function(){
        alert("xxx");
    });*/

    $("tbody").on("click",".updateBtnClass",function(){//.updateBtnClass 样式
        //this.roleId; //不能通过dom对象获取自定义属性值的
        //1.获取修改的数据id
        var roleId = $(this).attr("roleId");
        //2.发起ajax请求，查询数据
        $.get("${PATH}/role/getRoleById",{id:roleId},function (result){ // result == TRole == json {id:1,name:xxx}
            //3.回显数据
            $("#updateModal input[name='name']").val(result.name);
            $("#updateModal input[name='id']").val(result.id);
            //4.弹出模态框
            $("#updateModal").modal({
                show:true, //展示模态框
                backdrop:"static", //点背景页面，不关闭模态框
                keyboard:false  //点esc键，不关闭模态框
            });
        });
    });

    //修改功能
    $("#updateModalBtn").click(function () {
        //1.获取修改表单数据
        var name = $("#updateModal input[name='name']").val();
        var id = $("#updateModal input[name='id']").val();

        //2.提交ajax请求
        $.post("${PATH}/role/doUpdate",{id:id,name:name},function (result) {
            $("#updateModal").modal('hide');
            if(result == "ok"){
                layer.msg("修改成功");
                showData(json.pageNum);
            }else{
                layer.msg("修改失败");
            }
        });
    });


    //--- 异步-删除功能（单项删除）---------------------------------
    //deleteBtnClass:样式类
    $("tbody").on("click",".deleteBtnClass",function(){
        var roleId = $(this).attr("roleId");
        layer.confirm("您确定要删除吗？",{btn:['确定','取消']},function(){
            $.post("${PATH}/role/doDelete",{id:roleId},function(result){
                if(result == "ok"){
                    layer.msg("删除成功");
                    //返回当前页
                    showData(json.pageNum);
                }else{
                    layer.msg("删除失败");
                }
            });
        },function(){});

    });

    //---- 异步-批量删除功能 ------------------------------------------------------
    //1-复选框联动
    $("#theadCheckbox").click(function () {
        var theadChecked = $(this).prop("checked");
        // alert(theadChecked);
        $(".itemCheckboxClass").prop("checked",theadChecked);
    });

    //2-批量删除（难）
    $("#deleteBatchBtn").click(function () {
        var checkedboxList = $(".itemCheckboxClass:checked");
        if(checkedboxList == 0){
            layer.msg("请选择要删除的角色");
            return false;
        }
        var idStr = "";
        var idArray = new Array();

        $.each(checkedboxList,function (i,e) {
            var roleId = $(e).attr("roleId");
            idArray.push(roleId);
        });
        idStr = idArray.join(",");

        //异步请求，且跳回当前页面
        layer.confirm("您确定要删除吗？",{btn:['确定','取消']},function(){
            $.post("${PATH}/role/deleteBatch?",{ids:idStr,pageNum:pageNum1},function(result){
                if (result == "ok"){
                    layer.msg("角色删除成功");
                    showData(pageNum1);
                }else {
                    layer.msg("角色删除失败");
                }
            });
        },function(){});
    });


    //-------角色权限许可分配---------------------------

    //1 - 先弹出模态框(异步方式弹出)，异步方式，所以按钮算后来元素，用on函数
    var roleId = null;
    $("tbody").on("click",".assignBtnClass",function () {

        roleId = $(this).attr("roleId"); //拿到roleId

        //初始化树
        initTree();

        $("#assignModal").modal({
            show:true,
            backdrop:'static',
            keyboard:false
        });
    });

    //ZTree的生成函数
    function initTree() {

        var setting = {
            data:{
                simpleData:{
                    enable:true,
                    pIdKey:"pid"
                },
                key:{
                    url:"xUrl",
                    name:"title"
                }
            },
            view:{
                addDiyDom:function (treeId,treeNode) {
                    $("#"+treeNode.tId+"_ico").removeClass();
                    $("#"+treeNode.tId+"_span").before('<span class="'+treeNode.icon+'"></span>');
                }
            },
            /*给节点前加上复选框*/
            check:{
                enable:true
            }
        };

        // 两个异步请求并行，会出现回显不上的情况。需要将两个并行请求修改为两个串行请求。

        //1.加载数据
        $.get("${PATH}/permission/listAllPermissionTree",function(data){
            var tree = $.fn.zTree.init($("#treeDemo"), setting, data);
            var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            treeObj.expandAll(true);


            //2.回显数据,把已经分配的许可id查询出来
            $.get("${PATH}/role/listPermissionIdByRoleId",{roleId:roleId},function(data){
                //alert(roleId);
                console.log(data);
                $.each(data,function(i,e){
                    var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
                    var node = treeObj.getNodeByParam("id", e, null); //表示从整颗树上查找id=xxx的节点
                    treeObj.checkNode(node, true, false); //节点   打钩   是否联动
                });
            });
        });
    }

    //2 - 分配按钮
    //给角色分配许可
    $("#assignBtn").click(function () {
        var rid = roleId ;
        var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        var nodes = treeObj.getCheckedNodes(true); //获取树上被勾选的节点集合

        //alert(roleId);

        //roleId=2&permissionId=1&permissionId=2&permissionId=3
        var str = 'roleId='+rid;

        //alert(str);

        //迭代，拿id
        $.each(nodes,function (i,e) {
            var permissionId = e.id; //e 就表示节点数据，节点就是就是由TPermission对象生成JSON串  {id:1,name:'user:add',title:'添加'}
            str+="&";
            str+="ids="+permissionId
           /* console.log(permissionId);

            json['ids['+i+']'] = permissionId;*/
        });


        $.ajax({
            type:"post",
            url:"${PATH}/role/doAssignPermissionToRole",
            data:str,
            success:function(result){

                if("ok" == result){
                    $("#assignModal").modal('hide');
                    layer.msg("分配成功");
                }else{
                    layer.msg("分配失败");
                }
            }
        });
    });





</script>
</body>
</html>


