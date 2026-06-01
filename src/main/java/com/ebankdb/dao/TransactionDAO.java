package com.ebankdb.dao;

import com.ebankdb.config.DBConnection;
import com.ebankdb.model.Transaction;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {
    public String transferMoney(int fromAcc, int toAcc, BigDecimal amount) {
        try {
            Connection conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // CHECK FROM ACCOUNT
            String checkFrom = "SELECT status FROM Account WHERE account_id=?";
            PreparedStatement psFrom = conn.prepareStatement(checkFrom);
            psFrom.setInt(1, fromAcc);
            ResultSet rsFrom = psFrom.executeQuery();

            if (!rsFrom.next()) {
                return "Invalid sender account";
            }

            String fromStatus = rsFrom.getString("status");

            if (fromStatus.equalsIgnoreCase("Frozen") || fromStatus.equalsIgnoreCase("Closed")) {
                return "Sender account is Frozen/Closed";
            }

            // CHECK TO ACCOUNT
            String checkTo = "SELECT status FROM Account WHERE account_id=?";
            PreparedStatement psTo = conn.prepareStatement(checkTo);
            psTo.setInt(1, toAcc);
            ResultSet rsTo = psTo.executeQuery();

            if (!rsTo.next()) {
                return "Invalid receiver account";
            }

            String toStatus = rsTo.getString("status");

            if (toStatus.equalsIgnoreCase("Frozen") || toStatus.equalsIgnoreCase("Closed")) {
                return "Receiver account is Frozen/Closed";
            }

            if (fromAcc == toAcc) {
                return "Cannot transfer to the same account";
            }

            String balanceSql = "SELECT balance FROM Account WHERE account_id=?";
            PreparedStatement psBal = conn.prepareStatement(balanceSql);
            psBal.setInt(1, fromAcc);
            ResultSet rsBal = psBal.executeQuery();

            if (rsBal.next()) {
                BigDecimal balance = rsBal.getBigDecimal("balance");

                if (balance.compareTo(amount) < 0) {
                    return "Insufficient balance";
                }
            }

            // DEBIT
            String debit = "UPDATE Account SET balance = balance - ? WHERE account_id=?";
            PreparedStatement ps1 = conn.prepareStatement(debit);
            ps1.setBigDecimal(1, amount);
            ps1.setInt(2, fromAcc);
            ps1.executeUpdate();

            // CREDIT
            String credit = "UPDATE Account SET balance = balance + ? WHERE account_id=?";
            PreparedStatement ps2 = conn.prepareStatement(credit);
            ps2.setBigDecimal(1, amount);
            ps2.setInt(2, toAcc);
            ps2.executeUpdate();

            // SENDER TRANSACTION
            String senderTxn = "INSERT INTO Transactions(account_id, txn_type, amount, txn_date, status, destination_acc) VALUES (?, 'Transfer', ?, NOW(), 'Success', ?)";
            PreparedStatement ps3 = conn.prepareStatement(senderTxn);
            ps3.setInt(1, fromAcc);
            ps3.setBigDecimal(2, amount);
            ps3.setInt(3, toAcc);
            ps3.executeUpdate();

            // RECEIVER TRANSACTION
            String receiverTxn = "INSERT INTO Transactions(account_id, txn_type, amount, txn_date, status, destination_acc) VALUES (?, 'Credit', ?, NOW(), 'Success', ?)";
            PreparedStatement ps4 = conn.prepareStatement(receiverTxn);
            ps4.setInt(1, toAcc);
            ps4.setBigDecimal(2, amount);
            ps4.setInt(3, fromAcc);
            ps4.executeUpdate();

            conn.commit();
            return "SUCCESS";

        } catch (SQLException e) {
            e.printStackTrace();
            return "Transfer failed due to system error";
        }
    }

    public List<Transaction> getTransactionsByAccountId(int accountId){
        List<Transaction> list = new ArrayList<>();
        try{
            Connection conn = DBConnection.getConnection();
            String sql = """
                SELECT t.*
                FROM Transactions t
                JOIN Account a ON t.account_id = a.account_id
                WHERE t.account_id=? AND a.status!='Closed'
                ORDER BY txn_date DESC
            """;

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, accountId);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Transaction txn = new Transaction();
                txn.setTxnId(rs.getInt("txn_id"));
                txn.setAccountId(rs.getInt("account_id"));
                txn.setTxnType(rs.getString("txn_type"));
                txn.setAmount(rs.getBigDecimal("amount"));
                txn.setTxnDate(rs.getTimestamp("txn_date").toLocalDateTime());
                txn.setStatus(rs.getString("status"));
                txn.setDestinationAcc(rs.getInt("destination_acc"));

                list.add(txn);
            }
        }catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public List<Transaction> getAllTransactions(){
        List<Transaction> list = new ArrayList<>();
        try{
            Connection conn = DBConnection.getConnection();

            String sql = """
                SELECT t.*
                FROM Transactions t
                JOIN Account a ON t.account_id = a.account_id
                WHERE a.status!='Closed'
                ORDER BY txn_date DESC
            """;

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Transaction txn = new Transaction();
                txn.setTxnId(rs.getInt("txn_id"));
                txn.setAccountId(rs.getInt("account_id"));
                txn.setTxnType(rs.getString("txn_type"));
                txn.setAmount(rs.getBigDecimal("amount"));
                txn.setTxnDate(rs.getTimestamp("txn_date").toLocalDateTime());
                txn.setStatus(rs.getString("status"));
                txn.setDestinationAcc(rs.getInt("destination_acc"));
                list.add(txn);
            }

        }
        catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }

    public List<Transaction> getTransactionSummary(){
        List<Transaction> list = new ArrayList<>();
        try{
            Connection conn = DBConnection.getConnection();

            String sql = """
            SELECT 
                t.account_id,
                t.txn_type,
                COUNT(t.txn_id) AS total_transactions,
                SUM(t.amount) AS total_amount
            FROM Transactions t
            JOIN Account a ON t.account_id = a.account_id
            WHERE a.status != 'Closed'
            GROUP BY account_id, txn_type
            ORDER BY account_id """;

            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Transaction txn = new Transaction();
                txn.setAccountId(rs.getInt("account_id"));
                txn.setTxnType(rs.getString("txn_type"));
                txn.setAmount(rs.getBigDecimal("total_amount"));
                txn.setTransactionCount(rs.getInt("total_transactions"));
                list.add(txn);
            }

        }catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }

    // Get transaction summary for a specific account
    public List<Transaction> getTransactionSummaryByAccount(int accountId){
        List<Transaction> list = new ArrayList<>();
        try{
            Connection conn = DBConnection.getConnection();

            String sql = """
        SELECT 
            t.account_id,
            t.txn_type,
            COUNT(t.txn_id) AS total_transactions,
            SUM(t.amount) AS total_amount
        FROM Transactions t
        JOIN Account a ON t.account_id = a.account_id
        WHERE a.status != 'Closed' AND t.account_id = ?
        GROUP BY account_id, txn_type
        ORDER BY account_id """;

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, accountId);

            ResultSet rs = ps.executeQuery();

            while(rs.next()){
                Transaction txn = new Transaction();
                txn.setAccountId(rs.getInt("account_id"));
                txn.setTxnType(rs.getString("txn_type"));
                txn.setAmount(rs.getBigDecimal("total_amount"));
                txn.setTransactionCount(rs.getInt("total_transactions"));
                list.add(txn);
            }

        }catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }

    public List<Transaction> getClosedAccountTransactions() {
        List<Transaction> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT t.* FROM Transactions t JOIN Account a ON t.account_id = a.account_id WHERE a.status = 'Closed'";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Transaction t = new Transaction();
                t.setTxnId(rs.getInt("txn_id"));
                t.setAccountId(rs.getInt("account_id"));
                t.setTxnType(rs.getString("txn_type"));
                t.setAmount(rs.getBigDecimal("amount"));
                t.setTxnDate(rs.getTimestamp("txn_date").toLocalDateTime());
                t.setStatus(rs.getString("status"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Transaction> getOpenAccountTransactions() {
        List<Transaction> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT t.* FROM Transactions t JOIN Account a ON t.account_id = a.account_id WHERE a.status != 'Closed'";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Transaction t = new Transaction();
                t.setTxnId(rs.getInt("txn_id"));
                t.setAccountId(rs.getInt("account_id"));
                t.setTxnType(rs.getString("txn_type"));
                t.setAmount(rs.getBigDecimal("amount"));
                t.setTxnDate(rs.getTimestamp("txn_date").toLocalDateTime());
                t.setStatus(rs.getString("status"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Transaction> getTransactionsByAccountAndStatus(int accountId, String status) {
        List<Transaction> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT t.* FROM Transactions t JOIN Account a ON t.account_id = a.account_id WHERE t.account_id=? AND a.status=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, accountId);
            ps.setString(2, status);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Transaction t = new Transaction();
                t.setTxnId(rs.getInt("txn_id"));
                t.setAccountId(rs.getInt("account_id"));
                t.setTxnType(rs.getString("txn_type"));
                t.setAmount(rs.getBigDecimal("amount"));
                t.setTxnDate(rs.getTimestamp("txn_date").toLocalDateTime());
                t.setStatus(rs.getString("status"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Transaction> getTransactionsByAccountAndNotClosed(int accountId) {
        List<Transaction> list = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT t.* FROM Transactions t JOIN Account a ON t.account_id = a.account_id WHERE t.account_id=? AND a.status != 'Closed'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, accountId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Transaction t = new Transaction();
                t.setTxnId(rs.getInt("txn_id"));
                t.setAccountId(rs.getInt("account_id"));
                t.setTxnType(rs.getString("txn_type"));
                t.setAmount(rs.getBigDecimal("amount"));
                t.setTxnDate(rs.getTimestamp("txn_date").toLocalDateTime());
                t.setStatus(rs.getString("status"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}