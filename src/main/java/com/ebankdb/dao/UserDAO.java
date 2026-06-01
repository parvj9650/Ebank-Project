package com.ebankdb.dao;

import com.ebankdb.config.DBConnection;
import com.ebankdb.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
    public User login(String username, String password) {
        User user = null;
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM User WHERE username=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    public boolean register(String username, String password, String role) {
        try {
            Connection conn = DBConnection.getConnection();

            String check = "SELECT 1 FROM `User` WHERE username=?";
            PreparedStatement ps1 = conn.prepareStatement(check);
            ps1.setString(1, username);

            ResultSet rs = ps1.executeQuery();

            if (rs.next()) {
                return false;
            }

            String sql = "INSERT INTO `User` (username, password, role, created_at) VALUES (?, ?, ?, NOW())";
            PreparedStatement ps2 = conn.prepareStatement(sql);
            ps2.setString(1, username);
            ps2.setString(2, password);
            ps2.setString(3, role);
            ps2.executeUpdate();

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}