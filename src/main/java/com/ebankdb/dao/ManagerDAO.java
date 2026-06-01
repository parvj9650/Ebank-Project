package com.ebankdb.dao;

import com.ebankdb.config.DBConnection;
import com.ebankdb.model.Manager;

import java.sql.*;
import java.util.*;

public class ManagerDAO {
    public void createManager(Connection conn, int employeeId, String name, String email, String phone) throws Exception {
        String sql = "INSERT INTO Manager(employee_id, name, email, phone_no) VALUES (?,?,?,?)";

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1,employeeId);
        ps.setString(2,name);
        ps.setString(3,email);
        ps.setString(4,phone);
        ps.executeUpdate();
    }

    public boolean isManagerProfileComplete(int userId){
        boolean exists = false;
        try{
            Connection conn = DBConnection.getConnection();

            String sql = """
                SELECT m.employee_id
                FROM Manager m
                JOIN Employee e ON m.employee_id = e.employee_id
                WHERE e.user_id = ?
            """;

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                exists = true;
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return exists;
    }

    // Customer View
    public List<Map<String, Object>> getCustomerDetails(){
        List<Map<String, Object>> list = new ArrayList<>();
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM Manager_Customer_Details";
            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Map<String, Object> row = new HashMap<>();
                row.put("customer_id", rs.getInt("customer_id"));
                row.put("customer_name", rs.getString("customer_name"));
                row.put("email", rs.getString("email"));
                row.put("phone", rs.getString("phone"));
                row.put("account_id", rs.getObject("account_id")); // nullable
                row.put("account_type", rs.getString("account_type"));
                row.put("balance", rs.getBigDecimal("balance"));
                row.put("account_status", rs.getString("account_status"));
                row.put("branch_name", rs.getString("branch_name"));
                list.add(row);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getCustomerDetailsById(int customerId){
        List<Map<String, Object>> list = new ArrayList<>();
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM Manager_Customer_Details WHERE customer_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Map<String, Object> row = new HashMap<>();
                row.put("customer_id", rs.getInt("customer_id"));
                row.put("customer_name", rs.getString("customer_name"));
                row.put("email", rs.getString("email"));
                row.put("phone", rs.getString("phone"));
                row.put("account_id", rs.getObject("account_id")); // nullable
                row.put("account_type", rs.getString("account_type"));
                row.put("balance", rs.getBigDecimal("balance"));
                row.put("account_status", rs.getString("account_status"));
                row.put("branch_name", rs.getString("branch_name"));
                list.add(row);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }

    // Employee View
    public List<Map<String, Object>> getEmployeeDetails(){
        List<Map<String, Object>> list = new ArrayList<>();
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM Manager_Employee_Details";
            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Map<String, Object> row = new HashMap<>();
                row.put("employee_id", rs.getInt("employee_id"));
                row.put("employee_name", rs.getString("employee_name"));
                row.put("designation", rs.getString("designation"));
                row.put("hire_date", rs.getDate("hire_date"));
                row.put("branch_name", rs.getString("branch_name"));
                row.put("ifsc", rs.getString("IFSC"));
                list.add(row);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getEmployeeDetailsById(int employeeId){
        List<Map<String, Object>> list = new ArrayList<>();
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM Manager_Employee_Details WHERE employee_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, employeeId);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Map<String, Object> row = new HashMap<>();
                row.put("employee_id", rs.getInt("employee_id"));
                row.put("employee_name", rs.getString("employee_name"));
                row.put("designation", rs.getString("designation"));
                row.put("hire_date", rs.getDate("hire_date"));
                row.put("branch_name", rs.getString("branch_name"));
                row.put("ifsc", rs.getString("IFSC"));
                list.add(row);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getAuditLogs(){
        List<Map<String, Object>> list = new ArrayList<>();
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM Manager_Audit_Log_View ORDER BY action_date DESC";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Map<String, Object> row = new HashMap<>();
                row.put("log_id", rs.getInt("log_id"));
                row.put("employee_id", rs.getInt("employee_id"));
                row.put("employee_name", rs.getString("employee_name"));
                row.put("action", rs.getString("action"));
                row.put("action_date", rs.getTimestamp("action_date"));
                row.put("description", rs.getString("description"));
                list.add(row);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getAuditLogsByEmployeeId(int employeeId){
        List<Map<String, Object>> list = new ArrayList<>();
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM Manager_Audit_Log_View WHERE employee_id = ? ORDER BY action_date DESC";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, employeeId);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Map<String, Object> row = new HashMap<>();
                row.put("log_id", rs.getInt("log_id"));
                row.put("employee_id", rs.getInt("employee_id"));
                row.put("employee_name", rs.getString("employee_name"));
                row.put("action", rs.getString("action"));
                row.put("action_date", rs.getTimestamp("action_date"));
                row.put("description", rs.getString("description"));
                list.add(row);
            }
            conn.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public Manager getManagerByUserId(int userId) {
        Manager manager = null;

        try {
            Connection conn = DBConnection.getConnection();

            String sql = """
            SELECT m.*
            FROM Manager m
            JOIN Employee e ON m.employee_id = e.employee_id
            WHERE e.user_id=?
        """;

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                manager = new Manager();
                manager.setEmployeeId(rs.getInt("employee_id"));
                manager.setName(rs.getString("name"));
                manager.setEmail(rs.getString("email"));
                manager.setPhoneNo(rs.getString("phone_no"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return manager;
    }
}
