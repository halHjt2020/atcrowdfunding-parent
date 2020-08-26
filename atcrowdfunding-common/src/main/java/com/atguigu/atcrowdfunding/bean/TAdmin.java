package com.atguigu.atcrowdfunding.bean;


import java.io.Serializable;

public class TAdmin implements Serializable {
    private Integer id;

    private String loginacct;

    private String userpswd;

    private String username;

    private String email;

    private String createtime;


    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getLoginacct() {
        return loginacct;
    }

    public void setLoginacct(String loginacct) {
        this.loginacct = loginacct == null ? null : loginacct.trim();
    }

    public String getUserpswd() {
        return userpswd;
    }

    public void setUserpswd(String userpswd) {
        this.userpswd = userpswd == null ? null : userpswd.trim();
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username == null ? null : username.trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email == null ? null : email.trim();
    }

    public String getCreatetime() {
        return createtime;
    }

    public void setCreatetime(String createtime) {
        this.createtime = createtime == null ? null : createtime.trim();
    }

    public TAdmin() {
        super();
    }

    public TAdmin(String loginacct, String userpswd) {
        super();
        this.loginacct = loginacct;
        this.userpswd = userpswd;
    }

    public TAdmin(Integer id, String loginacct, String userpswd, String username, String email, String createtime) {
        this.id = id;
        this.loginacct = loginacct;
        this.userpswd = userpswd;
        this.username = username;
        this.email = email;
        this.createtime = createtime;
    }

    @Override
    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + ((createtime == null) ? 0 : createtime.hashCode());
        result = prime * result + ((email == null) ? 0 : email.hashCode());
        result = prime * result + ((id == null) ? 0 : id.hashCode());
        result = prime * result + ((loginacct == null) ? 0 : loginacct.hashCode());
        result = prime * result + ((username == null) ? 0 : username.hashCode());
        result = prime * result + ((userpswd == null) ? 0 : userpswd.hashCode());
        return result;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        TAdmin other = (TAdmin) obj;
        if (createtime == null) {
            if (other.createtime != null)
                return false;
        } else if (!createtime.equals(other.createtime))
            return false;
        if (email == null) {
            if (other.email != null)
                return false;
        } else if (!email.equals(other.email))
            return false;
        if (id == null) {
            if (other.id != null)
                return false;
        } else if (!id.equals(other.id))
            return false;
        if (loginacct == null) {
            if (other.loginacct != null)
                return false;
        } else if (!loginacct.equals(other.loginacct))
            return false;
        if (username == null) {
            if (other.username != null)
                return false;
        } else if (!username.equals(other.username))
            return false;
        if (userpswd == null) {
            if (other.userpswd != null)
                return false;
        } else if (!userpswd.equals(other.userpswd))
            return false;
        return true;
    }
}