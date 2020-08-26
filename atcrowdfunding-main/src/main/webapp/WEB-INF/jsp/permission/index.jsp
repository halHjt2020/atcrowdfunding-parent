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
                <h4 class="modal-title" id="myModalLabel">添加许可</h4>
            </div>
            <div class="modal-body">
                <form id="addForm" role="form">
                    <div class="form-group">
                        <label>许可名称</label>
                        <input type="hidden" name="pid">
                        <input type="text" class="form-control"  name="name" placeholder="请输入许可名称">
                    </div>
                    <div class="form-group">
                        <label>许可图标</label>
                        <input type="text" class="form-control"  name="icon" placeholder="请输入许可图标">
                    </div>
                    <div class="form-group">
                        <label>许可标题</label>
                        <input type="text" class="form-control"  name="title" placeholder="请输入许可标题">
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
                <h4 class="modal-title" id="myModalLabel2">修改许可</h4>
            </div>
            <div class="modal-body">
                <form id="updateForm" role="form">
                    <div class="form-group">
                        <label>ID</label>
                        <input type="hidden" name="pid">
                        <input type="text" class="form-control"  name="id" placeholder="请输入id">
                    </div>
                    <div class="form-group">
                        <label>许可名称</label>
                        <input type="hidden" name="pid">
                        <input type="text" class="form-control"  name="name" placeholder="许可名称">
                    </div>
                    <div class="form-group">
                        <label>许可图标</label>
                        <input type="text" class="form-control"  name="icon" placeholder="许可图标">
                    </div>
                    <div class="form-group">
                        <label>许可标题</label>
                        <input type="text" class="form-control"  name="title" placeholder="许可标题">
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
                },
                key: {
                    url: "xUrl",
                    name: "title"
                },
            },
                view: {
                    addDiyDom: addDiyDom,
                    addHoverDom: addHoverDom, //显示按钮
                    removeHoverDom: removeHoverDom //移除按钮
                }
            };

            //从数据库中（后端）通过json取数据反馈到前端页面  1.加载数据
            $.get("${PATH}/permission/listAllPermissionTree",{},function(result) {
                zNodes=result;
                //取出节点在数据库中存储的内容（id, title, icon 。。。）
                zNodes.push({"id":0,"title":"系统权限","icon":"glyphicon glyphicon-asterisk"});
                //初始化树
                var treeObj = $.fn.zTree.init($("#treeDemo"), setting, zNodes);
                //获取树并展开所有节点
                var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
                treeObj.expandAll(true);

            });
        }

            function addDiyDom(treeId,treeNode){
                //console.log(treeNode);
                //$("#"+treeNode.tId+"_ico").removeClass().addClass(treeNode.icon);
                $("#"+treeNode.tId+"_ico").removeClass();
                $("#"+treeNode.tId+"_span").before('<span class="'+treeNode.icon+'"></span>');
            }

            function addHoverDom(treeId,treeNode){
                var aObj = $("#" + treeNode.tId + "_a");
                aObj.attr("href","#");
                aObj.attr("onclick","return false;");
                if (treeNode.editNameFlag || $("#btnGroup"+treeNode.tId).length>0) return;
                var s = '<span id="btnGroup'+treeNode.tId+'">';
                if ( treeNode.level == 0 ) {
                    s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" onclick="add('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
                } else if ( treeNode.level == 1 ) {
                    s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  href="#" onclick="update('+treeNode.id+')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
                    if (treeNode.children.length == 0) {
                        s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" onclick="remove('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
                    }
                    s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" onclick="add('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
                } else if ( treeNode.level == 2 ) {
                    s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  href="#" onclick="update('+treeNode.id+')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
                    s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" href="#" onclick="remove('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
                }

                s += '</span>';
                aObj.after(s);
            }

            function removeHoverDom(treeId,treeNode){
                $("#btnGroup"+treeNode.tId).remove();
            }


            /*//视图
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
                        s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;"  onclick="update('+treeNode.id+')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
                        s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="remove('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
                        //s += '<a class="btn btn-info dropdown-toggle btn-xs" style="margin-left:10px;padding-top:0px;" onclick="assignBtn('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-anchor rbg "></i></a>';
                    }

                    s += '</span>';
                    aObj.after(s);
                },
                removeHoverDom: function(treeId, treeNode){ //鼠标移出节点触发的事件，隐藏按钮组
                    $("#btnGroup"+treeNode.tId).remove();
                }
            }
        };

        //Ztree树的初始化函数
        var zNodes ={};


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
        var title = $("#addModal input[name='title']").val();

        //2.发起Ajax请求，保存数据
        $.ajax({
            type:"post",
            url:"${PATH}/permission/save",
            data:{
                pid:pid,
                name:name,
                icon:icon,
                title:title
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
                        $("#addModal input[name='title']").val("");
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
        $.get("${PATH}/permission/get",{id:id},function(result) {
            console.log(result);//console.log() 方法用于在控制台输出信息。

            //回显数据
            $("#updateModal input[name='id']").val(result.id);
            $("#updateModal input[name='name']").val(result.name);
            $("#updateModal input[name='icon']").val(result.icon);
            $("#updateModal input[name='title']").val(result.title);

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
        var title = $("#updateModal input[name='title']").val();

        //2.发出ajax请求
        $.ajax({
            type:"post",
            data:{
                id:id,
                name:name,
                icon:icon,
                title:title
            },
            url:"${PATH}/permission/doUpdate",
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


    //---删除功能-------------------------------

    function remove(id){
        layer.confirm("确定要删除这个许可吗?",{btn:["确定","取消"]},function(index){
            $.post("${PATH}/permission/delete",{id:id},function(result){
                if(result=="ok"){
                    layer.msg("删除成功",{time:1000,icon:6},function() {
                        showTree();
                    });
                }else {
                    layer.msg("删除失败",{time:1000,icon:5});
                }
            });
            layer.close(index);
        },function(index){
            layer.close(index);
        });

    }


</script>
</body>
</html>


