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
                        <ul id="treeDemo" class="ztree"></ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>



    <!-- addModal 添加模态框  -->
    <div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">添加菜单</h4>
                </div>
                <div class="modal-body">
                    <form id="addForm" role="form">
                        <div class="form-group">
                            <label>菜单名称</label>
                            <input type="hidden" name="pid">
                            <input type="text" class="form-control"  name="name" placeholder="请输入菜单名称">
                        </div>
                        <div class="form-group">
                            <label>菜单图标</label>
                            <input type="text" class="form-control"  name="icon" placeholder="请输入菜单图标">
                        </div>
                        <div class="form-group">
                            <label>菜单URL</label>
                            <input type="text" class="form-control"  name="url" placeholder="请输入菜单URL">
                        </div>
                    </form>
                 </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
                </div>
            </div>
        </div>
    </div>


    <%-- updateModal 修改模态框 --%>
    <div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel2">修改菜单</h4>
                </div>
                <div class="modal-body">
                    <form id="updateForm" role="form">
                        <div class="form-group">
                            <label>ID</label>
                            <input type="hidden" name="pid">
                            <input type="text" class="form-control"  name="id" placeholder="请输入id">
                        </div>
                        <div class="form-group">
                            <label>菜单名称</label>
                            <input type="hidden" name="pid">
                            <input type="text" class="form-control"  name="name" placeholder="请输入菜单名称">
                        </div>
                        <div class="form-group">
                            <label>菜单图标</label>
                            <input type="text" class="form-control"  name="icon" placeholder="请输入菜单图标">
                        </div>
                        <div class="form-group">
                            <label>菜单URL</label>
                            <input type="text" class="form-control"  name="url" placeholder="请输入菜单URL">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="updateBtn" type="button" class="btn btn-primary">修改</button>
                </div>
            </div>
        </div>
    </div>


    <%-- 给菜单分配许可模态框 --%>
    <div class="modal fade" id="permissionModal" tabindex="-1" role="dialog" aria-labelledby="Modal">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel3">给菜单分配权限</h4>
                    </div>
                    <div class="modal-body">
                        <%-- 许可树 --%>
                        <ul id="assignPermissionTree" class="ztree"></ul>
                    </div>
                    <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="assignPermission" type="button" class="btn btn-primary">分配</button>
                </div>
            </div>
        </div>
    </div>





<%@include file="/WEB-INF/common/js.jsp"%>

<%-- 控制菜单栏的展开与合并  --%>
<script type="text/javascript">
    $(function () { //页面ready函数
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
        //页面加载完成时，就初始化树
        showTree();

    });

    //树的展示
    function showTree() {
        //控制树如何展示
        var setting = {
            data: {
                simpleData: {
                    enable: true,
                    pIdKey: 'pid'
                }
            },
            //视图
            view:{
    //treeNode表示一个节点，而一个节点其实就是一个后台TMenu对象。
    addDiyDom: function(treeId, treeNode){ // treeId就是容器id;  treeNode就是每一个具体的节点
        $("#"+treeNode.tId+"_ico").removeClass();//.addClass();
        $("#"+treeNode.tId+"_span").before("<span class='"+treeNode.icon+"'></span>");
    },
        //鼠标移动到节点上触发事件，增加按钮组
        addHoverDom: function(treeId, treeNode){
        var aObj = $("#" + treeNode.tId + "_a"); // tId = permissionTree_1, ==> $("#permissionTree_1_a")
        //aObj.attr("href", "javascript:;"); //禁用href,不起作用。这样设置是无效的。
        // <a href="#" onclick="return false;">xxx</a>

        //禁用href
        aObj.attr("href","#");
        aObj.attr("onclick","return false;");


    if (treeNode.editNameFlag || $("#btnGroup"+treeNode.tId).length>0) return;

                var s = '<span id="btnGroup'+treeNode.tId+'">';
                if ( treeNode.level == 0 ) { //根节点
                    s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="add('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
                } else if ( treeNode.level == 1 ) { //分支节点
                    s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  onclick="update('+treeNode.id+')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
                if (treeNode.children.length == 0) {  //没有子节点的节点，可以删除的。
                    s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="remove('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
                }
                    s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="add('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
                } else if ( treeNode.level == 2 ) { //叶子节点
                    //修改菜单项按钮
                    s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  onclick="update('+treeNode.id+')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
                    //删除菜单项按钮
                    s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="remove('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
                    //菜单分配许可按钮
                    s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="assignBtn('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-anchor rbg "></i></a>';
                }

                    s += '</span>';
                    aObj.after(s);
                },
                removeHoverDom: function(treeId, treeNode){ //鼠标移出节点触发的事件，隐藏按钮组
                    $("#btnGroup"+treeNode.tId).remove();
                }
            }
        };

        //简单json格式的树
        //var zNodes = {};

        //异步请求
        /*$.get("/menu/loadTree",{},function(zNodes) {
    //zNodes = result;

    //增加根节点
    zNodes.push({"id":0,"name":"系统权限菜单","icon":"glyphicon glyphicon-th-list","children":[]});

    //获取树并展开所有节点
    $.fn.zTree.init($("#treeDemo"), setting, zNodes);

    //初始化树
    var treeObj = $.fn.zTree.init("treeDemo");


    treeObj.expandAll(true);

    });*/


    //Ztree树的初始化函数
    var zNodes ={};

        //从数据库中（后端）通过json取数据反馈到前端页面
        $.get("${PATH}/menu/loadTree",{},function(result) {
            zNodes=result;
            //增加根节点
            zNodes.push({"id":0,"name":"系统权限菜单","icon":"glyphicon glyphicon glyphicon-tasks","children":[]});
            //初始化树
            var treeObj = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
            //获取树并展开所有节点
            //var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            treeObj.expandAll(true);

        });
    }


   /* //给树节点增加自定义  字体图标
    //treeId 表示生成树的位置  叫容器id
    //treeNode 节点对象 一个节点对象  就相当于一个TMenu对象
    function customeIcon(treeId,treeNode) {
        //tId  由 treeId + "_" + 序号
        // tId + "_ico" 获取显示字体图标的元素
        // tId + "_span" 获取显示节点名称的元素
        $("#"+treeNode.tId+"_ico").removeClass();//.addClass();
        $("#"+treeNode.tId+"_span").before("<span class='"+treeNode.icon+"'></span>")
    }*/


    /*/!**
    * 鼠标移动到节点上显示按钮组
    * @param treeId
    * @param treeNode
    *!/
    function customeAddBtn(treeId, treeNode) {
        var aObj = $("#" + treeNode.tId + "_a");

        aObj.attr("href", "javascript:;"); //禁用链接（点击后不会跳转链接）
        aObj.attr("onclick", "return false;"); //禁用单击事件

    if (treeNode.editNameFlag || $("#btnGroup"+treeNode.tId).length>0) {
        return;
    }

    //拼按钮组（模态框的绑定：使用HTML的 onclick 事件属性 ）
    var s = '<span id="btnGroup'+treeNode.tId+'">';
    if ( treeNode.level == 0 ) { //根节点 level == 0
        s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="add('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
    } else if ( treeNode.level == 1 ) { //分支节点  level == 1
        s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  onclick="update('+treeNode.id+')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
        if (treeNode.children.length == 0) {//没有子节点的节点，可以删除的。
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="remove('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
        }
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="add('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
        } else if ( treeNode.level == 2 ) { //叶子节点  level == 2
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  onclick="update('+treeNode.id+')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
            s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="remove('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
            //s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="remove('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
        }
        s += '</span>';
        aObj.after(s);
    }*/



    /*/!**
    * 鼠标离开节点去掉按钮组
    * @param treeId
    * @param treeNode
    *!/
    function customeRemoveBtn(treeId, treeNode) {
        $("#btnGroup"+treeNode.tId).remove(); //删除按钮组
    }*/




    //----------添加功能（模态框方式）-----------------
    //第一部分：回显+弹出
    function add(id) {
        //回显数据
        $("#addModal input[name='pid']").val(id);
        //弹出模态框
        $('#addModal').modal({
            show: true, //模态框初始化后立即显示出来
            backdrop: 'static', //静态的，点背景页面不会消失
            keyboard: false //禁用键盘快捷键esc去关闭模态框
        })
    }

        //第二部分：完成具体功能，给添加模态框 添加  按钮增加单击事件
        $("#saveBtn").click(function() {
            //1.获取参数
            var pid = $("#addModal input[name='pid']").val();
            var name = $("#addModal input[name='name']").val();
            var icon = $("#addModal input[name='icon']").val();
            var url = $("#addModal input[name='url']").val();

            //2.发起Ajax请求，保存数据
            $.ajax({
                type:"post",
                url:"${PATH}/menu/save",
                data:{
                     pid:pid,
                     name:name,
                     icon:icon,
                     url:url
                },
                success:function(result) {
                    //3.判断是否保存成功
                    //4.关闭模态框
                    if(result == 'ok'){
                        layer.msg("添加成功",{time:1000,icon:6},function() {
                            $("#addModal").modal("hide");
                            $("#addModal input[name='pid']").val("");
                            $("#addModal input[name='name']").val("");
                            $("#addModal input[name='icon']").val("");
                            $("#addModal input[name='url']").val("");
                            showTree();
                        });
                    }else{
                        layer.msg("添加失败",{time:1000,icon:5});
                    }
                }
            });
        });



    //----------修改功能（模态框方式）-----------------

    //第一部分：回显数据+弹出框
    function update(id) {
        //获取数据
        $.get("${PATH}/menu/get",{id:id},function(result) {
            console.log(result);//console.log() 方法用于在控制台输出信息。

            //回显数据
            $("#updateModal input[name='id']").val(result.id);
            $("#updateModal input[name='name']").val(result.name);
            $("#updateModal input[name='icon']").val(result.icon);
            $("#updateModal input[name='url']").val(result.url);

            //弹出模态框
            $("#updateModal").modal({
                show: true,  //模态框初始化后立即显示出来
                backdrop: 'static', //静态的，点背景页面不会消失
                keyboard: false    //禁用键盘快捷键esc去关闭模态框
            });
        });
    }

    //第二部分：给修改按钮增加修改（更新）功能
    $("#updateBtn").click(function() {
        //1.获取参数
        var id = $("#updateModal input[name='id']").val();
        var name = $("#updateModal input[name='name']").val();
        var icon = $("#updateModal input[name='icon']").val();
        var url = $("#updateModal input[name='url']").val();
        
        //2.发出ajax请求
        $.ajax({
            type:"post",
            data:{
                id:id,
                name:name,
                icon:icon,
                url:url
            },
            url:"${PATH}/menu/doUpdate",
            success:function(result) { //提交成功与否返回的结果
                if(result == 'ok'){
                   $("#updateModal").modal('hide');
                        layer.msg("修改成功",{time:1000,icon:6},function() {
                        showTree();
                    });
                }else{
                    layer.msg("修改失败",{time:1000,icon:5});
                }
            }
        });
    });


    //---删除-------------------------------

    function remove(id) {
        layer.confirm('您确定要删除这条数据吗?',{btn:['确定','取消']},function(index) {

            $.post("${PATH}/menu/delete",{id:id},function(result) {
                if(result == 'ok'){
                    layer.msg("删除成功",{time:1000,icon:6},function() {
                        showTree();
                    });
                }else {
                    layer.msg("删除失败",{time:1000,icon:5});
                }
            });

            layer.close(index);
        },function(index) {
            layer.close(index);
         });
    }

    //-----菜单分配许可功能--------------------------------

    //第一部分：回显数据+弹出模态框
    var tempMenuid = null;
    function assignBtn(menuid) {
        tempMenuid = menuid;

        //1 - 初始化权限树
        initPermissionToMenuTree();

        //2 - 显示模态框，并展示许可树（权限树）
        $("#permissionModal").modal({
            show:true,
            backdrop:"static"
        });

    }

    function initPermissionToMenuTree() {

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
            check:{
                enable : true
            },
            view:{
                //鼠标移动到图标后触发的事件
                addDiyDom:function(treeId,treeNode) {
                    $("#"+treeNode.tId+"_ico").removeClass();
                    $("#"+treeNode.tId+"_span").before('<spqn class="'+treeNode.icon+'"></span>');
                }
            },
            //给节点前加上复选框
            check:{
                enable:true
            }
        };

        //1.加载数据
        $.get("${PATH}/permission/listAllPermissionTree",function(data){
            var tree = $.fn.zTree.init($("#assignPermissionTree"), setting, data);
            var treeObj = $.fn.zTree.getZTreeObj("assignPermissionTree");
            treeObj.expandAll(true);

            //2.回显权限树
            showMenuPermissions(tempMenuid);
        });
    }

    //第二部分 - 分配权限（许可）
    $("#assignPermission").click(function() {
        //1.获取到已选中的所有id
        var treeObj = $.fn.zTree.getZTreeObj("assignPermissionTree");
        var ids = new Array(); //获取树上被勾选的节点集合

        $.each(treeObj.getCheckedNodes(true),function() {
            ids.push(this.id);
        });
        var idsStr = ids.join();

        //2.组装后台要提交的数据
        var data = {mid:tempMenuid,perIds:idsStr};
        console.log(data);

        //3.请求，完成菜单项分配权限（许可）
        $.post("${PATH}/menu/assignPermissionToMenu",data,function() {
            layer.msg("权限分配完成...")
            $("#permissionModal").modal('hide');
        })
    });

    //回显权限树
    function showMenuPermissions(menuid) {
        $.get("${PATH}/menu/menu_permission?menuid="+menuid, function(data) {
            //遍历每一个权限，在zTree中选中对应的节点
            $.each(data,function() {
                console.log(this);
                var treeObj = $.fn.zTree.getZTreeObj("assignPermissionTree");
                var node = treeObj.getNodeByParam("id", this.id, null); //根据指定的节点id搜索节点，null表示搜索整个树
                treeObj.checkNode(node,true,false);//需要回显的节点，是否勾选复选框，
                // 父子节点勾选是否联动
                //（例如：勾选父节点，要不要把它的所有子节点都勾上，取消父节点勾选，要不要把它的所有子节点也都取消勾选）
            });
        });
    }








</script>
</body>
</html>

