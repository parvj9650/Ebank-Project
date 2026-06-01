package com.ebankdb.dao;

import com.ebankdb.config.DBConnection;
import com.ebankdb.model.Account;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO {
    public List<Account> getAccountsByCustomerId(int customerId) {
        List<Account> accounts = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM Account WHERE customer_id=? AND status!='Closed'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setCustomerId(rs.getInt("customer_id"));
                acc.setBranchId(rs.getInt("branch_id"));
                acc.setBalance(rs.getBigDecimal("balance"));
                acc.setAccountType(rs.getString("account_type"));
                acc.setStatus(rs.getString("status"));
                accounts.add(acc);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return accounts;
    }

    public List<Account> getAllAccounts(){
        List<Account> accounts = new ArrayList<>();
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM Account WHERE status!='Closed'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setCustomerId(rs.getInt("customer_id"));
                acc.setBranchId(rs.getInt("branch_id"));
                acc.setBalance(rs.getBigDecimal("balance"));
                acc.setAccountType(rs.getString("account_type"));
                acc.setStatus(rs.getString("status"));
                accounts.add(acc);
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return accounts;
    }

    public List<Integer> getAllAccountIds(){
        List<Integer> list = new ArrayList<>();
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT account_id FROM Account WHERE status!='Closed'";
            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while(rs.next())list.add(rs.getInt("account_id"));

        }catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public boolean createAccount(int customerId, int branchId, BigDecimal balance, String accountType){
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO Account(customer_id, branch_id, balance, account_type, status, created_at) VALUES (?, ?, ?, ?, 'Active', NOW())";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, customerId);
            ps.setInt(2, branchId);
            ps.setBigDecimal(3, balance);
            ps.setString(4, accountType);
            ps.executeUpdate();

            return true;

        }catch(Exception e){
            e.printStackTrace();
        }

        return false;
    }

    public void closeAccount(Connection conn, int accountID) {
        try {
            conn.setAutoCommit(false);

            String acc = "UPDATE Account SET status='Closed' WHERE account_id=?";
            PreparedStatement ps1 = conn.prepareStatement(acc);
            ps1.setInt(1,accountID);
            ps1.executeUpdate();

            String txn = "UPDATE Transactions SET status='Closed' WHERE account_id=?";
            PreparedStatement ps2 = conn.prepareStatement(txn);
            ps2.setInt(1,accountID);
            ps2.executeUpdate();

            String fd = "DELETE FROM Fixed_Deposit WHERE account_id=?";
            PreparedStatement ps3 = conn.prepareStatement(fd);
            ps3.setInt(1,accountID);
            ps3.executeUpdate();

            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void freezeAccount(Connection conn, int accountId){
        try{
            String sql = "UPDATE account SET status='Frozen' WHERE account_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, accountId);
            ps.executeUpdate();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public void activateAccount(Connection conn, int accountId){
        try{
            String sql = "UPDATE Account SET status='Active' WHERE account_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, accountId);
            ps.executeUpdate();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
// Add this method to your AccountDAO class

    public boolean updateBalance(int accountId, BigDecimal newBalance) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE Account SET balance = ? WHERE account_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setBigDecimal(1, newBalance);
            ps.setInt(2, accountId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Alternative method if you want to deduct/add specific amount
    public boolean deductAmount(int accountId, BigDecimal amount) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE Account SET balance = balance - ? WHERE account_id = ? AND balance >= ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setBigDecimal(1, amount);
            ps.setInt(2, accountId);
            ps.setBigDecimal(3, amount);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addAmount(int accountId, BigDecimal amount) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE Account SET balance = balance + ? WHERE account_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setBigDecimal(1, amount);
            ps.setInt(2, accountId);

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isFrozen(int accountId){
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT status FROM account WHERE account_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                String status = rs.getString("status");
                if(status.equalsIgnoreCase("Frozen")){
                    return true;
                }
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return false;
    }

    public boolean isClosed(int accountId){
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT status FROM Account WHERE account_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, accountId);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                return rs.getString("status").equalsIgnoreCase("Closed");
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public BigDecimal getBalance(int accountId){
        BigDecimal balance = BigDecimal.ZERO;
        try{
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT balance FROM Account WHERE account_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, accountId);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){
                balance = rs.getBigDecimal("balance");
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return balance;
    }

    public boolean addFunds(int accountId, BigDecimal amount) {
        try {
            Connection conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            String check = "SELECT status FROM Account WHERE account_id=?";
            PreparedStatement psCheck = conn.prepareStatement(check);
            psCheck.setInt(1, accountId);

            ResultSet rs = psCheck.executeQuery();

            if (rs.next()) {
                String status = rs.getString("status");

                if (status.equalsIgnoreCase("Frozen") || status.equalsIgnoreCase("Closed")) {
                    return false;
                }
            }

            String update = "UPDATE Account SET balance = balance + ? WHERE account_id=?";
            PreparedStatement ps1 = conn.prepareStatement(update);
            ps1.setBigDecimal(1, amount);
            ps1.setInt(2, accountId);
            ps1.executeUpdate();

            String txn = "INSERT INTO Transactions(account_id, txn_type, amount, txn_date, status, destination_acc) VALUES (?, 'Credit', ?, NOW(), 'Deposit', NULL)";
            PreparedStatement ps2 = conn.prepareStatement(txn);
            ps2.setInt(1, accountId);
            ps2.setBigDecimal(2, amount);
            ps2.executeUpdate();

            conn.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Account> getAccountsByFilter(int accountId) {
        List<Account> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM Account WHERE account_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, accountId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Account acc = new Account();
                acc.setAccountId(rs.getInt("account_id"));
                acc.setBalance(rs.getBigDecimal("balance"));
                acc.setAccountType(rs.getString("account_type"));
                acc.setStatus(rs.getString("status"));
                list.add(acc);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Integer> getAccountIdsByStatus(String status) {
        List<Integer> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT account_id FROM Account WHERE status=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getInt("account_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Integer> getAccountIdsByNotClosed() {
        List<Integer> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT account_id FROM Account WHERE status != 'Closed'";
            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(rs.getInt("account_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}