package com.ebankdb.dao;

import com.ebankdb.config.DBConnection;
import com.ebankdb.model.Employee;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class EmployeeDAO {
    public void createEmployee(int userId, int branchId, String name, String designation, Date hireDate){
        try{
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO Employee (user_id, branch_id, name, designation, hire_date) VALUES (?,?,?,?,?) ";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1,userId);
            ps.setInt(2,branchId);
            ps.setString(3,name);
            ps.setString(4,designation);
            ps.setDate(5,hireDate);

            ps.executeUpdate();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public int createEmployee(Connection conn, int userId, int branchId, String name, String designation, Date hireDate) throws Exception {
        String sql = """
            INSERT INTO Employee(user_id, branch_id, name, designation, hire_date)
            VALUES (?, ?, ?, ?, ?)
         """;

        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

        ps.setInt(1, userId);
        ps.setInt(2, branchId);
        ps.setString(3, name);
        ps.setString(4, designation);
        ps.setDate(5, hireDate);
        ps.executeUpdate();

        ResultSet rs = ps.getGeneratedKeys();
        rs.next();

        return rs.getInt(1);
    }

    public Employee getEmployeeByUserId(int userId){
        Employee emp = null;
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM Employee WHERE user_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1,userId);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                emp = new Employee();
                emp.setEmployeeId(rs.getInt("employee_id"));
                emp.setUserId(rs.getInt("user_id"));
                emp.setBranchId(rs.getInt("branch_id"));
                emp.setName(rs.getString("name"));
                emp.setDesignation(rs.getString("designation"));
                emp.setHireDate(rs.getDate("hire_date").toLocalDate());
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return emp;
    }

    public int getEmployeeIdByUserId(int userId){
        int empId = -1;
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT employee_id FROM Employee WHERE user_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1,userId);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                empId = rs.getInt("employee_id");
            }

        }catch(Exception e){
            e.printStackTrace();
        }
        return empId;
    }

    public String getBranchNameByEmployeeId(int empId){
        String branch = "";
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT b.branch_name FROM Employee e JOIN Branch b ON e.branch_id = b.branch_id WHERE e.employee_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, empId);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                branch = rs.getString("branch_name");
            }

        }catch(Exception e){
            e.printStackTrace();
        }
        return branch;
    }

    public List<Map<String, Object>> getCustomerDetailsForEmployee(){
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try{
            conn = DBConnection.getConnection();

            String sql = """
                SELECT 
                    c.customer_id,
                    c.name AS customer_name,
                    c.email,
                    c.phone,
                    a.account_id,
                    a.account_type,
                    a.balance,
                    a.status AS account_status,
                    b.branch_name
                FROM Customer c
                LEFT JOIN Account a ON c.customer_id = a.customer_id
                LEFT JOIN Branch b ON a.branch_id = b.branch_id
                ORDER BY c.customer_id
            """;

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while(rs.next()){
                Map<String, Object> row = new HashMap<>();
                row.put("customer_id", rs.getInt("customer_id"));
                row.put("customer_name", rs.getString("customer_name"));
                row.put("email", rs.getString("email"));
                row.put("phone", rs.getString("phone"));
                row.put("account_id", rs.getObject("account_id"));
                row.put("account_type", rs.getString("account_type"));
                row.put("balance", rs.getBigDecimal("balance"));
                row.put("account_status", rs.getString("account_status"));
                row.put("branch_name", rs.getString("branch_name"));
                list.add(row);
            }
        } catch(Exception e){
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        return list;
    }

    // NEW: Customer View for Employee - Get customer by ID
    public List<Map<String, Object>> getCustomerDetailsByIdForEmployee(int customerId){
        List<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try{
            conn = DBConnection.getConnection();

            String sql = """
                SELECT 
                    c.customer_id,
                    c.name AS customer_name,
                    c.email,
                    c.phone,
                    a.account_id,
                    a.account_type,
                    a.balance,
                    a.status AS account_status,
                    b.branch_name
                FROM Customer c
                LEFT JOIN Account a ON c.customer_id = a.customer_id
                LEFT JOIN Branch b ON a.branch_id = b.branch_id
                WHERE c.customer_id = ?
                ORDER BY c.customer_id
            """;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();

            while(rs.next()){
                Map<String, Object> row = new HashMap<>();
                row.put("customer_id", rs.getInt("customer_id"));
                row.put("customer_name", rs.getString("customer_name"));
                row.put("email", rs.getString("email"));
                row.put("phone", rs.getString("phone"));
                row.put("account_id", rs.getObject("account_id"));
                row.put("account_type", rs.getString("account_type"));
                row.put("balance", rs.getBigDecimal("balance"));
                row.put("account_status", rs.getString("account_status"));
                row.put("branch_name", rs.getString("branch_name"));
                list.add(row);
            }
        } catch(Exception e){
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
        return list;
    }

    public Map<String, Object> getEmployeeWithManagerDetails(int userId) {
        Map<String, Object> profile = new HashMap<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();

            String sql = """
                SELECT e.employee_id, e.user_id, e.branch_id, e.name, e.designation, e.hire_date,
                       b.branch_name,
                       m.email, m.phone_no,
                       CASE WHEN m.employee_id IS NOT NULL THEN true ELSE false END as is_manager
                FROM Employee e
                LEFT JOIN Branch b ON e.branch_id = b.branch_id
                LEFT JOIN Manager m ON e.employee_id = m.employee_id
                WHERE e.user_id = ?
            """;

            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                profile.put("employee_id", rs.getInt("employee_id"));
                profile.put("user_id", rs.getInt("user_id"));
                profile.put("branch_id", rs.getInt("branch_id"));
                profile.put("branch_name", rs.getString("branch_name"));
                profile.put("name", rs.getString("name"));
                profile.put("designation", rs.getString("designation"));
                profile.put("hire_date", rs.getDate("hire_date"));
                profile.put("is_manager", rs.getBoolean("is_manager"));

                if (rs.getBoolean("is_manager")) {
                    profile.put("email", rs.getString("email") != null ? rs.getString("email") : "");
                    profile.put("phone_no", rs.getString("phone_no") != null ? rs.getString("phone_no") : "");
                } else {
                    profile.put("email", "");
                    profile.put("phone_no", "");
                }
            }

        } catch(Exception e){
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }

        return profile;
    }

    // UPDATED: Update employee profile (and manager if applicable)
    public void updateEmployeeProfile(int userId, String name, String email, String phone, int branchId) {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();

            int employeeId = getEmployeeIdByUserId(userId);

            // ✅ Update Employee table
            String sql1 = "UPDATE Employee SET name=?, branch_id=? WHERE user_id=?";
            ps = conn.prepareStatement(sql1);
            ps.setString(1, name);
            ps.setInt(2, branchId);
            ps.setInt(3, userId);
            ps.executeUpdate();
            ps.close();

            // ✅ Check if manager
            String check = "SELECT COUNT(*) FROM Manager WHERE employee_id=?";
            ps = conn.prepareStatement(check);
            ps.setInt(1, employeeId);
            ResultSet rs = ps.executeQuery();
            rs.next();

            if (rs.getInt(1) > 0) {
                String sql2 = "UPDATE Manager SET name=?, email=?, phone_no=? WHERE employee_id=?";
                ps = conn.prepareStatement(sql2);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, phone);
                ps.setInt(4, employeeId);
                ps.executeUpdate();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
