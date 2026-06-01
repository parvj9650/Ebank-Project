package com.ebankdb.dao;

import com.ebankdb.config.DBConnection;
import com.ebankdb.model.FixedDeposit;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class FixedDepositDAO {
    public boolean createFD(int customerId, int accountId, BigDecimal amount, double interestRate, BigDecimal maturityAmount, Date maturityDate) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO FixedDeposit (customer_id, account_id, deposit_amt, interest_rate, start_date, maturity_date, maturity_amt, status) VALUES (?, ?, ?, ?, CURDATE(), ?, ?, 'Active')";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            ps.setInt(2, accountId);
            ps.setBigDecimal(3, amount);
            ps.setDouble(4, interestRate);
            ps.setDate(5, maturityDate);
            ps.setBigDecimal(6, maturityAmount);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<FixedDeposit> getFDsByCustomer(int customerId) {
        List<FixedDeposit> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM Fixed_Deposit WHERE customer_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                FixedDeposit fd = new FixedDeposit();
                fd.setFdId(rs.getInt("fd_id"));
                fd.setCustomerId(rs.getInt("customer_id"));
                fd.setAccountId(rs.getInt("account_id"));
                fd.setDepositAmt(rs.getBigDecimal("deposit_amt"));
                fd.setInterestRate(rs.getDouble("interest_rate"));
                fd.setStartDate(rs.getDate("start_date").toLocalDate());
                fd.setMaturityDate(rs.getDate("maturity_date").toLocalDate());
                fd.setStatus(rs.getString("status"));
                BigDecimal principal = rs.getBigDecimal("deposit_amt");
                double rate = rs.getDouble("interest_rate");
                LocalDate start = rs.getDate("start_date").toLocalDate();
                LocalDate maturity = rs.getDate("maturity_date").toLocalDate();

                long days = ChronoUnit.DAYS.between(start, maturity);
                BigDecimal years = BigDecimal.valueOf(days).divide(BigDecimal.valueOf(365), 10, RoundingMode.HALF_UP);
                BigDecimal rateBD = BigDecimal.valueOf(rate);
                BigDecimal interestAmount = principal.multiply(rateBD).multiply(years).divide(BigDecimal.valueOf(100), 10, RoundingMode.HALF_UP);
                BigDecimal maturityAmount = principal.add(interestAmount).setScale(2, RoundingMode.HALF_UP);

                fd.setMaturityAmt(maturityAmount);

                list.add(fd);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    public boolean breakFD(int fdId) {
        try {
            Connection conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String getFD = "SELECT account_id, deposit_amt FROM Fixed_Deposit WHERE fd_id=?";
            PreparedStatement ps1 = conn.prepareStatement(getFD);

            ps1.setInt(1, fdId);
            ResultSet rs = ps1.executeQuery();
            rs.next();

            int accountId = rs.getInt("account_id");
            BigDecimal amount = rs.getBigDecimal("deposit_amt");

            String credit = "UPDATE Account SET balance = balance + ? WHERE account_id=?";
            PreparedStatement ps2 = conn.prepareStatement(credit);
            ps2.setBigDecimal(1, amount);
            ps2.setInt(2, accountId);
            ps2.executeUpdate();

            String update = "UPDATE Fixed_Deposit SET status='Closed' WHERE fd_id=?";
            PreparedStatement ps3 = conn.prepareStatement(update);
            ps3.setInt(1, fdId);
            ps3.executeUpdate();

            String txn = "INSERT INTO Transactions(account_id, txn_type, amount, txn_date, status, destination_acc) VALUES (?, 'Credit', ?, NOW(), 'FD Broken', NULL)";
            PreparedStatement ps4 = conn.prepareStatement(txn);

            ps4.setInt(1, accountId);
            ps4.setBigDecimal(2, amount);
            ps4.executeUpdate();

            conn.commit();

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public int getAccountIdByFdId(int fdId){
        int accountId = -1;
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT account_id FROM Fixed_Deposit WHERE fd_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, fdId);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                accountId = rs.getInt("account_id");
            }

        }catch(Exception e){
            e.printStackTrace();
        }
        return accountId;
    }
}