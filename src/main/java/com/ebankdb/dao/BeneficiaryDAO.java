package com.ebankdb.dao;

import com.ebankdb.config.DBConnection;
import com.ebankdb.model.Beneficiary;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BeneficiaryDAO {
    public String addBeneficiary(int customerId, String name, String accountNumber) {
        try {
            Connection conn = DBConnection.getConnection();

            String check = "SELECT c.name FROM Account a JOIN Customer c ON a.customer_id = c.customer_id WHERE a.account_id = ?";
            PreparedStatement ps1 = conn.prepareStatement(check);
            ps1.setString(1, accountNumber);
            ResultSet rs = ps1.executeQuery();

            if (!rs.next()) {
                return "Invalid account number";
            }

            String actualName = rs.getString("name");

            if (!actualName.equalsIgnoreCase(name)) {
                return "Beneficiary name does not match account holder";
            }

            String sql = "INSERT INTO Beneficiary(customer_id, beneficiary_name, beneficiary_AccNum, date) VALUES (?, ?, ?, CURDATE())";
            PreparedStatement ps2 = conn.prepareStatement(sql);
            ps2.setInt(1, customerId);
            ps2.setString(2, name);
            ps2.setString(3, accountNumber);
            ps2.executeUpdate();
            return "SUCCESS";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Beneficiary already exists";
        }
    }

    public List<Beneficiary> getBeneficiariesByCustomer(int customerId) {
        List<Beneficiary> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM Beneficiary WHERE customer_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Beneficiary b = new Beneficiary();
                b.setBeneficiaryId(rs.getInt("beneficiary_id"));
                b.setCustomerId(rs.getInt("customer_id"));
                b.setBeneficiaryName(rs.getString("beneficiary_name"));
                b.setBeneficiaryAccNum(rs.getString("beneficiary_AccNum"));
                b.setDate(rs.getDate("date").toLocalDate());
                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean deleteBeneficiary(int beneficiaryId) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "DELETE FROM Beneficiary WHERE beneficiary_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, beneficiaryId);
            ps.executeUpdate();

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean checkBeneficiaryExists(int customerId, String accNum){
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM Beneficiary WHERE customer_id=? AND TRIM(beneficiary_AccNum)=TRIM(?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            ps.setString(2, accNum);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        }catch(Exception e){
            e.printStackTrace();
        }
        return false;
    }
}