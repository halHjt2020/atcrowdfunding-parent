package com.atguigu.atcrowdfunding.bean;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class TPermission implements Serializable {
    private Integer id;

    private String name;

    private String title;

    private String icon;

    private Integer pid;

    private List<TPermission> children = new ArrayList<TPermission>();

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title == null ? null : title.trim();
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon == null ? null : icon.trim();
    }

    public Integer getPid() {
        return pid;
    }

    public void setPid(Integer pid) {
        this.pid = pid;
    }

    @Override
    public String toString() {
        return "TPermission [id=" + id + ", name=" + name + ", title=" + title + ", icon=" + icon + ", pid=" + pid
                + "]";
    }

    public List<TPermission> getChildren() {
        return children;
    }

    public void setChildren(List<TPermission> children) {
        this.children = children;
    }
}