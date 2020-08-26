package com.atguigu.atcrowdfunding.bean;

import java.io.Serializable;

public class TPermissionMenu implements Serializable {
    private Integer id;

    private Integer menuid;

    private Integer permissionid;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getMenuid() {
        return menuid;
    }

    public void setMenuid(Integer menuid) {
        this.menuid = menuid;
    }

    public Integer getPermissionid() {
        return permissionid;
    }

    public void setPermissionid(Integer permissionid) {
        this.permissionid = permissionid;
    }
}