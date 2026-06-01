package com.ebankdb.dao;

import com.ebankdb.config.DBConnection;
import com.ebankdb.model.Customer;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    public int getCustomerIdByUserId(int userId) {
        int customerId = -1;
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT customer_id FROM Customer WHERE user_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if(rs.next()) {
                customerId = rs.getInt("customer_id");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return customerId;
    }

    public List<Customer> getCustomersWithoutAccounts(){
        List<Customer> list = new ArrayList<>();
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM customer WHERE customer_id NOT IN (SELECT customer_id FROM account)";
            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Customer c = new Customer();
                c.setCustomerId(rs.getInt("customer_id"));
                c.setName(rs.getString("name"));
                list.add(c);
            }

        }catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public Customer getCustomerByUserId(int userId){
        Customer customer = null;
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM Customer WHERE user_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setUserId(rs.getInt("user_id"));
                customer.setName(rs.getString("name"));
                customer.setAddress(rs.getString("address"));
                customer.setEmail(rs.getString("email"));
                customer.setPhone(rs.getString("phone"));
                customer.setDob(rs.getDate("dob").toLocalDate());
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return customer;
    }

    public boolean saveCustomerProfile(Customer customer) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO Customer(user_id, name, address, email, phone, dob) VALUES(?,?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, customer.getUserId());
            ps.setString(2, customer.getName());
            ps.setString(3, customer.getAddress());
            ps.setString(4, customer.getEmail());
            ps.setString(5, customer.getPhone());
            ps.setDate(6, Date.valueOf(customer.getDob()));
            ps.executeUpdate();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public void updateCustomerProfile(int userId, String name, String address, String email, String phone, LocalDate dob){
        try{
            Connection conn = DBConnection.getConnection();

            String sql = """
                UPDATE Customer
                SET name=?, address=?, email=?, phone=?, dob=?
                WHERE user_id=?
            """;

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, address);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setDate(5, java.sql.Date.valueOf(dob));
            ps.setInt(6, userId);
            ps.executeUpdate();

        }catch(Exception e){
            e.printStackTrace();
        }
    }
}