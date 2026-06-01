package com.ebankdb.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Transaction {

    private int txnId;
    private int accountId;
    private String txnType;
    private BigDecimal amount;
    private LocalDateTime txnDate;
    private String status;
    private Integer destinationAcc;
    private int transactionCount;

    public Transaction() {}

    public int getTxnId() {
        return txnId;
    }

    public void setTxnId(int txnId) {
        this.txnId = txnId;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getTxnType() {
        return txnType;
    }

    public void setTxnType(String txnType) {
        this.txnType = txnType;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public LocalDateTime getTxnDate() {
        return txnDate;
    }

    public void setTxnDate(LocalDateTime txnDate) {
        this.txnDate = txnDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getDestinationAcc() {
        return destinationAcc;
    }

    public void setDestinationAcc(Integer destinationAcc) {
        this.destinationAcc = destinationAcc;
    }

    public int getTransactionCount() {
        return transactionCount;
    }

    public void setTransactionCount(int transactionCount) {
        this.transactionCount = transactionCount;
    }
}